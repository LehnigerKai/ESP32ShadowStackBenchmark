#include <iostream>

#include "esp_timer.h"
#include "freertos/security.h"
#include "esp_task.h"

template<unsigned DEPTH>
__attribute__((noinline)) void do_work(){
    asm("");
    if constexpr(DEPTH > 1){
        do_work<DEPTH-1>();
    }
}

#if MEASURE_SHADOW_STACK_SIZE
extern "C" uint32_t* main_stack_ptr;
#endif

extern "C" unsigned int __window_counter = 0;

extern "C" void app_main(void)
{
	__attribute__((unused)) __window_counter = 0;
	__attribute__((unused)) auto start = esp_timer_get_time();
	for(volatile int i = 0; i < 10000; ++i){
		do_work<BENCHMARK>();
	}
	__attribute__((unused)) auto stop = esp_timer_get_time();
#if METHOD == METHOD_COUNT
	const volatile auto c = __window_counter;
	std::cout << "Result: " << c << std::endl;
#elif  MEASURE_SHADOW_STACK_SIZE
	// simply count how many words still have default value
	int unused = 5; // skip first bytes, they contain a canary
	while(main_stack_ptr[5] == main_stack_ptr[++unused]);
	// size of total stack - free bytes = total used shadow stack size
	std::cout << "Result: " << (ESP_TASK_MAIN_STACK - unused * 4) << std::endl;
#else
	std::cout << "Result: " << (stop-start) << std::endl;
#endif

}
