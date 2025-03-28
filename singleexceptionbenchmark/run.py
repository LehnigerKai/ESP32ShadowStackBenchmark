import argparse
import serial
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
	args = parser.parse_args("-p COM5 -r results.txt -e C:\\Espressif\\frameworks\\esp-idf-v5.0\\export.bat".split())

	with open(args.results, "a") as res:
		for bench in range(1,21):
			for params in get_test_cases(bench, 1, results=args.results):
				result = benchmark(args.port, args.export_file, params)
				res.write(f"{signature(*params)} {result} |\n")
				res.flush()