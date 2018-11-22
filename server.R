library(dplyr)
library(ggplot2)
library(plotly)
library(shiny)
cleanData <- read.csv("cleanData.csv", header = TRUE)

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
                arrange(plot1, desc(Value))
                
        
                
                # Plot data
                plot1 <- plot1 %>%
                        dplyr::filter(Continent %in% continent) %>%
                        mutate(Country = forcats::fct_reorder(Country, Value)) %>%
                        arrange(desc(Value)) %>%
                        head(noOfCountries) %>%
                        ggplot(aes(Country, Value, fill = Continent)) +
                        geom_bar(stat = "identity") +
                        # ggtitle(paste("Number of films per Country: ", genre)) +
                        coord_flip() +
                        scale_fill_manual(values = c("North America" = "#3B9AB2",
                                             "South America" = "#78B7C5", 
                                             "Europe" = "#EBCC2A", 
                                             "Asia" = "#E1AF00", 
                                             "Oceania" = "#F21A00",
                                             "Africa" = "#000000"))
                
                print(ggplotly(plot1))
      
        })
        
        
})