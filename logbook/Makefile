logbookentries := $(shell grep 'entries' logbook.tex | grep -v '^%' | grep -o 'entries/[A-Za-z0-9_]*\.tex')
logbookfigures := $(shell grep 'figures/' $(logbookentries) | grep -v '^%' | sed 's/ %.*//' | grep -o 'figures/[A-Za-z0-9_/]*\.[a-z]*')
logbookdatedentries := $(shell grep 'entries/202[5-9]' logbook.tex | grep -v '^%' | grep -o 'entries/[A-Za-z0-9_]*\.tex')
logbookinputs := $(shell grep 'input/' $(logbookdatedentries) | grep -v '^%' | sed 's/ %.*//' | grep -o 'input/[A-Za-z0-9_]*\.[a-z]*')

all: logbook.pdf 

input:
	mkdir $@

logbook.pdf: logbook.tex $(logbookentries) $(logbookinputs) $(logbookfigures)
	pdflatex -draftmode $<
	-bibtex $(basename $<).aux
	pdflatex -draftmode $<
	pdflatex $<
	rm $(addprefix $(basename $<),.log .out .toc .aux)
	-rm $(addprefix $(basename $<),.bbl .blg)

.PHONY: clean
clean:
	-rm *.aux *.log *.toc *.out
	-rm *.bbl *.blg

# Logbook Inputs

find_inputs: 
	./find_inputs.sh $(logbookinputs)

input/cbp_dentist_regs_can_border.tex: ../tasks/cbp_regressions/output/cbp_dentist_regs_can_border.tex | input
	ln -s ../$< $@
input/cbp_dentist_regs_adj_counties.tex: ../tasks/cbp_regressions/output/cbp_dentist_regs_adj_counties.tex | input
	ln -s ../$< $@
input/cbp_dentist_regs_adj5_counties.tex: ../tasks/cbp_regressions/output/cbp_dentist_regs_adj5_counties.tex | input
	ln -s ../$< $@
input/cbp_dentist_regs_dummies_adj5_counties.tex: ../tasks/cbp_regressions/output/cbp_dentist_regs_dummies_adj5_counties.tex | input
	ln -s ../$< $@
input/dentists_emp_pc_border.png: ../tasks/county_maps/output/dentists_emp_pc_border.png | input
	ln -s ../$< $@
input/dentists_estabs_pc_border.png: ../tasks/county_maps/output/dentists_estabs_pc_border.png | input
	ln -s ../$< $@
input/amb_health_services_emp_pc_border.png: ../tasks/county_maps/output/amb_health_services_emp_pc_border.png | input
	ln -s ../$< $@
input/amb_health_services_estabs_pc_border.png: ../tasks/county_maps/output/amb_health_services_estabs_pc_border.png | input
	ln -s ../$< $@
