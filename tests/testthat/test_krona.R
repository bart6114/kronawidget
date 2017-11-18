test_file <- system.file("extdata", "MARS_stressors.csv", package="kronawidget")
test_doc_file <- system.file("extdata", "test_doc.Rdata", package="kronawidget")

testset <- read.csv2(test_file, stringsAsFactors = F)

doc<- df_to_krona(df = testset,
                  name = "test",
                  magnitude = "area",
                  "country", "river.basin.district", "first.stressor", "second.stressor")

#saveRDS(doc, "inst/extdata/test_doc.Rdata")
test_doc <- readRDS(test_doc_file)

# test 1
test_that("Test df_to_krona", {
  expect_equal(doc$krona$node$magnitude$val, testset$area %>% sum())
})

# test 2
test_that("Test kronawidget", {
  y <- kronawidget(doc)
  expect_s3_class(y, c("kronawidget", "htmlwidget"))
})

# test 3
test_that("Test doc equal to doc test", {
  expect_equal(doc, test_doc)
})
