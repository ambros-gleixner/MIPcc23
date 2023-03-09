import pyscipopt
import os
import sys
from datetime import datetime

meta_file = sys.argv[-1]
if not os.path.isfile(meta_file):
    print("Usage: python run.py /path/to/meta/file")
    exit()

with open(meta_file) as file:
    all_lines = [line.rstrip() for line in file]

if not os.path.isfile(meta_file):
    print("Meta file is invalid")
    print(meta_file)
    exit()

# read instances from meta file
instances = all_lines[7:len(all_lines)]
print("number of instances:", len(instances))

# read time limit from meta file
time_limit = int(all_lines[0].split(' ')[-1])

model = pyscipopt.Model("reoptimization")

solution_folder = os.path.join("solutions/", os.path.basename(os.path.splitext(meta_file)[0]))

if not os.path.isdir(solution_folder):
    os.mkdir(solution_folder)

base_folder = os.path.join(os.path.dirname(meta_file), "../..")

for instance in instances:
    instance_base = os.path.basename(instance)
    print("[INSTANCE]", instance_base)

    # optionally disable SCIP output
    # model.setIntParam("display/verblevel", 0)

    # set time limit
    model.setRealParam("limits/time", time_limit)

    # read instance
    instance_path = os.path.join(base_folder, instance)
    model.readProblem(instance_path)

    # optimize
    print("[START]", datetime.now().isoformat())
    model.optimize()
    print("[END]", datetime.now().isoformat())

    # print dual bound
    print("[DUALBOUND]", model.getDualbound())

    # write solution to instance_name.sol in 'solutions' directory
    if model.getNSols() > 0:
        with open(os.path.join(solution_folder, f"{instance_base}.sol"), 'w') as f:
            vars = model.getVars(transformed=False)
            for v in vars:
                solval = model.getVal(v)
                if abs(solval) > 1e-10:
                    f.write(v.name + "    " + str(solval) + "\n")
    else:
        print("No solution found")
