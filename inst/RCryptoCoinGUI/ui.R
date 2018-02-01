
 Settings_currency <- "USD"

library(shiny)
library(shinydashboard)
library(RCrypto)

# Define UI for application that draws a histogram
dashboardPage(skin = "purple",
              dashboardHeader(title = "RCryptoCoins"),
              dashboardSidebar(
                sidebarMenu(
                  selectInput(inputId="currency",
                              label = "Select your currency:",
                              choices = Currencys,
                              selected = Settings_currency ),
                  selectInput(inputId="crypto_coin_selected",
                              label = "Select your favourite criptocoin:",
                              choices = Crypto_coins,
                              selected = "BTC"  ),


                  br(),
                  h3("Menu"),
                  menuItem("Control Panel", tabName = "modelo",icon = icon("dashboard")),
                  menuItem("All Quotes", tabName = "table",icon = icon("table"))
                  #menuItem("Settings", tabName = "settings",icon = icon("cow"))

                )

              ),
              dashboardBody(

                tabItems(

                tabItem("modelo",
                       infoBoxOutput("price_money",width = "3"),
                       infoBoxOutput("price_btc",width = "3"),
                        infoBoxOutput("change_1h",width = "3"),
                        infoBoxOutput("change_24h",width = "3"),
                        infoBoxOutput("change_week",width = "3"),
                        box(title="Analysis",
                            selectInput("analysis",
                                        label = "Select one indicator",
                                        choices = c("None"="addVo()",
                                                    "MACD"="addMACD()",
                                                    "RSI"="addRSI()",
                                                    "MA"="addMA()",
                                                    "Bolinger Bands"="addBBands()")),


                            width = "9",collapsible = TRUE),
                        box(title="History",plotOutput("quote_yahpp"),width="12",footer = "Source: Yahoo Finance vía quantmod"
                )),

                tabItem("table",
                        shiny::tableOutput("tabla")


                )
              )
              ))
