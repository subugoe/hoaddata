# Load external data
oam_hybrid_jns <- system.file("extdata", "oam_hybrid_jns.csv", package = "hoaddata")

testthat::test_that("Does OAM journal file exist?", {
  testthat::expect_true( file.exists(oam_hybrid_jns) )
})

testthat::test_that("Loading OAM journal file", {
  testthat::expect_s3_class(
    suppressMessages(readr::read_csv(oam_hybrid_jns)), "data.frame")
})

testthat::test_that("Checking OAM journal data structure", {
  tt <- suppressMessages(readr::read_csv(oam_hybrid_jns))

  testthat::expect_equal(ncol(tt), 4)
  testthat::expect_named(tt, c("vertrag", "journal", "issn", "issn_l"))
  testthat::expect_gt(nrow(tt), 10000)

  testthat::expect_equal(nrow(tt[is.na(tt$vertrag),]), 0)

})
