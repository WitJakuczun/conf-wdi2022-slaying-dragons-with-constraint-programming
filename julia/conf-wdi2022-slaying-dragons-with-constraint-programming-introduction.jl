
#nb # %% {"slideshow": {"slide_type": "slide"}}
md"""
![](images/Jakuczun-Wit.png)
"""

# # What about the dragons?

md"""
![](images/Rabbitattack.jpeg)
"""

# ## Large Scale Combinatorial Optimization problems (LSCOs).

md"""
* **Real world problems which do not fit into well-defined problem categories.** There is no eficient solution models publicized in the research literature
which would apply to them and take into account their unique features (e.g. multiple decision criteria, user-defined constraints)
* **Large scale problems, characterized by large sets of data, variables and constraints.** Existing algorithms do not always scale up, some decomposition aspects must be considered (e.g. problem structure, hybrid models, cooperation between solvers)
* **Computationally difficult problems**, i.e. NP-hard problems whose solving requires anyhow a lot of knowledge and experience.

More in this paper [Large Scale Combinatorial Optimization: A Methodological Viewpoint](https://hal.umontpellier.fr/hal-01742376/document)
"""

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

# ## Travelling Salesman Problem with Constraint Programming

md"""
![](images/monalisa1.webp)

Source: [https://www.wired.com/2013/01/traveling-salesman-problem/](https://www.wired.com/2013/01/traveling-salesman-problem/)
"""

md"""
```Prolog
Cities = [X1,X2,X3,X4,X5,X6,X7],
element(X1,[ 0, 4, 8,10, 7,14,15],C1),
element(X2,[ 4, 0, 7, 7,10,12, 5],C2),
element(X3,[ 8, 7, 0, 4, 6, 8,10],C3),
element(X4,[10, 7, 4, 0, 2, 5, 8],C4),
element(X5,[ 7,10, 6, 2, 0, 6, 7],C5),
element(X6,[14,12, 8, 5, 6, 0, 5],C6),
element(X7,[15, 5,10, 8, 7, 5, 0],C7),
Cost #= C1+C2+C3+C4+C5+C6+C7,
circuit(Cities),
labeling([minimize(Cost)], Cities).
```
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
# ### Variables

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
### Constraints
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
### Search process - general introduction
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

* **Constraint propagation** - it is a process in which constraints
  are triggering each other by changing domains of variables. This process is mean to be
  done automatically. We can influence it by constraints.
* **Labelling** - it is a process in which variables are being assigned values from
  their domains.
"""

#nb # %% {"slideshow": {"slide_type":"slide"}}
md"""
### Search process - pseudocode
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

# # What is Constraint Programming good for?

md"""
Constraint programming is very effective for:

* scheduling problems
* time-tabling problems
* assignment problems
* configuration problems
"""

md"""
*Rule of thumb* to choose Constraint Programming approach:

* You need "only" feasible solution
* You need more than one feasible/optimal solutions
* You have effective search strategy
* MIP is not working for your problem
* Highly non-linear or complex constraints
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
* Can struggle with optimization problems.
* Easily can generate all or many solutions. :
* White-box approach where programmer controls search process.
* Both approaches can cooperate
"""

# # Solvers

# ## Open-source solvers

#nb # %% {"slideshow": {"slide_type":"fragment"}}
md"""
The not complete list of open source constraint programming solvers:

* [Choco solver](https://choco-solver.org/)
* [ECLiPSe](https://eclipseclp.org/)
* [Gecode](https://www.gecode.org/)
* [OR-Tools](https://developers.google.com/optimization)
* [MiniZinc](https://www.minizinc.org/)
* [Picat](http://picat-lang.org/)

"""

# ## Commercial solvers

md"""
I am aware of two commercial constraint programming solvers:

* [CPLEX CP Optimizer](https://www.ibm.com/pl-pl/analytics/cplex-cp-optimizer)
* [Sicstus Prolog](https://sicstus.sics.se/)
"""


# # Literature

# ## Books

md"""
I have following books on my shelf:

* [A Quick and Gentle Guide to Constraint Logic Programming via ECLiPSe](http://www.anclp.pl/)
    * There both polish and english version
* [Programming with Constraints](https://mitpress.mit.edu/books/programming-constraints)
* [Principles of Constraint Programming](https://www.amazon.pl/Principles-Constraint-Programming-Krzysztof-Apt/dp/0521125499/ref=asc_df_0521125499/?tag=plshogostdde-21&linkCode=df0&hvadid=504303969727&hvpos=&hvnetw=g&hvrand=14782899227594433475&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=20853&hvtargid=pla-423031644129&psc=1)
* [Constraint-Based Scheduling: Applying Constraint Programming to Scheduling Problems](https://www.amazon.pl/Constraint-Based-Scheduling-Applying-Constraint-Programming/dp/1461355745/ref=sr_1_3?__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3RRXAOTFUU4YG&keywords=constraint+programming&qid=1648842560&sprefix=constraint+programming%2Caps%2C82&sr=8-3)
* [Essentials of Constraint Programming](https://www.amazon.pl/Essentials-Constraint-Programming-Thom-Fr%C3%BChwirth/dp/3642087124/ref=sr_1_6?__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3RRXAOTFUU4YG&keywords=constraint+programming&qid=1648842604&sprefix=constraint+programming%2Caps%2C82&sr=8-6)
* [Constraint Processing](https://www.amazon.pl/Constraint-Processing-Rina-Dechter/dp/1558608907/ref=sr_1_75?__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3RRXAOTFUU4YG&keywords=constraint+programming&qid=1648842680&sprefix=constraint+programming%2Caps%2C82&sr=8-75)
* [Constraint Logic Programming using Eclipse](https://www.amazon.pl/Apt-Constraint-Logic-Programming-Eclipse/dp/0521866286/ref=sr_1_86?__mk_pl_PL=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3RRXAOTFUU4YG&keywords=constraint+programming&qid=1648842737&sprefix=constraint+programming%2Caps%2C82&sr=8-86)
"""

# ## Blogs

md"""
I read following blogs:

* [http://hakank.org/constraint_programming_blog/](http://hakank.org/constraint_programming_blog/)
"""

# # Materials for you

md"""
All code is available at my github account [https://github.com/WitJakuczun/](https://github.com/WitJakuczun).

Repository name is [conf-wdi2022-slaying-dragons-with-constraint-programming](https://github.com/WitJakuczun/conf-wdi2022-slaying-dragons-with-constraint-programming)

Contact information:

* LinkedIn profile: [https://www.linkedin.com/in/jakuczunwit/](https://www.linkedin.com/in/jakuczunwit/)
* email: [wit.jakuczun@gmail.com](wit.jakuczun@gmail.com)
"""
