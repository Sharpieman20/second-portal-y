import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import time
import scipy



base = 10
bin_size = 5

df = pd.DataFrame()

for line in open('stronghold_trials.txt', 'r'):
    values = [s for s in line.split()]
    y = int(values[0])
    did_eye_spy = values[1] == 'true'
    ind = round(y/bin_size)
    # df = df.append(pd.Series([ind, y, did_eye_spy]), ignore_index=True)
    # my_dict = 
    df = df.append({'bin': ind, 'y': y, 'success': did_eye_spy, 'count': 1}, ignore_index=True)

df = df.groupby(by='bin').sum()

theo_ratio = 15

def make_error_bars_for_row(row):
    from scipy.stats import binomtest
    # print(row)
    result = binomtest(k=int(row['success'])*theo_ratio, n=int(row['count'])*theo_ratio)
    ci = result.proportion_ci(confidence_level=0.999, method='exact')
    # print(ci)
    row['upper'] = ci.high
    row['lower'] = ci.low
    return row
    
    # row['upper'] = 
    # print(row)
    # print(scipy.stats.proportion_ci(
    
    # raise

df = df.apply(make_error_bars_for_row, axis=1)

df['success'] = df['success'] / df['count']

# 

# df = df.sort_values(by='success', ascending=False)
# df['bin'] *= bin_size

print(df)
# plt.plot(df.index*5, df['success'])
# plt.plot(df.index*5, df['lower'])
# plt.plot(df.index*5, df['upper'])

ax = plt.errorbar(df.index*5, 100.0*df['success'], yerr=[100.0*(df['success']-df['lower']), 100.0*(df['upper']-df['success'])], fmt="o", ecolor="red").lines

import matplotlib.ticker as mtick

# ax.yaxis.set_major_formatter(mtick.PercentFormatter())

# for entry_type in entry_types:
#     plt.plot(df3.index, df3.values, label=entry_type)


plt.grid()

plt.title("Chance of Eye Spy by Second Portal Y")

plt.xlabel("Second Portal Y")
plt.ylabel("Eye Spy %")
plt.yticks(ticks=[0.0, 20.0, 40.0, 60.0, 80.0, 100.0], labels=["0%", "20%", "40%", "60%", "80%", "100%"])
# plt.axes().yaxis.set_major_formatter(mtick.PercentFormatter())

# plt.legend()

plt.show()
