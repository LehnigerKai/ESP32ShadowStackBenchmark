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
				line = ser.readline().decode("utf-8").strip()
				if line.startswith("Result"):
					return line.split()[-1]
			except UnicodeDecodeError:
				continue

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-p", "--port", type=str)
	parser.add_argument("-e", "--export_file", type=str, help="path to export script to initialize ESP IDF environment")
	parser.add_argument("-r", "--results", type=str, help="file to save results")
	args = parser.parse_args("-r results.txt -p COM5 -e C:\\Espressif\\frameworks\\esp-idf-v5.0\\export.bat".split())

	with open(args.results, "a") as res:
		for bench in ["MD5", "SHA-1", "SHA-256", "SHA-512", "AES-CBC-128", "AES-CBC-192", "AES-CBC-256", "AES-CFB128-128", "AES-CFB128-192", "AES-CFB128-256", "AES-CFB8-128", "AES-CFB8-192", "AES-CFB8-256", "AES-CTR-128", "AES-CTR-192", "AES-CTR-256", "AES-XTS-128", "AES-XTS-256", "AES-GCM-128", "AES-GCM-192", "AES-GCM-256", "AES-CCM-128", "AES-CCM-192", "AES-CCM-256", "AES-CMAC-128", "AES-CMAC-192", "AES-CMAC-256", "AES-CMAC-PRF-128", "ARIA-CBC-128", "ARIA-CBC-192", "ARIA-CBC-256", "CTR_DRBG_(NOPR)", "CTR_DRBG_(PR)", "HMAC_DRBG_SHA-1_(NOPR)", "HMAC_DRBG_SHA-1_(PR)", "HMAC_DRBG_SHA-256_(NOPR)", "HMAC_DRBG_SHA-256_(PR)"]:
			for params in get_test_cases(bench, 10, results=args.results):
				print(params)
				result = benchmark(args.port, args.export_file, params)
				res.write(f"{signature(*params)} {result} |\n")
				res.flush()