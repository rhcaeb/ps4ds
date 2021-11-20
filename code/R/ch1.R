# Chapter 1 - Exploratory Data Analysis

## libraries ----
library(tidyverse)
library(vioplot)
library(corrplot)
library(gmodels)
library(matrixStats)
library(hexbin)

## import & view data ----
state <- read.csv('data/state.csv')
dfw <- read.csv('data/dfw_airline.csv')
sp500_px <- read.csv('data/sp500_data.csv.gz')
sp500_sym <- read.csv('data/sp500_sectors.csv')
kc_tax <- read.csv('data/kc_tax.csv.gz')


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

### scatterplot
telecom <- sp500_px[, sp500_sym[sp500_sym$sector == 'telecommunications_services', 'symbol']]
telecom <- telecom[row.names(telecom) > '2012-07-01',]

plot(telecom$T, telecom$VZ, xlab = 'ATT (T)', ylab = 'Verizon (VZ)')

## multivariate analysis: exploring > 2 variables
### hexagonal binning / contours (numeric vs categorical)
kc_tax0 <- subset(kc_tax, TaxAssessedValue < 750000 &
                    SqFtTotLiving > 100 & 
                    SqFtTotLiving < 3500)
nrow(kc_tax0)


ggplot(kc_tax0, (aes(x = SqFtTotLiving, y = TaxAssessedValue))) +
  stat_binhex(color = 'white') +
  theme_bw() +
  scale_fill_gradient(low = 'white', high = 'black') +
  labs(x = 'Finished Square Ft', y = 'Tax-Assessed Value')

ggplot(kc_tax0, aes(SqFtTotLiving, TaxAssessedValue)) +
  theme_bw() +
  geom_point(alpha = 0.1) +
  geom_density2d(color = 'white') +
  labs(x = 'Finished Sq Ft', y = 'Tax-Assessed Value')

## two categorical values
library(descr)

### load data
lc_loans <- read.csv('data/lc_loans.csv')

### contigency table
x_tab <- CrossTable(lc_loans$grade, lc_loans$status,
                    prop.c = FALSE, prop.chisq = FALSE, prop.t = FALSE)

## categorical and numeric data
airline_stats <- read.csv('data/airline_stats.csv')

## compare how % of delays varies across airlines
boxplot(pct_carrier_delay ~ airline, data = airline_stats,
        ylim = c(0, 50))

ggplot(data = airline_stats, aes(airline, pct_carrier_delay)) +
  ylim(0, 50) +
  geom_violin() +
  labs(x = '', y = 'Daily % of Delayed Flights') +
  theme_bw()

## exploring two or more variables

### king county tax eg
kc_tax0 <- subset(kc_tax, TaxAssessedValue < 750000 &
                    SqFtTotLiving > 100 & 
                    SqFtTotLiving < 3500)

ggplot(subset(kc_tax0, ZipCode %in% c(98188, 98105, 98108, 98126)),
       aes(x = SqFtTotLiving, y = TaxAssessedValue)) +
  stat_binhex(color = 'white') +
  theme_bw() +
  scale_fill_gradient(low = 'white', high = 'blue') +
  labs(x = 'Finished Sq Ft', y = 'Tax Assessed Value') +
  facet_wrap('ZipCode')

