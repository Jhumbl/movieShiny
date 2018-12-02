library(dplyr)
library(ggplot2)
devtools::install_github("ropensci/plotly")
library(plotly)
library(shiny)
library(scales)
library(readr)
library(wordcloud)
library(data.table)
source("functions.R")
cleanData <- read.csv("cleanData.csv", header = TRUE)
genrePlot <- cleanData
cleaned <- read_csv("cleanCountryData.csv", col_names = TRUE)
cleaned <- cleaned[,-1]
wordcloudData <- read_csv("wordcloudcsv.csv", col_names = TRUE)
wordcloudData <- wordcloudData[,-1]
ages <- read_csv("AgeData.csv", col_names = TRUE)

shinyServer(function(input, output, session){
        output$barPlot <- renderPlotly({
                
                # Set up variables
                genre <- input$Genre
                continent <- check_continent(input$Continent)
                noOfCountries <- 20 #input$`Number of Countries`
                
                # Select data and clean
                plot1 <- cleanData %>%
                        select_("Country", genre, "Continent", "Population", "gdp") 
                colnames(plot1) <- c("Country", "Value", "Continent", "Population", "gdp")
                
                # Adjust for population and GDP
                if (input$pop & input$gdp){
                        plot1 <- plot1[plot1$gdp != 0.00, ]
                        plot1 <- plot1[! is.na(plot1$Population), ]
                        plot1 <- plot1[! is.na(plot1$gdp), ]
                        plot1$Value <- round(((((plot1$Value)/(plot1$Population))*1000000)/(plot1$gdp))*1000000, 2)
                        barText <- "Per Million People Per Trillion GDP"
                } else if (input$pop){
                        plot1 <- plot1[! is.na(plot1$Population), ]
                        plot1$Value <- round(((plot1$Value)/(plot1$Population))*1000000, 2)
                        barText <- "Per Million People"
                } else if (input$gdp){
                        plot1 <- plot1[! is.na(plot1$gdp), ]
                        plot1 <- plot1[plot1$gdp != 0.00, ]
                        plot1$Value <- round(((plot1$Value)/(plot1$gdp))*1000000, 2)
                        barText <- "Per Trillion GDP"
                } else {
                        barText <- ""
                }
                
                #===================================================================
                # Plot 1: Bar Plot
                #===================================================================
                plot1 %>%
                        # arrange(desc(Value)) %>%
                        dplyr::filter(Continent %in% continent) %>%
                        mutate(Country = forcats::fct_reorder(Country, Value)) %>%
                        arrange(desc(Value)) %>%
                        head(noOfCountries) %>%
                        ggplot(aes(Country, Value, fill = Continent)) +
                        geom_bar(stat = "identity") +
                        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
                        ggtitle(paste("Number of films per Country",barText ,":", genre)) +
                        ylab("Number of Films") +
                        coord_flip() +
                        theme_light() +
                        labs(caption = "Data Source: 7CUSMTSD") +
                        theme(legend.title = element_blank()) +
                        scale_fill_manual(values = c("North America" = "#3B9AB2",
                                             "South America" = "#78B7C5", 
                                             "Europe" = "#EBCC2A", 
                                             "Asia" = "#E1AF00", 
                                             "Oceania" = "#F21A00",
                                             "Africa" = "#000000"))
      
        })
        output$mapPlot <- renderPlotly({
                # Filter by continent
                genre <- input$Genre
                continent <- check_continent(input$Continent)
                noOfCountries <- input$`Number of Countries`
                
                # filter and clean
                filteredData <- dplyr::filter(cleaned, Continent %in% continent) %>%
                        select_("long", "lat", "group", "piece", "Country", 
                                genre, "Continent", "Population", "gdp")
                
                colnames(filteredData) <- c("long", "lat", "piece", "group", 
                                            "Country", "Value", "Continent", "Population", "gdp")
                
                
                #Adjust for Population and GDP
                if (input$pop & input$gdp){
                        filteredData <- filteredData[! is.na(filteredData$Population), ]
                        filteredData <- filteredData[! is.na(filteredData$gdp), ]
                        filteredData <- filteredData[filteredData$gdp != 0, ]
                        filteredData$Value <- filteredData$Value - 1
                        filteredData$Value <- ((filteredData$Value)/(filteredData$Population))*1000000
                        filteredData$Value <- round(((filteredData$Value)/(filteredData$gdp))*1000000, 2)
                        filteredData$Count <- filteredData$Value
                        filteredData <- filteredData[!is.na(filteredData$Value), ]
                        filteredData$Value[filteredData$Value == 0] <- min(filteredData$Value[filteredData$Value != 0])/2
                        titleText <- "Per Million People Per Trillion GDP"
                } else if (input$pop){
                        filteredData <- filteredData[! is.na(filteredData$Population), ]
                        filteredData$Value <- filteredData$Value - 1
                        filteredData$Value <- round(((filteredData$Value)/(filteredData$Population))*1000000, 2)
                        filteredData$Count <- filteredData$Value
                        filteredData <- filteredData[!is.na(filteredData$Value), ]
                        filteredData$Value[filteredData$Value == 0] <- min(filteredData$Value[filteredData$Value != 0])/2
                        titleText <- "Per Million People"
                } else if (input$gdp){
                        filteredData <- filteredData[! is.na(filteredData$gdp), ]
                        filteredData <- filteredData[filteredData$gdp != 0, ]
                        filteredData$Value <- filteredData$Value - 1
                        filteredData$Value <- round(((filteredData$Value)/(filteredData$gdp))*1000000, 2)
                        filteredData$Count <- filteredData$Value
                        filteredData <- filteredData[!is.na(filteredData$Value), ]
                        filteredData$Value[filteredData$Value == 0] <- min(filteredData$Value[filteredData$Value != 0])/2
                        titleText <- "Per Trillion GDP"
                } else {
                        filteredData$Count <- filteredData$Value - 1
                        titleText <- ""
                }

                
                # filteredData$Value[filteredData$Value == 1] <- 0
               
                
                
                
                # Breaks
                breaks <- determine_breaks(filteredData$Value)
                br <- breaks$breaks
                lb <- breaks$lb
                lim <- breaks$limits
                
                #=========================================================================================
                # Plot 1: Map Plot
                #=========================================================================================
                p <- filteredData %>% 
                        ggplot() +
                        geom_polygon(aes(x = long, y = lat, fill = Value, country = Country, 
                                         continent = Continent, Total = Count, piece = piece),
                                     size = 0.03, alpha = 1, color="#000000") +
                        theme_void() +
                        scale_fill_continuous(name = "Count", low = "#ffffd9", high = "#0c2c84", 
                                              trans = log_trans(), limits = lim, breaks = br, 
                                              labels = prettyNum(lb, big.mark = ",", scientific = FALSE)) + 
                        coord_map(projection = "mercator") +
                        ggtitle(paste("Map of Movie Count", titleText))
                ggplotly(p, tooltip = c("country", "continent", "Total"))
                
                # Colour palletes 
                # #edf8b1 #2c7fb8 baige to purples or #ffffd9 to #0c2c84
                # #e0ecf4 #8856a7 purples 
                
        })
        output$genrePlot <- renderPlotly({
                # Inputs
                label <- input$Continent2
                if(label == "World"){label <- "the World"}
                continent <- check_continent(input$Continent2)
                noOfCountries <- input$`Number of Countries2` 
                
                #Select Continent
                genrePlot <- dplyr::filter(genrePlot, Continent %in% continent)
                # Calculations
                genreSum <-apply(genrePlot[,c(-1, -2, -34, -31, -32, -33)], MARGIN = 2 ,FUN = sum)
                genreSum <-sort(genreSum, decreasing = TRUE)
                genreSum <- data.frame(genreSum)
                genreSum <- setDT(genreSum, keep.rownames = TRUE)
                colnames(genreSum) <- c("rn", "sum")
                
                # Plot
                genreSum %>%
                        arrange(desc(sum)) %>%
                        mutate(genreSum = forcats::fct_reorder(rn, sum)) %>%
                        head(noOfCountries) %>%
                        ggplot(aes(reorder(rn, sum), sum)) +
                        geom_bar(stat = "identity") +
                        coord_flip() +
                        theme_light() +
                        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
                        labs(title = paste("Most Popular Genres Made in", label), x = "Genre", y = "Numbe of Films")
                
               
        })
        output$wordcloud <- renderPlot({
                numberOfWords <- input$words
                sent <- input$Sent
                #head(wordcloudData)
                
                if (sent) {
                         colnames(wordcloudData) <- c("Title", "Freq", "Using", "notUsing")
                } else {
                         colnames(wordcloudData) <- c("Title", "Freq", "notUsing", "Using")
                }
                
                wordcloud(wordcloudData$Title, wordcloudData$Freq, scale = c(11, 0.3), max.words = numberOfWords, 
                          random.order = FALSE, colors = wordcloudData$Using, ordered.colors = TRUE, title = "Hello")
        },
        height = function() {
                session$clientData$output_wordcloud_width
        })
        output$Age <- renderPlotly({
                
                
                
                groups <- c()
                if (input$Actors) {
                        groups <- c(groups, "Actors")
                }
                if (input$Actresses) {
                        groups <- c(groups, "Actresses")
                }
                if (input$Directors){
                        groups <- c(groups, "Directors")
                }
                if (input$Producers){
                        groups <- c(groups, "Producers")
                }
                if (input$Composers){
                        groups <- c(groups, "Composers")
                }
                if (length(groups) == 0) {
                        groups = c("No Input")
                }
               
                
                agesData <- dplyr::filter(ages, Group %in% groups)
                
                r <- ggplot(data = agesData) +
                        geom_line(aes(Year, Age, color = Group)) +
                        scale_color_manual(values = c("Actors" = "#3B9AB2",
                                                      "Actresses" = "#EBCC2A", 
                                                      "Producers" = "#78B7C5", 
                                                      "Directors" = "#E1AF00", 
                                                      "Composers" = "#F21A00")) +#EBCC2A#78B7C5
                        labs(title = "Average Age of People in Film") +
                        xlab("Year") +
                        theme_light() +
                        scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
                        theme(legend.title = element_blank()) +
                        ylab("Average Age")
                ggplotly(r)
        })
})