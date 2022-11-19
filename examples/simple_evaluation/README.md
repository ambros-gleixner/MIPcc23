# Using the example evaluation script

The python script `eval.py` provides a simple example how to produce the scores as specified in the rules and verify them partially.
Its dependencies are listed in `environment.yml'.

Usage:
1. Run your script and save the output to a log file, e.g., `mipcomp.sh /path/to/testfile.test > mylog.txt`.
2. Verify that your script produced solution files in a solution folder as specified in the rules.
3. Run the script, e.g., `python eval.py /path/to/mylog.txt /path/to/solution_folder /path/to/testfile.test`.

The total score and its three components will then be printed for each individual instance.

