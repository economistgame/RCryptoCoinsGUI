

library(shiny)
library(shinydashboard)
library(RCrypto)
library(quantmod)

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {

  Last_Quotes <- reactive({
    invalidateLater(5000,session)
     CoinMarketCap_All(currency = input$currency)
  })

  Only_selected <- reactive({
    All <-Last_Quotes()
    All[which(All$symbol==input$crypto_coin_selected),]
  })

  History <- reactive({
    Object <- paste0(input$crypto_coin_selected,"-",input$currency)
    data <- try(getSymbols(Object,auto.assign = FALSE),TRUE)
    validate(
      need(class(data) != "try-error", "Excuse, but this history quotes have not available")
    )
    data
  })

  output$tabla <- renderTable({
    All <- Last_Quotes()[,-c(1,3,4,9,10,11,15)]
    colnames(All)[1:8] <- c("Name","Price USD","Price BTC","24h Volume USD","Market Cap USD","1h Change","24h Change","Week Change")
    All
    })
  output$price_money <- renderInfoBox({
    Price_money <- Only_selected()[,paste0("price_",tolower(input$currency))]
    infoBox(
      paste0("Price in ",input$currency),round(as.numeric(Price_money),2) , icon = icon("money"),
      color = "blue", fill = TRUE)
  })
  output$price_btc <- renderInfoBox({
    Price_money <- Only_selected()[,"price_btc"]
    infoBox(
      paste0("Price in BTC"),round(as.numeric(Price_money),2) , icon = icon("money"),
      color = "blue", fill = TRUE)
  })

  output$change_1h <- renderInfoBox({
    Change_1h <- as.numeric(Only_selected()[,"percent_change_1h"])
    color <- ifelse(Change_1h>0,"green","red")
    infoBox(
      "LAST 1H", paste0(Change_1h, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })

  output$change_24h <- renderInfoBox({
    Change_24h <- as.numeric(Only_selected()[,"percent_change_24h"])
    color <- ifelse(Change_24h>0,"green","red")
    infoBox(
      "LAST DAY", paste0(Change_24h, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })

  output$change_week <- renderInfoBox({
    Change_week <- as.numeric(Only_selected()[,"percent_change_7d"])
    color <- ifelse(Change_week>0,"green","red")
    infoBox(
      "LAST WEEK", paste0(Change_week, "%"), icon = icon("percent"),
      color = color, fill = TRUE
    )
  })


  output$quote_yahpp <- renderPlot({

      chartSeries(History(),name =paste0(input$crypto_coin_selected,"-",input$currency),subset="last 2 years",TA =input$analysis , theme="white")
  })


})
