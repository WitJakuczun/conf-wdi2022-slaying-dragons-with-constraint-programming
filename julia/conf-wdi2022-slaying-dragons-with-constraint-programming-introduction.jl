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
