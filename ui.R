#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(shinyjs)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  titlePanel("Mr. Eel"),
  
  fluidRow(
    column(4,
           useShinyjs(),
           actionButton("toggleDoc", "Documentation"),
           div(id="doc", includeMarkdown("mr-eel.md"))
    ),
    column(4,
           includeHTML("include.html"),
           plotOutput("muPlot")
    )
    # column(4,
    #        plotOutput("muPlot")
    # )
  )
))
