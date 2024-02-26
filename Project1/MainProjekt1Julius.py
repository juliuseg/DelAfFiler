import importlib_resources
import numpy as np
import pandas as pd
import xlrd
import matplotlib.pyplot as plt


file_path = 'PowerPlant.xls'

powerplant = xlrd.open_workbook(file_path).sheet_by_index(0)

cell_value = powerplant.cell_value(rowx=1, colx=1)  # Example: Read the value of the cell in the first row and column

print(cell_value)


