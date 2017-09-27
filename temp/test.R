library(tidyverse)
library(rlang)
library(xml2)
library(progress)

library(kronawidget)
testset<-read.csv2("inst/extdata/MARS_stressors.csv", stringsAsFactors = F)

doc<-
  df_to_krona(testset, test, area, country, river.basin.district, first.stressor, second.stressor, third.stressor)
xml2::write_html(xml2::as_xml_document(doc), "temp/test.xml")
