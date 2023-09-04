# Test Hybrid OA articles
testthat::test_that("cc_articles exists", {
  testthat::expect_s3_class(cc_articles, "tbl_df")
})

testthat::test_that("cc_articles has OA article", {
  testthat::expect_equal(
    nrow(unique(
      cc_articles[cc_articles$doi == "10.1002/2016jc012241", "doi"]
    )),
    1
  )
})

testthat::test_that("cc_articles has OA article", {
  testthat::expect_equal(
    nrow(unique(
      cc_articles[cc_articles$doi == "10.1002/asi.24460", "doi"]
    )),
    1
  )
})
