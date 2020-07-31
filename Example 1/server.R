library(ggplot2)

# Generate some random data, 3 rows, 4 columns, 10 cases per dataset
df <- expand.grid(x=1:10,rowvar=1:3,colvar=1:4)
df$y <- rnorm(nrow(df))

# Function to create the plots
# If no row or column is specified, a lattice plot is created (thumnails)
# Otherwise a larger zoomed in plot is created with a title

doPlot <- function(row=NULL,col=NULL) {
  if (is.null(row)|is.null(col)) {usedata <- df}
  else {usedata <- df[df$rowvar==row & df$colvar==col, ]}
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
# Initialize ---------------------------------------------------------
  # Initial value to be plotted, updated on click
  selectedRow <- reactiveVal(1)
  selectedCol <- reactiveVal(1)

  observeEvent(input$overviewClick, {
    clickList <- input$overviewClick
    if (!is.null(clickList)) {
      selectedRow(clickList$panelvar2)
      selectedCol(clickList$panelvar1)
      updateTabsetPanel(session, "inTabset",selected = "Expanded version")
    }
  })
 
  # Overview chart =============================
  output$overview <- renderPlot({
    doPlot()
  },
  height=600
  )
  
  # Enlagrged chart =============================
  output$enlarged <- renderPlot({
    doPlot(row=selectedRow(),col=selectedCol())
  },
  height=600
  )
}

