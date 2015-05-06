#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: heating_rate.R <config>\n'))
    quit(status=1)
}
config <- fromJSON(file=args[1])

script.dir <- dirname(substring(commandArgs()[grep("--file=",commandArgs())],8))
source(sprintf('%s/lib/common.R', script.dir))
source(sprintf('%s/lib/plot_profile.R', script.dir))

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    
    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p$flux_thermal_diff <- apply(p$flux_thermal, c(2,3), diff)
    p$heating_rate_thermal <- -g*p$flux_thermal_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p
}

cairo_pdf(config$plot, width=10/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

only <- c(
        'pressure_thickness',
        'pressure',
        'flux_solar',
        'flux_thermal',
        'heat_capacity'
)

p <- level(read.nc(config$product, only=only))

plot.profile.band(p, config$name,
    xlab=config$xlab,
    xlim=config$xlim,
    lwd=1,
    bg=config$bg

)

plot.profile(p, config$name,
    lwd=1,
    col=config$col,
    new=FALSE
)

dev.off()
