library(ggplot2)
library(gridExtra)

# Generate some random data, 10 repeats of x by y, indexed by rep
df <- expand.grid(x=1:10,reps=1:12)
df$y <- rnorm(nrow(df))

doPlot <- function(forValue) {
  ggplot(df[df$reps==forValue,], aes(y = y,x=x)) +
    geom_line() +
    labs(y="y")+
    labs(title = paste0("Value ",forValue))+
    scale_x_discrete(name="x",limits=factor(1:10)) +
    theme_bw(base_size = 18) +
    theme(aspect.ratio = 9/16)
}

server <- function(input, output, session) {
# Initialize ---------------------------------------------------------
  # Initial value to be plotted, updated on doubleclick
  plotThis <- reactiveVal(1)

  observeEvent(input$overviewClick, {
    clickList <- input$overviewClick
    if (!is.null(clickList)) {
      ncol <- 4
      nrow <- ceiling(length(unique(df$reps))/ncol)
      chartCol <- ceiling(clickList$x*ncol)
      chartRow <- ceiling((1 - clickList$y)*nrow)
      plotThis((chartRow-1)*ncol+chartCol)
      # cat(nrow,"rows,",ncol,"columns\n","Row",chartRow,",column",chartCol,"\n")
      updateTabsetPanel(session, "inTabset",selected = "Expanded version")
    }
  })
  
  # Overview chart =============================
  output$overview <- renderPlot({
    a <- lapply(unique(df$reps),function(val) {return(doPlot(forValue = val))})
    grid.arrange(grobs=a,ncol=4)
  },
  height=600
  )
  
  # Enlagrged chart =============================
  output$enlarged <- renderPlot({
    doPlot(forValue = plotThis())
  },
  height=600
  )
}

