This benchmark contains a minimal example of a chain of empty functions that trigger a single window overflow and a single underflow. The benchmark executes 10000 iterations of this function chain.
The benchmark is used to measure security code instrumentation implemented in the windowhandlerinstrumentation submodule.

|`SHADOW_STACK_ACCESS` | `STACK_ACCESS` | `USE_MPU_PROTECTION` | Result |
|---|---|---|---|
|`NONE`|`REGULAR`| no | 8519|
|`NONE`|`REGULAR`| yes | 12271|
|`CONSTANT`|`NONE`| no | 8644|
|`CONSTANT`|`NONE`| yes | 12398|
|`CONSTANT`|`LOAD_AND_COMPARE`| no | 9146|
|`CONSTANT`|`LOAD_AND_COMPARE`| yes | 12897|
|`LITERAL_DIRECT`|`NONE`| no | 9144|
|`LITERAL_DIRECT`|`NONE`| yes | 12900|
|`LITERAL_DIRECT`|`LOAD_AND_COMPARE`| no | 9646|
|`LITERAL_DIRECT`|`LOAD_AND_COMPARE`| yes | 13396|
|`LITERAL_INDIRECT`|`NONE`| no | 9583|
|`LITERAL_INDIRECT`|`NONE`| yes | 13334|
|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 10085|
|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 13834|
|`COMPRESSED_DIRECT`|`NONE`| no | 10458|
|`COMPRESSED_DIRECT`|`NONE`| yes | 14213|
|`COMPRESSED_DIRECT`|`LOAD_AND_COMPARE`| no | 10959|
|`COMPRESSED_DIRECT`|`LOAD_AND_COMPARE`| yes | 14715|
|`COMPRESSED_INDIRECT`|`NONE`| no | 11270|
|`COMPRESSED_INDIRECT`|`NONE`| yes | 15035|
|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 11587|
|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 15347|

# Run the benchmark

Use the `run.py` benchmark to run the script.