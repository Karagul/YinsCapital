#' @title AI Screener for Entered Tickers
#' @description AI Screener Desgiend to Filter Stocks
#' @param
#' @return
#' @examples AI_Screener()
#' @export AI_Screener
#'
#' # Define function
AI_Screener <- function(
  tickers = c("AAPL", "FB"),
  threshold = 0.03
) {
  screening_process <- lapply(tickers, function(x) YinsCapital::AI_Predictor(x, threshold = threshold)$Candidates_Recommendation)
  names(screening_process) <- tickers
  all_stocks_prob <- c()
  pb <- txtProgressBar(min = 0, max = length(tickers), style = 3)
  tryCatch(
    for (i in 1:length(tickers)) {
      all_stocks_prob <- c(all_stocks_prob, mean(data.frame(screening_process[i])[,2]))
      setTxtProgressBar(pb, i)})
  final_data <- cbind(tickers = tickers, prob = all_stocks_prob)
  final_data <- final_data[order(as.numeric(as.character(final_data[, 2])), decreasing = TRUE), ]
  return(list(
    Screening_Process = screening_process,
    Final_Data = final_data
  ))
} # End of function
