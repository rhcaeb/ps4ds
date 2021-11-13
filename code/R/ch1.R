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
