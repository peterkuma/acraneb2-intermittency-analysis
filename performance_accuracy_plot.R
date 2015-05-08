#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: performance_accuracy_plot.R <config>\n'))
    quit(status=1)
}
config <- fromJSON(file=args[1])

script.dir <- dirname(substring(commandArgs()[grep("--file=",commandArgs())],8))
source(sprintf('%s/lib/common.R', script.dir))

level <- function(p) {
    p$pressure <- apply(p$pressure_thickness, c(2,3), cumsum) - p$pressure_thickness/2
    p$mean_pressure <- apply(p$pressure, 1, mean)
    p$mean_pressure_thickness <- apply(p$pressure_thickness, 1, mean)
    p$flux_solar_diff <- apply(p$flux_solar, c(2,3), diff)
    p$heating_rate_solar <- -g*p$flux_solar_diff/p$heat_capacity/p$pressure_thickness*24*60*60
    p$flux_thermal_diff <- apply(p$flux_thermal, c(2,3), diff)
    p$heating_rate_thermal <- -g*p$flux_thermal_diff/p$heat_capacity/p$pressure_thickness*24*60*60
    p
}

only <- c(
        'pressure_thickness',
        'pressure',
        'flux_solar',
        'flux_thermal',
        'heat_capacity'
)

p.base <- level(read.nc(config$base, only=only))

products <- lapply(config$products, function(filename) {
    p <- level(read.nc(filename, only=only))
    p$heating_rate_solar_abs_error <- abs(p$heating_rate_solar - p.base$heating_rate_solar)
    p$heating_rate_thermal_abs_error <- abs(p$heating_rate_thermal - p.base$heating_rate_thermal)
    p$heating_rate_solar_wmean_abs_error <- apply(p$heating_rate_solar_abs_error, c(2, 3), function(x) {
        weighted.mean(x, p$mean_pressure_thickness)
    })
    p$heating_rate_solar_mean_wmean_abs_error <- mean(p$heating_rate_solar_wmean_abs_error)
    p$heating_rate_solar_abs_error_high <- quantile(
        sample(p$heating_rate_solar_abs_error, 1000000,
            prob=p$pressure_thickness,
            replace=TRUE
        ),
        0.95
    )
    p
})

value <- sapply(products, function(p) { p[[config$name]] })
high <- sapply(products, function(p) { p[[config$high]] })
low <- rep(0, length(value))

cairo_pdf(config$plot, width=14/cm(1), height=9/cm(1))
par(mar=c(4,4,1,1))
par(cex=0.8)
par(lwd=0.8)

x <- c(1, config$performance)*100
y <- c(0, value)

ord <- order(x, decreasing=TRUE)

plot(NULL,
    type='n',
    xlab='Run time (%)',
    ylab=config$ylab,    
    xlim=c(100, min(x)),
    ylim=c(0, max(high)),
)

polygon(
   c(x[ord], rev(x[ord])),
   c(c(0, low)[ord], rev(c(0, high)[ord])),
   col=config$bg,
   border=NA
)

lines(x[ord], c(0, high)[ord],
    lwd=1,
    type='o',
    pch=20,
    lty=2,
    col=config$col
)

lines(x[ord], y[ord],
    col=config$col,
    lwd=1,
    type='o',
    pch=20
)

arrows(x, 0, x, c(0, high),
    length=0,
    lwd=0.5,
    lty=3
)

text(x, y, config$labels,
    pos=3,
    offset=0.5,
    xpd=NA,
    cex=0.8
)

dev.off()
