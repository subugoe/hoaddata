# Test internal cr_upw dataset
testthat::test_that("cr_upw exists", {
  testthat::expect_s3_class(cr_upw, "tbl_df")
})

testthat::test_that("cr_upw straight counting", {
  testthat::expect_true(unique(
    purrr::map2_lgl(
      cr_upw$article_total, cr_upw$cr_hybrid_total,
      function(x, y) {
        x >= y
        }
      )
  ))
})
