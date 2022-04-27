# Test internal cc_openalex_inst dataset
testthat::test_that("cc_openalex_inst can be loaded as tibble", {
  testthat::expect_s3_class(cc_openalex_inst, "tbl_df")
})

testthat::test_that("cc_openalex_inst format is correct", {
  testthat::expect_equal(ncol(cc_openalex_inst), 7)
  testthat::expect_named(
    cc_openalex_inst,
    c(
      "doi",
      "cr_journal_id",
      "cr_year",
      "cc",
      "country_code",
      "id",
      "display_name"
    )
  )
  testthat::expect_gt(nrow(cc_openalex_inst), 350000)
})

testthat::test_that("cc_openalex_inst no duplicated journal ids", {
  tmp <- cc_openalex_inst %>%
    dplyr::distinct(doi, cr_journal_id) %>%
    dplyr::group_by(doi) %>%
    dplyr::filter(dplyr::n() > 1)
  testthat::expect_equal(nrow(tmp), 0)
})
