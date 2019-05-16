#' @title Watchlist for DIA for Designated Stock Ticker
#' @description Watchlist for DIA for Designated Stock Ticker
#' @param
#' @return
#' @examples DIA_Watch_List()
#' @export DIA_Watch_List
#'
#' # Define function
DIA_Watch_List <- function(
  buy.height = -1.96,
  past.days = 3
) {
  # Download Stock Pool:
  data <- getSymbols(c(
    # DJIA
    "SPY", "AXP", "AAPL", "BA", "CVX", "CSCO",
    "DIS", "XOM", "GE", "GS", "HD", "IBM", "INTC",
    "JPM", "MCD", "MRK", "MSFT", "NKE",
    "PFE", "PG", "UTX", "UNH",
    "V", "WMT"
  ))
  data.list <- list(
    # DJIA
    "SPY", "AXP", "AAPL", "BA", "CVX", "CSCO",
    "DIS", "XOM", "GE", "GS", "HD", "IBM", "INTC",
    "JPM", "MCD", "MRK", "MSFT", "NKE",
    "PFE", "PG", "UTX", "UNH",
    "V", "WMT"
  )
  data.data.matrix <- list(
    SPY, AXP, AAPL, BA, CVX, CSCO,
    DIS, XOM, GE, GS, HD, IBM, INTC,
    JPM, MCD, MRK, MSFT, NKE,
    PFE, PG, UTX, UNH,
    V, WMT
  )

  # Watch List:
  #print("BRIDGEWATER PICKS")
  #buy.height <- -1.96
  #past.days <- 4
  buy.watch.list <- NULL
  # for (i in 1:length(data.data.matrix)){print(c(i, dim(data.data.matrix[[i]])))}
  for (i in 1:length(data.data.matrix)) {
    buy.watch.list <- data.frame(cbind(
      buy.watch.list,
      c(
        round(YinsCapital::BS.Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, past.days)[,3],2),
        round(mean(YinsCapital::BS.Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, nrow(data.data.matrix[[i]]))[,3]),2),
        round(sd(YinsCapital::BS.Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, nrow(data.data.matrix[[i]]))[,3]),2)
      )
    ))
  }
  rownames(buy.watch.list) <- c(as.character(YinsCapital::BS.Algo(SPY, .9, 1, buy.height, 2.9, 1, past.days)[,1]), "Mean", "SD")
  colnames(buy.watch.list) <- data.list
  buy.watch.list <- t(buy.watch.list)
  buy.watch.list <- data.frame(cbind(
    Name = rownames(buy.watch.list),
    buy.watch.list
  ))

  # Present table:
  return(buy.watch.list)
} # End of function
