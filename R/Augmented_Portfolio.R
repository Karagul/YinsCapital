#' @title Augmented Reality for Designated 8 Stock Ticker
#' @description Augmented Reality for Designated 8 Stock Ticker
#' @param
#' @return
#' @examples Augmented_Portfolio()
#' @export Augmented_Portfolio
#'
#' # Define function
Augmented_Portfolio <- function(
  ticker = AAPL,
  liquidaterate = 0.05,
  c.buy = -2,
  c.sell = +2,
  past.n.days = 100
) {
  # Parameters
  library(quantmod); library(dygraphs)
  liquidaterate = 0.05
  past.n.days = 100

  # Data
  temp <- YinsCapital::BS_Algo(ticker,r_day_plot=.2,end_day_plot=1,c.buy=c.buy,c.sell=c.sell,height=1,past.n.days=past.n.days,test.new.price=0)
  temp$Add <- ifelse(as.numeric(temp$Buy.Signal > 0), as.numeric(temp$Buy.Signal > 0), 0)
  temp$Sell <- ifelse(as.numeric(temp$Sell.Signal > 0), as.numeric(temp$Sell.Signal > 0), 0)
  temp$Ret <- c(temp$Ticker/quantmod::Lag(temp$Ticker)-1)
  temp$CumRet <- c(1,cumprod(c(1L+na.omit(temp$Ret))))
  stoplossrate = 2*sd(na.omit(temp$Ret))

  # Augmented Portfolio
  Holdings <- rep(0,nrow(temp))
  for (i in 2:nrow(temp)) {
    # Action
    if (Holdings[i-1] == 0) {
      if (temp$Add[i] > 0) {
        Holdings[i] <- temp$Ticker[i]
      }
    } else {
      Holdings[i] <- temp$Ticker[i]
    }

    # Stop loss
    if ((temp$Sell[i] > 0) | (temp$Ret[i] < -2*stoplossrate)) {
      #Holdings[i] <- Holdings[i-1]
      Holdings[i] <- 0
    }
  }; Holdings
  temp$Holdings <- Holdings

  # Graph
  library(DiagrammeR)
  diagram <- grViz(
    "digraph flowchart {
    # node definitions with substituted label text
    node [fontname = Helvetica, shape = rectangle]
    tab1 [label = '@@1']
    tab2 [label = '@@2']
    tab3 [label = '@@3']
    tab4 [label = '@@4']
    tab5 [label = '@@5']
    tab6 [label = '@@6']

    # edge definitions with the node IDs
    tab1 -> tab2;
    tab2 -> tab3;
    tab2 -> tab4 -> tab5
    tab4 -> tab6
    }

    [1]: 'Investigate all historical data'
    [2]: 'Make a buy decision'
    [3]: 'If stock goes below VAR: stop loss'
    [4]: 'If stock goes up 15%-30%: liquidate 50% of position'
    [5]: 'If stock goes below VAR: stop loss'
    [6]: 'If stock goes up: do nothing'
    ")

  # Output
  return(list(
    Diagram = diagram,
    Portfolio_Info = temp
  ))
}
