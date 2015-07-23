# This application converts currencies from one denomination to other basis current exchange rate
# also showing the variability in the exchnage rates

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
                     h4("1. Select the currency in Change:"),
                     h4("2. Select the currency in To:"),
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