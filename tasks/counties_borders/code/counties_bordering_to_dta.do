import delimited "../temp/counties_bordering_canada_mexico.csv", clear

// Generate County FIPS Variable
gen county_FIPS = string(geoid, "%05.0f")

keep county_FIPS border

save "../temp/counties_bordering_canada_mexico.dta", replace
save "../output/counties_bordering_canada_mexico.dta", replace
