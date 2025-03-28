#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

extern int main(int, char**);

void app_main(void)
{

    char *param[] = {"0", "0", "0x66", "2500"};		// These parameters are not taken into account

    main(4,param);

}
