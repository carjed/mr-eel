library(shiny)
library(shinyBS)
library(ggplot2)
library(Cairo)   # For nicer ggplot2 output when deployed on Linux
library(DT)
library(RColorBrewer)
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
      selectInput("adj", label="Motif length", choices=list("7-mers"=3, "5-mers"=2), selected=3),
      checkboxInput('seq', 'Include sequence motif?', FALSE),
      
      # textInputRow(inputId="scale", label="Scale rates to:", value = 0),
      div(id="scaling", "Scale rates to:", textInputRow(inputId="scale", label="", value = 0), "x10^-8"),
      shinyjs::hidden(div(id="scibox", checkboxInput('sci', 'Output in sci notation?', FALSE))),
      actionButton("submit", "Submit")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Distribution", plotOutput("muPlot")),
        tabPanel("View output",
          # bsCollapse(id="browse", open=NULL,
          # bsCollapsePanel("Browse Motifs", open=NULL,
              DT::dataTableOutput("output"),
            # ),
          downloadButton('downloadData', 'Download Full Data')
          # )
        ),
        tabPanel("Help", includeMarkdown("mr-eel.md"))
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
