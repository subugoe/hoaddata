# Test internal jn_ind dataset
testthat::test_that("jn_ind can be loaded as tibble", {
  testthat::expect_s3_class(jn_ind, "tbl_df")
})

testthat::test_that("jn_ind format is correct", {
  testthat::expect_equal(ncol(jn_ind), 6)
  testthat::expect_named(jn_ind,
                         c("issn_l", "cr_year", "cc",
                           "cc_total", "jn_all", "prop"))
  testthat::expect_gt(nrow(jn_ind), 35000)

  testthat::expect_true(is.factor(jn_ind$cr_year))
  testthat::expect_true(is.factor(jn_ind$cc))
})

testthat::test_that("jn_ind calculation worked", {
 testthat::expect_lte(max(jn_ind$prop, na.rm = TRUE), 1)
})
