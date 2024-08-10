import numpy as np
import pandas as pd

def example_adjacency_matrix(df):
    '''
    This function generates an example adjacency matrix for a given DataFrame, by assuming that all nodes are connected to each other.
    and assigns a weight of 1 to each edge.
    '''
    n = len(df.columns)-1  # Number of rows in the DataFrame
    adj_matrix = np.zeros((n, n))  # Initialize an n x n zero matrix
    
    # Example: Fully connected graph with weights as 1
    for i in range(n):
        for j in range(n):
            if i != j:
                adj_matrix[i][j] = 1
    
    print(adj_matrix)
    print(adj_matrix.shape)
    return adj_matrix

# example usage
df = pd.read_csv('C:/Users/User/Desktop/SCUOLA/UNI/2.Magistrale/TESI/Causal_Inference_for_Multivariate_Time_Series/Code/Python code/real world data/Hybrid file/data/Antivirus_Activity/preprocessed_1.csv')
adj_matrix = example_adjacency_matrix(df)