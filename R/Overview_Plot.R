#' @title Overview Plot for Designated Stock Ticker
#' @description Overview Plot for Designated Stock Ticker
#' @param
#' @return
#' @examples Overview_Plot()
#' @export Overview_Plot
#'
#' # Define function
Overview_Plot <- function(
  x,
  r_day_plot,
  end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  chartSeries(data.all,
              theme = chartTheme("white"),
              name = "Candlestick Chart for Entered Ticker",
              TA = c(addEMA(12, col = 'green'),
                     addEMA(26, col = 'cyan'),
                     addEMA(50, col = 'yellow'),
                     addEMA(100, col = 'red'),
                     addEMA(200, col = 'purple'),
                     addVo(20))); addRSI(n = 28)
} # End of function
