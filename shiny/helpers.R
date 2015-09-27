# mandatory fields in the form
fields_mandatory <- c(
        "scope",
        "quality"
)

# all fields in the form we want to save
fields_all <- c(
        fields_mandatory,
        "timestamp"
)

# get current Epoch time
get_time_epoch <- function() {
        return(as.integer(Sys.time()))
}

# get a formatted string of the timestamp (exclude colons as they are invalid
# characters in Windows filenames)
get_time_human <- function() {
        format(Sys.time(), "%Y%m%d-%H%M%OS")
}