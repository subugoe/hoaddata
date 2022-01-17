# Crossref analytics

# Executes analytics task on Big Query

# Create Crossref metadata subset ----
oam <- bigrquery::bq_dataset("hoad-dash", "oam")
bg_oam_cr_raw <- bigrquery::bq_table("hoad-dash", "oam", "cr_raw")

if (bigrquery::bq_table_exists(bg_oam_cr_raw))
  bigrquery::bq_table_delete(bg_oam_cr_raw)

cr_md_sql <-  readr::read_file(
system.file(package = "hoaddata", "inst/sql/cr_raw.sql")
)

bigrquery::bq_dataset_query(
  oam,
  query = cr_md_sql,
  destination_table = bg_oam_cr_raw
)

# Aggregation ----

## Journal publication volume by year ----
bg_oam_jn_by_year <- bigrquery::bq_table("hoad-dash", "oam", "oam_jn_by_year")

if (bigrquery::bq_table_exists(bg_oam_jn_by_year))
  bigrquery::bq_table_delete(bg_oam_jn_by_year)
oam_jn_by_year_sql <-  readr::read_file(
  system.file(package = "hoaddata", "inst/sql/oam_jn_by_year.sql")
)

bigrquery::bq_dataset_query(
  oam,
  query = oam_jn_by_year_sql,
  destination_table = bg_oam_jn_by_year
)

oam_jns_by_year <- bigrquery::bq_table_download(bg_oam_jn_by_year)
usethis::use_data(oam_jns_by_year, overwrite = TRUE)
