# Crossref Metadata Coverage

This dataset gives information about metadata coverage per year and
agreement.

## Usage

``` r
cr_md
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
84833 rows and 9 columns.

## Details

The following Crossref metadata were analysed:

- cr_year:

  Earliest publication year (Crossref field \`issued\`)

- issn_l:

  Linking ISSN

- articles_total:

  Yearly journal output by year and country affiliation

- tdm_total:

  The number of articles containing full text URLs in the metadata

- orcid_total:

  The number of articles containing at least one ORCID in the metadata

- funder_total:

  The number of articles with funding metadata

- abstract_total:

  The number of articles with open abstracts

- ref_total:

  The number of articles with open reference lists)

- cat:

  Global output or from first-authors based in Germany

## Examples

``` r
# OA Articles in Scientometrics from first-authors in Germany: Metadata coverage
cr_md[cr_md$issn_l == "0138-9130" & cr_md$cat == "Germany",]
#> # A tibble: 9 × 9
#>   cr_year issn_l article_total tdm_total orcid_total funder_total abstract_total
#>     <int> <chr>          <int>     <int>       <int>        <int>          <int>
#> 1    2017 0138-…             7         7           3            4              0
#> 2    2018 0138-…             5         5           4            1              0
#> 3    2019 0138-…             6         6           5            1              2
#> 4    2020 0138-…            28        28          25           11             28
#> 5    2021 0138-…            28        28          25           25             24
#> 6    2022 0138-…            24        24          23           23             23
#> 7    2023 0138-…            15        15          15           15             15
#> 8    2024 0138-…            17        17          17           17             17
#> 9    2025 0138-…             3         3           3            3              3
#> # ℹ 2 more variables: ref_total <int>, cat <chr>
```
