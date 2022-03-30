julia --project=. --eval="using Literate; Literate.notebook(\"test.jl\", \".\"; mdstrings=true)"
/Users/witj/.julia/conda/3/bin/jupyter nbconvert --to=slides test.ipynb
