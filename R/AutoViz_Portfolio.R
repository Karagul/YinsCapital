#' @title Autonomous Visualization for Designated Group of Stocks
#' @description Autonomous Visualization for Designated Group of Stocks
#' @param
#' @return
#' @examples AutoViz_Portfolio()
#' @export AutoViz_Portfolio
#'
#' # Define function
AutoViz_Portfolio <- function(
  base_dollar = 100,
  tickers = c( "AAPL", "FB", "GOOGL", "WMT", "PEP", "SBUX" ),
  past_days = 300
) {
  # Library
  library(dygraphs); library(quantmod); library(ggplot2); library(lattice);
  library(latticeExtra); library(parcoords); library(tidyverse); library(DT)

  # Convert input
  tickers <- unlist(strsplit(tickers, ", "))

  # Inside a function
  getSymbols(tickers)
  closePrices <- do.call(merge, lapply(tickers, function(x) Cl(get(x))))
  dateWindow <- c(as.Date(Sys.time())-past_days, as.Date(Sys.time()))
  dgraph_base_value <- dygraph(closePrices, main = "Value (in USD)", group = "stock") %>% dyRebase(value = base_dollar) %>% dyRangeSelector(dateWindow = dateWindow)
  dgraph_base_return <- dygraph(closePrices, main = "Accumulated Return (in %)", group = "stock") %>% dyRebase(percent = TRUE) %>% dyRangeSelector(dateWindow = dateWindow)

  # Update data
  cleandata_daily <- data.frame(na.omit(closePrices))
  cleandata_weekly <- data.frame(apply(cleandata_daily, 2, to.weekly))
  cleandata_monthly <- data.frame(apply(cleandata_daily, 2, to.monthly))
  cleandata_quarterly <- data.frame(apply(cleandata_daily, 2, to.quarterly))

  # Daily
  cleandata_daily_return <- c(); cleandata_daily_return_tidy <- c()
  for (i in 2:nrow(cleandata_daily)) { cleandata_daily_return <- rbind(cleandata_daily_return, cleandata_daily[i,]/cleandata_daily[i-1,]-1) }
  for (j in 1:ncol(cleandata_daily_return)) { cleandata_daily_return_tidy <- rbind(cleandata_daily_return_tidy, cbind(cleandata_daily_return[,j], colnames(cleandata_daily_return)[j])) }
  cleandata_daily_return_tidy <- data.frame(cleandata_daily_return_tidy); colnames(cleandata_daily_return_tidy) <- c("Return","Stock")

  # Weekly
  cleandata_weekly_return <- c(); cleandata_weekly_return_tidy <- c()
  for (i in 2:nrow(cleandata_weekly)) { cleandata_weekly_return <- rbind(cleandata_weekly_return, cleandata_weekly[i,]/cleandata_weekly[i-1,]-1) }
  for (j in 1:ncol(cleandata_weekly_return)) { cleandata_weekly_return_tidy <- rbind(cleandata_weekly_return_tidy, cbind(cleandata_weekly_return[,j], colnames(cleandata_weekly_return)[j])) }
  cleandata_weekly_return_tidy <- data.frame(cleandata_weekly_return_tidy); colnames(cleandata_weekly_return_tidy) <- c("Return","Stock")

  # Monthly
  cleandata_monthly_return <- c(); cleandata_monthly_return_tidy <- c()
  for (i in 2:nrow(cleandata_monthly)) { cleandata_monthly_return <- rbind(cleandata_monthly_return, cleandata_monthly[i,]/cleandata_monthly[i-1,]-1) }
  for (j in 1:ncol(cleandata_monthly_return)) { cleandata_monthly_return_tidy <- rbind(cleandata_monthly_return_tidy, cbind(cleandata_monthly_return[,j], colnames(cleandata_monthly_return)[j])) }
  cleandata_monthly_return_tidy <- data.frame(cleandata_monthly_return_tidy); colnames(cleandata_monthly_return_tidy) <- c("Return","Stock")

  # Quarterly
  cleandata_quarterly_return <- c(); cleandata_quarterly_return_tidy <- c()
  for (i in 2:nrow(cleandata_quarterly)) { cleandata_quarterly_return <- rbind(cleandata_quarterly_return, cleandata_quarterly[i,]/cleandata_quarterly[i-1,]-1) }
  for (j in 1:ncol(cleandata_quarterly_return)) { cleandata_quarterly_return_tidy <- rbind(cleandata_quarterly_return_tidy, cbind(cleandata_quarterly_return[,j], colnames(cleandata_quarterly_return)[j])) }
  cleandata_quarterly_return_tidy <- data.frame(cleandata_quarterly_return_tidy); colnames(cleandata_quarterly_return_tidy) <- c("Return","Stock")

  # Cross-section Returns
  cross_section_return_mat <- data.frame(rbind(
    apply(cleandata_daily_return, 2, mean),
    apply(cleandata_weekly_return, 2, mean),
    apply(cleandata_monthly_return, 2, mean),
    apply(cleandata_quarterly_return, 2, mean)
  )); colnames(cross_section_return_mat) <- tickers;
  rownames(cross_section_return_mat) <- c(
    "Ave.D.Return",
    "Ave.WK.Return",
    "Ave.MON.Return",
    "Ave.QR.Return" )
  recent_cross_section_return_mat <- data.frame(rbind(
    cleandata_daily_return[nrow(cleandata_daily_return),],
    cleandata_weekly_return[nrow(cleandata_weekly_return),],
    cleandata_monthly_return[nrow(cleandata_monthly_return),],
    cleandata_quarterly_return[nrow(cleandata_quarterly_return),]
  )); colnames(recent_cross_section_return_mat) <- tickers;
  rownames(recent_cross_section_return_mat) <- c(
    "Rec.D.Return",
    "Rec.WK.Return",
    "Rec.MON.Return",
    "Rec.QR.Return" )

  ## Design Plot
  DF <- cross_section_return_mat
  #sub.data <- VADeaths[1:nrow(DF), 1:ncol(DF)]
  sub.data <- as.matrix(DF)
  colnames(sub.data) <- c(colnames(DF))
  rownames(sub.data) <- c(rownames(DF))
  #for (i in 1:5) { for (j in 1:4) { sub.data[i, j] <- DF[i, j] } }
  P1 <- cloud(
    sub.data,
    panel.3d.cloud = panel.3dbars,
    xbase = 0.4,
    ybase = 0.4,
    zlim = c(min(cross_section_return_mat), max(cross_section_return_mat)),
    scales = list(arrows = FALSE, just = "right"),
    xlab = list(label = "Metrics", cex = 1.1),
    ylab = list(label = "Stocks", cex = 1.1),
    zlab = list(
      label = "Returns",
      cex = 1.1,
      rot = 90
    ),
    cex.axis = 0.7,
    lwd = 0.5,
    main = list(label = paste0("Average Cross-section Performance"), cex = 1.5),
    col.facet = level.colors(
      sub.data,
      at = do.breaks(range(sub.data), 20),
      col.regions = cm.colors,
      colors = TRUE ),
    colorkey = list(col = cm.colors, at = do.breaks(range(sub.data), 20)) )

  ## Design Plot
  DF <- recent_cross_section_return_mat
  #sub.data <- VADeaths[1:nrow(DF), 1:ncol(DF)]
  sub.data <- as.matrix(DF)
  colnames(sub.data) <- c(colnames(DF))
  rownames(sub.data) <- c(rownames(DF))
  #for (i in 1:5) { for (j in 1:4) { sub.data[i, j] <- DF[i, j] } }
  P2 <- cloud(
    sub.data,
    panel.3d.cloud = panel.3dbars,
    xbase = 0.4,
    ybase = 0.4,
    zlim = c(min(recent_cross_section_return_mat), max(recent_cross_section_return_mat)),
    scales = list(arrows = FALSE, just = "right"),
    xlab = list(label = "Metrics", cex = 1.1),
    ylab = list(label = "Stocks", cex = 1.1),
    zlab = list(
      label = "Returns",
      cex = 1.1,
      rot = 90
    ),
    cex.axis = 0.7,
    lwd = 0.5,
    main = list(label = paste0("Recent Cross-section Performance"), cex = 1.5),
    col.facet = level.colors(
      sub.data,
      at = do.breaks(range(sub.data), 20),
      col.regions = cm.colors,
      colors = TRUE ),
    colorkey = list(col = cm.colors, at = do.breaks(range(sub.data), 20)) )

  ## Parcoords
  P3 <- parcoords(
    data.frame(t(cross_section_return_mat)),
    rownames = T,
    brushMode = "1d",
    color = list(
      colorScale = htmlwidgets::JS('d3.scale.category10()')))
  P4 <- parcoords(
    data.frame(t(recent_cross_section_return_mat)),
    rownames = T,
    brushMode = "1d",
    color = list(
      colorScale = htmlwidgets::JS('d3.scale.category10()')))

  ## Radial column bar chart
  tidy_cross_section_return_mat <- cbind(
    Metric = c(unlist(matrix(c(paste0(tickers, ".", rep(rownames(cross_section_return_mat),ncol(cross_section_return_mat)))), 4, byrow = T))),
    Return = unlist(cross_section_return_mat) )

  # Create dataset
  data = data.frame(
    id = seq(1, nrow(tidy_cross_section_return_mat)),
    individual = paste0("Mr.", 1:nrow(tidy_cross_section_return_mat)),
    value = seq(1, nrow(tidy_cross_section_return_mat))
  )
  data$individual <- tidy_cross_section_return_mat[, 1]
  data$value <- c(as.numeric(as.character(unlist( tidy_cross_section_return_mat[, 2] ))))

  # ----- This section prepare a dataframe for labels ---- #
  # Get the name and the y position of each label
  label_data = data

  # calculate the ANGLE of the labels
  number_of_bar = nrow(label_data)
  angle = 90 - 360 * (label_data$id - 0.5) / number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)

  # calculate the alignment of labels: right or left
  # If I am on the left part of the plot, my labels have currently an angle < -90
  label_data$hjust <- ifelse(angle < -90, 1, 0)

  # flip angle BY to make them readable
  label_data$angle <- ifelse(angle < -90, angle + 180, angle)
  # ----- ------------------------------------------- ---- #


  # Start the plot
  radial_col_P1 = ggplot(data, aes(x = as.factor(id), y = value)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar

    # This add the bars with a blue color
    geom_bar(stat = "identity", fill = alpha("skyblue", 1)) +

    # Limits of the plot = very important. The negative value controls the size of the inner circle, the positive one is useful to add size over each bar
    ylim(-0.1, 0.1) +

    # Custom the theme: no axis title and no cartesian grid
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1, 4), "cm")
      # Adjust the margin to make in sort labels are not truncated!
    ) +

    # This makes the coordinate polar instead of cartesian.
    coord_polar(start = 0) +

    # Add the labels, using the label_data dataframe that we have created before
    geom_text(
      data = label_data,
      aes(
        x = id,
        y = value,
        label = individual,
        hjust = hjust
      ),
      color = "black",
      fontface = "bold",
      alpha = 1,
      size = 4,
      angle = label_data$angle,
      inherit.aes = FALSE
    )

  ## Radial column bar chart
  tidy_recent_cross_section_return_mat <- cbind(
    Metric = c(unlist(matrix(c(paste0(tickers, ".", rep(rownames(recent_cross_section_return_mat),ncol(recent_cross_section_return_mat)))), 4, byrow = T))),
    Return = unlist(recent_cross_section_return_mat) )

  # Create dataset
  data = data.frame(
    id = seq(1, nrow(tidy_recent_cross_section_return_mat)),
    individual = paste0("Mr.", 1:nrow(tidy_recent_cross_section_return_mat)),
    value = seq(1, nrow(tidy_recent_cross_section_return_mat))
  )
  data$individual <- tidy_recent_cross_section_return_mat[, 1]
  data$value <- c(as.numeric(as.character(unlist( tidy_recent_cross_section_return_mat[, 2] ))))

  # ----- This section prepare a dataframe for labels ---- #
  # Get the name and the y position of each label
  label_data = data

  # calculate the ANGLE of the labels
  number_of_bar = nrow(label_data)
  angle = 90 - 360 * (label_data$id - 0.5) / number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)

  # calculate the alignment of labels: right or left
  # If I am on the left part of the plot, my labels have currently an angle < -90
  label_data$hjust <- ifelse(angle < -90, 1, 0)

  # flip angle BY to make them readable
  label_data$angle <- ifelse(angle < -90, angle + 180, angle)
  # ----- ------------------------------------------- ---- #


  # Start the plot
  radial_col_P2 = ggplot(data, aes(x = as.factor(id), y = value)) +       # Note that id is a factor. If x is numeric, there is some space between the first bar

    # This add the bars with a blue color
    geom_bar(stat = "identity", fill = alpha("skyblue", 1)) +

    # Limits of the plot = very important. The negative value controls the size of the inner circle, the positive one is useful to add size over each bar
    ylim(-0.1, 0.1) +

    # Custom the theme: no axis title and no cartesian grid
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank(),
      plot.margin = unit(rep(-1, 4), "cm")
      # Adjust the margin to make in sort labels are not truncated!
    ) +

    # This makes the coordinate polar instead of cartesian.
    coord_polar(start = 0) +

    # Add the labels, using the label_data dataframe that we have created before
    geom_text(
      data = label_data,
      aes(
        x = id,
        y = value,
        label = individual,
        hjust = hjust
      ),
      color = "black",
      fontface = "bold",
      alpha = 1,
      size = 4,
      angle = label_data$angle,
      inherit.aes = FALSE
    )
  # Return
  return(list(
    cross_section_return_mat = DT::datatable(data.frame(t(round(cross_section_return_mat,3)))) %>% formatStyle( colnames(data.frame(t(round(cross_section_return_mat,3)))), color = styleInterval(c(0), c('red','green'))),
    recent_cross_section_return_mat = DT::datatable(data.frame(t(round(recent_cross_section_return_mat,3)))) %>% formatStyle( colnames(data.frame(t(round(recent_cross_section_return_mat,3)))), color = styleInterval(c(-0.01,0.01), c('red', "skyblue", 'green'))),
    dgraph_base_value = dgraph_base_value,
    dgraph_base_return = dgraph_base_return,
    Ave_Ret = P1,
    Recent_ret = P2,
    ParcoordAverage = P3,
    ParcoordRecent = P4,
    radial_col_P1 = radial_col_P1,
    radial_col_P2 = radial_col_P1
  ))
} # End of function
