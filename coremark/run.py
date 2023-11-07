import argparse
import serial
import sys

sys.path.append('..')

from windowhandlerinstrumentation.benchmark import start_run, get_test_cases

def benchmark(port, export_file, params):
	start_run(port, export_file, params)

	with serial.Serial(port, 115200) as ser:
		while True:
			try:
				line = ser.readline().decode("utf-8")
				if line.startswith("Total ticks"):
					return line.split()[-1]
			except UnicodeDecodeError:
				continue

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-p", "--port", type=str)
	parser.add_argument("-e", "--export_file", type=str, help="path to export script to initialize ESP IDF environment")
	parser.add_argument("-r", "--results", type=str, help="file to save results")
	parser.add_argument("-s", "--skip_irrelevant", action="store_true")
	args = parser.parse_args()

	with open(args.results, "w") as res:
		for params in get_test_cases(args.skip_irrelevant):
			result = benchmark(args.port, args.export_file, params)
			p1, p2, p3 =  *params,
			res.write(f"|`{p1}`|`{p2}`| {'yes' if p3 else 'no'} | {result}|\n")
			res.flush()