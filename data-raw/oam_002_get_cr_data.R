# OAM 
# Create Crossref metadata subset ----
create_bq_table(sql_basename = "cr_raw")

## Creative Commons licensing ----

### Metadata ----
create_bq_table(sql_basename = "cc_md")

### Creative Commons per journals ----
oam_jn_ind <- create_bq_table("cc_jn_ind", download = TRUE) |>
  dplyr::mutate(cr_year = factor(cr_year)) |>
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

usethis::use_data(oam_jn_ind, overwrite = TRUE)
# Save as cvs
readr::write_csv(oam_jn_ind, "data-raw/oam_jn_ind.csv")

## Affiliations (OpenAlex)  ----

### Metadata ----

# Article-level first author affiliation data, including dois
# where no affiliation data could be found
create_bq_table("cr_openalex_inst_full_raw")

# Extract iso2 country codes from adress strings where OpenALEX
# found no match country code

# 1. Upload countrycode list

countrycodes <- countrycode::codelist[, c("iso2c", "country.name.en")]
colnames(countrycodes) <- c("iso2c", "country_name_en")
bg_countrycodes <- bigrquery::bq_table("hoad-dash", "oam", "countrycodes")

if (bigrquery::bq_table_exists(bg_countrycodes)) {
  bigrquery::bq_table_delete(bg_countrycodes)
}
bigrquery::bq_table_upload(
  bg_countrycodes,
  countrycodes
)

# 2. Extract and match country strings
create_bq_table("cr_openalex_inst_full")

### First-author affiliation data CC articles ----

# Article-level first author affiliation data CC licenses
oam_cc_inst <-
  create_bq_table("cc_openalex_inst", download = TRUE)
usethis::use_data(oam_cc_inst, overwrite = TRUE)
# Save as csv
readr::write_csv(oam_cc_inst, "data-raw/oam_cc_inst.csv")

### Aggregated first-author country affiliations per hybrid journal and year ----

oam_jn_aff <-
  create_bq_table("cc_openalex_inst_jn_ind",
    download = TRUE
  )

usethis::use_data(oam_jn_aff, overwrite = TRUE)
# Save as csv
readr::write_csv(oam_jn_aff, "data-raw/oam_jn_aff.csv")

## Metadata assessment

oam_cr_md <- create_bq_table("cc_md_indicators",
  download = TRUE
)

usethis::use_data(oam_cr_md, overwrite = TRUE)
# Save as csv
readr::write_csv(oam_cr_md, "data-raw/oam_cr_md.csv")
