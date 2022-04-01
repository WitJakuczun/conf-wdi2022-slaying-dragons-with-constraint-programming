NB_FILES = conf-wdi2022-slaying-dragons-with-constraint-programming-introduction.ipynb conf-wdi2022-slaying-dragons-with-constraint-programming-introduction-examples.ipynb

all: $(NB_FILES)
	@echo $(inputs)

%.ipynb: %.jl
	julia --project=. --eval="using Literate; Literate.notebook(\"$^\", \".\"; mdstrings=true)"

clean:
	rm conf-wdi2022-slaying-dragons-with-constraint-programming-introduction.ipynb
	rm conf-wdi2022-slaying-dragons-with-constraint-programming-introduction-examples.ipynb

