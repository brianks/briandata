/* This do file can be found at http://students.washington.edu/chutter/Intro_to_STATA/Session1.do */
/* created by Carolyn Hutter, September25, 2007 */

/* close any open log file and open a new one.  Note, the capture command allows the do file to proceed even if the line would produce an error.  In this situation, it will close an open log if there is one, but will proceed to the next step if no log was open */
capture log close
log using descriptives.log, replace
insheet using http://students.washington.edu/chutter/Intro_to_STATA/toy_data.csv, comma clear

/* In this do file we will explore the data using table, tabulate, summarize and tabstat */

table case
table sex case
table ht sex case

tabulate sex
tabulate sex, missing
tabulate sex case
tabulate sex case, row column chi2

summarize age
summarize age, detail

tabstat ht
/* I am introducing format here, we will discuss this command more next week */
format ht %9.2f 
tabstat ht, format
tabstat ht, stat(mean sd p25 p50 p75) format
tabstat ht, by(sex) stat(mean sd min max n) format
tabstat ht age, by(sex) stat(mean sd min max n) columns(stat) format

** Here we will promote good-bye habits by :
** (1) closing the log
log close
** (2) check the status of the log
log
** (3) saving the working data (ie, _dta) into the C:\ directory:
save "toy_data.dta", replace
