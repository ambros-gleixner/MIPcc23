using SCIP, HiGHS, Cbc
using MathOptInterface
const MOI = MathOptInterface
using Dates

if isempty(ARGS)
    error("Pass the meta file as last argument.\nAborting")
end

meta_file = ARGS[end]

if !isfile(meta_file)
    error("Last argument should be a file:\n$(meta_file)\nAborting")
end

all_lines = open(meta_file) do f
    readlines(f)
end

time_limit_line = all_lines[1]
@assert occursin("TIMEOUT", time_limit_line)
time_limit = parse(Int, split(time_limit_line, " ")[end])

base_folder = joinpath(dirname(meta_file), "../..")

all_files = [joinpath(base_folder, file) for file in all_lines[2:end]]
# verify that we have a valid path
@assert all(isfile, all_files)

# choose your solver here
optimizer = SCIP.Optimizer()
# optimizer = HiGHS.Optimizer()
# Cbc requires a cache to work
# optimizer = MOI.Utilities.CachingOptimizer(
    # MOI.Utilities.UniversalFallback(MOI.Utilities.Model{Float64}()),
    # Cbc.Optimizer(),
# )

meta_file_basename = basename(splitext(meta_file)[1])

solution_folder = joinpath(@__DIR__, "solutions/$(meta_file_basename)")
if !isdir(solution_folder)
    mkdir(solution_folder)
end
@assert isdir(solution_folder)

for file in all_files
    basefile_name = basename(file)
    println("[INSTANCE] $(basefile_name)")

    # read instance
    file_model = MOI.FileFormats.Model(filename=file)
    MOI.read_from_file(file_model, file)
    MOI.copy_to(optimizer, file_model)

    # set time limit and disable output
    MOI.set(optimizer, MOI.TimeLimitSec(), time_limit)

    # optionally remove output
    # MOI.set(optimizer, MOI.Silent(), true)

    # optimize (Dates.now() prints in the required format of bash date +%s)
    println("[START] ", Dates.now())
    MOI.optimize!(optimizer)
    println("[END] ", Dates.now())

    # print out dual bound
    dual_bound = MOI.get(optimizer, MOI.ObjectiveBound())
    println("[DUALBOUND] $(dual_bound)")

    if MOI.get(optimizer, MOI.PrimalStatus()) in (MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT)
        # write solution file to instance_name.sol in s'olutions' directory
        open(joinpath(solution_folder, "$basefile_name.sol"), "w") do f
            for var in MOI.get(optimizer, MOI.ListOfVariableIndices())
                name = MOI.get(optimizer, MOI.VariableName(), var)
                val = MOI.get(optimizer, MOI.VariablePrimal(), var)
                write(f, "$name     $val\n")
            end
        end
    else
        println("No solution found")
    end

    # empty the optimizer state
    MOI.empty!(optimizer)
end
