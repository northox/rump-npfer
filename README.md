# rump-npfer
A Rumprun firewall unikernel for [Qubes OS](//qubes-os.org). See the [blog post](//danny.mantor.org/immutable-tor-firewall-vm/) for the initial anouncement.

# Installation

# Usage
TODO

1. Install ?makefs?
1. Change directory to rump-npfer/dom0/fs/
1. Edit the firewall rules `etc/npf.conf` - see [NetBSD's doc](https://www.netbsd.org/~rmind/npf/) for more info
1. Launch `makefs`
1. Copy the new filesystem iso to dom0
    
    dom0$ qvm-run -p yourvm 'cat /path/to/etc.iso' > etc.iso

# Build
If you wish to build your own rump-firewall (npfer) 

1. Clone and build [rumprun](//github.com/rumpkernel/rumprun).
1. Clone this reporitory.
1. Set RUMP\_ROOT to the base of your working rumprun repository: `export RUMP_ROOT=~/rumprun`
1. Execute `make`.

# Test & debug
Rumprun has a useful (but dangerous) facility that can be used to test and debug our unikernels: rumpctrl and sysproxy. It is to be used in a controlled environment for testing purpose only. To make things safer, by default the Makefile uses `xen_pv_npf_safe` which explicitly disable this capability. To enable it in your binary set `export DANGEROUS=true`, XXXXXXXX, install rumpctrl from a VM connected to your unikernel and read rumpctrl [instructions](http://wiki.rumpkernel.org/rumpctrl/).

```bash
rumpctrl (tcp://10.137.2.34:12345)$ npfctl

# filtering:    active
# config:       loaded

group
        ruleset "test" all
        pass all
rumpctrl (tcp://10.137.2.34:12345)$ ifconfig
lo0: flags=0x8049<UP,LOOPBACK,RUNNING,MULTICAST> mtu 33648
        inet6 ::1 prefixlen 128
        inet6 fe80::1%lo0 prefixlen 64 scopeid 0x1
        inet 127.0.0.1 netmask 0xff000000
xenif0: flags=0x8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        address: 00:16:3e:5e:6c:0b
        inet6 fe80::216:3eff:fe5e:6c0b%xenif0 prefixlen 64 scopeid 0x2
        inet 10.137.2.34 netmask 0xffffff00 broadcast 10.137.2.255
xenif1: flags=0x8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        address: 00:16:3e:53:6c:11
        inet6 fe80::216:3eff:fe53:6c11%xenif1 prefixlen 64 scopeid 0x3
        inet 10.137.102.134 netmask 0xffffff00 broadcast 10.137.102.255
```

# License
MIT

# Source
https://github.com/northox/rump-npfer

# Acknowledgement
All the credit should go to the Rumpkernel project team. Special thanks to [@anttikantee](//github.com/anttikantee)

## Author
Danny Fullerton - Mantor Organization
