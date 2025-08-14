import delimited using "../temp/county_med_hh_income.dat", clear

// Counties Only
keep if substr(geo_id,1,7) == "0500000"

// Generate County FIPS
gen county_FIPS = substr(geo_id,10,5)

// Rename Median Household Income Variable
rename b19013_e001 med_hh_income

// Keep Variables

