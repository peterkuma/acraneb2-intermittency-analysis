#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 7) {
    cat(sprintf('Usage: heating_rate_error_timeseries.R <plot> <product> <base> <name> <ylab> <ylim> <start-time>\n'))
    quit(status=1)
}

plot.filename <- args[1]
product.filename <- args[2]
base.filename <- args[3]
name <- args[4]
ylab <- args[5]
ylim <- as.numeric(strsplit(args[6], ',')[[1]])
start.time <- as.POSIXct(args[7], tz='UTC')

source('lib/common.R')
source('lib/plot_time_series.R')

pressure.index <- function(p, pressure) {
    which.min(abs(p$mean_pressure - pressure))
}

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    p$start_time <- start.time
    p$time_utc <- p$start_time + p$time

    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60
    p$heating_rate_solar_850 <- p$heating_rate_solar[pressure.index(p, 850e2),,]

    p$flux_thermal_diff <- apply(p$flux_thermal, c(2,3), diff)
    p$heating_rate_thermal <- -g*p$flux_thermal_diff/p$heat_capacity/p$pressure_thickness*24*60*60
    p$heating_rate_thermal_850 <- p$heating_rate_thermal[pressure.index(p, 850e2),,]

    p
}

only <- c(
    'time',
    'pressure_thickness',
    'flux_solar',
    'flux_thermal',
    'heat_capacity'
)

p <- level(read.nc(product.filename, only=only))
p.base <- level(read.nc(base.filename, only=only))

p$heating_rate_solar_error_850 <- p$heating_rate_solar_850 - p.base$heating_rate_solar_850
p$heating_rate_thermal_error_850 <- p$heating_rate_thermal_850 - p.base$heating_rate_thermal_850

cairo_pdf(plot.filename, width=15/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

plot.time.series(p, name,
    ylab=ylab,
    ylim=ylim,
    lwd=1,
    col='#0169c9',
    bg='#b3defd'
)

dev.off()
