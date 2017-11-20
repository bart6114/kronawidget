rm(list=ls())

# data
test_file <- system.file("extdata", "MARS_stressors.csv", package="kronawidget")
testset <- read.csv2(test_file, stringsAsFactors = F)

doc<- df_to_krona(df = testset,
                  name = "test",
                  magnitude = "area",
                  "country", "river.basin.district", "first.stressor", "second.stressor")
# kronawidget
kronawidget <- function(krona_df, width = "100%", height = "500px", elementId = NULL) {

  temp_xml_file <- tempfile()
  xml2::write_xml(xml2::as_xml_document(krona_df), temp_xml_file, options = c("format", "no_declaration"))

  # forward options using x
  x = list(
    content =  paste0(readLines(temp_xml_file), collapse = "\n")
  )


  # create widget
  htmlwidgets::createWidget(
    name = 'kronawidget',
    x,
    width = width,
    height = height,
    package = 'kronawidget',
    elementId = elementId
  )
}

kronawidget(doc)

# kronawidget cached

kronawidget_cached <- memoise(kronawidget)

kronawidget_cached(doc)
