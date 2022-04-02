
%%minizinc -m bind -s -t 60000 --solver gecode

include "globals.mzn";

int: n_machines;                        % The number of machines.
int: n_jobs;                            % The number of jobs.
int: n_tasks = n_machines;      % Each job has one task per machine.
set of int: jobs = 1..n_jobs;
set of int: tasks = 1..n_tasks;
set of int: machines = 0..(n_machines-1);

array [jobs, tasks] of int: jt_machine;
array [jobs, tasks] of int: jt_duration;

int: max_end;

array [jobs, tasks] of var 0..max_end: jt_start;
var 0..max_end: t_end;

array [machines, jobs] of var jobs: seq;


constraint
    (
        t_end = max([jt_start[j,t] + jt_duration[j,t] | j in jobs, t in tasks])
    );

constraint
    forall ( j in jobs, k in 1..(n_tasks - 1) ) (
        jt_start[j, k] + jt_duration[j, k]  <=
            jt_start[j, k + 1]
    );

constraint
    forall(m in machines) (
        disjunctive(
            [jt_start[j,t] | j in jobs, t in tasks where
                jt_machine[j,t]=m],
            [jt_duration[j,t] | j in jobs, t in tasks where
                jt_machine[j,t]=m])
    );

constraint
    forall(m in machines) (alldifferent([seq[m,j] | j in jobs]));

constraint
    forall(m in machines, j1 in jobs, j2 in jobs, t1 in tasks, t2 in tasks
        where jt_machine[j1,t1]=m /\jt_machine[j2,t2]=m)
        (
            seq[m, j1] < seq[m, j2] ->
                jt_start[j1,t1] + jt_duration[j1, t1] <= jt_start[j2, t2]
        );

solve
    :: seq_search([
        int_search(
            [seq[m,j] |
                m in machines, t in tasks, j in jobs
                where jt_machine[j,t]=m],
            first_fail,
            indomain_random),
        int_search([jt_start[j,t] | j in jobs, t in tasks], smallest, indomain_min)])
    :: restart_constant(1000)

    minimize t_end;

output [
    "t_end = ", show(t_end), "\n"
];


n_machines = 10;
n_jobs = 10;
max_end = 1050;


%
% The times for each job.
%
jt_duration = array2d(jobs, tasks,
   [
 29, 78, 9,  36, 49, 11, 62, 56, 44, 21,
 43, 90, 75, 11, 69, 28, 46, 46, 72, 30,
 91, 85, 39, 74, 90, 10, 12, 89, 45, 33,
 81, 95, 71, 99, 9,  52, 85, 98, 22, 43,
 14, 6,  22, 61, 26, 69, 21, 49, 72, 53,
 84, 2,  52, 95, 48, 72, 47, 65, 6,  25,
 46, 37, 61, 13, 32, 21, 32, 89, 30, 55,
 31, 86, 46, 74, 32, 88, 19, 48, 36, 79,
 76, 69, 76, 51, 85, 11, 40, 89, 26, 74,
 85, 13, 61, 7,  64, 76, 47, 52, 90, 45,
 ]);


%
% The order the jobs must be done.
%
%
jt_machine = array2d(jobs, 1..n_machines,
  [
   % indicating the order in which each job must be done
 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
 0, 2, 4, 9, 3, 1, 6, 5, 7, 8,
 1, 0, 3, 2, 8, 5, 7, 6, 9, 4,
 1, 2, 0, 4, 6, 8, 7, 3, 9, 5,
 2, 0, 1, 5, 3, 4, 8, 7, 9, 6,
 2, 1, 5, 3, 8, 9, 0, 6, 4, 7,
 1, 0, 3, 2, 6, 5, 9, 8, 7, 4,
 2, 0, 1, 5, 4, 6, 8, 9, 7, 3,
 0, 1, 3, 5, 2, 9, 6, 7, 4, 8,
 1, 0, 2, 6, 8, 9, 5, 3, 4, 7,
  ]);
