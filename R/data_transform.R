#' quotes values for use in adhoc parsing
value_quote<-Vectorize(function(value){
  paste0("[['",value, "']]")
})

#' Adds magnitude for each level of the doc structure
#'
#' @param doc_part a structured list
#' @return the structured list with added magnitude values
#' @importFrom magrittr "%>%"
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
    if(!names(doc_part)[n] %in% c("magnitude", "val")){
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
  levels <- rlang::quos(...)

  ## aggregate data on specified cols]
  df_agg <-
    df %>%
    dplyr::arrange(rlang::UQS(levels)) %>%
    dplyr::group_by(rlang::UQS(levels)) %>%
    dplyr::summarise(magnitude = sum(rlang::UQ(magnitude)))

  df_agg

  doc <- list()

  pb <- progress::progress_bar$new(total = nrow(df_agg))
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

  doc2 <- list(krona = list())
  doc2$krona$attributes <- structure(list(attribute = structure("magnitude", display="area")), magnitude="magnitude")
  doc2$krona$node <- structure(doc, name=name)
  doc2
  # xml2::as_xml_document(doc)
}

#' Save krona object
#'
#' @param doc a KRONA document object created by \code{df_to_krona}
#' @param filename the filename to write the xml to
#'
#' @export
save_krona_xml <- function(doc, filename){
  xml2::write_xml(
    xml2::as_xml_document(doc),
    "temp/test.xml", options = c("format", "no_declaration"))

  message("Written KRONA XML file to '", filename, "'\n")

  return(filename)
}
