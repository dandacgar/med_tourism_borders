import delimited "../temp/cbp23co.txt", clear

// Rename Variables
rename (naics ap_nf ap) (NAICS payroll_nf payroll)

rename est n
rename n5 n5less
rename n1000_1 n1000_1499
rename n1000_2 n1500_2499
rename n1000_3 n2500_4999
rename n1000_4 n5000more
rename n* estabs*

// Generate County FIPS as str5
gen str5 county_FIPS = string(fipstate * 1000 + fipscty, "%05.0f")

// Clean/Reformat Variables
foreach var of varlist *_nf {
	encode `var', gen(`var'_temp) // Noise Flags are Alphabetical (G, H, J)
	label define `var'_lbl 1 "<2% Noise" 2 "2-5% Noise" 3 ">5% Noise"
	label values `var'_temp `var'_lbl
	drop `var'
	rename `var'_temp `var'
}

foreach var of varlist estabs* {
destring `var', ignore(N) replace // N stands for Not Available or Not Comparable
}

save "../output/cbp23co.dta", replace
