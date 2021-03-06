#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: heating_rate_error_timeseries.R <config>\n'))
    quit(status=1)
}
config <- fromJSON(file=args[1])
config$start_time <- as.POSIXct(config$start_time, tz='UTC')

script.dir <- dirname(substring(commandArgs()[grep("--file=",commandArgs())],8))
source(sprintf('%s/lib/common.R', script.dir))
source(sprintf('%s/lib/plot_time_series.R', script.dir))

pressure.index <- function(p, pressure) {
    which.min(abs(p$mean_pressure - pressure))
}

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    p$start_time <- config$start_time
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

products.base <- lapply(config$base, function(filename) {
    level(read.nc(filename, only=only))
})

products <- lapply(1:length(config$products), function(i) {
    filename <- config$products[i]
    p <- level(read.nc(filename, only=only))
    p.base <- products.base[[(i - 1) %% length(products.base) + 1]]
    p$heating_rate_solar_error <- p$heating_rate_solar - p.base$heating_rate_solar
    p$heating_rate_solar_error_850 <- p$heating_rate_solar_850 - p.base$heating_rate_solar_850
    p$heating_rate_thermal_error <- p$heating_rate_thermal - p.base$heating_rate_thermal
    p$heating_rate_thermal_error_850 <- p$heating_rate_thermal_850 - p.base$heating_rate_thermal_850
    p
})

cairo_pdf(config$plot, width=15/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

i <- 1
for (p in products) {
    plot.time.series.band(p, config$name,
        ylab=config$ylab,
        ylim=config$ylim,
        lwd=1,
        col=config$col[i],
        bg=config$bg[i],
        new=(i == 1)
    )
    i <- i + 1
}

i <- 1
for (p in products) {
    plot.time.series(p, config$name,
        ylab=config$ylab,
        ylim=config$ylim,
        lwd=1,
        col=config$col[i],
        lty=config$lty[i],
        new=FALSE
    )
    i <- i + 1
}

dev.off()
