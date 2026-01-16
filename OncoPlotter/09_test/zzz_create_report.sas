/*** HELP START ***//*

### Purpose:
- Create validation report using %create_report()

*//*** HELP END ***/

%loadPackage(valivali)
%set_tmp_lib(lib=TEMP, winpath=C:\Temp, otherpath=/tmp, newfolder=oncoplotter)

/*Create report*/
%create_report(
  sourcelocation = C:\Temp\SAS_PACKAGES\packages\oncoplotter,
  reporter = Ryo Nakaya,

  general = %nrstr(
OncoPlotter is a SAS macro package designed to easily generate key figures typically required in oncology clinical trials.
It supports Kaplan-Meier plots, Swimmer plots, and Waterfall plots ready for both clinical study reports and publications.
The package also provides dummy datasets, allowing you to test each macro without preparing your own data.
This makes it especially useful for both beginners and advanced users in the oncology data field.
  ),

  requirements = %nrstr(
- %kaplan_meier_plot :  ^{newline}
  - Creates survival curves by treatment group ^{newline}
  - Displays censoring marks and number-at-risk below the plot ^{newline}
  - Fully customizable axis labels, line colors, patterns, and plot titles ^{newline}
  - Option to output generated SAS code via the `MFILE` option ^{newline}
  - Includes internal dummy dataset (`dummy_adtte`) for quick testing ^{newline}
  ^{newline}
- %swimmer_plot :  ^{newline}
  - Visualizes individual treatment durations, responses, ongoing treatments, and death ^{newline}
  - Accepts ADSL and ADRS-format input datasets ^{newline}
  - Color grouping by disease stage and response categories (e.g., CR, PR, SD, PD) ^{newline}
  - Allows customization of plot size, subjects per page, and theme colors ^{newline}
  - Supports predefined color styles like `OncoPlotter`, `Kyoto`, `Osaka`, and more ^{newline}
  ^{newline}
- %waterfall_plot :  ^{newline}
  - Displays percentage tumor size change for each subject as bars ^{newline}
  - Bars are grouped and color-coded by response or treatment group ^{newline}
  - Includes threshold lines for PR/PD classification ^{newline}
  - Suitable for visualizing best overall response ^{newline}
  ),
  results = TEMP.oncoplotter_test,
  additional = %nrstr(
	NA
  ), 
  references = %nrstr(
	https://github.com/PharmaForest/oncoplotter
  ), 
  outfilelocation = C:\Temp\SAS_PACKAGES\packages\oncoplotter\validation 
) ;
