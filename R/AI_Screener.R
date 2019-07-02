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
  to.date = Sys.Date(),
  cutoff = 0.5,
  threshold = 0.03,
  use.iscore = TRUE,
  verbatim = TRUE
) {

  # Ge Data
  screening_process <- lapply(tickers, function(x) YinsCapital::AI_Predictor(
    tickers = x,
    to.date = to.date,
    cutoff = cutoff,
    threshold = threshold,
    use.iscore = use.iscore))
  names(screening_process) <- tickers

  # Running Algorithms
  all_stocks_prob <- c()
  if (verbatim) {pb <- txtProgressBar(min = 0, max = length(tickers), style = 3)}
  tryCatch(
    for (i in 1:length(tickers)) {
      all_stocks_prob <- c(all_stocks_prob, mean(data.frame(screening_process[[i]]$Candidates_Recommendation)[,2]))
      if (verbatim) {setTxtProgressBar(pb, i)}})
  final_data <- cbind(Tickers = tickers, Probability = all_stocks_prob)
  final_data <- final_data[order(as.numeric(as.character(final_data[, 2])), decreasing = TRUE), ]

  # Output
  return(list(
    Screening_Process = screening_process,
    Final_Data = final_data
  ))
} # End of function
