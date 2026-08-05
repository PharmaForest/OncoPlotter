/*** HELP START ***//*

### Purpose:
- Unit test for the forest_plot() macro

### Expected result:  
- Graph plot will be created for forest plot.

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output";

ods graphics / reset=all
                   imagename="forest_test01"
                   imagefmt=png
                   width=300px
                   height=300px;

/* Plot */

  %forest_plot(
    data=dummy_forest_test,
    out1=col1,
    out2=col2,
    out3=col3,
    out4=col4,
    out5=col5,
    marker_point=estimate,
    bar_left=lower_limit,
    bar_right=upper_limit,
    out1_label=%nrbquote(Sub Group),
    out2_label=%nrbquote(n),
    out3_label=%nrbquote(%),
    out4_label=%nrbquote(HR),
    out5_label=%nrstr(HR 95 %CL),
    AxisValues=%nrbquote(0.0 to 2.5 by 0.5),
    refline_value=1,
    bar_color=black,
    marker_color=black,
    Generate_Code=Y
  );


/* Assert graph */
%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\forest_test01.png,
  desc   =  (%nrstr(%forest_plot))[test01] Default parameter test , 
  outds  = TEMP.oncoplotter_test
);
