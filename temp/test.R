
library(kronawidget)
data(testdata)
testset<-testdata

doc<-
  df_to_krona(df = testset,
              name = "test",
              magnitude = "area",
              "country", "river.basin.district", "first.stressor", "second.stressor")#, "third.stressor")

# save_krona_xml(doc, "temp/test.xml")



kronawidget(doc)

# htmlwidgets::saveWidget(kronawidget(doc), "../temp/saved_widget")

library(memoise)
kronawidget.mem <- memoise(kronawidget)

kronawidget.mem(doc)





####
library(widgetframe)

frameWidget(kronawidget(doc, height=600, width="100%"),
            height=600, width="100%")

frameWidget(kronawidget(doc))


# xml2::write_xml(xml2::as_xml_document(doc), "temp/test.xml", options = c("format", "no_declaration"))
#
# temp_xml_file <- tempfile()
#
#
# xml2::write_xml(xml2::as_xml_document(doc), temp_xml_file, options = c("format", "no_declaration"))
# paste0(readLines(temp_xml_file), collapse = "\n")


## randomize stressors
library(tidyverse)
testdata<-
testset %>%
  mutate(area = sample(1:100, length(area), replace=TRUE))

devtools::use_data(testdata)


