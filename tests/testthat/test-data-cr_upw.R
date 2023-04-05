# Test internal cr_upw dataset
testthat::test_that("cr_upw exists", {
  testthat::expect_s3_class(cr_upw, "tbl_df")
})

testthat::test_that("cr_upw straight counting", {
  testthat::expect_true(unique(
    mapply(function(x, y) {
        x >= y
        },
        cr_upw$article_total,
        cr_upw$cr_hybrid_total
      )
  ))
})
