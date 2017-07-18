# Title : French babies first names / Course Project : Shiny Application and Reproducible Pitch 
# Author : Olivier Cazin
# Date : 20170718

# loading packages
library(shiny) 
library(dplyr)
library(ggplot2)
library(scales)

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

shinyServer( function(input, output,session) { 
  
  # at least one city must be selected,if not all cities are ticked
  observe({
  if(length(input$French_city) < 1)
  {
    updateCheckboxGroupInput(session, "French_city", selected= c("NANTES","STRASBOURG","TOULOUSE","RENNES"))
  }
  })
  
  # Number of babies by year of birth with selected first name and selected city(ies)
   mydata_filtered <-  reactive({ 
    mydata %>%  
    dplyr::filter(PRN==toupper(input$entree_texte))  %>%
    dplyr::filter(grepl(paste(input$French_city, collapse='|'),LBCOM)) %>%  
    dplyr::select(ANNAISS,NRB,SEX) %>%  
    dplyr::group_by(ANNAISS,SEX) %>% 
    dplyr::mutate(Sum_NRB = sum(NRB)) %>% 
    dplyr::select(ANNAISS, SEX, Sum_NRB) %>%
    unique
  })
  
   # Number of babies by year of birth in selected city(ies)
    mydata_tot <-  reactive({ 
       mydata %>%  
      dplyr::filter(grepl(paste(input$French_city, collapse='|'),LBCOM)) %>%  
      dplyr::select(ANNAISS,PRN,NRB,SEX) %>%  
      dplyr::group_by(ANNAISS,SEX) %>% 
      dplyr::mutate(tot = sum(NRB)) %>% 
      dplyr::select(ANNAISS, SEX, tot) %>% 
      unique
    })
    
    # Percent of babies by year of birth with selected first name and selected city(ies)
    mydata_prop <-  reactive({
      mydata %>%  
      dplyr::filter(grepl(paste(input$French_city, collapse='|'),LBCOM)) %>%  
      dplyr::select(ANNAISS,PRN,NRB,SEX) %>%  
      dplyr::group_by(ANNAISS,SEX) %>% 
      dplyr::mutate(tot = sum(NRB)) %>% 
      dplyr::group_by(ANNAISS,PRN,SEX) %>%  
      dplyr::mutate(Sum_NRB = sum(NRB)) %>% 
      dplyr::mutate(percent_NRB=Sum_NRB/tot) %>%    
      dplyr::select(ANNAISS, SEX,Sum_NRB,tot,percent_NRB) %>%   
      dplyr::filter(PRN==toupper(input$entree_texte))  %>%
      unique
    }) 
    
    # Top 10 of babies first names for all years of birth and all cities
     mydata_table <- reactive({
      mydata %>%
        dplyr::select(PRN,NRB) %>%  
        dplyr::group_by(PRN) %>% 
        dplyr::mutate(Sum_NRB = sum(NRB)) %>% 
        dplyr::select(PRN,Sum_NRB) %>%   
        dplyr::arrange(desc(Sum_NRB)) %>%
         dplyr::select("First Name"=PRN,"Number"=Sum_NRB) %>%
        unique %>%  
        head(10)   
       }) 
      
      # Plot which displays the number of babies by year of birth with selected first name and selected city(ies)
      output$barplot1 <- renderPlot({
      cols <- c("HOMME" = "lightblue", "FEMME" = "lightpink")
      ggplot(mydata_filtered(), aes(x=factor(ANNAISS), y=Sum_NRB,fill=factor(SEX))) + geom_bar(stat="identity", colour="black",position="dodge") + scale_fill_manual(values = cols) + labs(x="Year of birth", y="Number of babies",title=paste0("Number of babies named ",toupper(input$entree_texte)," in selected city")) +  theme_minimal() +  theme(axis.text.x = element_text(angle=90,size = rel(0.9))) + guides(fill=FALSE)
                                    })
      # Plot which displays the percent of babies by year of birth with selected first name and selected city(ies)
      output$barplot2 <- renderPlot({
      cols <- c("HOMME" = "lightblue", "FEMME" = "lightpink")
      ggplot(mydata_prop(), aes(x=factor(ANNAISS), y=percent(percent_NRB),fill=factor(SEX))) + geom_bar(stat="identity", colour="black",position="dodge") + scale_fill_manual(values = cols) + labs(x="Year of birth", y="Percent of babies",title=paste0("Percent of babies named ",toupper(input$entree_texte)," in selected city")) +  theme_minimal()  + guides(fill=FALSE)
                                    })
      # Plot which displays the total number of babies by year of birth in selected city(ies)
      output$barplot3 <- renderPlot({
      ggplot(mydata_tot(), aes(x=factor(ANNAISS), y=tot,fill=factor(SEX))) + geom_bar(stat="identity", colour="black",position="dodge") +  scale_fill_manual(values = c("lightblue","lightpink")) +
      labs(x="Year of birth", y="Number of babies",title="Total number of babies in selected city") +  theme_minimal() + theme(axis.text.x = element_text(angle=90,size = rel(0.9))) + guides(fill=FALSE)
                                    })
      # Table which displays the top 10 of babies first names for all years of birth and all cities
      output$table <- renderTable({mydata_table()},align="c",caption = "Top 10 of the first names (all cities and years of birth combined)", caption.placement = getOption("xtable.caption.placement", "top"))
  
                                                 })
  