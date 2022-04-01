conf-wdi2022-slaying-dragons-with-constraint-programming-introduction-examples.ipynb: conf-wdi2022-slaying-dragons-with-constraint-programming-introduction-examples.jl
	julia --project=. --eval="using Literate; Literate.notebook(\"$?\", \".\"; mdstrings=true)"

conf-wdi2022-slaying-dragons-with-constraint-programming-introduction.ipynb: conf-wdi2022-slaying-dragons-with-constraint-programming-introduction.jl
	julia --project=. --eval="using Literate; Literate.notebook(\"$?\", \".\"; mdstrings=true)"

clean:
	rm conf-wdi2022-slaying-dragons-with-constraint-programming-introduction.ipynb
	rm conf-wdi2022-slaying-dragons-with-constraint-programming-introduction-examples.ipynb

