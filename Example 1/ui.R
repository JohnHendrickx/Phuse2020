library(shiny)

ui <- fluidPage(tabsetPanel(
  id = "inTabset",
  tabPanel("Thumbnail plots",
    plotOutput(
      outputId = "overview",
      click = "overviewClick"
    )
  ),
  tabPanel("Expanded version",
    plotOutput(outputId = "enlarged")
  )
))