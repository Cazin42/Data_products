# Title : French babies first names / Course Project : Shiny Application and Reproducible Pitch 
# Author : Olivier Cazin
# Date : 20170718

# loading packages
library(shiny)
library(RCurl)

# loading open data file
#url <- getURL("https://www.data.gouv.fr/storage/f/2013-11-28T16%3A34%3A11.114Z/prenoms-odf.csv")
#mydata <- read.csv(text = url,sep=";",fileEncoding="latin1")
mydata <- read.csv("./data/prenoms-odf.csv",sep=";")

# replacing french accent or special characters in the first names variable
mydata$PRN <- gsub("Ã©","e",mydata$PRN)
mydata$PRN <- gsub("Ã¨","e",mydata$PRN)
mydata$PRN <- gsub("Ãˆ","e",mydata$PRN)
mydata$PRN <- gsub("Ã«","e",mydata$PRN)
mydata$PRN <- gsub("Ã‰","e",mydata$PRN)
mydata$PRN <- gsub("Ã§","c",mydata$PRN)
mydata$PRN <- gsub("Ã¯","i",mydata$PRN)
mydata$PRN <- toupper(mydata$PRN)

shinyUI(navbarPage("First names given to the french children borned recently in Nantes, Rennes, Strasbourg and Toulouse",
        tabPanel("Use the App",
                 
                  sidebarPanel( 
                    
                       textInput(inputId = "entree_texte", 
                       label = "Enter a first name please :", 
                       value = ""),
              
                       checkboxGroupInput("French_city", "Choose a french city :",
                       choiceNames = list("Nantes","Rennes","Strasbourg","Toulouse"),
                       choiceValues = list("NANTES","RENNES","STRASBOURG","TOULOUSE"),
                       selected= c("NANTES","STRASBOURG","TOULOUSE","RENNES")
                                         )
                               ),
                 
                   mainPanel( 
           
                       column(6,plotOutput("barplot1",width = "110%")) ,
              
                       column(6,plotOutput("barplot2",width = "110%")) ,
              
                       column(6,plotOutput("barplot3",width = "110%")) ,
              
                       column(6,tableOutput('table'),align = 'center',style = "font-size:80%") 
                            )
                 ),
        
        tabPanel(p(icon("info"), "About"),
           
                  mainPanel(includeMarkdown("about.Rmd")))
  
              )        
          )