# ============================================================
# Telling Stories with Data - Movie Visualisation
# ============================================================

# Install Relevant Packages
library(shiny)
library(markdown)
library(plotly)
library(shinydashboard)

# Read in Data
cleanData <- read.csv("cleanData.csv", header = TRUE)
cleanData <- cleanData[, c(-2, -1,-32)]
cleanData <- cleanData[, c(29, 1:28)]

# Set up User Interface
ui <- dashboardPage(
        dashboardHeader(title = "Movies Data"),
        # Sidebar
        dashboardSidebar(
                hr(),
                sidebarMenu( id = "tabs",
                        menuItem("Movie Count", tabName = "Plot1", icon = icon("globe-americas")),
                        menuItem("Genre Count", tabName = "Plot2", icon = icon("chart-bar")),
                        menuItem("IMDb Average Age", tabName = "IMDb1", icon = icon("chart-line")),
                        menuItem("IMDb Wordcloud", tabName = "IMDb2", icon = icon("cloud")),
                        menuItem("About and Code",  icon = icon("file-text-o"),
                                 menuSubItem("About and Sources", tabName = "about", icon = icon("angle-right")),
                                 menuSubItem("ui.R", tabName = "ui", icon = icon("angle-right")),
                                 menuSubItem("server.R", tabName = "server", icon = icon("angle-right"))
                        ),
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
                                         sliderInput("Number of Countries2", "Select the Number of Genres to be shown:",
                                                      min = 3, max = 30, value = 20)

                                         )
                        ),
                conditionalPanel("input.tabs == 'IMDb2'",
                                 menuItem(
                                         sliderInput("words", "Number of words:", min = 50, max = 1000, value = 300)
                                 ),
                                 checkboxInput("Sent", HTML("View Senteminet of Words: <br> Blue-Positive <br> Red-Negative <br> Grey-Neutral"), value = FALSE)
                        ),
                conditionalPanel("input.tabs == 'IMDb1'",
                                 checkboxInput("Actors", "Actors", value = TRUE),
                                 checkboxInput("Actresses", "Actresses", value = TRUE),
                                 checkboxInput("Directors", "Directors", value = FALSE),
                                 checkboxInput("Producers", "Producers", value = FALSE),
                                 checkboxInput("Composers", "Composers", value = FALSE)
                )
        ),
        # Main Body
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
                        tabItem(tabName = "IMDb2", 
                                fluidPage(
                                        box(
                                                collapsible  = TRUE, title = "Wordcloud of Movie Titles is the IMDB Dataset",
                                                status = "primary", solidHeader = TRUE,
                                                plotOutput("wordcloud", height = "80%"),
                                                width = 12
                                        )
                                )
                        ),
                        tabItem(tabName = "IMDb1",
                                fluidRow(
                                        box(
                                                collapsible =  TRUE, title = "Average Age of People in Film - IMDB Dataset",
                                                status = "primary", solidHeader = TRUE,
                                                plotlyOutput("Age", height = "80%"),
                                                width = 12
                                        )
                                )
                        ),
                        tabItem(tabName = "about",
                                box( width = NULL, status = "primary", solidHeader = TRUE, title="ui.R",
                                     br(),br(),
                                     pre(includeMarkdown("README.md"))
                                )
                        ),
                        tabItem(tabName = "ui",
                                box( width = NULL, status = "primary", solidHeader = TRUE, title="ui.R",
                                     br(),br(),
                                     pre(includeText("ui.R"))
                                )
                        ),
                        tabItem(tabName = "server",
                                box( width = NULL, status = "primary", solidHeader = TRUE, title="server.R",
                                     br(),br(),
                                     pre(includeText("server.R"))
                                )
                        )
                )
        )
)
