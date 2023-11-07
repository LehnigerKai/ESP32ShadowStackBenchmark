This is the BEEBS benchmark for the ESP32. The original benchmark can be found here: https://github.com/mageec/beebs.
This is not a proper port due to timing constraints.
The benchmark is used to measure security code instrumentation implemented in the windowhandlerinstrumentation submodule.

# Generate CMakeLists.txt for main module

The CMakeLists.txt file for the main component is generatey by the `gen_cmake.py` script based on the subdirectories in the component.
Each subdirectory contains header and sourse files for a specific benchmark. More benchmarks can be added simply by adding another subdirectory and comply to the interface for BEEBS benchmarks.

# Run the benchmark

Use the `run.py` benchmark to run the script.
Due to the large number of benchmarks, there are options to narrow down the selction for benchmarks as well as only run it for a specific security configuration instead of all possible combinations.
All results are printed in a Markdown table format and can be collected in the table below.

## Currently borken benchmarks

* ctl, ctl-stack, ctl-string, ctl-vector
* matmult, matmult-float, matmult-int 
* miniz
* nettle-cast128
* select
* sglib-arrayheapsort, sglib-arrayquicksort, sglib-arraysort, sglib-dllist, sglib-listinsertsort
* trio, trio-snprintf, trio-sscanf

## Recommended parameters

The following shadow stack configurations are recommended:
* `-s NONE -a REGULAR -m False`: No instrumentation happens, regular behaviour. 
* `-s LITERAL_INDIRECT -a LOAD_AND_COMPARE -m`: Parallel shadow stack with integrity check and memory protection
* `-s LITERAL_INDIRECT -a LOAD_AND_COMPARE`: Parallel shadow stack with integrity check without memory protection
* `-s COMPRESSED_INDIRECT -a LOAD_AND_COMPARE -m`: Compressed parallel shadow stack with integrity check and memory protection
* `-s COMPRESSED_INDIRECT -a LOAD_AND_COMPARE`: Compressed parallel shadow stack with integrity check without memory protection

## Create a table

The result in the bottom can be used by `to_table.py` to create a table for Latex documents.
While the script takes no parameters it can easily be modified i.e. for a different output, differnt benchmarks to present or how the results should be sorted.

# Results

|Benchmark|`SHADOW_STACK_ACCESS` | `STACK_ACCESS` | `USE_MPU_PROTECTION` | Result |
|---|---|---|---|---|
|aha-compress|`NONE`|`REGULAR`| no | 509837|
|aha-mont64|`NONE`|`REGULAR`| no | 451616|
|bs|`NONE`|`REGULAR`| no | 3725|
|bubblesort|`NONE`|`REGULAR`| no | 3188311|
|cnt|`NONE`|`REGULAR`| no | 189515|
|compress|`NONE`|`REGULAR`| no | 209112|
|cover|`NONE`|`REGULAR`| no | 267259|
|crc|`NONE`|`REGULAR`| no | 72492|
|crc32|`NONE`|`REGULAR`| no | 1260647|
|cubic|`NONE`|`REGULAR`| no | 11150378|
|dijkstra|`NONE`|`REGULAR`| no | 39463312|
|dtoa|`NONE`|`REGULAR`| no | 261350|
|duff|`NONE`|`REGULAR`| no | 43905|
|edn|`NONE`|`REGULAR`| no | 2552782|
|expint|`NONE`|`REGULAR`| no | 81649|
|fac|`NONE`|`REGULAR`| no | 45821|
|fasta|`NONE`|`REGULAR`| no | 22198281|
|fdct|`NONE`|`REGULAR`| no | 64426|
|fibcall|`NONE`|`REGULAR`| no | 8719|
|fir|`NONE`|`REGULAR`| no | 9840201|
|frac|`NONE`|`REGULAR`| no | 2959815|
|huffbench|`NONE`|`REGULAR`| no | 12383413|
|insertsort|`NONE`|`REGULAR`| no | 38206|
|janne_complex|`NONE`|`REGULAR`| no | 8338|
|jfdctint|`NONE`|`REGULAR`| no | 102746|
|lcdnum|`NONE`|`REGULAR`| no | 9272|
|levenshtein|`NONE`|`REGULAR`| no | 2603681|
|ludcmp|`NONE`|`REGULAR`| no | 145748|
|mergesort|`NONE`|`REGULAR`| no | 16683229|
|minver|`NONE`|`REGULAR`| no | 112031|
|nbody|`NONE`|`REGULAR`| no | 70497743|
|ndes|`NONE`|`REGULAR`| no | 2289203|
|nettle-aes|`NONE`|`REGULAR`| no | 2098213|
|nettle-arcfour|`NONE`|`REGULAR`| no | 447893|
|nettle-des|`NONE`|`REGULAR`| no | 146936|
|nettle-md5|`NONE`|`REGULAR`| no | 37960|
|nettle-sha256|`NONE`|`REGULAR`| no | 235354|
|newlib-exp|`NONE`|`REGULAR`| no | 34621|
|newlib-log|`NONE`|`REGULAR`| no | 28129|
|newlib-mod|`NONE`|`REGULAR`| no | 7467|
|newlib-sqrt|`NONE`|`REGULAR`| no | 57203|
|ns|`NONE`|`REGULAR`| no | 743|
|nsichneu|`NONE`|`REGULAR`| no | 344991|
|picojpeg|`NONE`|`REGULAR`| no | 40204385|
|prime|`NONE`|`REGULAR`| no | 398816|
|qrduino|`NONE`|`REGULAR`| no | 37284530|
|qsort|`NONE`|`REGULAR`| no | 36648|
|qurt|`NONE`|`REGULAR`| no | 281150|
|recursion|`NONE`|`REGULAR`| no | 81409|
|rijndael|`NONE`|`REGULAR`| no | 29135720|
|sglib-arraybinsearch|`NONE`|`REGULAR`| no | 661103|
|sglib-hashtable|`NONE`|`REGULAR`| no | 817801|
|sglib-listsort|`NONE`|`REGULAR`| no | 1110071|
|sglib-queue|`NONE`|`REGULAR`| no | 804339|
|sglib-rbtree|`NONE`|`REGULAR`| no | 2723338|
|slre|`NONE`|`REGULAR`| no | 1631619|
|sqrt|`NONE`|`REGULAR`| no | 26724833|
|st|`NONE`|`REGULAR`| no | 7585066|
|statemate|`NONE`|`REGULAR`| no | 79104|
|stb_perlin|`NONE`|`REGULAR`| no | 4510429|
|stringsearch1|`NONE`|`REGULAR`| no | 397550|
|strstr|`NONE`|`REGULAR`| no | 64320|
|tarai|`NONE`|`REGULAR`| no | 13746|
|ud|`NONE`|`REGULAR`| no | 131517|
|whetstone|`NONE`|`REGULAR`| no | 47494840|
|wikisort|`NONE`|`REGULAR`| no | 68195955|
|aha-compress|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 509904|
|aha-mont64|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 451680|
|bs|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 3724|
|bubblesort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 3188745|
|cnt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 189553|
|compress|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 209147|
|cover|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 267295|
|crc|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 72501|
|crc32|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1260926|
|cubic|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 11151430|
|dijkstra|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 39471039|
|dtoa|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 261408|
|duff|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 43908|
|edn|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2553123|
|expint|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 81660|
|fac|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 76566|
|fasta|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 22197970|
|fdct|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 64435|
|fibcall|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 8720|
|fir|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 9841539|
|frac|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2960412|
|huffbench|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 12385184|
|insertsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 38209|
|janne_complex|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 8341|
|jfdctint|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 102757|
|lcdnum|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 9274|
|levenshtein|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2604038|
|ludcmp|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 145770|
|mergesort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 16695073|
|minver|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 112047|
|nbody|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 70505403|
|ndes|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2289686|
|nettle-aes|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2098645|
|nettle-arcfour|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 447954|
|nettle-des|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 146967|
|nettle-md5|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 37967|
|nettle-sha256|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 235419|
|newlib-exp|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 34626|
|newlib-log|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 28135|
|newlib-mod|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 7468|
|newlib-sqrt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 57211|
|ns|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 743|
|nsichneu|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 345016|
|picojpeg|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 40243222|
|prime|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 398884|
|qrduino|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 37300276|
|qsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 36653|
|qurt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 281219|
|recursion|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 95397|
|rijndael|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 29144856|
|sglib-arraybinsearch|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 661150|
|sglib-hashtable|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 817903|
|sglib-listsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1110151|
|sglib-queue|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 804393|
|sglib-rbtree|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 3050693|
|slre|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1685022|
|sqrt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 26729917|
|st|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 7590423|
|statemate|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 79116|
|stb_perlin|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 4511044|
|stringsearch1|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 397606|
|strstr|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 64328|
|tarai|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 13749|
|ud|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 131533|
|whetstone|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 47489064|
|wikisort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| yes | 68207869|
|aha-compress|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 509866|
|aha-mont64|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 451645|
|bs|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 3725|
|bubblesort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 3188510|
|cnt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 189531|
|compress|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 209126|
|cover|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 267275|
|crc|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 72497|
|crc32|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 1260751|
|cubic|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 11151675|
|dijkstra|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 39469718|
|dtoa|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 261397|
|duff|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 43907|
|edn|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2552938|
|expint|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 81654|
|fac|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 59636|
|fasta|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 22199883|
|fdct|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 64429|
|fibcall|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 8720|
|fir|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 9840808|
|frac|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2960095|
|huffbench|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 12384203|
|insertsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 38207|
|janne_complex|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 8339|
|jfdctint|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 102749|
|lcdnum|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 9273|
|levenshtein|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2603840|
|ludcmp|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 145758|
|mergesort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 16685961|
|minver|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 112037|
|nbody|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 70501880|
|ndes|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2289418|
|nettle-aes|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2098430|
|nettle-arcfour|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 447920|
|nettle-des|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 146950|
|nettle-md5|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 37963|
|nettle-sha256|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 235383|
|newlib-exp|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 34624|
|newlib-log|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 28131|
|newlib-mod|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 7468|
|newlib-sqrt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 57207|
|ns|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 743|
|nsichneu|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 345003|
|picojpeg|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 40223312|
|prime|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 398850|
|qrduino|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 37288227|
|qsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 36649|
|qurt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 281182|
|recursion|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 87699|
|rijndael|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 29140105|
|sglib-arraybinsearch|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 661124|
|sglib-hashtable|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 817852|
|sglib-listsort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 1110106|
|sglib-queue|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 804364|
|sglib-rbtree|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 2870450|
|slre|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 1655623|
|sqrt|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 26727128|
|st|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 7587687|
|statemate|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 79109|
|stb_perlin|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 4510835|
|stringsearch1|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 397575|
|strstr|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 64324|
|tarai|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 13744|
|ud|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 131525|
|whetstone|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 47489341|
|wikisort|`COMPRESSED_INDIRECT`|`LOAD_AND_COMPARE`| no | 68205207|
|aha-compress|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 509888|
|aha-mont64|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 451660|
|bs|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 3725|
|bubblesort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 3188650|
|cnt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 189542|
|compress|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 209141|
|cover|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 267286|
|crc|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 72499|
|crc32|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1260808|
|cubic|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 11148898|
|dijkstra|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 39469769|
|dtoa|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 261406|
|duff|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 43907|
|edn|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2553046|
|expint|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 81658|
|fac|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 69794|
|fasta|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 22199133|
|fdct|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 64433|
|fibcall|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 8720|
|fir|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 9841243|
|frac|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2960260|
|huffbench|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 12384796|
|insertsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 38207|
|janne_complex|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 8341|
|jfdctint|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 102754|
|lcdnum|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 9274|
|levenshtein|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2603961|
|ludcmp|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 145765|
|mergesort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 16687968|
|minver|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 112043|
|nbody|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 70502414|
|ndes|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2289566|
|nettle-aes|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2098542|
|nettle-arcfour|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 447940|
|nettle-des|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 146960|
|nettle-md5|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 37965|
|nettle-sha256|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 235404|
|newlib-exp|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 34626|
|newlib-log|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 28132|
|newlib-mod|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 7468|
|newlib-sqrt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 57209|
|ns|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 743|
|nsichneu|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 345010|
|picojpeg|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 40230940|
|prime|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 398867|
|qrduino|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 37288896|
|qsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 36652|
|qurt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 281205|
|recursion|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 92315|
|rijndael|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 29141779|
|sglib-arraybinsearch|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 661139|
|sglib-hashtable|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 817870|
|sglib-listsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1110137|
|sglib-queue|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 804382|
|sglib-rbtree|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 2978534|
|slre|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 1673304|
|sqrt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 26726908|
|st|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 7586273|
|statemate|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 79114|
|stb_perlin|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 4511016|
|stringsearch1|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 397594|
|strstr|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 64327|
|tarai|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 13749|
|ud|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 131529|
|whetstone|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 47496254|
|wikisort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| yes | 68207227|
|aha-compress|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 509853|
|aha-mont64|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 451629|
|bs|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 3724|
|bubblesort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 3188412|
|cnt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 189523|
|compress|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 209121|
|cover|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 267267|
|crc|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 72493|
|crc32|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 1260703|
|cubic|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 11149136|
|dijkstra|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 39464662|
|dtoa|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 261363|
|duff|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 43906|
|edn|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2552861|
|expint|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 81651|
|fac|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 52866|
|fasta|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 22199062|
|fdct|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 64428|
|fibcall|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 8718|
|fir|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 9840507|
|frac|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2959947|
|huffbench|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 12383821|
|insertsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 38207|
|janne_complex|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 8339|
|jfdctint|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 102748|
|lcdnum|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 9273|
|levenshtein|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2603763|
|ludcmp|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 145753|
|mergesort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 16692267|
|minver|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 112034|
|nbody|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 70498950|
|ndes|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2289310|
|nettle-aes|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2098296|
|nettle-arcfour|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 447907|
|nettle-des|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 146943|
|nettle-md5|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 37962|
|nettle-sha256|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 235369|
|newlib-exp|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 34621|
|newlib-log|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 28128|
|newlib-mod|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 7467|
|newlib-sqrt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 57204|
|ns|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 744|
|nsichneu|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 344997|
|picojpeg|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 40205556|
|prime|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 398832|
|qrduino|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 37290231|
|qsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 36649|
|qurt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 281167|
|recursion|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 84622|
|rijndael|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 29138859|
|sglib-arraybinsearch|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 661115|
|sglib-hashtable|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 817819|
|sglib-listsort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 1110090|
|sglib-queue|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 804351|
|sglib-rbtree|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 2798395|
|slre|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 1643860|
|sqrt|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 26726013|
|st|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 7587336|
|statemate|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 79107|
|stb_perlin|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 4510637|
|stringsearch1|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 397562|
|strstr|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 64321|
|tarai|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 13747|
|ud|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 131521|
|whetstone|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 47487343|
|wikisort|`LITERAL_INDIRECT`|`LOAD_AND_COMPARE`| no | 68192939|
|aha-compress|`LITERAL_INDIRECT`|`NONE`| yes | 509881|
|aha-mont64|`LITERAL_INDIRECT`|`NONE`| yes | 451658|
|bs|`LITERAL_INDIRECT`|`NONE`| yes | 3725|
|bubblesort|`LITERAL_INDIRECT`|`NONE`| yes | 3188617|
|cnt|`LITERAL_INDIRECT`|`NONE`| yes | 189539|
|compress|`LITERAL_INDIRECT`|`NONE`| yes | 209138|
|cover|`LITERAL_INDIRECT`|`NONE`| yes | 267284|
|crc|`LITERAL_INDIRECT`|`NONE`| yes | 72499|
|crc32|`LITERAL_INDIRECT`|`NONE`| yes | 1260853|
|cubic|`LITERAL_INDIRECT`|`NONE`| yes | 11146756|
|dijkstra|`LITERAL_INDIRECT`|`NONE`| yes | 39469379|
|dtoa|`LITERAL_INDIRECT`|`NONE`| yes | 261404|
|duff|`LITERAL_INDIRECT`|`NONE`| yes | 43908|
|edn|`LITERAL_INDIRECT`|`NONE`| yes | 2553025|
|expint|`LITERAL_INDIRECT`|`NONE`| yes | 81657|
|fac|`LITERAL_INDIRECT`|`NONE`| yes | 67533|
|fasta|`LITERAL_INDIRECT`|`NONE`| yes | 22198866|
|fdct|`LITERAL_INDIRECT`|`NONE`| yes | 64431|
|fibcall|`LITERAL_INDIRECT`|`NONE`| yes | 8721|
|fir|`LITERAL_INDIRECT`|`NONE`| yes | 9841147|
|frac|`LITERAL_INDIRECT`|`NONE`| yes | 2960223|
|huffbench|`LITERAL_INDIRECT`|`NONE`| yes | 12384660|
|insertsort|`LITERAL_INDIRECT`|`NONE`| yes | 38208|
|janne_complex|`LITERAL_INDIRECT`|`NONE`| yes | 8340|
|jfdctint|`LITERAL_INDIRECT`|`NONE`| yes | 102752|
|lcdnum|`LITERAL_INDIRECT`|`NONE`| yes | 9273|
|levenshtein|`LITERAL_INDIRECT`|`NONE`| yes | 2603932|
|ludcmp|`LITERAL_INDIRECT`|`NONE`| yes | 145764|
|mergesort|`LITERAL_INDIRECT`|`NONE`| yes | 16681732|
|minver|`LITERAL_INDIRECT`|`NONE`| yes | 112041|
|nbody|`LITERAL_INDIRECT`|`NONE`| yes | 70505270|
|ndes|`LITERAL_INDIRECT`|`NONE`| yes | 2289543|
|nettle-aes|`LITERAL_INDIRECT`|`NONE`| yes | 2098513|
|nettle-arcfour|`LITERAL_INDIRECT`|`NONE`| yes | 447934|
|nettle-des|`LITERAL_INDIRECT`|`NONE`| yes | 146958|
|nettle-md5|`LITERAL_INDIRECT`|`NONE`| yes | 37965|
|nettle-sha256|`LITERAL_INDIRECT`|`NONE`| yes | 235401|
|newlib-exp|`LITERAL_INDIRECT`|`NONE`| yes | 34624|
|newlib-log|`LITERAL_INDIRECT`|`NONE`| yes | 28132|
|newlib-mod|`LITERAL_INDIRECT`|`NONE`| yes | 7469|
|newlib-sqrt|`LITERAL_INDIRECT`|`NONE`| yes | 57208|
|ns|`LITERAL_INDIRECT`|`NONE`| yes | 743|
|nsichneu|`LITERAL_INDIRECT`|`NONE`| yes | 345009|
|picojpeg|`LITERAL_INDIRECT`|`NONE`| yes | 40233309|
|prime|`LITERAL_INDIRECT`|`NONE`| yes | 398859|
|qrduino|`LITERAL_INDIRECT`|`NONE`| yes | 37294047|
|qsort|`LITERAL_INDIRECT`|`NONE`| yes | 36652|
|qurt|`LITERAL_INDIRECT`|`NONE`| yes | 281201|
|recursion|`LITERAL_INDIRECT`|`NONE`| yes | 91290|
|rijndael|`LITERAL_INDIRECT`|`NONE`| yes | 29135655|
|sglib-arraybinsearch|`LITERAL_INDIRECT`|`NONE`| yes | 661136|
|sglib-hashtable|`LITERAL_INDIRECT`|`NONE`| yes | 817866|
|sglib-listsort|`LITERAL_INDIRECT`|`NONE`| yes | 1110126|
|sglib-queue|`LITERAL_INDIRECT`|`NONE`| yes | 804377|
|sglib-rbtree|`LITERAL_INDIRECT`|`NONE`| yes | 2954596|
|slre|`LITERAL_INDIRECT`|`NONE`| yes | 1669454|
|sqrt|`LITERAL_INDIRECT`|`NONE`| yes | 26730348|
|st|`LITERAL_INDIRECT`|`NONE`| yes | 7588081|
|statemate|`LITERAL_INDIRECT`|`NONE`| yes | 79113|
|stb_perlin|`LITERAL_INDIRECT`|`NONE`| yes | 4510868|
|stringsearch1|`LITERAL_INDIRECT`|`NONE`| yes | 397588|
|strstr|`LITERAL_INDIRECT`|`NONE`| yes | 64326|
|tarai|`LITERAL_INDIRECT`|`NONE`| yes | 13749|
|ud|`LITERAL_INDIRECT`|`NONE`| yes | 131529|
|whetstone|`LITERAL_INDIRECT`|`NONE`| yes | 47493715|
|wikisort|`LITERAL_INDIRECT`|`NONE`| yes | 68214060|
|aha-compress|`LITERAL_INDIRECT`|`NONE`| no | 509849|
|aha-mont64|`LITERAL_INDIRECT`|`NONE`| no | 451625|
|bs|`LITERAL_INDIRECT`|`NONE`| no | 3725|
|bubblesort|`LITERAL_INDIRECT`|`NONE`| no | 3188383|
|cnt|`LITERAL_INDIRECT`|`NONE`| no | 189523|
|compress|`LITERAL_INDIRECT`|`NONE`| no | 209119|
|cover|`LITERAL_INDIRECT`|`NONE`| no | 267265|
|crc|`LITERAL_INDIRECT`|`NONE`| no | 72494|
|crc32|`LITERAL_INDIRECT`|`NONE`| no | 1260666|
|cubic|`LITERAL_INDIRECT`|`NONE`| no | 11148935|
|dijkstra|`LITERAL_INDIRECT`|`NONE`| no | 39466150|
|dtoa|`LITERAL_INDIRECT`|`NONE`| no | 261357|
|duff|`LITERAL_INDIRECT`|`NONE`| no | 43905|
|edn|`LITERAL_INDIRECT`|`NONE`| no | 2552838|
|expint|`LITERAL_INDIRECT`|`NONE`| no | 81650|
|fac|`LITERAL_INDIRECT`|`NONE`| no | 50610|
|fasta|`LITERAL_INDIRECT`|`NONE`| no | 22198834|
|fdct|`LITERAL_INDIRECT`|`NONE`| no | 64428|
|fibcall|`LITERAL_INDIRECT`|`NONE`| no | 8719|
|fir|`LITERAL_INDIRECT`|`NONE`| no | 9840409|
|frac|`LITERAL_INDIRECT`|`NONE`| no | 2959909|
|huffbench|`LITERAL_INDIRECT`|`NONE`| no | 12383693|
|insertsort|`LITERAL_INDIRECT`|`NONE`| no | 38207|
|janne_complex|`LITERAL_INDIRECT`|`NONE`| no | 8340|
|jfdctint|`LITERAL_INDIRECT`|`NONE`| no | 102748|
|lcdnum|`LITERAL_INDIRECT`|`NONE`| no | 9273|
|levenshtein|`LITERAL_INDIRECT`|`NONE`| no | 2603736|
|ludcmp|`LITERAL_INDIRECT`|`NONE`| no | 145753|
|mergesort|`LITERAL_INDIRECT`|`NONE`| no | 16695640|
|minver|`LITERAL_INDIRECT`|`NONE`| no | 112034|
|nbody|`LITERAL_INDIRECT`|`NONE`| no | 70499813|
|ndes|`LITERAL_INDIRECT`|`NONE`| no | 2289274|
|nettle-aes|`LITERAL_INDIRECT`|`NONE`| no | 2098282|
|nettle-arcfour|`LITERAL_INDIRECT`|`NONE`| no | 447902|
|nettle-des|`LITERAL_INDIRECT`|`NONE`| no | 146940|
|nettle-md5|`LITERAL_INDIRECT`|`NONE`| no | 37961|
|nettle-sha256|`LITERAL_INDIRECT`|`NONE`| no | 235363|
|newlib-exp|`LITERAL_INDIRECT`|`NONE`| no | 34621|
|newlib-log|`LITERAL_INDIRECT`|`NONE`| no | 28129|
|newlib-mod|`LITERAL_INDIRECT`|`NONE`| no | 7467|
|newlib-sqrt|`LITERAL_INDIRECT`|`NONE`| no | 57204|
|ns|`LITERAL_INDIRECT`|`NONE`| no | 743|
|nsichneu|`LITERAL_INDIRECT`|`NONE`| no | 344995|
|picojpeg|`LITERAL_INDIRECT`|`NONE`| no | 40192481|
|prime|`LITERAL_INDIRECT`|`NONE`| no | 398826|
|qrduino|`LITERAL_INDIRECT`|`NONE`| no | 37287734|
|qsort|`LITERAL_INDIRECT`|`NONE`| no | 36648|
|qurt|`LITERAL_INDIRECT`|`NONE`| no | 281163|
|recursion|`LITERAL_INDIRECT`|`NONE`| no | 83588|
|rijndael|`LITERAL_INDIRECT`|`NONE`| no | 29134650|
|sglib-arraybinsearch|`LITERAL_INDIRECT`|`NONE`| no | 661110|
|sglib-hashtable|`LITERAL_INDIRECT`|`NONE`| no | 817817|
|sglib-listsort|`LITERAL_INDIRECT`|`NONE`| no | 1110083|
|sglib-queue|`LITERAL_INDIRECT`|`NONE`| no | 804348|
|sglib-rbtree|`LITERAL_INDIRECT`|`NONE`| no | 2774373|
|slre|`LITERAL_INDIRECT`|`NONE`| no | 1639941|
|sqrt|`LITERAL_INDIRECT`|`NONE`| no | 26723711|
|st|`LITERAL_INDIRECT`|`NONE`| no | 7585308|
|statemate|`LITERAL_INDIRECT`|`NONE`| no | 79106|
|stb_perlin|`LITERAL_INDIRECT`|`NONE`| no | 4510574|
|stringsearch1|`LITERAL_INDIRECT`|`NONE`| no | 397560|
|strstr|`LITERAL_INDIRECT`|`NONE`| no | 64321|
|tarai|`LITERAL_INDIRECT`|`NONE`| no | 13746|
|ud|`LITERAL_INDIRECT`|`NONE`| no | 131520|
|whetstone|`LITERAL_INDIRECT`|`NONE`| no | 47496267|
|wikisort|`LITERAL_INDIRECT`|`NONE`| no | 68201661|
|aha-compress|`COMPRESSED_INDIRECT`|`NONE`| yes | 509899|
|aha-mont64|`COMPRESSED_INDIRECT`|`NONE`| yes | 451676|
|bs|`COMPRESSED_INDIRECT`|`NONE`| yes | 3725|
|bubblesort|`COMPRESSED_INDIRECT`|`NONE`| yes | 3188728|
|cnt|`COMPRESSED_INDIRECT`|`NONE`| yes | 189554|
|compress|`COMPRESSED_INDIRECT`|`NONE`| yes | 209147|
|cover|`COMPRESSED_INDIRECT`|`NONE`| yes | 267294|
|crc|`COMPRESSED_INDIRECT`|`NONE`| yes | 72500|
|crc32|`COMPRESSED_INDIRECT`|`NONE`| yes | 1260859|
|cubic|`COMPRESSED_INDIRECT`|`NONE`| yes | 11149391|
|dijkstra|`COMPRESSED_INDIRECT`|`NONE`| yes | 39468861|
|dtoa|`COMPRESSED_INDIRECT`|`NONE`| yes | 261408|
|duff|`COMPRESSED_INDIRECT`|`NONE`| yes | 43908|
|edn|`COMPRESSED_INDIRECT`|`NONE`| yes | 2553107|
|expint|`COMPRESSED_INDIRECT`|`NONE`| yes | 81659|
|fac|`COMPRESSED_INDIRECT`|`NONE`| yes | 75155|
|fasta|`COMPRESSED_INDIRECT`|`NONE`| yes | 22201602|
|fdct|`COMPRESSED_INDIRECT`|`NONE`| yes | 64434|
|fibcall|`COMPRESSED_INDIRECT`|`NONE`| yes | 8721|
|fir|`COMPRESSED_INDIRECT`|`NONE`| yes | 9841478|
|frac|`COMPRESSED_INDIRECT`|`NONE`| yes | 2960355|
|huffbench|`COMPRESSED_INDIRECT`|`NONE`| yes | 12385094|
|insertsort|`COMPRESSED_INDIRECT`|`NONE`| yes | 38209|
|janne_complex|`COMPRESSED_INDIRECT`|`NONE`| yes | 8340|
|jfdctint|`COMPRESSED_INDIRECT`|`NONE`| yes | 102755|
|lcdnum|`COMPRESSED_INDIRECT`|`NONE`| yes | 9273|
|levenshtein|`COMPRESSED_INDIRECT`|`NONE`| yes | 2604035|
|ludcmp|`COMPRESSED_INDIRECT`|`NONE`| yes | 145764|
|mergesort|`COMPRESSED_INDIRECT`|`NONE`| yes | 16683293|
|minver|`COMPRESSED_INDIRECT`|`NONE`| yes | 112046|
|nbody|`COMPRESSED_INDIRECT`|`NONE`| yes | 70502926|
|ndes|`COMPRESSED_INDIRECT`|`NONE`| yes | 2289654|
|nettle-aes|`COMPRESSED_INDIRECT`|`NONE`| yes | 2098639|
|nettle-arcfour|`COMPRESSED_INDIRECT`|`NONE`| yes | 447952|
|nettle-des|`COMPRESSED_INDIRECT`|`NONE`| yes | 146965|
|nettle-md5|`COMPRESSED_INDIRECT`|`NONE`| yes | 37966|
|nettle-sha256|`COMPRESSED_INDIRECT`|`NONE`| yes | 235416|
|newlib-exp|`COMPRESSED_INDIRECT`|`NONE`| yes | 34628|
|newlib-log|`COMPRESSED_INDIRECT`|`NONE`| yes | 28134|
|newlib-mod|`COMPRESSED_INDIRECT`|`NONE`| yes | 7469|
|newlib-sqrt|`COMPRESSED_INDIRECT`|`NONE`| yes | 57211|
|ns|`COMPRESSED_INDIRECT`|`NONE`| yes | 743|
|nsichneu|`COMPRESSED_INDIRECT`|`NONE`| yes | 345014|
|picojpeg|`COMPRESSED_INDIRECT`|`NONE`| yes | 40244804|
|prime|`COMPRESSED_INDIRECT`|`NONE`| yes | 398872|
|qrduino|`COMPRESSED_INDIRECT`|`NONE`| yes | 37296034|
|qsort|`COMPRESSED_INDIRECT`|`NONE`| yes | 36651|
|qurt|`COMPRESSED_INDIRECT`|`NONE`| yes | 281217|
|recursion|`COMPRESSED_INDIRECT`|`NONE`| yes | 94756|
|rijndael|`COMPRESSED_INDIRECT`|`NONE`| yes | 29137068|
|sglib-arraybinsearch|`COMPRESSED_INDIRECT`|`NONE`| yes | 661147|
|sglib-hashtable|`COMPRESSED_INDIRECT`|`NONE`| yes | 817897|
|sglib-listsort|`COMPRESSED_INDIRECT`|`NONE`| yes | 1110149|
|sglib-queue|`COMPRESSED_INDIRECT`|`NONE`| yes | 804392|
|sglib-rbtree|`COMPRESSED_INDIRECT`|`NONE`| yes | 3035628|
|slre|`COMPRESSED_INDIRECT`|`NONE`| yes | 1682663|
|sqrt|`COMPRESSED_INDIRECT`|`NONE`| yes | 26731571|
|st|`COMPRESSED_INDIRECT`|`NONE`| yes | 7586561|
|statemate|`COMPRESSED_INDIRECT`|`NONE`| yes | 79114|
|stb_perlin|`COMPRESSED_INDIRECT`|`NONE`| yes | 4511064|
|stringsearch1|`COMPRESSED_INDIRECT`|`NONE`| yes | 397601|
|strstr|`COMPRESSED_INDIRECT`|`NONE`| yes | 64329|
|tarai|`COMPRESSED_INDIRECT`|`NONE`| yes | 13748|
|ud|`COMPRESSED_INDIRECT`|`NONE`| yes | 131531|
|whetstone|`COMPRESSED_INDIRECT`|`NONE`| yes | 47496168|
|wikisort|`COMPRESSED_INDIRECT`|`NONE`| yes | 68211195|
|aha-compress|`COMPRESSED_INDIRECT`|`NONE`| no | 509864|
|aha-mont64|`COMPRESSED_INDIRECT`|`NONE`| no | 451640|
|bs|`COMPRESSED_INDIRECT`|`NONE`| no | 3724|
|bubblesort|`COMPRESSED_INDIRECT`|`NONE`| no | 3188490|
|cnt|`COMPRESSED_INDIRECT`|`NONE`| no | 189530|
|compress|`COMPRESSED_INDIRECT`|`NONE`| no | 209125|
|cover|`COMPRESSED_INDIRECT`|`NONE`| no | 267274|
|crc|`COMPRESSED_INDIRECT`|`NONE`| no | 72496|
|crc32|`COMPRESSED_INDIRECT`|`NONE`| no | 1260739|
|cubic|`COMPRESSED_INDIRECT`|`NONE`| no | 11141996|
|dijkstra|`COMPRESSED_INDIRECT`|`NONE`| no | 39467565|
|dtoa|`COMPRESSED_INDIRECT`|`NONE`| no | 261376|
|duff|`COMPRESSED_INDIRECT`|`NONE`| no | 43907|
|edn|`COMPRESSED_INDIRECT`|`NONE`| no | 2552925|
|expint|`COMPRESSED_INDIRECT`|`NONE`| no | 81653|
|fac|`COMPRESSED_INDIRECT`|`NONE`| no | 58222|
|fasta|`COMPRESSED_INDIRECT`|`NONE`| no | 22195894|
|fdct|`COMPRESSED_INDIRECT`|`NONE`| no | 64429|
|fibcall|`COMPRESSED_INDIRECT`|`NONE`| no | 8719|
|fir|`COMPRESSED_INDIRECT`|`NONE`| no | 9840746|
|frac|`COMPRESSED_INDIRECT`|`NONE`| no | 2960048|
|huffbench|`COMPRESSED_INDIRECT`|`NONE`| no | 12384115|
|insertsort|`COMPRESSED_INDIRECT`|`NONE`| no | 38208|
|janne_complex|`COMPRESSED_INDIRECT`|`NONE`| no | 8340|
|jfdctint|`COMPRESSED_INDIRECT`|`NONE`| no | 102750|
|lcdnum|`COMPRESSED_INDIRECT`|`NONE`| no | 9273|
|levenshtein|`COMPRESSED_INDIRECT`|`NONE`| no | 2603828|
|ludcmp|`COMPRESSED_INDIRECT`|`NONE`| no | 145759|
|mergesort|`COMPRESSED_INDIRECT`|`NONE`| no | 16685704|
|minver|`COMPRESSED_INDIRECT`|`NONE`| no | 112037|
|nbody|`COMPRESSED_INDIRECT`|`NONE`| no | 70499215|
|ndes|`COMPRESSED_INDIRECT`|`NONE`| no | 2289379|
|nettle-aes|`COMPRESSED_INDIRECT`|`NONE`| no | 2098408|
|nettle-arcfour|`COMPRESSED_INDIRECT`|`NONE`| no | 447916|
|nettle-des|`COMPRESSED_INDIRECT`|`NONE`| no | 146949|
|nettle-md5|`COMPRESSED_INDIRECT`|`NONE`| no | 37964|
|nettle-sha256|`COMPRESSED_INDIRECT`|`NONE`| no | 235381|
|newlib-exp|`COMPRESSED_INDIRECT`|`NONE`| no | 34622|
|newlib-log|`COMPRESSED_INDIRECT`|`NONE`| no | 28130|
|newlib-mod|`COMPRESSED_INDIRECT`|`NONE`| no | 7468|
|newlib-sqrt|`COMPRESSED_INDIRECT`|`NONE`| no | 57206|
|ns|`COMPRESSED_INDIRECT`|`NONE`| no | 744|
|nsichneu|`COMPRESSED_INDIRECT`|`NONE`| no | 345002|
|picojpeg|`COMPRESSED_INDIRECT`|`NONE`| no | 40209586|
|prime|`COMPRESSED_INDIRECT`|`NONE`| no | 398839|
|qrduino|`COMPRESSED_INDIRECT`|`NONE`| no | 37289718|
|qsort|`COMPRESSED_INDIRECT`|`NONE`| no | 36650|
|qurt|`COMPRESSED_INDIRECT`|`NONE`| no | 281180|
|recursion|`COMPRESSED_INDIRECT`|`NONE`| no | 87057|
|rijndael|`COMPRESSED_INDIRECT`|`NONE`| no | 29139838|
|sglib-arraybinsearch|`COMPRESSED_INDIRECT`|`NONE`| no | 661123|
|sglib-hashtable|`COMPRESSED_INDIRECT`|`NONE`| no | 817841|
|sglib-listsort|`COMPRESSED_INDIRECT`|`NONE`| no | 1110104|
|sglib-queue|`COMPRESSED_INDIRECT`|`NONE`| no | 804360|
|sglib-rbtree|`COMPRESSED_INDIRECT`|`NONE`| no | 2855460|
|slre|`COMPRESSED_INDIRECT`|`NONE`| no | 1653194|
|sqrt|`COMPRESSED_INDIRECT`|`NONE`| no | 26726849|
|st|`COMPRESSED_INDIRECT`|`NONE`| no | 7587603|
|statemate|`COMPRESSED_INDIRECT`|`NONE`| no | 79109|
|stb_perlin|`COMPRESSED_INDIRECT`|`NONE`| no | 4510836|
|stringsearch1|`COMPRESSED_INDIRECT`|`NONE`| no | 397572|
|strstr|`COMPRESSED_INDIRECT`|`NONE`| no | 64323|
|tarai|`COMPRESSED_INDIRECT`|`NONE`| no | 13745|
|ud|`COMPRESSED_INDIRECT`|`NONE`| no | 131524|
|whetstone|`COMPRESSED_INDIRECT`|`NONE`| no | 47486996|
|wikisort|`COMPRESSED_INDIRECT`|`NONE`| no | 68198920|
|aha-compress|`COUNT_OVERFLOWS`|`REGULAR`| no | 202|
|aha-mont64|`COUNT_OVERFLOWS`|`REGULAR`| no | 184|
|bs|`COUNT_OVERFLOWS`|`REGULAR`| no | 0|
|bubblesort|`COUNT_OVERFLOWS`|`REGULAR`| no | 1274|
|cnt|`COUNT_OVERFLOWS`|`REGULAR`| no | 89|
|compress|`COUNT_OVERFLOWS`|`REGULAR`| no | 90|
|cover|`COUNT_OVERFLOWS`|`REGULAR`| no | 109|
|crc|`COUNT_OVERFLOWS`|`REGULAR`| no | 31|
|crc32|`COUNT_OVERFLOWS`|`REGULAR`| no | 547|
|cubic|`COUNT_OVERFLOWS`|`REGULAR`| no | 6551|
|dijkstra|`COUNT_OVERFLOWS`|`REGULAR`| no | 16428|
|dtoa|`COUNT_OVERFLOWS`|`REGULAR`| no | 123|
|duff|`COUNT_OVERFLOWS`|`REGULAR`| no | 16|
|edn|`COUNT_OVERFLOWS`|`REGULAR`| no | 1011|
|expint|`COUNT_OVERFLOWS`|`REGULAR`| no | 35|
|fac|`COUNT_OVERFLOWS`|`REGULAR`| no | 45082|
|fasta|`COUNT_OVERFLOWS`|`REGULAR`| no | 9632|
|fdct|`COUNT_OVERFLOWS`|`REGULAR`| no | 25|
|fibcall|`COUNT_OVERFLOWS`|`REGULAR`| no | 3|
|fir|`COUNT_OVERFLOWS`|`REGULAR`| no | 3931|
|frac|`COUNT_OVERFLOWS`|`REGULAR`| no | 1417|
|huffbench|`COUNT_OVERFLOWS`|`REGULAR`| no | 5060|
|insertsort|`COUNT_OVERFLOWS`|`REGULAR`| no | 13|
|janne_complex|`COUNT_OVERFLOWS`|`REGULAR`| no | 1|
|jfdctint|`COUNT_OVERFLOWS`|`REGULAR`| no | 37|
|lcdnum|`COUNT_OVERFLOWS`|`REGULAR`| no | 2|
|levenshtein|`COUNT_OVERFLOWS`|`REGULAR`| no | 1063|
|ludcmp|`COUNT_OVERFLOWS`|`REGULAR`| no | 62|
|mergesort|`COUNT_OVERFLOWS`|`REGULAR`| no | 12158|
|minver|`COUNT_OVERFLOWS`|`REGULAR`| no | 47|
|nbody|`COUNT_OVERFLOWS`|`REGULAR`| no | 33512|
|ndes|`COUNT_OVERFLOWS`|`REGULAR`| no | 1143|
|nettle-aes|`COUNT_OVERFLOWS`|`REGULAR`| no | 1046|
|nettle-arcfour|`COUNT_OVERFLOWS`|`REGULAR`| no | 181|
|nettle-des|`COUNT_OVERFLOWS`|`REGULAR`| no | 74|
|nettle-md5|`COUNT_OVERFLOWS`|`REGULAR`| no | 17|
|nettle-sha256|`COUNT_OVERFLOWS`|`REGULAR`| no | 145|
|newlib-exp|`COUNT_OVERFLOWS`|`REGULAR`| no | 17|
|newlib-log|`COUNT_OVERFLOWS`|`REGULAR`| no | 13|
|newlib-mod|`COUNT_OVERFLOWS`|`REGULAR`| no | 2|
|newlib-sqrt|`COUNT_OVERFLOWS`|`REGULAR`| no | 25|
|ns|`COUNT_OVERFLOWS`|`REGULAR`| no | 0|
|nsichneu|`COUNT_OVERFLOWS`|`REGULAR`| no | 106|
|picojpeg|`COUNT_OVERFLOWS`|`REGULAR`| no | 75953|
|prime|`COUNT_OVERFLOWS`|`REGULAR`| no | 168|
|qrduino|`COUNT_OVERFLOWS`|`REGULAR`| no | 19226|
|qsort|`COUNT_OVERFLOWS`|`REGULAR`| no | 17|
|qurt|`COUNT_OVERFLOWS`|`REGULAR`| no | 159|
|recursion|`COUNT_OVERFLOWS`|`REGULAR`| no | 20530|
|rijndael|`COUNT_OVERFLOWS`|`REGULAR`| no | 13778|
|sglib-arraybinsearch|`COUNT_OVERFLOWS`|`REGULAR`| no | 201|
|sglib-hashtable|`COUNT_OVERFLOWS`|`REGULAR`| no | 340|
|sglib-listsort|`COUNT_OVERFLOWS`|`REGULAR`| no | 344|
|sglib-queue|`COUNT_OVERFLOWS`|`REGULAR`| no | 243|
|sglib-rbtree|`COUNT_OVERFLOWS`|`REGULAR`| no | 480311|
|slre|`COUNT_OVERFLOWS`|`REGULAR`| no | 78708|
|sqrt|`COUNT_OVERFLOWS`|`REGULAR`| no | 12841|
|st|`COUNT_OVERFLOWS`|`REGULAR`| no | 3780|
|statemate|`COUNT_OVERFLOWS`|`REGULAR`| no | 30|
|stb_perlin|`COUNT_OVERFLOWS`|`REGULAR`| no | 1992|
|stringsearch1|`COUNT_OVERFLOWS`|`REGULAR`| no | 161|
|strstr|`COUNT_OVERFLOWS`|`REGULAR`| no | 26|
|tarai|`COUNT_OVERFLOWS`|`REGULAR`| no | 7|
|ud|`COUNT_OVERFLOWS`|`REGULAR`| no | 50|
|whetstone|`COUNT_OVERFLOWS`|`REGULAR`| no | 22934|
|wikisort|`COUNT_OVERFLOWS`|`REGULAR`| no | 31147|
