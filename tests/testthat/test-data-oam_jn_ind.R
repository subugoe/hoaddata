# Test internal oam_jn_ind dataset
testthat::test_that("oam_jn_ind can be loaded as tibble", {
  testthat::expect_s3_class(oam_jn_ind, "tbl_df")
})

testthat::test_that("oam_jn_ind format is correct", {
  testthat::expect_equal(ncol(oam_jn_ind), 6)
  testthat::expect_named(oam_jn_ind,
                         c("cr_journal_id", "cr_year", "cc",
                           "cc_total", "jn_all", "prop"))
  testthat::expect_gt(nrow(oam_jn_ind), 35000)

  testthat::expect_true(is.factor(oam_jn_ind$cr_year))
  testthat::expect_true(is.factor(oam_jn_ind$cc))
})

testthat::test_that("oam_jn_ind calculation worked", {
 testthat::expect_lte(max(oam_jn_ind$prop, na.rm = TRUE), 1)
})
