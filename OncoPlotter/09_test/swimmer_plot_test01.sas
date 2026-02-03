/*** HELP START ***//*

### Purpose:
- Unit test for the %swimmer_plot() macro

### Expected result:  
- Three graph plots will be created for swimmer plot.

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output";
ods graphics / reset=all
                   imagename="swimmer_test01"
                   imagefmt=png
                   width=300px
                   height=300px;/*these settings will be overwritten in swimmer plot macro*/

/* Plot */
%Swimmer_Plot(
        adrs				= adrs_dummy,
        adsl				= adsl_dummy,
        whr_adrs			= PARAM="Overall Response" and PARQUAL="IRC",
        whr_adsl			= FASFL="Y",
        eotvar			= EOTSTT,

        groupvar			= STAGEN,
        groupLabel		= Disease Stage,
        groupN			= 1 2 3 4 5,
        groupC			= Stage I | Stage IIa | Stage IIb | Stage III | Stage IV,

        groupColor		= ,
        markerColor		= ,
        markerSymbol	= ,
        title				= Swimmer%str(%')s Plot,

        xvalues			= 0 to 280 by 28,
        interval			= Day        
)

%mp_assertgraph(
gpath1 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\expected\swimmer_test01.png,
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test01.png,
  desc   =  (%nrstr(%swimmer_plot))[test01] Default parameter test (1/3), 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath1 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\expected\swimmer_test011.png,
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test011.png,
  desc   =  (%nrstr(%swimmer_plot))[test01] Default parameter test (2/3), 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath1 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\expected\swimmer_test012.png,
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test012.png,
  desc   =  (%nrstr(%swimmer_plot))[test01] Default parameter test (3/3), 
  outds  = TEMP.oncoplotter_test
);
