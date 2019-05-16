#' @title Buy Signal Correlation Table for Designated Stock Ticker
#' @description Buy Signal Correlation Table for Designated Stock Ticker
#' @param
#' @return
#' @examples Buy_Table_Correlation()
#' @export Buy_Table_Correlation
#'
#' # Define function
Buy_Table_Correlation <- function(x,r_day_plot,end_day_plot,c,height,past.n.days){
  # x <- AAPL
  getSymbols(c('SPY','QQQ','DIA','IWM','GLD','FEZ','FXI'))
  M <- data.frame(
    YinsCapital::Buy.table(x,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(SPY,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(QQQ,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(DIA,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(IWM,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(GLD,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(FEZ,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    YinsCapital::Buy.table(FXI,r_day_plot,end_day_plot,c,height,past.n.days)[,1]
  )
  M.update <- cor(M)
  colnames(M.update) = c("Entered.Stock","SPY","QQQ","DIA","IWM","GLD","FEZ","FXI")
  rownames(M.update) = c("Entered.Stock","SPY","QQQ","DIA","IWM","GLD","FEZ","FXI")
  return(data.frame(M.update))
} # End of function:
