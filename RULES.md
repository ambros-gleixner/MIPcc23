# MIPcc23: The MIP Workshop 2023 Computational Competition

See [here](README.md) for a general description of the competition topic.
In the following, we describe the rules and evaluation process in detail.


## Rules for Participation

- Participants must not be an organizer of the competition nor a family member of a competition organizer.
- Otherwise, there is no restriction on participation.
- **In particular, student participation is encouraged.**
- Participants can be a single entrant or a team; there is no restriction on the size of teams.
- Should participants be related to organizers of the competition, the rest of the committee will decide whether a conflict of interest is at hand.  Affected organizers will not be part of the jury for the final evaluation.


## Technical Rules

- Participants may use any existing software that is available in source code and can be freely used for the evaluation.  Closed-source solvers and software that provides algorithmic functionality for optimization is forbidden.
- The source code may be written in any programming language.
- For the final evaluation, participants will need to compile and run their code on a Linux server.
- The instances must be solved sequentially in the order specified by the input files. 
- The submissions must run sequentially (1 thread), use no more than 16 GB of RAM, and respect the total time limit for each instance series.
- Violations of the time limit for a single instance are penalized in the performance score.

In case participants have any doubts about the implementation of specific rules, they should not hesitate to contact the organizers, best on this repo's [discussions](https://github.com/ambros-gleixner/MIPcc23/discussions) forum.


## Submission Requirements

### Registration

- All participants must register with the full list of team members via e-mail by January 31st, 2023.
- After this deadline, all teams will receive access to a server for testing installation of their software.
- Teams of multiple participants must nominate a single contact person to handle the submission of report and code.

### Report

All participants must submit a written report of **10 pages maximum** plus references, in Springer LNCS format, through [easychair.org](https://www.easychair.org).
Submissions will be accepted until **March 1st, 2023, at 8:00 PM EST**.

The report must include the following information:
- A description of the methods developed and implemented, including any necessary citations to the literature and software used.
- Computational results on the public instance series with constant constraint matrix, see (datasets/README.md)[datasets/README.md].
- The results should include at least the following metrics for each series: $reltime$, $gap$, and $nofeas$ scores (as defined below) averaged over all 50 instances, and additionally over the 5 batches of instances 1 to 10, 11 to 20, 21 to 30, 31 to 40, and 41 to 50.
- Further analysis of the computational results is welcome.  If the approach can be applied to the instance series with varying constraint matrix, e.g., it would be interesting to include this in the report.

If the computational work was performed by students only, the participants should include a letter of attestation indicating this.

### Code

All programs should be executable via a shell script named `mipcomp.sh` (provided by the participants) which receives a text file as follows:
- The first line `[TIMEOUT] t` contains the time limit of `t` seconds for solving a single instance of the series.
- The following 50 lines contain the paths of the instances in the series.

The script will be executed as `sh mipcomp.sh dataset.test` with a hard time limit of 50 times `t` times 1.1.

The log output must contain at least the following information in this order:
```shell
[INSTANCE] synthetic_1.mps
[START] 2022-10-26T15:25:10.852
[END] 2022-10-26T15:26:17.171
[DUALBOUND] -17174.255797175505
```
- The `[START]` and `[END]` times must be given in the same format as that of the `date -Iseconds` command.
- `[INSTANCE]` must be the file name of the current instance being solved (without the complete path).
- `[DUALBOUND]` must be a valid dual/relaxation bound for the problem at hand. The validity of dual bounds will be verified by comparison against exact pre-computed values. Dual bounds must not violate the optimal objective value $z$ by more than $10^{-5}\cdot\max(|z|,1)$.

For each instance, one solution file with name of the instance and extension `.sol` should be produced in the `solutions` folder of your submission.
The solution file must follow the following format:
- Each line contains a variable name and the associated value as `<variable name> white space <solution value>`.
- Additional lines can be added as comments starting with `#`.
- If any variable is absent from the solution file, its value will be interpreted as 0.0.

A primal solution will be considered feasible if the absolute violation of every constraint is at most $10^{−5}$ and if all integer variables are at most $10^{-4}$ away from the nearest integer value.

The solution file for an instance must not be modified anymore after moving on to solve the next instance.


## Final Evaluation Criteria

The evaluation will be performed by an expert jury of researchers with experience in computational optimization. They will judge both paper and code submission on two criteria:
1. **Novelty and scope**: How innovative is the approach, and how general regarding type and magnitude of the changes?
2. **Computational excellence**: How does the approach rank in terms of the performance score defined below.

The computational evaluation of the submissions will be conducted on instance series **with constant constraint matrix**:
- on the public instances in this repository as described in [datasets/README.md](datasets/README.md),
- on a set of hidden instances pre-selected by the jury.
The hidden instance series will also feature constant constraint matrix.

The spirit of this competition is to encourage the development of new methods that work in practice.
The jury will be free to disqualify submissions that provide no contribution beyond repurposing existing software or that do not address the task to reuse information from previous solving processes for reoptimization.


## Performance Scoring

1. Performance evaluation is based on a set of instance series $s=1,\ldots,S$, each consisting of $i=1,\ldots,50$ MIP instances.

2. Performance on a single instance $(s,i)$ is measured via the score function $f(s,i) = reltime + gap\ at\ time\ limit + nofeas$ where
$$reltime := \frac{time\ spent}{time\ limit} \text{ iff instance is solved to optimality}, \quad\text{ and }\quad \max(1, \frac{time\ spent}{time\ limit}) \text{ otherwise}$$
$$gap := 0 \text{ if } pb = db = 0, \quad 1 \text{ if } pb \text{ or } db \text{ are infinite or } pb\cdot db < 0, \quad \text{and} \quad \frac{|pb-db|}{\max(|pb|,|db|)} \text{ otherwise}$$
$$nofeas := 1 \text{ if no feasible solution is returned}, \quad\text{ and }\quad 0 \text{ otherwise}$$
Smaller score is better.
If the submission exceeds the time limit, $reltime$ will be larger than 1.
Submissions that stop before the time limit without reaching gap zero will receive full $reltime = 1$.
The $gap$ definition ensures a value between 0 and 1 (here, $pb$ and $db$ stand for "primal bound" and "dual bound", respectively).
$nofeas$ penalizes submissions that do not reliably produce primal solutions.

3. Then for each instance $(s,i)$ all participants are ranked according to their score $f_{(s,i)}$.  This way, each team receives a rank $r_{(s,i)}$: smaller rank is better.  Teams with same score receive the same rank.

4. For instances where the primal solution is not feasible or the dual bound is not valid, a team receives two times the lowest possible rank independently of their $f(s,i)$ value.

5. For each team, a total score is then computed as the following weighted sum of their ranks over all instances $(s,i)$:
$$C := \sum_{s=1}^S \sum_{i=1}^{50} (1+0.1i) \cdot r_{(s,i)}$$
This way, the rank for instances that appear later in their series is weighted higher.


