/*** HELP START ***//*

* Program:     kaplan_meier_plot.txt
* Macro:       %kaplan_meier_plot
*
* Purpose:     This macro generates Kaplan-Meier survival plots using PROC LIFETEST in SAS.
*              It produces survival curves by group, displays censoring marks, and includes
*              the number at risk at each time point on the plot.
*
* Features:
*   - Optionally generates an internal example dataset (e.g., `dummy_adtte`)
*   - Customizable group labels, colors, and line patterns
*   - Supports plotting of censored observations
*   - Configurable axis and display settings
*   - Supports MFILE option to export generated SAS code
*
* Parameters:
*   data=                  Input dataset name (e.g., dummy_adtte)
*   groupn=                Numeric group variable (e.g., TRTPN)
*   groupc=                Character group label variable (e.g., TRTP)
*   wh=                    WHERE condition to subset data (optional)
*   Time_var=              Time-to-event variable (e.g., AVAL)

*   Censor_var=           Censoring indicator variable (e.g., CNSR)
*   Censor_val=           Value indicating censored observations (e.g., 1)
*  (formerly) Censore_var=           Censoring indicator variable (e.g., CNSR)
*  (formerly) Censore_val=           Value indicating censored observations (e.g., 1)

*   Title=                 Plot title (default: "Kaplan-Meier Plot")
*   Group_color_list=      Color list for group lines (e.g., "black red blue green")
*   Group_linepattern_list= Line pattern list for groups (e.g., "solid dash longdash dot")
*   XLABEL=                Label for the X-axis (e.g., "Survival Time (Month)")
*   YLABEL=                Label for the Y-axis (e.g., "Probability of Survival")
*   AxisValues=            Tick marks for the X-axis (e.g., "0 to 16 by 2")
*   Delete_Process_Data=   Option to delete intermediate datasets (Y/N, not used)
*   Generate_Code=         Option to output MFILE-generated SAS code (Y/N)
*
* Example usage:
*   %kaplan_meier_plot(
*       data = dummy_adtte,
*       groupn = TRTPN,
*       groupc = TRTP,
*       Time_var = AVAL,
*       Censor_var = CNSR,
*       Censor_val = 1,
*       Title = %nrquote(Kaplan-Meier Curve Example),
*       Group_color_list = %nrquote(black red blue green),
*       Group_linepattern_list = %nrquote(solid dash longdash shortdash),
*       XLABEL = %nrquote(Survival Time (Month)),
*       YLABEL = %nrquote(Probability),
*       AxisValues = %nrquote(0 to 24 by 4),
*       Generate_Code = Y
*   );
*
* Author:     Yutaka Morioka
* First Release Date:        2025-06-24
* Update:     2025-09-01 (Bug Fix)
* Update:	 2025-09-16 (minor change)
* Update:	 2026-02-05 (bug fix--generate coe)
* Update:     2026-02-23 (changed parameter names: Censore -> Censor)  

*//*** HELP END ***/

%macro kaplan_meier_plot(
data = dummy_adtte ,
groupn = TRTPN ,
groupc = TRTP ,
wh = ,
Time_var = AVAL ,
Censor_var = ,
Censor_val = ,
Censore_var = CNSR ,
Censore_val = 1,
Title = %nrbquote(Kaplan-Meier Plot),
Group_color_list =%nrbquote(black black black black),
Group_linepattern_list =%nrbquote(solid shortdash longdash dash),
XLABEL =%nrbquote( Survival Time (Month)),
YLABEL =%nrbquote( Probability of Survival),
AxisValues =%nrbquote (0 to 16 by 2),
Generate_Code =Y
);

/* Backward compatibility: use old params only when new ones are not provided */
%if %superq(Censor_var) = %str() and %superq(Censore_var) ne %str() %then %do;
  %let Censor_var = &Censore_var;
%end;

%if %superq(Censor_val) = %str() and %superq(Censore_val) ne %str() %then %do;
  %let Censor_val = &Censore_val;
%end;

%let codepath = %sysfunc(pathname(WORK));
%put &codepath;
options nomfile;
%if %upcase(&Generate_Code) =Y %then %do;
%let sysind =&sysindex;
filename mprint "&codepath./kaplan_meier_plot&sysind..txt";
options mfile mprint;
%end;
data dummy_adtte;
attrib
USUBJID label="Unique Subject Identifier" length=$20.
TRTP  label="Planned Treatment" length=$20.
TRTPN	label="Planned Treatment (N)" length=8.
PARAM  label="Parameter" length=$50.
PARAMCD label="Parameter Code" length=$20.
PARAMN  label="Parameter (N)" length=8.
AVAL  label="Analysis Value" length=8.
CNSR  label="Censor" length=8.
;
call streaminit(1982);
do TRTPN = 1 to 4;
do _USUBJID = 1 to 100;
do PARAMN = 1 to 1;
if TRTPN =1 then time =rand('WEIBULL', 1.5, 10);
else if TRTPN =2 then time =rand('WEIBULL', 1.5, 7);
else if TRTPN =3 then time =rand('WEIBULL', 1.5, 3);
else time =rand('WEIBULL', 1.5, 5);
USUBJID = cats(TRTPN,_USUBJID);
censor_limit = rand('UNIFORM') * 15;
CNSR = ^(time <= censor_limit);
AVAL = min(time, censor_limit);
TRTP = choosec(TRTPN,"XXXXX","YYYY","ZZZZZ","Placebo");
PARAMCD = choosec(PARAMN,"PFS");
PARAM = choosec(PARAMN,"Progression Free Survival (Months)");
output;
end;
end;
end;
keep USUBJID -- CNSR;
run;
proc sort data=&data.(keep=&groupn. &groupc.) out=group_fmt nodupkey;
by &groupn. &groupc.;
run;
data group_fmt;
set group_fmt;
FMTNAME = "$KM_GR";
START = cats(&groupn.);
LABEL = &groupc.;
run;
proc format cntlin=group_fmt;
run;
ods graphics on;
ods noresults;
ods select none;
ods output Survivalplot=SurvivalPlotData;
proc lifetest data=&data.
plots=survival(atrisk=&AxisValues.);
time &Time_var. * &Censor_var.(&Censor_val.);
strata &groupn. ;
run;
proc sort data=SurvivalPlotData(keep = Stratum) out=Stratum nodupkey;
by Stratum;
run;
proc sort data=SurvivalPlotData(keep = tAtRisk) out=tAtRisk nodupkey;
where ^missing(tAtRisk);
by tAtRisk;
run;
data atrisk;
set Stratum;
if _N_=1 then do;
declare hash h1(dataset:"SurvivalPlotData(keep=Stratum tAtRisk)");
h1.definekey("Stratum","tAtRisk");
h1.definedone();
end;
do i=1 to obs;
set tAtRisk nobs=obs point=i;
AtRisk=0;
if h1.check() ne  0 then  output;
end;
run;
data SurvivalPlotData_1;
set SurvivalPlotData atrisk;
if ^missing(Censored) then do;
tick_marks_upper = Censored + 0.02;
tick_marks_lower = Censored - 0.02;
end;
run;
ods results;
ods select all;
ods graphics / reset
noborder
noscale
imagefmt=png
width=745 px
height=510 px
				             attrpriority=none;
title "&Title";
proc sgplot data=SurvivalPlotData_1 noborder noautolegend ;
styleattrs datacontrastcolors=(&Group_color_list)
				       datalinepatterns=(&Group_linepattern_list)
;
step x=time y=survival / group=stratum name='step' lineattrs=(thickness=2);
scatter x=time y=censored /noerrorcaps yerrorupper=tick_marks_upper yerrorlower=tick_marks_lower errorbarattrs=(pattern=1 thickness=2)  markerattrs=(size=0) GROUP=stratum;
xaxistable atrisk / x=tatrisk class=stratum location=outside colorgroup=stratum valueattrs=(size=10 ) ;
keylegend 'step' / location=inside position=topright across=1 noborder  valueattrs=(size=10) exclude=("") ;
yaxis label="&YLABEL." min=0 values=(0 0.2 0.4 0.5 0.6 0.8 1.0 ) offsetmax=0.03;
xaxis label="&XLABEL."  values=(&AxisValues.)  offsetmin=0.04 ;
format stratum $KM_GR. ;
run;
title;
%if %upcase(&Generate_Code) =Y %then %do;
  %*-- Only for Windows system --*;
  %if %index(%upcase(&SYSSCP), WIN) > 0 %then %do;
    options noxwait noxsync;
  %end;
  options nomprint nomfile;
  filename mprint clear;
  data _null_;
    put "NOTE: Generated Program Code File: &codepath./kaplan_meier_plot&sysind..txt";
  	call sleep(1,1);
  run;

  %*-- Open file when use XCMD --*;
  %if %sysfunc(getoption(xcmd))=XCMD %then %sysexec "&codepath./kaplan_meier_plot&sysind..txt";
%end;
%mend;
