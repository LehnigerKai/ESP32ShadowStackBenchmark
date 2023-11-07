Modified freertos component for ESP IDF with instrumented window exception handlers.

# How it works

The file containing the window exception handlers `/components/freertos/FreeRTOS-Kernel/portable/xtensa/xtensa_vectors.S` was modified to be extendable using several macros.
The macros are defined inside `/components/freertos/FreeRTOS-Kernel/portable/xtensa/window_instrumentation.S`.
Constants can be used to configure how these macros are defined:

* `SHADOW_STACK_ACCESS`: controls how the shadow stack is accessed.
* `STACK_ACCESS`: controls how the stack is accessed.
* `USE_MPU_PROTECTION`: Simulates MPU protection of the shadow stack

Not all possible configurations make sense!

## Shadow Stack Access

The `SHADOW_STACK_ACCESS` constant controls how the shadow stack is accessed. 
As there is no real shadow stack to be used, the offset is always 0.

Possible values are:

* `NONE`: The shadow stack is not used.
* `CONSTANT`: A constant, encoded in an instruction is used to access the shadow stack.
* `LITERAL_DIRECT`: A literal placed in memory contains the offset to the shadow stack.
* `LITERAL_INDIRECT`: A more realistic implementation of an literal where the literal can be placed far away from the exception handlers to be modifyable by other parts of the program.
* `COMPRESSED_DIRECT`: Implementation of a compressed parallel shadow stack using literals.
* `COMPRESSED_INDIRECT`: Implementation of a compressed parallel shadow stack using literals pointing to variables.
* Add your option to the `shadow_stack_access` list in the `run.py` file if you want to include it in the automated benchmark.

Additionally, the values `COUNT_OVERFLOWS` and `COUNT_UNDERFLOWS` can be used to increment a `__window_counter` variable whenever an overflow or underflow handler is called. While this has nothing to do with a shadow stack it might still give interesting insights for benchmarking.

To add a new access method:

* Add your new value to the list of defined available SHADOW_STACK_ACCESS values in the beginning of the file. Use 2-digit numbers.
* Define the macros `shadow_stack_store` and `shadow_stack_load`.
* If you need to define constants in memory you can do that by defining `USE_SHADOW_STACK_DATA` and define the macro `shadow_stack_data`. Make sure that if you define a constant that you are using `.literal_psition` to place the literal at the correct position.

## Stack Access

The `STACK_ACCESS` constant controls how the stack is accessed for the return address. Possible values are:

* `NONE`: The return address is not placed onto the stack. Only useful when using a shadow stack.
* `REGULAR`: The return address is simply stored and loaded from the stack as with the regular window exception handler.
* `LOAD_AND_COMPARE`: As before, but the return address is loaded into a different register and compared to the value in register a0 afterwards. Only useful when using a shadow stack.

To add a new access method:

* Add your new value to the list of defined available STACK_ACCESS values in the beginning of the file. Use 3-digit numbers.
* Define the macros `stack_store` and `stack_load`.
* Add your option to the `stack_access` list in the `run.py` file if you want to include it in the automated benchmark.

## Additional Configuration Options

* You can use up to two scratch registers a2 and a3. To use them define `SCRATCH_A2` or `SCRATCH_A3`.
* If your get the error `Error: attempt to move .org backwards` this is due to the size restrictions of the exception handlers. You can use the option `LARGE_WINDOW_HANDLERS` to fix that (slight performance penalty).

## USE_MPU_PROTECTION

This does not implemenent any real protection of a shadow stack as there is no real memory area of shadow stacks that could be protected.
It however assumes that the shadow stack area is protected by the ESP32 MPU and access requires the window exception handlers to be executed in privileged mode.
This option adds code that simulates switching back to user mode at the end of the exception handlers. Since the PID switches from 0 to 0, no real change occurs.
The code for switching the PID was taken from Apaches' NuttX project: https://github.com/apache/nuttx

# Automation

the `benchmark.py` script contains two functions that helps with automated benchmarking. `get_test_cases` can be used to provide a list of all avaiable parameter combinations.
`start_run` will compile and flash the application given a set of parameters. The user is responsible to parse the results of their benchmark application.