#' @title Basic Plot for Designated Stock Ticker
#' @description Basic Plot for Designated Stock Ticker
#' @param
#' @return
#' @examples Basic_Plot()
#' @export Basic_Plot
#'
#' # Define function
Basic_Plot <- function(x,r_day_plot,end_day_plot){
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  dygraph(data.all) %>% dyCandlestick() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>%
    dyRangeSelector()
} # End of function
