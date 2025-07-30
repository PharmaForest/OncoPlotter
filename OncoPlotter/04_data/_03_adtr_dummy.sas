/*** HELP START ***//*

## Create dummy datasets
ADTR_DUMMY

*//*** HELP END ***/

/*Generate ADTR*/
proc sort data=adrs_dummy out=___ADTR1;
  by USUBJID;
run;
data ___ADTR2;
  set ___ADTR1;
  where PARAMCD in ("TARGETRS","NONTGTRS");
  where same PARQUAL eq "IRC";
  by USUBJID;

  if      PARAMCD eq "NONTGTRS" then TRGRPID="NON-TARGET";
  else if PARAMCD eq "TARGETRS" then TRGRPID="TARGET";
  PARAM="Sum of Diameters";
  PARAMCD="SUMDIAM";

call streaminit(456);
  BASE = round(50 + rand("uniform") * 100, 0.1);
  AVAL = round(80 + rand("uniform") * 100, 0.1);
  CHG  = AVAL - BASE;
  PCHG = round((AVAL - BASE) / BASE * 100, 0.1);

drop AVALC;
run;

proc sort data=___ADTR2;
  by USUBJID PCHG;
run;
data adtr_dummy;
  set ___ADTR2;
  by USUBJID PCHG;

  if first.USUBJID then ANL01FL="Y";
run;


proc delete data=___ADTR1 ___ADTR2;
run;
