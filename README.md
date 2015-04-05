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

    ./download-results.sh

Experiments
-----------

The experiments are based on ALARO cycle 38 (38t1tr_op3) with a time step
of 3 min.

### Shortwave intermittency base

Namelist: `shortwave-intermittency-base.nml`

Configuration:

    NSORAYFR=1
    NTHRAYFR=-1
    NRAUTOEV=3

Base configuration for shortwave intermittency.

* Shortwave gaseous transmissivities computed once per 1 h.
* Longwave gaseous transmissivities computed once per 1 h.
* Calibration of longwave NER weights once per 3 h.

### Shortwave intermittency 1 h

Namelist: `shortwave-intermittency-1h.nml`

Configuration:

    NSORAYFR=-1
    NTHRAYFR=-1
    NRAUTOEV=3

Shortwave intermittency enabled with 1 h intermittency.

* Based on Shortwave intermittency base.
* Shortwave transmissivities computed every 1 h.
