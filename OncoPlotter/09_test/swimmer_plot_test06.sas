/*** HELP START ***//*

### Purpose:
- Unit test for the %swimmer_plot() macro

### Expected result:  
- Two graph plots will be created for swimmer plot.

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

ods listing gpath="C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output"; 
ods graphics / reset=all
                   imagename="swimmer_test06"
                   imagefmt=png
                   width=300px
                   height=300px;/*these settings will be overwritten in swimmer plot macro*/

/* Plot */
%Swimmer_Plot(
        adrs				= adrs_dummy,
        adsl				= adsl_dummy,
        whr_adrs			= PARAM="Overall Response" and PARQUAL="IRC",
        whr_adsl			= FASFL="Y",
        eotvar			=EOTSTT,
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
        nperpage			= 30,
        width				= 640,
        height				= 480,
        subjidOn			= Y,
        colorStyle		= Osaka,
        groupColor		= ,
        markerColor		= ,
        markerSymbol	= ,
        title				= Swimmer%str(%')s Plot,
        ytitle				= Subject,
        xtitle				= Days from Treatment,
        xvalues			= 0 to 280 by 28,
        nolegend			= ,
        interval			= Day,
        Generate_Code	= N
)

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test06.png,
  desc   =  (%nrstr(%swimmer_plot))[test06] colorStyle=Osaka  interval=Day (1/2) , 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test061.png,
  desc   =  (%nrstr(%swimmer_plot))[test06] colorStyle=Osaka  interval=Day (2/2) , 
  outds  = TEMP.oncoplotter_test
);
