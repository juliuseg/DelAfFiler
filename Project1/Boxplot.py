import importlib_resources
import matplotlib.pyplot as plt
from scipy.linalg import svd
import numpy as np
import xlrd


# Load xls sheet with data
filename = 'PowerPlant.xls'
doc = xlrd.open_workbook(filename).sheet_by_index(0)

# Extract attribute names (1st row, column 4 to 12)
attributeNames = doc.row_values(0, 0, 3)


# Preallocate memory, then extract excel data to matrix X
X = np.empty((9500, 4)) # change to 9569 and likewise the one in np.asarray
for i, col_id in enumerate(range(0, 3)):
    X[:, i] = np.asarray(doc.col_values(col_id, 1, 9501))

