# Loading required libraries

library(shiny)
library(quantmod)
library(xts)
library(zoo)

# Create function for currency conversion using the getFX() function from the
# quantmod package. Output is a single conversion for a certain currency pair at a day

FXconversion <- function(currencyA,currencyB,amount,days){
    currency_ratio <- paste(currencyA,"/",currencyB,sep="")
    FXrate <- xts(get(getFX(currency_ratio,from = Sys.Date()-days,
                            to = Sys.Date()-days)))
    amount_converted <- as.numeric(amount*FXrate)
    return(amount_converted)
}

# Create history of currency exchange rates or respectively exchanged currencies

FXhistory <- function(currencyA,currencyB,amount,days){
    currency_ratio <- paste(currencyA,"/",currencyB,sep="")
    FXrate <- xts(get(getFX(currency_ratio,from = Sys.Date()-days,
                            to = Sys.Date()-1)))
    amount_history <- amount*FXrate
    return(amount_history)
}

# Create Shiny Server function with input and in interactive plot

shinyServer(
    function(input, output) {
        output$oid1 <- renderPrint({input$variable})
        output$oid2 <- renderPrint({input$variable2})
        output$amount <- renderPrint({
            FXconversion(input$variable,input$variable2,input$amount,1)})
        output$amount2 <- renderPrint({
            FXconversion(input$variable,input$variable2,input$amount,
                         input$days+1)})
        output$myplot <- renderPlot({
            FX_over_time <- FXhistory(input$variable,input$variable2,
                                      input$amount, input$days+2)
            FX_over_tmp <- FX_over_time
            index <- 2:(length(FX_over_tmp)-1)
            index[1]<-1
            FX_over_time_line <- FX_over_tmp[-index]
            plot(FX_over_time,main = "Value of Currency over Time",
                 ylab = input$variable)
            points(FX_over_time[2],pch=21, col = "blue", bg = "green")
            points(FX_over_time[length(FX_over_time)],pch=21, col = "blue", bg = "green")
            lines(FX_over_time_line,pch=23,lty=4,col="dark red")
            legend("topleft","Cut-off Dates",
                   pch=21, title = "Selected Period")
        })
    }
)
