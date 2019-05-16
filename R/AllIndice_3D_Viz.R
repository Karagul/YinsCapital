#' @title All Indice 3D Visualization for Designated 8 Stock Ticker
#' @description All Indice 3D Visualization for Designated 8 Stock Ticker
#' @param
#' @return
#' @examples AllIndice_3D_Viz()
#' @export AllIndice_3D_Viz
#'
#' # Define function
AllIndice_3D_Viz <- function(
  a,b,c,d, e,f,g,h
) {
  # Data
  data.list <- list(
    a,b,c,d, e,f,g,h
  )
  all <- matrix(NA, nrow = 8, ncol = 4)

  # Update Momentum:
  for (i in c(1:nrow(all))){
    all[i,1] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-5),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,2] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,3] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25*3),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,4] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-252),4])-1
  }

  # Update column names:
  colnames(all) <- c("Pre 5-Days",
                     "Pre 30-Days",
                     "Pre Quarter",
                     "Pre Year")
  df <- data.frame(all)
  df
}
