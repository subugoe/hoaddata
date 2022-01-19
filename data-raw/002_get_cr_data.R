# Crossref analytics

# Helper function ----

#' @param  sql_basename basename of sql file in inst/sql
#' @param  project BigQuery project
#' @param dataset BigQuery dataset
#' @param download download save result locally?
#'
create_bq_table <- function(sql_basename = NULL,
                            project = "hoad-dash",
                            dataset = "oam",
                            download = FALSE) {
  # Refer to Big Query dataset
  oam <- bigrquery::bq_dataset(project, dataset)
  # Refer to Big Query table
  dest <- bigrquery::bq_table(project, dataset, sql_basename)

  if (bigrquery::bq_table_exists(dest))
    bigrquery::bq_table_delete(dest)

  # Read sql query
  sql_string <- system.file(package = "hoaddata", paste0("inst/sql/", sql_basename, ".sql"))
  if (sql_string == "")
    stop(paste(sql, "file not found"))
  sql_ <-  readr::read_file(sql_string)

  # Execute sql
  bigrquery::bq_dataset_query(oam,
                              query = sql_,
                              destination_table = dest)
  if (isTRUE(download))
    bigrquery::bq_table_download(dest)
}

# Create Crossref metadata subset ----
create_bq_table(sql_basename = "cr_raw")

# Aggregation ----

## Journal publication volume by year ----
oam_jn_by_year <- create_bq_table(sql_basename = "oam_jn_by_year",
                                  download = TRUE)
#save as internal data
oam_jn_by_year |>
  usethis::use_data(overwrite = TRUE)

## Creative Commons licensing ----

create_bq_table(sql_basename = "cc_md")

