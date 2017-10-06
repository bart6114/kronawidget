library(tidyverse)
library(rlang)
library(xml2)
library(progress)

library(kronawidget)
testset<-read.csv2("inst/extdata/MARS_stressors.csv", stringsAsFactors = F)

doc<-
  df_to_krona(df = testset,
              name = test,
              magnitude = area,
              country, river.basin.district, first.stressor, second.stressor, third.stressor)

save_krona_xml(doc, "temp/test.xml")
# xml2::write_xml(xml2::as_xml_document(doc), "temp/test.xml", options = c("format", "no_declaration"))

temp_xml_file <- tempfile()


xml2::write_xml(xml2::as_xml_document(doc), temp_xml_file, options = c("format", "no_declaration"))
paste0(readLines(temp_xml_file), collapse = "\n")

library(memoise)
kronawidget.mem <- memoise(kronawidget)

kronawidget(doc)
kronawidget.mem(doc)
