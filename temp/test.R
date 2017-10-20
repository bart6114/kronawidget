
library(kronawidget)
testset<-read.csv2("inst/extdata/MARS_stressors.csv", stringsAsFactors = F)

doc<-
  # testset %>% filter(country %in% input$countries) %>%
  df_to_krona(df = testset,
              name = test,
              magnitude = area,
              country, river.basin.district, first.stressor, second.stressor, third.stressor)

save_krona_xml(doc, "temp/test.xml")



kronawidget(doc)

htmlwidgets::saveWidget(kronawidget(doc), "../temp/saved_widget")

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
