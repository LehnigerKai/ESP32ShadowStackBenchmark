import subprocess

def start_run(port, export_file, params, flags=[]):
    """
    Compiles and flashes a ESP-IDF project with the given parameters.
    
    port: serial port of device
    export_file: path to export.bat or export.sh of ESP-IDF on your system
    params: parametrs for the benchmark @see get_test_cases
    flags: any additional flags you want to provide to your CMAKE build
    """
	shadow_stack_access, stack_access, use_mpu = *params,
	print(f"{export_file} && idf.py -DSHADOW_STACK_ACCESS={shadow_stack_access} -DSTACK_ACCESS={stack_access} -DUSE_MPU_PROTECTION={'1' if use_mpu else '0'} {' '.join(flags)} build && idf.py -p {port} flash")
	subprocess.run(f"{export_file} && idf.py -DSHADOW_STACK_ACCESS={shadow_stack_access} -DSTACK_ACCESS={stack_access} -DUSE_MPU_PROTECTION={'1' if use_mpu else '0'} {' '.join(flags)} build && idf.py -p {port} flash", shell=True)
	
SHADOW_STACK_ACCESS = ["NONE", "CONSTANT", "LITERAL_DIRECT", "LITERAL_INDIRECT", "COMPRESSED_DIRECT", "COMPRESSED_INDIRECT"]
STACK_ACCESS = ["NONE", "REGULAR", "LOAD_AND_COMPARE"]
MPU_ACCESS = [False, True]

def get_test_cases(skip_irrelevant):
    """
    Provide an iterator over possible test cases
    """
	for p1 in SHADOW_STACK_ACCESS:
			for p2 in STACK_ACCESS:
				for p3 in MPU_ACCESS:
					if (p1, p2) in  [("NONE", "NONE"), ("NONE", "LOAD_AND_COMPARE")]:
						continue
					if skip_irrelevant and p1 != "NONE" and p2 == "REGULAR":
						continue
					yield (p1, p2, p3)