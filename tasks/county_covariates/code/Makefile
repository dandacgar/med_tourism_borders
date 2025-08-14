all: $(addprefix ../output/, \
	county_demo_populations.dta \
	county_sizes.dta \
	county_med_hh_income.dta)

include ../../generic.make

../output/county_demo_populations.dta: clean_pop_counts.do ../input/county_population_counts.csv | ../output
	stata-se -e $<

../output/county_sizes.dta: clean_sizes.do ../input/2023_Gaz_counties_national.txt | ../output
	stata-se -e $<

../output/county_med_hh_income.dta: clean_med_hh_income.do ../input/county_med_hh_income.txt | ../output
	stata-se -e $<

../input/county_med_hh_income.txt: ../../downloaddata/output/county_med_hh_income.txt | ../input
	ln -s $< $@

../input/county_population_counts.csv: ../../downloaddata/output/county_population_counts.csv | ../input
	ln -s $< $@

../input/2023_Gaz_counties_national.txt: ../../downloaddata/output/2023_Gaz_counties_national.txt | ../input
	ln -s $< $@
