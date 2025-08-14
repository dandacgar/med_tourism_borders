
use "../input/cbp23co.dta", clear

// Keeping Dental Offices (NAICS 6212--)
keep if NAICS == "6212//"

count
* 2,092 counties have dentist counts

// Merge in County Demographics/Sizes
merge 1:1 county_FIPS using "../input/county_demo_populations.dta", nogen keep(1 3)
merge 1:1 county_FIPS using "../input/county_sizes.dta", nogen keep(1 3)
merge 1:1 county_FIPS using "../input/county_med_hh_income.dta", nogen keep(1 3)

// Merge in County Border Information
merge 1:1 county_FIPS using "../input/counties_from_mexico_border.dta", nogen keep(1 3)
merge 1:1 county_FIPS using "../input/counties_bordering_canada_mexico.dta", nogen keep(1 3)

gen canada_border = border == "Canada"
gen mexico_border = border == "Mexico"

// Save Variables
order county_FIPS border NAICS emp* payroll* estabs* pop_* med_hh_income landarea *_border
keep county_FIPS border NAICS emp* payroll* estabs* pop_* med_hh_income landarea *_border

save "../output/dentists_cbp_covariates.dta", replace
