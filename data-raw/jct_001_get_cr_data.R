# JCT data gathering
pkgload::load_all()

#' Authenticate with Big Query
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
# Journal Checker Tool outside of this package on 15 July 2022
# and 8 May 2023.
# Because the Journal Checker Tool only contains current
# transformative agreements, an archived version from July 2021
# was also used.

jct_hybrid_jns_raw <- readr::read_csv("data-raw/jct_hybrid_jns.csv")

# Fix publisher names and remove manually identified full oa journals
jct_hybrid_jns <- jct_hybrid_jns_raw |>
    dplyr::mutate(esac_publisher = gsub("&", "and", esac_publisher)) |>
    dplyr::filter(!issn_l %in% c("2769-2485", "2666-6278", "2772-5642",
    "2772-6967", "1097-3702", "2768-7228", "1869-3660", "2666-9587",
    "2589-8892", "2321-0656", "2642-3588", "2667-3681", "2590-0315",
    "1746-6202", "0943-4747", "2352-3727", "2748-1964", "2516-6042",
    "2747-7460", "0012-9623", "2804-7214", "2694-0884", "2694-085X"))

# Upload to BQ
jct_hybrid_jns_path <-
  bigrquery::bq_table("subugoe-collaborative", "hoaddata", "jct_hybrid_jns")

if (bigrquery::bq_table_exists(jct_hybrid_jns_path)) {
  bigrquery::bq_table_delete(jct_hybrid_jns_path)
}
bigrquery::bq_table_upload(
  jct_hybrid_jns_path,
  jct_hybrid_jns
)
usethis::use_data(jct_hybrid_jns, overwrite = TRUE)

# # OAM data

# # Cleaned and enriched version of OAM data
# # <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>

 oam_hybrid_jns <- readr::read_csv("data-raw/oam_hybrid_jns.csv")

# # Upload to BQ
 oam_hybrid_jns_path <-
   bigrquery::bq_table("subugoe-collaborative", "hoaddata", "oam_hybrid_jns")

 if (bigrquery::bq_table_exists(oam_hybrid_jns_path)) {
   bigrquery::bq_table_delete(oam_hybrid_jns_path)
 }
 bigrquery::bq_table_upload(
   oam_hybrid_jns_path,
   oam_hybrid_jns
)
 usethis::use_data(oam_hybrid_jns, overwrite = TRUE)

# # Combine both journal tables
# hybrid_jns <- oam_hybrid_jns |>
#   dplyr::filter(!issn_l %in% jct_hybrid_jns$issn_l) |>
#   dplyr::bind_rows(jct_hybrid_jns) |>
#   dplyr::distinct()

# # Upload to BQ
# hybrid_jns_path <-
#   bigrquery::bq_table("subugoe-collaborative", "hoaddata", "hybrid_jns")

# if (bigrquery::bq_table_exists(hybrid_jns_path)) {
#   bigrquery::bq_table_delete(hybrid_jns_path)
# }
# bigrquery::bq_table_upload(
#   hybrid_jns_path,
#   hybrid_jns
# )

# # Article data

# # Create Crossref metadata subset ----
# create_bq_table(sql_basename = "cr_raw")

# ## Creative Commons licensing ----

# ### Metadata ----
# # All CC-licensed articles
# create_bq_table(sql_basename = "cc_md_all")
# # Exclude journals with OA proportion > .95
# create_bq_table(sql_basename = "cc_oa_prop")
# # Final article-level CC metadata
# create_bq_table(sql_basename = "cc_md")

# ### Creative Commons per journals ----
# jn_ind <- create_bq_table("cc_jn_ind", download = TRUE) |>
#   dplyr::mutate(cr_year = factor(cr_year))  |>
#   dplyr::mutate(cc = factor(
#     cc,
#     # Order by permissiveness
#     levels = c(
#       "CC BY",
#       "CC BY-SA",
#       "CC BY-NC",
#       "CC BY-NC-SA",
#       "CC BY-ND",
#       "CC BY-NC-ND"
#     )
#   )) |>
#   dplyr::mutate(across(c(cc_total, prop), ~ tidyr::replace_na(., 0)))

# # Export as package data
# usethis::use_data(jn_ind, overwrite = TRUE)


# ## Affiliations (OpenAlex)  ----

# ### Metadata ----

# # Article-level first author affiliation data, including dois
# # where no affiliation data could be found
# create_bq_table("cr_openalex_inst_full_raw")

# # Extract iso2 country codes from address strings where OpenALEX
# # found no match country code

# # 1. Upload countrycode list

# countrycodes <- countrycode::codelist[, c("iso2c", "country.name.en")]
# colnames(countrycodes) <- c("iso2c", "country_name_en")
# bg_countrycodes <- bigrquery::bq_table("subugoe-collaborative", "hoaddata", "countrycodes")

# if (bigrquery::bq_table_exists(bg_countrycodes)) {
#   bigrquery::bq_table_delete(bg_countrycodes)
# }
# bigrquery::bq_table_upload(
#   bg_countrycodes,
#   countrycodes
# )

# # 2. Extract and match country strings
# create_bq_table("cr_openalex_inst_full")

# ### First-author affiliation data CC articles ----

# # Article-level first author affiliation data CC licenses
# cc_articles <-
#   create_bq_table("cc_openalex_inst", download = TRUE)
# # Save in package
# usethis::use_data(cc_articles, overwrite = TRUE)


# ### Aggregated first-author country affiliations per hybrid journal and year ----

# jn_aff <-
#   create_bq_table("cc_openalex_inst_jn_ind",
#   dataset = "hoaddata",
#                   download = TRUE)
# # Save in package
# usethis::use_data(jn_aff, overwrite = TRUE)

# ### Open Metadata ----

# #### License gaps
# cr_upw <-  create_bq_table("cc_upw_cr", download = TRUE)
# # Save in package
# usethis::use_data(cr_upw, overwrite = TRUE)


# ### Crossref metadata coverage CC-licenses articles

# #### Global
# cc_md_indicators <- create_bq_table("cc_md_indicators", download = TRUE)

# #### Germany
# cc_md_indicators_de <- create_bq_table("cc_md_indicators_de", download = TRUE)

# cr_md <- cc_md_indicators |>
#   dplyr::mutate(cat = "Global") |>
#   dplyr::bind_rows(cc_md_indicators_de) |>
#   dplyr::mutate(cat = ifelse(is.na(cat), "Germany", cat)) |>
#   dplyr::arrange(issn_l, cr_year)
# # Save in package
# usethis::use_data(cr_md, overwrite = TRUE)


# ### OpenAlex Journal metadata ----
# jct_oalex_venues <- create_bq_table("jct_oalex_venues", download = TRUE)
# # Fix duplicate URLs
# jct_oalex_venues <- jct_oalex_venues |>
#   dplyr::distinct(issn_l, .keep_all = TRUE)
# # Save in package
# usethis::use_data(jct_oalex_venues, overwrite = TRUE)


# ### Link country affiliations and TAs ----
# jct_inst <- readr::read_csv("data-raw/jct_institutions.csv")

# # Upload to BQ
# jct_inst_path <-
#   bigrquery::bq_table("subugoe-collaborative", "hoaddata", "jct_inst")

# if (bigrquery::bq_table_exists(jct_inst_path)) {
#   bigrquery::bq_table_delete(jct_inst_path)
# }
# bigrquery::bq_table_upload(
#   jct_inst_path,
#   jct_inst
# )
# # Add associated institutions
#  create_bq_table("jct_inst_enriched")

# # Obtain publication statistics for institutions 
# # participating in transformative agreements (TA)
# create_bq_table("ta_oa_inst")

# # Save in GCS
# ta_oa_inst_path <- bigrquery::bq_table("subugoe-collaborative", "hoaddata", "ta_oa_inst")
# bigrquery::bq_table_save(ta_oa_inst_path, "gs://hoaddata/ta_oa_inst.csv.gz", destination_format = "csv")
# # usethis::use_data(ta_country_output, overwrite = TRUE)
