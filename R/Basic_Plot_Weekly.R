#' @title Basic Plot for Designated Stock Ticker
#' @description Basic Plot for Designated Stock Ticker
#' @param
#' @return
#' @examples Basic_Plot_Weekly()
#' @export Basic_Plot_Weekly
#'
#' # Define function
Basic_Plot_Weekly <- function(x,r_day_plot,end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  name <- colnames(x)
  x <- to.weekly(x)
  colnames(x) <- name
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  # Advanced plot:
  dygraph(data.all) %>% dyCandlestick() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>%
    dyRangeSelector()
} # End of function
