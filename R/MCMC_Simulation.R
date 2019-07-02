#' @title Markov Chain Monte Carlo Algorithm for Simulation
#' @description AI Predictor Trained to Conclude a Probability for Today's Stock Price
#' @param
#' @return
#' @examples MCMC_Simulation()
#' @export MCMC_Simulation
#'
#' # Define function
MCMC_Simulation <- function(
  seed = 1,
  path = 100,
  expected_return = 0.005,
  expected_sd = 0.02,
  num_of_days = 250,
  type = "l"
) {
  # Simulation
  seed = seed
  X = matrix(rnorm(num_of_days*path, expected_return, expected_sd) + 1L, ncol = path); X[1, ] <- 1L
  cum_X <- apply(X, 2, cumprod)
  matplot(
    cum_X,
    type = "l",
    xlab = "Number of Time Units",
    ylab = "Cumulative Return Path from $1",
    main = paste0("MCMC SIMULATION: \n E(r)=", expected_return, " and SD=", expected_sd, " with ", path, " Replicated Paths"))

  # Return
  return(list(
    Return_Matrix = X,
    Cumu_Return_Matrix = cum_X,
    Plot = matplot(
      cum_X,
      type = "l",
      xlab = "Number of Time Units",
      ylab = "Cumulative Return Path from $1",
      main = paste0("MCMC SIMULATION: \n E(r)=", expected_return, " and SD=", expected_sd, " with ", path, " Replicated Paths"))
  ))
} # End of function
