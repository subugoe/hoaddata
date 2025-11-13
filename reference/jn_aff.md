# First author country affiliations per journal, year and Creative Commons license

This dataset contains the number and proportion of open access articles
in hybrid journals by country, year and Creative Commons license
variant.

## Usage

``` r
jn_aff
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
1981677 rows and 6 columns.

## Details

Country affiliations were determined using the first author affiliation
as listed by OpenAlex. A first author is often considered as lead
author(<https://en.wikipedia.org/wiki/Lead_author>) who has usually
undertaken most of the research presented in the article, although
author roles can vary across disciplines.

Note that full counting in which every original article or review was
counted once per country of affiliation of the first authors was
applied. Because first authors can have multiple affiliations from
different countries, don't use this dataset, but
[`jn_ind`](https://subugoe.github.io/hoaddata/reference/jn_ind.md) to
determine a journal's publication volume.

Variables:

- issn_l:

  Linking ISSN

- cr_year:

  Earliest publication year (Crossref field \`issued\`)

- country_code:

  The country where this institution is located, represented as an ISO
  two-letter country code. (OpenAlex field \`country_code\`)

- cc:

  Normalized Creative Commons variant. `NA` represents articles, which
  were not provided under a CC license

- articles_under_cc_variant:

  Number of articles under Creative Commons variant, grouped by journal,
  year and country affiliation

- articles_total:

  Yearly journal output by year and country affiliation

## Examples

``` r
# Country output China vs Germany in Scientometrics (ISSN-L: 0138-9130)
  subset(jn_aff,
    issn_l %in% "0138-9130" & country_code %in% c("DE", "CN"))
#> # A tibble: 33 × 6
#>    issn_l    cr_year country_code cc    articles_under_cc_variant articles_total
#>    <chr>       <int> <chr>        <chr>                     <int>          <int>
#>  1 0138-9130    2025 DE           CC BY                         3              3
#>  2 0138-9130    2025 CN           CC BY                         1              6
#>  3 0138-9130    2025 CN           NA                            5              6
#>  4 0138-9130    2024 DE           CC BY                        17             19
#>  5 0138-9130    2024 CN           NA                           76             80
#>  6 0138-9130    2024 CN           CC BY                         4             80
#>  7 0138-9130    2024 DE           NA                            2             19
#>  8 0138-9130    2023 CN           NA                           75             79
#>  9 0138-9130    2023 CN           CC BY                         4             79
#> 10 0138-9130    2023 DE           CC BY                        15             15
#> # ℹ 23 more rows
```
