library(shiny)

ui <- fluidPage(tabsetPanel(
  id = "inTabset",
  tabPanel("Thumbnail plots",
    fluidRow(
      column(width=2,
        numericInput(
          "nRows", 
          "Number of rows", 
          value = 5, 
          min = 1, 
          max = 12
        )
      ),
      column(width=2,
        numericInput(
          "nCols", 
          "Number of columns", 
          value = 4, 
          min = 1, 
          max = 12
        )
      )
    ),
    plotOutput(
      outputId = "overview",
      click = "overviewClick"
    )
  ),
  tabPanel("Expanded version",
     fluidRow(
       column(width = 2,uiOutput("ui_rownr")),
       column(width = 2,uiOutput("ui_colnr"))
     ),
     plotOutput(outputId = "enlarged")
  )
))