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

## scatterplot
# Determine telecommunications symbols
telecomSymbols = sp500_sym[sp500_sym['sector'] == 'telecommunications_services']['symbol']
telecom = sp500_px.loc[sp500_px.index >= '2012-07-01', telecomSymbols]


ax = telecom.plot.scatter(x = 'T', y = 'VZ', figsize = (4, 4), marker = '$\u25EF$')
ax.set_xlabel('ATT (T)')
ax.set_ylabel('Verizon (VZ)')
ax.axhline(0, color = 'grey', lw = 1)
ax.axvline(0, color = 'grey', lw = 1)

## multivariate Analysis
kc_tax0 = kc_tax.loc[(kc_tax.TaxAssessedValue < 750000) &
                     (kc_tax.SqFtTotLiving > 100) &
                     (kc_tax.SqFtTotLiving < 3500), :]
kc_tax0.shape

### hex binning
ax = kc_tax0.plot.hexbin(x = 'SqFtTotLiving', y = 'TaxAssessedValue',
gridsize = 30, sharex = False, figsize = (5, 4))
ax.set_xlabel('Finished Square Feet')
ax.set_ylabel('Tax-Assessed Value')

### density
fig, ax = plt.subplots(figsize=(4, 4))
sns.kdeplot(data=kc_tax0.sample(10000), x='SqFtTotLiving', y='TaxAssessedValue', ax=ax)
ax.set_xlabel('Finished Square Feet')
ax.set_ylabel('Tax Assessed Value')
