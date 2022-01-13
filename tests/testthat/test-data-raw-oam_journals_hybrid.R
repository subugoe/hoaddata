# Load external data
oam_hybrid_jns <- system.file("extdata", "oam_hybrid_jns.csv", package = "hoaddata")

testthat::test_that("Locating OAM journal file", {
  testthat::expect_true( file.exists(oam_hybrid_jns) )
})

testthat::test_that("Loading OAM journal file", {
  testthat::expect_s3_class(
    suppressMessages(readr::read_csv(oam_hybrid_jns)), "data.frame")
})

testthat::test_that("Checking data structure", {
  tt <- testthat::expect_s3_class(
    suppressMessages(readr::read_csv(oam_hybrid_jns)), "data.frame")
  testthat::expect_equal(ncol(tt), 3)
  testthat::expect_named(tt, c("vertrag", "issn_l", "issn"))
  testthat::expect_gt(nrow(tt), 10000)

  testthat::expect_equal(nrow(tt[is.na(tt$vertrag),]), 0)
  testthat::expect_equal(nrow(tt[is.na(tt$issn_l),]), 0)
  testthat::expect_equal(nrow(tt[is.na(tt$issn),]), 0)

})
