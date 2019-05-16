#' @title Visualization for Designated 8 Stock Ticker
#' @description Visualization for Designated 8 Stock Ticker
#' @param
#' @return
#' @examples QQ_Comparison()
#' @export QQ_Comparison
#'
#' # Define function
QQ_Comparison <- function(
  tickers = c( "SPY", "AAPL", "FB", "GOOGL", "WMT", "PEP", "SBUX", "GS", "BAC", "WFC" ),
  past_n_days = 30
) {
  getSymbols(tickers)
  closePrices <- do.call(merge, lapply(tickers, function(x) Cl(get(x))))
  DF <- closePrices; N <- nrow(DF)
  data_new <- c()
  for (j in 1:ncol(closePrices)) {
    data_new <- cbind(
      data_new,
      as.numeric(closePrices[,j]/lag(closePrices[,j])-1)
    )
  }; colnames(data_new) <- paste0(tickers, "_Daily_Return")
  data_new <- data.frame(na.omit(data_new))
  data_compare <- data.frame(cbind(Equal_Weight = apply(data_new[, -1], 1, mean), Market = data_new$SPY_Daily_Return))
  data_compare <- data_compare[(nrow(data_compare)-past_n_days):nrow(data_compare), ]
  qqP1 <- ggplot(data_compare, aes(sample = Equal_Weight)) +
    stat_qq() +
    stat_qq_line() +
    ggtitle(paste0("QQPlot: Past ",past_n_days+1," days of data"),
            subtitle = "Portfolio (Eq Weight) Return vs. Standard Normal")
  qqP2 <- ggplot(data_compare, aes(sample = Market)) +
    stat_qq() +
    stat_qq_line() +
    ggtitle(paste0("QQPlot: Past ",past_n_days+1," days of data"),
            subtitle = "Market Return vs. Standard Normal")
  qqP3 <- ggplot(data_compare, aes(Equal_Weight, Market)) +
    geom_line() +
    ggtitle(paste0("QQPlot: Past ",past_n_days+1," days of data"),
            subtitle = "Portfolio (Eq Weight) Return vs. Market Return")
  gridall = grid.arrange(qqP1,qqP2,qqP3, nrow=1)
  return(list(
    qqP1 = qqP1, qqP2 = qqP2, qqP3 = qqP3,
    Grid = gridall
  ))
} # End of function
