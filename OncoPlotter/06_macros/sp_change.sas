/*** HELP START ***//*

This is internal utility macro previously used in `%swimmer_plot` and `%waterfall_plot` until v0.5.1, but no longer used.

Purpose:
Change separater of | to "","" (e.g. CR | PR | SD   ->   "CR","PR","SD")
* Author:     Ryo Nakaya
* Date:        2025-07-05
	2026-05-27 : Bug fixed (added "G" in call symputx)

*//*** HELP END ***/

%macro SP_change(var=) ;
data _null_;
	length quoted $1000;
	quoted = '';
	do i = 1 to countw(symget("&var"), '|');
		word = scan(symget("&var"), i, '|');
		if i = 1 then quoted = cats('"', word, '"');
		else quoted = catx(',', quoted, cats('"', word, '"'));
	end;
	call symputx(cats("&var", "_quoted"), quoted, "G");
run;
%mend ;
