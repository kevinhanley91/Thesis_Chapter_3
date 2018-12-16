title 'LCA Postgrad Student Experience';
options nodate formdlim='*';

*Reading in the Data from an excel file;
PROC IMPORT OUT=WorkingData DATAFILE= "F:\0861537961\Chapter 3 - Latent Class Analysis\Code\Changed Data.xlsx" 
            DBMS=xlsx REPLACE;
     GETNAMES=YES;
RUN;

proc print data=WorkingData;
run;

proc format; 
value genderf 1 = 'Male'
			  2 = 'Female'
			  .  = 'Unavailable';
value nationf 1 = 'Irish'
		      2 = 'Other EU'
		      3 = 'Non-EU'
			  . = 'Missing';
value collegef 2 = 'Arts,Celtic Studies'
		       3 = 'Business'
		       4 = 'Medicine'
		       5 = 'SEFS'
			   . = 'Missing';
value degreef  1 = 'Higher Diploma'
		       2 = 'Postgraduate Certificate'
		       3 = 'Postgraduate Diploma'
		       4 = 'Masters Degree'
			   . = 'Missing';
value statusf 1 = 'Full Time Student'
			  2 = 'Part Time Student'
              . = 'Missing';
value yearf 1 = 'First Year'
            2 = 'Second Year'
            . = 'Missing';
value entryf 1 = 'UCC Graduate'
             2 = 'Other Institute'
             . = 'Missing';
value satisfactionf 1 = 'Very Dissatisfied'
                    2 = 'Dissatisfied'
                    3 = 'Neither Satisfied or Dissatisfied' 
					4 = 'Satisfied' 
					5 = 'Very Satisfied'
                    . = 'Missing';
value teachf 1 = 'Strongly Disagree'
             2 = 'Disagree'
             3 = 'Uncertain' 
			 4 = 'Agree' 
			 5 = 'Strongly Agree'
             . = 'Missing';
run;

data sample;
set workingdata;
label V1 = 'Gender';
label V2 = 'Nationality';
label V4 = 'College';
label V5 = 'Degree';
label V6='Status of a Student';
label V7='Year of Study';
label V8=' Process of Entry';
label V9='Level of Overall Satistaction';
format V1 genderf.
	   V2 nationf.
	   V4 collegef.
	   V5 degreef.
	   V6 statusf.
       V7 yearf.
       V8 entryf.
       V9 satisfactionf.
	   V14A teachf.
	   V14B teachf.
	   V14C teachf.
	   V14D teachf.
	   V14E teachf.
	   V14F teachf.
	   V15A teachf.
	   V15B teachf.
	   V15C teachf.
	   V15D teachf.
	   V15E teachf.
	   V15F teachf.
	   V15G teachf.
	   V15H teachf.
	   V15I teachf.
	   V15J teachf.
	   V15K teachf.
	   V15L teachf.
	   V15M teachf.
run;
proc contents data=sample;
run;
proc print data=sample(obs=20);
run;

/* 
	Missing entries removed 
*/
data complete_info;
	set sample;
	miss_n = nmiss(V14A,V14B,V14C,V14D,V14E,V14F,V15A,V15B,V15C,V15D,V15E,V15F,V15G,V15H,V15I,V15J,V15K,V15L,V15M);
	complete = 0;
	if miss_n > 0 then complete = 0;
	if miss_n =0 then complete =1;
	label miss_n = 'Are there missing values';
run;

proc print data = complete_info (obs = 20);
run;

data analysis;
set complete_info;
if complete = 1;
run;

proc print data = analysis;
run;

proc contents data =analysis;
run;

proc freq data=analysis;
run;

/*
		Comparing the Missing Observations to the Complete to ensure no bias has been introduced
*/
data delete;
	set complete_info;
	if complete = 0;
run;

proc print data = delete ;
run;

* Missing;
proc gchart data = delete;
	hbar  V1 V2 V4 V5 V6 V7 V8 V9 / nozero;
run;

*Complete;
proc gchart data = analysis;
	hbar  V1 V2 V4 V5 V6 V7 V8 V9 / nozero;
run;

* Missing;
proc freq data = delete;
	tables  V1 V2 V4 V5 V6 V7 V8 V9;
run; 

* Complete;
proc freq data = analysis;
	tables  V1 V2 V4 V5 V6 V7 V8 V9;
run; 

*Missing;
proc means data=delete median;
	var V1 V2 V4 V5 V6 V7 V8 V9;
run;

*Complete;
proc means data=delete median;
	var V1 V2 V4 V5 V6 V7 V8 V9;
run;



* Dichotomising the data to positive and non-positive responses;
proc format;
	value positivef 2 = 'Positive'
					1 = 'Non-Positive'
					. = 'Missing'
run;

data grouped;
set analysis;
GTS1 = .; GTS2 = .; GTS3 = .; GTS4 = .; GTS5 = .; GTS6 = .;
AWS1 = .; AWS2 = .; AWS3 = .; AWS4 = .;
MS1 = .; MS2 = .; MS3 = .; MS4 = .; MS5 = .; MS6 = .;  MS7 = .; MS8 = .; MS9 = .;
if V14A = 4 or V14A = 5 then GTS1 = 2; 		* here 1 is a positive response and 2 is a non-positive response;
		else GTS1 = 1;
if V14B = 4 or V14B = 5 then GTS2 = 2;
		else GTS2 = 1;
if V14C = 4 or V14C = 5 then GTS3 = 2;
		else GTS3 = 1;
if V14D = 4 or V14D = 5 then GTS4 = 2;
		else GTS4 = 1;
if V14E = 4 or V14E = 5 then GTS5 = 2;
		else GTS5 = 1;
if V14F = 4 or V14F = 5 then GTS6 = 2;
		else GTS6 = 1;
if V15A = 1 or V15A = 2 then AWS1 = 2;
		else AWS1 = 1;
if V15B = 1 or V15B = 2 then AWS2 = 2;
		else AWS2 = 1;
if V15C = 4 or V15C = 5 then AWS3 = 2;
		else AWS3 = 1;
if V15D = 1 or V15D = 2 then AWS4 = 2;
		else AWS4 = 1;
if V15E = 4 or V15E = 5 then MS1 = 2;
		else MS1 = 1;
if V15F = 4 or V15F = 5 then MS2 = 2;
		else MS2 = 1;
if V15G = 4 or V15G = 5 then MS3 = 2;
		else MS3 = 1;
if V15H = 4 or V15H = 5 then MS4 = 2;
		else MS4 = 1;
if V15I = 4 or V15I = 5 then MS5 = 2;
		else MS5 = 1;
if V15J = 1 or V15J = 2 then MS6 = 2;
		else MS6 = 1;
if V15K = 1 or V15K = 2 then MS7 = 2;
		else MS7 = 1;
if V15L = 4 or V15L = 5 then MS8 = 2;
		else MS8 = 1;
if V15M = 4 or V15M = 5 then MS9 = 2;
		else MS9 = 1;
label GTS1 = 'My lecturers normally give me helpful feedback on my progress';
label GTS2 = 'My lecturers in this programme motivate me to do my best work';
label GTS3 = 'My lecturers make a real effort to understand any difficulties I have';
label GTS4 = 'My lecturers are extremely good at explaining things';
label GTS5 = 'My lecturers work hard to make their subjects interesting';
label GTS6 = 'My lecturers put a lot of time into comments (orally and/or in writing) on my work';
label AWS1 = 'There is a lot of unwanted academic pressure on me as a student';
label AWS2 = 'My academic workload is too heavy';
label AWS3 = 'I am generally given enough time to understand things I have learned';
label AWS4 = 'The volume of work necessary for my programme of study means that it cannot all be thoroughly comprehended';
label MS1 = 'My programme of study is intellectually stimulating';
label MS2 = 'I find my programme of study motivating';
label MS3 = 'My programme of study has stimulated my enthusiasm for further learning';
label MS4 = 'My programme of study has stimulated my interest in the field';
label MS5 = 'I feel that I benefit from being in contact with active researchers/scholars';
label MS6 = 'The academic expectations of me on my programme of study are too high';
label MS7 = 'Intellectual standards at UCC are set too high';
label MS8 = 'I feel part of a community of scholars who are committed to learning';
label MS9 = 'Being selected to study at UCC is a source of motivation to me';
format GTS1 positivef. GTS2 positivef. GTS3 positivef. GTS4 positivef. GTS5 positivef. GTS6 positivef.
	   AWS1 positivef. AWS2 positivef. AWS3 positivef. AWS4 positivef.
	   MS1 positivef. MS2 positivef. MS3 positivef. MS4 positivef. MS5 positivef. MS6 positivef.  MS7 positivef. MS8 positivef. MS9 positivef.;
run;

proc print data=grouped;
run;

proc freq data=grouped;
	tables GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
run;

data grouped1 (Drop = V14A V14B V14C V14D V14E V14F V15A V15B V15C V15D V15E V15F V15G V15H V15I V15J V15K V15L V15M miss_n complete);
	set grouped;
	by id;
		if first.id then byID+1;		
run;

proc print data=grouped1;
run;
	




* using LCA ;
* A 2 class model;
proc lca data=grouped1 OUTPARAM=param2 OUTPOST=post2 OUTEST=est2 OUTSTDERR=stderr2;
	NCLASS 2;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	NSTARTS 1000;
	RHO PRIOR=1;
	SEED 10000;
RUN;

* A 3 class model;
proc lca data=grouped1 OUTPARAM=param3 OUTPOST=post3 OUTEST=est3 OUTSTDERR=stderr3;
	NCLASS 3;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	NSTARTS 1000;
	RHO PRIOR=1;
	SEED 10000;
RUN;

* A 4 class model;
proc lca data=grouped1 OUTPARAM=param4 OUTPOST=post4 OUTEST=est4 OUTSTDERR=stderr4;
	NCLASS 4;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	NSTARTS 1000;
	RHO PRIOR=1;
	SEED 10000;
RUN;

* A 5 class model;
proc lca data=grouped1 OUTPARAM=param5 OUTPOST=post5 OUTEST=est5 OUTSTDERR=stderr5;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	NSTARTS 1000;
	RHO PRIOR=1;
	SEED 10000;
RUN;

proc lca data=grouped1 OUTPARAM=param6 OUTPOST=post6 OUTEST=est6 OUTSTDERR=stderr6;
	NCLASS 6;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	NSTARTS 1000;
	RHO PRIOR=1;
	SEED 10000;
RUN;

/* checking the conditional probabilities for the 5 latent class model */
proc print data=post5;
run;

proc freq data=post5;
	tables Best;
run;

/* Assigning students to latent classes based on their posterior probabilities */
data LC1;
	set post5;
	if Best=1;
run;

data LC2;
	set post5;
	if Best=2;
run;

data LC3;
	set post5;
	if Best=3;
run;

data LC4;
	set post5;
	if Best=4;
run;

data LC5;
	set post5;
	if Best=5;
run;

proc freq data=LC1;
	tables GTS1 * GTS2 / chisq;
run;

proc freq data=LC1;
	tables GTS1 * GTS3 / chisq;
run;

proc freq data=LC1;
	tables GTS1 * GTS4 / chisq;
run;

proc freq data=LC1;
	tables GTS1 * GTS5 / chisq;
run;

proc freq data=LC1;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

proc freq data=LC1;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

proc freq data=LC2;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

proc freq data=LC3;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

proc freq data=LC4;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

proc freq data=LC5;
	tables (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9) * (GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9)
	/ noprint chisq;
run;

/* Comparing the different classes against each other to get the BLRT */

/* 2 Classes versus 3 Classes */
%LcaBootstrap(null_outest=est2,
                alt_outest=est3,
                null_outparam=param2,  
                alt_outparam=param3, 
                n = 2000,
                num_bootstrap=99,
                num_starts_for_null=10,
                num_starts_for_alt=10,
                cores=1,
                initial_seed_for_extra_starts=1000);
/* redefining the colege variable into STEM and non-STEM */

proc format;
	value genderf	0 = 'Female'
			 		1 = 'Male'
			  		. = 'Unavailable';

	value STEMf	0 = 'Non-STEM'
				1 = 'STEM'
				. = 'Unavailable';
run;

data grouped2;
	set grouped1;
	if V1=1 then Gender=1;
		else if V1=2 then Gender=0;
	if V4=2 or V4=3 then STEM=0;
	else if V4=4 or V4=5 then STEM=1;
	Interaction = Gender * STEM;
run;


proc freq data=grouped2;
	tables STEM Gender Interaction;
run;

/* 	Testing the association between the latent class model and a covariate
	Two different covariates will be used in here Gender and College (College is restricted to STEM and non-STEM */

/* Both */
proc lca data=grouped2 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	Covariates Gender STEM Interaction;
	Reference 3;
	NSTARTS 20;
	Rho Prior = 1;
	Beta Prior=1;
	SEED 10000;
RUN;

/* Gender */
proc lca data=grouped2 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	Covariates Gender;
	Reference 3;
	NSTARTS 100;
	Rho Prior = 1;
	Beta Prior=1;;
	SEED 10000;
RUN;

/* STEM */
proc lca data=grouped2 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	Covariates STEM;
	Reference 3;
	NSTARTS 100;
	Rho Prior = 1;
	Beta Prior=1;
	SEED 10000;
RUN;


/**********************************************************************/

* Checking for measurement invariance ;
/* Gender */
/* Model allowing the item response probabilities to vary across groups */ 
proc lca data=grouped2 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	groups V1;
	Groupnames male female;
	Rho Prior = 1;
	NSTARTS 100;
	SEED 10000;
RUN;

/* Model not allowing the item response probabilities to vary across groups */ 
proc lca data=grouped2 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	groups V1;
	Groupnames male female;
	Rho Prior = 1;
	Measurement groups;
	NSTARTS 100;
	SEED 10000;
RUN;

/* Getting the Likelihood Ratio test */
data lrt_pval;
	LRT = 4272.1 - 4155.46;
	df  = 95;
	p_value = 1 - probchi(LRT,df);
run;

proc print data=lrt_pval;
	title1 "LR test statistic and p-value";
run;


/* STEM */

data grouped3;
	set grouped2;
	if V4=2 or V4=3 then STEM=2;
		else if V4=4 or V4=5 then STEM=1;
run;


/* Model allowing the item response probabilities to vary across groups */ 
proc lca data=grouped3 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	groups STEM;
	Groupnames STEM Non_STEM;
	Rho Prior = 1;
	NSTARTS 100;
	SEED 10000;
RUN;

/* Model not allowing the item response probabilities to vary across groups */ 
proc lca data=grouped3 OUTPARAM=param1 OUTPOST=post1 OUTEST=est1 OUTSTDERR=stderr1;
	NCLASS 5;
	ID byID;
	ITEMS GTS1 GTS2 GTS3 GTS4 GTS5 GTS6 AWS1 AWS2 AWS3 AWS4 MS1 MS2 MS3 MS4 MS5 MS6 MS7 MS8 MS9;
	CATEGORIES 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2;
	groups STEM;
	Groupnames STEM Non_STEM;
	Measurement groups;
	Rho Prior = 1;
	NSTARTS 100;
	SEED 10000;
RUN;

/* Getting the Likelihood Ratio test */
data lrt_pval;
	LRT = 4274.2 - 4162.74;
	df  = 95;
	p_value = 1 - probchi(LRT,df);
run;

proc print data=lrt_pval;
	title1 "LR test statistic and p-value";
run;
