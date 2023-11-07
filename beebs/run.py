import argparse
import serial
import os
import sys

sys.path.append('..')

from windowhandlerinstrumentation.benchmark import start_run, get_test_cases, STACK_ACCESS, SHADOW_STACK_ACCESS, MPU_ACCESS

def benchmark(port, export_file, params, flags):
	start_run(port, export_file, params, flags)

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
	parser.add_argument("-s", "--skip_irrelevant", action="store_true")
	parser.add_argument("-b", "--benchmarks", nargs="*", help="Select a number BEEBS benchmarks to run", default=[])

	subparsers = parser.add_subparsers(dest="subparser")
	caseparser = subparsers.add_parser("testcase")
	caseparser.add_argument("--shadow_stack_access", "-s", choices=SHADOW_STACK_ACCESS, default=SHADOW_STACK_ACCESS[0])
	caseparser.add_argument("--stack_access", "-a", choices=STACK_ACCESS, default=STACK_ACCESS[1])
	caseparser.add_argument("--mpu_access", "-m", action="store_true")

	args = parser.parse_args()

	with open(args.results, "w") as res:
		for bm in ([d.name for d in os.scandir("main") if d.is_dir()] if len(args.benchmarks) == 0 else args.benchmarks):
			for params in (get_test_cases(args.skip_irrelevant) if args.subparser == None else [(args.shadow_stack_access, args.stack_access, args.mpu_access)]):
				result = benchmark(args.port, args.export_file, params, [f'-DBENCHMARK={bm}'])
				p1, p2, p3 =  *params,
				res.write(f"|{bm}|`{p1}`|`{p2}`| {'yes' if p3 else 'no'} | {result}|\n")
				res.flush()