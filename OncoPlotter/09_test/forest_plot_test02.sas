/*** HELP START ***//*

### Purpose:
- Unit test for the forest_plot() macro

### Expected result:  
- TEMP.corr_test dataset will be created with test_result=CHECK

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output"; /*Ç±ÇÃÇ‹Ç‹*/

ods graphics / reset=all
                   imagename="forest_test02"
                   imagefmt=png
                   width=300px
                   height=300px;/*forest_plotÇÃíÜÇÃê›íËÇ≈è„èëÇ´Ç≥ÇÍÇÈçÄñ⁄Ç†ÇËÅiimagenameÇÕê∂Ç´ÇÈÅj*/

/*test data*/
data forest_data_test;
    length
        col1 $20
        col2 $3
        col3 $6
        col4 $5
        col5 $13
        lower_limit 8
        estimate    8
        upper_limit 8
    ;

    infile datalines dlm='|' dsd truncover;

    input
        col1         :$20.
        col2         :$3.
        col3         :$6.
        col4         :$5.
        col5         :$13.
        lower_limit  :best32.
        estimate     :best32.
        upper_limit  :best32.
    ;

datalines;
Age|||||||
< 65|345|(99.9)|0.82|[0.63-1.07]|1.05|1.50|1.90
65 - < 75|468|(99.9)|1.05|[0.83-1.32]|0.40|0.70|1.15
>= 75|374|(99.9)|1.28|[1.02-1.60]|0.60|0.80|1.25
Sex|||||||
Male|732|(99.9)|1.08|[0.90-1.30]|1.20|1.50|1.80
Female|464|(99.9)|1.01|[0.80-1.27]|0.60|0.80|1.00
Race or ethnic group|||||||
AAA|730|(99.9)|1.07|[0.90-1.29]|0.60|1.05|1.20
BBB|466|(99.9)|1.02|[0.80-1.28]|0.85|1.20|1.60
COMPLICATION|||||||
Yes|896|(99.9)|99.99|[99.99-99.99]|0.90|1.40|2.00
No|300|(99.9)|99.99|[99.99-99.99]|0.80|1.10|1.50
;
run;


/*%forest_plot*/

  %forest_plot(
    data=WORK.Forest_data_test,
    out1=col1,
    out2=col4,
    out3=col5,
    marker_point=estimate,
    bar_left=lower_limit,
    bar_right=upper_limit,
    out1_label=%nrbquote(Sub Group),
    out2_label=%nrbquote(HR),
    out3_label=%nrstr(HR 95 %CL),
    AxisValues=%nrbquote(0.0 to 3.0 by 0.5),
    refline_value=1,
    bar_color=blue,
    marker_color=green,
    Generate_Code=N
  );


/* Assert graph*/
%mp_assertgraph(
 gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\forest_test02.png,
  desc   =  (%nrstr(%forest_plot))[test02] Test with more parameters , 
  outds  = TEMP.oncoplotter_test
);
