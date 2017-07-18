First name of french babies in four cities overview
========================================================
author: Olivier Cazin
date: 2017/07/18
autosize: true

A R Shiny app which relies on open data
========================================================

This R Shiny app relies on open data delivered by four big french cities.  

The file contains the first names given to the children born in the french cities of Rennes, Strasbourg, Nantes, Toulouse, from 2002 to 2012. These data come from the civil registries of the municipalities adhering to the association Open data France. For reasons of respecting the anonymity of the persons, this file does not publish the first names whose occurrence is less than 5.  

The open data are disponible here : <https://www.data.gouv.fr/fr/datasets/les-prenoms-des-petits-francais/>  

Short description of the open data file
========================================================

The file has been retreated to replace all french accents or special characters and is constitued of 5 939 observations and 7 columns :   

```
'data.frame':	5939 obs. of  7 variables:
 $ ANNAISS: int  2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...
 $ MNAISS : logi  NA NA NA NA NA NA ...
 $ CODCOM : int  35238 35238 35238 35238 35238 35238 35238 35238 35238 35238 ...
 $ LBCOM  : Factor w/ 4 levels "NANTES","RENNES",..: 2 2 2 2 2 2 2 2 2 2 ...
 $ SEX    : Factor w/ 2 levels "FEMME","HOMME": 1 1 1 1 1 1 1 1 1 1 ...
 $ PRN    : chr  "EMMA" "MANON" "JADE" "CAMILLE" ...
 $ NRB    : int  50 45 44 41 37 34 33 30 30 29 ...
```

Mean of all variables : "ANNAISS" is the year of birth, "MNAISS" is the month of birth, "CODCOM" is the code of the commune, "LBCOM" is the name of the commune, "SEX" is the sex of the baby, "PRN" is the first name of the baby and "NRB" is the number of babies. 


Slide With Plot
========================================================

At first the R Shiny app requires the user to enter a first name and then to tick the box(es) corresponding to a city(ies).

Then, automatically, the app displays : 
- at the top at left : the number of babies with the selected first names in the slected city(ies).  
- at the top at right : the percent of babies with the selected first names in the slected city(ies).  
- at the bottom at left : the total number of babies in the selected city(ies).   
- at the bottom at right : the top 10 of first names in the four cities combined.   

At least one city must be selected.

Ready to give it a try ?
========================================================


Use the Shiny app at <https://greendraco.shinyapps.io/French_babies_first_names/>

Get the app source code at https://

