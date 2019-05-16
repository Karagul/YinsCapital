#' @title Buy Sell Algorithm Chart for Designated Stock Ticker
#' @description Buy and/or Sell Algorithm for Designated Stock Ticker
#' @param
#' @return
#' @examples BS_Algo_Chart()
#' @export BS_Algo_Chart
#'
#' # Define function
BS_Algo_Chart <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,past.n.days,test.new.price=0) {
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  past.n.days <- round(daily_ending_time_plot - daily_initial_time_plot)
  data <- YinsCapital::BS_Algo(x,r_day_plot,end_day_plot,c.buy,c.sell,height, past.n.days,test.new.price=0)[, c(3,4)]
  dygraph(data) %>%
    dyBarChart() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>%
    dyRangeSelector()
} # End of function
