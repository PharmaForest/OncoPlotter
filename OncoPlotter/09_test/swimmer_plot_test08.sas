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
                   imagename="swimmer_test08"
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
        lstvstdt			= ,
        crprN				= 1 2,
        durable			= Y,
        durableLabel		= Durable Period,
        groupvar			= STAGEN,
        groupLabel		= Disease Stage,
        groupN			= 1 2 3 4 5,
        groupC			= Stage I | Stage IIa | Stage IIb | Stage III | Stage IV,
        responseN		= 1 2 3 4,
        responseC		= CR | PR | SD | PD,
        responseLabel	= Response,
        deathLabel		= Death,
        ongoingLabel	= Treatment Ongoing,
        nperpage			= 20,
        width				= 640,
        height				= 480,
        subjidOn			= Y,
        colorStyle		= ,
        groupColor		= orange,
        markerColor		= red,
        markerSymbol	= circlefilled X squarefilled trianglefilled ,
        title				= Swimmer%str(%')s Plot,
        ytitle				= Subject,
        xtitle				= Weeks from treatment,
        xvalues			= 0 to 40 by 4,
        nolegend			= ,
        interval			= Week,
        Generate_Code	= N
)

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test08.png,
  desc   =  (%nrstr(%swimmer_plot))[test08] groupvar colorStyle=null Individually specify the colors and symbols (1/3) , 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test081.png,
  desc   =  (%nrstr(%swimmer_plot))[test08] groupvar colorStyle=null Individually specify the colors and symbols (2/3) , 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test082.png,
  desc   =  (%nrstr(%swimmer_plot))[test08] groupvar colorStyle=null Individually specify the colors and symbols (3/3) , 
  outds  = TEMP.oncoplotter_test
);
