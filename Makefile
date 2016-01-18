PROG=		npfer

ifndef RUMP_ROOT
  $(error RUMP_ROOT is undefined)
endif

RTOOLS_DIR=	$(RUMP_ROOT)/obj-amd64-xen/rumptools
ATOOLS_DIR=	$(RUMP_ROOT)/rumprun/bin
NPF_DIR=   	$(RUMP_ROOT)/src-netbsd/usr.sbin/npf/npfctl
export PATH := $(RTOOLS_DIR):$(ATOOLS_DIR):$(PATH)
_OBJECTS=	npfctl.o npf_var.o npf_data.o npf_build.o npf_extmod.o \
		npf_bpf_comp.o npf_show.o npf_scan.o npf_parse.o
OBJECTS=	$(patsubst %,$(NPF_DIR)/%,$(_OBJECTS))
ARCH=		x86_64-rumprun-netbsd-
RMAKE=		rumpmake
RSTRIP=		$(ARCH)strip
RBAKE=          rumprun-bake
RBAKE_CONF=     npfer-bake.conf
ifeq ($(DANGEROUS),true)
  RBAKE_COMP=   xen_pv_npf_unsafe
else
  RBAKE_COMP=   xen_pv_npf_safe
endif
CC=		$(ARCH)gcc 
LDADD=		-lnpf -lprop -lcrypto -lpcap -lutil -ly

$(PROG): $(PROG).bin
	# Bake $@
	$(RBAKE) -c $(RBAKE_CONF) $(RBAKE_COMP) $@ $@.bin

$(PROG).bin: npfctl
	# Compile $@
	$(CC) -I $(NPF_DIR) -o $@ $(PROG).c $(OBJECTS) $(LDADD)

npfctl.c.orig:
	# Backup npfctl.c
	cp $(NPF_DIR)/npfctl.c $@

npfctl.c.no-main:
	# Comment out main() from local copy
	sed 'N;s/int\s*main\s*/int main/' npfctl.c.orig | \
	awk '/\s*main\s*\(/{f=1}f{$$0="//"$$0}{print}' > $@

.PHONY:	npfctl strip clean

npfctl: npfctl.c.orig npfctl.c.no-main
	# Patch npfctl.c - comment out main()
	cp npfctl.c.no-main $(NPF_DIR)/npfctl.c
	# Compiling npfctl objects
	$(RMAKE) -C ${NPF_DIR} $(OBJECTS)
	# Restore npfctl.c
	cp npfctl.c.orig $(NPF_DIR)/npfctl.c

strip:
	$(RSTRIP) $(PROG) $(PROG).bin

clean:
	(cd ${NPF_DIR} && $(RM) *.o 2>/dev/null || true)
	$(RM) ${PROG} $(PROG).bin npfctl.c.no-main npfctl.c.orig
