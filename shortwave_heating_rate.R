#!/usr/bin/env Rscript

source('lib/plot_profile.R')

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60
    p
}

cairo_pdf('shortwave_heating_rate.pdf', width=10/cm(1), height=10/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

only <- c(
        'pressure_thickness',
        'pressure',
        'flux_solar',
        'heat_capacity'
)

p.base <- level(read.nc('results/shortwave-intermittency-base.nc', only=only))
p.1h <- level(read.nc('results/shortwave-intermittency-1h.nc', only=only))

plot.profile(p.base, 'heating_rate_solar',
    xlab='Shortwave heating rate (K/day)',
    lwd=1,
    col='#0169c9',
    bg='#b3defd',
    xlim=c(0,5)
)

# plot.profile(p.1h, 'heating_rate_solar',
#     lwd=1,
#     col='red',
#     new=FALSE
# )

dev.off()
