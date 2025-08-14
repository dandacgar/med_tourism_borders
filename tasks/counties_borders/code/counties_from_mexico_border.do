import delimited "../input/county_adjacency.txt", clear

// Remove Self-Reference As Bordering County
drop if countygeoid == neighborgeoid

// Generate County FIPS Variable
gen county_FIPS = string(countygeoid, "%05.0f")
gen neighbor_FIPS = string(neighborgeoid, "%05.0f")

tempfile neighbors
save `neighbors'

// Import Canada/Mexico Border Counties
import delimited "../temp/counties_bordering_canada_mexico.csv", clear

// Generate County FIPS Variable
gen county_FIPS = string(geoid, "%05.0f")

keep county_FIPS border

save "../output/counties_bordering_canada_mexico.dta", replace

// Keep Only Mexico Border Counties
keep if border == "Mexico"

keep county_FIPS
gen counties_from_border = 0

tempfile base
save `base' // Iterate Appends On this Dataset

// Loop Through Five Adjacencies

foreach adj of numlist 1/5 {
use `base', clear
keep if counties_from_border == `adj'-1

merge 1:m county_FIPS using `neighbors', nogen keep(3)
* Master-only (#1) are base counties in question, not bordering any other U.S. counties (none)
* Using-only (#2) are counties bordering other U.S. counties, but not counties in question
* Matched (#3) are counties in question and their neighbors

keep neighbor_FIPS
rename neighbor_FIPS county_FIPS

duplicates drop

gen counties_from_border = `adj'

append using `base'

tempfile base
save `base'
}

// Keep Only Minimum
collapse (min) counties_from_border, by(county_FIPS)

save "../output/counties_from_mexico_border.dta", replace
