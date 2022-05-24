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
  sql_string <-
    system.file(package = "hoaddata", paste0("inst/sql/", sql_basename, ".sql"))
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

### Creative Commons per journals ----
cc_jn_ind <- create_bq_table("cc_jn_ind", download = TRUE) |>
  dplyr::mutate(cr_year = factor(cr_year))  |>
  dplyr::mutate(cc = factor(
    cc,
    # Order by permissiveness
    levels = c(
      "CC BY",
      "CC BY-SA",
      "CC BY-NC",
      "CC BY-NC-SA",
      "CC BY-ND",
      "CC BY-NC-ND"
    )
  )) |>
  dplyr::mutate(across(c(cc_total, prop), ~ tidyr::replace_na(., 0)))

usethis::use_data(cc_jn_ind, overwrite = TRUE)
# Save as cvs
readr::write_csv(cc_jn_ind, "cc_jn_ind.csv")

## Affiliations (OpenAlex)  ----

### Metadata ----

# Article-level first author affiliation data, including dois
# where no affiliation data could be found
create_bq_table("cr_openalex_inst_full_raw")

# Extract iso2 country codes from adress strings where OpenALEX
# found no match country code

# 1. Upload countrycode list

countrycodes <- countrycode::codelist[,c("iso2c", "country.name.en")]
colnames(countrycodes) <- c("iso2c", "country_name_en")
bg_countrycodes <- bigrquery::bq_table("hoad-dash", "oam", "countrycodes")

if (bigrquery::bq_table_exists(bg_countrycodes))
  bigrquery::bq_table_delete(bg_countrycodes)
bigrquery::bq_table_upload(bg_countrycodes,
                           countrycodes)

# 2. Extract and match country strings
create_bq_table("cr_openalex_inst_full")


### First-author affiliation data CC articles ----

# Article-level first author affiliation data CC licenses
cc_openalex_inst <-
  create_bq_table("cc_openalex_inst", download = TRUE)
usethis::use_data(cc_openalex_inst, overwrite = TRUE)
# Save as csv
readr::write_csv(cc_openalex_inst, "cc_openalex_inst")


### Aggregated first-author country affiliations per hybrid journal and year ----

cc_openalex_inst_jn_ind <-
  create_bq_table("cc_openalex_inst_jn_ind",
                  download = TRUE)

usethis::use_data(cc_openalex_inst_jn_ind, overwrite = TRUE)
# Save as csv
readr::write_csv(cc_openalex_inst_jn_ind, "cc_openalex_inst_jn_ind")
