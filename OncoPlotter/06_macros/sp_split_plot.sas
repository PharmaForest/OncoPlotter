/*** HELP START ***//*

This is internal macro used in `%swimmer_plot`.
This macro is main functionality including sgplot.

* Author:     Ryo Nakaya
* Date:        2025-07-05
* Version:     0.1

*//*** HELP END ***/

%macro SP_split_plot;
  %do i = 1 %to &npage.;
    %let start = %eval((&i. - 1) * &nperpage. + 1);
    %let end = %eval(&i. * &nperpage.);

    data PLOT_SUBSET;
      set PLOT_DATA;
      if item >= &start. and item <= &end.;
    run;

      /* initialize yvals/ylabels for y-axis label */
      data _null_;
        call symputx('yvals', '');
        call symputx('ylabels', '');
      run;

      /* To add dummy item */
      proc sort data=PLOT_SUBSET out=PLOT_SUBSET_SORT; 
        by item;
      run;
	  proc sort data=PLOT_SUBSET_SORT out=ITEM_LIST(keep=item SUBJID) nodupkey ;
		by item;
	  run;

      proc sql noprint;
        select count(*) into :real_n from ITEM_LIST; /* number of items */
      quit;

      data _null_;
        set ITEM_LIST end=last;
        if last then call symputx('itemmax', item); /* max item */
      run;

      data ITEM_LIST1;
        set ITEM_LIST end=last;
        output;
        if last then do;
          do newitem = &itemmax.+1 to &start.+&nperpage.-1;
            item = newitem;
            subjid = '';
            output;
          end;
        end;
        drop newitem;
      run;

      /* yvals/ylabels for y-axis */
	  %if &subjidOn. = Y %then %do ;
	      data _null_;
	        call symputx('yvals', '');
	        call symputx('ylabels', '');
	      run;
	      data _null_;
	        set ITEM_LIST1 end=last;
	        call symputx('yvals', catx(' ', symget('yvals'), item));
	        call symputx('ylabels', catx(' ', symget('ylabels'), cats('"', strip(SUBJID), '"')));
	        if last then do;
	          call symputx('yvals', strip(symget('yvals')));
	          call symputx('ylabels', strip(symget('ylabels')));
	        end;
	      run;
		%end ;
		%else %do ;
	      data _null_;
	        call symputx('yvals', '');
	        call symputx('ylabels', '');
	      run;
	      data _null_;
	        set ITEM_LIST1 end=last;
	        call symputx('yvals', catx(' ', symget('yvals'), item));
  			call symputx('ylabels', catx(' ', symget('ylabels'), '""')); /*all null*/
	        if last then do;
	          call symputx('yvals', strip(symget('yvals')));
	          call symputx('ylabels', strip(symget('ylabels')));
	        end;
	      run;
		%end ;

      /* adding dummy to plot_subset */
	proc sort data=PLOT_SUBSET; by item; run;
	proc sort data=ITEM_LIST1; by item; run;

	data PLOT_SUBSET2;
	  /*for first dummy records having groupvar.
	     datacolors in sgplot (e.g. color1 color2,...,color5) are matched to the categories of data
	     appeared firstly in the plot(e.g. order of data appearance like 5,4,2,1,3 matches to above colors).
         To match with asending order of categories 1,2,3,4,5, dummy records with ascending order is created here. 
	*/
	  do group_idx = 1 to &groupN_n.;
		&groupvar. = group_idx;
 		item = .;   
	    output;
  	  end;
	  do aval_idx = 1 to &responseN_n.;
	    AVAL = aval_idx;
	    item = .;
	    output;
	  end;

	  merge PLOT_SUBSET(in=a) ITEM_LIST1(in=b);
	  by item;
	  if a then output;
	  else do; /*add extra records with dummy item(to have same width of bars across plots)*/
	    array groupns{&groupN_n.} 8 _temporary_ (&groupN_comma.);
	    array avals{&responseN_n.} 8 _temporary_ (&responseN_comma.);

	    group_idx = mod(item-&itemmax.-1, &groupN_n.) + 1;
	    aval_idx = mod(item-&itemmax-1, &responseN_n.) + 1;
	    &groupvar. = groupns{group_idx};
	    AVAL = avals{aval_idx};
	    output;
	  end;
	  drop group_idx aval_idx;
	run;
	data PLOT_SUBSET2 ;
		set PLOT_SUBSET2 ;
		if AVAL=. then AVAL=1 ;/*dummy for not showing # in legend*/
	run ;

      title "&title &i of &npage";
      proc sgplot data=PLOT_SUBSET2 nocycleattrs %if &nolegend.=Y %then %do ; noautolegend %end ; ;
	    format &groupvar. groupf. AVAL respf. ;

        highlow y=item low=low high=high / 
          group=&groupvar. grouporder=ascending type=bar fill nooutline 
          lineattrs=(color=black) transparency=0
          highcap=endcap legendlabel="&groupLabel"
		  name="group" ;
		  %if %superq(colorStyle) ne %str() %then %do;
			  %if %sysfunc(strip(%upcase(&colorStyle.))) = ONCOPLOTTER %then %do ; 
				styleattrs datacolors=(CXE2E9ED CXA1B5C3 CX85A0B8 CX688AAD CX283E59) 
					datasymbols=(squarefilled trianglefilled circlefilled X) ;
			  %end ;
			  %else %if %sysfunc(strip(%upcase(&colorStyle.))) = SALMON %then %do ; 
				styleattrs datacolors=(lightgrey CXDAADAD CXBC8F8F pink red)
					datasymbols=(squarefilled trianglefilled circlefilled X) ;
			  %end ;
			  %else %if %sysfunc(strip(%upcase(&colorStyle.))) = KAWAII %then %do ; 
				styleattrs datacolors=(lightpink thistle lightblue lightyellow lightgreen) 
					datasymbols=(squarefilled trianglefilled circlefilled X) ;
			  %end ;
			  %else %if %sysfunc(strip(%upcase(&colorStyle.))) = KYOTO %then %do ; 
				styleattrs datacolors=(lightgrey CX7058A3 CX8F9779 CXD69090 CXBAB45E) 
					datasymbols=(squarefilled trianglefilled circlefilled X) ;
			  %end ;
			  %else %if %sysfunc(strip(%upcase(&colorStyle.))) = OSAKA %then %do ; 
				styleattrs datacolors=(CXFFF200 lightgrey CXE60012 CX996600 thistle) 
					datasymbols=(squarefilled trianglefilled circlefilled X) ;
			  %end ;
		   %end ;
 		   %else %do ;
		   	%put &groupColor. &markerSymbol. ;
				styleattrs datacolors=(&groupColor.) 
					datasymbols=(&markerSymbol.) ;
		   %end ;

	   %if &durable. = Y %then %do ;
        highlow y=item low=durable_low high=durable_high / 
          lineattrs=(thickness=2 pattern=solid color=
		  %if %superq(colorStyle) ne %str() %then %do;
			%if %sysfunc(strip(%upcase(&colorStyle.))) = ONCOPLOTTER %then %do ; CXF24F00 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = SALMON		   %then %do ; black %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KAWAII			   %then %do ; CXDB5C5C %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KYOTO			   %then %do ; CX444444 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = OSAKA			   %then %do ; black %end ;
		  %end ;
		  %else %do ; &markerColor. %end ;
		  )
          nooutline legendlabel="&durableLabel" name="durable";
		%end ;

        scatter y=item x=ADY / group=AVAL grouporder=ascending
          markerattrs=(size=10 color=
		  %if %superq(colorStyle) ne %str() %then %do;
			%if %sysfunc(strip(%upcase(&colorStyle.))) = ONCOPLOTTER %then %do ; CXF24F00 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = SALMON		   %then %do ; black %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KAWAII			   %then %do ; CXDB5C5C %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KYOTO			   %then %do ; CX444444 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = OSAKA			   %then %do ; black %end ;
		  %end ;
		  %else %do ; &markerColor. %end ;
		  ) legendlabel="&responseLabel" name="response";

        scatter y=item x=marker_d / legendlabel="&deathLabel" name="death"
          markerattrs=(symbol=star color=
		  %if %superq(colorStyle) ne %str() %then %do;
			%if %sysfunc(strip(%upcase(&colorStyle.))) = ONCOPLOTTER %then %do ; CXF24F00 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = SALMON		   %then %do ; black %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KAWAII			   %then %do ; CXDB5C5C %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = KYOTO			   %then %do ; CX444444 %end ;
			%else %if %sysfunc(strip(%upcase(&colorStyle.))) = OSAKA			   %then %do ; black %end ;
		  %end ;
		  %else %do ; &markerColor. %end ;
		size=12) ;

        scatter y=ymin x=low / markerattrs=(symbol=trianglerightfilled size=14 color=darkgray)
           legendlabel="&ongoingLabel" name='dummy' ;

        xaxis label="&xtitle" values=(&xvalues.);
        yaxis reverse display=(noticks) label="&ytitle"
          values=(&yvals) valuesdisplay=(&ylabels);

		%if &nolegend. ne Y %then %do ;
        keylegend "response"	   %if &durable. = Y %then %do ; "durable" %end ;
			"death" "dummy" / border location=inside position=bottomright across=1;
        keylegend 'group' / title="&groupLabel" ;
		%end ;
      run;
  %end;
%mend;
