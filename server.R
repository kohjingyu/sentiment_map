library(tidyverse)
library(plotly)
# library(rgdal)

function(input, output, session) {
  sent_tweets <- read_csv("emoji_trunc.csv")
  minDate <- arrange(sent_tweets, created_at)[1,] %>% pull("created_at")
  maxDate <- arrange(sent_tweets, desc(created_at))[1,] %>% pull("created_at")

  # sg <- readOGR("sg-all")
  # sg.window <- as.owin(sg)

  # # Plot for hexagons that have more than x number of tweets
  # ggplot(data=sent_tweets, aes(x=lon, y=lat, z=sent, group=1)) +
  #   stat_summary_hex(binwidth=0.02, drop=TRUE, fun = function(x) if(length(x) > 300) {mean(x)} else {NA}) + coord_fixed() +
  #   scale_fill_gradient(low="white", high="blue") +
  #   ggtitle("Sentiment of Tweets (mean)")

  # MRTbreakdown <- sent_tweets[sent_tweets$created_at > 1436266077000 & sent_tweets$created_at < 1436282007000,]
  # ggplot(data=MRTbreakdown, aes(x=lon, y=lat, z=neg, group=1)) +
  #   stat_summary_hex(binwidth=0.02, drop=TRUE, fun=mean) + coord_fixed() +
  #   scale_fill_gradient(low="white", high="blue") +
  #   ggtitle("Sentiment of Tweets (mean)")

  # Combine the selected variables into a new data frame
  selectedData <- reactive({
    plotData <- dateRange()
    if(input$sent == "Positive") {
      plotData$pos;
    }
    else if(input$sent == "Negative") {
      plotData$neg;
    }
    else if(input$sent == "Sentiment") {
      plotData$sent;
    }
    else if(input$sent == "Count") {
      matrix(1, length(plotData$sent))
    }
  })

  func <- reactive({
    if(input$func == "Sum") {
      sum;
    }
    else if(input$func == "Mean") {
      mean;
    }
  })

  binSize <- reactive({
    input$binSize;
  })

  minTweets <- reactive({
    input$minTweets;
  })

  dateRange <- reactive({
    sent_tweets[sent_tweets$created_at > input$dateRange[1] & sent_tweets$created_at < input$dateRange[2],]
  })

  output$plot1 <- renderPlotly({
    plotData <- dateRange()
    p <- ggplot(data=plotData, aes(x=plotData$lon, y=plotData$lat, z=selectedData(), group=1)) +
      stat_summary_hex(binwidth=binSize(), drop=TRUE, fun=function(x) if(length(x) > minTweets()) {func()(x)} else {NA}) + coord_fixed() +
      scale_fill_gradient(low="white", high="blue") +
      scale_x_continuous(limits = c(103.6, 104)) + scale_y_continuous(limits = c(1.21, 1.49))
    ggplotly(p)
  })

  output$sliderOutput <- renderUI({
    sliderInput("dateRange", "Date Range:",
      min = minDate, max = maxDate,
        value = c(minDate, maxDate))
  })
}
