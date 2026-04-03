/*** HELP START ***//*

### Purpose:
- Unit test for the kaplan_meier_plot() macro with options

### Expected result:  
- Graph plot will be created for Kaplan-Meier plot.  

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output";
ods graphics / reset=all
                   imagename="kaplan_meier_test02"
                   imagefmt=png
                   width=300px
                   height=300px;/*these settings will be overwritten in KM plot macro*/

/* Plot */

%kaplan_meier_plot(
              data = dummy_adtte ,
              groupn = TRTPN ,
              groupc = TRTP ,
              wh = ,
              Time_var = AVAL ,
              Censor_var = CNSR ,
              Censor_val = 1 ,
              Title = %nrbquote(Kaplan-Meier Curve Example),
              Group_color_list =%nrbquote(black red blue green),
              Group_linepattern_list =%nrbquote(solid dash longdash shortdash),
              XLABEL =%nrbquote(Survival Time (Month)),
              YLABEL =%nrbquote(Probability),
              AxisValues =%nrbquote (0 to 24 by 4),
              Generate_Code =Y
);

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\kaplan_meier_test02.png,
  desc   =  (%nrstr(%kaplan_meier_plot))[test02] Help Example parameter test , 
  outds  = TEMP.oncoplotter_test
);

