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
  time_unit = "week",
  to.date = Sys.Date(),
  cutoff = 0.5,
  threshold = 0.02,
  use.iscore = TRUE,
  verbatim = TRUE) {

  # Library
  library(quantmod)
  print(paste0("Now analyzing: ", tickers, "..."))
  getSymbols(tickers, to = to.date)
  closePrices <- do.call(merge, lapply(tickers, function(x) get(x)))
  if (time_unit == "day") {
    closePrices <- closePrices
  } else if (time_unit == "week") {
    closePrices <- to.weekly(closePrices)
  }
  cl_price <- closePrices$closePrices.Close
  op_price <- Op(closePrices)
  hi_price <- Hi(closePrices)
  lo_price <- Lo(closePrices)
  data <- data.frame(cbind(
    Y = lag(as.numeric(hi_price/op_price - 1 > threshold)),
    X = cbind(
      cl_price / lag(cl_price, k = 1), cl_price / lag(cl_price, k = 2),
      cl_price / lag(cl_price, k = 3), cl_price / lag(cl_price, k = 4),
      cl_price / lag(cl_price, k = 5), cl_price / lag(cl_price, k = 6),
      cl_price / lag(cl_price, k = 7), cl_price / lag(cl_price, k = 8),
      cl_price / lag(cl_price, k = 9), cl_price / lag(cl_price, k = 10),
      cl_price / lag(cl_price, k = 11), cl_price / lag(cl_price, k = 12),
      hi_price / lo_price,
      lag(hi_price / lo_price, k = 1), lag(hi_price / lo_price, k = 2),
      lag(hi_price / lo_price, k = 3), lag(hi_price / lo_price, k = 4),
      lag(hi_price / lo_price, k = 5), lag(hi_price / lo_price, k = 6),
      lag(hi_price / lo_price, k = 7), lag(hi_price / lo_price, k = 8),
      lag(hi_price / lo_price, k = 9), lag(hi_price / lo_price, k = 10),
      hi_price / op_price,
      lag(hi_price / op_price, k = 1), lag(hi_price / op_price, k = 2),
      lag(hi_price / op_price, k = 3), lag(hi_price / op_price, k = 3),
      lag(hi_price / op_price, k = 4), lag(hi_price / op_price, k = 5),
      lag(hi_price / op_price, k = 6), lag(hi_price / op_price, k = 7),
      lag(hi_price / op_price, k = 8), lag(hi_price / op_price, k = 9),
      lag(hi_price / op_price, k = 10),
      hi_price / cl_price,
      lag(hi_price / cl_price, k = 1), lag(hi_price / cl_price, k = 2),
      lag(hi_price / cl_price, k = 3), lag(hi_price / cl_price, k = 4),
      lag(hi_price / cl_price, k = 4), lag(hi_price / cl_price, k = 5),
      lag(hi_price / cl_price, k = 6), lag(hi_price / cl_price, k = 7),
      lag(hi_price / cl_price, k = 8), lag(hi_price / cl_price, k = 9),
      lag(hi_price / cl_price, k = 10),
      cl_price / op_price,
      lag(cl_price / op_price, k = 1), lag(cl_price / op_price, k = 2),
      lag(cl_price / op_price, k = 3), lag(cl_price / op_price, k = 4),
      lag(cl_price / op_price, k = 5), lag(cl_price / op_price, k = 6),
      lag(cl_price / op_price, k = 7), lag(cl_price / op_price, k = 8),
      lag(cl_price / op_price, k = 9), lag(cl_price / op_price, k = 10),
      op_price / hi_price,
      op_price / lag(hi_price, k = 1), op_price / lag(hi_price, k = 2),
      op_price / lag(hi_price, k = 3), op_price / lag(hi_price, k = 4),
      op_price / lag(hi_price, k = 5), op_price / lag(hi_price, k = 6),
      op_price / lo_price,
      op_price / lag(lo_price, k = 1), op_price / lag(lo_price, k = 2),
      op_price / lag(lo_price, k = 3), op_price / lag(lo_price, k = 4),
      op_price / lag(lo_price, k = 5), op_price / lag(lo_price, k = 6),
      op_price / lag(op_price),
      op_price / lag(lag(op_price), k = 1), op_price / lag(lag(op_price), k = 2),
      op_price / lag(lag(op_price), k = 3), op_price / lag(lag(op_price), k = 4),
      op_price / lag(lag(op_price), k = 5), op_price / lag(lag(op_price), k = 6),
      op_price / lag(cl_price),
      op_price / lag(lag(cl_price), k = 1), op_price / lag(lag(cl_price), k = 2),
      op_price / lag(lag(cl_price), k = 3), op_price / lag(lag(cl_price), k = 4),
      op_price / lag(lag(cl_price), k = 5), op_price / lag(lag(cl_price), k = 6)
  )))
  data <- data.frame(na.omit(data)); all <- data
  if (use.iscore) {
    print(paste0("Converting data into discrete levels using ISCORE ..."))
    tmp <- YinsLibrary::convert_data_by_iscore(
      x = all[, -1],
      y = all[, 1],
      cut_off = cutoff,
      verbatim = verbatim)
    all <- data.frame(cbind(y = tmp$y, X = tmp$x_new))
    # PREMISE: Maximum number of levels for X's: 0, 1, 2
    print(paste0("Running BDA ..."))
    Begin.Time <- Sys.time()
    ISCORE <- YinsLibrary::Discrete_VS(
      all = all,
      cut_off = cutoff,
      num.initial.set = 5,
      how.many.rounds = 300,
      num.top.rows = 100,
      seed = 1
    ); End.Time <- Sys.time(); print(paste0("Time spent on training this machine: ")); print(End.Time - Begin.Time)
    # INTERACTION-BASED FEATURE EXTRACTION & ENGINEER
    # This scripts takes ISCORE results from above
    # and update data by using interaction-based
    # feature extraction and engineering technique.
    print(paste0("Data engineering in progress using BDA results ..."))
    Begin.Time <- Sys.time()
    NewDataResult <- YinsLibrary::Interaction_Based_Feature_Extraction_and_Engineer(
      x = all[, -1],
      y = all[, 1],
      cut_off = cutoff,
      Result = ISCORE,
      num.top.rows = 5,
      do.you.want.only.modules = FALSE,
      seed = 1,
      verbatim = verbatim
    ); End.Time <- Sys.time(); print(paste0("Time spent on training this machine: ")); print(End.Time - Begin.Time)
    all <- data.frame(cbind(Y = NewDataResult$Y, NewDataResult$X))
  } else { all <- data }

  # MACHINE LEARNING
  print(paste0("Running GBM ..."))
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
    cutoff = cutoff,
    cutoff.coefficient = 1,
    num.of.trees = 100,
    bag.fraction = 0.5,
    shrinkage = 0.05,
    interaction.depth = 3,
    cv.folds = 5,
    verbatim = verbatim
  )
  GBM_Result$Test.Confusion.Matrix
  GBM_Result$Test.AUC
  GBM_Result$Test.Y.Hat[length(GBM_Result$Test.Y.Hat)]
  print(paste0("Running Bagging ..."))
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
    cutoff = cutoff,
    nbagg = 100,
    cutoff.coefficient = 1
  )
  Bagging_Result$Prediction.Table
  Bagging_Result$Testing.Accuracy
  Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)]
  print(paste0("Running Random Forest ..."))
  RF_Result <- YinsLibrary::Random_Forest_Classifier(
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
    cutoff = cutoff,
    num.tree = 100,
    num.try = 50,
    cutoff.coefficient = 1,
    SV.cutoff = 1:4
  )
  RF_Result$Prediction.Table; RF_Result$AUC; RF_Result$test.y.hat[length(RF_Result$test.y.hat)]
  print(paste0("Running iRF ..."))
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
    cutoff = cutoff,
    num.tree = 100,
    num.iter = 10,
    SV.cutoff = 1:4,
    verbatim = verbatim
  )
  iRF_Result$Prediction.Table
  iRF_Result$AUC
  iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2]
  print(paste0("Running BART ..."))
  BART_Result <- YinsLibrary::Bayesian_Additive_Regression_Tree_Classifier(
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
    cutoff = cutoff,
    num.tree = 100,
    num.cut = 50,
    cutoff.coefficient = 1,
    SV.cutoff = 1:4,
    verbatim = verbatim
  )
  BART_Result$Prediction.Table; BART_Result$AUC
  print(paste0("Finished running all algorithm ..."))
  print(paste0("Finished computing aggregated average voting for outcome ..."))
  print(paste0("... Results stored for ", tickers, "."))

  # Return
  return(list(
    GBM_Result = list(
      Test.Confusion.Matrix = GBM_Result$Test.Confusion.Matrix,
      Test.AUC = GBM_Result$Test.AUC,
      Test.Errors = GBM_Result$Test.Y.Errors),
    Bagging_Result = list(
      Prediction.Table = Bagging_Result$Prediction.Table,
      Testing.Accuracy = Bagging_Result$Testing.Accuracy,
      Test.Errors = plyr::count(Bagging_Result$test.y.hat - Bagging_Result$test.y.truth)),
    RF_Result = list(
      Prediction.Table = RF_Result$Prediction.Table,
      AUC = RF_Result$AUC,
      Test.Errors = RF_Result$test.y.errors),
    iRF_Result = list(
      Prediction.Table = iRF_Result$Prediction.Table,
      AUC = iRF_Result$AUC,
      Test.Errors = plyr::count(as.numeric(iRF_Result$test.y.hat - 1L) - iRF_Result$test.y.truth)),
    BART_Result = list(
      Prediction.Table = BART_Result$Prediction.Table,
      AUC = BART_Result$AUC,
      Test.Errors = plyr::count(BART_Result$Test.Y.Hat - as.numeric(BART_Result$Test.Y.Truth))),
    Candidates_Recommendation = data.frame(
      Name = c("GBM", "BAG", "RF", "iRF", "BART"),
      Probability = c(
        GBM_Result$Test.Y.Hat.Original[length(GBM_Result$Test.Y.Hat.Original)],
        Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)],
        as.numeric(RF_Result$test.y.hat[length(RF_Result$test.y.hat)]),
        iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2],
        BART_Result$Test.Y.Hat[length(BART_Result$Test.Y.Hat)])),
    Conclusion = paste0(
      "Entered ticker goes up today with probability: ",
      round(mean(c(
        GBM_Result$Test.Y.Hat[length(GBM_Result$Test.Y.Hat)],
        Bagging_Result$test.y.hat[length(Bagging_Result$test.y.hat)],
        RF_Result$test.y.hat[length(RF_Result$test.y.hat)],
        iRF_Result$Truth.vs.Predicted.Probabilities[nrow(iRF_Result$Truth.vs.Predicted.Probabilities), 2],
        BART_Result$Test.Y.Hat[length(BART_Result$Test.Y.Hat)])), 4))
  ))
} # End of function
