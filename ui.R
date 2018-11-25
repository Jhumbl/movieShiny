cleanData <- read.csv("cleanData.csv", header = TRUE)
cleanData <- cleanData[, c(-2, -1,-32)]
cleanData <- cleanData[, c(29, 1:28)]
library(shiny)
library(plotly)
library(shinydashboard)

ui <- dashboardPage(
        dashboardHeader(title = "Movies Data"),
        dashboardSidebar(
                hr(),
                sidebarMenu( id = "tabs",
                        menuItem("Plot1", tabName = "Plot 1", icon = icon("globe-americas")),
                        menuItem("Plot2", tabName = "Dashboard", icon = icon("dashboard")),
                        menuItem("Plot3", tabName = "Plot 3", icon = icon("th")),
                        menuItem("Plot4", tabName = "Plot 4", icon = icon("th")),
                        menuItem("Plot5", tabName = "Plot 5", icon = icon("th")),
                hr()
                        
                ),
                conditionalPanel("input.tabs == 'Plot 1'", 
                                 menuItem(
                                         selectInput("Genre", "Select a Genre:",  
                                                     choices = c(names(cleanData)), selected = "Total")
                                 ),
                                 menuItem(
                                         selectInput("Continent", "Select a Continent:",
                                                     choices = c("World" ,"North America", "South America", "Africa", "Europe",
                                                                 "Asia", "Oceania"), selected = "World")
                                 ),
                                 menuItem(
                                         sliderInput("Number of Countries", "Select the Number of Countries to be shown for bar chart:",
                                                     min = 3, max = 30, value = 20)
                                         
                                 )
                        )
        ),
        dashboardBody(
                fluidRow(
                        column( width = 12,
                                box(
                                        collapsible = TRUE, title = "Bar Plot of Movie Counts", status = "primary", solidHeader = TRUE,  
                                        column(width = 12, plotlyOutput("barPlot")),
                                        width = 12
                                        
                                       
                                ),
                                
                                
                                        
                                
                                
                                box(
                                        collapsible = TRUE, title = "Map of Movie Counts", status = "primary", solidHeader = TRUE,  
                                        column(width = 12, plotlyOutput("mapPlot")),
                                        width = 12
                                        #plotlyOutput("mapPlot")
                                        
                                        
                                        # plotlyOutput("mapPlot")
                                        
                                )
                        )
                ),
                fluidRow(
                        # box(
                        #         selectInput("Genre", "Select a Genre:",  
                        #                     choices = c(names(cleanData)), selected = "Total"),
                        #         selectInput("Continent", "Select a Continent:",
                        #                     choices = c("World" ,"North America", "South America", "Africa", "Europe",
                        #                                 "Asia", "Oceania"), selected = "World"),
                        #         sliderInput("Number of Countries", "Select the Number of Countries to be shown for bar chart:",
                        #                     min = 3, max = 30, value = 20),
                        #         width = 3
                        # )
                )
        )
)