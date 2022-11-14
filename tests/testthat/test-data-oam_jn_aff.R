# Test internal oam_cc_inst dataset
testthat::test_that("oam_cc_inst can be loaded as tibble", {
  testthat::expect_s3_class(oam_cc_inst, "tbl_df")
})

testthat::test_that("oam_cc_inst format is correct", {
  testthat::expect_equal(ncol(oam_cc_inst), 7)
  testthat::expect_named(
    oam_cc_inst,
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
  testthat::expect_gt(nrow(oam_cc_inst), 350000)
})

testthat::test_that("oam_cc_inst no duplicated journal ids", {
  tmp <- oam_cc_inst %>%
    dplyr::distinct(doi, cr_journal_id) %>%
    dplyr::group_by(doi) %>%
    dplyr::filter(dplyr::n() > 1)
  testthat::expect_equal(nrow(tmp), 0)
})

testthat::test_that("oam_cc_inst cc breakdown equal to cc_jn_df", {
  cc_1 <- oam_jn_ind %>%
    dplyr::filter(!is.na(cc)) %>%
    # To Do: Should cc be factored according to level of permissiveness
    # throughout of hoaddata?
    dplyr::group_by(cc = as.character(cc)) %>%
    dplyr::summarise(articles = sum(cc_total)) %>%
    dplyr::arrange(dplyr::desc(articles))
  cc_2 <- oam_cc_inst %>%
    dplyr::group_by(cc) %>%
    dplyr::summarise(articles = dplyr::n_distinct(doi)) %>%
    dplyr::arrange(dplyr::desc(articles))

  testthat::expect_equal(cc_1, cc_2)
})
