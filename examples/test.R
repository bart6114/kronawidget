
library(kronawidget)

## load test data
data(testdata)
testset<-testdata

## generate krona data object
doc<-
  df_to_krona(df = testset,
              name = "test",
              magnitude = "area",
              "country", "river.basin.district", "first.stressor", "second.stressor")#, "third.stressor")

## generate krona widget
kronawidget(doc)


## save krona widget
# htmlwidgets::saveWidget(kronawidget(doc), "../temp/saved_widget")
