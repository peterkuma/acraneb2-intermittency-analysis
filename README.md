ACRANEB2 Intermittency Analysis
===============================

This repository contains analysis of intermittency implementation
in the ACRANEB2 radiation scheme in the NWP model ALADIN.

See [peterkuma/masters-thesis](https://github.com/peterkuma/masters-thesis/)
for details.

Results
-------

Datasets with results need to be downloaded separately from an external
repository:

* [shortwave-intermittency-base.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZWFZGdG5TWDE5UVU/view?usp=sharing)
* [shortwave-intermittency-6min.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZZ2phb25yT3BkZG8/view?usp=sharing)
* [shortwave-intermittency-15min.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZQmJmMjB2RGdEVWM/view?usp=sharing)
* [shortwave-intermittency-30min.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZSFR6NGhDZ081MTQ/view?usp=sharing)
* [shortwave-intermittency-1h.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZeHpacjdsbnV6TDQ/view?usp=sharing)
* [shortwave-intermittency-90min.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZTHhMMnJ3XzFGTFE/view?usp=sharing)
* [shortwave-intermittency-2h.nc.bz2](https://drive.google.com/file/d/0B0GuL0rQokUZaHJhZXd1STJnVXc/view?usp=sharing)

In order to use the results with the supplied scripts, download the
compressed NetCDF files above to the directory `results` and unpack.

Experiments
-----------

The experiments are based on ALARO cycle 38 (38t1tr_op3) with a time step
of 3 min. Experiment namelists are in the directory `experiments`.

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

### Shortwave Intermittency 6 min

Namelist: `shortwave-intermittency-6min.nml`

Configuration:

    NSORAYFR=2
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 6-min period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 6 min.

### Shortwave Intermittency 15 min

Namelist: `shortwave-intermittency-15min.nml`

Configuration:

    NSORAYFR=5
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 15-min period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 15 min.

### Shortwave Intermittency 30 min

Namelist: `shortwave-intermittency-30min.nml`

Configuration:

    NSORAYFR=10
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 30-min period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 30 min.

### Shortwave Intermittency 1 h

Namelist: `shortwave-intermittency-1h.nml`

Configuration:

    NSORAYFR=-1
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 1-h period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 1 h.

### Shortwave Intermittency 90 min

Namelist: `shortwave-intermittency-90min.nml`

Configuration:

    NSORAYFR=30
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 90-min period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 90 min.


### Shortwave Intermittency 2 h

Namelist: `shortwave-intermittency-2h.nml`

Configuration:

    NSORAYFR=-2
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 2-h period.

* Based on *Shortwave Intermittency Base*.
* Shortwave gaseous transmissivities computed once per 2 h.

### Intermittency Base

Namelist: `intermittency-base.nml`

Configuration:

    NSORAYFR=1
    NTHRAYFR=1
    NRAUTOEV=1

Base configuration of ACRANEB2 with longwave and shortwave intermittency
disabled.

### Intermittency 1 h

Namelist: `intermittency-1h.nml`

Configuration:

    NSORAYFR=-1
    NTHRAYFR=-1
    NRAUTOEV=3

ACRANEB2 with longwave and shortwave intermittency enabled with 1-h period.

* Based on *Intermittency Base*.
* Longwave and shortwave gaseous transmissivities computed once per 1 h.
* Longwave ‘bracketing’ weights computed once per 3 h.

### Intermittency FMR/RRTM Base

Namelist: `intermittency-fmr-base.nml`

Configuration:

    LRAY=.F.
    LRAYFM=.T.
    &NAERAD
      LHGHG=.F.
      LRRTM=.T.
      LSRTM=.F.
      NICEOPT=3
      NLIQOPT=2
      NOVLP=6
      NRADFR=1
      NSW=6
      RLWINHF=1.
      RSWINHF=1.
      RCCO2=389.0E-06
      RCN2O=0.323E-06
      RCCH4=1.808E-06
      RCCFC11=0.
      RCCFC12=0.

Base configuration of FMR/RRTM with intermittency disabled.

### Intermittency FMR/RRTM 1 h

Namelist: `intermittency-fmr-1h.nml`

Configuration:

    NRADFR=-1

FMR/RRTM with full intermittency enabled with 1-h period.

* Based on *Intermittency FMR/RRTM Base*.
* Fluxes computed once per 1 h.

Performance
-----------

Performance information from model runs is stored in
`performance/<name>.log.<i>`, where `<i>` is the number of a (repeated) run.
These runs were made with an unmodified model binary, i.e. without data dumping.
Files `performance/<name>.steps.<i>` contain times of individual model steps.

Prerequisites
-------------

* [R](http://www.r-project.org/)
* [rjson](http://cran.r-project.org/web/packages/rjson/index.html) R package

Usage
-----

    cd shortwave-intermittency

    # Plot shortwave heating rate.
    ../heating_rate.R shortwave_heating_rate.json

    # Plot shortwave heating rate time series.
    ../heating_rate_timeseries.R shortwave_heating_rate_timeseries.json

    # Plot shortwave heating rate error.
    ../heating_rate_error.R shortwave_heating_rate_error.json

    # Plot shortwave heating rate error time series.
    ../heating_rate_error_timeseries.R shortwave_heating_rate_error_timeseries.json

    # Plot shortwave heating rate error distribution.
    ../heating_rate_error_distribution.R shortwave_heating_rate_error_distribution.json

    # Plot longwave heating rate.
    ../heating_rate.R longwave_heating_rate.json

    # Plot longwave heating rate time series.
    ../heating_rate_timeseries.R longwave_heating_rate_timeseries.json

    # Plot longwave heating rate error.
    ../heating_rate_error.R longwave_heating_rate_error.json

    # Plot longwave heating rate error time series.
    ../heating_rate_error_timeseries.R longwave_heating_rate_error_timeseries.json

    # Plot longwave heating rate error distribution.
    ../heating_rate_error_distribution.R longwave_heating_rate_error_distribution.json

    # Plot performance statistics.
    ../performance_plot.R performance_plot.json

    # Plot performance vs. accuracy plot.
    ../performance_accuracy_plot.R performance_accuracy_plot.json

    cd acraneb2-vs-fmr

    # Plot shortwave heating rate error.
    ../heating_rate_error.R shortwave_heating_rate_error.json

    # Plot shortwave heating rate error time series.
    ../heating_rate_error_timeseries.R shortwave_heating_rate_error_timeseries.json

    # Plot longwave heating rate.
    ../heating_rate.R longwave_heating_rate.json

    # Plot longwave heating rate time series.
    ../heating_rate_timeseries.R longwave_heating_rate_timeseries.json
