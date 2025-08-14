// Setup Shapefiles
use ../temp/us_county_db.dta, clear

gen county_FIPS = STATEFP + COUNTYFP

rename STATEFP state_FIPS

keep state_FIPS county_FIPS id

tempfile usdb
save `usdb'

// Industry Titles
local dentists_title "Dental"
local amb_health_services_title "Ambulatory Health Services"

// Maps
do "../input/stata_graphics_setup.do"

foreach industry in dentists amb_health_services {
use "../input/`industry'_cbp_covariates.dta", clear

merge 1:1 county_FIPS using `usdb', nogen

gen `industry'_emp_pc = emp/pop_total
gen `industry'_estabs_pc = estabs/pop_total

// Maps
spmap `industry'_emp_pc using "../temp/us_county_coords.dta" if inlist(state_FIPS, "06", "04", "35", "48"), id(id) ///
 fcolor("255 255 212" "254 217 142" "254 153 41" "204 76 2") title("``industry'_title' Employment per Capita") ///
 legend(size(4))
 graph export "../temp/`industry'_emp_pc_border.eps", replace
 
 spmap `industry'_estabs_pc using "../temp/us_county_coords.dta" if inlist(state_FIPS, "06", "04", "35", "48"), id(id) ///
 fcolor("255 255 212" "254 217 142" "254 153 41" "204 76 2") title("``industry'_title' Establishments per Capita") ///
 legend(size(4))
 graph export "../temp/`industry'_estabs_pc_border.eps", replace
}
