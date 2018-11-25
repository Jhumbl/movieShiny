library(dplyr)
library(ggplot2)
devtools::install_github("ropensci/plotly")
library(plotly)
library(shiny)
library(scales)
library(readr)
cleanData <- read.csv("cleanData.csv", header = TRUE)
cleaned <- read_csv("cleanCountryData.csv", col_names = TRUE)
cleaned <- cleaned[,-1]

shinyServer(function(input, output, session){
        output$barPlot <- renderPlotly({
                
                # Set up variables
                genre <- input$Genre
                continent <- input$Continent
                
                if (continent == "World"){
                        continent <- c("North America", "South America", "Africa", "Europe",
                                       "Asia", "Oceania")
                }
                
                noOfCountries <- input$`Number of Countries`
                
                # Select data and clean
                plot1 <- cleanData %>%
                        select_("Country", genre, "Continent") 
                colnames(plot1) <- c("Country", "Value", "Continent")
                
                
        
                
                # Plot data
               
                plot1 %>%
                        # arrange(desc(Value)) %>%
                        dplyr::filter(Continent %in% continent) %>%
                        mutate(Country = forcats::fct_reorder(Country, Value)) %>%
                        arrange(desc(Value)) %>%
                        head(noOfCountries) %>%
                        ggplot(aes(Country, Value, fill = Continent)) +
                        geom_bar(stat = "identity") +
                        scale_y_continuous(breaks = scales::pretty_breaks(n = 7)) +
                        ggtitle(paste("Number of films per Country: ", genre)) +
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
                # plot1
                # print(ggplotly(plot1))
      
        })
        output$mapPlot <- renderPlotly({
                # Filter by continent
                
                genre <- input$Genre
                continent <- input$Continent
                
                if (continent == "World"){
                        continent <- c("North America", "South America", "Africa", "Europe",
                                       "Asia", "Oceania", "Antarctica")
                }
                filteredData <- dplyr::filter(cleaned, Continent %in% continent) %>%
                        select_("long", "lat", "group", "piece", "Country", genre, "Continent")
                
                colnames(filteredData) <- c("long", "lat", "piece", "group", "Country", "Value", "Continent")
                
                filteredData$Count <- filteredData$Value - 1
                # Number of Breaks
                # base_breaks <- function(n = 10){
                #   function(x) {
                #       axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
                #   }
                # }
                
                # Breaks
                if (max(filteredData$Value) > 50000){
                        br <- trans_breaks("log10", function(x) 10 ^ x)(c(1, 100000))
                        lim = c(1, 100000)
                } else if (max(filteredData$Value) > 10000){
                        br <- trans_breaks("log10", function(x) 5 ^ x)(c(1, 200000))
                        lim = c(1, 20000)
                } else if (max(filteredData$Value) > 5000){
                        br <- trans_breaks("log10", function(x) 10 ^ x)(c(1, 10000))
                        lim = c(1, 10000)
                } else if (max(filteredData$Value) > 1000){
                        br <- trans_breaks("log10",n = 5 , function(x) 5 ^ x)(c(1, 50000))
                        lim = c(1, 10000)
                } else if (max(filteredData$Value) <= 1000){
                        br <- trans_breaks("log10", function(x) 5 ^ x)(c(1, 10000))
                        lim = c(1, 1000)
                }
                
                
                
                # br <- trans_breaks("log10", function(x) 10 ^ x)(c(1, max(filteredData$Total)))
                lb <- br
                lb[1] <- 0
                
                # Plot Data, before this make sure to write final data out.
                p <- filteredData %>% 
                        ggplot() +
                        geom_polygon(aes(x = long, y = lat, fill = Value, country = Country, continent = Continent, Total = Count, piece = piece),
                                     size = 0.03, alpha = 1, color="#000000") +
                        theme_void() +
                        scale_fill_continuous(low = "#fcfbfd", high = "#3f007d", trans = log_trans(), limits = lim, breaks = br, labels = prettyNum(lb, big.mark = ",", scientific = FALSE)) + 
                        coord_map(projection = "mercator")
                # Convert ggplot to plotly
                
                ggplotly(p, tooltip = c("country", "continent", "Total"))
                
                # #edf8b1 #2c7fb8 baige to purples
                # #e0ecf4 #8856a7 purples , limits = c(1, 100000)
                
        })
        
        
})