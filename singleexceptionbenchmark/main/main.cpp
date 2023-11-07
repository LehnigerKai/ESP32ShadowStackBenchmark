#include <iostream>

#include "esp_timer.h"

template<unsigned DEPTH>
__attribute__((noinline)) void do_work(){
    asm("");
    if constexpr(DEPTH > 1){
        do_work<DEPTH-1>();
    }
}

// used by indirect literals
extern "C" unsigned int __shadow_stack_offset = 0;
extern "C" unsigned int __stack_base = 0;
extern "C" unsigned int __shadow_stack_base = 0;

extern "C" void app_main(void)
{
	auto start = esp_timer_get_time();
	for(volatile int i = 0; i < 10000; ++i){
		do_work<8>();
	}
	auto stop = esp_timer_get_time();
	std::cout << "Result: " << (stop-start) << std::endl;

}
