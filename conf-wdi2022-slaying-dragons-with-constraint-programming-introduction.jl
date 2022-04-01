#nb # %% {"slideshow": {"slide_type": "slide"}}
# # What is constraint programming?

#nb # %% {"slideshow": {"slide_type": "slide"}}
md"""
## What does [Wikipedia](https://en.wikipedia.org/wiki/Constraint_programming) say?
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
Constraint programming (CP)[1] is a paradigm for **solving combinatorial problems**
that draws on a wide range of techniques from artificial intelligence, computer science,
and operations research.

In constraint programming, users **declaratively** state the **constraints** on
the feasible solutions for a set of **decision variables**.
"""

#nb # %% {"slideshow": {"slide_type": "slide"}}
md"""
## Components of Constraint Programming programm

Each constraint programming program is defined by the following triple:
"""

#nb # %% {"slideshow": {"slide_type": "fragments"}}
md"""

* Variables
* Constraints
* Search procedure:
    * propagation
    * variable selection
    * value selection
"""


#nb # %% {"slideshow": {"slide_type": "slide"}}
# ##Variables

#nb # %% {"slideshow": {"slide_type": "fragment"}}
md"""
Variables define our decision (optimization) problem.  Each variable has a domain that define value range
it can take.
"""

#nb # %% {"slideshow": {"slide_type": "fragment"}}
# Modern constraint programming implementations can handle following variables' domains:

#nb # %% {"slideshow": {"slide_type": "fragment"}}
# *Discrete domains*
# $\{1,2,3\}$ or $\{go, wait\}$


#nb # %% {"slideshow": {"slide_type": "fragment"}}
# *Real value domains*
# $[0\ldots 3)\cup(5,\ldots,8]$


#nb # %% {"slideshow": {"slide_type": "fragment"}}
# Multiset domains
# $\{\{1\}, \{1,2\}\} \subseteq 2^{\{1,2\}}$

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Constraints
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
Constraint is a function with variables as arguments that returns three values:

* *true* if values of variables fulfill the constraint
* *false* if values of variables break the constraint
* *maybe* if it is not possible to decide if there is (non)feasible valuation of the variables.
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
Constraints follow the rules:

* Each constraint call can result in domain reduction of variables
this constraint handles.
* Constraints are called in an order they were declared but decision to run
the constraint is triggered by how its variables were modified. Exemplary events:
    * variable is instantiated (has only one value)
    * domain was modified
    * lower/upper bounding value of domain has changed
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Search process - general introduction
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
Search (aka labeling) process is a process that is trying to
check **all** values of **each** variable. It looks like bruteforce but
due to constrants domain reduction is very effective.
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
It is important to understand that this process is of recursive nature. After
a solution is found feasible or unfeasible, the process **backtracks** to last state
and tries next combination.
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
It is split into two main phases that interleave:

* Constraint propagation - it is a process in which constraints
  are triggering each other by changing domains of variables. This process is mean to be
  done automatically. We can influence it by constraints.
* Labelling - it is a process in which variables are being assigned values from
  their domains.
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Search process - pseudocode
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
1. Post variables
2. Post Constraints
3. Propagate constraints
4. If there are variables that has more than one value
    1. Select one of them (e.g. $var$)
    2. Select one possible value from $var$'s domain (e.g. $val$)
    3. Instantiate $var$ to $val$
    4. Jump to 3.
5. If there is at least one variable with empty domain report *Infeasible*
6. If all variables have singleton domains mark this as solution.
    1. Backtrack all changes to last instantiated variable and jump to 4.A and select next value
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Example of search tree for [queens problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle).
"""


#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
![](http://hakank.org/minizinc/cp_viz_queens8.png)

Source image [MiniZinc version 1.2: More about CP-Viz and some models changed](http://www.hakank.org/constraint_programming_blog/minizinczinc/#:~:text=MiniZinc%20version%201.2%3A%20More%20about%20CP%2DViz%20and%20some%20models%20changed)
"""


#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Constraint programming vs Mixed Integer Programming
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
* Easily handles complex/non-linear constraints.
* More expressive thanks to *constraints are functions* approach.
* Best for finding feasible (not optimal) solutions.
* Easily can generate all or many solutions. :
* White-box approach where programmer controls search process.
* Both approaches can cooperate
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
# Working examples
"""


#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Tools
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
* [Julia 1.7.2](https://julialang.org/downloads/)
* [ConstraintSolver.jl](https://wikunia.github.io/ConstraintSolver.jl/stable/)
* [MiniZinc](https://www.minizinc.org/)
* [VSCode](https://code.visualstudio.com/)
    * [Jupyter Notebooks in VS Code](https://code.visualstudio.com/docs/datascience/jupyter-notebooks)
    * [Julia in VS Code](https://code.visualstudio.com/docs/languages/julia)
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
## Propagation mechanism
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
I will present how constraint programming works for the following feasibility problem:

* We have three variables: $x,y \in\{0,...,9\}$ and $z \in\{0...18\}$
* We will play with the following constraints:
    1. $x + y = z$
    2. $z = 13$
    3. $y < x-3$
* Task is to find all solutions that respect given constraints.
"""

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
All code is available at my github account [github.com/WitJakuczun/](https://github.com/WitJakuczun).
Repository name is [conf-wdi2022-slaying-dragons-with-constraint-programming](https://github.com/WitJakuczun/conf-wdi2022-slaying-dragons-with-constraint-programming)
"""
#

using ConstraintSolver
const CS=ConstraintSolver
using JuMP
#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
### First constraint $x + y = z$
"""
#
function first_constraint()
    m = Model(optimizer_with_attributes(CS.Optimizer, "backtrack"=>false))

    @variable(m, 0 <= x <= 9, Int)
    @variable(m, 0 <= y <= 9, Int)
    @variable(m, 0 <= z <= 18, Int)

    @constraint(m, z == x+y)

    optimize!(m)

    status = JuMP.termination_status(m)
    println("Solving ended with $(status) status.")
    if status in [OPTIMAL, OTHER_LIMIT]
        for v in [x, y, z]
            println(name(v), "=>", CS.values(m, v))
        end
    else
        println("No solution found.")
    end
end

first_constraint();

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
### Constraint $z = 13$

Solver was not able to reduce domains. Let's see what happens if I add next constraint.
"""

#
function second_constraint()
    m = Model(optimizer_with_attributes(CS.Optimizer, "backtrack"=>false))

    @variable(m, 0 <= x <= 9, Int)
    @variable(m, 0 <= y <= 9, Int)
    @variable(m, 0 <= z <= 18, Int)

    @constraint(m, z == x+y)
    @constraint(m, z == 13)

    optimize!(m)

    status = JuMP.termination_status(m)
    println("Solving ended with $(status) status.")
    if status in [OPTIMAL, OTHER_LIMIT]
        for v in [x, y, z]
            println(name(v), "=>", CS.values(m, v))
        end
    else
        println("No solution found.")
    end
end
second_constraint();

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
### Constraint $x < y - 4$

Now solver was able to deduce that variables $x$ and $y$ must be greater than $4$.
Let's see what happens if we add more constraints.
"""

#
function third_constraint()
    m = Model(optimizer_with_attributes(CS.Optimizer, "backtrack"=>false))

    @variable(m, 0 <= x <= 9, Int)
    @variable(m, 0 <= y <= 9, Int)
    @variable(m, 0 <= z <= 18, Int)


    @constraint(m, z == x+y)
    @constraint(m, z == 13)
    @constraint(m, y < x - 4)
    optimize!(m)

    status = JuMP.termination_status(m)
    println("Solving ended with $(status) status.")
    if status in [OPTIMAL, OTHER_LIMIT]
        for v in [x, y, z]
            println(name(v), "=>", CS.values(m, v))
        end
    else
        println("No solution found.")
    end
end

third_constraint();

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
### Summary

As you could see the solver was able to reduce domains. Even to the solution just using propagation mechanizm.
"""


#nb # %% {"slideshow": {"slide_type":"slide"}}
# ## Labeling variables

md"""
Now I will present how we can deal with the situation when propagation mechanism was not
able to find solution.


Suppose we wish to schedule six one-hour lectures, v1, v2, v3, v4, v5, v6.
  Among the the potential audience there are people who **wish to hear both**

   - v1 and v2
   - v1 and v4
   - v3 and v5
   - v2 and v6
   - v4 and v5
   - v5 and v6
   - v1 and v6

  How many hours are necessary in order that the lectures can be given
  without clashes?

*Based on [http://hakank.org/julia/constraints/lectures.jl](http://hakank.org/julia/constraints/lectures.jl)*
"""
#



# ### First we will create a model for the lecture scheduling problem.

#

function labeling_variables_1()
    problem = [
        (1, 2),
        (1, 4),
        (3, 5),
        (2, 6),
        (4, 5),
        (5, 6),
        (1, 6)
    ]
    n = size(problem)[1]

    m = Model(optimizer_with_attributes(CS.Optimizer, "backtrack"=>false))

    @variable(m, 1 <= lecture_time[1:n] <= n, Int)
    @variable(m, 1 <= max_t <= n, Int)

    for (lecture_a, lecture_b) in problem
        @constraint(m, lecture_time[lecture_a] != lecture_time[lecture_b])
    end

    @constraint(m, lecture_time .<= max_t)

    @objective(m, Min, max_t)

    optimize!(m)

    status = JuMP.termination_status(m)
    println("Solving ended with $(status) status.")
    if status in [OPTIMAL, OTHER_LIMIT]
        println(name(max_t), "=>", CS.values(m, max_t))
        for i in 1:n
            println(name(lecture_time[i]), "=>", CS.values(m, lecture_time[i]))
        end
    else
        println("No solution found.")
    end
end

md"""
Let's see if solver can reduce domain of variables.
"""

labeling_variables_1()

md"""
As you can see solver was not able to reduce domains of any vairable
"""

# ### Now we will add labeling phase and compare two value selection strategies:

md"""
* Start with smallest value possible
* Start with larget value possible

We will use default variable selection process that prioritize variables that are in objective formula, how often they lead to infeasibility and size of their domains.
More info you can find [here](https://wikunia.github.io/ConstraintSolver.jl/stable/options/#:~:text=Options%3A-,%3AIMPS,-%3D%3E%20Infeasible%20and%20Minimum)
"""

#
function labeling_variables_2(branch_split)
    problem = [
        (1, 2),
        (1, 4),
        (3, 5),
        (2, 6),
        (4, 5),
        (5, 6),
        (1, 6)
    ]
    n = size(problem)[1]

    m = Model(optimizer_with_attributes(CS.Optimizer,
                    "traverse_strategy"=>:BFS,
                    "branch_strategy"=>:IMPS,
                    "branch_split"=>branch_split,
                    "backtrack"=>true))

    @variable(m, 1 <= lecture_time[1:n] <= n, Int)
    @variable(m, 1 <= max_t <= n, Int)

    for (lecture_a, lecture_b) in problem
        @constraint(m, lecture_time[lecture_a] != lecture_time[lecture_b])
    end

    @constraint(m, lecture_time .<= max_t)

    @objective(m, Min, max_t)

    optimize!(m)

    status = JuMP.termination_status(m)
    println("Solving ended with $(status) status.")
    if status in [OPTIMAL, OTHER_LIMIT]
        println(name(max_t), "=>", CS.values(m, max_t))
        for i in 1:n
            println(name(lecture_time[i]), "=>", CS.values(m, lecture_time[i]))
        end
    else
        println("No solution found.")
    end
end

# ### Smallest values first


@time labeling_variables_2(:Smallest)

# ### Biggest values first 

#
@time labeling_variables_2(:Biggest)

# ### Mean value to split domain in half
#
@time labeling_variables_2(:InHalf)

