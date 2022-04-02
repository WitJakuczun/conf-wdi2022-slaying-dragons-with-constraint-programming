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
