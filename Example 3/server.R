library(ggplot2)


# Function to create the plots
# If no row or column is specified, a lattice plot is created (thumnails)
# Otherwise a larger zoomed in plot is created with a title

doPlot <- function(dataIn,row=NULL,col=NULL) {
  if (is.null(row)|is.null(col)) {usedata <- dataIn}
  else {usedata <- dataIn[dataIn$rowvar==row & dataIn$colvar==col, ]}
  p <- ggplot(usedata, aes(y = y,x=x)) +
    geom_line() +
    labs(y="y")+
    scale_x_discrete(name="x",limits=factor(1:10)) +
    theme_bw(base_size = 18) +
    theme(aspect.ratio = 9/16)
  if (is.null(row)|is.null(col)) {
    p <- p + facet_grid(vars(rowvar),vars(colvar))
  }
  else {
    p <- p + labs(title = paste0("Row ",row,", Column ",col))
  }
  p
}

server <- function(input, output, session) {
  # Generate some random data, 3 rows, 4 columns, 10 cases per dataset
  # df <- expand.grid(x=1:10,rowvar=1:input$nRows,colvar=1:input$nCols)
  getData <- reactive({
    ranData <- expand.grid(x=1:10,rowvar=1:input$nRows,colvar=1:input$nCols)
    ranData$y <- rnorm(nrow(ranData))
    as.data.frame(ranData)
  })
  
# Initialize ---------------------------------------------------------
  output$ui_rownr <- renderUI({
    selectInput(
      "rowVal",
      label = "Row value",
      choices = 1:input$nRows,
      selected = 1
    )
  })

  output$ui_colnr <- renderUI({
    selectInput(
      "colVal",
      label = "Column value",
      choices = 1:input$nCols,
      selected = 1
    )
  })
  
  observeEvent(input$overviewClick, {
    clickList <- input$overviewClick
    if (!is.null(clickList)) {
      updateTabsetPanel(session, "inTabset",selected = "Expanded version")
      updateVarSelectInput(session,"colVal",selected=clickList$panelvar1)
      updateVarSelectInput(session,"rowVal",selected=clickList$panelvar2)
    }
  })
 
  # Overview chart =============================
  output$overview <- renderPlot({
    df <- getData()
    doPlot(dataIn = df)
  },
  height=600
  )
  
  # Enlagrged chart =============================
  output$enlarged <- renderPlot({
    if (is.null(getData())) return()
    if (is.null(input$rowVal) | is.null(input$colVal)) return()
    df <- getData()
    doPlot(dataIn = df,row=input$rowVal,col=input$colVal)
  },
  height=600
  )
}

