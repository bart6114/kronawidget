testset<-read.csv2("inst/extdata/MARS_stressors.csv", stringsAsFactors = F)

#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
library(tidyverse)
library(rlang)
# library(XML)
library(xml2)
library(progress)

gh<-NULL

df_to_krona<-function(df, name, magnitude, ...){
  name <- substitute(name)
  magnitude <- substitute(magnitude)
  levels <- quos(...)
  print("@#$#@#$")
  print(UQ(magnitude))
  ## aggregate data on specified cols]
  df_agg <-
    df %>%
    arrange(UQS(levels)) %>%
    group_by(UQS(levels)) %>%
    summarise(magnitude = sum(UQ(magnitude)))

  gh<<-df_agg
  # iterate over dataframe and build XML tree
  # top_xml <- newXMLNode("node", attrs=list(name = `!!`(name)))
  top_xml <- xml_new_document() %>% xml_add_child("node", name = `!!`(name))

  df_cols<- colnames(df_agg)[-ncol(df_agg)]
  print(`!!`(name))
  for(i in 1:nrow(df_agg)){
    if(i %% 100 == 0) print(paste(i, nrow(df_agg)))
    create_node_if_not_exists(top_xml,
                              `!!`(name),
                              df_agg[i, df_cols[-length(df_cols)]] %>% unlist() %>% unname(),
                              df_agg[i, df_cols[length(df_cols)]] %>% unlist %>% unname())
  }



  top_xml

}


construct_path_spec <- function(levels, root_name){
  base_path <- paste0("//node[@name=", shQuote(root_name), "]")

  if(length(levels) == 0){
    return(base_path)
  } else {
    paste0(
      c(
        base_path,
        paste0("node[@name=", shQuote(levels), "]")
      ),
      collapse="/"
    )
  }
}

create_node_if_not_exists <- function(root_xml, root_name, parent_levels, new_level){
  # print("=====")
  # print(paste("parent:", parent_levels))
  # print(parent_levels)
  # print(length(parent_levels))
  # print(new_level)
  full_path_spec <- construct_path_spec(c(parent_levels, new_level), root_name)
  # print(full_path_spec)
  # print("=+++")

  # if(length(xml_find_one(root_xml, full_path_spec)) > 0){
  #   # node already exists
  #   return(root_xml)
  # }
  # print(333)
  parent_path_spec <- construct_path_spec(parent_levels, root_name)
  # print(parent_path_spec)
  parent_node <- xml_find_first(root_xml, parent_path_spec)
  # print(parent_node)
  # print(4444)
  # print(length(parent_levels))
  if(length(parent_levels) > 0 && length(parent_node) == 0){
    root_xml <- create_node_if_not_exists(root_xml, root_name, parent_levels[-length(parent_levels)], parent_levels[length(parent_levels)])
    # print(parent_levels)
    # print(555)
    parent_node <- xml_find_first(root_xml, parent_path_spec)
  }
  # Sys.sleep(.001)
  # newXMLNode("node", attrs=list(name=new_level), parent = parent_node)
  xml_add_child(parent_node, "node", name=new_level, where=0)

  root_xml
}

# create_node_if_not_exists(top_xml, c("stressors", "test"), "blaad")

test_doc <- df_to_krona(testset, test, area, country, river.basin.district, first.stressor, second.stressor, third.stressor)

# %>%
# filter(country=="FR", river.basin.district=="Adour-Garonne", first.stressor=="stressor1", second.stressor=="stressor2", third.stressor=="stressor3")  %>% {.$magnitude} %>% sum()

#
# library(rlang)
# UQ(quo(name))
# `!!`(quo(name))


# buffer <- c()
#
# num_levels <- ncol(gh) - 1 # 1 level goes to magnitude
#
# for(i in num_levels){
#   gh %>% split(.[i])
# }
#
#
# u<-gh %>% split(.[1:num_levels])
#
# doc_holder <- list()
# gh<-gh%>%ungroup
#
# value_quote<-Vectorize(function(value){
#   paste0("[['",value, "']]")
# })
#
# rec_add_list<-function(lst, name){
#   lst[['node']] <- structure(list(), name=name)
#   lst
# }
#
create_doc_list <- function(df_agg){
  doc <- list()

  pb <- progress_bar$new(total = nrow(df_agg))
  for(i in 1:nrow(df_agg)){
    values <- df_agg[i,1:num_levels] %>% unlist %>% unname

    slice_expr <-
      paste0("doc",
             paste0(values %>% value_quote, collapse=""),
             " <- list()" #df_agg[[i,",ncol(df_agg), "]]"
      )
    # print(slice_expr)

    eval(parse(text=slice_expr))

    # ## add magnitude

    slice_expr <-
      paste0("doc",
             paste0(values %>% value_quote, collapse=""),
             # value_quote("magnitude"),
             " <- df_agg[[i,",ncol(df_agg), "]]"
      )
    # print(slice_expr)
    eval(parse(text=slice_expr))


    pb$tick()

  }


  doc
}

doc<-create_doc_list(gh)

## add magnitude
add_magnitude <- function(df_agg, df_list){
  for(i in 1:nrow(df_agg)){
    values <- df_agg[i,1:num_levels] %>% unlist %>% unname

    slice_expr <-
      paste0("doc",
             paste0(df_agg[i,1:num_levels] %>% unlist %>% unname %>% value_quote, collapse=""),
             value_quote("magnitude"),
             "<- 3"
      )
    print(slice_expr)

    eval(parse(text=slice_expr))
  }

}

doc2<-add_magnitude(gh, doc)
