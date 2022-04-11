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
  readr::read_csv("http://ftp.crossref.org/titlelist/titleFile.csv")
# Clean Crossref journal title list
cr_issn_list <- cr_title_list %>%
  dplyr::select(JournalID, pissn, eissn, additionalIssns) %>%
  tidyr::separate(
    additionalIssns,
    c("additional_1", "additional_2"),
    sep = "; ",
    fill = "right"
  ) %>%
  tidyr::pivot_longer(
    c(pissn, eissn, additional_1, additional_2),
    names_to = "issn_type",
    values_to = "issn",
    values_drop_na = TRUE
  ) %>%
  dplyr::mutate(issn_norm = gsub("-", "", issn)) %>%
  dplyr::mutate(issn_norm = stringi::stri_sub_replace(issn_norm, 5, 4, value = "-"))
# Add Crossref info to OAM subset
oam_cr <- oam_new %>%
  dplyr::inner_join(cr_issn_list, by = c("issn" = "issn_norm")) %>%
  dplyr::distinct(vertrag, cr_journal_id = JournalID, issn, journal)

# Print journals, which could not be matched
oam_new %>%
  dplyr::filter(!journal %in% oam_cr$journal) %>%
  dplyr::distinct(journal)
# Obtain Crossref Journal IDs for all OAM journals that could be matched
oam_hybrid_jns <- oam_cr %>%
  dplyr::distinct(vertrag, cr_journal_id) %>%
  dplyr::inner_join(cr_issn_list, by = c("cr_journal_id" = "JournalID")) %>%
  dplyr::select(-issn,-issn_type) %>%
  dplyr::rename(issn = issn_norm, agreement = vertrag) %>%
  # Extract consortium leader
  tidyr::separate(agreement, c("agreement", "lead"), sep = " \\(") %>%
  dplyr::mutate(lead = gsub(")", "", lead))

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
