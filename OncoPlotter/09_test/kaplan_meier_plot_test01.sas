/*** HELP START ***//*

### Purpose:
- Unit test for the kaplan_meier_plot() macro

### Expected result:  
- Graph plot will be created for Kaplan-Meier plot.

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output";
ods graphics / reset=all
                   imagename="kaplan_meier_test01"
                   imagefmt=png
                   width=300px
                   height=300px;/*these settings will be overwritten in KM plot macro*/

/* Plot */

%kaplan_meier_plot();

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\kaplan_meier_test01.png,
  desc   =  (%nrstr(%kaplan_meier_plot))[test01] Default parameter test , 
  outds  = TEMP.oncoplotter_test
);
