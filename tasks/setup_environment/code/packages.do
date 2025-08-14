local PACKAGES estout reghdfe

foreach package in `PACKAGES' {
capture which `package'
if _rc==111 ssc install `package'
}

file open outfile using "../output/stata_packages.txt", write replace text
file write outfile "Successfully installed: `PACKAGES'" _n
file close outfile
