# Chapter 1 - Exploratory Data Analysis

## libraries ----
library(tidyverse)
library(vioplot)
library(corrplot)
library(gmodels)
library(matrixStats)

## import & view data ----
state <- read.csv('data/state.csv')
str(state)

## analysis ----

### e.g. location estimates of population and murder rates by state
mean(state[['Population']]) # average population
mean(state[['Population']], trim = 0.1) # trimmed average 
median(state[['Population']]) # median population

weighted.mean(state[['Murder.Rate']], w = state[['Population']])
weightedMedian(state[['Murder.Rate']], w = state[['Population']]) # matrixStats() function

### e.g. variability estimates of State population
sd(state[['Population']]) # standard deviation
IQR(state[['Population']]) # interquartile range
mad(state[['Population']]) # median absolute deviation

### e.g. percentiles
quantile(state[['Murder.Rate']], p = c(0.05, 0.25, 0.50, 0.75, 0.95))

### e.g. boxplot
boxplot(state[['Population']]/1000000, ylab = 'Population (millions)')

### frequency tables and histograms