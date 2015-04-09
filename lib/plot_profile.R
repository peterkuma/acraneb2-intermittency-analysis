plot.profile <- function(p, name, col=NULL, lwd=NULL, new=TRUE, ...) {
    var.mean <- apply(p[[name]], 1, mean)

    if (new) {
        ylim <- rev(range(p$mean_pressure/100))

        plot(NULL,
            # xlim=xlim,
            ylim=ylim,
            type='n',
            ylab='Mean pressure (hPa)',
            yaxt='n',
            yaxs='i',
            ...
        )
        axis(2, at=c(100,300,500,700,850)) 
    }

    lines(var.mean, p$mean_pressure/100,
        'l',
        col=col,
        lwd=lwd,
        ...
    )
}

plot.profile.band <- function(p, name, bg=NULL, new=TRUE, ...) {
    var.hi <- apply(p[[name]], 1, function(x) {
        quantile(x, 0.95)
    })

    var.lo <- apply(p[[name]], 1, function(x) {
        quantile(x, 1-0.95)
    })

    if (new) {
        ylim <- rev(range(p$mean_pressure/100))

        plot(NULL,
            # xlim=xlim,
            ylim=ylim,
            type='n',
            ylab='Mean pressure (hPa)',
            yaxt='n',
            yaxs='i',
            ...
        )
        axis(2, at=c(100,300,500,700,850)) 
    }

    polygon(
        c(var.lo, rev(var.hi)),
        c(p$mean_pressure/100, rev(p$mean_pressure/100)),
        col=bg,
        border=NA
    )
}
