#' @title Price to Market Algorithm for Designated Stock Ticker
#' @description Price to Market Algorithm for Designated Stock Ticker
#' @param
#' @return
#' @examples Price_to_Market_Algo()
#' @export Price_to_Market_Algo
#'
#' # Define function
Price_to_Market_Algo <- function(x, #r_day_plot, end_day_plot, c, height,
                                 past.n.buy=3,
                                 past.n.days=300){
  # Get data
  getSymbols("SPY")
  Close<-x[,4] # Define Close as adjusted closing price

  # Extract recent data
  #past.n.days = 500
  Close <- Close[(nrow(Close) - past.n.days):nrow(Close),]
  SPY <- SPY[(nrow(SPY) - past.n.days):nrow(SPY),]

  # Compute
  price.to.market <- Close/SPY[,4]
  minimum <- min(price.to.market); minimum <- round(minimum, 4)
  maximum <- max(price.to.market); maximum <- round(maximum, 4)
  average <- mean(price.to.market); average <- round(average, 4)
  SD <- sd(price.to.market); SD <- round(SD, 4)

  # Compute return beta
  Y = (Close/lag(Close)-1)*100; X = (SPY[,4]/lag(SPY[,4])-1)*100
  LM <- lm(Y ~ X)
  beta = LM$coefficients[2]; beta <- round(beta, 4)

  # Main Table Output
  Date <- rownames(data.frame(price.to.market))
  Result <- data.frame(cbind(
    data.frame(Date),
    data.frame(round(price.to.market, 4))
  )); colnames(Result) <- c("Date", "Price-to-Market")
  # Result

  # Stats
  statistics <- rbind(
    c("Min P/M = ", minimum, "Heavy buy if exposed to market normality."),
    c("Average P/M = ", average, "Do nothing."),
    c("SD of P/M = ", SD, "Consider buy/sell two SD below/above average level."),
    c("Max P/M = ", maximum, "Recommended sell if exposed to market normality."),
    c("Beta (Ret ~ MKT) = ", beta, "Volatility, behavior of stock price relative to market price."))
  colnames(statistics) <- c("Name", "P/M Distribution", "Indicated Game Plan")

  # Output
  return(list(
    Table = Result[(nrow(Result) - past.n.buy):nrow(Result),],
    Stats = statistics
  ))
} # End of function
