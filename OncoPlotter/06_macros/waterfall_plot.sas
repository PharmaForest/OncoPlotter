/*** HELP START ***//*

/*************************************************************************
* Program:     Waterfall_Plot.sas
* Macro:       %Waterfall_Plot
*
* Purpose:     This macro generates a Waterfall Plot using ADaM datasets
*              (ADSL, ADTR, ADRS) to visualize tumor size changes from baseline.
*
* Features:
*   - Plots percent change in tumor size (e.g., from baseline to nadir)
*   - Supports grouping by Best Overall Response (BOR) or any other variable
*   - Custom group labels, color coding, and legend display
*   - Flexible WHERE conditions for subsetting each dataset
*   - Customizable axis range, plot title, width, and height
*   - Option to output SAS code
*
* Parameters:
*   adrs=           Input response dataset (e.g., ADRS with BOR)
*   adtr=           Tumor measurements dataset (e.g., ADTR with SUMDIA)
*   adsl=           Subject-level dataset (e.g., ADSL)
*
*   whr_adrs=       where condition for selecting best response per subject (e.g. PARAMCD="BORIRC")
*   whr_adtr=       where condition to select the best sum of diameters per subject (e.g. PARAMCD="SUMDIA" and ANL01FL="Y")
*   whr_adsl=       where condition for subject-level data (e.g. FASFL="Y")
*
*   groupVar=       Numeric variable used for grouping subjects (e.g., based on BOR)
*   groupLabel=     Character variable used for group labels (e.g., BOR term)
*   groupN=         List of numeric group values (e.g., 1 2 3)
*   groupC=         List of character group labels (e.g., "CR" "PR" "SD")
*   groupColor=     Color list for group bars (e.g., red blue green)
*
*   responseVar=    Numeric variable plotted on Y-axis (e.g., percent change in tumor size) 
*   varWidth      =    Width of var (default: 0.7)
*
*   width=          Width of the plot in pixels (default: 840)
*   height=         Height of the plot in pixels (default: 480)
*   dpi=            DPI of the plot  (default: 300)
*
*   title=          Title of the plot (e.g., "Waterfall Plot of Tumor Shrinkage")
*   ytitle=         Label for the Y-axis (e.g., "Change from Baseline (%)")
*   yvalues=        Range and increment for the Y-axis (e.g., -100 to 100 by 20)
*   y_refline=  referrence line (e.g. -30 20)
*
*   Generate_Code=  Option to output generated SAS code via MFILE (Y/N)
*
* Example usage:
******************************
* Example 1:
*   %Waterfall_Plot(
*     adrs = ADRS,
*     adtr = ADTR,
*     adsl = ADSL,
*     whr_adrs = PARAMCD = "BOR",
*     whr_adtr = PARAMCD = "SLD",
*     whr_adsl = SAFFL = "Y",
*     groupVar = GROUPN,
*     groupLabel = GROUPC,
*     groupN = 1 2 3,
*     groupC = "CR" "PR" "SD",
*     groupColor = red blue green,
*     responseVar = PCHG,
*     width = 840,
*     height = 480,
*     title = %nrquote(Waterfall Plot of Best Tumor Response),
*     ytitle = %nrquote(Change from Baseline (%)),
*     yvalues = -100 to 100 by 20,
*     Generate_Code = Y
*   );
* 
******************************
* Example 2:
%Waterfall_Plot(
  adrs      = adrs_dummy,
  adtr      = adtr_dummy,
  adsl      = adsl_dummy,

  whr_adrs    = PARAM="Best Overall Response",
  whr_adtr    = PARAM="Sum of Diameters" and PARQUAL="IRC" and TRGRPID="TARGET" and ANL01FL="Y",
  whr_adsl    = FASFL="Y",

  groupVar     = AVAL,
  groupN       = 1 2 3 4,
  groupC       = CR | PR | SD | PD,
  groupLabel   = Best Overall Response:,
  groupColor   = green | blue | gray | red,

  responseVar  = PCHG,
  VarWidth     = 0.7,

  width     = 840,
  height    = 480,
  dpi       = 300, 

  title   = ,         
  ytitle  = Change from Baseline (%), 
  yvalues = -100 to 100 by 20,  
  y_refline=20 40,                

  Generate_Code = Y
);
* 
* Author:     Hiroki Yamanobe
* Date:       2025-08-25
* Version:    0.1

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

  width     = 840,  /* width of the plot */
  height    = 480,  /* height of the plot */
  dpi       = 300,  /* dpi of the plot */

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
  filename mprint "&codepath.\waterfall_plot&sysind..txt";
  options mfile mprint;
%end;
/*@@@@@@@@*/

/* separator, formats*/
%SP_change(var=groupC);
%let groupN_comma = %sysfunc(tranwrd(&groupN, %str( ),%str(,))); /* to comma separated */
%let groupN_n = %sysfunc(countw(&groupN, %str( ))); /*number of groupN*/
%let groupN_n = 4; /*number of groupN*/
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
ods html image_dpi=&dpi.;

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
options nomfile;
%if %upcase(&Generate_Code) =Y %then %do;
  %let codepath = %sysfunc(pathname(WORK));
  %let sysind =&sysindex;
  filename mprint "&codepath.\waterfall_plot&sysind..txt";
  options mfile mprint;
%end;
/*@@@@@@@@*/


%mend Waterfall_Plot;
