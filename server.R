#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

options(shiny.maxRequestSize = 9*1024^2)

library(shiny)
library(shinyBS)
library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(DT)
library(RColorBrewer)
setwd("/var/www/jedidiahcarlson.com")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  outdat<-eventReactive(input$submit, {
  # outdat <- reactive({
    req(input$file1)
    inFile <- input$file1
    filepath<- inFile$datapath
    adj <- input$adj
    processcmd <- paste0("perl cgi/mr_eel.pl --in ", filepath, " --adj ", adj)
    out <- read.table(pipe(processcmd), header=F, stringsAsFactors=F)
    # system(processcmd)
    return(out)
  # })
  })
  
  # data <- reactive({
  #   req(input$file1)
  # 
  #   df <- read.table(inFile$datapath, sep="\t", header=F, stringsAsFactors=F)
  #   
  #   return(df)
  # })
  # shinyjs::onclick("toggleDoc",
  #   shinyjs::toggle(id = "doc", anim = TRUE))

  # testout <- reactive({
  #   input$scale
  # })
  output$text <- renderText({
    outdat()
  })
  
  output$output <- DT::renderDataTable(outdat(), options = list(
    lengthMenu = list(c(5, 15, 25), c('5', '15', '25')),
    pageLength = 5
  ), server=TRUE)

  output$muPlot <- renderPlot({
    plotdf <- outdat()
    ggplot(plotdf, aes(x=V5))+
      geom_histogram()
  })

})
