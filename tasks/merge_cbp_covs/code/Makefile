all: $(addprefix ../output/, \
	dentists_cbp_covariates.dta \
	amb_health_services_cbp_covariates.dta)

include ../../generic.make

COVS := $(addprefix ../input/, \
	county_demo_populations.dta \
	county_sizes.dta \
	county_med_hh_income.dta)

BORDERS := $(addprefix ../input/, \
	counties_bordering_canada_mexico.dta \
	counties_from_mexico_border.dta)

../output/%_cbp_covariates.dta: merge_cbp_dentists.do ../input/cbp23co.dta $(COVS) $(BORDERS) | ../output
	stata-se -e $< $*

$(COVS): ../input/%: ../../county_covariates/output/% | ../input
	ln -s $< $@

$(BORDERS): ../input/%: ../../counties_borders/output/% | ../input
	ln -s $< $@

../input/cbp23co.dta: ../../downloaddata/output/cbp23co.dta | ../input
	ln -s $< $@


