# Benchmark collection for shadow stack concept evaluation for the ESP32 microcontroller.

This project contains the following sub-projects:
* windowhandlerinstrumentation: A modified freertos ESP-IDF component that instruments the window overflow und underflow exception handlers.
* beebs: The BEEBS benchmark collection as a ESP-IDF project, based on https://github.com/mageec/beebs.
* coremark: The CoreMark benchmark as a ESP-IDF project, based on https://github.com/eembc/coremark.
* MbedTLS: Benchmark for the MbedTLS library as a ESP-IDF project, based on https://github.com/ARMmbed/mbed-os-example-tls/tree/master/benchmark.
* singleexceptionbenchmark (name outdated): Benchmark of a single recursive function in a loop with configurable call depth.

# Usage

Requirements: ESP-IDF Version 5.0 and an ESP32 development board.

Each directory (with the exception of windowhandlerinstrumentation) contains a benchmark that can be run independant from the other ones, using the modified freerots component.
Every benchmark contains a run.py script that can be used to automatically builds, flashes, and executes all benchmark configurations and saves the results in a file. 
Results for the evaluation can be found in the results.txt for each benchmark.

# Configuration

There are three configuration parameters that can combined with each other.

## METHOD

Different window handler instrumentations and measurements.
By default, time is measured. If a method ends with _SIZE, the size of the shadow stack is measured.
METHOD_COUNT is special as it counts the execution of all window handlers.

- METHOD_DEFAULT: use default handlers
- METHOD_SHADOW(_SIZE): parallel shadow stack
- METHOD_AREA(_SIZE): parallel shadow stack for all register values
- METHOD_COMPRESS(_SIZE): compressed parallel shadow stack

## STORAGE

Offers two options how a method manages its data.
- METHOD_REG: hold data in registers misc2 and misc3
- METHOD_MEMORY: hold data in a global variable

## PRIVILEGED

Toggle if the execution of a window handler should happen in a privileged mode.
This uses the ESP32 PID controller to switch to PID 0 if a window handler occurs.

- PRIVILEGED_ON: enable privileged mode for window handlers
- PRIVILEGED_OFF: disable privileged mode for window handlers
