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

dfw = pd.read_csv('data/dfw_airline.csv')

sp500_px = pd.read_csv('data/sp500_data.csv.gz', index_col=0)
sp500_sym = pd.read_csv('data/sp500_sectors.csv')

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

### density plots and estimates
ax = state['Murder.Rate'].plot.hist(density = True, xlim = [0,12], bins = range(1,12))
state['Murder.Rate'].plot.density(ax = ax)
ax.set_xlabel('Murder Rate (per 100,000)')

## exploring binary and categorical Data
ax = dfw.transpose().plot.bar(figsize = (4, 4), legend = False)
ax.set_xlabel('Cause of Delay')
ax.set_ylabel('Count')

## correlation
etfs = sp500_px.loc[sp500_px.index > '2012-07-01',
sp500_sym[sp500_sym['sector'] == 'etf']['symbol']]

sns.heatmap(etfs.corr(), vmin = -1, vmax = 1,
cmap = sns.diverging_palette(20, 220, as_cmap = True))
