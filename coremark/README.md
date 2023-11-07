# Introduction

This project uses the CoreMark benchmark (https://github.com/eembc/coremark) to measure different overheads of window exception modifications.

Disclaimer: The protection mechanisms are not fully implemented and only contain parts that are necessary to estimate the runtime overhead.

\* not a useful combination

# Running all configurations

The `run.py`script can be used to run all configurations automatically. It creates the table for this README as an output.

# Benchmark results in us

|`SHADOW_STACK_ACCESS` | `STACK_ACCESS` | `USE_MPU_PROTECTION` | Result |
|---|---|---|---|
|`NONE`|`REGULAR`| no | 1364351|
|`NONE`|`REGULAR`| yes | 1364628|
|`CONSTANT`|`NONE`| no | 1364362|
|`CONSTANT`|`NONE`| yes | 1364638|
|`CONSTANT`|`REGULAR`| no | 1364372|
|`CONSTANT`|`REGULAR`| yes | 1364651|
|`CONSTANT`|`LOAD_AND_COMPARE`| no | 1364399|
|`CONSTANT`|`LOAD_AND_COMPARE`| yes | 1364680|
|`LITERAL_DIRECT`|`NONE`| no | 1364396|
|`LITERAL_DIRECT`|`NONE`| yes | 1364687|
|`LITERAL_DIRECT`|`REGULAR`| no | 1364407|
|`LITERAL_DIRECT`|`REGULAR`| yes | 1364690|
|`LITERAL_DIRECT`|`LOAD_AND_COMPARE`| no | 1364434|
|`LITERAL_DIRECT`|`LOAD_AND_COMPARE`| yes | 1364713|
|`LITERAL_INDIRECT`|`NONE`| no | 1364425|
|`LITERAL_INDIRECT`|`NONE`| yes | 1364708|
|`LITERAL_INDIRECT`|`REGULAR`| no | 1364437|
|`LITERAL_INDIRECT`|`REGULAR`| yes | 1364727|
|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 1364467|
|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1364745|
|`COMPRESSED_DIRECT`|`NONE`| no | 1364496|
|`COMPRESSED_DIRECT`|`NONE`| yes | 1364770|
|`COMPRESSED_DIRECT`|`REGULAR`| no | 1364501|
|`COMPRESSED_DIRECT`|`REGULAR`| yes | 1364774|
|`COMPRESSED_DIRECT`|`LOAD_AND_COMPARE`| no | 1364532|
|`COMPRESSED_DIRECT`|`LOAD_AND_COMPARE`| yes | 1364815|
|`COMPRESSED_INDIRECT`|`NONE`| no | 1364560|
|`COMPRESSED_INDIRECT`|`NONE`| yes | 1364850|
|`COMPRESSED_INDIRECT`|`REGULAR`| no | 1364567|
|`COMPRESSED_INDIRECT`|`REGULAR`| yes | 1364842|
|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 1364582|
|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1364862|
