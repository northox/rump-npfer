#include <stdio.h>
#include <stdlib.h>
#include "npfer.h"

int main(int argc, char **argv)
{ 
  printf("Loading firewall rules...\n");
  npfctl(NPFCTL_RELOAD, argc, argv);

  printf("Starting firewall...\n");
  npfctl(NPFCTL_START, argc, argv);

  printf("Sleeping forever.\n");
  for (;;) sleep(1000);

  return 0;
}
