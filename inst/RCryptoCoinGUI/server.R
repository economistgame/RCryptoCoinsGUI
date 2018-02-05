library(shiny)
library(shinydashboard)
library(RCrypto)
library(quantmod)

##Function to obtain current information about a one cryptocoin
 Only_Selected_Stock <- function(Symbol,Currency){
   All_values <- RCrypto::CoinMarketCap_All(currency = Currency)
   All_values[which(All_values$symbol == Symbol), ]
 }
##Function to obtain histiry information about cryptocoin
 GetCurrencyStock <- function(CryptoCoin,Currency){
   Object <- paste0(CryptoCoin, "-", Currency)
   data <- try(suppressWarnings(quantmod::getSymbols(Object, auto.assign = FALSE)), TRUE)
   validate(
     need(class(data) != "try-error", "Excuse, but this history quotes have not available")
   )
   data
 }
##Table formater
 FormatTable <- function(All_Values){
 All <- All_Values[, -c(1, 3, 4, 9, 10, 11, 15)]
 colnames(All)[1:8] <- c("Name", "Price USD", "Price BTC", "24h Volume USD", "Market Cap USD", "1h Change", "24h Change", "Week Change")
 All
 }

shinyServer(function(input, output, session) {

###All current available data
Last_Quotes <- reactive({
    invalidateLater(5000, session)
    CoinMarketCap_All(currency = input$currency)
  })
###Now showed in Dashboard
Only_selected <- reactive({
    invalidateLater(5000, session)
    Only_Selected_Stock(input$crypto_coin_selected, input$currency)
  })
###Obtain History of Yahoo Finance
History <- reactive({
    GetCurrencyStock(input$crypto_coin_selected,input$currency)
  })
###All current available data in a table
output$tabla <- renderTable({
    FormatTable(Last_Quotes())
  })
output$price_money <- renderInfoBox({
    Price_money <- Only_selected()[, paste0("price_", tolower(input$currency))]
    infoBox(
      paste0("Price in ", input$currency), round(as.numeric(Price_money), 2), icon = icon("money"),
      color = "blue", fill = TRUE
    )
  })
  output$price_btc <- renderInfoBox({
    Price_money <- Only_selected()[, "price_btc"]
    infoBox(
      paste0("Price in BTC"), round(as.numeric(Price_money), 2), icon = icon("money"),
      color = "blue", fill = TRUE
    )
  })

  output$change_1h <- renderInfoBox({
    Change_1h <- as.numeric(Only_selected()[, "percent_change_1h"])
    color <- ifelse(Change_1h > 0, "green", "red")
    infoBox(
      "LAST 1H", paste0(Change_1h, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })

  output$change_24h <- renderInfoBox({
    Change_24h <- as.numeric(Only_selected()[, "percent_change_24h"])
    color <- ifelse(Change_24h > 0, "green", "red")
    infoBox(
      "LAST DAY", paste0(Change_24h, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })

  output$change_week <- renderInfoBox({
    Change_week <- as.numeric(Only_selected()[, "percent_change_7d"])
    color <- ifelse(Change_week > 0, "green", "red")
    infoBox(
      "LAST WEEK", paste0(Change_week, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })

  output$quote_yahpp <- renderPlot({
    chartSeries(History(), name = paste0(input$crypto_coin_selected, "-", input$currency), subset = "last 2 years", TA = input$analysis, theme = "white")
  })
})

