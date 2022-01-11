## code to prepare `oam_hybrid_jns.R` dataset goes here
pkgload::load_all()
#' Load cleaned and enriched hybrid journal list from FZ Jülich
oam_hybrid_jns <- system.file(package = "hoaddata",
                              "inst/extdata/oam_hybrid_jns.csv")
oam_hybrid_jns <- readr::read_csv(oam_hybrid_jns)
#' make it available to package users
usethis::use_data(oam_hybrid_jns, overwrite = TRUE)
#' Upload oam_df to Big Query project
json <- gargle:::secret_read("hoaddata", "hoaddata-bq.json")
bigrquery::bq_auth(path = rawToChar(json))
bg_oam_journals <-
  bigrquery::bq_table("hoad-dash", "oam", "oam_hybrid_jns")
if (bigrquery::bq_table_exists(bg_oam_journals))
  bigrquery::bq_table_delete(bg_oam_journals)
bigrquery::bq_table_upload(bg_oam_journals,
                           oam_df)

