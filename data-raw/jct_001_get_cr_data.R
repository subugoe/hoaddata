# JCT data gathering
pkgload::load_all()

#' Authentificate with Big Query
#' 
#'Decrypting-ability using internal secret_* functions from gargle
# package following bigrquery test setup.
# <https://gargle.r-lib.org/articles/articles/managing-tokens-securely.html>
#' 
if (gargle:::secret_can_decrypt(package = "hoaddata")) {
  gc_json <-
    gargle:::secret_read(package = "hoaddata", name = "hoaddata-bq.json")
  bigrquery::bq_auth(path = rawToChar(gc_json))
}

# Note that journal-level data was gathered from the
# Journal Checker Tool outside of this package on 15 July.
# Because the Journal Checker Tool only contains current
# transformative agreements, an archived version from July 2021
# was also used.

jct_hybrid_jns <- readr::read_csv("data-raw/jct_hybrid_jns.csv")

# Upload to BQ
jct_hybrid_jns_path <-
  bigrquery::bq_table("hoad-dash", "hoaddata", "jct_hybrid_jns")

if (bigrquery::bq_table_exists(jct_hybrid_jns_path)) {
  bigrquery::bq_table_delete(jct_hybrid_jns_path)
}
bigrquery::bq_table_upload(
  jct_hybrid_jns_path,
  jct_hybrid_jns
)
usethis::use_data(jct_hybrid_jns, overwrite = TRUE)

# OAM data

# Cleaned and enriched version of OAM data
# <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>

oam_hybrid_jns <- readr::read_csv("data-raw/oam_hybrid_jns.csv")

# Upload to BQ
oam_hybrid_jns_path <-
  bigrquery::bq_table("hoad-dash", "hoaddata", "oam_hybrid_jns")

if (bigrquery::bq_table_exists(oam_hybrid_jns_path)) {
  bigrquery::bq_table_delete(oam_hybrid_jns_path)
}
bigrquery::bq_table_upload(
  oam_hybrid_jns_path,
  oam_hybrid_jns
)
usethis::use_data(oam_hybrid_jns, overwrite = TRUE)

# Article data

# Create Crossref metadata subset ----
create_bq_table(sql_basename = "cr_raw")

## Creative Commons licensing ----

### Metadata ----
create_bq_table(sql_basename = "cc_md")

### Creative Commons per journals ----
jn_ind <- create_bq_table("cc_jn_ind", download = TRUE) |>
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
usethis::use_data(jn_ind, overwrite = TRUE)
# Save as csv
readr::write_csv(jn_ind, "data-raw/jn_ind.csv")

## Affiliations (OpenAlex)  ----

### Metadata ----

# Article-level first author affiliation data, including dois
# where no affiliation data could be found
create_bq_table("cr_openalex_inst_full_raw")

# Extract iso2 country codes from address strings where OpenALEX
# found no match country code

# 1. Upload countrycode list

countrycodes <- countrycode::codelist[,c("iso2c", "country.name.en")]
colnames(countrycodes) <- c("iso2c", "country_name_en")
bg_countrycodes <- bigrquery::bq_table("hoad-dash", "hoaddata", "countrycodes")

if (bigrquery::bq_table_exists(bg_countrycodes))
  bigrquery::bq_table_delete(bg_countrycodes)
bigrquery::bq_table_upload(bg_countrycodes,
                           countrycodes)

# 2. Extract and match country strings
create_bq_table("cr_openalex_inst_full")


### First-author affiliation data CC articles ----

# Article-level first author affiliation data CC licenses
cc_articles <-
  create_bq_table("cc_openalex_inst", download = TRUE)
# Save in package
usethis::use_data(cc_articles, overwrite = TRUE)
# Save as csv
readr::write_csv(cc_articles, "data-raw/cc_articles.csv")

### Aggregated first-author country affiliations per hybrid journal and year ----

jn_aff <-
  create_bq_table("cc_openalex_inst_jn_ind",
  dataset = "hoaddata",
                  download = TRUE)
# Save in package
usethis::use_data(jn_aff, overwrite = TRUE)
# Save as csv
readr::write_csv(jn_aff, "data-raw/jn_aff.csv")

### Open Metadata ----

#### All
upw_cr <-  create_bq_table("cc_upw_cr", download = TRUE) |>
  dplyr::mutate(cat = "Global")

#### Germany
upw_cr_de <- create_bq_table("cc_upw_cr_de", download = TRUE) |>
  dplyr::mutate(cat = "Germany")

cr_upw <- dplyr::bind_rows(upw_cr, upw_cr_de)
# Save in package
usethis::use_data(cr_upw, overwrite = TRUE)
# Save as csv
readr::write_csv(cr_upw, "data-raw/cr_upw.csv")

### Crossref metadata coverage CC-licenses articles 

#### Global
cc_md_indicators <- create_bq_table("cc_md_indicators", download = TRUE) 

#### Germany
cc_md_indicators_de <- create_bq_table("cc_md_indicators_de", download = TRUE)

cr_md <- cc_md_indicators |>
  dplyr::mutate(cat = "Global") |>
  dplyr::bind_rows(cc_md_indicators_de) |>
  dplyr::mutate(cat = ifelse(is.na(cat), "Germany", cat)) |>
  dplyr::arrange(issn_l, cr_year)
# Save in package
usethis::use_data(cr_md, overwrite = TRUE)
# Save as csv
readr::write_csv(cr_md, "data-raw/cr_md.csv")

### OpenAlex Journal metadata ----
jct_oalex_venues <- create_bq_table("jct_oalex_venues", download = TRUE)
# Save in package
usethis::use_data(jct_oalex_venues, overwrite = TRUE)

readr::write_csv(jct_oalex_venues, "data-raw/jct_oalex_venues.csv")

### Link country affiliations and TAs ----
jct_inst <- readr::read_csv("data-raw/jct_institutions.csv")
jct_inst_short <- jct_inst |>
  dplyr::distinct(esac_id, ror_id) |>
  # Remove orgs without ror id 
  dplyr::filter(!is.na(ror_id)) 

# Upload to BQ
jct_inst_short_path <-
  bigrquery::bq_table("hoad-dash", "hoaddata", "jct_inst_short")

if (bigrquery::bq_table_exists(jct_inst_short_path)) {
  bigrquery::bq_table_delete(jct_inst_short_path)
}
bigrquery::bq_table_upload(
  jct_inst_short_path,
  jct_inst_short
)
# Map institutions to journals
create_bq_table("esac_jn_inst")

ta_country_output <-
  create_bq_table("ta_country_output", download = TRUE)
# Save in package
usethis::use_data(ta_country_output, overwrite = TRUE)
# Save as csv
readr::write_csv(ta_country_output, "data-raw/jct_ta_country_output.csv")