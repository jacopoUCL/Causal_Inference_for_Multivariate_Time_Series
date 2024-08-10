import os
import pandas as pd
import pickle
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

class dataframe_storer:
    def __init__(self, path, output_pickle, folder=False):
        """
        Initializes the CSVProcessor with the given parameters.
        """
        self.path = path
        self.output_pickle = output_pickle
        self.folder = folder
        self.data_dict = {}

    def load_data(self):
        """
        Loads CSV files from the path and stores them in a dictionary.
        """
        if self.folder:
            # Process all CSV files in the specified folder
            for file_name in os.listdir(self.path):
                if file_name.endswith('.csv'):
                    file_path = os.path.join(self.path, file_name)
                    df = pd.read_csv(file_path)
                    self.data_dict[file_name[:-4]] = df
        else:
            # Process a single CSV file
            df = pd.read_csv(self.path)
            file_name = os.path.basename(self.path)[:-4]
            self.data_dict[file_name] = df

        # Print the list of dataset names
        print("Datasets loaded into the dictionary:")
        for name in self.data_dict.keys():
            print(name)
        
        return self.data_dict
    
    def clean_data(self, column_to_remove=None, column_name=None):
        """
        Cleans the datasets in the dictionary, e.g., removing columns with missing values.
        """
        if column_to_remove is not None and column_name is None:
            for name, df in self.data_dict.items():
                # remove columns with missing values
                self.data_dict[name] = df.dropna(axis=1)
                # remove duplicated columns
                self.data_dict[name] = self.data_dict[name].loc[:, ~self.data_dict[name].columns.duplicated()]
                # remove specific columns using its position
                if column_to_remove < len(self.data_dict[name].columns):
                    self.data_dict[name] = self.data_dict[name].drop(self.data_dict[name].columns[column_to_remove], axis=1)
                else:
                    print(f"Column index {column_to_remove} is out of bounds for DataFrame {name}")

        elif column_to_remove is None and column_name is not None:
            for name, df in self.data_dict.items():
                # remove columns with missing values
                self.data_dict[name] = df.dropna(axis=1)
                # remove duplicated columns
                self.data_dict[name] = self.data_dict[name].loc[:, ~self.data_dict[name].columns.duplicated()]
                # remove specific columns using its name
                if column_name in self.data_dict[name].columns:
                    self.data_dict[name] = self.data_dict[name].drop(columns=[column_name])
                else:
                    print(f"Column name '{column_name}' not found in DataFrame {name}")

        elif column_to_remove is not None and column_name is not None:
            print("Please specify only one of column_to_remove or column_name parameters.")

        else:
            for name, df in self.data_dict.items():
                # remove columns with missing values
                self.data_dict[name] = df.dropna(axis=1)
                # remove duplicated columns
                self.data_dict[name] = self.data_dict[name].loc[:, ~self.data_dict[name].columns.duplicated()]

        print("Data cleaned.")
    
    
    def save_data(self):
        """
        Saves the dictionary containing the datasets as a pickle file.
        """
        with open(self.output_pickle, 'wb') as f:
            pickle.dump(self.data_dict, f)
        print(f"Data saved to {self.output_pickle}.")
    
    def analyze_dataset(self, dataset_name):
        """
        Analyzes a specific dataset from the dictionary based on the dataset name.
        """
        if dataset_name in self.data_dict:
            df = self.data_dict[dataset_name]
            # Perform some analysis, e.g., print the first few rows
            print(f"Analyzing dataset: {dataset_name}")
            print("DataFrame head:")
            print(df.head())
            # Add more analysis as needed
        else:
            print(f"Dataset {dataset_name} not found in the dictionary.")

# Example usage:
# set wd
os.chdir('C:/Users/User/Desktop/SCUOLA/UNI/2.Magistrale/TESI/Causal_Inference_for_Multivariate_Time_Series/Code/Python code/real world data/Hybrid file/data/Antivirus_Activity')
processor = dataframe_storer('C:/Users/User/Desktop/SCUOLA/UNI/2.Magistrale/TESI/Causal_Inference_for_Multivariate_Time_Series/Code/Python code/real world data/Hybrid file/data/Antivirus_Activity', 'Antivirus_dataframes.pkl', folder=True)
dfs = processor.load_data()
processor.clean_data(column_to_remove=None, column_name='timestamp')
processor.save_data()
processor.analyze_dataset('preprocessed_1')
processor.analyze_dataset('preprocessed_2')


class DAG_maker:
    '''
    A class to convert a DAG string to an adjacency matrix and plot the graph.
    '''
    def __init__(self):
        self.graph = nx.DiGraph()
    
    def dag_to_adj_matrix(self, dag_str):
        """
        Converts a DAG string in the form 'A->B, A->C->D, D->C' to an adjacency matrix.
        """
        # Split the string into individual paths
        paths = dag_str.split(', ')
        nodes = []
        
        # Collect all unique nodes
        for path in paths:
            nodes.extend(path.split('->'))
        unique_nodes = list(set(nodes))
        
        # Map nodes to indices
        node_indices = {node: i for i, node in enumerate(unique_nodes)}
        n = len(unique_nodes)
        
        # Initialize an adjacency matrix
        adj_matrix = np.zeros((n, n), dtype=int)
        
        # Populate the adjacency matrix for each path
        for path in paths:
            path_nodes = path.split('->')
            for i in range(len(path_nodes) - 1):
                start = node_indices[path_nodes[i]]
                end = node_indices[path_nodes[i+1]]
                adj_matrix[start][end] = 1
                # Add the edge to the graph
                self.graph.add_edge(path_nodes[i], path_nodes[i+1])
        
        return unique_nodes, adj_matrix

    def adj_matrix_to_graph(self, nodes, adj_matrix):
        """
        Converts an adjacency matrix back into a graph.
        """
        self.graph.clear()
        n = len(nodes)
        for i in range(n):
            for j in range(n):
                if adj_matrix[i][j] == 1:
                    self.graph.add_edge(nodes[i], nodes[j])
    
    def plot_graph(self):
        """
        Plots the graph.
        """
        plt.figure(figsize=(8, 6))
        pos = nx.spring_layout(self.graph)
        nx.draw(self.graph, pos, with_labels=True, node_color='skyblue', node_size=2000, 
                edge_color='gray', linewidths=2, font_size=15, font_weight='bold')
        plt.title("DAG Plot", size=20)
        plt.show()

# Example Usage:
processor = DAG_maker()
nodes, adj_matrix = processor.dag_to_adj_matrix('A->B->C->D, A->C, B->D, D->B')
print("Nodes:", nodes)
print("Adjacency Matrix:\n", adj_matrix)
processor.adj_matrix_to_graph(nodes, adj_matrix)
processor.plot_graph()


class NodesNAmeMaker:
    '''
    A class to map the columns of a dataset to capital letters and create a text output.
    '''
    def __init__(self, data_dict):
        """
        Initializes the NodesNAmeMaker with a dictionary of datasets.
        """
        self.data_dict = data_dict
    
    def map_columns(self, dataset_name):
        """
        Maps the columns of the specified dataset to capital letters and creates a text output.
        """
        if dataset_name not in self.data_dict:
            print(f"Dataset '{dataset_name}' not found in the dictionary.")
            return None
        
        df = self.data_dict[dataset_name]
        columns = df.columns
        
        output_lines = []
        for i, column in enumerate(columns):
            letter = self._get_column_letter(i)
            output_lines.append(f"{letter}: {column}")
        
        output_text = "\n".join(output_lines)
        return output_text
    
    def _get_column_letter(self, index):
        """
        Generates a column letter based on the index, supporting more than 26 columns.
        """
        letters = ''
        while index >= 0:
            letters = chr(65 + (index % 26)) + letters
            index = index // 26 - 1
        return letters

    def save_output(self, output_text, file_path):
        """
        Saves the output text to a file.
        """
        with open(file_path, 'w') as file:
            file.write(output_text)
        print(f"Output saved to {file_path}")

# Example Usage:
column_mapper = NodesNAmeMaker(dfs)
output_text = column_mapper.map_columns('preprocessed_2')

if output_text:
    print(output_text)
    # Save the output to a text file
    column_mapper.save_output(output_text, 'nodes_preprocessed_2.txt')
