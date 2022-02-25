install:
	Rscript install.R

run:
	R -e "shiny::runApp('./R')"
