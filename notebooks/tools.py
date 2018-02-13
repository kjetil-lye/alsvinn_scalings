import json

def read_run(report):
    with open(report, 'r') as f:
        return json.load(f)

def get_runtime(report):
    return int(read_run(report)['report']['wallTime'])

def get_timesteps(report):
    return int(read_run(report)['report']['timesteps'])

def get_processes(report):
    return int(read_run(report)['report']['mpiProcesses'])

def get_threads(report):
    return int(read_run(report)['report']['ompThreads'])

def get_total_cores(report):
    return int(get_threads(report)*get_processes(report))

def get_revision(report):
    return read_run(report)['report']['revision']

def get_build_type(report):
    return read_run(report)['report']['buildType']
