/*** HELP START ***//*

### Purpose:
- Unit test for the spider_plot() macro

### Expected result:  
- TEMP.oncoplotter_test dataset will be created with test_result=CHECK

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output"; 

ods graphics / reset=all
                   imagename="spider_test01"
                   imagefmt=png
                   width=300px
                   height=300px;

/* Plot */

  %spider_plot(
    data = dummy_spider,
    xvar = ADY,
    yvar = PCHG,
    subject_var = SUBJID,
    subject_category = BOR,
    xaxis_label = %nrbquote(Days),
    xaxis_values = %nrbquote(0 43 85 127 169 191 213 235),
    yaxis_label = %nrbquote(Change rate from baseline (%)),
    yaxis_values = %nrbquote(-100 -75 -50 -30 0 20 50 75 100),
    datacontrastcolors = %nrbquote(Blue Red Green Yellow),
    refline_value = 0 20 -30,
    curvelabel = Y,
    Generate_Code = N
  );

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\spider_test01.png,
  desc   =  (%nrstr(%spider_plot))[test01] Default parameter test , 
  outds  = TEMP.oncoplotter_test
);
