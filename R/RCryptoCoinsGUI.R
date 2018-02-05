#' User-friendly Interface using RCrypto and quantmod to see the current situation of cryptocurrents
#'
#' User-friendly Interface using RCrypto and quantmod to see the current situation of cryptocurrents
#'
#' @usage RCryptoCoinsGUI()
#'
#'
#' @examples
#' if(interactive()){
#' RCryptoCoinsGUI()
#'
#' }
#' @import "shiny" "shinydashboard" "RCrypto"  "utils" "quantmod"
#' @importFrom "shiny" "runApp"
#' @export
# Launch function
RCryptoCoinsGUI <- function() {
  # remove all false warnings
  utils::capture.output(
    suppressWarnings(
      # remove run Shiny App
      shiny::runApp(system.file("RCryptoCoinGUI", package = "RCryptoCoinsGUI"))
    )
  )
}
