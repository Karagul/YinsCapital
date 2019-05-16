#' @title Buy Sell Algorithm for Designated Stock Ticker
#' @description Buy and/or Sell Algorithm for Designated Stock Ticker
#' @param
#' @return
#' @examples BS_Algo()
#' @export BS_Algo
#'
#' # Define function
BS_Algo <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,past.n.days,test.new.price=0) {
  buy.sell.table <- data.frame(cbind(
    rownames(YinsCapital::Buy_Table(x,r_day_plot,end_day_plot,c.buy,height,past.n.days)),
    YinsCapital::Buy_Table(x,r_day_plot,end_day_plot,c.buy,height,past.n.days,test.new.price)[,1:2],
    YinsCapital::Sell_Table(x,r_day_plot,end_day_plot,c.sell,height,past.n.days,test.new.price)[,2]
  ))
  colnames(buy.sell.table) <- c("Date", "Ticker", "Buy.Signal", "Sell.Signal")
  buy.sell.table
} # End of function
