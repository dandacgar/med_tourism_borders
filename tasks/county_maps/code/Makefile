all: $(addprefix ../output/, \
	dentists_emp_pc_border.png \
	dentists_estabs_pc_border.png \
	amb_health_services_emp_pc_border.png \
	amb_health_services_estabs_pc_border.png)

include ../../generic.make

../output/%_border.png: ../temp/%_border.eps | ../output
	magick -density 300 $< -trim $@

.INTERMEDIATE: $(addprefix ../temp/, \
	us_county_db.dta \
	us_county_coords.dta \
	cb_2023_us_county_5m.shp \
	cb_2023_us_county_5m.dbf)

../temp/%_border.eps: border_maps.do $(addprefix ../input/, dentists_cbp_covariates.dta amb_health_services_cbp_covariates.dta stata_graphics_setup.do) ../temp/us_county_db.dta ../temp/us_county_coords.dta | ../output
	stata-se -e $<

../temp/us_county_db.dta ../temp/us_county_coords.dta: shapefiles_to_dta.do ../temp/cb_2023_us_county_5m.shp ../temp/cb_2023_us_county_5m.dbf | ../output
	stata-se -e $<

../temp/cb_2023_us_county_5m.shp ../temp/cb_2023_us_county_5m.dbf: ../input/cb_2023_us_county_5m.zip | ../temp
	unzip $< $(notdir $@) -d ../temp

../input/stata_graphics_setup.do: ../../setup_environment/code/stata_graphics_setup.do | ../input
	ln -s $< $@

../input/%_cbp_covariates.dta: ../../merge_cbp_covs/output/%_cbp_covariates.dta | ../input
	ln -s $< $@

../input/cb_2023_us_county_5m.zip: ../../downloaddata/output/cb_2023_us_county_5m.zip | ../input
	ln -s $< $@
