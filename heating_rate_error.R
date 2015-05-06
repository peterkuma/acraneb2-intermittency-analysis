#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: shortwave_heating_rate_error.R <config>\n'))
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

products.base <- lapply(config$base, function(filename) {
    level(read.nc(filename, only=only))
})

products <- lapply(1:length(config$products), function(i) {
    filename <- config$products[i]
    p <- level(read.nc(filename, only=only))
    p.base <- products.base[[(i - 1) %% length(products.base) + 1]]
    p$heating_rate_solar_error <- p$heating_rate_solar - p.base$heating_rate_solar
    p$heating_rate_thermal_error <- p$heating_rate_thermal - p.base$heating_rate_thermal
    p
})

i <- 1
for (p in products) {
    plot.profile.band(p, config$name,
        xlab=config$xlab,
        lwd=1,
        xlim=config$xlim,
        bg=config$bg[i],
        new=(i == 1)
    )
    i <- i + 1
}

i <- 1
for (p in products) {
    plot.profile(p, config$name,
        lwd=1,
        lty=config$lty[i],
        col=config$col[i],
        new=FALSE
    )
    i <- i + 1
}

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
