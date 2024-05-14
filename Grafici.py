import csv
import json
import os
import re
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.ticker import ScalarFormatter
from matplotlib.cm import get_cmap

# Ottieni la Tableau Palette
tableau_palette = get_cmap('tab10').colors

# Definisci il dizionario color_dict utilizzando i colori dalla Tableau Palette
color_dict = {'1 Preference Level': tableau_palette[0],
              '3 Preference Levels': tableau_palette[1],
              '5 Preference Levels': tableau_palette[2],
              '10 Preference Levels': tableau_palette[3],
              '10 Interval Size': tableau_palette[0],
              '50 Interval Size': tableau_palette[1],
              '100 Interval Size': tableau_palette[2]}

operation_types = ['DIFF', 'PC']
versions = ['IM', 'ME']
label_pref = ['1 Preference Level', '3 Preference Levels', '5 Preference Levels', '10 Preference Levels', 'No-Time',
              'Exact']
label_interval = ['10 Interval Size', '50 Interval Size', '100 Interval Size', 'No-Time', 'Exact']
temporal_limit = 3600000
type_interval = {
    '10INT': '10 Interval Size',
    '50INT': '50 Interval Size',
    '100INT': '100 Interval Size',
}

type_pref = {
    '1PREF': '1 Preference Level',
    '10INT': '3 Preference Levels',
    '5PREF': '5 Preference Levels',
    '10PREF': '10 Preference Levels'
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
            match = re.match(r'(\d+(?:\.\d+)?\s*k?)_(\d+)_(me|im|nt|ts)_(diff|pc)\.csv', filename, re.IGNORECASE)
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
    version_names = {'IM': 'Pyramid', 'ME': 'Explicit'}
    operation_names = {'PC': 'Cartesian Product', 'DIFF': 'Difference'}

    execution_time_data = {'Cartesian Product': {'Pyramid': [], 'Explicit': []},
                           'Difference': {'Pyramid': [], 'Explicit': []}}
    answer_size_data = {'Difference': {'Pyramid': [], 'Explicit': []}}
    execution_time_data_diff = {'Difference': {'Pyramid': [], 'Explicit': []}}
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
                plt.plot(x, y, label=version, linestyle='-' if version == 'Pyramid' else '--',
                         marker='o' if version == 'Pyramid' else 's')

            plt.title(f"Average Execution Time for Difference - {descritption}")
            plt.xlabel("Number of Tuples")
            ylabel = "Average Execution Time (milliseconds)"
            plt.ylabel(ylabel)
            plt.legend()
            plt.savefig(f"{save_path}/Difference.svg")
            plt.close()
    else:
        for operation, versions in execution_time_data.items():
            plt.figure(figsize=(9, 8))
            for version, data in versions.items():
                data.sort()
                x, y = zip(*data)
                plt.plot(x, y, label=version, linestyle='-' if version == 'Pyramid' else '--',
                         marker='o' if version == 'Pyramid' else 's')
            if descritption == '50INT' and operation == 'Cartesian Product':
                plt.axhline(y=temporal_limit, color='black', linestyle='dotted', label='Test Ends')
            plt.title(f"Average Execution Time for {operation} - {descritption}")
            plt.xlabel("Number of Tuples")
            ylabel = "Average Execution Time (minutes)" if operation == 'Cartesian Product' else "Average Execution Time (milliseconds)"
            plt.ylabel(ylabel)
            plt.legend()
            plt.savefig(f"{save_path}/{operation}.svg")
            plt.close()

    plt.figure(figsize=(9, 8))
    for version, data in answer_size_data['Difference'].items():
        data.sort()
        x, y = zip(*data)
        plt.plot(x, y, label=version, linestyle='-' if version == 'Pyramid' else '--',
                 marker='o' if version == 'Pyramid' else 's')
    plt.title(f"Answer Size for Difference {descritption}")
    plt.xlabel("Number of Input Tuples")
    plt.ylabel("Answer Size (number of tuples)")
    plt.legend()
    plt.savefig(f"{save_path}/DIFF_ANSW.svg")
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
    data['version'] = data['query'].apply(lambda x: 'Pyramid' if '_IM' in x else 'Explicit')
    data['total_io_blks'] = data['exec_reads_blks'] + data['exec_writes_blks']
    data['input_tuples'] = data['query'].apply(extract_tuples)
    data['operation'] = data['query'].apply(lambda x: 'Difference' if 'DIFF_' in x else 'Cartesian Product')
    if type_op == 'NT' or type_op == 'TS':
        data['version'] = type_op
        data['type'] = type_op
    else:
        data['type'] = type_op
    data = data.dropna(subset=['input_tuples'])

    grouped_data = data.groupby(['version', 'input_tuples', 'type', 'operation'])['total_io_blks'].mean().reset_index()

    plt.figure(figsize=(9, 8))

    for version in ['Pyramid', 'Explicit']:
        subset = grouped_data[grouped_data['version'] == version].copy()
        subset.sort_values(by='input_tuples', inplace=True)

        plt.plot(subset['input_tuples'], subset['total_io_blks'], label=version,
                 marker='o' if version == 'Pyramid' else 's', linestyle='-' if version == 'Pyramid' else '--')

    formatter = ScalarFormatter(useOffset=False)
    formatter.set_scientific(False)
    plt.gca().xaxis.set_major_formatter(formatter)
    plt.title(f'IO/Dataset Size {operation}')
    plt.xlabel('Number of Input Tuples')
    plt.ylabel('Average I/O Blocks')
    plt.legend()
    plt.savefig(f"{save_path}.svg")
    plt.close()

    return grouped_data


def plot_comparison(data_list, labels, operation_types, versions, title_suffix, in_scale, save_path):
    version_names = {'IM': 'Pyramid', 'ME': 'Explicit', 'TS': 'Exact', 'NT': 'No-Time'}
    operation_names = {'PC': 'Cartesian Product', 'DIFF': 'Difference'}

    fig, axes = plt.subplots(nrows=len(operation_types), ncols=len(versions), figsize=(15, 10))
    fig.suptitle(f'Comparison of Execution Times by Operation and Version - {title_suffix}')

    limits = {op: {'min': float('inf'), 'max': float('-inf')} for op in operation_types}

    for operation in operation_types:
        for data in data_list:
            for key, value in data.items():
                if key[2].upper() == operation:
                    current_min = value['average_execution_time']
                    current_max = value['average_execution_time']
                    if current_min < limits[operation]['min']:
                        limits[operation]['min'] = current_min
                    if current_max > limits[operation]['max']:
                        limits[operation]['max'] = current_max
        limits[operation]['min'] -= limits[operation]['min'] * 0.1
        limits[operation]['max'] += limits[operation]['max'] * 0.1

    # Generate plots
    for i, operation in enumerate(operation_types):
        for j, version in enumerate(versions):
            ax = axes[i][j] if len(operation_types) > 1 else axes[j]
            for data, label in zip(data_list, labels):
                filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                 k[2].upper() == operation and k[1].upper() == version]
                if filtered_data:
                    num_tuples, average_execution_time = zip(*sorted(filtered_data))
                    if operation == 'PC':
                        average_execution_time = tuple(x / 60000 for x in average_execution_time)
                    ax.plot(num_tuples, average_execution_time, label=label, marker='o', linestyle='-')
            if version == 'ME' and operation == 'PC' and labels == label_interval:
                ax.axhline(y=temporal_limit / 60000, color='black', linestyle='dotted', label='Test Ends')
            ax.set_title(f'{version_names[version]} - {operation_names[operation]}')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Average Execution Time (ms)' if operation == 'DIFF' else 'Average Execution Time (minutes)')
            if in_scale:
                ax.set_ylim(limits[operation]['min'],
                            limits[operation]['max'])
            ax.legend()

    plt.tight_layout()
    plt.savefig(f'{save_path}.svg')
    plt.close()

    if not in_scale and title_suffix == 'Preference Levels':
        for operation in operation_types:
            plt.figure(figsize=(5, 4))
            versioni = ['IM', 'ME', 'TS', 'NT']
            for version in versioni:
                if version in ['IM']:
                    for data, label in zip(data_list, labels):
                        if label != '1 Preference Level':
                            filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                             k[2].upper() == operation and k[1].upper() == version]
                            if filtered_data:
                                num_tuples, average_execution_time = zip(*sorted(filtered_data))
                                plt.plot(num_tuples, average_execution_time,
                                         label=f'{label} Pyramid' if versioni == 'IM' else f'{label}', marker='o')
            plt.xlabel('Number of Tuples')
            plt.ylabel('Average Execution Time (ms)')
            plt.tight_layout()
            plt.legend(title='Pyramid:')
            plt.savefig(f'{save_path}_{operation}.svg')
            plt.close()
    if in_scale:
        # Loop through each operation
        for i, operation in enumerate(operation_types):
            fig, ax = plt.subplots(figsize=(7.5, 5))
            versioni = ['IM', 'ME', 'TS', 'NT']
            for version in versioni:
                if version in ['IM', 'ME']:
                    for data, label in zip(data_list, labels):
                        if label != '1 Preference Level':
                            filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                             k[2].upper() == operation and k[1].upper() == version]
                            if filtered_data:
                                num_tuples, average_execution_time = zip(*sorted(filtered_data, reverse=True))
                                if operation == 'PC':
                                    average_execution_time = tuple(x / 60000 for x in average_execution_time)
                                if label == 'TSQL2' or label == 'Non Temporal':
                                    ax.plot(num_tuples, average_execution_time, label=f'{version_names[version]}',
                                            linestyle='--' if version == 'TS' else (
                                                'dotted' if version == 'NT' else '-'),
                                            marker='o')
                                else:
                                    ax.plot(num_tuples, average_execution_time,
                                            label=f'{version_names[version]} : {label} ',
                                            linestyle='--' if version == 'ME' else '-',
                                            marker='o' if version == 'IM' else 's', color=color_dict[label])
            if operation == 'PC' and labels == label_interval:
                plt.axhline(y=temporal_limit / 60000, color='black', linestyle='dotted', label='Test Ends')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Average Execution Time (ms)' if operation == 'DIFF' else 'Average Execution Time (minutes)')
            ax.legend()

            plt.tight_layout()
            plt.savefig(f'{save_path}_{i}_3.svg')
            plt.close()

        if in_scale:
            # Loop through each operation
            for i, operation in enumerate(operation_types):
                fig, ax = plt.subplots(figsize=(7.5, 5))
                versioni = ['IM', 'ME', 'TS', 'NT']
                for version in versioni:
                    if version in ['IM', 'TS', 'NT']:
                        for data, label in zip(data_list, labels):
                            filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                             k[2].upper() == operation and k[1].upper() == version]
                            if filtered_data:
                                num_tuples, average_execution_time = zip(*sorted(filtered_data))

                                if version != 'TS' and version != 'NT':
                                    if label == '3 Preference Levels':
                                        ax.plot(num_tuples, average_execution_time,
                                                label='Pyramid',
                                                linestyle='--' if version == 'ME' else '-',
                                                marker='o' if version == 'IM' else 's', color=color_dict[label])
                        for data, label in zip(data_list, labels):
                            filtered_data = [(k[0], v['average_execution_time']) for k, v in data.items() if
                                             k[2].upper() == operation and k[1].upper() == version]
                            if filtered_data:
                                num_tuples, average_execution_time = zip(*sorted(filtered_data))

                                if version != 'TS' and version != 'NT':
                                    if label == '1 Preference Level':
                                        ax.plot(num_tuples, average_execution_time,
                                                label='Indet',
                                                linestyle='--' if version == 'ME' else '-',
                                                marker='o' if version == 'IM' else 's', color=color_dict[label])
                                else:
                                    ax.plot(num_tuples, average_execution_time, label=f'{version_names[version]}',
                                            linestyle='--' if version == 'TS' else (
                                                'dotted' if version == 'NT' else '-'),
                                            marker='o', color='#8a64bc' if version == 'TS' else '#7c5247')
                ax.set_xlabel('Number of Tuples')
                ax.set_ylabel(
                    'Average Execution Time (ms)')
                ax.legend()

                plt.tight_layout()
                plt.savefig(f'{save_path}_{i}_2.svg')
                plt.close()


def plot_io_by_type(df, title, type_labels, in_scale, save_path):
    df.sort_values(by='input_tuples', inplace=True)

    df_copy = df[~(df['version'].isin(['NT', 'TS']))]
    operations = ['Difference', 'Cartesian Product']
    versions = df_copy['version'].unique()

    fig, axes = plt.subplots(len(operations), len(versions),
                             figsize=(15, 10))
    fig.suptitle(title)

    limits = {op: {'min': float('inf'), 'max': float('-inf')} for op in operations}
    for operation in operations:
        operation_subset = df_copy[df_copy['operation'] == operation]
        current_min = operation_subset['total_io_blks'].min()
        current_max = operation_subset['total_io_blks'].max()
        limits[operation]['min'] = min(limits[operation]['min'], current_min)
        limits[operation]['max'] = max(limits[operation]['max'], current_max)
        limits[operation]['min'] *= 0.9
        limits[operation]['max'] *= 1.1

    for i, operation in enumerate(operations):
        for j, version in enumerate(versions):
            ax = axes[i][j]
            for t, label in type_labels.items():
                subset = df_copy[
                    (df_copy['operation'] == operation) & (df_copy['version'] == version) & (df_copy['type'] == t)]
                ax.plot(subset['input_tuples'], subset['total_io_blks'], marker='o', label=label)
            if version == 'Explicit' and operation == 'Cartesian Product' and type_labels == type_interval:
                ax.axhline(y=180000, color='black', linestyle='dotted', label='Test Ends')
            ax.set_title(f'{version} - {operation}')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Total IO Blocks')
            ax.legend(title='Type')
            if False:
                ax.set_ylim(limits[operation]['min'], limits[operation]['max'])

    plt.tight_layout()
    plt.savefig(f"{save_path}.svg")
    plt.close()
    if not in_scale and title == 'Comparison of IO Blocks by Preference Level':
        for operation in operations:
            for version in versions:
                if version == 'Pyramid':
                    fig, ax = plt.subplots(figsize=(5, 4))
                    for t, label in type_labels.items():
                        if label != '1 Preference Level':
                            subset = df[(df['operation'] == operation) & (df['version'] == version) & (df['type'] == t)]
                            ax.plot(subset['input_tuples'], subset['total_io_blks'] / 1000, marker='o', label=label)
                    ax.set_xlabel('Number of Tuples')
                    ax.set_ylabel('Total IO Blocks (1K blocks)')
                    ax.legend(title='Pyramid:')
                    plt.tight_layout()
                    plt.savefig(f"{save_path}_{operation}_{version}.svg")
                    plt.close()
    if in_scale:
        style_dict = {'Pyramid': ('-', 'o'), 'Explicit': ('--', 's'), 'Non Temporal': ('-', 'o'), 'TSQL2': ('--', 's')}
        for idx, operation in enumerate(operations):
            fig, ax = plt.subplots(figsize=(7.5, 5))
            df_filtered = df[~(df['version'].isin(['NT', 'TS']))]
            versions_sorted = ['Pyramid', 'Explicit'] + [v for v in versions if v not in ['Pyramid', 'Explicit']]
            for version in versions_sorted:
                if version in ['NT', 'TS']:
                    subset = df[(df['operation'] == operation) & (df['version'] == version)]
                    label = 'No-Time' if version == 'NT' else 'Exact'
                    linestyle, marker = style_dict[label]
                else:
                    subset = df_filtered[(df_filtered['operation'] == operation) & (df_filtered['version'] == version)]
                    linestyle, marker = style_dict[version]

                for t, lbl in type_labels.items():
                    if lbl != '1 Preference Level':
                        subset_type = subset[subset['type'] == t]
                        ax.plot(subset_type['input_tuples'], subset_type['total_io_blks'] / 1000,
                                linestyle=linestyle,
                                marker=marker, label=f'{version} : {lbl} ', color=color_dict[lbl])
            if operation == 'Cartesian Product' and type_labels == type_interval:
                ax.axhline(y=180000 / 1000, color='black', linestyle='dotted', label='Test Ends')
            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Total IO Blocks (1K blocks)')
            ax.legend()

            plt.tight_layout()
            plt.savefig(f"{save_path}_{idx}_2.svg")
            plt.close()

        style_dict = {'Pyramid': ('-', 'o'), 'NT': ('dotted', 'o'), 'TS': ('--', 'o')}

        for idx, operation in enumerate(operations):
            fig, ax = plt.subplots(figsize=(7.5, 5))  # Creazione di una singola figura per ogni iterazione

            df_filtered = df[df['version'].isin(['NT', 'TS', 'Pyramid'])]
            for version in ['Pyramid', 'TS', 'NT']:
                subset = df_filtered[(df_filtered['operation'] == operation) & (df_filtered['version'] == version)]
                linestyle, marker = style_dict[version]

                if version == 'Pyramid':
                    for t, lbl in type_labels.items():
                        if lbl == '3 Preference Levels':
                            subset_type = subset[subset['type'] == t]
                            ax.plot(subset_type['input_tuples'], subset_type['total_io_blks'] / 1000,
                                    linestyle=linestyle, marker=marker, label='Pyramid',color = '#e47700')
                    for t, lbl in type_labels.items():
                        if lbl == '1 Preference Level':
                            subset_type = subset[subset['type'] == t]
                            ax.plot(subset_type['input_tuples'], subset_type['total_io_blks'] / 1000,
                                    linestyle=linestyle, marker=marker, label='Indet',color='#4a74b2')
                else:
                    label = 'No-Time' if version == 'NT' else ('Exact' if version == 'TS' else version)
                    color = '#8a64bc' if version == 'TS' else '#7c5247'
                    ax.plot(subset['input_tuples'], subset['total_io_blks'] / 1000, linestyle=linestyle,
                            marker=marker, label=label, color=color)

            ax.set_xlabel('Number of Tuples')
            ax.set_ylabel('Total IO Blocks (1K blocks)')
            ax.legend()

            plt.tight_layout()
            plt.savefig(
                f"{save_path}_{idx}_3.svg")  # Salvataggio di ciascuna figura separatamente con un indice univoco
            plt.close()


# IO GRAPHS
data_io_diff_10 = iograph(f"{base_path}/IO_DIFF_10INT.csv", 'Difference - 10 Interval', '10INT',
                          f'{result_path}/IO/IO_DIFF_10INT')
data_io_diff_50 = iograph(f"{base_path}/IO_DIFF_50INT.csv", 'Difference - 50 Interval', '50INT',
                          f'{result_path}/IO/IO_DIFF_50INT')
data_io_diff_100 = iograph(f"{base_path}/IO_DIFF_100INT.csv", 'Difference - 100 Interval', '100INT',
                           f'{result_path}/IO/IO_DIFF_100INT')
data_io_diff_1 = iograph(f"{base_path}/IO_DIFF_1PREF.csv", 'Difference - 1 Preference', '1PREF',
                         f'{result_path}/IO/IO_DIFF_1PREF')
data_io_diff_5 = iograph(f"{base_path}/IO_DIFF_5PREF.csv", 'Difference - 5 Preference', '5PREF',
                         f'{result_path}/IO/IO_DIFF_5PREF')
data_io_diff_10pref = iograph(f"{base_path}/IO_DIFF_10PREF.csv", 'Difference - 10 Preference', '10PREF',
                              f'{result_path}/IO/IO_DIFF_10PREF')
data_io_pc_10 = iograph(f"{base_path}/IO_PC_10INT.csv", 'Cartesian Product - 10 Interval',
                        '10INT', f'{result_path}/IO/IO_PC_10INT')
data_io_pc_50 = iograph(f"{base_path}/IO_PC_50INT.csv", 'Cartesian Product - 50 Interval',
                        '50INT', f'{result_path}/IO/IO_PC_50INT')
data_io_pc_100 = iograph(f"{base_path}/IO_PC_100INT.csv", 'Cartesian Product - 100 Interval',
                         '100INT', f'{result_path}/IO/IO_PC_100INT')
data_io_pc_1 = iograph(f"{base_path}/IO_PC_1PREF.csv", 'Cartesian Product - 1 Preference',
                       '1PREF', f'{result_path}/IO/IO_PC_1PREF')
data_io_pc_5 = iograph(f"{base_path}/IO_PC_5PREF.csv", 'Cartesian Product - 5 Preference',
                       '5PREF', f'{result_path}/IO/IO_PC_5PREF')
data_io_pc_10pref = iograph(f"{base_path}/IO_PC_10PREF.csv", 'Cartesian Product - 10 Preference',
                            '10PREF', f'{result_path}/IO/IO_PC_5PREF')

data_io_diff_NT = iograph(f"{base_path}/IO_DIFF_NT.csv", 'Difference - Non Temporal', 'NT',
                          f'{result_path}/IO/IO_DIFF_NT')
data_io_diff_TSQL2 = iograph(f"{base_path}/IO_DIFF_TS.csv", 'Difference - TSQL2', 'TS',
                             f'{result_path}/IO/IO_DIFF_TS')
data_io_pc_NT = iograph(f"{base_path}/IO_PC_NT.csv", 'Cartesian Product - Non Temporal', 'NT',
                        f'{result_path}/IO/IO_PC_NT')
data_io_pc_TSQL2 = iograph(f"{base_path}/IO_PC_TS.csv", 'Cartesian Product - TSQL2', 'TS',
                           f'{result_path}/IO/IO_PC_TS')
additional_rows = pd.DataFrame([
    {'version': 'Explicit', 'input_tuples': 500, 'type': '100INT', 'operation': 'Cartesian Product',
     'total_io_blks': 6500.0},
    {'version': 'Explicit', 'input_tuples': 1000, 'type': '100INT', 'operation': 'Cartesian Product',
     'total_io_blks': 180000.0},
    {'version': 'Explicit', 'input_tuples': 2500, 'type': '100INT', 'operation': 'Cartesian Product',
     'total_io_blks': 180000.0},
    {'version': 'Explicit', 'input_tuples': 5000, 'type': '100INT', 'operation': 'Cartesian Product',
     'total_io_blks': 180000.0}
])
data_io_pc_100 = pd.concat([data_io_pc_100, additional_rows], ignore_index=True)
new_row = pd.DataFrame([{'version': 'Explicit', 'input_tuples': 5000, 'type': '50INT', 'operation': 'Cartesian Product',
                         'total_io_blks': 180000.0}])
data_io_pc_50 = pd.concat([data_io_pc_50, new_row], ignore_index=True)
frames = [data_io_diff_10, data_io_diff_50, data_io_diff_100, data_io_diff_1, data_io_diff_5, data_io_pc_10,
          data_io_pc_50, data_io_pc_1, data_io_pc_5, data_io_pc_NT, data_io_pc_TSQL2, data_io_diff_NT,
          data_io_diff_TSQL2, data_io_pc_10pref, data_io_diff_10pref, data_io_pc_100]
df_total_io = pd.concat(frames)
df_total_io = df_total_io[df_total_io['input_tuples'] != 1000000]
# EXECUTION TIME AND ANSWER SIZE
data_structure_10 = process_files(f"{base_path}/10INT_TEST", '10INT')
data_structure_50 = process_files(f"{base_path}/50INT_TEST", '50INT')
data_structure_100 = process_files(f"{base_path}/100INT_TEST", '100INT')
data_structure_1pref = process_files(f"{base_path}/1PREF_TEST", '1PREF')
data_structure_5pref = process_files(f"{base_path}/5PREF_TEST", '5PREF')
data_structure_10pref = process_files(f"{base_path}/10PREF_TEST", '10PREF')
data_structure_NoTime = process_files(f"{base_path}/NOTIME", 'NOTIME')
data_structure_TSQL2 = process_files(f"{base_path}/TSQL2", 'TSQL2')
data_structure_100[(1000, 'ME', 'PC', '100INT')] = {
    'execution_times': [3600000, None, None],
    'actual_rows': 0,
    'average_execution_time': 3600000
}
data_structure_100[(2500, 'ME', 'PC', '100INT')] = {
    'execution_times': [3600000, None, None],
    'actual_rows': 0,
    'average_execution_time': 3600000
}
data_structure_100[(5000, 'ME', 'PC', '100INT')] = {
    'execution_times': [3600000, None, None],
    'actual_rows': 0,
    'average_execution_time': 3600000
}
data_structure_50[(5000, 'ME', 'PC', '50INT')] = {
    'execution_times': [3600000, None, None],
    'actual_rows': 0,
    'average_execution_time': 3600000
}
data_structure_100[(500, 'ME', 'PC', '100INT')] = {
    'execution_times': [320680.200, None, None],
    'actual_rows': 2347,
    'average_execution_time': 320680.200
}

plot_data(data_structure_10, '10 Interval', f'{result_path}/EXEC_10INT')
plot_data(data_structure_50, '50 Interval', f'{result_path}/EXEC_50INT')
plot_data(data_structure_100, '100 Interval', f'{result_path}/EXEC_100INT')
plot_data(data_structure_1pref, '1 Preference', f'{result_path}/EXEC_1PREF')
plot_data(data_structure_5pref, '5 Preference', f'{result_path}/EXEC_5PREF')
plot_data(data_structure_10pref, '10 Preference', f'{result_path}/EXEC_10PREF')

# COMPARISON EXECUTION TIME
data_pref = [data_structure_1pref, data_structure_10, data_structure_5pref, data_structure_10pref,
             data_structure_NoTime, data_structure_TSQL2]
data_interval = [data_structure_10, data_structure_50, data_structure_100, data_structure_NoTime, data_structure_TSQL2]
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
