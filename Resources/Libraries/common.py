"""A library for custom keywords
"""
import csv


def defineEnvironmentVariablesFromFile(env):
    print(f'Looking for {env} environment')
    variables = {}
    with open('Resources/Common/environments.csv') as csv_file:
        csv_reader = csv.DictReader(csv_file, delimiter=',')
        for row in csv_reader:
            if row["environment"].lower() == env.lower():
                print(f'Found an environment {env}!')
                for key in row.keys():
                    if key != 'environment':
                        variables[key] = row[key]
    if not variables:
        print(f'Environment {env} not found!')
    return variables


def get_url_without_starting_slash(string):
    if string[0] == "/":
        string_without_starting_slash = string[1:]
        return string_without_starting_slash
    else:
        return string
