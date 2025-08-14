all: $(addprefix ../output/, \
	$(foreach stub, can_border adj_counties adj5_counties dummies_adj5_counties, \
	cbp_dentist_regs_$(stub).tex))

include ../../generic.make

../output/cbp_dentist_regs_%.tex: cbp_dentist_regs.do ../input/dentists_cbp_covariates.dta | ../output
	stata-se -e $<

../input/dentists_cbp_covariates.dta: ../../merge_cbp_covs/output/dentists_cbp_covariates.dta | ../input
	ln -s $< $@
