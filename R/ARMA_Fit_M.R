#' @title Model Fitting using ARMA Monthly Data for Designated Stock Ticker
#' @description Model Fitting using ARMA Monthly Data for Designated Stock Ticker
#' @param
#' @return
#' @examples ARMA_Fit_M()
#' @export ARMA_Fit_M
#'
#' # Define function
ARMA_Fit_M <- function(entry,ahead){
  #entry <- SPY[,4]; ahead=10
  entry <-to.monthly(entry)[,4]
  fit<-auto.arima(
    entry,
    stationary=FALSE,
    max.p = 5, max.q = 5, max.P = 2,
    max.Q = 2, max.order = 5, max.d = 2, max.D = 1, start.p = 2,
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
  colnames(forecast) <- c("Month + ?", "Point.Forecast", "Lo.80", "Hi.80", "Lo.95", "Hi.95")
  return(forecast)
} # End function
