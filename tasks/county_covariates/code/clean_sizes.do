import delimited "../input/2023_Gaz_counties_national.txt", clear

// Generate County FIPS
gen county_FIPS = string(geoid, "%05.0f")

rename aland_sqmi landarea

// Keep Variables
keep county_FIPS landarea

// Label Variables
label variable landarea "Land Area (Sq. Miles)"

save "../output/county_sizes.dta", replace
