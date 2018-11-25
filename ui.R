cleanData <- read.csv("cleanData.csv", header = TRUE)
cleanData <- cleanData[, c(-2, -1,-32)]
cleanData <- cleanData[, c(29, 1:28)]
library(shiny)
library(plotly)

ui <- fluidPage(
        
        titlePanel("Movies"),
        
        sidebarLayout(
                
                sidebarPanel(
                        selectInput("Genre", "Select a Genre:",  
                                    choices = c(names(cleanData)), selected = "Total"),
                        selectInput("Continent", "Select a Continent:",
                                    choices = c("World" ,"North America", "South America", "Africa", "Europe",
                                                "Asia", "Oceania"), selected = "World"),
                        sliderInput("Number of Countries", "Select the Number of Countries to be shown for bar chart:",
                                    min = 3, max = 30, value = 20)
                ),
                
                mainPanel(
                        plotlyOutput("barPlot")
                )
        )
)