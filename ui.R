# https://stackoverflow.com/questions/38184396/shiny-server-user-usergroup

# Ensure Docker container uses the image's R package library
.libPaths(c("/usr/local/lib/R/site-library", .libPaths()))

# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(readtext)
library(devtools)
library(xgboost)
library(text2vec)
library(tm)
library(NLP)
library(readr)
library(imager)   # https://github.com/aoles/EBImage/issues/2    https://github.com/Bioconductor/bioc_docker/issues/26 

library(RFakeNewsDetector)


# Define UI for application that draws a histogram
shinyUI(
    fluidPage(
        
        div(
            style=" max-width: 1700px; margin: 0 auto 25px ",
            
            # App title ----
            titlePanel(windowTitle = "Fake News Detector", # Title shown in the tap of the web browser
                       p(style="font-family: &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif;
                                font-size: 30px; color: #2F4F4F; font-weight: bold; margin-left: 7px;
                                margin-bottom: 25px; margin-top: 30px;",
                         "Fake News Detector")), # Page title

            # Sidebar layout with input and output definitions ----
            sidebarLayout(

                # Sidebar panel for inputs ----
                sidebarPanel(
                    width=6,

                    #text input
                    textAreaInput(inputId = "text", label = "News article text", height = 420),


                    # Horizontal line ----
                    tags$hr(),


                    # Input: Select a file ----
                    # fileInput("file1",
                    #         "Input File (.txt)",
                    #         multiple = FALSE,
                    #         accept = c("text", "text/plain")
                    #         ),

                    #showing Note 
                    p(""),

                    #checkbox input
                    checkboxInput("xgboost","Gradient Boosting (XGBoost)"),
                    checkboxInput("svm","Support Vector Machine"),
                    # checkboxInput("nbase","Naive Bayes"),

                    #submit button with name submit
                    # actionButton("submit","Submit"),div("[ It takes a bit ]"),
                    div(
                        style="display:inline-block",
                        actionButton("submit","Submit",
                                    style='padding:4px 26px; color: black ; font-weight: bold;
                                            border-color: #0000FF; font-size:110%; background-color: #DCDCDC')
                    ),
                    div(style="display:inline-block"," (It takes a bit) "),
                        
                    # Horizontal line ----
                    tags$hr()

                ),  # slidebar panel closed
                
                # Main panel for displaying outputs ----
                mainPanel(
                    width=6,

                    # Output: Data file ----
                    htmlOutput("content"),

                    #warning for wrong file upload
                    h1(textOutput("warning1"))

                ) # main panel closed

            ) # slidebar layout closed
        
        ) # div closed

    ) # fluid page closed

)
