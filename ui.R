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
                        menuItem("Plot1", tabName = "Plot1", icon = icon("globe-americas")),
                        menuItem("Plot2", tabName = "Plot2", icon = icon("dashboard")),
                        menuItem("Plot3", tabName = "Plot3", icon = icon("th")),
                        menuItem("Plot4", tabName = "Plot4", icon = icon("th")),
                        menuItem("Plot5", tabName = "Plot5", icon = icon("th")),
                hr()
                        
                ),
                conditionalPanel("input.tabs == 'Plot1'", 
                                 menuItem(
                                         selectInput("Genre", "Select a Genre:",  
                                                     choices = c(names(cleanData)), selected = "Total")
                                 ),
                                 menuItem(
                                         selectInput("Continent", "Select a Continent:",
                                                     choices = c("World" ,"North America", "South America", "Africa", "Europe",
                                                                 "Asia", "Oceania"), selected = "World")
                                 ),
                                 checkboxInput("pop", "Adjust for Population", value = FALSE),
                                 checkboxInput("gdp", "Adjust for GDP", value = FALSE)
                                 # menuItem(
                                 #         sliderInput("Number of Countries", "Select the Number of Countries to be shown for bar chart:",
                                 #                     min = 3, max = 30, value = 20)
                                 # 
                                 # )
                                 
                        ),
                conditionalPanel("input.tabs == 'Plot2'",
                                 menuItem(
                                         selectInput("Continent2", "Select a Continent:",
                                                     choices = c("World" ,"North America", "South America", "Africa", "Europe",
                                                                 "Asia", "Oceania"), selected = "World")
                                 ),
                                 menuItem(
                                         sliderInput("Number of Countries2", "Select the Number of Countries to be shown for bar chart:",
                                                      min = 3, max = 30, value = 20)

                                         )
                        ),
                conditionalPanel("input.tabs == 'Plot4'",
                                 menuItem(
                                         sliderInput("words", "Number of words:", min = 50, max = 1000, value = 300)
                                 ),
                                 checkboxInput("Sent", HTML("View Senteminet of Words: <br> Blue-Positive <br> Red-Negative <br> Grey-Neutral"), value = FALSE)
                        ),
                conditionalPanel("input.tabs == 'Plot3'",
                                 checkboxInput("Actors", "Actors", value = TRUE),
                                 checkboxInput("Actresses", "Actresses", value = TRUE),
                                 checkboxInput("Directors", "Directors", value = FALSE),
                                 checkboxInput("Producers", "Producers", value = FALSE),
                                 checkboxInput("Composers", "Composers", value = FALSE)
                )
        ),
        dashboardBody(
                tabItems(
                        tabItem(tabName = "Plot1",
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
                                                )
                                        )
                                )
                        ),
                        tabItem(tabName = "Plot2", 
                                fluidRow(
                                        box(
                                                collapsible =  TRUE, title = "Bar Plot of Genre Counts", status = "primary", solidHeader = TRUE,
                                                plotlyOutput("genrePlot"),
                                                width = 12,
                                                height = "100%"
                                        )
                                )
                        ),
                        tabItem(tabName = "Plot4", 
                                fluidPage(
                                        box(
                                                collapsible  = TRUE, title = "Wordcloud of Movie Titles is the IMDB Dataset",
                                                status = "primary", solidHeader = TRUE,
                                                plotOutput("wordcloud", height = "80%"),
                                                width = 12
                                        )
                                )
                        ),
                        tabItem(tabName = "Plot3",
                                fluidRow(
                                        box(
                                                collapsible =  TRUE, title = "Average Age of People in Film - IMDB Dataset",
                                                status = "primary", solidHeader = TRUE,
                                                plotlyOutput("Age", height = "80%"),
                                                width = 12
                                        )
                                )
                        ),
                        tabItem(tabName = "Plot5", h1("Hello"))
                )
        )
)
