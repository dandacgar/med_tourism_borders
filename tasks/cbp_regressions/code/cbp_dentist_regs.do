use "../input/dentists_cbp_covariates.dta", clear

// Outcome Variables
gen dentist_emp_pc = emp/pop_total
gen dentist_estabs_pc = estabs/pop_total
gen ln_dentist_emp_pc = ln(dentist_emp_pc)
gen ln_dentist_estabs_pc = ln(dentist_estabs_pc)

// Control Variables
gen ln_density = ln(pop_total/landarea)
gen ln_population = ln(pop_total)
gen ln_med_hh_income = ln(med_hh_income)

gen prop_prime = pop_prime/pop_total
gen prop_older = pop_older/pop_total
gen prop_black = pop_black/pop_total
gen prop_hispanic = pop_hispanic/pop_total

// Label Variables
label variable ln_dentist_emp_pc "Log Dental Employment Per Capita"
label variable ln_dentist_estabs_pc "Log Dental Establishments Per Capita"

label variable ln_density "Log Pop. Density"
label variable ln_population "Log Population"
label variable ln_med_hh_income "Log Median. HH Income"

label variable prop_prime "Proportion 25-54"
label variable prop_older "Proportion 55+"
label variable prop_black "Proportion Black"
label variable prop_hispanic "Proportion Hispanic"

label variable mexico_border "Borders Mexico"
label variable counties_from_border "Counties from Border"

// Fixed Effects Variables
gen state_FIPS = substr(county_FIPS,1,2)

// Sample Restrictions
gen sr1 = canada_border == 1 | mexico_border == 1
gen sr2 = counties_from_border <= 1 | mexico_border == 1

gen sr3 = counties_from_border <=5 | mexico_border == 1

// Controls
local controls0
local controls1 ln_population ln_density ln_med_hh_income
local controls2 `controls1' prop_prime
local controls3 `controls1' prop_older
local controls4 `controls1' prop_prime prop_older

local controls5 `controls4' prop_black prop_hispanic

// Regressions

local outcome dentist_emp_pc
eststo clear

foreach controls in controls0 controls1 controls2 controls3 controls4 controls5 {
reghdfe ln_`outcome' mexico_border ``controls'' if sr1 == 1, noabsorb
estadd local state_fe "No"
sum `outcome' if sr1 == 1
estadd local mean `=string(`r(mean)', "%9.3g")'
eststo sr1_`controls'

reghdfe ln_`outcome' mexico_border ``controls'' if sr2 == 1, absorb(state_FIPS)
estadd local state_fe "Yes"
sum `outcome' if sr2 == 1
estadd local mean `=string(`r(mean)', "%9.3g")'
eststo sr2_`controls'

reghdfe ln_`outcome' mexico_border ``controls'' if sr3 == 1, absorb(state_FIPS)
estadd local state_fe "Yes"
sum `outcome' if sr3 == 1
estadd local mean `=string(`r(mean)', "%9.3g")'
eststo sr3_`controls'

reghdfe ln_`outcome' ib5.counties_from_border ``controls'' if sr3 == 1, absorb(state_FIPS)
estadd local state_fe "Yes"
sum `outcome' if sr3 == 1
estadd local mean `=string(`r(mean)', "%9.3g")'
eststo sr3dummies_`controls'
}

esttab sr1_* using "../output/cbp_dentist_regs_can_border.tex", se s(N mean state_fe, labels("N" "Mean" "State FE")) nocons label nomtitles booktabs nonotes addnotes("Standard errors in parentheses. Mean refers to original (non-logged) outcome variable." "* p<0.05, ** p<0.01, *** p<0.001") replace

esttab sr2_* using "../output/cbp_dentist_regs_adj_counties.tex", se s(N mean state_fe, labels("N" "Mean" "State FE")) nocons label nomtitles booktabs nonotes addnotes("Standard errors in parentheses. Mean refers to original (non-logged) outcome variable." "* p<0.05, ** p<0.01, *** p<0.001") replace

esttab sr3_* using "../output/cbp_dentist_regs_adj5_counties.tex", se s(N mean state_fe, labels("N" "Mean" "State FE")) nocons label nomtitles booktabs nonotes addnotes("Standard errors in parentheses. Mean refers to original (non-logged) outcome variable." "* p<0.05, ** p<0.01, *** p<0.001") replace

esttab sr3dummies_* using "../output/cbp_dentist_regs_dummies_adj5_counties.tex", se s(N mean state_fe, labels("N" "Mean" "State FE")) nocons label nomtitles nobaselevels booktabs nonotes addnotes("Standard errors in parentheses. Mean refers to original (non-logged) outcome variable." "* p<0.05, ** p<0.01, *** p<0.001") replace



