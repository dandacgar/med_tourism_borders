infix str county_FIPS 1-5 str med_hh_income 7-12 using "../input/county_med_hh_income.txt", clear

destring med_hh_income, replace

replace med_hh_income = . if med_hh_income == -66666 // Flagged Data

save "../output/county_med_hh_income.dta", replace
