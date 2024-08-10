import pandas as pd
import numpy as np

class CustomDatasetLoader:
    '''
    This class is used to load custom datasets from CSV files and store them in a dictionary,
    along with their corresponding ground truth adjacency matrices, which is specified as a NumPy array by the user.
    '''
    def __init__(self, file_path=None, sep=",", header=0, drop_missing=True, drop_columns=None):
        self.file_path = file_path
        self.sep = sep
        self.header = header
        self.dataset_dict = {}
        self.drop_missing = drop_missing
        self.drop_columns = drop_columns

    def load_custom_dataset(self, file_path=None, ground_truth_adj_matrix=None):
        '''
        # Example adjacency matrix
        adj_matrix = [
            [0, 1, 0, 0],  # Node 1 is connected to Node 2
            [1, 0, 1, 0],  # Node 2 is connected to Node 1 and Node 3
            [0, 1, 0, 1],  # Node 3 is connected to Node 2 and Node 4
            [0, 0, 1, 0]   # Node 4 is connected to Node 3
        ]
        '''
        # If file_path is provided in method call, it will override the one passed during initialization
        if file_path is not None:
            self.file_path = file_path
        
        dataset_name = self.file_path.split("/")[-1].split(".")[0]
        data = pd.read_csv(self.file_path, sep=self.sep, header=self.header)

        if self.drop_missing:
            data = data.dropna(axis=1)  # Drop columns with missing values

        if self.drop_columns is not None:
            if isinstance(self.drop_columns, list):
                data = data.drop(columns=self.drop_columns)
            elif isinstance(self.drop_columns, int):
                data = data.drop(data.columns[self.drop_columns], axis=1)

        # Ensure the adjacency matrix is a NumPy array
        if ground_truth_adj_matrix is not None:
            ground_truth_adj_matrix = np.array(ground_truth_adj_matrix)

        # Add the dataset and adjacency matrix to the dictionary
        self.dataset_dict[dataset_name] = (data, ground_truth_adj_matrix)
        return self.dataset_dict

    def analyze_data_structure(self):
        for name, (data, ground_truth_adj_matrix) in self.dataset_dict.items():
            print(f"Dataset: {name}")
            print("Observations DataFrame Head:")
            print(data.head())
            print("\nDataFrame Info:")
            print(data.info())
            print("\nGround Truth Adjacency Matrix:")
            if ground_truth_adj_matrix is not None:
                print(ground_truth_adj_matrix)
            else:
                print("No ground truth adjacency matrix provided.")
            print("\n" + "-"*50 + "\n")

# example usage
import os
os.chdir("C:/Users/User/Desktop/SCUOLA/UNI/2.Magistrale/TESI/Causal_Inference_for_Multivariate_Time_Series/Code/Python code/real world data/Hybrid file")
adj_matrix = [
            [0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,],
            [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,]
        ]
loader = CustomDatasetLoader("data/Antivirus_Activity/preprocessed_1.csv")
data = loader.load_custom_dataset(ground_truth_adj_matrix=adj_matrix)
loader.analyze_data_structure()

# add another dataset to the loader 
loader = CustomDatasetLoader("data/Antivirus_Activity/preprocessed_2.csv")
data = loader.load_custom_dataset(ground_truth_adj_matrix=adj_matrix)
loader.analyze_data_structure()

# show a list of all elements in dataset_dict
print(data)