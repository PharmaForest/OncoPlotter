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
                   imagename="swimmer_test03"
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
        nperpage			= 40,
        width				= 480,
        height				= 640,
        subjidOn			= Y,
        colorStyle		= Salmon,
        groupColor		= ,
        markerColor		= ,
        markerSymbol	= ,
        title				= Swimmer%str(%')s Plot,
        ytitle				= Subject,
        xtitle				= Months from treatment,
        xvalues			= 0 to 10 by 2,
        nolegend			= ,
        interval			= Month,
        Generate_Code	= N
)

%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test03.png,
  desc   =  (%nrstr(%swimmer_plot))[test03] colorStyle=Salmon  Vertically oriented (portrait) chart (1/2) , 
  outds  = TEMP.oncoplotter_test
);
%mp_assertgraph(
gpath2 = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation\output\swimmer_test031.png,
  desc   =  (%nrstr(%swimmer_plot))[test03] olorStyle=Salmon  Vertically oriented (portrait) chart (2/2) , 
  outds  = TEMP.oncoplotter_test
);
