#' @title AI Predictor for Entered Ticker
#' @description AI Predictor Trained to Conclude a Probability for Today's Stock Price
#' @param
#' @return
#' @examples AI_Predictor()
#' @export AI_Predictor
#'
#' # Define function
AI_Predictor <- function(
  tickers = "SPY",
  threshold = 0.02) {
  library(quantmod)
  #tickers = "SPY"
  #threshold = 0.02
  getSymbols(tickers)
  closePrices <-do.call(merge, lapply(tickers, function(x) Cl(get(x))))
  cl_price <- closePrices[, 1]
  data <- data.frame(cbind(
    Y = as.numeric(cl_price / lag(cl_price) - 1 > threshold),
    X = cbind(
      cl_price / lag(lag(cl_price)) - 1,
      cl_price / lag(lag(lag(cl_price))) - 1,
      cl_price / lag(lag(lag(lag( cl_price )))) - 1,
      cl_price / lag(lag(lag(lag( lag(cl_price) )))) - 1,
      cl_price / lag(lag(lag(lag( lag(lag(cl_price)) )))) - 1,
      cl_price / lag(lag(lag(lag( lag(lag(lag(cl_price))) )))) - 1,
      cl_price / lag(lag(lag(lag( lag(lag(lag(lag( cl_price )))) )))) - 1,
      cl_price / lag(lag(lag(lag( lag(lag(lag(lag( lag(cl_price) )))))))) - 1,
      cl_price / lag(lag(lag(lag( lag(lag(lag(lag( lag(lag(cl_price)) )))) )))) - 1,
      cl_price / lag(lag(lag(lag(lag(lag(lag(lag(lag(lag(lag(cl_price))))))))))) - 1
    )
  ))
  data <- data.frame(na.omit(data))
  all <- data
  GBM_Result <- YinsLibrary::Gradient_Boosting_Machine_Classifier(
    x = data.frame(
      cbind(
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))]
      )
    ),
    y = all[, 1],
    cutoff = 0.5,
    cutoff.coefficient = 1,
    num.of.trees = 50,
    bag.fraction = 0.5,
    shrinkage = 0.05,
    interaction.depth = 3,
    cv.folds = 5
  )
  GBM_Result$Test.Confusion.Matrix
  GBM_Result$Test.AUC
  GBM_Result$Test.Y.Hat[length(GBM_Result$Test.Y.Hat)]
  Bagging_Result <- YinsLibrary::Bagging_Classifier(
    x = data.frame(
      cbind(
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))]
      )
    ),
    y = all[, 1],
    cutoff = 0.5,
    nbagg = 10,
    cutoff.coefficient = 1
  )
  Bagging_Result$Prediction.Table
  Bagging_Result$Testing.Accuracy
  Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)]
  RF_Result <- YinsLibrary::Random_Forest(
    x = data.frame(
      cbind(
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))]
      )
    ),
    y = all[, 1],
    cutoff = 0.5,
    num.tree = 20,
    num.try = 20,
    cutoff.coefficient = 1,
    SV.cutoff = 1:4
  )
  RF_Result$Prediction.Table; RF_Result$AUC; RF_Result$test.y.hat[length(RF_Result$test.y.hat)]
  iRF_Result <- YinsLibrary::iter_Random_Forest_Classifier(
    x = data.frame(
      cbind(
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))],
        all[,-1][, sample(1:(ncol(all) - 1), (ncol(all) - 1))]
      )
    ),
    y = all[, 1],
    cutoff = 0.5,
    num.tree = 10,
    num.iter = 10,
    SV.cutoff = 5
  )
  iRF_Result$Prediction.Table
  iRF_Result$AUC
  iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2]

  # Return
  return(list(
    GBM_Result = list(
      Test.Confusion.Matrix = GBM_Result$Test.Confusion.Matrix,
      Test.AUC = GBM_Result$Test.AUC),
    Bagging_Result = list(
      Prediction.Table = Bagging_Result$Prediction.Table,
      Testing.Accuracy = Bagging_Result$Testing.Accuracy),
    RF_Result = list(
      Prediction.Table = RF_Result$Prediction.Table,
      AUC = RF_Result$AUC),
    iRF_Result = list(
      Prediction.Table = iRF_Result$Prediction.Table,
      AUC = iRF_Result$AUC),
    Candidates_Recommendation = data.frame(
      Name = c("GBM", "BAG", "RF", "iRF"),
      Probability = c(
        GBM_Result$Test.Y.Hat[length(GBM_Result$Test.Y.Hat)],
        Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)],
        as.numeric(RF_Result$test.y.hat[length(RF_Result$test.y.hat)]),
        iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2])),
    Conclusion = paste0(
      "Entered ticker goes up today with probability: ",
      round(mean(c(
        GBM_Result$Test.Y.Hat[length(GBM_Result$Test.Y.Hat)],
        Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)],
        RF_Result$test.y.hat[length(RF_Result$test.y.hat)],
        iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2])), 3))
  ))
} # End of function