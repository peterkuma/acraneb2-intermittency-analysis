plot.time.series <- function(p, name, new=TRUE, ...) {
    time.dim <- length(dim(p[[name]]))
    var.mean <- apply(p[[name]], time.dim, mean)

    if (new) {
        xlim <- range(p$time_utc)
        # ylim <- range(p[[name]])
        plot(NULL,
            type='n',
            xaxt='n',
            xlab='Time (UTC)',
            xlim=xlim,
            ...
        )

        at <- seq(p$start_time, tail(p$time_utc, n=1), 3*60*60)
        labels <- format.Date(at, format='%H:%M')
        axis(1, at, labels)
    }

    lines(p$time_utc, var.mean,
        type='o',
        pch=NA,
        ...
    )
}

plot.time.series.band <- function(p, name, new=TRUE, bg=NULL, ...) {
    time.dim <- length(dim(p[[name]]))

    t <- 1
    var.hi <- apply(p[[name]], time.dim, function(x) {
        if (is.null(dim(x))) {
            y <- x
        } else {
            y <- sample(c(x), length(c(x))*10,
                prob=c(p$pressure_thickness[,,t]),
                replace=TRUE
            )
        }
        t <- t + 1
        quantile(y, (1 + 0.90)/2)
    })
 
    t <- 1
    var.lo <- apply(p[[name]], time.dim, function(x) {
        if (is.null(dim(x))) {
            y <- x
        } else {
            y <- sample(c(x), length(c(x))*10,
                prob=c(p$pressure_thickness[,,t]),
                replace=TRUE
            )
        }
        t <- t + 1
        quantile(y, (1 - 0.90)/2)
    })

    if (new) {
        xlim <- range(p$time_utc)
        # ylim <- range(p[[name]])
        plot(NULL,
            type='n',
            xaxt='n',
            xlab='Time (UTC)',
            xlim=xlim,
            ...
        )

        at <- seq(p$start_time, tail(p$time_utc, n=1), 3*60*60)
        labels <- format.Date(at, format='%H:%M')
        axis(1, at, labels)
    }

    polygon(
        c(p$time_utc, rev(p$time_utc)),
        c(var.lo, rev(var.hi)),
        border=NA,
        col=bg
    )
}
