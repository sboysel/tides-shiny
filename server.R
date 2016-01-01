library(curl)
library(dplyr)
library(ggplot2)
library(jsonlite)
library(quantmod)

get_tides <- function(input, debug = FALSE) {
  h <- format(Sys.time(), "%H")
  m <- format(Sys.time(), "%M")
  dates_str <- gsub("-", "", as.character(input$dates))
  q <- paste0("http://tidesandcurrents.noaa.gov/api/datagetter?begin_date=",
              dates_str[1],
              " ", h, ":", m,
              "&end_date=",
              dates_str[2],
              " ", h, ":", m,
              "&station=",
              input$station,
              "&product=predictions&datum=MTL",
              "&units=",
              input$units,
              "&time_zone=",
              input$timezone,
              "&application=",
              "ports_screen&format=json")
  q <- URLencode(q)
  if (debug) {
    print(q)
  }
  tides <- suppressWarnings(jsonlite::fromJSON(URLencode(q))$predictions)
  tides$t <- as.POSIXct(tides$t, format = "%Y-%m-%d %H:%M")
  tides$v <- as.numeric(tides$v)
  return(tides)
}

high_lows <- function(tides_df) {
  tides.ts <- xts(tides_df$v, tides_df$t)
  tides.highs <- data.frame(Height = tides.ts[quantmod::findPeaks(tides.ts)],
                            Tide = "High")
  tides.highs$Time <- rownames(tides.highs)
  tides.lows <- data.frame(Height = tides.ts[quantmod::findValleys(tides.ts)],
                           Tide = "Low")
  tides.lows$Time <- rownames(tides.lows)
  data <- suppressWarnings(dplyr::bind_rows(tides.highs, tides.lows)) %>%
    mutate(Time = as.POSIXct(Time)) %>%
    arrange(Time)
  return(data)
}

shinyServer(function(input, output) {
  tides <- reactive({
    get_tides(input)
  })
  output$tides <- renderPlot({
    ggplot(data = tides(), aes(x = t, y = v)) +
      geom_line(size = 2,
                colour = "lightcoral") +
      scale_x_datetime() +
      labs(x = "Time",
           y = paste("Height in",
                     ifelse(input$units == "english", "feet", "meters")),
           title = "Mean Tide Level - Predictions") +
           theme(axis.text.x = element_text(angle = 45,
                                            hjust = 1,
                                            size = 14),
                 axis.text.y = element_text(siz = 14),
                 axis.title = element_text(size = 16),
                 plot.title = element_text(size = 18))
  })
  output$high_lows <- renderDataTable({
      high_lows(tides())
    },
    options = list(dom = "t")
  )
})