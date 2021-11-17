# Chapter 1 - Exploratory Data Analysis

## packages ----
%matplotlib inline

from pathlib import Path

import pandas as pd
import numpy as np
from scipy.stats import trim_mean
from statsmodels import robust

import seaborn as sns
import matplotlib.pylab as plt

import wquantiles

import os
# os.getcwd()
# os.chdir('')

## estimates of location ----

## import data
state = pd.read_csv('data/state.csv')
print(state.head(5))

state['Population'].mean()
trim_mean(state['Population'], 0.1)
state['Population'].median()
print(np.average(state['Murder.Rate'], weights=state['Population']))
print(wquantiles.median(state['Murder.Rate'], weights=state['Population']))

## estimates of variability ----
state['Population'].std() # standard deviation
state['Population'].quantile(0.75) - state['Population'].quantile(0.25) # IQR
robust.scale.mad(state['Population']) # median absolute deviation

## exploring data distribution ----
### percentiles
state['Murder.Rate'].quantile([0.05, 0.25, 0.50, 0.75, 0.95])

### boxplot
ax = (state['Population']/1_000_000).plot.box()
ax.set_ylabel('Population (millions)')

## frequency tables and histograms ----
binnedPopulation = pd.cut(state['Population'], 10)
binnedPopulation.value_counts()

### histogram
ax = (state['Population'] / 1_000_000).plot.hist(figsize = (4, 4))
ax.set_xlabel('Population (millions)')
