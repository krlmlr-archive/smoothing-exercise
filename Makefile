all: smooth.md

%.md: %.R
	Rscript -e "library(knitr); spin('$<')"

