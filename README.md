# OncoPlotter
A SAS package to create figures commonly created in oncology studies  
![OncoPlotter](./OncoPlotter_Logo_small.png)  

The repo will be collaborative work.
# `%kaplan_meier_plot()` macro <a name="kaplanmeierplot-macros-1"></a> 
<br>
Macro:       %kaplan_meier_plot<br>
<br>
Purpose:     This macro generates Kaplan-Meier survival plots using PROC LIFETEST in SAS.<br>
              It produces survival curves by group, displays censoring marks, and includes<br>
              the number at risk at each time point on the plot.<br>
<br>
 Features:<br>
   - Optionally generates an internal example dataset (e.g., `dummy_adtte`)<br>
   - Customizable group labels, colors, and line patterns<br>
   - Supports plotting of censored observations<br>
   - Configurable axis and display settings<br>
   - Supports MFILE option to export generated SAS code<br>
<br>
 Parameters:<br>
   data=                  Input dataset name (e.g., dummy_adtte)<br>
   groupn=                Numeric group variable (e.g., TRTPN)<br>
   groupc=                Character group label variable (e.g., TRTP)<br>
   wh=                    WHERE condition to subset data (optional)<br>
   Time_var=              Time-to-event variable (e.g., AVAL)<br>
   Censore_var=           Censoring indicator variable (e.g., CNSR)<br>
   Censore_val=           Value indicating censored observations (e.g., 1)<br>
   Title=                 Plot title (default: "Kaplan-Meier Plot")<br>
   Group_color_list=      Color list for group lines (e.g., "black red blue green")<br>
   Group_linepattern_list= Line pattern list for groups (e.g., "solid dash longdash dot")<br>
   XLABEL=                Label for the X-axis (e.g., "Survival Time (Month)")<br>
   YLABEL=                Label for the Y-axis (e.g., "Probability of Survival")<br>
   AxisValues=            Tick marks for the X-axis (e.g., "0 to 16 by 2")<br>
   Generate_Code=         Option to output MFILE-generated SAS code (Y/N)<br>
<br>
 Example usage:<br>
%kaplan_meier_plot( );
 <br>
<img width="565" alt="Image" src="https://github.com/user-attachments/assets/df08440b-b38d-42d6-b8e5-24b13e253b27" />
<br>
<img width="887" alt="Image" src="https://github.com/user-attachments/assets/0ae04e03-d763-4cc1-9207-451fe55338e7" />
<br>
👆When run without specifying anything, it automatically draws with dummy data and even opens plain SAS code as text.<br>
 <br>
 %kaplan_meier_plot(<br>
       data = dummy_adtte,<br>
       groupn = TRTPN,<br>
       groupc = TRTP,<br>
       Time_var = AVAL,<br>
       Censore_var = CNSR,<br>
       Censore_val = 1,<br>
       Title = %nrquote(Kaplan-Meier Curve Example),<br>
       Group_color_list = %nrquote(black red blue green),<br>
       Group_linepattern_list = %nrquote(solid dash longdash shortdash),<br>
       XLABEL = %nrquote(Survival Time (Month)),<br>
       YLABEL = %nrquote(Probability),<br>
       AxisValues = %nrquote(0 to 15 by 1),<br>
       Generate_Code = N<br>
   );<br>
   <img width="562" alt="Image" src="https://github.com/user-attachments/assets/8859997d-73d8-437f-8853-ad36283f7c35" />
<br>

 Author:     Yutaka Morioka<br>
 Date:        2025-06-24<br>
 Version:     0.1<br>

  
---
 
