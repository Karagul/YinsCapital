#' @title Fundamental Plot for Designated Stock Ticker
#' @description Fundamental Plot for Designated Stock Ticker
#' @param
#' @return
#' @examples Fin_Report_IS_Plot()
#' @export Fin_Report_IS_Plot
#'
#' # Define function
Fin_Report_IS_Plot <- function(
  enter_stock,
  whichyear = 2017
) {
  YR <- as.numeric(unlist(strsplit(as.character(Sys.time()),"-"))[[1]])
  temp <- GetIncome(as.character(enter_stock), whichyear)
  temp <- temp[order(temp$endDate, temp$startDate), c(4,5,1,2,3)]
  temp$Amount <- as.numeric(as.character(temp$Amount))
  temp <- temp[, c(4,5,1,2,3)]
  ggplot(temp, aes(Amount, reorder(Metric, -Amount), color = endDate)) +
    geom_point() + theme(text = element_text(size=18)) + ylab("Metric")
} # End of function
