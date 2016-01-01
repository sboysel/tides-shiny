shinyUI(fluidPage(
  titlePanel("Tides"),
  sidebarLayout(
    sidebarPanel(selectInput("station", label = h4("Station"),
                             choices = list("Port San Luis, CA" = 9412110,
                                            "Oil Platform Harvest, CA" = 9411406,
                                            "Santa Barbara, CA" = 9411340,
                                            "Santa Monica, CA" = 9410840,
                                            "Los Angeles, CA" = 9410660),
                             selected = 9411340),
                 dateRangeInput("dates",
                                label = h4("Date Range"),
                                format = "yyyy-mm-dd",
                                start = as.Date(Sys.time()) - 1,
                                end = as.Date(Sys.time()),
                                min = as.Date(Sys.time()) - 365,
                                max = as.Date(Sys.time()) + 365),
                 radioButtons("units", label = h4("Units"),
                              choices = list("English" = "english",
                                             "Metric" = "metric")),
                 radioButtons("timezone", label = h4("Timezone"),
                              choices = list("GMT" = "gmt",
                                             "Local" = "lst",
                                             "Local (Daylight Savings)" = "lst_ldt"),
                              selected = "lst")
                 ),
    mainPanel(
      plotOutput("tides"),
      dataTableOutput("high_lows")
    )
  )
))
