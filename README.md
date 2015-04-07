ACRANEB2 Intermittency Analysis
===============================

This repository contains analysis of intermittency implementation
in the ACRANEB2 radiation scheme in the NWP model ALADIN/ALARO.

See [peterkuma/masters-thesis](https://github.com/peterkuma/masters-thesis/)
for details.

Results
-------

Datasets with results need to be downloaded separately from an external
repository with:

    ./download_results.sh

Experiments
-----------

The experiments are based on ALARO cycle 38 (38t1tr_op3) with a time step
of 3 min.

### Shortwave Intermittency Base

Namelist: `shortwave-intermittency-base.nml`

Configuration:

    NSORAYFR=1
    NTHRAYFR=-1
    NRAUTOEV=3

Base configuration for shortwave intermittency evaluation.

* Shortwave gaseous transmissivities computed at every time step.
* Longwave gaseous transmissivities computed once per 1 h.
* Calibration of longwave NER weights computed once per 3 h.

### Shortwave Intermittency 1 h

Namelist: `shortwave-intermittency-1h.nml`

Configuration:

    NSORAYFR=-1
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 1 h intermittency.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 1 h.

Usage
-----

    # Plot shortwave heating rate error.
    ./shortwave_heating_rate_error.R shortwave_heating_rate_error.pdf results/shortwave-intermittency-1h.nc results/shortwave-intermittency-base.nc

    # Plot shortwave heating rate time series.
    ./shortwave_heating_rate_timeseries.R shortwave_heating_rate_timeseries.pdf results/shortwave-intermittency-1h.nc 2009-06-29

    # Plot shortwave heating rate error time series.
    ./shortwave_heating_rate_error_timeseries.R shortwave_heating_rate_error_timeseries.pdf results/shortwave-intermittency-1h.nc results/shortwave-intermittency-base.nc 2009-06-29
