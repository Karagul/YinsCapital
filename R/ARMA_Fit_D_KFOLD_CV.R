#' @title Model Fitting using ARMA Daily Data for Designated Stock Ticker
#' @description Model Fitting using ARMA Daily Data for Designated Stock Ticker
#' @param
#' @return
#' @examples ARMA_Fit_D_KFOLD_CV()
#' @export ARMA_Fit_D_KFOLD_CV
#'
#' # Define function
ARMA_Fit_D_KFOLD_CV <- function(
  entry,
  ahead = 10,
  cutoff = 0.9,
  how.many.fold = 6) {

  # Define
  #entry = AAPL
  entry <- entry[,4]
  ahead <- ahead
  cutoff <- cutoff

  # K-fold CV
  all <- entry; all.copy <- all
  num.break <- how.many.fold
  train.results <- NULL
  test.results <- NULL
  folds <- cut(seq(1,nrow(all)),breaks=num.break,labels=FALSE)

  # CV
  sum.MSE <- NULL
  sum.Model <- list()
  for (i in c(1:(num.break-1))) {
    all <- all.copy
    train <- all[which(folds == i), ]
    all <- train

    # Model fitting
    fit <- auto.arima(
      all[1:round(cutoff*nrow(all)), ],
      stationary=FALSE,
      max.p = 30, max.q = 30, max.P = 10,
      max.Q = 10, max.order = 5, max.d = 2, max.D = 1, start.p = 2,
      start.q = 2, start.P = 1, start.Q = 1,
      ic=c("aicc","aic","bic"),
      test=c("kpss","adf","pp"),
      approximation=TRUE
    )
    Y_hat <- data.frame(forecast(fit, nrow(all[round(cutoff*nrow(all)):nrow(all), ])))
    Y_hat <- Y_hat$Point.Forecast
    Y <- all[round(cutoff*nrow(all)):nrow(all), ]
    MSE <- mean((Y_hat - Y)^2)

    # Store result
    sum.MSE <- c(sum.MSE, MSE)
    sum.Model[[i]] <- fit
  }

  # Choose the best param
  best.fit <- sum.Model[[which.min(sum.MSE)]]
  sum.MSE; best.fit

  # Test
  all <- all.copy
  train <- all[which(folds != num.break), ]
  test <- all[which(folds == num.break), ]
  fit <- auto.arima(
    train,
    stationary=FALSE,
    max.p = 30, max.q = 30, max.P = 10,
    max.Q = 10, max.order = 5, max.d = 2, max.D = 1, start.p = 2,
    start.q = 2, start.P = 1, start.Q = 1,
    ic=c("aicc","aic","bic"),
    test=c("kpss","adf","pp"),
    approximation=TRUE
  )
  Y_hat <- data.frame(forecast(fit, length(test)))
  Y_hat <- Y_hat$Point.Forecast
  Y <- test
  plot.data <- cbind(Y_hat, Y)
  colnames(plot.data)[1] <- c("Prediction")

  # Prediction
  fit <- auto.arima(
    entry,
    stationary=FALSE,
    max.p = 20, max.q = 20, max.P = 10,
    max.Q = 10, max.order = 5, max.d = 2, max.D = 1, start.p = 2,
    start.q = 2, start.P = 1, start.Q = 1,
    ic=c("aicc","aic","bic"),
    test=c("kpss","adf","pp"),
    approximation=TRUE
  )
  #summary(fit)
  results<-cbind(
    # fit$coef,
    fit$sigma^2,
    fit$log,
    fit$aic,
    fit$aicc,
    fit$bic
  )
  #results
  forecast<-data.frame(forecast(fit,ahead))
  forecast.days <- 1:ahead
  forecast <- data.frame(cbind(
    forecast.days, forecast
  ))
  colnames(forecast) <- c("Day + ?", "Point.Forecast", "Lo.80", "Hi.80", "Lo.95", "Hi.95")
  forecast

  # Return
  return(list(
    Summary.of.MSE = sum.MSE,
    Best.Model = best.fit,
    Test.MSE = mean(apply(plot.data, 1, mean)),
    #Graph = dygraph(plot.data),
    Forecast = forecast
  ))
} # End of function
