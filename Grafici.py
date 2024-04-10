import csv
import json
import os
import re
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.ticker import ScalarFormatter

folder_path = "C:/Users/Antonella/Documents/GitHub/Tesi-Implementazione-SQL/TEST/10INT_TEST"


# Function to convert k-values in numbers
def convert_value(number_of_tuples):
    if 'k' in number_of_tuples.lower():
        return int(float(number_of_tuples.lower().replace('k', '')) * 1000)
    return int(number_of_tuples)


# Function to process files and aggregate data
def process_files(path):
    query_dict = {}

    for filename in os.listdir(path):
        if filename.endswith('.csv'):
            match = re.match(r'(\d+(?:\.\d+)?\s*k?)_(\d+)_(me|im)_(diff|pc)\.csv', filename, re.IGNORECASE)
            if match:
                num_tuple, campionamento, version, operation = match.groups()
                num_tuple = convert_value(num_tuple)
                key = (num_tuple, version.upper(), operation.upper())

                file_path = os.path.join(path, filename)
                with open(file_path, mode='r', encoding='utf-8') as file:
                    reader = csv.reader(file)
                    next(reader)
                    for row in reader:
                        json_file = row[0]
                        json_data = json.loads(json_file)
                        actual_rows = json_data[0]['Plan']['Actual Rows']
                        execution_time = json_data[0]['Execution Time']
                        if key not in query_dict:
                            query_dict[key] = {'execution_times': [None, None, None], 'actual_rows': actual_rows}
                        query_dict[key]['execution_times'][int(campionamento) - 1] = execution_time

    # Calculate average execution time
    for key, value in query_dict.items():
        execution_times = value['execution_times']
        valid_times = [time for time in execution_times if time is not None]
        average_execution_time = round(sum(valid_times) / len(valid_times), 3) if valid_times else None
        query_dict[key]['average_execution_time'] = average_execution_time

    return query_dict


# Function to plot data
def plot_data(plot_dict):
    version_names = {'IM': 'Implicit', 'ME': 'Explicit'}
    operation_names = {'PC': 'Cartesian Product', 'DIFF': 'Difference'}

    execution_time_data = {'Cartesian Product': {'Implicit': [], 'Explicit': []},
                           'Difference': {'Implicit': [], 'Explicit': []}}
    answer_size_data = {'Difference': {'Implicit': [], 'Explicit': []}}

    for key, value in plot_dict.items():
        num_tuples, version, operation = key
        average_time = value['average_execution_time']
        actual_rows = value['actual_rows']
        version_mapped = version_names[version]
        operation_mapped = operation_names[operation]

        if operation_mapped == 'Cartesian Product':
            average_time = average_time / 60000 if average_time is not None else None

        execution_time_data[operation_mapped][version_mapped].append((num_tuples, average_time))

        if operation_mapped == 'Difference':
            answer_size_data[operation_mapped][version_mapped].append((num_tuples, actual_rows))

    # Plotting
    for operation, versions in execution_time_data.items():
        plt.figure(figsize=(9, 8))
        for version, data in versions.items():
            data.sort()
            x, y = zip(*data)
            plt.plot(x, y, label=version, linestyle='-' if version == 'Implicit' else '--',
                     marker='o' if version == 'Implicit' else 's')

        plt.title(f"Average Execution Time for {operation}")
        plt.xlabel("Number of Tuples")
        ylabel = "Average Execution Time (minutes)" if operation == 'Cartesian Product' else "Average Execution Time (milliseconds)"
        plt.ylabel(ylabel)
        plt.legend()
        plt.show()

    plt.figure(figsize=(9, 8))
    for version, data in answer_size_data['Difference'].items():
        data.sort()
        x, y = zip(*data)
        plt.plot(x, y, label=version, linestyle='-' if version == 'Implicit' else '--',
                 marker='o' if version == 'Implicit' else 's')
    plt.title("Answer Size for Difference")
    plt.xlabel("Number of Input Tuples")
    plt.ylabel("Answer Size (number of tuples)")
    plt.legend()
    plt.show()


def extract_tuples(input_string):
    match = re.search(r'DIFF_(\d+k)_(\d+)_', input_string)
    if match:
        return match.group(1)
    else:
        return 'unknown'


def iograph(path, operation):
    data = pd.read_csv(path)
    data['version'] = data['query'].apply(lambda x: 'Implicit' if '_IM' in x else 'Explicit')
    data['total_io_blks'] = data['exec_reads_blks'] + data['exec_writes_blks']
    data['input_tuples'] = data['query'].apply(extract_tuples)
    data['operation'] = data['query'].apply(lambda x: 'Difference' if 'DIFF_' in x else 'Cartesian Product')
    grouped_data = data.groupby(['version', 'input_tuples'])['total_io_blks'].mean().reset_index()

    plt.figure(figsize=(9, 8))

    for version in ['Implicit', 'Explicit']:
        subset = grouped_data[grouped_data['version'] == version].copy()  # Usa .copy() qui
        subset['input_tuples_num'] = subset['input_tuples'].apply(lambda x: int(x[:-1]) * 1000)
        subset.sort_values(by='input_tuples_num', inplace=True)

        plt.plot(subset['input_tuples_num'], subset['total_io_blks'], label=version,
                 marker='o' if version == 'Implicita' else 's', linestyle='-' if version == 'Implicit' else '--')
    formatter = ScalarFormatter(useOffset=False)
    formatter.set_scientific(False)
    plt.gca().xaxis.set_major_formatter(formatter)
    plt.title('IO/Dataset Size  ' + operation)
    plt.xlabel('Number of Input Tuples')
    plt.ylabel('Average I/O Blocks')
    plt.legend()
    plt.show()


iograph("C:/Users/Antonella/Documents/GitHub/Tesi-Implementazione-SQL/TEST/IO_DIFF_10INT.csv", 'Difference')
data_structure = process_files(folder_path)
plot_data(data_structure)
