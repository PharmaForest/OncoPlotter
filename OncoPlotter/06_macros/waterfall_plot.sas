/*** HELP START ***//*

### Macro:

%Waterfall_Plot

### Purpose:

Creates a waterfall plot using ADaM datasets (`ADSL`, `ADTR`, and `ADRS`)
to visualize percent change in tumor size from baseline for each subject.

### Parameters:

#### Data inputs

- `adrs` (optional, default=`ADRS`) :
	Response dataset (e.g., ADRS containing Best Overall Response).
	Expected variables include `USUBJID` and the variable specified in `groupVar`.

- `adtr` (optional, default=`ADTR`) :
	Tumor measurement dataset (e.g., ADTR containing sum of diameters).
	Expected variables include `USUBJID` and the variable specified in `responseVar`.

- `adsl` (optional, default=`ADSL`) :
	Subject-level dataset (ADSL ADaM).
	Expected variable includes `USUBJID`.

- `whr_adrs` (optional, default=blank) :
	WHERE condition applied to the response dataset.
	For example, `PARAM="Best Overall Response"`.

- `whr_adtr` (optional, default=blank) :
	WHERE condition applied to the tumor measurement dataset.
	For example, `PARAM="Sum of Diameters" and PARQUAL="IRC" and TRGRPID="TARGET" and ANL01FL="Y"`.

- `whr_adsl` (optional, default=blank) :
	WHERE condition applied to the subject-level dataset.
	For example, `FASFL="Y"`.

#### Grouping

- `groupVar` (required) :
	Numeric variable used to group subjects, such as the numeric value of Best Overall Response.

- `groupLabel` (optional, default=blank) :
	Legend title for the grouping variable.

- `groupN` (required) :
	Numeric values for the grouping variable.

- `groupC` (required) :
	Character labels corresponding to `groupN`.
	Values must be separated by `|`.

- `groupColor` (required) :
	Colors corresponding to the groups.
	Values must be separated by `|`.

#### Response definition

- `responseVar` (required) :
	Numeric variable plotted on the y-axis, such as percent change from baseline.

- `VarWidth` (optional, default=`0.7`) :
	Width of each waterfall bar.

#### Output and layout

- `width` (optional, default=`840`) :
	Width of the output graphic in pixels.

- `height` (optional, default=`480`) :
	Height of the output graphic in pixels.

- `dpi` (optional, default=`300`) :
	Resolution of the output graphic in dots per inch.

- `imgPath` (optional, default=SAS temporary directory) :
	Directory in which the image and HTML output files are written.

- `title` (optional, default=blank) :
	Title of the plot.

- `ytitle` (optional, default=`Change from Baseline (%)`) :
	Title of the y-axis.

- `yvalues` (optional, default=`-100 to 100 by 20`) :
	Y-axis tick specification.

- `y_refline` (optional, default=blank) :
	Space-separated y-axis reference-line values, such as `-30 20`.

#### Code generation

- `Generate_Code` (optional, default=`Y`) :
	When set to `Y`, generates the underlying SAS program code
	and writes it to a text file in the WORK directory.

### Example

~~~sas
%Waterfall_Plot(
	adrs         = adrs_dummy,
	adtr         = adtr_dummy,
	adsl         = adsl_dummy,
	whr_adrs     = PARAM="Best Overall Response",
	whr_adtr     = PARAM="Sum of Diameters" and PARQUAL="IRC" and TRGRPID="TARGET" and ANL01FL="Y",
	whr_adsl     = FASFL="Y",
	groupVar     = AVAL,
	groupN       = 1 2 3 4,
	groupC       = CR | PR | SD | PD,
	groupLabel   = Best Overall Response:,
	groupColor   = green | blue | gray | red,
	responseVar  = PCHG,
	VarWidth     = 0.7,
	width        = 840,
	height       = 480,
	dpi          = 300,
	imgPath      = C:/temp,
	title        = Figure 14.2.x,
	ytitle       = Change from Baseline (%),
	yvalues      = -100 to 100 by 20,
	y_refline    = -30 20,
	Generate_Code = Y
);
~~~

### Prerequisites

- Response data: ADRS or another response dataset
	(`USUBJID` and the variable specified in `groupVar`)
- Tumor measurement data: ADTR or another BDS ADaM dataset
	(`USUBJID` and the variable specified in `responseVar`)
- Subject-level data: ADSL ADaM dataset
	(`USUBJID`)

### URL:

https://github.com/PharmaForest/OncoPlotter

Author:     Hiroki Yamanobe
Update:
	8Oct2025 : First release
	27May2026 : Bug fixed for not using %sp_change. Updated program header
    30July2026 : Updated program header to markdown 


*//*** HELP END ***/

%macro Waterfall_Plot(
	adrs      = ADRS,  /* Response dataset (ADaM) */
	adtr      = ADTR,  /* Subject-level dataset (ADaM) */
	adsl      = ADSL,  /* Subject-level dataset (ADaM) */
	whr_adrs  = ,  /* where condition for selecting best response per subject  */
	whr_adtr  = ,  /* where condition to select the best sum of diameters per subject */
	whr_adsl  = ,  /* where condition for subject-level data */
	groupVar   = , /* Numeric variable for grouping */
	groupLabel = , /* Label for group in legend */
	groupN     = , /* Numeric values for group variable */
	groupC     = , /* Character values for group variable */
	groupColor = , /* Color Code for group */
	responseVar  = , /* Numeric variable for y-axis(Sum of Diameters) */
	VarWidth     = 0.7, /* Numeric variable for y-axis(Sum of Diameters) */
	width     = 840,  /* Width of the plot */
	height    = 480,  /* Height of the plot */
	dpi       = 300,  /* DPI of the plot */
	imgPath   =,      /* Path of image file */
	title   = ,                         /* Title of the plot */
	ytitle  = Change from Baseline (%), /* title of y-axis */
	yvalues = -100 to 100 by 20,        /* range of y-axis */
	y_refline=,                         /* referrence line of y-axis (e.g. -30 20) */
	Generate_Code = Y
) ;
/* @@@@@@@@ Generate_Code start */
options nomfile;
%if %upcase(&Generate_Code) =Y %then %do;
%let codepath = %sysfunc(pathname(WORK));
%let sysind =&sysindex;
filename mprint "&codepath./waterfall_plot&sysind..txt";
options mfile mprint;
%end;
/*@@@@@@@@*/
/* separator, formats*/
%let groupN_comma = %sysfunc(tranwrd(&groupN, %str( ),%str(,))); /* to comma separated */
%let groupN_n = %sysfunc(countw(&groupN, %str( ))); /*number of groupN*/
%SP_make_groupf_format()
/*==========================================================================*/
/* merge ADRS, ADTR and ADSL */
proc sort data=&adsl. out=&adsl._sort ; where &whr_adsl.; by USUBJID ; run;
proc sort data=&adrs. out=&adrs._sort ; where &whr_adrs.; by USUBJID ADT; run;
proc sort data=&adtr. out=&adtr._sort ; where &whr_adtr.; by USUBJID ADT; run;
data WATERFALL ;
	merge &adrs._sort(keep=USUBJID &groupVar.     in=A)
	&adsl._sort(keep=USUBJID                in=B)
	&adtr._sort(keep=USUBJID &responseVar.  in=C)
	;
	by USUBJID;
	if A and B and C;
	forORDER=100-&responseVar.;
run;
proc sort data=WATERFALL;
	by forORDER;
run;
data WATERFALL2;
	set WATERFALL;
	by forORDER;
	ORDER=_n_;
run;
/*==========================================================================*/
/* attribute map */
proc format cntlout=fmt_out;
run;
data attrmapData;
	set fmt_out;
	where FMTNAME eq "GROUPF";
	length ID Value FillColor $200.;
	ID="groupClor";
	VALUE=LABEL;
	FILLCOLOR = strip(scan("&groupColor.",input(strip(START),best.),"|"));
	put ID= VALUE= FILLCOLOR=;
	keep ID VALUE FILLCOLOR;
run;
/*==========================================================================*/
/* set refline */
data _null_;
	if ^missing("&y_refline.") then do;
	VAR=tranwrd(cats("&y_refline.")," ","|");
	cnt=count(VAR,"|");
	put cnt=;
	do i=1 to cnt+1;
	OUT=catx(" ","refline",scan(VAR,i,"|"),'/ axis=y lineattrs=(pattern=shortdash color=gray);');
	call symputx(cats("L_ref",i),OUT,"L");
	call symputx("max_refline",i,"L");
	end;
	end;
	else call symputx("max_refline",0,"L");
run;
%put &=max_refline.;
/*==========================================================================*/
/* Plot */
/* get temporary */
%let _wk=%sysfunc(getoption(work));
%put &=_wk ;
%if %length(&imgPath.) > 1 %then %do; %let _wk=&imgPath.; %end;
%put NOTE: Output path of image files: &_wk.;
ods html image_dpi=&dpi. path="&_wk." file="sashtml.html";
ods graphics / width=&width.px height=&height.px ;
title "&title.";
proc sgplot data=WATERFALL2 dattrmap=attrmapData;
	refline   0 / axis=y lineattrs=(pattern=solid     color=gray);
	%do i=1 %to &max_refline.;
	&&L_ref&i..;
	%end;
	vbar ORDER/
	response=&responseVar. barwidth=&VarWidth.
	group=&groupVar. grouporder=ascending attrid=groupClor name="group"
	;
	xaxis display=(novalues nolabel noticks);
	yaxis label="&ytitle." values=(&yvalues.);
	keylegend "group" / title="&groupLabel." ;
	format &groupvar. GROUPF.;
run;
ods graphics / reset=all ;

/*@@@@@@@@ Generate_Code end */
%if %upcase(&Generate_Code) =Y %then %do;
%*-- Only for Windows system --*;
%if %index(%upcase(&SYSSCP), WIN) > 0  %then %do;
options noxwait noxsync;
%end;
options nomprint nomfile;
filename mprint clear;
data _null_;
	put "NOTE: Generated Program Code File: &codepath./waterfall_plot&sysind..txt";
	call sleep(1,1);
run;
%*-- Open file when use XCMD --*;
%if %sysfunc(getoption(xcmd))=XCMD %then %sysexec "&codepath./waterfall_plot&sysind..txt";
%end;
/*@@@@@@@@*/

%mend Waterfall_Plot;
