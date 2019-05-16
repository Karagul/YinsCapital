#' @title Prediction using RNN for Designated Stock Ticker
#' @description Prediction using RNN for Designated Stock Ticker
#' @param
#' @return
#' @examples RNN_Daily()
#' @export RNN_Daily
#'
#' # Define function
RNN_Daily <- function(entry) {
  # Data
  getSymbols(c("SPY", "IVV"))
  x <- IVV[, 4][(nrow(IVV) - 800 + 1):nrow(IVV), ]
  y <- entry[, 4][(nrow(entry) - 800 + 1):nrow(entry), ]

  # Samples of 20 time series
  X <- matrix(x, nrow = 20)
  Y <- matrix(y, nrow = 20)

  # Plot noisy waves
  #plot(as.vector(X), col='blue', type='l', ylab = "X,Y", main = "Noisy waves")
  #lines(as.vector(Y), col = "red")
  #legend("topleft", c("X", "Y"), col = c("blue","red"), lty = c(1,1), lwd = c(1,1))

  # Standardize in the interval 0 - 1
  X <- (X - min(X)) / (max(X) - min(X))
  Y <- (Y - min(Y)) / (max(Y) - min(Y))

  # Transpose
  X <- t(X)
  Y <- t(Y)

  # Training-testing sets
  cutoff = .7
  train <- 1:(nrow(X)*cutoff)
  test <- (nrow(X)*cutoff + 1):nrow(X)

  # Train model. Keep out the last two sequences.
  model <- trainr(Y = Y[train,],
                  X = X[train,],
                  learningrate = 0.05,
                  hidden_dim = 16,
                  numepochs = 100)

  # Predicted values
  Yp <- predictr(model, X)

  # Plot predicted vs actual. Training set + testing set
  #plot(as.vector(t(Y)), col = 'red', type = 'l', main = "Actual vs predicted", ylab = "Y,Yp")
  #lines(as.vector(t(Yp)), type = 'l', col = 'blue')
  #legend("topleft", c("Predicted", "Real"), col = c("blue","red"), lty = c(1,1), lwd = c(1,1))

  # Plot predicted vs actual. Testing set only.
  #plot(as.vector(t(Y[test,])), col = 'red', type='l', main = "Actual vs predicted: testing set", ylab = "Y,Yp")
  #lines(as.vector(t(Yp[test,])), type = 'l', col = 'blue')
  #legend("topleft", c("Predicted", "Real"), col = c("blue","red"), lty = c(1,1), lwd = c(1,1))

  # Test MSE
  Test.MSE <- (sum(t(Y[test,]) - t(Yp[test,])))^2

  # Actual prediction
  Yp_actual <- predictr(model, X[(ncol(X) - 10):ncol(X), ])
  Yp_actual_vector <- as.vector(t(Yp_actual))
  result <- data.frame(
    Next_D_Change = Yp_actual_vector,
    CI_LB = Yp_actual_vector - 2*sd(Yp_actual_vector),
    CI_UB = Yp_actual_vector + 2*sd(Yp_actual_vector)
  )

  # Output
  return(tail(result))
}# End of function
