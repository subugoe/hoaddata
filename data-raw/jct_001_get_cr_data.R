# JCT data gathering

# Note that journal-level data was gathered from the
# Journal Checker Tool outside of this package on 15 July.
# Because the Journal Checker Tool only contains current
# transformative agreements, an archived version from July 2021
# was also used.

jct_hybrid_jns <- readr::read_csv("data-raw/jct_hybrid_jns.csv")

# Upload to BQ
jct_hybrid_jns_path <-
  bigrquery::bq_table("hoad-dash", "jct", "jct_hybrid_jns")

if (bigrquery::bq_table_exists(jct_hybrid_jns_path)) {
  bigrquery::bq_table_delete(jct_hybrid_jns_path)
}
bigrquery::bq_table_upload(
  jct_hybrid_jns_path,
  jct_hybrid_jns
)
usethis::use_data(jct_hybrid_jns, overwrite = TRUE)

# Create Crossref metadata subset ----
create_bq_table(sql_basename = "cr_raw", dataset = "jct")

## Creative Commons licensing ----

### Metadata ----
create_bq_table(sql_basename = "cc_md", dataset = "jct")

### Creative Commons per journals ----
jct_jn_ind <- create_bq_table("cc_jn_ind", dataset = "jct", download = TRUE) |>
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

# Export as package data
usethis::use_data(jct_jn_ind, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_jn_ind, "data-raw/jct_jn_ind.csv")

## Affiliations (OpenAlex)  ----

### Metadata ----

# Article-level first author affiliation data, including dois
# where no affiliation data could be found
create_bq_table("cr_openalex_inst_full_raw", dataset = "jct")

# Extract iso2 country codes from address strings where OpenALEX
# found no match country code

# 1. Upload countrycode list

countrycodes <- countrycode::codelist[,c("iso2c", "country.name.en")]
colnames(countrycodes) <- c("iso2c", "country_name_en")
bg_countrycodes <- bigrquery::bq_table("hoad-dash", "jct", "countrycodes")

if (bigrquery::bq_table_exists(bg_countrycodes))
  bigrquery::bq_table_delete(bg_countrycodes)
bigrquery::bq_table_upload(bg_countrycodes,
                           countrycodes)

# 2. Extract and match country strings
create_bq_table("cr_openalex_inst_full", dataset = "jct")


### First-author affiliation data CC articles ----

# Article-level first author affiliation data CC licenses
jct_cc_inst <-
  create_bq_table("cc_openalex_inst", dataset = "jct", download = TRUE)
# Save in package
usethis::use_data(jct_cc_inst, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_cc_inst, "data-raw/jct_cc_aff.csv")

### Aggregated first-author country affiliations per hybrid journal and year ----

jct_jn_aff <-
  create_bq_table("cc_openalex_inst_jn_ind",
  dataset = "jct",
                  download = TRUE)
# Save in package
usethis::use_data(jct_jn_aff, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_jn_aff, "data-raw/jct_jn_aff.csv")

### Open Metadata ----

#### All
upw_cr <-  create_bq_table("cc_upw_cr", dataset = "jct", download = TRUE) |>
  dplyr::mutate(cat = "Global")

#### Germany
upw_cr_de <- create_bq_table("cc_upw_cr_de", dataset = "jct", download = TRUE) |>
  dplyr::mutate(cat = "Germany")

jct_cr_upw <- dplyr::bind_rows(upw_cr, upw_cr_de)
# Save in package
usethis::use_data(jct_cr_upw, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_cr_upw, "data-raw/jct_cr_upw.csv")

### Crossref metadata coverage CC-licenses articles 

#### Global
cc_md_indicators <- create_bq_table("cc_md_indicators", dataset = "jct", download = TRUE) 

#### Germany
cc_md_indicators_de <- create_bq_table("cc_md_indicators_de", dataset = "jct", download = TRUE)

jct_cr_md <- cc_md_indicators |>
  dplyr::mutate(cat = "Global") |>
  dplyr::bind_rows(cc_md_indicators_de) |>
  dplyr::mutate(cat = ifelse(is.na(cat), "Germany", cat)) |>
  dplyr::arrange(esac_publisher, cr_year)
# Save in package
usethis::use_data(jct_cr_md, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_cr_md, "data-raw/jct_cr_md.csv")

### OpenAlex Journal metadata ----
jct_oalex_venues <- create_bq_table("jct_oalex_venues",  dataset = "jct", download = TRUE)
# Save in package
usethis::use_data(jct_oalex_venues, overwrite = TRUE)

readr::write_csv(jct_oalex_venues, "data-raw/jct_oalex_venues.csv")

### Link country affiliations and TAs ----
jct_ta_country_output <-
  create_bq_table("ta_country_output", dataset = "jct", download = TRUE)
# Save in package
usethis::use_data(jct_ta_country_output, overwrite = TRUE)
# Save as csv
readr::write_csv(jct_ta_country_output, "data-raw/jct_ta_country_output.csv")
