/*** HELP START ***//*

This is internal utility macro used in `%swimmer_plot`.
Purpose:
Create format for groupvar (e.g.
	proc format ;
		value groupf
		1 = "Stage I"
		2 = "Stage II"
		;
	run ;
* Author:     Ryo Nakaya
* Date:        2025-07-05
* Version:     0.1

*//*** HELP END ***/

%macro SP_make_groupf_format();
proc format;
value groupf
%do i=1 %to %sysfunc(countw(&groupN, %str( )));
%let n = %scan(&groupN, &i, %str( ));
%let c = %scan(&groupC, &i, |);
&n. = "%superq(c)"
%end;
;
run;
%mend;
