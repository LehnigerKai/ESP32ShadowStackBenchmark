import subprocess

def start_run(port, export_file, benchmark, method, storage, privilege):
	"""
	Compiles and flashes a ESP-IDF project with the given parameters.
	
	port: serial port of device
	export_file: path to export.bat or export.sh of ESP-IDF on your system
	params: parametrs for the benchmark @see get_test_cases
	flags: any additional flags you want to provide to your CMAKE build
	"""
	#print(f"{export_file} && idf.py -DSHADOW_STACK_ACCESS={shadow_stack_access} -DSTACK_ACCESS={stack_access} -DUSE_MPU_PROTECTION={'1' if use_mpu else '0'} {' '.join(flags)} build && idf.py -p {port} flash")
	subprocess.run(f"{export_file} && idf.py -DBENCHMARK={benchmark} -DMETHOD={method} -DSTORAGE={storage} -DPRIVILEGED={privilege} build && idf.py -p {port} flash", shell=True)
	
def count_occurence(file, signature):
	count = 0
	with open(file, "r") as f:
		for line in f.readlines():
			if signature in line:
				count += 1
	return count

METHOD = ["METHOD_SHADOW", "METHOD_AREA", "METHOD_COMPRESS", "METHOD_SHADOW_SIZE", "METHOD_AREA_SIZE", "METHOD_COMPRESS_SIZE", "METHOD_COUNT", "METHOD_DEFAULT"]
STORAGE = ["STORAGE_MEMORY", "STORAGE_REG"]
PRIVILEGED = ["PRIVILEGED_OFF", "PRIVILEGED_ON"]

def signature(benchmark, storage, priv, method):
	return f"| {benchmark} | {storage} | {priv} | {method} |"

def get_test_cases(bench, repeats, skip_size=False, results=None):
	"""
	Provide an iterator over possible test cases
	"""
	for p1 in [m for m in METHOD if not skip_size or "SIZE" not in m]:
		for p2 in STORAGE if p1 in METHOD[0:3] else [STORAGE[0]]:
			for p3 in PRIVILEGED if p1 in METHOD[0:3] else [PRIVILEGED[0]]:
				sig = signature(bench, p1,p2,p3)
				for _ in range(repeats - (0 if results == None else count_occurence(results, sig))):
					yield (bench, p1, p2, p3)