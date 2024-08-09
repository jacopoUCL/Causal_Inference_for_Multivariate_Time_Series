import pandas as pd
#ciao
class CustomDatasetLoader:
    def __init__(self, file_path, sep=",", header=0, ground_truth_col=None, ground_truth_file=None, drop_missing=True, drop_columns=None):
        self.file_path = file_path
        self.sep = sep
        self.header = header
        self.ground_truth_col = ground_truth_col
        self.ground_truth_file = ground_truth_file
        self.dataset_dict = {}
        self.drop_missing = drop_missing
        self.drop_columns = drop_columns

    def load_custom_dataset(self):
        dataset_name = self.file_path.split("/")[-1].split(".")[0]
        data = pd.read_csv(self.file_path, sep=self.sep, header=self.header)
        ground_truth = None

        if self.ground_truth_col:
            ground_truth = data[self.ground_truth_col].values
            data = data.drop(columns=[self.ground_truth_col])
        elif self.ground_truth_file:
            ground_truth = pd.read_csv(self.ground_truth_file).values.flatten()

        if self.drop_missing:
            data = data.dropna(axis=1) # Drop columns with missing values

        if self.drop_columns is not None:
            if isinstance(self.drop_columns, list):
                data = data.drop(columns=self.drop_columns)
            elif isinstance(self.drop_columns, int):
                data = data.drop(data.columns[self.drop_columns], axis=1)

        self.dataset_dict = {dataset_name: (data, ground_truth)}
        return self.dataset_dict

    def analyze_data_structure(self):
        for name, (data, ground_truth) in self.dataset_dict.items():
            print(f"Dataset: {name}")
            print("Observations DataFrame Head:")
            print(data.head())
            print("\nDataFrame Info:")
            print(data.info())
            print("\nGround Truth:")
            if ground_truth is not None:
                print(ground_truth)
            else:
                print("No ground truth provided.")
            print("\n" + "-"*50 + "\n")



# example usage ########################################################################################################################
# setting the working directory
import os
os.chdir("C:/Users/User/Desktop/SCUOLA/UNI/2.Magistrale/TESI/Causal_Inference_for_Multivariate_Time_Series/Code/Python code/real world data/Hybrid file")


from Custom_Dataset_Loader import CustomDatasetLoader as cdl

loader = cdl(
    file_path="data/Antivirus_Activity/preprocessed_1.csv",    # Path to your dataset file
    sep=",",                         # Separator used in the file, adjust as needed
    header=0,                        # Row number to use as column names
    ground_truth_col=None,            # Name of the ground truth column, if present
    drop_missing=True,
    drop_columns=["timestamp"]       # List of columns to drop from the dataset
)

# Load the dataset eliminating timestamp column using Custom_Data_Loader
loader.load_custom_dataset()

# Analyze the structure of the loaded dataset
loader.analyze_data_structure()
########################################################################################################################################