import statistics
import numpy as np
from tabulate import tabulate

def extract(file, collectors = [statistics.mean, max]):
	with open(file) as f:
		data =np.genfromtxt(f, delimiter="|", dtype="str", autostrip=True)
		data =[((d[1], d[2], d[3], d[4]) , [int(d[5])]) for d in data]
		collected = {d[0]: [] for d in data}
		for k, v in data:
			collected[k] += v
		return [{key : c(val) for key, val in collected.items()} for c in collectors]

class ColumnDescriptor:
	"""
	Abstract base class.

	Contains formatting information for a table column
	"""

	def __init__(self, name, data, col_key):
		"""
		Constructor

		@param name Name of the column
		@param data data that should be presented
		@param col_key key of the column for the data set
		"""
		self.name = name
		self.data = data
		self.col_key = col_key

	def format(self, row):
		"""
		Returns a string for a cell in a table in the given format

		@param row key for the row
		@return string for table cell
		"""
		pass

	def val(self, row):
		"""
		Getter for the value in the cell

		@param row key for the row of the data to get
		@return data of the cell
		"""
		return self.data[(row, *self.col_key)]

class AbsoluteDescriptor(ColumnDescriptor):
	"""
	ColumnDescriptor that formats the data as absolute number
	"""

	def format(self, row):
		return f"{self.val(row):}"


class RelativeDescriptor(ColumnDescriptor):
	"""
	ColumnDescriptor that uses data from another row to scale the data.
	Can be used to show the relative overhead compared to another column.
	"""

	def __init__(self, name, data, col_key, ref_key=("METHOD_DEFAULT", "STORAGE_MEMORY", "PRIVILEGED_OFF")):
		"""
		Constructor

		@param name Name of the column
		@param data data that should be presented
		@param col_key key of the column for the data set
		@param ref_key key that should be used to scale the data
		"""
		super().__init__(name, data, col_key)
		self.ref_key = ref_key

	def val(self, row):
		return self.data[(row, *self.col_key)] / self.data[(row,*self.ref_key)]

	def format(self, row):
		return f"{self.val(row) - 1:+.3%}"

class TableColumnDescriptor(ColumnDescriptor):
	"""
	ColumnDescriptor that shows the absolute number of the data a well as the relative overhead
	of it compared to a reference column in paranthesis behind
	"""

	def __init__(self, name, data, col_key, ref_key):
		super().__init__(name, data, col_key)
		self.f1 = AbsoluteDescriptor(name, data, col_key)
		self.f2 = RelativeDescriptor(name, data, col_key, ref_key)

	def format(self, row):
		return f"{f1.format(row)} ({f2.format(row)})"

def print_data(col_desc, rows, sortby=None):
	"""
	This function is intended to replace to_table and to_graph by offering more flexibility.
	Prints the data according to the given description.

	@param col_desc List of ColumnDescriptor objects
	@param rows List of keys used to identify the data for the rows
	@param sortby Number of column that should be used to sort the table rows
	@return None
	"""
	if type(sortby) is int:
		rows = sorted(rows, key=col_desc[sortby].val, reverse=True)

	out = [[col.format(row) for col in col_desc] for row in rows]
	index = [f"{row}" for row in rows]
	return tabulate(out, tablefmt="plain", headers=["Benchmark"] + [c.name for c in col_desc], showindex=index)

def get_rows(data_set):
	return {key[0] for key in data_set.keys()}

if __name__ == "__main__":
	beebs_means, beebs_maxs = extract("beebs/results.txt")
	coremark_means, coremark_maxs = extract("coremark/results.txt")
	micro_means, micro_maxs = extract("singleexceptionbenchmark/results.txt")
	tls_means, tls_maxs = extract("MbedTLSBenchmark/results.txt")

	means = beebs_means | coremark_means | micro_means | tls_means
	maxs = beebs_maxs | coremark_maxs | micro_maxs | tls_maxs
	rows = get_rows(means)

	with open("data.txt", "w") as out:

		out.write(print_data([
			RelativeDescriptor("RetTimeMemOff", means, ("METHOD_SHADOW", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			RelativeDescriptor("RetTimeMemOn", means, ("METHOD_SHADOW", "STORAGE_MEMORY", "PRIVILEGED_ON")),
			RelativeDescriptor("RetTimeRegOff", means, ("METHOD_SHADOW", "STORAGE_REG", "PRIVILEGED_OFF")),
			RelativeDescriptor("RetTimeRegOn", means, ("METHOD_SHADOW", "STORAGE_REG", "PRIVILEGED_ON")),
			AbsoluteDescriptor("RetSize", maxs, ("METHOD_SHADOW_SIZE", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			RelativeDescriptor("AreaTimeMemOff", means, ("METHOD_AREA", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			RelativeDescriptor("AreaTimeMemOn", means, ("METHOD_AREA", "STORAGE_MEMORY", "PRIVILEGED_ON")),
			RelativeDescriptor("AreaTimeRegOff", means, ("METHOD_AREA", "STORAGE_REG", "PRIVILEGED_OFF")),
			RelativeDescriptor("AreaTimeRegOn", means, ("METHOD_AREA", "STORAGE_REG", "PRIVILEGED_ON")),
			AbsoluteDescriptor("AreaSize", maxs, ("METHOD_AREA_SIZE", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			RelativeDescriptor("CompressTimeMemOff", means, ("METHOD_COMPRESS", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			RelativeDescriptor("CompressTimeMemOn", means, ("METHOD_COMPRESS", "STORAGE_MEMORY", "PRIVILEGED_ON")),
			RelativeDescriptor("CompressTimeRegOff", means, ("METHOD_COMPRESS", "STORAGE_REG", "PRIVILEGED_OFF")),
			RelativeDescriptor("CompressTimeRegOn", means, ("METHOD_COMPRESS", "STORAGE_REG", "PRIVILEGED_ON")),
			AbsoluteDescriptor("CompressSize", maxs, ("METHOD_COMPRESS_SIZE", "STORAGE_MEMORY", "PRIVILEGED_OFF")),
			], rows))
