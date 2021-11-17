# Chapter 1 - Exploratory Data Analysis

## libraries ----
library(tidyverse)
library(vioplot)
library(corrplot)
library(gmodels)
library(matrixStats)

## import & view data ----
state <- read.csv('data/state.csv')
dfw <- read.csv('data/dfw_airline.csv')
sp500_px <- read.csv('data/sp500_data.csv.gz')
sp500_sym <- read.csv('data/sp500_sectors.csv')


## analysis ----

### location estimates of population and murder rates by state
mean(state[['Population']]) # average population
mean(state[['Population']], trim = 0.1) # trimmed average 
median(state[['Population']]) # median population

weighted.mean(state[['Murder.Rate']], w = state[['Population']])
weightedMedian(state[['Murder.Rate']], w = state[['Population']]) # matrixStats() function

### variability estimates of State population
sd(state[['Population']]) # standard deviation
IQR(state[['Population']]) # interquartile range
mad(state[['Population']]) # median absolute deviation

###  percentiles
quantile(state[['Murder.Rate']], p = c(0.05, 0.25, 0.50, 0.75, 0.95))

### boxplot
boxplot(state[['Population']]/1000000, ylab = 'Population (millions)')

### frequency tables and histograms
breaks <- seq(from = min(state[['Population']]),
              to = max(state[['Population']]), length = 11)
pop_freq <- cut(state[['Population']], breaks = breaks,
                right = TRUE, include.lowest = TRUE)
table(pop_freq)

### histogram
hist(state[['Population']], breaks = breaks)

### density plots and estimates
hist(state[['Murder.Rate']], freq = FALSE)
lines(density(state[['Murder.Rate']]), lwd = 3, col = 'blue')

### exploring binary and categorical data
barplot(as.matrix(dfw) / 6, cex.axis = 0.8, cex.names = 0.7,
        xlab = 'Cause of Delay', ylab = 'Count')

### correlation
etfs <- sp500_px[row.names(sp500_px) > '2012-07-01',
                 sp500_sym[sp500_sym$sector == 'etf', 'symbol']]

corrplot(cor(etfs), method = 'ellipse')


