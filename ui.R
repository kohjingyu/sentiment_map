library(plotly)

fluidPage(
  titlePanel('Social Media Sentiment in Singapore'),
  sidebarLayout(
    sidebarPanel(
      selectInput('sent', 'Data Type', c("Sentiment", "Positive", "Negative", "Count"), selected="Sentiment"),
      selectInput('func', 'Aggregate Type', c("Mean", "Sum"), selected="Mean"),
      numericInput('binSize', 'Hexagon Size', 0.02,
                   min = 0.01, max = 0.05),
      numericInput('minTweets', 'Minimum Tweets Required', 100,
                   min = 0, max = 1000),
      width=3
    ),
    mainPanel(
      plotlyOutput('plot1', width="100%", height="500px"),
      uiOutput("sliderOutput", width="100%")
    )
  )
)
