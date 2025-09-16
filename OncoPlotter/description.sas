Type : Package
Package : OncoPlotter
Title : OncoPlotter--A SAS package to create figures commonly created in oncology studies
Version : 0.3.3
Author : [Yutaka Morioka],[Hiroki Yamanobe],[Ryo Nakaya]
Maintainer : [Yutaka Morioka],[Hiroki Yamanobe],[Ryo Nakaya]
License : MIT
Encoding : UTF8
Required : "Base SAS Software"
ReqPackages :  

DESCRIPTION START:

## ?? OncoPlotter

**A SAS package to create figures commonly used in oncology studies.**

OncoPlotter is a SAS macro package designed to easily generate key figures typically required in oncology clinical trials.  
It supports Kaplan-Meier plots, Swimmer plots, and Waterfall plots?ready for both clinical study reports and publications.  
The package also provides dummy datasets, allowing you to test each macro without preparing your own data.  
This makes it especially useful for both beginners and advanced users in the oncology data field.  

### Main Features

- ?**Kaplan-Meier Plot (`%kaplan_meier_plot`)**  
  - Creates survival curves by treatment group  
  - Displays censoring marks and number-at-risk below the plot  
  - Fully customizable axis labels, line colors, patterns, and plot titles  
  - Option to output generated SAS code via the `MFILE` option  
  - Includes internal dummy dataset (`dummy_adtte`) for quick testing

- ?**Swimmer Plot (`%swimmer_plot`)**  
  - Visualizes individual treatment durations, responses, ongoing treatments, and death  
  - Accepts ADSL and ADRS-format input datasets  
  - Color grouping by disease stage and response categories (e.g., CR, PR, SD, PD)  
  - Allows customization of plot size, subjects per page, and theme colors  
  - Supports predefined color styles like "OncoPlotter", "Kyoto", "Osaka", and more

- ?**Waterfall Plot (`%waterfall_plot`)**  
  - Displays percentage tumor size change for each subject as bars  
  - Bars are grouped and color-coded by response or treatment group  
  - Includes threshold lines for PR/PD classification  
  - Suitable for visualizing best overall response

---
DESCRIPTION END:
