#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 4) {
    cat(sprintf('Usage: shortwave_heating_rate_error_timeseries.R <plot> <product> <base> <start-time>\n'))
    quit(status=1)
}

plot.filename <- args[1]
product.filename <- args[2]
base.filename <- args[3]
start.time <- as.POSIXct(args[4], tz='UTC')

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
    p$heating_rate_solar_850 <- p$heating_rate[pressure.index(p, 850),,]
    p
}

only <- c(
    'time',
    'pressure_thickness',
    'flux_solar',
    'heat_capacity'
)

p <- level(read.nc(product.filename, only=only))
p.base <- level(read.nc(base.filename, only=only))

p$heating_rate_solar_error_850 <- p$heating_rate_solar_850 - p.base$heating_rate_solar_850

cairo_pdf(plot.filename, width=15/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

plot.time.series(p, 'heating_rate_solar_error_850',
    ylab='Shortwave heating rate error at 850 hPa (K/day)',
    ylim=c(-0.1, 0.2),
    lwd=1,
    col='#0169c9',
    bg='#b3defd'
)

dev.off()
