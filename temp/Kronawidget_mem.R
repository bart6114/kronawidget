rm(list=ls())

# data
test_file <- system.file("extdata", "MARS_stressors.csv", package="kronawidget")
testset <- read.csv2(test_file, stringsAsFactors = F)

doc<- df_to_krona(df = testset,
                  name = "test",
                  magnitude = "area",
                  "country", "river.basin.district", "first.stressor", "second.stressor")

# kronawidget cached

kronawidget_cached <- memoise(kronawidget)

kronawidget_cached(doc)

#' Cached version of kronawidget
#'
#' @param cache_type either \code{memory} or \code{filesystem}
#' @param cache_fs_path directory to store cached data if \code{cache_type == "filesystem"}
#'
#' @return cached output of kronawidget
#' @export
kronawidget_cached <- function(cache_type = "memory", cache_fs_path = NULL){
  if(cache_type == "memory"){
    cache_func = memoise::cache_memory()
  } else if(cache_type == "filesystem"){
    cache_func = memoise::cache_filesystem(cache_fs_path)
  }
  mem_func <- memoise::memoise(kronawidget, cache = cache_func)
}

kronawidget_cached <- kronawidget_cached(cache_type = "memory")

kronawidget_cached(doc)


