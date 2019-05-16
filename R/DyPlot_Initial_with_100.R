#' @title Visualization for Designated 8 Stock Ticker
#' @description Visualization for Designated 8 Stock Ticker
#' @param
#' @return
#' @examples DyPlot_Initial_with_100()
#' @export DyPlot_Initial_with_100
#'
#' # Define function
DyPlot_Initial_with_100 <- function(
  tickers = c( "AAPL", "FB", "GOOGL", "WMT", "PEP", "SBUX", "GS", "BAC", "WFC" ),
  past_days = 300
) {
  getSymbols(tickers)
  closePrices <- do.call(merge, lapply(tickers, function(x) Cl(get(x))))
  dateWindow <- c(as.Date(Sys.time())-past_days, as.Date(Sys.time()))
  dygraph(closePrices, main = "Value (in USD)", group = "stock") %>%
    dyRebase(value = 100) %>% dyRangeSelector(dateWindow = dateWindow)
} # End of function
