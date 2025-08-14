all: $(addprefix ../output/, \
	cbp23co.dta \
	cb_2023_us_county_5m.zip \
	tl_2023_us_internationalboundary.zip \
	county_population_counts.csv \
	2023_Gaz_counties_national.txt \
	county_adjacency.txt \
	county_med_hh_income.txt)

include ../../generic.make

# U.S. County Borders
../output/cb_2023_us_county_5m.zip: | ../output
	wget --no-check-certificate "https://www2.census.gov/geo/tiger/GENZ2023/shp/cb_2023_us_county_5m.zip" -O $@

../output/tl_2023_us_internationalboundary.zip: | ../output
	wget --no-check-certificate "https://www2.census.gov/geo/tiger/TIGER2023/INTERNATIONALBOUNDARY/tl_2023_us_internationalboundary.zip" -O $@

# U.S. County Business Patterns
../output/cbp23co.dta: import_cbp.do ../temp/cbp23co.txt |  ../output
	stata-se -e $<

.INTERMEDIATE: ../temp/cbp23co.txt ../temp/cbp23co.zip

../temp/cbp23co.txt: ../temp/cbp23co.zip | ../temp
	unzip $< $(notdir $@) -d ../temp 

../temp/cbp23co.zip: | ../temp
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/cbp/datasets/2023/cbp23co.zip" -O $@

# U.S. County Population Counts
../output/county_population_counts.csv: | ../output
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/popest/datasets/2020-2023/counties/asrh/cc-est2023-alldata.csv" -O $@ 

# U.S. County Median HH Income

../output/county_med_hh_income.txt: ../temp/county_med_hh_income.dat | ../output
	grep '^0500000US' $< | sed -E 's/^0500000US([0-9]+)\|/\1|/' | cut -d'|' -f1,2 > $@

.INTERMEDIATE: ../temp/county_med_hh_income.dat

../temp/county_med_hh_income.dat: | ../temp
	wget --no-check-certificate "https://www2.census.gov/programs-surveys/acs/summary_file/2023/table-based-SF/data/5YRData/acsdt5y2023-b19013.dat" -O $@ 

# U.S. County Sizes
../output/2023_Gaz_counties_national.txt: ../temp/2023_Gaz_counties_national.zip | ../output
	unzip $< $(notdir $@) -d ../output

.INTERMEDIATE: ../temp/2023_Gaz_counties_national.zip

../temp/2023_Gaz_counties_national.zip: | ../temp
	wget --no-check-certificate "https://www2.census.gov/geo/docs/maps-data/data/gazetteer/2023_Gazetteer/2023_Gaz_counties_national.zip" -O $@

# U.S. County Adjacency
../output/county_adjacency.txt: | ../output
	wget --no-check-certificate "https://www2.census.gov/geo/docs/reference/county_adjacency/county_adjacency2023.txt" -O $@ 
