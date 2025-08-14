all: $(addprefix ../output/, \
	counties_bordering_canada_mexico.dta \
	counties_from_mexico_border.dta)

include ../../generic.make

.INTERMEDIATE: ../temp/counties_bordering_canada_mexico.csv

../output/counties_from_mexico_border.dta ../output/counties_bordering_canada_mexico.dta: counties_from_mexico_border.do  ../temp/counties_bordering_canada_mexico.csv ../input/county_adjacency.txt | ../output
	stata-se -e $<

../temp/counties_bordering_canada_mexico.csv: identify_border_counties.py $(addprefix ../input/, cb_2023_us_county_5m.zip tl_2023_us_internationalboundary.zip) | ../temp
	python $<

../input/cb_2023_us_county_5m.zip: ../../downloaddata/output/cb_2023_us_county_5m.zip | ../input
	ln -s $< $@

../input/tl_2023_us_internationalboundary.zip: ../../downloaddata/output/tl_2023_us_internationalboundary.zip | ../input
	ln -s $< $@

../input/county_adjacency.txt: ../../downloaddata/output/county_adjacency.txt | ../input
	ln -s $< $@
