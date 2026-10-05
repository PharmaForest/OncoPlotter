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
                   imagename="spider_test02"
                   imagefmt=png
                   width=300px
                   height=300px;

/*test data*/
data spider_data_test;
    length
        SUBJID $8
        ADY       8
        PCHG     8
        BOR     $19
    ;

    infile datalines dlm='@' dsd truncover;

    input
        SUBJID         :$8.
        ADY             :best32.
        PCHG            :best32.
        BOR             :$19.
    ;

datalines;
101810@0@0@Complete Response
101810@28@-10@Complete Response
101810@84@-50@Complete Response
101810@140@-70@Complete Response
101810@196@-92@Complete Response
101810@224@-100@Complete Response
103101@0@0@Progressive Disease
103101@28@10@Progressive Disease
103101@84@55@Progressive Disease
103101@140@75@Progressive Disease
103105@0@0@Stable Disease
103105@28@-5@Stable Disease
103105@84@0@Stable Disease
103105@140@5@Stable Disease
103105@196@0@Stable Disease
103201@0@0@Partial Response
103201@28@-10@Partial Response
103201@84@-20@Partial Response
103201@140@-40@Partial Response
103201@196@-30@Partial Response
103201@224@-45@Partial Response
103205@0@0@Partial Response
103205@28@-20@Partial Response
103205@84@-40@Partial Response
103205@140@-50@Partial Response
103205@196@-55@Partial Response
103205@224@-55@Partial Response
103205@252@-40@Partial Response
;
run;


/* Plot */

  %spider_plot(
    data = spider_data_test,
    xvar = ADY,
    yvar = PCHG,
    subject_var = SUBJID,
    subject_category = BOR,
    xaxis_label = %nrbquote(Days),
    xaxis_values = %nrbquote(0 28 84 140 196 224 252 280),
    yaxis_label = %nrbquote(Change rate from baseline (%)),
    yaxis_values = %nrbquote(-100 -75 -50 -25 0 25 50 75 100),
    datacontrastcolors = %nrbquote(Blue Red orange Green),
    refline_value = 0 20 -30,
    curvelabel = Y,
    Generate_Code = Y
  );

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\spider_test02.png,
  desc   =  (%nrstr(%spider_plot))[test02] Test with more parameters , 
  outds  = TEMP.oncoplotter_test
);
