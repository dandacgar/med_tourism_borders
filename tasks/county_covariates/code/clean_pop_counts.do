import delimited "../input/county_population_counts.csv", clear

// Keep 2023 Estimate
keep if year == 5 // 5 corresponds to July 2023

// Generate County FIPS Variable
gen county_FIPS = string(state *1000 + county, "%05.0f")

// Total, Black, and Hispanic Population
preserve
collapse (sum) pop_total=tot_pop bac_male bac_female h_male h_female, by(county_FIPS)

gen pop_black = bac_male + bac_female // Using Black alone OR in combination
gen pop_hispanic = h_male + h_female // Using Hispanic (any) definition

keep county_FIPS pop_total pop_black pop_hispanic

tempfile tbh_pops
save `tbh_pops'
restore

// Prime-Age (25-54) Population
preserve
keep if inrange(agegrp, 6, 11)
collapse (sum) pop_prime=tot_pop, by(county_FIPS)

keep county_FIPS pop_prime

tempfile prime_pops
save `prime_pops'
restore

// Older (55+) Population
preserve
keep if inrange(agegrp, 12, 18)
collapse (sum) pop_older=tot_pop, by(county_FIPS)

keep county_FIPS pop_older

tempfile older_pops
save `older_pops'
restore

// Merge
use `tbh_pops', clear
merge 1:1 county_FIPS using `prime_pops', nogen
merge 1:1 county_FIPS using `older_pops', nogen

save "../output/county_demo_populations.dta", replace
