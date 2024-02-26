import pandas as pd
import matplotlib.pyplot as plt

# Read all sheets into a dictionary of DataFrames
file_path = 'PowerPlant.xls'
xls = pd.ExcelFile(file_path)
sheets = xls.sheet_names  # Get a list of all sheet names in the file

# Print out all sheet names
print("Sheet names:", sheets)

# Load a specific sheet into a DataFrame
# Here we are loading the first sheet, but you can choose another by index or by name
df = pd.read_excel(file_path, sheet_name=sheets[0])  

# Now you can print the first few rows of the DataFrame to inspect the data
print(df.head())

# Create the scatter plot using 'AT' as the x-axis and 'V' as the y-axis
plt.figure(figsize=(10, 8))
plt.scatter(df['AT'], df['PE'], c='blue', alpha=0.5)

# Add labels and title
plt.xlabel('Ambient Temperature (AT)')
plt.ylabel('Power output (PE)')
plt.title('Relationship between Ambient Temperature and Power Output')

# Show the plot
plt.show()