#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

// used by indirect literals
unsigned int __shadow_stack_offset = 0;
unsigned int __stack_base = 0;
unsigned int __shadow_stack_base = 0;

extern int main(int, char**);

void app_main(void)
{

    char *param[] = {"0", "0", "0x66", "2500"};		// These parameters are not taken into account

    main(4,param);

}
