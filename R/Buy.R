#' @title Buy Function for Designated Stock Ticker
#' @description Buy Function for Designated Stock Ticker
#' @param
#' @return
#' @examples Buy()
#' @export Buy
#'
#' # Define function
Buy <- function(x,r_day_plot,end_day_plot,c,height,test.new.price = 0){
  if (test.new.price == 0) {
    x = x
  } else {
    intra.day.test <- data.frame(matrix(c(0,0,0,test.new.price,0,0), nrow = 1))
    rownames(intra.day.test) <- as.character(Sys.Date())
    x = data.frame(rbind(x, intra.day.test))
  }
  Close<-x[,4] # Define Close as adjusted closing price
  # A new function needs redefine data from above:
  # Create SMA for multiple periods
  SMA10<-SMA(Close,n=10)
  SMA20<-SMA(Close,n=20)
  SMA30<-SMA(Close,n=30)
  SMA50<-SMA(Close,n=50)
  SMA200<-SMA(Close,n=200)
  SMA250<-SMA(Close,n=250)

  # Create RSI for multiple periods
  RSI10 <- (RSI(Close,n=10)-50)*height*5
  RSI20 <- (RSI(Close,n=20)-50)*height*5
  RSI30 <- (RSI(Close,n=30)-50)*height*5
  RSI50 <- (RSI(Close,n=50)-50)*height*5
  RSI200 <- (RSI(Close,n=200)-50)*height*5
  RSI250 <- (RSI(Close,n=250)-50)*height*5

  # Create computable dataset: Close/SMA_i-1
  ratio_10<-(Close/SMA10-1)
  ratio_20<-(Close/SMA20-1)
  ratio_30<-(Close/SMA30-1)
  ratio_50<-(Close/SMA50-1)
  ratio_200<-(Close/SMA200-1)
  ratio_250<-(Close/SMA250-1)
  all_data_ratio <- merge(
    ratio_10,
    ratio_20,
    ratio_30,
    ratio_50,
    ratio_200,
    ratio_250
  )
  # Here we want to create signal for each column
  # Then we add them all together
  all_data_ratio[is.na(all_data_ratio)] <- 0 # Get rid of NAs
  sd(all_data_ratio[,1])
  sd(all_data_ratio[,2])
  sd(all_data_ratio[,3])
  sd(all_data_ratio[,4])
  sd(all_data_ratio[,5])
  sd(all_data_ratio[,6])
  coef<-c
  m<-height*mean(Close)
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] <= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] <= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] <= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] <= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] <= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] <= coef*sd(all_data_ratio[,6]),
    m, "0")

  all_data_ratio$Signal<-(
    all_data_ratio[,7]
    +all_data_ratio[,8]
    +all_data_ratio[,9]
    +all_data_ratio[,10]
    +all_data_ratio[,11]
    +all_data_ratio[,12]
  )

  all_data_signal <- merge(Close, all_data_ratio$Signal)
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  plot(Close[daily_initial_time_plot:daily_ending_time_plot,],main="Closing Price with Buy Signal and SMA + RSI",
       ylim = c(-20,(max(Close)+3)))
  par(new=TRUE)
  lines(SMA10[daily_initial_time_plot:daily_ending_time_plot,], col = 5)
  lines(SMA20[daily_initial_time_plot:daily_ending_time_plot,], col = 6)
  lines(SMA30[daily_initial_time_plot:daily_ending_time_plot,], col = 7)
  lines(SMA50[daily_initial_time_plot:daily_ending_time_plot,], col = 8)
  lines(SMA200[daily_initial_time_plot:daily_ending_time_plot,], col = 2)
  lines(SMA250[daily_initial_time_plot:daily_ending_time_plot,], col = 3)
  lines(RSI10[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI20[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI30[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI50[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI200[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI250[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(all_data_ratio$Signal[daily_initial_time_plot:daily_ending_time_plot,],
        type = "h", col='green')
} # End of function # End of function # End of function
