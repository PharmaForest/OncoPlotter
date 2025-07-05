/*** HELP START ***//*

This is internal utility macro used in `%swimmer_plot`.

Purpose:
Change separater of | to "","" (e.g. CR | PR | SD   ->   "CR","PR","SD")

* Author:     Ryo Nakaya
* Date:        2025-07-05
* Version:     0.1

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
  call symputx(cats("&var", "_quoted"), quoted);
run;
%mend ;