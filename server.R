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
library(ggplot2)
setwd("/var/www/jedidiahcarlson.com")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  observeEvent(input$submit {
  outdat <- reactive({
    req(input$file1)
    inFile <- input$file1
    filepath<- inFile$datapath
    adj <- input$adj
    processcmd <- paste0("perl cgi/mr_eel.pl --in ", filepath, " --adj ", adj)
    out <- read.table(pipe(processcmd), header=F, stringsAsFactors=F)
    # system(processcmd)
    return(out)
  })
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

  output$muPlot <- renderPlot({
    plotdf <- outdat()
    ggplot(plotdf, aes(x=V5))+
      geom_histogram()
  })

})
