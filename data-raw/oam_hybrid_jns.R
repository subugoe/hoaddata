# Code to prepare `oam_hybrid_jns`
pkgload::load_all()

## Load cleaned and enriched hybrid journal list from FZ Jülich (oam_hybrid_jns)
oam_hybrid_jns <- system.file(package = "hoaddata",
                              "inst/extdata/oam_hybrid_jns.csv")
oam_hybrid_jns <- readr::read_csv(oam_hybrid_jns)

### Save as package data
usethis::use_data(oam_hybrid_jns, overwrite = TRUE)

## Load hybrid oa journal list to Big Query

### Auth BQ: Decrypt Google Cloud secret service token

# Implements decrypt-ability using internal secret_* functions from gargle
# package following bigrquery test setup.
# <https://gargle.r-lib.org/articles/articles/managing-tokens-securely.html>
decrypt_gc_secret <-
  function(package = "hoaddata", name = "hoaddata-bq.json")
    if (gargle:::secret_can_decrypt(package)) {
      json <- gargle:::secret_read(package, name)
      rawToChar(json)
    }

bigrquery::bq_auth(path = decrypt_gc_secret)

### Upload to BQ
bg_oam_journals <- bigrquery::bq_table("hoad-dash", "oam", "oam_hybrid_jns")

if (bigrquery::bq_table_exists(bg_oam_journals))
  bigrquery::bq_table_delete(bg_oam_journals)
bigrquery::bq_table_upload(bg_oam_journals,
                           oam_hybrid_jns)
