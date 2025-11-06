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

**Run DID regression with employed variable with new qualities

didregress (employed) (did_variable), group(treated) time(year)

**Run trendplots for graphical representation

estat trendplots

**Run a test for parallel trends

estat ptrends 

**Conduct a Granger causality test

estat granger

translate ECO726_ResearchPaper_LogFile.smcl ECO726_ResearchPaper_LogFile.pdf, replace


log close 

