#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 3) {
    cat(sprintf('Usage: longwave_heating_rate_error.R <plot> <product> <base>\n'))
    quit(status=1)
}

plot.filename <- args[1]
product.filename <- args[2]
base.filename <- args[3]

source('lib/common.R')
source('lib/plot_profile.R')

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
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
        'flux_thermal',
        'heat_capacity'
)

p <- level(read.nc(product.filename, only=only))
p.base <- level(read.nc(base.filename, only=only))

p$heating_rate_thermal_error <- p$heating_rate_thermal - p.base$heating_rate_thermal

plot.profile(p, 'heating_rate_thermal_error',
    xlab='Longwave heating rate error (K/day)',
    lwd=1,
    col='#0169c9',
    xlim=c(-0.7, 0.7),
    bg='#b3defd'
)

dev.off()
