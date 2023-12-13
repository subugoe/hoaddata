# Test internal cr_upw dataset
testthat::test_that("jct_hybrid_jns exists", {
  testthat::expect_s3_class(cr_upw, "jct_hybrid_jns")
})

testthat::test_that("jct_hybrid_jns de gruyter is normalized", {
  testthat::expect_equal(
    length(
      unique(
        jct_hybrid_jns[grepl("walter", jct_hybrid_jns$esac_publisher, ignore.case = TRUE), "esac_publisher"]
        )
      ), 1
    )
})
