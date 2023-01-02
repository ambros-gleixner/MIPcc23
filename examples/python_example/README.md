# Example script using PySCIPOpt

This is an example submission for the reoptimization challenge using the SCIP Python wrapper.

## Installation and setup

See the PySCIPOpt [README](https://github.com/scipopt/PySCIPOpt/).

## Expected interface

The main program takes as argument the metafile. The metafile contains time limit on the first line, rows and columns of components that vary across instances on the next six lines, followed by the instances to solve.
```shell
sh mipcomp.sh ../../datasets/testfiles/matrix_series_1.test
```

The script reads the time limit, all instances, and starts solving them with the output required for the competition:
```shell
[INSTANCE] inst_01.mps
[START] 2022-10-26T15:25:10.852
[END] 2022-10-26T15:26:17.171
[DUALBOUND] -17174.255797175505
```

- The `[START]` and `[END]` times must be given in the same format as that of the `date -Iseconds` command.
- `[INSTANCE]` must be the name of the current instance being solved (without the complete path).
- `[DUALBOUND]` must be a valid dual/relaxation bound for the problem at hand. The validity of dual bounds will be verified on hidden instances and through the code.
- A `.sol` solution file must be produced in the `solutions/instance_group` folder of your submission.
With the example above, the solution folder would be `solutions/matrix_series_1`.

## Solution file

The sol file is expected to have on each line a variable name and the associated value. Additional lines can be added with comments starting with `#`.
If any variable is absent from the sol file, it will be interpreted as 0.0.
