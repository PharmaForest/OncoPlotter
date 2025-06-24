# OncoPlotter
A SAS package to create figures commonly created in oncology studies  
![OncoPlotter](./OncoPlotter_Logo_small.png)  

The repo will be collaborative work.
# `%kaplan_meier_plot()` macro <a name="kaplanmeierplot-macros-1"></a> 

* Program:     kaplan_meier_plot.txt
* Macro:       %kaplan_meier_plot
*
* Purpose:     This macro generates Kaplan-Meier survival plots using PROC LIFETEST in SAS.
*              It produces survival curves by group, displays censoring marks, and includes
*              the number at risk at each time point on the plot.
*
* Features:
*   - Optionally generates an internal example dataset (e.g., `dummy_adtte`)
*   - Customizable group labels, colors, and line patterns
*   - Supports plotting of censored observations
*   - Configurable axis and display settings
*   - Supports MFILE option to export generated SAS code
*
* Parameters:
*   data=                  Input dataset name (e.g., dummy_adtte)
*   groupn=                Numeric group variable (e.g., TRTPN)
*   groupc=                Character group label variable (e.g., TRTP)
*   wh=                    WHERE condition to subset data (optional)
*   Time_var=              Time-to-event variable (e.g., AVAL)
*   Censore_var=           Censoring indicator variable (e.g., CNSR)
*   Censore_val=           Value indicating censored observations (e.g., 1)
*   Title=                 Plot title (default: "Kaplan-Meier Plot")
*   Group_color_list=      Color list for group lines (e.g., "black red blue green")
*   Group_linepattern_list= Line pattern list for groups (e.g., "solid dash longdash dot")
*   XLABEL=                Label for the X-axis (e.g., "Survival Time (Month)")
*   YLABEL=                Label for the Y-axis (e.g., "Probability of Survival")
*   AxisValues=            Tick marks for the X-axis (e.g., "0 to 16 by 2")
*   Delete_Process_Data=   Option to delete intermediate datasets (Y/N, not used)
*   Generate_Code=         Option to output MFILE-generated SAS code (Y/N)
*
* Example usage:
*   %kaplan_meier_plot(
*       data = dummy_adtte,
*       groupn = TRTPN,
*       groupc = TRTP,
*       Time_var = AVAL,
*       Censore_var = CNSR,
*       Censore_val = 1,
*       Title = %nrquote(Kaplan-Meier Curve Example),
*       Group_color_list = %nrquote(black red blue green),
*       Group_linepattern_list = %nrquote(solid dash longdash shortdash),
*       XLABEL = %nrquote(Survival Time (Month)),
*       YLABEL = %nrquote(Probability),
*       AxisValues = %nrquote(0 to 24 by 4),
*       Generate_Code = Y
*   );
*
* Author:     Yutaka Morioka
* Date:        2025-06-24
* Version:     0.1

  
---
 
