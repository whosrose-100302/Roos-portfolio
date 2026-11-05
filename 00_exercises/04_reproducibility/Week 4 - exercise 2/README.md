In this project, I replicated the simulation in the article "Introduction to statistical simulations in
health research" by Boulesteix et al., 2020, doi:10.1136/bmjopen-2020-039921.

In the folder data, you can find the raw data files, along with the clean data file.
The data can be found here: https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Begi-nYear=2015
Or downloaded directly from: https://github.com/mlarpis/markup/blob/main/documents/week-4/raw_data 

To replicate the analyses, R was used. The package versions are recorded in `renv.lock`.
A reproducible environment was used.
After opening this project in R, you can recreate the environment on your machine by running:
install.packages("renv") in your console, after which this command: renv::restore() recreates the environment.

In docs, you can find the data cleaning and the analyses, along with some interpretations and explanations.
In scripts, you can find the .R scripts used to conduct the data cleaning and the analyses; no lengthy explanations, just annotated code.
First, the data cleaning should be ran, after which the analyses should be ran.
You can find the code in either the docs map or the scripts map. The doc versions contain explanations, but the code is the same.

Then finally, in results, you can find the .RDS files containing R output that was created with the `analyses_explanation.qmd` file in the docs folder.
These results are model output, a matrix containting beta estimates and one figure. 

Author: Roos Mulder