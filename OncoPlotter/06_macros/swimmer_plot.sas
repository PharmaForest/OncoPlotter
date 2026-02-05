/*** HELP START ***//*

### Macro:
%Swimmer_Plot
### Purpose:
Creates a swimmer plot to visualize treatment duration, response duration (CR/PR),
and clinical events (e.g., death) for each subject using ADaM datasets.
### Parameters:
#### Data inputs
- `adrs` (required) :
Response dataset (BDS ADaM).
Expected variables include `USUBJID`, `AVAL`, `AVALC`, `ADT`, `ADY`.
- `adsl` (required) :
Subject-level dataset (ADSL ADaM).
Expected variables include `USUBJID`, `SUBJID`, `TRTSDT`, `TRTEDT`, `DTHDT`
and the variable specified in `eotvar`.
- `whr_adrs` (optional, default=blank) :
WHERE condition applied to the response dataset.
- `whr_adsl` (optional, default=blank) :
WHERE condition applied to the subject-level dataset.
- `eotvar` (required) :
End-of-treatment status variable.
If its value equals `"ONGOING"` (case-insensitive), an arrow endcap is drawn.
- `lstvstdt` (optional, default=blank) :
Alternative last visit date used when `TRTEDT` is missing or incomplete.
Treatment duration is calculated as `min(TRTEDT, lstvstdt) - TRTSDT + 1`.
#### Response definition
- `crprN` (optional, default=`1 2`) :
Numeric values of `AVAL` considered as CR or PR.
- `responseN` (required, default=`1 2 3 4`) :
Numeric values of response categories.
- `responseC` (required, default=`CR | PR | SD | PD`) :
Character labels corresponding to `responseN`.
Values must be separated by `|`.
- `responseLabel` (optional, default=`Response`) :
Label for response legend.
#### Durable response display
- `durable` (optional, default=`Y`) :
Specifies whether response-duration (durable period) lines are drawn.
- `durableLabel` (optional, default=`Response period`) :
Legend label for the durable response period.
#### Grouping
- `groupvar` (optional, default=blank) :
Numeric grouping variable in `adsl`.
- `groupN` (optional, default=blank) :
Numeric values for the grouping variable.
- `groupC` (optional, default=blank) :
Character labels for the grouping variable.
Values must be separated by `|`.
- `groupLabel` (optional, default=blank) :
Legend label for grouping categories.
#### Event labels
- `deathLabel` (optional, default=`Death`) :
Legend label for death marker.
- `ongoingLabel` (optional, default=`Treatment Ongoing`) :
Legend label for ongoing-treatment indicator.
#### Layout and appearance
- `nperpage` (optional, default=`20`) :
Number of subjects displayed per page.
- `width` (optional, default=`640`) :
Width of the output graphic in pixels.
- `height` (optional, default=`480`) :
Height of the output graphic in pixels.
- `subjidOn` (optional, default=`Y`) :
Displays subject ID when set to `Y`.
- `title` (optional, default=blank) :
Title of the plot.
- `ytitle` (optional, default=`Subject`) :
Title of the y-axis.
- `xtitle` (optional, default=`Days from Treatment Start`) :
Title of the x-axis.
- `xvalues` (optional, default=blank) :
X-axis tick specification (e.g., `0 to 40 by 4`).
- `nolegend` (optional, default=blank) :
Suppresses legend when set to `Y`.
#### Style
- `colorStyle` (optional, default=`OncoPlotter`) :
Preset color style.
Supported values include `OncoPlotter`, `Salmon`, `Kawaii`, `Kyoto`, `Osaka`.
- `groupColor` (optional, default=`orange`) :
Color for group categories when `colorStyle` is blank.
- `markerColor` (optional, default=`red`) :
Color for markers when `colorStyle` is blank.
- `markerSymbol` (optional, default=blank) :
Marker symbol when `colorStyle` is blank.
#### Time scale
- `interval` (optional, default=blank) :
Time-unit conversion.
Permitted values (case-insensitive):
- `WEEK`  : days divided by 7
- `MONTH` : days divided by 30.4375
#### Code generation
- `Generate_Code` (optional, default=`Y`) :
When set to `Y`, generates the underlying program code
and writes it to a text file in the WORK directory.
~~~sas
%Swimmer_Plot(
	adrs				= adrs_dummy,
	adsl				= adsl_dummy,
	whr_adrs			= PARAM="Overall Response" and PARQUAL="IRC",
	whr_adsl			= FASFL="Y",
	eotvar 			= EOTSTT,
	lstvstdt			= ,
	crprN 			= 1 2,
	durable			= Y,
	durableLabel 	= Durable Period,
	groupvar 			= STAGEN,
	groupLabel 		= Disease Stage,
	groupN 			= 1 2 3 4 5,
	groupC 			= Stage I | Stage IIa | Stage IIb | Stage III | Stage IV,
	responseN 		= 1 2 3 4,
	responseC 		= CR | PR | SD | PD,
	responseLabel 	= Response,
	deathLabel 		= Death,
	ongoingLabel 	= Treatment Ongoing,
	nperpage 		= 20,
	width 				= 640,
	height				= 480,
	subjidOn		 	= Y,
	colorStyle 		= OncoPlotter,
	groupColor 		= ,
	markerColor 	= ,
	markerSymbol 	= ,
	title 				= Swimmer%str(%')s Plot,
	ytitle 				= Subject,
	xtitle 				= Days from treatment,
	xvalues 			= 0 to 40 by 4,
	nolegend			= ,
	interval 			= week,
	Generate_Code = Y
)
~~~
### prerequisites
- Response data		: BDS ADaM dataset
		(USUBJID, AVAL, ADT, ADY)
- Subject-level-data	: ADSL ADaM dataset
		(USUBJID, SUBJID, TRTSDT, TRTEDT, DTHDT)
### URL:
https://github.com/PharmaForest/OncoPlotter
* Author:     Ryo Nakaya
* Latest udpate Date:        2026-01-19

*//*** HELP END ***/

%macro Swimmer_Plot(
	adrs		= ,	/* Response dataset (ADaM) */
	adsl		= ,	/* Subject-level dataset (ADaM) */
	whr_adrs	= ,	/* where conditon for response data */
	whr_adsl	= ,	/* where condition for subject-level data */
	eotvar 	= ,	/* Variable of End of Treatment Status */
	lstvstdt 	= , /* In case TRTEDT is null */
	crprN 	= 1 2, /* Numeric values for CR/PR */
	durable 	= Y, /* Y for describing line of durable period */
	durableLabel = Response period, /* Label for durable period in legend */
	groupvar 	= , /* Numeric variable for grouping */
	groupLabel = , /* Label for group in legend */
	groupN 	= ,	/* Numeric values for group variable */
	groupC 	= , /* Character values for group variable */
	responseN = 1 2 3 4, /* Numeric values for response variable(AVAL) */
	responseC = CR | PR | SD | PD, /* Character values for response variable(AVAL) */
	responseLabel = Response,	/* Label for response in legend */
	deathLabel = Death,	/* Label for death in legend */
	ongoingLabel = Treatment Ongoing,	/* Label for ongoing in legend */
	nperpage = 20, /* N per page for a plot */
	width 		= 640,	/* width of the plot */
	height		= 480,	/* height of the plot */
	subjidOn = Y , /* Y for showing subject ID */
	colorStyle = OncoPlotter,	/* OncoPlotter, Salmon, Kawaii, Kyoto, Osaka */
	groupColor = orange,	/* Color for group categories (Effective when colorStyle is null.) */
	markerColor = red,	/* Color for marker (Effective when colorStyle is null) */
	markerSymbol = ,	/* Symbols for marker (Effective when colorStyle is null) */
	title = ,	/* Title of the plot */
	ytitle = Subject,	/* Title for y-axis */
	xtitle = Days from Treatment Start,	/* title for x-axis */
	xvalues = ,	/* range of x-axis */
	nolegend = ,	/* Y to surpress the legend */
	interval = ,	/* Can change time intervals from Day to Week or Month */
	Generate_Code = Y
	) ;
/*@@@@@@@@*/
options nomfile;
%if %upcase(&Generate_Code) =Y %then %do;
%let codepath = %sysfunc(pathname(WORK));
%let sysind =&sysindex;
filename mprint "&codepath./swimmer_plot&sysind..txt";
options mfile mprint;
%end;
/*@@@@@@@@*/
/* separator, formats*/
%SP_change(var=responseC);
%let responseN_comma = %sysfunc(tranwrd(&responseN, %str( ),%str(,))); /* to comma separated */
%let responseN_n = %sysfunc(countw(&responseN, %str( ))); /*number of groupN*/
%SP_make_respf_format()
%if %superq(groupvar) ne %str() %then %do;
	%SP_change(var=groupC);
	%let groupN_comma = %sysfunc(tranwrd(&groupN, %str( ),%str(,))); /* to comma separated */
	%let groupN_n = %sysfunc(countw(&groupN, %str( ))); /*number of groupN*/
	%SP_make_groupf_format()
%end ;
/*==========================================================================*/
/* merge ADRS and ADSL */
proc sort data=&adsl. out=&adsl._sort ; by USUBJID ; run ;
proc sort data=&adrs. out=&adrs._sort ; by USUBJID ADT ; run ;
data SWIM ;
	merge &adrs._sort(where=(&whr_adrs.)  in=A)
			 &adsl._sort(where=(&whr_adsl.) in=B) ;
	by USUBJID ;
	if A and B ;
run ;
/* Data 1:  Treatment duration data (per subject) */
data ADSL_TRTDUR;
set &adsl._sort(where=(&whr_adsl.));
low = 0;
%if %superq(lstvstdt) ne %str() %then %do ;
	high = min(TRTEDT, &lstvstdt.) - TRTSDT + 1;
%end ;
%else %do; high = TRTEDT - TRTSDT + 1; %end ;
if upcase(&eotvar.)="ONGOING" then endcap="arrow"; /* cap type */
else endcap="none";
run;
proc sort data=ADSL_TRTDUR out=ADSL_TRTDUR_SORT; /*sort descending order*/
by descending high;
run;
data ADSL_TRTDUR_RANK;
set ADSL_TRTDUR_SORT;
item = _N_; /* variable for y-axis*/
run;
proc sort data=ADSL_TRTDUR_RANK ; by USUBJID ; run ;
proc sort data=ADSL_TRTDUR_RANK out=SUBJID_LIST(keep=item USUBJID SUBJID); /* item?irank?j and SUBJID */
by item;
run;
/* Data 2: Response duration data (per subject, response duration) */
proc sort data=SWIM ;
by USUBJID ADT;
run;
data SWIM_RESPONSE;
set SWIM;
by USUBJID;
retain in_resp resp_start resp_start_avalc prev_prcr_adt;
/* Initialize */
if first.USUBJID then do;
in_resp = 0;        /*response flag*/
resp_start = .;     /*response start*/
prev_prcr_adt = .; /*previous PR/CR ADT*/
end;
/* Start of PR/CR */
if AVAL in (%sysfunc(tranwrd(&crprN., %str( ), %str(,)))) then do;
if in_resp = 0 then do;         /* Start new duration */
resp_start = ADT;
resp_start_avalc = AVALC;   /* keep the first response */
in_resp = 1; 					  /*response flag=1*/
end;
prev_prcr_adt = ADT;            /* latest ADT of response */
end;
/* End of PR/CR ?ii.e. Not in (PR, CR) or Last observation)*/
if in_resp = 1 and (AVAL not in (%sysfunc(tranwrd(&crprN, %str( ), %str(,)))) or last.USUBJID) then do;
if AVAL not in (%sysfunc(tranwrd(&crprN, %str( ), %str(,)))) then resp_end = prev_prcr_adt ;
else if last.USUBJID and AVAL in (%sysfunc(tranwrd(&crprN, %str( ), %str(,)))) then resp_end = ADT;
else resp_end = .;
/* output if not missing start and end */
if not missing(resp_start) and not missing(resp_end) and resp_end >= resp_start then do;
output;
end;
/* reset for another duration */
in_resp = 0;
resp_start = .;
resp_end = .;
prev_prcr_adt = .;
end;
format resp_start resp_end yymmdd10.;
keep USUBJID resp_start resp_end resp_start_avalc TRTSDT ;
run;
data SWIM_RESPONSE2;
set SWIM_RESPONSE;
durable_low = resp_start - TRTSDT + 1;
durable_high = resp_end - TRTSDT + 1;
run;
proc sql ; /*merge item to response duration data*/
	create table SWIM_RESPONSE3 as
	select a.* , b.SUBJID, b.item
	from SWIM_RESPONSE2 as a
	left join SUBJID_LIST as b
	on a.USUBJID = b.USUBJID ;
quit ;
data SWIM_RESPONSE4 ;
	merge SWIM_RESPONSE3(in=A) &adsl._sort(where=(&whr_adsl.)) ;
	by USUBJID ;
run ;
/* Data 3: Marker data(per subject, visit */
proc sql ; /*merge item to marker data*/
	create table MARKER as
	select a.* , b.item
	from SWIM as a
	left join SUBJID_LIST as b
	on a.USUBJID = b.USUBJID ;
quit ;
data MARKER1;
set MARKER;
if not missing(DTHDT) then marker_d = DTHDT - TRTSDT + 1; /* Day of death */
run;
/* Set Data 1-3 */
data PLOT_DATA;
	length bar_type $10. ;
set
ADSL_TRTDUR_RANK(in=A)        /* Treatment duration */
SWIM_RESPONSE4(in=B) 			/* Response duration */
	MARKER1(in=C) ;						/* Marker */
	if A then bar_type="treat" ;
	if B then bar_type="durable" ;
	if C then bar_type="marker" ;
	ymin=-1 ; /*for dummy plot(out of area) of cap for showing cap in legend*/
run;
/*==========================================================================*/
/* number of subject */
proc sort data=PLOT_DATA out=PLOT_DATA_NODUP nodupkey ; by USUBJID ; run ;
proc sql noprint;
select count(*) into :ncase from PLOT_DATA_NODUP ;
quit;
%let npage = %sysfunc(ceil(%sysevalf(&ncase. / &nperpage.)));
/*Week, Month*/
%if %sysfunc(strip(%upcase(&interval.)))=WEEK %then %do ;
	data PLOT_DATA ;
		set PLOT_DATA(rename=(low=low_d high=high_d durable_low=durable_low_d durable_high=durable_high_d
		ADY=ADY_d marker_d=marker_d_d)) ;
		low=low_d/7 ; high=high_d/7 ; durable_low=durable_low_d/7; durable_high=durable_high_d/7 ;
		ADY=ADY_d/7 ; marker_d=marker_d_d/7 ;
	run ;	
%end ;
%if %sysfunc(strip(%upcase(&interval.)))=MONTH %then %do ;
	data PLOT_DATA ;
		set PLOT_DATA(rename=(low=low_d high=high_d durable_low=durable_low_d durable_high=durable_high_d
		ADY=ADY_d marker_d=marker_d_d)) ;
		low=low_d/30.4375 ; high=high_d/30.4375 ; durable_low=durable_low_d/30.4375; durable_high=durable_high_d/30.4375 ;
		ADY=ADY_d/30.4375 ; marker_d=marker_d_d/30.4375 ;
	run ;	
%end ;
ods graphics / attrpriority=none width=&width.px height=&height.px;
%SP_split_plot;
ods graphics / reset=all ;
/*@@@@@@@@*/
%if %upcase(&Generate_Code) =Y %then %do;
%*-- Only for Windows system --*;
%if %index(%upcase(&SYSSCP), WIN) > 0 %then %do;
options noxwait noxsync;
%end;
options nomprint nomfile;
filename mprint clear;
data _null_;
put "NOTE: Generated Program Code File: &codepath./swimmer_plot&sysind..txt";
	call sleep(1,1);
run;
%*-- Open file when use XCMD --*;
%if %sysfunc(getoption(xcmd))=XCMD %then %sysexec "&codepath./swimmer_plot&sysind..txt";
%end;
/*@@@@@@@@*/
%mend ;
