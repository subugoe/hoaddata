# Hybrid OA publishing output from first authors

This dataset comprises affiliation information from first authors for
each open access article published in hybrid journals as listed in
[oam_hybrid_jns](https://subugoe.github.io/hoaddata/reference/oam_hybrid_jns.md).

## Usage

``` r
cc_articles
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
1511229 rows and 6 columns.

## Details

A first author is often considered as lead author
(<https://en.wikipedia.org/wiki/Lead_author>) who has usually undertaken
most of the research presented in the article, although author roles can
vary across disciplines. We used OpenAlex as data source for determining
the lead author's affiliation.

In case where OpenAlex did not record an country affiliation, we
extracted country names from the display_name using regular expressions.

Variables:

- doi:

  DOI for the OA article

- issn_l:

  Linking ISSN

- cr_year:

  Earliest publication year (Crossref field \`issued\`)

- cc:

  Normalized Creative Commons variant.

- country_code:

  The country where this institution is located, represented as an ISO
  two-letter country code. (OpenAlex field \`country_code\` and extra
  country extraction)

- ror:

  ROR Organizational ID

To our knowledge, OpenAlex does not provide information about
corresponding authors and their affiliation.

## Examples

``` r
# Hybrid OA articles with lead author from Uni Göttingen
cc_articles[cc_articles$ror %in% "https://ror.org/01y9bpm73",]
#> # A tibble: 2,785 × 6
#>    doi                     issn_l    cr_year cc          country_code ror       
#>    <chr>                   <chr>       <int> <chr>       <chr>        <chr>     
#>  1 10.1002/1873-3468.13978 0014-5793    2020 CC BY-NC-ND DE           https://r…
#>  2 10.1002/1873-3468.14089 0014-5793    2021 CC BY-NC-ND DE           https://r…
#>  3 10.1002/1873-3468.14671 0014-5793    2023 CC BY-NC-ND DE           https://r…
#>  4 10.1002/adem.202201914  1438-1656    2023 CC BY-NC-ND DE           https://r…
#>  5 10.1002/adfm.202313619  1616-301X    2024 CC BY       DE           https://r…
#>  6 10.1002/adfm.202315559  1616-301X    2023 CC BY-NC    DE           https://r…
#>  7 10.1002/adfm.202409432  1616-301X    2024 CC BY-NC    DE           https://r…
#>  8 10.1002/adfm.202419990  1616-301X    2025 CC BY       DE           https://r…
#>  9 10.1002/adfm.202511897  1616-301X    2025 CC BY       DE           https://r…
#> 10 10.1002/adma.201907693  0935-9648    2020 CC BY       DE           https://r…
#> # ℹ 2,775 more rows
```
