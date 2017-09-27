# TODO clean up imports
library(tidyverse)
library(rlang)
library(xml2)
library(progress)

#' quotes values for use in adhoc parsing
value_quote<-Vectorize(function(value){
  paste0("[['",value, "']]")
})

#' Adds magnitude for each level of the doc structure
#'
#' @param doc_part a structured list
#' @return the structured list with added magnitude values
add_magnitude <- function(doc_part){

  child_magnitude_vals <- sapply(doc_part, function(x) x[['magnitude']][['val']]) %>% unlist

  if(any(is.null(child_magnitude_vals))){
    doc_part <- lapply(doc_part, add_magnitude)
    child_magnitude_vals <- sapply(doc_part, function(x) x[['magnitude']][['val']]) %>% unlist
  }

  doc_part$magnitude <- list(val = sum(child_magnitude_vals))

  return(doc_part)

}

#' Rename key to 'node' and add original name as attribute
#'
#' @param doc_part a structured list
#' @return the structured list with renamed keys
do_rename <- function(doc_part){
  if(!class(doc_part) == "list"){
    return(doc_part)
  }
  if(! all(names(doc_part) %in% c("name", "magnitude"))){

    doc_part <- lapply(doc_part, do_rename)
  }

  for(n in seq_along(doc_part)){
    if(!names(doc_part)[n] == "magnitude"){
      attr(doc_part[[n]], "name") <- names(doc_part)[n]
      names(doc_part)[n] <- "node"
    }

  }

  doc_part
}

#' Convert a data.frame to a KRONA XML structure
#'
#' @param df the data.frame
#' @param name the name of the dataset
#' @param magnitude the name of the column which holds the magnitude values
#' @param ... a list of columns on which to aggregate, note: order matters
#' @return an xml object (based on xml2)
#' @export
df_to_krona<-function(df, name, magnitude, ...){
  name <- substitute(name)
  magnitude <- substitute(magnitude)
  levels <- quos(...)

  ## aggregate data on specified cols]
  df_agg <-
    df %>%
    arrange(UQS(levels)) %>%
    group_by(UQS(levels)) %>%
    summarise(magnitude = sum(UQ(magnitude)))

  df_agg

  doc <- list()

  pb <- progress_bar$new(total = nrow(df_agg))
  num_levels <- ncol(df_agg)-1
  for(i in 1:nrow(df_agg)){
    values <- df_agg[i,1:num_levels] %>% unlist %>% unname

    slice_expr <-
      paste0("doc",
             paste0(values %>% value_quote, collapse=""),
             " <- list()" #df_agg[[i,",ncol(df_agg), "]]"
      )

    eval(parse(text=slice_expr))

    ## add magnitude

    slice_expr <-
      paste0("doc",
             paste0(values %>% value_quote, collapse=""),
             value_quote("magnitude"),
             " <- list(val = df_agg[[i,",ncol(df_agg), "]])"
      )
    eval(parse(text=slice_expr))


    pb$tick()


  }

  doc <- doc %>%
    add_magnitude() %>%
    do_rename()

  # some remodelling

  doc <- list(krona = doc)
  doc$krona$attributes <- structure(list(attribute = structure("magnitude", display="area")), magnitude="magnitude")
  doc
  # xml2::as_xml_document(doc)
}
