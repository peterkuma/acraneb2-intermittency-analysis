library('RColorBrewer')
library('ncdf4')
# library('rhdf5')

g <- 9.80665

read.nc <- function(filename, only=NULL) {
    nc <- nc_open(filename)
    obj <- list()
    for (name in names(nc$var)) {
        if (!is.null(only) && !(name %in% only)) {
            next
        }
        obj[[name]] <- ncvar_get(nc, name)
    }
    nc_close(nc)
    obj
}

# write.nc <- function(filename, p) {
#     vars <- lapply(names(p), function(name) {
#         ncvar_def(name, '', list())
#     })
#     nc <- nc_create(filename, vars, force_v4=TRUE)
#     for (name in names(p)) {
#         dims <- lapply(0:(length(dim(p[[name]])) - 1), function(i) {
#             ncdim_def(sprintf('dim_%s_%d', name, i), '', 1:(dim(p[[name]])[i]))
#         })
#         ncvar_put(nc, name, p[[name]])
#     }
# }

# read.h5 <- function(filename) {
#     h5dump(input.filename)
#     p <- list()
#     h5read
# }

# write.h5 <- function(filename, p) {
#     h5createFile(filename)
#     for (name in names(p)) {
#         h5write(p[[name]], filename, name)
#     }
# }
