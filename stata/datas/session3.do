/* Exercise:
Do the following using STATA.  
*/

* 1. Set your default directory
cd f:/stataclass

* 2. Start a log file (have it be a text file, rather than a smcl file) 
capture log close
log using session4_review.txt, text replace

* 3. Open the dataset new_toy_data.dta (this is a STATA 10 dataset.  If you are using an earlier version of STATA you will need to insheet toy_data.csv)
use "new_toy_data.dta", replace

* 4. Open a new do file, and type commands in the do file, rather than on the command line. 

* OPEN DO FILE
* 5. Generate a new variable that has the value 0 for people who are 60 years of age or younger and 1 for people who are over 60 (make sure your variable would handle missing variables correctly).
gen over60=0 if age<=60
replace over60=1 if age>60

* 6. Label this variable, and the values for this variable
label variable over60 "indicator for age>60 years"
label define over60_label 0 "<=60" 1 ">60"
label values over60 over60_label

* 7. Find the mean, standard deviation, minimum and maximum for age, separately for people who are 60 years of age or younger and for people who are 60 or over.
bys over60: sum age
tabstat age, stat(mean sd min max) by(over60)

* 8. Format the age and ht variables so that they will display with 2 digits after the decimal place. 
format age ht %9.2f

* 9. Make a table of mean, sd, 25th%, median, 75th% and interquartile range of the variables age and height for males and for females.  Format this output to show 2 digits after the decimal place.  
tabstat age ht, stat(mean sd q iqr) by(sex) format col(stat) long

* 10. Put this table in a word or excel document, and format it to look pretty.

* 11. Create a scatter plot of age vs. height
scatter ht age

* 12. Create a graph that has three panels: 1) scatter plot of age vs. height for males; 2) scatter plot of age vs. height for females; 3) scatter plot of age vs. height for total sample.  Make sure this graph has an appropriate title.
scatter ht age, by(sex, total col(3) title("scatter plot of age vs height, by sex")) xlab(,format(%9.0f)) 

* 13. Export this graph as a windows metafile and insert it in a word document.
graph export ht_age_bysex.wmf, as(wmf)

* 14. Use drop (and/or keep) to make your dataset only have females who are over 50.
keep if sex=="F"
drop if age<=50

* 15. Do appropriate descriptive statistics to make sure you dropped (kept) the right people.  Determine how many individuals are in your new dataset.
tab sex
sum age

* 15. Close your log and open it in Microsoft Word.
log close