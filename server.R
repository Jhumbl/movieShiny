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
                
                
        
                
                # Plot data
               
                plot1 %>%
                        # arrange(desc(Value)) %>%
                        dplyr::filter(Continent %in% continent) %>%
                        mutate(Country = forcats::fct_reorder(Country, Value)) %>%
                        arrange(desc(Value)) %>%
                        head(noOfCountries) %>%
                        ggplot(aes(Country, Value, fill = Continent)) +
                        geom_bar(stat = "identity") +
                        scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
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
        
        
})