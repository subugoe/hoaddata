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

## Creative Commons licensing ----

### Metadata ----
create_bq_table(sql_basename = "cc_md")

### Indicator ----
cc_jn_ind <- create_bq_table("cc_jn_ind", download = TRUE) |>
  dplyr::mutate(cr_year = factor(cr_year))  |>
  dplyr::mutate(cc = factor(cc,
                               # Order by permissiveness
                               levels = c("CC BY", "CC BY-SA",
                                          "CC BY-NC", "CC BY-NC-SA",
                                          "CC BY-ND", "CC BY-NC-ND")))
usethis::use_data(cc_jn_ind, overwrite = TRUE)

## Affiliations (openalex)

cr_olax_inst <- create_bq_table("cr_oalex_inst", download = TRUE)
usethis::use_data(cr_olax_inst, overwrite = TRUE)


