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

// Counties From Border MAp
use "../input/counties_from_mexico_border.dta", clear

merge 1:1 county_FIPS using `usdb', nogen keep(1 2 3)

spmap counties_from_border using "../temp/us_county_coords.dta" if inlist(state_FIPS, "04", "06", "08", "32", "35", "48", "49") & counties_from_border < 2, id(id)

spmap counties_from_border using "../temp/us_county_coords.dta" if inlist(state_FIPS, "04", "06", "08", "32", "35", "48", "49"), id(id) ///
 fcolor("153 52 4" "217 95 14" "254 153 41" "254 196 79" "254 227 145" "255 255 212") title("Counties From U.S.-Mexico Border") ///
 clmethod(custom) clnumber(6) clbreaks(-.5 .5 1.5 2.5 3.5 4.5 5.5) ///
 legend(size(4) order(1 ">5" 6 "5" 6 "4" 5 "3" 4 "2" 3 "1" 2 "0")) 
graph export "../temp/counties_from_border.eps", replace
 
// Per Capita Maps
foreach industry in dentists amb_health_services {
use "../input/`industry'_cbp_covariates.dta", clear

merge 1:1 county_FIPS using `usdb', nogen keep(2 3)

gen `industry'_emp_pc = emp/pop_total
gen `industry'_estabs_pc = estabs/pop_total

// Maps
spmap `industry'_emp_pc using "../temp/us_county_coords.dta" if inlist(state_FIPS, "04", "06", "08", "32", "35", "48", "49"), id(id) ///
 fcolor("255 255 212" "254 217 142" "254 153 41" "204 76 2") title("``industry'_title' Employment per Capita") ///
 legend(size(4))
 graph export "../temp/`industry'_emp_pc_border.eps", replace
 
 spmap `industry'_estabs_pc using "../temp/us_county_coords.dta" if inlist(state_FIPS, "04", "06", "08", "32", "35", "48", "49"), id(id) ///
 fcolor("255 255 212" "254 217 142" "254 153 41" "204 76 2") title("``industry'_title' Establishments per Capita") ///
 legend(size(4))
 graph export "../temp/`industry'_estabs_pc_border.eps", replace
}
