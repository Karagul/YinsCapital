#' @title Watchlist for XLF for Designated Stock Ticker
#' @description Watchlist for XLF for Designated Stock Ticker
#' @param
#' @return
#' @examples XLF_Watch_List()
#' @export XLF_Watch_List
#'
#' # Define function
XLF_Watch_List <- function(
  buy.height = -1.96,
  past.days = 3
) {
  # Download Stock Pool:
  data <- getSymbols(c(
    # XLF
    "SPY", "XLF", "JPM", "BAC", "WFC",
    "USB", "GS", "AXP", "MS", "PNC",
    "BLK", "SCHW", "BK"
  ))
  data.list <- list(
    # XLF
    "SPY", "XLF", "JPM", "BAC", "WFC",
    "USB", "GS", "AXP", "MS", "PNC",
    "BLK", "SCHW", "BK"
  )
  data.data.matrix <- list(
    SPY, XLF, JPM, BAC, WFC,
    USB, GS, AXP, MS, PNC,
    BLK, SCHW, BK
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
        round(YinsCapital::BS_Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, past.days)[,3],2),
        round(mean(YinsCapital::BS_Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, nrow(data.data.matrix[[i]]))[,3]),2),
        round(sd(YinsCapital::BS_Algo(data.data.matrix[[i]], .01, 1, buy.height, 2.9, 0.01, nrow(data.data.matrix[[i]]))[,3]),2)
      )
    ))
  }
  rownames(buy.watch.list) <- c(as.character(YinsCapital::BS_Algo(SPY, .9, 1, buy.height, 2.9, 1, past.days)[,1]), "Mean", "SD")
  colnames(buy.watch.list) <- data.list
  buy.watch.list <- t(buy.watch.list)
  buy.watch.list <- data.frame(cbind(
    Name = rownames(buy.watch.list),
    buy.watch.list
  ))

  # Present table:
  return(buy.watch.list)
} # End of function
