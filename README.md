# Official Quantitative and Statistical Software Package by Yin's Capital

- Copyright @ Official quantitative and statistical software published by Yin's Capital. 
- Contact: Yiqiao Yin
- Email: Yiqiao.Yin@YinsCapital.com

# Install

```
ddf
```

# Usage

There are the following categories:

```
########################## START SCRIPT ###########################

# ACKNOWLEDGEMENT:
# In this script, let us
# (1) download data for a designated stock, and
# (2) run Yin's packages, i.e. YinsCapital
# COPYRIGHT @ Yiqiao Yin

# README:
# Open a new clean RStudio.
# Open a new R script by pressing ctrl + shift + n
# For easy navigation, please press ctrl + shift + o which will open the menu bar.
# Feel free to copy this script to yours and you can the codes for fast execution.

####################### INITIATE ALL LIBRARIES #######################

# INSTALL LIBRARY
library('quantmod')
library('plotly')
library('shiny')
library('shinysky')
library('shinythemes')
library('corrplot')
library('forecast')
library('xts')
library('dygraphs')
library('ggplot2')
library('reshape2')
library('gtools')
library('DT')
library('rnn')
library("plot3D")
library("plotly")
library("parcoords")
library("quadprog")
library("pROC")
library("matrixcalc")
library("XML")
library("beepr")
library('data.table')
library('scales')
library('ggplot2')
library('fPortfolio')
library('finreportr')
library('knitr')
library('treemap')
library('tidyquant')
library('gridExtra')

####################### BASIC FUNCTIONS #######################

getSymbols("AAPL"); ticker = AAPL
YinsCapital::Basic_Plot(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::Basic_Plot_Weekly(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::Basic_Plot_Monthly(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::BS_Algo(ticker,r_day_plot=0.2,end_day_plot=1,c.buy=-2,c.sell=+2,
height=1,past.n.days=10,test.new.price=0)
YinsCapital::BS_Algo_Chart(ticker,r_day_plot=0.2,end_day_plot=1,c.buy=-2,c.sell=+2,
height=1,past.n.days=10,test.new.price=0)

####################### WATCH LSIT #######################

YinsCapital::QQQ_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::XLF_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::XLI_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::XLP_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::XLU_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::XLV_Watch_List(buy.height = -1.96, past.days = 3)
YinsCapital::SemiConductor_Watch_List(buy.height = -1.96, past.days = 3)

####################### TIME SERIES FORECAST #######################

YinsCapital::ARMA_Fit_D(ticker, 10); dygraphs::dygraph(YinsCapital::ARMA_Fit_D(ticker, 10))
YinsCapital::ARMA_Fit_W(ticker, 10)
YinsCapital::ARMA_Fit_M(ticker, 10)
YinsCapital::ARMA_Fit_A(ticker, 10)

####################### NATURAL LANGUAGE PROCESSING AND RNN #######################

YinsCapital::RNN_Daily(ticker)

####################### FUNDAMENTALS #######################

YinsCapital::Fin_Report_IS_Plot(
  "AAPL",
  whichyear = 2017)

####################### FINISHING MESSAGE #######################

# This code creates a text message
# and saved it on desktop
# and will upload to RSTUDIO and
# pronouce it.
YinsCapital::job_finished_warning(
  path = "C:/Users/eagle/Desktop/",
  speed = 2,
  content = c(
    "Mr. Yin, your program is ready.",
    "Sir, your code is finished.",
    "Running job is done, sir.",
    "Mr. Yin, job has just finished running."),
  choose_or_random = TRUE )

######################### END SCRIPT #############################
```
