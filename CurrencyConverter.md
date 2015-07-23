Exchange Rate Converter
========================================================

Exchange rate (ForEx rate) is one of the most important means through which a country’s relative level of economic health is determined. A country's foreign exchange rate provides a window to its economic stability, which is why it is constantly watched and analyzed. 

The exchange rate is defined as "the rate at which one country's currency may be converted into another." It may fluctuate daily with the changing market forces of supply and demand of currencies from one country to another.


author: Ravi Pandey
date: 7/10/2015

Exchange Rate - Influencing Factors
========================================================
1. Inflation Rates
2. Interest Rates
3. Country’s Current Account / Balance of Payments
4. Government Debt
5. Terms of Trade
6. Political Stability & Performance
7. Recession
8. Speculation

***
![Alt Text] (CurrencyConverter-figure/Factors_Affecting_Exchange_Rates.jpg)


Why You need the App?.smaller
========================================================
All of these factors determine the foreign exchange rate fluctuations. If you send or receive money frequently, being up-to-date on these factors will help you better evaluate the optimal time for international money transfer. To avoid any potential falls in currency exchange rates, opt for a locked-in exchange rate service, which will guarantee that your currency is exchanged at the same rate despite any factors that influence an unfavorable fluctuation.
***
![Alt Text] (CurrencyConverter-figure/bigstock-Currency-Exchange-Rates-Board-2231588.jpg)

Conversion Logic (Server.R)
========================================================


```r
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
```

User Interface(ui.R)
========================================================


```r
#library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("Currency Exchange Calculator"),
    sidebarPanel(
        selectInput("variable", "Change:",
                    list("USD",
                         "EUR",
                         "GBP",
                         "AUD",
                         "CAD",
                         "CHF",
                         "DKK",
                         "HKD",
                         "JPY",
                         "KRW",
                         "NOK",
                         "NZD",
                         "SEK",
                         "MXN")),
        selectInput("variable2", "To:",
                    list("EUR",
                         "USD",
                         "GBP",
                         "AUD",
                         "CAD",
                         "CHF",
                         "DKK",
                         "HKD",
                         "JPY",
                         "KRW",
                         "NOK",
                         "NZD",
                         "SEK",
                         "MXN")),
        numericInput('amount', 'Amount to be converted at current exchange rate:',
                     1, min = 0, step = 0.5),
        numericInput('days', 'no. of Prior periods to look for exchange rates!', 
                     10, min = 1, max = 480, step = 1)
        
    ),
    mainPanel(
        tabsetPanel(
            tabPanel("Instructions",
                     h5(" This application converts the currency provided in one denomination to the other at the current exchange rate. There is also the option to choose prior periods to see the trend in exchange rates."),
                     h4("1. Select the currency in From"),
                     h4("2. Select the currency in To"),
                     h4("3. Enter the amount to convert(Default is 1)"),
                     h4("4. Enter the number of prior periods for trend"),
                     h5("Click the Conversion Tab to view results. You can run this as many times you want")
                ),
            tabPanel("Conversion",
                h3('Exchanged Currency'),
                h4("From"),
                textOutput("oid1"),
                h4("To"),
                textOutput("oid2"),
                h4("Amount at current exchange rate"),
                textOutput("amount"),
                h4 ("Amount at past exchange rate"),
                textOutput("amount2"),
                plotOutput('myplot')                
                )
            )
        )
    ))
```

<!--html_preserve--><div class="container-fluid">
<div class="row">
<div class="col-sm-12">
<h1>Currency Exchange Calculator</h1>
</div>
</div>
<div class="row">
<div class="col-sm-4">
<form class="well">
<div class="form-group shiny-input-container">
<label class="control-label" for="variable">Change:</label>
<div>
<select id="variable"><option value="USD" selected>USD</option>
<option value="EUR">EUR</option>
<option value="GBP">GBP</option>
<option value="AUD">AUD</option>
<option value="CAD">CAD</option>
<option value="CHF">CHF</option>
<option value="DKK">DKK</option>
<option value="HKD">HKD</option>
<option value="JPY">JPY</option>
<option value="KRW">KRW</option>
<option value="NOK">NOK</option>
<option value="NZD">NZD</option>
<option value="SEK">SEK</option>
<option value="MXN">MXN</option></select>
<script type="application/json" data-for="variable" data-nonempty="">{}</script>
</div>
</div>
<div class="form-group shiny-input-container">
<label class="control-label" for="variable2">To:</label>
<div>
<select id="variable2"><option value="EUR" selected>EUR</option>
<option value="USD">USD</option>
<option value="GBP">GBP</option>
<option value="AUD">AUD</option>
<option value="CAD">CAD</option>
<option value="CHF">CHF</option>
<option value="DKK">DKK</option>
<option value="HKD">HKD</option>
<option value="JPY">JPY</option>
<option value="KRW">KRW</option>
<option value="NOK">NOK</option>
<option value="NZD">NZD</option>
<option value="SEK">SEK</option>
<option value="MXN">MXN</option></select>
<script type="application/json" data-for="variable2" data-nonempty="">{}</script>
</div>
</div>
<div class="form-group shiny-input-container">
<label for="amount">Amount to be converted at current exchange rate:</label>
<input id="amount" type="number" class="form-control" value="1" min="0" step="0.5"/>
</div>
<div class="form-group shiny-input-container">
<label for="days">no. of Prior periods to look for exchange rates!</label>
<input id="days" type="number" class="form-control" value="10" min="1" max="480" step="1"/>
</div>
</form>
</div>
<div class="col-sm-8">
<div class="tabbable tabs-above">
<ul class="nav nav-tabs">
<li class="active">
<a href="#tab-3149-1" data-toggle="tab" data-value="Instructions">Instructions</a>
</li>
<li>
<a href="#tab-3149-2" data-toggle="tab" data-value="Conversion">Conversion</a>
</li>
</ul>
<div class="tab-content">
<div class="tab-pane active" data-value="Instructions" id="tab-3149-1">
<h5> This application converts the currency provided in one denomination to the other at the current exchange rate. There is also the option to choose prior periods to see the trend in exchange rates.</h5>
<h4>1. Select the currency in From</h4>
<h4>2. Select the currency in To</h4>
<h4>3. Enter the amount to convert(Default is 1)</h4>
<h4>4. Enter the number of prior periods for trend</h4>
<h5>Click the Conversion Tab to view results. You can run this as many times you want</h5>
</div>
<div class="tab-pane" data-value="Conversion" id="tab-3149-2">
<h3>Exchanged Currency</h3>
<h4>From</h4>
<div id="oid1" class="shiny-text-output"></div>
<h4>To</h4>
<div id="oid2" class="shiny-text-output"></div>
<h4>Amount at current exchange rate</h4>
<div id="amount" class="shiny-text-output"></div>
<h4>Amount at past exchange rate</h4>
<div id="amount2" class="shiny-text-output"></div>
<div id="myplot" class="shiny-plot-output" style="width: 100% ; height: 400px"></div>
</div>
</div>
</div>
</div>
</div>
</div><!--/html_preserve-->
