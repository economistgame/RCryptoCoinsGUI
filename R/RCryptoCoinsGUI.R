#' User-friendly Interface using RCrypto and quantmod to see the current situation of cryptocurrents
#'
#'User-friendly Interface using RCrypto and quantmod to see the current situation of cryptocurrents
#'
#' @usage RCryptoCoinsGUI()
#'
#'
#' @examples
#' \dontrun{
#' RCryptoCoinsGUI()
#'
#' }
#' @import "shiny" "shinydashboard" "RCrypto"  "utils"
#' @importFrom "shiny" "runApp"
#' @export
RCryptoCoinsGUI <- function() {

  utils::capture.output(
    suppressWarnings(
      shiny::runApp(system.file("RCryptoCoinGUI", package = "RCryptoCoinsGUI"))
    )
  )

}
