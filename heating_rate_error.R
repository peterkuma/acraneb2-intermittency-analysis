#!/usr/bin/env Rscript

args <- commandArgs(TRUE)
if (length(args) != 6) {
    cat(sprintf('Usage: shortwave_heating_rate_error.R <plot> <product> <base> <name> <xlab> <xlim>\n'))
    quit(status=1)
}

plot.filename <- args[1]
product.filename <- args[2]
base.filename <- args[3]
name <- args[4]
xlab <- args[5]
xlim <- as.numeric(strsplit(args[6], ',')[[1]])

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

p.base <- level(read.nc(base.filename, only=only))
p <- level(read.nc(product.filename, only=only))

p$heating_rate_solar_error <- p$heating_rate_solar - p.base$heating_rate_solar
p$heating_rate_thermal_error <- p$heating_rate_thermal - p.base$heating_rate_thermal

plot.profile(p, name,
    xlab=xlab,
    lwd=1,
    col='#0169c9',
    xlim=xlim,
    bg='#b3defd'
)

# p$heating_rate_solar_rmse <- sqrt(apply(
#     (p$heating_rate_solar - p.base$heating_rate_solar)**2,
#     1,
#     mean
# ))

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
