# Tides
[![Travis](https://img.shields.io/travis/sboysel/tides-shiny.svg?style=flat-square)](https://github.com/sboysel/tides-shiny)
[![Shinyapps](https://img.shields.io/badge/shinyapps-deployed-brightgreen.svg?style=flat-square)](https://sboysel.shinyapps.io/tides)

A [Shiny](http://shiny.rstudio.com/) app to visualize tide predictions.

## Usage
Clone a copy of this repo
```bash
git clone git@github.com:sboysel/tides-shiny.git
cd tides-shiny
```
Run in `R`
```r
library(shiny)
runApp()
```

## Dependencies

* curl
* dplyr
* ggplot2
* jsonlite
* quantmod

## Resources

* [NOAA CO-OPS API For Data Retrieval](https://tidesandcurrents.noaa.gov/api/)
* [NOAA Stations Map](http://tidesandcurrents.noaa.gov/map/)
