library(shiny)
library(shinyBS)
library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(DT)
library(RColorBrewer)
library(shinyjs)
library(shinythemes)

textInputRow<-function (inputId, label, value = "") {
  div(style="display:inline-block;",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value, class="input-small"))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  shinyjs::useShinyjs(),
  navbarPage("",
             tabPanel("App",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput('file1', 'Choose file'),
                          tags$hr(),
                          selectInput("adj", label="Motif length", 
                                      choices=list("7-mers"=3, "5-mers"=2), selected=3),
                          checkboxInput('seq', 'Include sequence motif?', FALSE),
                          
                          # textInputRow(inputId="scale", label="Scale rates to:", value = 0),
                          div(id="scaling", "Scale rates to:", 
                              textInputRow(inputId="scale", label="", value = 0), 
                              HTML(paste("x10", tags$sup(-8), 
                                         " (keep value as 0 to return relative rates)", sep = ""))),
                          shinyjs::hidden(div(id="scibox", 
                                              checkboxInput('sci', 'Output in scientific notation?', FALSE))),
                          actionButton("submit", "Submit")
                        ),
                        
                        mainPanel(
                          tabsetPanel(
                            tabPanel("View output",
                                     DT::dataTableOutput("output"),
                                     tags$hr(),
                                     downloadButton('downloadData', 'Download Processed Data')),
                            tabPanel("Plots", 
                                     plotOutput("muPlot"))
                          )
                        )
                        
                      )
                      
             ),
             
             tabPanel("Documentation", 
                      # includeMarkdown("/srv/shiny-server/mr-eel/README.md"))
             includeHTML("/srv/shiny-server/mr-eel/README.html"))
  )
))