/*** HELP START ***//*

 ## Create dummy datasets
   ADSL_DUMMY

*//*** HELP END ***/


/* Generate ADSL */
data ADSL_DUMMY;
  length STUDYID  $10. SITEID $3. SUBJID $7. USUBJID $25. SEX $1. ARMCD $4. ARM $20.
	TRT01P $20. FASFL $1. STAGE $9. STAGEN 8. AGEGR1 $10. EOTSTT $15. AGE 8. ;
  format TRTSDT TRTEDT DTHDT date9.;

  call streaminit(123);

  array SUBJNUM[5] _temporary_ (0 0 0 0 0); /* subject number per site */

  /* 50 subjects */
  do i = 1 to 50;

    STUDYID = "STUDY001";

    /* SITEID (001 - 005) */
    SITE_INDEX = ceil(rand("uniform")*5);
    SITEID = put(SITE_INDEX, z3.);

    /* Count up subject number */
    SUBJNUM[SITE_INDEX] + 1;

    /* SUBJID, USUBJID */
    SUBJID = cats(SITEID, "-", put(SUBJNUM[SITE_INDEX], z3.));
    USUBJID = cats(STUDYID, "-", SUBJID);

    SEX = ifc(mod(i,2)=0, "M", "F");

    AGE = 20 + mod(i*7, 45);
    AGEGR1 = ifc(.<AGE < 40, "<40", ">=40");

    select (mod(i,3));
      when (0) do; ARMCD = "A"; ARM = "Placebo"; end;
      when (1) do; ARMCD = "B"; ARM = "Drug 10mg"; end;
      when (2) do; ARMCD = "C"; ARM = "Drug 20mg"; end;
    end;
    TRT01P = ARM;

    TRTSDT = '01JAN2024'd + i ;
    TRTEDT = TRTSDT + 100 + 2*mod(i,20);

    FASFL = ifc(rand("uniform") <= 0.1, "N", "Y");

    select (mod(i,5));
      when (0) do; STAGE = "Stage I"; STAGEN=1 ; end ;
      when (1) do; STAGE = "Stage IIa"; STAGEN=2 ; end ;
	  when (2) do; STAGE = "Stage IIb" ; STAGEN=3 ; end ;
      when (3) do; STAGE = "Stage III"; STAGEN=4 ; end ;
      when (4) do; STAGE = "Stage IV"; STAGEN=5 ; end ;
    end;

    if mod(i,10)=0 then 
      DTHDT = TRTEDT + ceil(rand("uniform") * 30);
    else DTHDT = .;

    pct = rand("uniform");
    if .<pct < 0.7 then EOTSTT = "ONGOING";
    else if pct <= 1 then EOTSTT = "DISCONTINUED";
 
    output;
  end;

  drop i pct site_index;
run;