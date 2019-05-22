# YinsCapital

[![YinsCapital](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://yinscapital.com/research/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

This is official quantitative and statistical software package by Yin's Capital. Artificial Intelligence (AI) is logical extension of human will. At Yin's Capital, we investigate marketable securities through not only the lens of human experience but also by machine power to discover and fully extract the intrinsic value of securities.  

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/main.gif">
</p>
<p align="center">
	<img src="https://img.shields.io/badge/stars-30+-blue.svg"/>
	<img src="https://img.shields.io/badge/license-CC0-blue.svg"/>
</p>

- Copyright @ Official quantitative and statistical software published by Yin's Capital. 
- Contact: Yiqiao Yin
- Email: Yiqiao.Yin@YinsCapital.com

# Install

```
# Note: you must have these packages:
# quantmod, plotly, shiny, shinysky, shinythemes, corrplot, forecast, xts, dygraphs, ggplot2, reshape2, gtools, reshape2, gtools, DT, rnn, plot3D, plotly, parcoords, quandprog, pROC, matrixcalc, XML, beepr, data.table, scales, fPortfolio, finreportr, knitrr, treemap, tidyquant, gridExtra
# Please install them if you do not have them. 

# Install Package: Yin's Capital (i.e. YinsCapital)
devtools::install_github("yiqiao-yin/YinsCapital")
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

####################### AUTONOMOUS VISUALIZATION #######################
AutoViz <- YinsCapital::AutoViz_Portfolio(
  base_dollar = 100,
  tickers = c("SPY","QQQ","AAPL","FB","AMZN"),
  past_days = 300)
```


| Command | Description |
| --- | --- |
| <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-1.PNG"> | List all new or modified files |
| <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-2.PNG"> | Show file differences that haven't been staged |

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-1.PNG">
</p>

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-2.PNG">
</p>

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-3.PNG">
</p>

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-4.PNG">
</p>


```
####################### VISUALIZATION #######################

YinsCapital::DyPlot_Initial_with_100()
YinsCapital::DyPlot_Initial_with_Return()
temp = YinsCapital::QQ_Comparison(); temp$Grid

####################### BASIC FUNCTIONS #######################

getSymbols("AAPL"); ticker = AAPL
YinsCapital::Basic_Plot(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::Basic_Plot_Weekly(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::Basic_Plot_Monthly(ticker,r_day_plot=0.2,end_day_plot=1)
YinsCapital::BS_Algo(ticker,r_day_plot=0.2,end_day_plot=1,c.buy=-2,c.sell=+2,height=1,past.n.days=10,test.new.price=0)
YinsCapital::BS_Algo_Chart(ticker,r_day_plot=0.2,end_day_plot=1,c.buy=-2,c.sell=+2,height=1,past.n.days=10,test.new.price=0)

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

```

<p align="center">
  <img width="300" src="https://github.com/yiqiao-yin/YinsCapital/blob/master/figs/AV-fig-5.PNG">
</p>


```
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
