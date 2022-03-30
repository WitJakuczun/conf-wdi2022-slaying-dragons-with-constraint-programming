SRC_JULIA_FILE=$1.jl
OUT_IPYNB_FILE=$1.ipynb
julia --project=. --eval="using Literate; Literate.notebook(\"$SRC_JULIA_FILE\", \".\"; mdstrings=true)"
/Users/witj/.julia/conda/3/bin/jupyter nbconvert --to=slides $OUT_IPYNB_FILE
