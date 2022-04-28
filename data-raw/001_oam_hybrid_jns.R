# Code to prepare `oam_hybrid_jns`
pkgload::load_all()

# Load cleaned and enriched list of journals under transformative agreements in
# Germany from FZ Jülich
oam_jns <- system.file(package = "hoaddata",
                              "inst/extdata/oam_hybrid_jns.csv") %>%
  readr::read_csv()
oam_new <- oam_jns %>%
  tidyr::pivot_longer(c(issn, issn_l),
                      names_to = "issn_type", values_to = "issn") %>%
  # Only hybrid journals
  dplyr::filter(!grepl("Gold", vertrag))

# Load Crossref journal title list
cr_title_list <-
  readr::read_csv("http://ftp.crossref.org/titlelist/titleFile.csv") %>%
  dplyr::mutate(years = stringr::str_extract_all(`(year1)[volume1]issue1,issue2,issue3(year2)[volume2]issue4,issues5`,
                                                                                                    "[0-9]{4}+"))

# Clean Crossref journal title list
cr_issn_list <- cr_title_list %>%
  dplyr::select(JournalID, pissn, eissn, years) %>%
  tidyr::pivot_longer(
    c(pissn, eissn),
    names_to = "issn_type",
    values_to = "issn",
    values_drop_na = TRUE
  ) %>%
  dplyr::mutate(issn_norm = gsub("-", "", issn)) %>%
  dplyr::mutate(issn_norm = stringi::stri_sub_replace(issn_norm, 5, 4, value = "-"))


# Manual fix missing journals
manual_fixed_jns <- tibble::tribble(
  ~vertrag, ~cr_journal_id, ~issn, ~journal,
  "Springer Hybrid (DEAL)",49459,"2373-8529","Financial Markets and Portfolio Management",
  # Europe Economics Review and Eurasian Business Review share the same Journal
  # ID, we created an id for Eurasian Economic Review
  "Springer Hybrid (DEAL)", 11111111, "1309-422X","Eurasian Economic Review",
  "Springer Hybrid (DEAL)", 11111111, "2147-429X","Eurasian Economic Review",
)

# Add Crossref info to OAM subset
oam_cr <- oam_new %>%
  dplyr::inner_join(cr_issn_list, by = c("issn" = "issn_norm")) %>%
  dplyr::distinct(vertrag, cr_journal_id = JournalID, issn, journal, years) %>%
  dplyr::mutate(years = purrr::map(years, function(x) grep("^20[0-2]", x, value = TRUE))) %>%
  dplyr::mutate(years = purrr::map(years, function(x) sort(x))) %>%
  dplyr::mutate(end_year = purrr::map_chr(years, dplyr::last)) %>%
  # manual curation
  # 1. add missing journals
  dplyr::bind_rows(manual_fixed_jns) %>%
  # Exclude journals with duplicated ids
  dplyr::filter(!cr_journal_id %in% c(180565, 14676, 32798, 170806,
                                      312652, 36938, 18036, 45500,
                                      32278, 32798, 776, 72787,
                                      466211, 114285, 265229, 306690)) %>%
  # Exclude journals that ended before 2017
  dplyr::filter(end_year %in% c(as.character(2017:2029), NA))

# Print journals, which could not be matched
oam_new %>%
  dplyr::filter(!journal %in% oam_cr$journal) %>%
  dplyr::distinct(journal)

# Obtain Crossref Journal IDs for all OAM journals that could be matched
oam_hybrid_jns <- oam_cr %>%
  # Extract consortium leader
  tidyr::separate(vertrag, c("agreement", "lead"), sep = " \\(") %>%
  dplyr::mutate(lead = gsub(")", "", lead)) %>%
  dplyr::select(-years)

### Save as package data
usethis::use_data(oam_hybrid_jns, overwrite = TRUE)

## Load hybrid oa journal list to Big Query

### Auth BQ: Decrypt Google Cloud secret service token

# Decrypting-ability using internal secret_* functions from gargle
# package following bigrquery test setup.
# <https://gargle.r-lib.org/articles/articles/managing-tokens-securely.html>
if (gargle:::secret_can_decrypt(package = "hoaddata")) {
  gc_json <-
    gargle:::secret_read(package = "hoaddata", name = "hoaddata-bq.json")
  bigrquery::bq_auth(path = rawToChar(gc_json))
}

### Upload to BQ
bg_oam_journals <-
  bigrquery::bq_table("hoad-dash", "oam", "oam_hybrid_jns")

if (bigrquery::bq_table_exists(bg_oam_journals))
  bigrquery::bq_table_delete(bg_oam_journals)
bigrquery::bq_table_upload(bg_oam_journals,
                           oam_hybrid_jns)
