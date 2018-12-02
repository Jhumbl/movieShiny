library(scales)
# Assign the continents to world variable
check_continent <- function(continent){
        if (continent == "World"){
                continent <- c("North America", "South America", "Africa", "Europe",
                               "Asia", "Oceania", "Antarctica")
        }
        return(continent)
}

# Determine the breaks for log plot
determine_breaks <- function(column){
        if ((min(column) < 1) & (max(column) > 150000)){
                br <- trans_breaks("log10", function(x) 5 ^ x)(c(0.005, 10000000))
                lim = c(0.01, 400000)
        } else if (min(column) < 0.01){
                br <- trans_breaks("log10", function(x) 5 ^ x)(c(0.0005, 100000))
                lim = c(0.005, 20000)
        } else if (min(column) < 1){
                br <- trans_breaks("log10", function(x) 5 ^ x)(c(0.005, 100000))
                lim = c(0.01, 1000)
        } else if (max(column) > 50000){
                br <- trans_breaks("log10", function(x) 10 ^ x)(c(1, 100000))
                lim = c(1, 100000)
        } else if (max(column) > 10000){
                br <- trans_breaks("log10", function(x) 5 ^ x)(c(1, 200000))
                lim = c(1, 20000)
        } else if (max(column) > 5000){
                br <- trans_breaks("log10", function(x) 10 ^ x)(c(1, 10000))
                lim = c(1, 10000)
        } else if (max(column) > 1000){
                br <- trans_breaks("log10",n = 5 , function(x) 5 ^ x)(c(1, 50000))
                lim = c(1, 10000)
        } else if (max(column) <= 1000){
                br <- trans_breaks("log10", function(x) 5 ^ x)(c(1, 10000))
                lim = c(1, 1000)
        }
        lb <- br
        lb[1] <- 0
        breaks <- list("breaks" = br, "limits" = lim, "lb" = lb)
        return(breaks)
}




