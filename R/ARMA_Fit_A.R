#' @title Model Fitting using ARMA Yearly Data for Designated Stock Ticker
#' @description Model Fitting using ARMA Yearly Data for Designated Stock Ticker
#' @param
#' @return
#' @examples ARMA_Fit_A()
#' @export ARMA_Fit_A
#'
#' # Define function
ARMA_Fit_A <- function(entry,ahead){
  #entry <- SPY[,4]; ahead=10
  entry <-to.yearly(entry)[,4]
  fit<-auto.arima(
    entry,
    stationary=FALSE,
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
  colnames(forecast) <- c("Year + ?", "Point.Forecast", "Lo.80", "Hi.80", "Lo.95", "Hi.95")
  return(forecast)
} # End function
