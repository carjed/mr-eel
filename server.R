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
# setwd("/srv/shiny-server/mr-eel")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  infile <- reactive({
    req(input$file1)
    inFile <- input$file1
    filepath <- inFile$datapath
    dat <- read.table(filepath, header=T, stringsAsFactors=F)
    out <- c(filepath, dat)
    names(out) <- c("filepath", "dat")
    return(out)
  })

  observeEvent(input$scale,{
    if(input$scale>0){
      shinyjs::show("scibox")
    }
  })


  outdat<-eventReactive(input$submit, {
  # outdat <- reactive({
    # req(input$file1)
    # inFile <- input$file1
    # filepath<- inFile$datapath
    inpath <- infile()$filepath
    adj <- input$adj
    processcmd <- paste0("perl cgi/mr_eel.pl --in ", inpath, " --adj ", adj)
    if(input$seq){
      processcmd <- paste0(processcmd, " --seq")
    }

    if(input$scale>0){
      processcmd <- paste0(processcmd, " --scale ", input$scale)
    }

    if(input$sci){
      processcmd <- paste0(processcmd, " --sci")
    }

    out <- read.table(pipe(processcmd), header=F, stringsAsFactors=F)

    # out$CAT <- paste(out$V3, out$V4, sep="")
    #
    # # Manually remove bins near chr20 centromere
    # # chr22 <- chr22[ which(chr22$BIN<260 | chr22$BIN>300),]
    # out$Category[out$CAT=="AC" | out$CAT=="TG"] <- "AT_CG"
    # out$Category[out$CAT=="AG" | out$CAT=="TC"] <- "AT_GC"
    # out$Category[out$CAT=="AT" | out$CAT=="TA"] <- "AT_TA"
    # out$Category[out$CAT=="GA" | out$CAT=="CT"] <- "GC_AT"
    # out$Category[out$CAT=="GC" | out$CAT=="CG"] <- "GC_CG"
    # out$Category[out$CAT=="GT" | out$CAT=="CA"] <- "GC_TA"

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
  # output$text <- renderText({
  #   outdat()
  # })

  output$output <- DT::renderDataTable(outdat(), options = list(
    lengthMenu = list(c(5, 15, 25), c('5', '15', '25')),
    pageLength = 5
  ), server=TRUE)

  output$downloadData <- downloadHandler(
    filename = "data_full.txt",
    # data = outdat(),
    content = function(file) {
      write.table(outdat(), file, col.names=F, row.names=F, sep="\t", quote=F)
    }
  )

  output$muPlot <- renderPlot({
    plotdf <- outdat()
    ggplot(plotdf, aes(x=MU, colour=CATEGORY, fill=CATEGORY))+
      geom_histogram()+
      scale_colour_brewer(palette="Dark2")+
      scale_fill_brewer(palette="Dark2")+
      facet_wrap(~CATEGORY, scales="free")+
      theme_bw()
  })

})
