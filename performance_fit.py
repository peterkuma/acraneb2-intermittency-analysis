#!/usr/bin/env python

import numpy as np
import pymc as pm
import json


class JSONEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray) and obj.ndim == 1:
            return obj.tolist()
        return json.JSONEncoder.default(self, obj)


def fit_performance(runs):
    n = len(runs)
    sd0 = pm.Uniform('sd0', 0, 0.20)

    time = np.empty(n, dtype=np.object)
    mean = np.empty(n, dtype=np.object)
    sd = np.empty(n, dtype=np.object)
    perf = np.empty(n, dtype=np.object)
    for i in range(n):
        mean[i] = pm.Uniform('mean_%d' % i, 0, 1e8)
        sd[i] = sd0*mean[i]
        time[i] = pm.Normal('time_%d' % i, mean[i], 1/sd[i]**2, observed=True, value=runs[i])
        perf[i] = pm.Lambda('perf_%d' % i, lambda mean_0=mean[0], mean_i=mean[i]: mean_i/mean_0)
    
    model = pm.Model([time[0], time[1], time[2], sd0, perf[0], perf[1], perf[2]])
    mcmc  = pm.MCMC(model)
    mcmc.sample(60000, 40000, progress_bar=False)
    stats = mcmc.stats()
    return {
        'sd0': stats['sd0'],
        'mean_0': stats['mean_0'],
        'mean_1': stats['mean_1'],
        'mean_2': stats['mean_2'],
        'perf_0': stats['perf_0'],
        'perf_1': stats['perf_1'],
        'perf_2': stats['perf_2'],
    }


if __name__ == '__main__':
    # ./performance_fit.py <data> <base> <run>...

    data = {
        "shortwave-intermittency-base": [
            16411.726845,
            15639.958041
        ],
        "shortwave-intermittency-1h": [
            14711.460142,
            14814.319562
        ],
        "shortwave-intermittency-30min": [
            14879.164945,
            14689.764521
        ]
    }

    base = 'shortwave-intermittency-base'

    runs = [
        'shortwave-intermittency-30min',
        'shortwave-intermittency-1h',
    ]

    fit = fit_performance([data[base]] + [data[run] for run in runs])
    print json.dumps(fit, indent=4, cls=JSONEncoder)
