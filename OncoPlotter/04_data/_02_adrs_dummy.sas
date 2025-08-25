/*** HELP START ***//*

## Create dummy datasets
ADRS_DUMMY

*//*** HELP END ***/

/*Generate ADRS*/
data ADRS_DUMMY;
  set ADSL_DUMMY;
  format ADT date9.;
  length PARAM $40. PARAMCD $8. PARQUAL $15. AVISIT $10. AVALC $4. ;
  
  call streaminit(456);

  array PARAM_LIST[3] $40 _temporary_ ('Overall Response', 'Target Response', 'Non-Target Response');
  array PARAMCD_LIST[3] $8 _temporary_ ('OVRLRS', 'TARGETRS', 'NONTGTRS');
  array PARQUAL_LIST[2] $15 _temporary_ ('INVESTIGATOR', 'IRC');
  array AVISIT_LIST[5] $10 _temporary_ ('Week 3', 'Week 6', 'Week 12', 'Week 18', 'Week 24');
  array AVISITN_LIST[5] 8. _temporary_ (3,6,12,18,24);

  retain PD_FLAG 0;

  do p = 1 to dim(PARAM_LIST);
    do q = 1 to dim(PARQUAL_LIST);

      PD_FLAG = 0;  /* reset PD_FLAG per subject, parameter, perqual */

      do v = 1 to dim(AVISIT_LIST);

        if PD_FLAG then leave; /* Stop if PD exists */

        PARAM    = PARAM_LIST[p];
		PARAMCD  = PARAMCD_LIST[p];
        PARQUAL  = PARQUAL_LIST[q];
        AVISIT   = AVISIT_LIST[v];
        AVISITN  = AVISITN_LIST[v];

        /* +-3 days around scheduled visit */
        base_day = input(scan(AVISIT, 2), best.) * 7;
        jitter   = round(rand("uniform") * 6 - 3); 
        ADY = base_day + jitter;
        ADT = TRTSDT + ADY - 1;

        /* Randomly assign tumor response (higher rate of CR/PR/SD first and then PD) */
        rand_val = rand("uniform");
        if v < 3 then do;
          if rand_val < 0.5 then do; AVALC = "SD"; AVAL=3 ; end ;
          else if rand_val < 0.7 then do; AVALC = "PR"; AVAL=2 ; end ;
          else if rand_val < 0.9 then do; AVALC = "CR"; AVAL=1 ; end ;
          else do; AVALC = "PD"; AVAL=4 ;
            PD_FLAG = 1;
          end;
        end;
        else do;
          if rand_val < 0.3 then do; AVALC = "SD"; AVAL=3 ; end ;
          else if rand_val < 0.5 then do; AVALC = "PR"; AVAL=2 ; end ;
          else if rand_val < 0.6 then do; AVALC = "CR"; AVAL=1 ; end ;
          else do; AVALC = "PD"; AVAL=4 ; 
            PD_FLAG = 1;
          end;
        end;

        output;
      end;
    end;
  end;

  keep STUDYID SITEID USUBJID PARAM PARAMCD PARQUAL AVISIT AVISITN ADT ADY AVAL AVALC
	TRT01P SEX FASFL TRTSDT TRTEDT ;
run;
proc sort data=ADRS_DUMMY out=_TMP01 ; by USUBJID ; run ;
data _TMP02 ;
	set _TMP01(where=(PARAMCD="OVRLRS" and PARQUAL="IRC")) ;
	by USUBJID ;
	if first.USUBJID ;
	ANL01FL="Y" ;
	PARAM="Best Overall Response" ;
	PARAMCD="BORIRC" ;
	AVISIT="" ;
	AVISITN=. ;
	ADY=. ;
run ;
data ADRS_DUMMY ;
	set ADRS_DUMMY _TMP02 ;
run ;
proc sort data=ADRS_DUMMY ; by USUBJID PARAMCD AVISITN ; run ;

proc datasets lib=WORK ;
	delete _TMP01 _TMP02 ;
run ; quit ;
