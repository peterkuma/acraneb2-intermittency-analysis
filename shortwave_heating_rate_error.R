#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 3) {
    cat(sprintf('Usage: shortwave_heating_rate_error.R <plot> <product> <base>\n'))
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
    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60
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
        'heat_capacity'
)

p.base <- level(read.nc(base.filename, only=only))
p <- level(read.nc(product.filename, only=only))

p$heating_rate_solar_error <- p$heating_rate_solar - p.base$heating_rate_solar

plot.profile(p, 'heating_rate_solar_error',
    xlab='Shortwave heating rate error (K/day)',
    lwd=1,
    col='#0169c9',
    xlim=c(-0.2, 0.2),
    bg='#b3defd'
)

p$heating_rate_solar_rmse <- sqrt(apply(
    (p$heating_rate_solar - p.base$heating_rate_solar)**2,
    1,
    mean
))

# polygon(
#     c(
#         rep(0, length(p$mean_pressure)),
#         rev(p$heating_rate_solar_rmse)
#     ),
#     c(
#         p$mean_pressure/100,
#         rev(p$mean_pressure/100)
#     ),
#     col='#0197fd',
#     border=NA
# )

dev.off()
