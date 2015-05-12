#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: heating_rate_error_distribution.R <config>\n'))
    quit(status=1)
}
config <- fromJSON(file=args[1])
config$start_time <- as.POSIXct(config$start_time, tz='UTC')

script.dir <- dirname(substring(commandArgs()[grep("--file=",commandArgs())],8))
source(sprintf('%s/lib/common.R', script.dir))

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    p$start_time <- config$start_time
    p$time_utc <- p$start_time + p$time

    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p$flux_thermal_diff <- apply(p$flux_thermal, c(2,3), diff)
    p$heating_rate_thermal <- -g*p$flux_thermal_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p
}

only <- c(
    'time',
    'pressure_thickness',
    'flux_solar',
    'flux_thermal',
    'heat_capacity'
)

p.base <- level(read.nc(config$base, only=only))

filename <- config$product
p <- level(read.nc(filename, only=only))
p$heating_rate_solar_error <- p$heating_rate_solar - p.base$heating_rate_solar
p$heating_rate_thermal_error <- p$heating_rate_thermal - p.base$heating_rate_thermal

cairo_pdf(config$plot, width=15/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

x <- p[[config$name]]
y <- sample(c(x), length(c(x)),
    prob=c(p$pressure_thickness),
    replace=TRUE
)

# d <- density(y)
# plot(d,
#     type='n',
#     xlab=config$xlab,
#     xlim=config$xlim,
#     main=''
# )
# polygon(d$x, d$y,
#     col=config$col,
#     border=NA
# )

hist(y,
    xlab=config$xlab,
    xlim=config$xlim,
    col=config$col,
    border=NA,
    freq=FALSE,
    breaks=config$breaks,
    main=''
)

dev.off()
