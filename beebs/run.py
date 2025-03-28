import argparse
import serial
import os
import sys

sys.path.append('..')

from windowhandlerinstrumentation.benchmark import start_run, get_test_cases, signature

def benchmark(port, export_file, params):
	start_run(port, export_file, *params)

	with serial.Serial(port, 115200) as ser:
		while True:
			try:
				line = ser.readline().decode("utf-8")
				if line.startswith("Result"):
					return line.split()[-1]
			except UnicodeDecodeError:
				continue

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-p", "--port", type=str)
	parser.add_argument("-e", "--export_file", type=str, help="path to export script to initialize ESP IDF environment")
	parser.add_argument("-r", "--results", type=str, help="file to save results")
	parser.add_argument("-b", "--benchmarks", nargs="*", help="Select a number BEEBS benchmarks to run", default=[])


	args = parser.parse_args("-p COM5 -r results.txt -e C:\\Espressif\\frameworks\\esp-idf-v5.0\\export.bat -b aha-compress aha-mont64 bs bubblesort cnt compress cover crc crc32 ctl-stack ctl-string ctl-vector cubic dijkstra dtoa duff edn expint fac fasta fdct fibcall fir frac huffbench insertsort janne_complex jfdctint lcdnum levenshtein ludcmp matmult-float matmult-int mergesort miniz minver nbody ndes nettle-aes nettle-arcfour nettle-cast128 nettle-des nettle-md5 nettle-sha256 newlib-exp newlib-log newlib-mod newlib-sqrt ns nsichneu picojpeg prime qrduino qsort qurt recursion rijndael select sglib-arraybinsearch sglib-hashtable sglib-arrayheapsort sglib-arrayquicksort sglib-dllist sglib-listinsertsort sglib-listsort sglib-queue sglib-rbtree slre sqrt st statemate stb_perlin stringsearch1 strstr tarai trio-snprintf trio-sscanf ud whetstone wikisort".split())

	with open(args.results, "a") as res:
		for bm in args.benchmarks:
			for params in get_test_cases(bm, 10, results=args.results):
				result = benchmark(args.port, args.export_file, params)
				res.write(f"{signature(*params)} {result} |\n")
				res.flush()