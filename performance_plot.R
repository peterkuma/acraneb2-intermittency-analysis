#!/usr/bin/env Rscript

library(rjson)

args <- commandArgs(TRUE)
if (length(args) != 1) {
    cat(sprintf('Usage: performance_plot.R <config>\n'))
    quit(status=1)
}
config <- fromJSON(file=args[1])

cairo_pdf(config$plot, width=7/cm(1), height=7/cm(1))
par(mar=c(2,4,1,1))
par(cex=0.8)
par(lwd=0.8)

x <- barplot(config$mean*100,
    col=config$col,
    border=NA,
    ylab='Run time (%)',
    names.arg=config$labels
)

abline(100, 0, lty=2, lwd=0.5)

i <- 1
for (hdi in config$hdi) {
    arrows(x[i,1], hdi[1]*100, x[i,1], hdi[2]*100,
        angle=90,
        code=3,
        length=0.1,
        lwd=0.5
    )
    i <- i + 1
}

i <- 1
for (mean in config$mean) {
    text(x[i,1], mean*100, sprintf('%.0f %%', mean*100),
        pos=1,
        offset=0.8,
        col=config$text.col,
        font=2
    )
    i <- i + 1
}

# error.bar <- function(x, y, upper, lower=upper, length=0.1,...){
# if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
# stop("vectors must be same length")
# arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length, ...)
# }

dev.off()
