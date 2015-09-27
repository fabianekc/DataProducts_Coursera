library(dplyr)
library(digest)
library(DBI)
library(RAmazonS3)

# decide which function to use to save based on storage type
get_save_fxn <- function(type) {
        fxn <- sprintf("save_data_%s", type)
        stopifnot(existsFunction(fxn))
        fxn
}
save_data <- function(data, type) {
        fxn <- get_save_fxn(type)
        do.call(fxn, list(data))
}

# decide which function to use to load based on storage type
get_load_fxn <- function(type) {
        fxn <- sprintf("load_data_%s", type)
        stopifnot(existsFunction(fxn))
        fxn
}
load_data <- function(type) {
        fxn <- get_load_fxn(type)
        data <- do.call(fxn, list())
        
        # Just for a nicer UI, if there is no data, construct an empty
        # dataframe so that the colnames will still be shown
        if (nrow(data) == 0) {
                data <-
                        matrix(nrow = 0, ncol = length(fields_all),
                               dimnames = list(list(), fields_all)) %>%
                        data.frame
        }
        data %>% dplyr::arrange(desc(timestamp))
}


#### Method 7: Amazon S3 ####

s3_bucket_name <- "crwdsttmp"

save_data_s3 <- function(data) {
        file_name <- paste0(
                paste(
                        get_time_human(),
                        digest(data, algo = "md5"),
                        sep = "_"
                ),
                ".csv"
        )
        RAmazonS3::addFile(I(paste0(paste(names(data), collapse = ","),
                                    "\n",
                                    paste(data, collapse = ","))),
                           s3_bucket_name, file_name, virtual = TRUE)
}

create_data_s3 <- function() {
        save_data_s3(list(scope=35, quality=7, timestamp=get_time_epoch()))
        save_data_s3(list(scope=41, quality=0, timestamp=get_time_epoch()))
        save_data_s3(list(scope=38, quality=6, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=10, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=2, timestamp=get_time_epoch()))
        save_data_s3(list(scope=29, quality=1, timestamp=get_time_epoch()))
        save_data_s3(list(scope=35, quality=12, timestamp=get_time_epoch()))
        save_data_s3(list(scope=37, quality=5, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=4, timestamp=get_time_epoch()))
        save_data_s3(list(scope=22, quality=13, timestamp=get_time_epoch()))
        save_data_s3(list(scope=40, quality=5, timestamp=get_time_epoch()))
        save_data_s3(list(scope=35, quality=7, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=3, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=2, timestamp=get_time_epoch()))
        save_data_s3(list(scope=25, quality=18, timestamp=get_time_epoch()))
        save_data_s3(list(scope=25, quality=11, timestamp=get_time_epoch()))
        save_data_s3(list(scope=20, quality=9, timestamp=get_time_epoch()))
        save_data_s3(list(scope=34, quality=7, timestamp=get_time_epoch()))
        save_data_s3(list(scope=30, quality=8, timestamp=get_time_epoch()))
        save_data_s3(list(scope=22, quality=2, timestamp=get_time_epoch()))
}

load_data_s3 <- function() {
        files <- listBucket(s3_bucket_name)$Key %>% as.character
        data <-
                lapply(files, function(x) {
                        raw <- getFile(s3_bucket_name, x, virtual = TRUE)
                        read.csv(text = raw, stringsAsFactors = FALSE)
                }) %>%
                do.call(rbind, .)
        data
}

clear_data_s3 <- function() {
        files <- listBucket(s3_bucket_name)$Key %>% as.character
        lapply(files, function(x) {
                RAmazonS3::removeFile(s3_bucket_name, x, virtual = TRUE)
        })
        length(files)
}