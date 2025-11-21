*******************************************
*******************************************

	*ECO 726: Program and Policy Evaluation 

*******************************************
*******************************************


cls 
clear all 

capture cd "C:\Users\Mr. Drakes\Dropbox\ECO 797\2025 797"

capture log close 
log using "ECO726_ResearchPaper_LogFile",replace 


use cps_00005,clear 

//Replace year with year-1 to match the survey year with the work year 

replace year = year-1
**Generate new variable; post 1975 (after the implementation of the EITC)

generate post_1975 = 0

replace post_1975 = 1 if year > 1975
***************************

**Tabulate Nmothers

tab nmothers

**Create variable allowing for mothers to be the treatment group

gen treated = 0

replace treated = 1 if nmothers > 0
****************************
** Create Difference-In-Differences variable

gen did_variable = treated*post_1975
**************************
**Tabulate employment status and create dummy variables to separate employed from unemployed mothers 

tab empstat, generate(employed_dummy)
** Add other employed mothers who didn't work last week

generate employed = 0
replace employed = employed_dummy1 + employed_dummy2

**Tabulate marital status and create dummy variables to separate married from unmarried mothers 

tab marst, generate(married_dummy)
** Generate married variable; Add marital statuses to create married dummy variable 
generate married = 0
replace married = married_dummy1 + married_dummy2 + married_dummy3

**Tabulate race and hispan and generate nonwhite
tab race, generate(race_dummy)
generate nonwhiterace = race_dummy2 + race_dummy3

tab hispan, generate(hispan_dummy)
generate nonwhiteethnicity = hispan_dummy2 + hispan_dummy3 + hispan_dummy4 + hispan_dummy5 + hispan_dummy6 + hispan_dummy7 +hispan_dummy8 + hispan_dummy9 + hispan_dummy10 

generate nonwhite = nonwhiterace + nonwhiteethnicity
**Run DID regression with employed variable with new qualities

didregress (employed) (did_variable), group(treated) time(year)

** Plot Line Graph of Difference-In-Differences
collapse (mean) employed, by(year nmothers)
twoway ///
    (line employed year if nmothers==0, lcolor(blue) lpattern(solid) lwidth(medthick) ///
        msymbol(circle) mcolor(blue)) ///
    (line employed year if nmothers==1, lcolor(red) lpattern(dash) lwidth(medthick) ///
        msymbol(triangle) mcolor(red)), ///
    legend(order(1 "Control" 2 "Treated")) ///
    xtitle("Year") ytitle("Employment Status") ///
    title("Difference-in-Differences Plot") ///
	xline(1975) 

**Run trendplots for graphical representation

estat trendplots

**Run a test for parallel trends

estat ptrends 

**Conduct a Granger causality test

estat granger

translate ECO726_ResearchPaper_LogFile.smcl ECO726_ResearchPaper_LogFile.pdf, replace


log close 

