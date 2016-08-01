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

textInputRow<-function (inputId, label, value = "") {
  div(style="display:inline-block;",
      tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value, class="input-small"))
}

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  titlePanel("Mr. Eel"),

  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file'),
      tags$hr(),
      selectInput("select", label="test", choices=list("7-mers"=3, "5-mers"=2), selected=3),
      checkboxInput('seq', 'Include sequence motif?', FALSE),
      
      # textInputRow(inputId="scale", label="Scale rates to:", value = 0),
      div(id="scaling", "Scale rates to:", textInputRow(inputId="scale", label="", value = 0), "x10^-8"),
      shinyjs::hidden(div(id="scibox", checkboxInput('sci', 'Output in sci notation?', FALSE)))

    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Distribution", plotOutput("muPlot"))
        # tabPanel("Distribution", textOutput("text"))
      )
    )

  )

  # fluidRow(
  #   column(4,
  #          useShinyjs(),
  #          actionButton("toggleDoc", "Documentation"),
  #          div(id="doc", includeMarkdown("mr-eel.md"))
  #   ),
  #   column(4,
  #          includeHTML("include.html"),
  #          plotOutput("muPlot")
  #   )
  # )
))
