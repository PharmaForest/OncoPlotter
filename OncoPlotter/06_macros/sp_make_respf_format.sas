/*** HELP START ***//*

This is internal utility macro used in `%swimmer_plot`.

Purpose:
Create format for response (e.g. 
	proc format ;
		value respf
		1 = "CR"
		2 = "PR"
		;
	run ;

* Author:     Ryo Nakaya
* Date:        2025-07-05
* Version:     0.1

*//*** HELP END ***/

%macro SP_make_respf_format();
proc format;
  value respf
    %do i=1 %to %sysfunc(countw(&responseN, %str( )));
      %let n = %scan(&responseN, &i, %str( ));
      %let c = %scan(&responseC, &i, |);
      &n. = "%superq(c)"
    %end;
  ;
run;
%mend;
