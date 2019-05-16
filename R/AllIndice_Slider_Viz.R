#' @title All Indice Slider Screener for Market
#' @description All Indice Slider Screener for Market
#' @param
#' @return
#' @examples AllIndice_Slider_Viz()
#' @export AllIndice_Slider_Viz
#'
#' # Define function
AllIndice_Slider_Viz <- function() {
  data <- getSymbols(c(
    "SPY", "DIA", "QQQ", "IWM", "GLD", "XLB", "XLE", "XLK", "XLU", "XLI", "XLP", "XLY",
    "EWC", "EWG", "EWJ", "EWZ", "FEZ", "FXI", "GDX", "GLD", "IBB", "INDA", "IVV", "SPXL",
    "TLT", "TQQQ", "XBI", "ITA", "IYZ", "HACK", "KRE", "MOO", "SOCL", "XHB", "IAK"
  )); data
  data.list <- list(
    SPY, DIA, QQQ, IWM, GLD, XLB, XLE, XLK, XLU, XLI, XLP, XLY,
    EWC, EWG, EWJ, EWZ, FEZ, FXI, GDX, GLD, IBB, INDA, IVV, SPXL, TLT, TQQQ,
    XBI, ITA, IYZ, HACK, KRE, MOO, SOCL, XHB, IAK
  )

  # Create data set:
  all <- matrix(NA,nrow=length(data),ncol=12)
  rownames(all) <- data

  # Update Price (Current, daily basis):
  for (i in c(1:nrow(all))){
    all[i,2] <- data.frame(data.list[i])[nrow(data.frame(data.list[i])),4]
  }

  # Update Momentum:
  for (i in c(1:nrow(all))){
    all[i,5] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-5),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,6] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,7] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25*3),4])-1
  }
  for (i in c(1:nrow(all))){
    all[i,8] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-252),4])-1
  }

  # Clearn up
  all <- all[,-c(1,3,4,9,10,11,12)]

  # Update column names:
  colnames(all) <- c("Last Price",
                     "Pre 5-Days",
                     "Pre 30-Days",
                     "Pre Quarter",
                     "Pre Year")

  # Quick vertical bar plot:
  counts <- all[,2]
  counts.std <- sd(all[,2])
  #barplot(counts, main="5-Day Return Bar Chart", #horiz=TRUE,
  #        names.arg=rownames(all), cex.names=0.35,
  #        col=ifelse(counts>counts.std,"green",ifelse(counts<(-1)*counts.std,"red","pink")))

  # Sortable table:
  library('DT')
  # Present table:
  d = data.frame(
    round(all[,c(2,3,4,5)],4),
    #round(all[,c(2,3,4,5)],4),
    stringsAsFactors = FALSE)
  #d <- data.frame(cbind(
  #  rownames(d),
  #  d
  #))
  #colnames(d)[1] <- "Name"

  Par <- parcoords(d,
                   #All.Indice.3D(),
                   rownames = T,
                   brushMode = "1d"#,
                   #reorderable = T,
                   #queue = F,
                   #color = list(colorBy = rownames(d.parcoord))
                   )

  # Output
  return(Par)
} # End of function
