/*  This do file should be used with the "toy" dataset */
insheet using  toy_data.csv, clear

/* In this do file we will generate new variables for the metric versions of height.  We will also create variables for height and age categories and we will recode the sex variable */

/* close any open log file and open a new one.  Note, the capture command allows the do file to proceed even if the line would produce an error.  In this situation, it will close an open log if there is one, but will proceed to the next step if no log was open */
capture log close
log using newvariables.log, replace

/* first we will convert weight in pounds to weight in kg. */
cap drop htmetric
/* Capture intercepts an error message and allow the do-file to continue. In this case we will drop htmetric if it is already in the data set, but will proceed without interruption if it is not.  This is a good trick to use if you are generating variables in a dofile */
g htmetric = ht*0.0254
label variable htmetric "height (meters)"
su htmetric ht

/* Silly example of creating a variable "tall", just to show use of relational operators*/

capture drop tall
gen tall=0
replace tall=1 if (sex=="F" & ht >=68) | (sex=="M" & ht >=72)

/*Note: we had to put "F" and "M" in quotes, since sex is a string variable*/

/* Question:  What happened to the individual who was missing data for ht? */
/* Two options to deal with the missing value
1) we can replace the person now */

replace tall=. if ht==.

/* or 2) we can pay attention to missing when generating our variables */

capture drop tall
gen tall=0
replace tall=1 if (sex=="F" & ht >=68 & ht <.) | (sex=="M" & ht >=72 & ht <.)

capture label drop tall_label
label define tall_label 0 "short" 1 "tall"
label values tall tall_label

format ht htmetric %9.2f
bys sex: tabstat ht htmetric, by(tall) stat(min max n) format
note tall: this is an indicator variable that arbitrarily sets males as "tall" if they are 72 inches or taller, and women as "tall" if they are 68 inches or taller
describe tall ht htmetric

/* Generating age categories */
capture drop agecategory
generate agecategory=age
recode agecategory (min/20=0) (20/30=1) (30/40=2) (40/50=3) (50/60=4) (60/70=5)(70/max=6)(miss=.)
label variable agecategory "10 year categories"
bys agecategory: sum age

/* Next we will categorize ht into quartiles */
tabstat ht, stats(p25, p50, p75)
capture drop htcat
gen htcat=(ht>62)+(ht>67)+(ht>69)
bys htcat: summarize ht

/* An ADVANCED OPTION for making quartiles uses the "return" ("r()") to specify the cutpoints.  We will cover return in more detail later in the class */
sum ht, detail
gen htcat2=(ht>r(p25))+(ht>r(p50))+(ht>r(p75))
replace htcat2=. if ht==.
bys htcat2: summarize ht

/* A third "quick and dirty" way to do this is to just sort the variable and then create four groups.  This method is not recommended if a lot of people have the same value.  Why? */
sort ht
capture drop htcat3
gen htcat3=group(4)
bys htcat3: summarize ht

/* An example of encode, creating a numeric variable for sex */
capture drop gender
encode sex, generate(gender)
tab sex gender
sum sex gender
tab gender if gender==1

/* An example of an egen command.  Creating groups formed by case and sex */
capture drop groups
egen groups = group(case sex)
bys groups: list case sex 

log close

