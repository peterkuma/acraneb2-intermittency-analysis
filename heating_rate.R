#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 5) {
    cat(sprintf('Usage: heating_rate.R <plot> <product> <name> <xlab> <xlim>\n'))
    quit(status=1)
}

plot.filename <- args[1]
product.filename <- args[2]
name <- args[3]
xlab <- args[4]
xlim <- as.numeric(strsplit(args[5], ',')[[1]])

source('lib/common.R')
source('lib/plot_profile.R')

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    
    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p$flux_thermal_diff <- apply(p$flux_thermal, c(2,3), diff)
    p$heating_rate_thermal <- -g*p$flux_thermal_diff/p$heat_capacity/p$pressure_thickness*24*60*60

    p
}

cairo_pdf(plot.filename, width=10/cm(1), height=10/cm(1))
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

p <- level(read.nc(product.filename, only=only))

plot.profile(p, name,
    xlab=xlab,
    lwd=1,
    col='#0169c9',
    bg='#b3defd',
    xlim=xlim
)

dev.off()
