This repository contains the essential codes to run the elastic net regression analysis as described in Lim et al. 2023

1. System requirements

Windows 11 Home Version 22H2 was used for the analyses although R and the packages used should be compatible with the Mac and Linux operating systems.
All analyses were done on R version 4.2.0
The following R packages were used: 

dplyr 1.0.9
readr 2.1.2
glmnet 4.1-4
caret 6.0-92


2. Installion guide

Download and install R from "https://www.r-project.org/" and R Studio from "https://posit.co/download/rstudio-desktop/". This should take less than 5 minutes. 
Install the required packages from "https://cran.r-project.org/" or type "install.packages(c('dplyr','readr','glmnet','caret'))" into the R console.


3. Demo and 4. Instructions for use

Launch RStudio
Run the script in "script/elastic_net_regression.r".
The expected output are two .csv files with the coefficients for the BMI-protein signature and the WC-protein signature respectively.
The expected run time should be around 5 minutes using the mock data.
