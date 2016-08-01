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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  outdat <- reactive({
    req(input$file1)
    inFile <- input$file1
    processcmd <- paste0("perl ./mr_eel.pl --in ", inFile$datapath, " --adj ", adj)
    out <- read.table(pipe(processcmd), header=F, stringsAsFactors=F)
    return(out)
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
    # text <- testout()
    input$seq
  })
  # observeEvent(input$scale, {
  # cat(input$scale, "\n")
  #   if(input$scale>0){
  #     shinyjs::toggle(id="scibox")
  #   }
  # })
  


  output$muPlot <- renderPlot({
    plotdf <- outdat()
    ggplot(plotdf, aes(x=V5))+
      geom_histogram()
  })

})
