# Test internal cc_articles dataset
testthat::test_that("cc_articles can be loaded as tibble", {
  testthat::expect_s3_class(cc_articles, "tbl_df")
})

testthat::test_that("cc_articles format is correct", {
  testthat::expect_equal(ncol(cc_articles), 7)
  testthat::expect_named(
    cc_articles,
    c(
      "doi",
      "issn_l",
      "cr_year",
      "cc",
      "country_code",
      "ror"
    )
  )
  testthat::expect_gt(nrow(cc_articles), 350000)
})

 testthat::test_that("cc_articles no duplicated journal ids", {
  tmp <- cc_articles %>%
    dplyr::distinct(doi, issn_l) %>%
    dplyr::group_by(doi) %>%
    dplyr::filter(dplyr::n() > 1)
  testthat::expect_equal(nrow(tmp), 0)
})

 testthat::test_that("cc_articles cc breakdown equal to cc_jn_df", {
   cc_1 <- jn_ind %>%
     dplyr::filter(!is.na(cc)) %>%
     # To Do: Should cc be factored according to level of permissiveness
     # throughout of hoaddata?
     dplyr::group_by(cc = as.character(cc)) %>%
     dplyr::summarise(articles = sum(cc_total)) %>%
     dplyr::arrange(dplyr::desc(articles))
   cc_2 <- cc_articles %>%
     dplyr::group_by(cc) %>%
     dplyr::summarise(articles = dplyr::n_distinct(doi)) %>%
     dplyr::arrange(dplyr::desc(articles))

   testthat::expect_equal(cc_1, cc_2)
 })
