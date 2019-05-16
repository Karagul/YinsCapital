#' @title Buy Sell Distribution for Designated Stock Ticker
#' @description Buy Sell Distribution for Designated Stock Ticker
#' @param
#' @return
#' @examples BS_Dist()
#' @export BS_Dist
#'
#' # Define function
BS_Dist <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,test.new.price=0) {
  # x <- SPY; r_day_plot = .8; end_day_plot = 1; c.buy = -.5; c.sell = .5; height = 1
  past.n.days <- nrow(x)
  buy.sell.table <- YinsCapital::BS_Algo(
    x,
    r_day_plot,end_day_plot,
    c.buy,c.sell,height,
    past.n.days,test.new.price=0)

  bs.dist <- matrix(NA,nrow=4,ncol=2)
  bs.dist[1,1] <- round(mean(buy.sell.table[,3]),4)
  bs.dist[2,1] <- round(sd(buy.sell.table[,3]),4)
  bs.dist[3,1] <- round(max(buy.sell.table[,3]),4)
  bs.dist[4,1] <- plyr::count(buy.sell.table[,3] > 0)[2,2]/sum(plyr::count(buy.sell.table[,3] > 0)[1,2], plyr::count(buy.sell.table[,3] > 0)[2,2])
  bs.dist[4,1] <- round(bs.dist[4,1],4)
  bs.dist[1,2] <- round(mean(buy.sell.table[,4]),4)
  bs.dist[2,2] <- round(sd(buy.sell.table[,4]),4)
  bs.dist[3,2] <- round(max(buy.sell.table[,4]),4)
  bs.dist[4,2] <- plyr::count(buy.sell.table[,4] > 0)[2,2]/sum(plyr::count(buy.sell.table[,4] > 0)[1,2], plyr::count(buy.sell.table[,4] > 0)[2,2])
  bs.dist[4,2] <- round(bs.dist[4,2],4)
  bs.dist <- data.frame(cbind(
    c("Mean", "STD", "MAX", "Freq"),bs.dist,
    c("Ave. buy/sell signals including zeros",
      "Alpha:>=1STD; Beta:>0; Exit:<80% D/W low",
      "Maximum buy/sell signal ever happened",
      "Execution occurences x% of the time (you want to be as little as possible)") ))
  colnames(bs.dist) <- c("Summary", "Buy.Sig.Dist", "Sell.Sig.Dist", "Indicated Game Plan")
  return(bs.dist)
} # End of function
