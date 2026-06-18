# Documentation for the `OncoPlotter` package
 
 
OncoPlotter--A SAS package to create figures commonly created in oncology studies
 
 
## Version Information
 
* **Package:** OncoPlotter
* **Version:** 0.5.2
* **Generated:**  
* **Author(s):** [Yutaka Morioka],[Hiroki Yamanobe],[Ryo Nakaya]
* **Maintainer(s):** [Yutaka Morioka],[Hiroki Yamanobe],[Ryo Nakaya]
* **License:** MIT
 
### Required SAS Components
 
* Base SAS Software
 
## Description
 

##  OncoPlotter

**A SAS package to create figures commonly used in oncology studies.**
OncoPlotter is a SAS macro package designed to easily generate key figures typically required in oncology clinical trials.
It supports Kaplan-Meier plots, Swimmer plots, Waterfall plots, Forest Plot and Spider Plot ready for both clinical study reports and publications.
The package also provides dummy datasets, allowing you to test each macro without preparing your own data.
This makes it especially useful for both beginners and advanced users in the oncology data field.

### Main Features

- **Kaplan-Meier Plot (`%kaplan_meier_plot`)**
  - Creates survival curves by treatment group
  - Displays censoring marks and number-at-risk below the plot
  - Fully customizable axis labels, line colors, patterns, and plot titles
  - Option to output generated SAS code via the `MFILE` option
  - Includes internal dummy dataset (`dummy_adtte`) for quick testing

- **Swimmer Plot (`%swimmer_plot`)**
  - Visualizes individual treatment durations, responses, ongoing treatments, and death
  - Accepts ADSL and ADRS-format input datasets
  - Color grouping by disease stage and response categories (e.g., CR, PR, SD, PD)
  - Allows customization of plot size, subjects per page, and theme colors
  - Supports predefined color styles like "OncoPlotter", "Kyoto", "Osaka", and more

- **Waterfall Plot (`%waterfall_plot`)**
  - Displays percentage tumor size change for each subject as bars
  - Bars are grouped and color-coded by response or treatment group
  - Includes threshold lines for PR/PD classification
  - Suitable for visualizing best overall response  

- **Forest Plot (`%forest_plot`)**
  - Create a forest plot using `PROC SGPLOT`.
  - Draw point estimates and confidence intervals.
  - Optional reference line and code generation (mprint dump) are supported.
  - Includes internal dummy dataset (`dummy_forest_test`) for quick testing.

- **Spider Plot (`%spider_plot`)**
  - Create a spider (subject profile) plot using `PROC SGPLOT`.
  - Draw a series line (with markers) for each subject across the specified X variable and Y variable.
  - Optional reference lines, custom axis labels/values, and code generation (mprint dump) are supported.
  - Includes internal dummy dataset (`dummy_spider`) for quick testing.

### Usage

For more details, please visit https://github.com/PharmaForest/OncoPlotter

---
 
## Contents
The `OncoPlotter` package consists of the following content:
 
 
* [data ](#data )
* [macros ](#macros )
 
### data
 
* [`01_adsl_dummy`data](data.md#01_adsl_dummy)
* [`02_adrs_dummy`data](data.md#02_adrs_dummy)
* [`_02_adrs_dummy`data](data.md#_02_adrs_dummy)
* [`_03_adtr_dummy`data](data.md#_03_adtr_dummy)
 
### macros
 
* [`%forest_plot()`macro](macros.md#forest_plot)
* [`%kaplan_meier_plot()`macro](macros.md#kaplan_meier_plot)
* [`%sp_change()`macro](macros.md#sp_change)
* [`%sp_make_groupf_format()`macro](macros.md#sp_make_groupf_format)
* [`%sp_make_respf_format()`macro](macros.md#sp_make_respf_format)
* [`%sp_split_plot()`macro](macros.md#sp_split_plot)
* [`%spider_plot()`macro](macros.md#spider_plot)
* [`%swimmer_plot()`macro](macros.md#swimmer_plot)
* [`%waterfall_plot()`macro](macros.md#waterfall_plot)
 
## License
 
```text
Copyright (c) [2025]  [Yutaka Morioka],[Hiroki Yamanobe],[Ryo Nakaya]
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
 
