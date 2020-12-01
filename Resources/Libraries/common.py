"""A library for custom keywords
"""
import json

def defineEnvironmentVariablesFromJsonFile(env):
    print(f'Looking for {env} environment')
    variables = {}
    environments_file_path = 'Resources/Environments/environments_' + env + '.json'
    try:
        with open(environments_file_path) as json_file:      
            data = json.loads(json_file.read())
            for d in data:
                if d["environment"] == env:
                    print(f'Found an environment {env}!')
                    for key, value in d.items():
                        if key not in variables:
                            variables[key] = value
    except:
        print(f'Environment {env} not found!')
    if not variables:
        print(f'No variables found for environment {env}')
    return variables
