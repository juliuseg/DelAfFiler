# exercise 2.1.3
# (requires data structures from ex. 2.2.1)
import importlib_resources
import matplotlib.pyplot as plt
from scipy.linalg import svd
import numpy as np
import xlrd


filename = 'PowerPlant.xls'
doc = xlrd.open_workbook(filename).sheet_by_index(0)

attributeNames = doc.row_values(0, 0, 4)
print(attributeNames)


X = np.empty((9500, 4)) 
for i, col_id in enumerate(range(0, 4)):
    X[:, i] = np.asarray(doc.col_values(col_id, 1, 9501))




N = 9500


Y = X - np.ones((N, 1)) * X.mean(axis=0)

U, S, V = svd(Y, full_matrices=False)

rho = (S * S) / (S * S).sum()




def explained():
    threshold1 = 0.90
    threshold2 = 0.95
    # # Plot variance explained
    plt.figure()
    plt.plot(range(1, len(rho) + 1), rho, "x-")
    plt.plot(range(1, len(rho) + 1), np.cumsum(rho), "o-")
    plt.plot([1, len(rho)], [threshold1, threshold1], "k--")
    plt.plot([1, len(rho)], [threshold2, threshold2], "k--")
    plt.title("Variance explained by principal components")
    plt.xlabel("Principal component")
    plt.ylabel("Variance explained")
    plt.legend(["Individual", "Cumulative", "Threshold"])
    plt.grid()
    plt.show()

def scatter():
    Z = Y.dot(V.T)

    PCA1 = Z[:, 0]
    PCA2 = Z[:, 1]

    # Plot
    plt.figure()
    plt.scatter(PCA1, PCA2)
    plt.title('PCA Scatter Plot')
    plt.xlabel('PCA1')
    plt.ylabel('PCA2')
    plt.grid(True)
    plt.show()

def boxplot(data):

    means = data.mean(axis=0)
    std_devs = data.std(axis=0)

    print(means)
    print(std_devs)
    print(data)

    X_standardized = (data - means) / std_devs
    plt.figure(figsize=(12, 8))  

    plt.boxplot(X_standardized, notch=False, sym='o', vert=True, whis=1.5, patch_artist=False, showmeans=False)

    plt.xticks(ticks=np.arange(1, len(attributeNames) + 1), labels=attributeNames)

    plt.title('Boxplot of Attributes')
    plt.xlabel('Attributes')
    plt.ylabel('Values')

    plt.grid(True)
    plt.show()

def scatterMatrix(data, figsize=(8, 8)):
    num_vars = data.shape[1]
    fig, axes = plt.subplots(nrows=num_vars, ncols=num_vars, figsize=figsize)
    
    for i in range(num_vars):
        for j in range(num_vars):
            ax = axes[i, j]
            if i == j:  # Diagonal: plot a histogram
                ax.hist(data[:, i])
            else:  # Off-diagonal: scatter plot
                ax.scatter(data[:, j], data[:, i], s=1)
            
            # Set labels on the left and bottom plots only
            if i == num_vars - 1:
                ax.set_xlabel(attributeNames[j])
            if j == 0:
                ax.set_ylabel(attributeNames[i])
            
            # Hide labels and ticks when not on the edge
            if i < num_vars - 1:
                ax.xaxis.set_ticklabels([])
            if j > 0:
                ax.yaxis.set_ticklabels([])
    
    plt.tight_layout()
    plt.show()

def scatterMatrixPower(data, figsize=(8, 8)):
    num_vars = 3  # We will only plot the first three attributes
    fig, axes = plt.subplots(nrows=num_vars, ncols=num_vars, figsize=figsize)
    
    # Normalize the fourth attribute to get values between 0 and 1 for color mapping
    color = data[:, 3]
    color_normalized = (color - np.min(color)) / (np.max(color) - np.min(color))
    
    for i in range(num_vars):
        for j in range(num_vars):
            ax = axes[i, j]
            
            scatter = ax.scatter(data[:, j], data[:, i], c=color_normalized, cmap='coolwarm', s=10)
            
            # Set labels for the leftmost and bottom subplots
            if j == 0:
                ax.set_ylabel(f'Attribute {i+1}')
            if i == num_vars - 1:
                ax.set_xlabel(f'Attribute {j+1}')
            
            # Hide labels and ticks when not on the edge
            if i < num_vars - 1:
                ax.xaxis.set_ticklabels([])
            if j > 0:
                ax.yaxis.set_ticklabels([])
    
    # Colorbar for the fourth attribute
    #cbar = fig.colorbar(scatter, ax=axes.ravel().tolist(), orientation='vertical')
    #cbar.set_label('Attribute 4')
    
    plt.tight_layout()
    plt.show()

#explained()
#scatter()
#boxplot(X)
#scatterMatrix(X)
scatterMatrixPower(X)
