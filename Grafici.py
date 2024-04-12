import csv
import json
import os
import re
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.ticker import ScalarFormatter

operation_types = ['DIFF', 'PC']
versions = ['IM', 'ME']
label_pref = ['1 Preference Level', '3 Preference Level', '5 Preference Level']
label_interval = ['10 Interval Size', '50 Interval Size', '100 Interval Size']

type_interval = {
    '10INT': '10 Interval Size',
    '50INT': '50 Interval Size',
    '100INT': '100 Interval Size',
}

type_pref = {
    '1PREF': '1 Preference Level',
    '10INT': '3 Preference Level',
    '5PREF': '5 Preference Level'
}

result_path = "C:/Users/Antonella/Documents/GitHub/Tesi-Implementazione-SQL/RESULT"
base_path = "C:/Users/Antonella/Documents/GitHub/Tesi-Implementazione-SQL/TEST"


# Function to convert k-values in numbers
def convert_value(number_of_tuples):
    if 'k' in number_of_tuples.lower():
        return int(float(number_of_tuples.lower().replace('k', '')) * 1000)
    return int(number_of_tuples)


# Function to process files and aggregate data
def process_files(path, description_data):
    query_dict = {}

    for filename in os.listdir(path):
        if filename.endswith('.csv'):
            match = re.match(r'(\d+(?:\.\d+)?\s*k?)_(\d+)_(me|im)_(diff|pc)\.csv', filename, re.IGNORECASE)
            if match:
                num_tuple, campionamento, version, operation = match.groups()
                num_tuple = convert_value(num_tuple)
                key = (num_tuple, version.upper(), operation.upper(), description_data.upper())

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
def plot_data(plot_dict, descritption, save_path):
    version_names = {'IM': 'Implicit', 'ME': 'Explicit'}
    operation_names = {'PC': 'Cartesian Product', 'DIFF': 'Difference'}

    execution_time_data = {'Cartesian Product': {'Implicit': [], 'Explicit': []},
                           'Difference': {'Implicit': [], 'Explicit': []}}
    answer_size_data = {'Difference': {'Implicit': [], 'Explicit': []}}
    execution_time_data_diff = {'Difference': {'Implicit': [], 'Explicit': []}}
    for key, value in plot_dict.items():
        num_tuples, version, operation, descritption_data = key
        average_time = value['average_execution_time']
        actual_rows = value['actual_rows']
        version_mapped = version_names[version]
        operation_mapped = operation_names[operation]

        if operation_mapped == 'Cartesian Product':
            average_time = average_time / 60000 if average_time is not None else None

        execution_time_data[operation_mapped][version_mapped].append((num_tuples, average_time))

        if operation_mapped == 'Difference':
            answer_size_data[operation_mapped][version_mapped].append((num_tuples, actual_rows))
            execution_time_data_diff[operation_mapped][version_mapped].append((num_tuples, average_time))

    # Plotting
    if descritption == '100 Interval':
        for operation, versions in execution_time_data_diff.items():
            plt.figure(figsize=(9, 8))
            for version, data in versions.items():
                    data.sort()
                    x, y = zip(*data)
                    plt.plot(x, y, label=version, linestyle='-' if version == 'Implicit' else '--',
                        marker='o' if version == 'Implicit' else 's')

            plt.title(f"Average Execution Time for Difference - {descritption}")
            plt.xlabel("Number of Tuples")
            ylabel = "Average Execution Time (milliseconds)"
            plt.ylabel(ylabel)
            plt.legend()
            plt.savefig(f"{save_path}/Difference")
            plt.close()
    else:
        for operation, versions in execution_time_data.items():
            plt.figure(figsize=(9, 8))
            for version, data in versions.items():
                    data.sort()
                    x, y = zip(*data)
                    plt.plot(x, y, label=version, linestyle='-' if version == 'Implicit' else '--',
                        marker='o' if version == 'Implicit' else 's')

            plt.title(f"Average Execution Time for {operation} - {descritption}")
            plt.xlabel("Number of Tuples")
            ylabel = "Average Execution Time (minutes)" if operation == 'Cartesian Product' else "Average Execution Time (milliseconds)"
            plt.ylabel(ylabel)
            plt.legend()
            plt.savefig(f"{save_path}/{operation}")
            plt.close()


    plt.figure(figsize=(9, 8))
    for version, data in answer_size_data['Difference'].items():
        data.sort()
        x, y = zip(*data)
        plt.plot(x, y, label=version, linestyle='-' if version == 'Implicit' else '--',
                 marker='o' if version == 'Implicit' else 's')
    plt.title(f"Answer Size for Difference {descritption}")
    plt.xlabel("Number of Input Tuples")
    plt.ylabel("Answer Size (number of tuples)")
    plt.legend()
    plt.savefig(f"{save_path}/DIFF_ANSW")
    plt.close()


def extract_tuples(input_string):
    match = re.search(r'_(\d+K?)', input_string.upper())
    if match:
        number = match.group(1).replace('K', '000')
        return int(number)
    else:
        return None


def iograph(path, operation, type_op, save_path):
    data = pd.read_csv(path)
    data['version'] = data['query'].apply(lambda x: 'Implicit' if '_IM' in x else 'Explicit')
    data['total_io_blks'] = data['exec_reads_blks'] + data['exec_writes_blks']
    data['input_tuples'] = data['query'].apply(extract_tuples)
    data['operation'] = data['query'].apply(lambda x: 'Difference' if 'DIFF_' in x else 'Cartesian Product')
    data['type'] = type_op
    data = data.dropna(subset=['input_tuples'])

    grouped_data = data.groupby(['version', 'input_tuples', 'type', 'operation'])['total_io_blks'].mean().reset_index()

    plt.figure(figsize=(9, 8))

    for version in ['Implicit', 'Explicit']:
        subset = grouped_data[grouped_data['version'] == version].copy()
        subset.sort_values(by='input_tuples', inplace=True)

        plt.plot(subset['input_tuples'], subset['total_io_blks'], label=version,
                 marker='o' if version == 'Implicit' else 's', linestyle='-' if version == 'Implicit' else '--')

    formatter = ScalarFormatter(useOffset=False)
    formatter.set_scientific(False)
    plt.gca().xaxis.set_major_formatter(formatter)
    plt.title(f'IO/Dataset Size {operation}')
    plt.xlabel('Number of Input Tuples')
    plt.ylabel('Average I/O Blocks')
    plt.legend()
    plt.savefig(save_path)
    plt.close()

    return grouped_data


def plot_comparison(data_list, labels, operation_types, versions, title_suffix, in_scale, save_path):
    fig, axes = plt.subplots(nrows=len(operation_types), ncols=len(versions), figsize=(15, 10))
    fig.suptitle(f'Comparison of Execution Times by Operation and Version - {title_suffix}')
    operation_labels = {'PC': 'Cartesian Product', 'DIFF': 'Difference'}
    version_labels = {'IM': 'Implicit', 'ME': 'Explicit'}
    limits = {op: {'min': float('inf'), 'max': float('-inf')} for op in operation_types}
    for operation in operation_types:
        for data in data_list:
            for key, value in data.items():
                if key[2].upper() == operation:  # Filtra per operazione
                    current_min = value['average_execution_time']
                    current_max = value['average_execution_time']
                    if current_min < limits[operation]['min']:
                        limits[operation]['min'] = current_min
                    if current_max > limits[operation]['max']:
                        limits[operation]['max'] = current_max
        limits[operation]['min'] -= limits[operation]['min'] * 0.1
        limits[operation]['max'] += limits[operation]['max'] * 0.1
    for i, operation in enumerate(operation_types):
        for j, version in enumerate(versions):
            ax = axes[i][j] if len(operation_types) > 1 else axes[j]
            for data, label in zip(data_list, labels):
                # Filtra i dati per operazione e versione
                filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                 k[2].upper() == operation and k[1].upper() == version]
                if filtered_data:
                    num_tuples, average_execution_time = zip(*sorted(filtered_data))
                    ax.plot(num_tuples, average_execution_time, label=label)
            ax.set_title(f'{version_labels[version]} - {operation_labels[operation]}')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Average Execution Time')
            if in_scale:
                ax.set_ylim(limits[operation]['min'], limits[operation]['max'])  # Applica i limiti per operazione
            ax.legend()

    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()


def plot_io_by_type(df, title, type_labels, in_scale, save_path):
    df.sort_values(by='input_tuples', inplace=True)

    # Definisci l'ordine delle operazioni e delle versioni
    operations = ['Difference', 'Cartesian Product']  # Ordine personalizzato
    versions = df['version'].unique()

    limits = {op: {'min': float('inf'), 'max': float('-inf')} for op in operations}
    for operation in operations:
        operation_subset = df[df['operation'] == operation]
        current_min = operation_subset['total_io_blks'].min()
        current_max = operation_subset['total_io_blks'].max()

        if current_min < limits[operation]['min']:
            limits[operation]['min'] = current_min
        if current_max > limits[operation]['max']:
            limits[operation]['max'] = current_max

    for operation in limits:
        limits[operation]['min'] *= 0.9
        limits[operation]['max'] *= 1.1
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))
    fig.suptitle(title)

    for i, operation in enumerate(operations):
        for j, version in enumerate(versions):
            ax = axes[i, j]
            for t, label in type_labels.items():
                subset = df[(df['operation'] == operation) & (df['version'] == version) & (df['type'] == t)]
                ax.plot(subset['input_tuples'], subset['total_io_blks'], marker='o', label=label)
            if in_scale:
                ax.set_ylim(limits[operation]['min'], limits[operation]['max'])
            ax.set_title(f'{version} - {operation}')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Total IO Blocks')
            ax.legend(title='Type')

    plt.tight_layout()
    plt.savefig(save_path)
    plt.close()



# IO GRAPHS
data_io_diff_10 = iograph(f"{base_path}/IO_DIFF_10INT.csv", 'Difference - 10 Interval', '10INT',
                          f'{result_path}/IO_DIFF_10INT')
data_io_diff_50 = iograph(f"{base_path}/IO_DIFF_50INT.csv", 'Difference - 50 Interval', '50INT',
                          f'{result_path}/IO_DIFF_50INT')
data_io_diff_100 = iograph(f"{base_path}/IO_DIFF_100INT.csv", 'Difference - 100 Interval', '100INT',
                           f'{result_path}/IO_DIFF_100INT')
data_io_diff_1 = iograph(f"{base_path}/IO_DIFF_1PREF.csv", 'Difference - 1 Preference', '1PREF',
                         f'{result_path}/IO_DIFF_1PREF')
data_io_diff_5 = iograph(f"{base_path}/IO_DIFF_5PREF.csv", 'Difference - 5 Preference', '5PREF',
                         f'{result_path}/IO_DIFF_5PREF')
data_io_pc_10 = iograph(f"{base_path}/IO_PC_10INT.csv", 'Cartesian Product - 10 Interval',
                        '10INT', f'{result_path}/IO_PC_10INT')
data_io_pc_50 = iograph(f"{base_path}/IO_PC_50INT.csv", 'Cartesian Product - 50 Interval',
                        '50INT', f'{result_path}/IO_PC_50INT')
data_io_pc_1 = iograph(f"{base_path}/IO_PC_1PREF.csv", 'Cartesian Product - 1 Preference',
                       '1PREF', f'{result_path}/IO_PC_1PREF')
data_io_pc_5 = iograph(f"{base_path}/IO_PC_5PREF.csv", 'Cartesian Product - 5 Preference',
                       '5PREF', f'{result_path}/IO_PC_5PREF')

frames = [data_io_diff_10, data_io_diff_50, data_io_diff_100, data_io_diff_1, data_io_diff_5, data_io_pc_10,
          data_io_pc_50, data_io_pc_1, data_io_pc_5]
df_total_io = pd.concat(frames)
df_total_io = df_total_io[df_total_io['input_tuples'] != 1000000]

# EXECUTION TIME AND ANSWER SIZE
data_structure_10 = process_files(f"{base_path}/10INT_TEST", '10INT')
data_structure_50 = process_files(f"{base_path}/50INT_TEST", '50INT')
data_structure_100 = process_files(f"{base_path}/100INT_TEST", '100INT')
data_structure_1pref = process_files(f"{base_path}/1PREF_TEST", '1PREF')
data_structure_5pref = process_files(f"{base_path}/5PREF_TEST", '5PREF')

plot_data(data_structure_10, '10 Interval', f'{result_path}/EXEC_10INT')
plot_data(data_structure_50, '50 Interval', f'{result_path}/EXEC_50INT')
plot_data(data_structure_100, '100 Interval', f'{result_path}/EXEC_100INT')
plot_data(data_structure_1pref, '1 Preference', f'{result_path}/EXEC_1PREF')
plot_data(data_structure_5pref, '5 Preference', f'{result_path}/EXEC_5PREF')

# COMPARISON EXECUTION TIME
data_pref = [data_structure_1pref, data_structure_10, data_structure_5pref]
data_interval = [data_structure_10, data_structure_50, data_structure_100]
plot_comparison(data_interval, label_interval, operation_types, versions, 'Interval Size', True,
                f'{result_path}/EXEC_INT_INSCALE')
plot_comparison(data_interval, label_interval, operation_types, versions, 'Interval Size', False,
                f'{result_path}/EXEC_INT')
plot_comparison(data_pref, label_pref, operation_types, versions, 'Preference Levels', True,
                f'{result_path}/EXEC_PREF_INSCALE')
plot_comparison(data_pref, label_pref, operation_types, versions, 'Preference Levels', False,
                f'{result_path}/EXEC_PREF')

# COMPARISON IO
plot_io_by_type(df_total_io, 'Comparison of IO Blocks by Interval Size', type_interval, False, f'{result_path}/IO_INT')
plot_io_by_type(df_total_io, 'Comparison of IO Blocks by Interval Size', type_interval, True,
                f'{result_path}/IO_INT_INSCALE')
plot_io_by_type(df_total_io, 'Comparison of IO Blocks by Preference Level', type_pref, False, f'{result_path}/IO_PREF')
plot_io_by_type(df_total_io, 'Comparison of IO Blocks by Preference Level', type_pref, True,
                f'{result_path}/IO_PREF_INSCALE')



