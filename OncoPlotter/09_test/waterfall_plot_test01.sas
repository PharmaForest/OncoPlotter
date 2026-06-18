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
                   imagename="waterfall_test01"
                   imagefmt=png
                   width=300px
                   height=300px;

/* Plot */

%Waterfall_Plot(
            adrs = adrs_dummy,
            adtr = adtr_dummy,
            adsl = adsl_dummy,
			whr_adrs  = PARAM="Best Overall Response",
			whr_adtr  = PARAM="Sum of Diameters" and PARQUAL="IRC" and TRGRPID="TARGET" and ANL01FL="Y",
			whr_adsl  = FASFL="Y",
			groupVar     = AVAL,
			groupLabel   = Best Overall Response:,
			groupN     = 1 2 3,
			groupC     = CR | PR | SD,
			groupColor = red | blue | green,
			responseVar  = PCHG,



			title   = Waterfall Plot of Tumor Shrinkage,


			y_refline=-30 20
   );


/* Assert graph*/
%mp_assertgraph(
gpath1 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\expected\waterfall_test01.png,
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\waterfall_test01.png,
  desc   =  (%nrstr(%Waterfall_Plot))[test01] Default parameter test , 
  outds  = TEMP.oncoplotter_test
);
