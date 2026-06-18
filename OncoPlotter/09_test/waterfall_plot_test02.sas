/*** HELP START ***//*

### Purpose:
- Unit test for the Waterfall_Plot() macro

### Expected result:  
- TEMP.corr_test dataset will be created with test_result=CHECK

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output";
ods graphics / reset=all
                   imagename="waterfall_test02"
                   imagefmt=png
                   width=300px
                   height=300px;

/* Plot */

%Waterfall_Plot(
            adrs = adrs_dummy,
            adtr = adtr_dummy,
            adsl = adsl_dummy,
            whr_adrs = PARAMCD = "BORIRC",
            whr_adtr = PARAMCD = "SUMDIAM" and PARQUAL="IRC" and TRGRPID="TARGET" and ANL01FL="Y",
            whr_adsl = FASFL = "Y",
            groupVar = AVAL,
            groupLabel = Best Overall Response:,
            groupN = 1 2 3 4,
            groupC = CR | PR | SD | PD,
            groupColor = red | green | blue | gray,
            responseVar = PCHG,
			VarWidth     = 0.7,
            width = 800,
            height = 450,
			dpi       = 300,
            title = Figure 14.2.x,
            ytitle = Change from Baseline (%),
            yvalues = -75 to 100 by 25,
            Generate_Code = Y
   );


/* Assert graph */
%mp_assertgraph(
gpath1 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\expected\waterfall_test02.png,
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\waterfall_test02.png,
  desc   =  (%nrstr(%Waterfall_Plot))[test02] Test with more parameters , 
  outds  = TEMP.oncoplotter_test
);

