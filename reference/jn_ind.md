# Prevalence of Creative Commons licenses by variant, year and journal

This dataset contains the number and proportion of open access articles
with Creative Commons license (CC) by license variant and year for
hybrid journals included in the cOAlition S Journal Checker Tool.

## Usage

``` r
jn_ind
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
123770 rows and 6 columns.

## Details

Publication period is 2017 - 2022.

Journal's article volume was calculated using Crossref metadata
snapshot. Note that only articles published in regular issues aside from
supplements containing conference contributions like meeting abstracts,
indicated by non-numeric pagination, were included. Also, non-scholarly
journal content, such as the table of contents were excluded. In doing
so, we followed Unpaywall's paratext recognition approach, which we
expanded to include patterns indicating corrections.

CC licenses were also identified through Crossref. License information
for author accepted manuscripts ("aam") were not considered.

Variables:

- issn_l:

  Linking ISSN

- cr_year:

  Earliest publication year (Crossref field \`issued\`)

- cc:

  Normalized Creative Commons variant. Ordered factor by license variant
  permissiveness

- cc_total:

  Number of articles under Creative Commons variant

- jn_all:

  Yearly journal output

- prop:

  Proportion of CC licensed articles

## Examples

``` r
jn_ind
#> # A tibble: 190,425 × 6
#>    issn_l    cr_year cc          cc_total jn_all    prop
#>    <chr>     <fct>   <fct>          <int>  <int>   <dbl>
#>  1 0001-0782 2017    CC BY-NC-SA        1    281 0.00356
#>  2 0001-0782 2017    CC BY-SA           1    281 0.00356
#>  3 0001-0782 2017    CC BY-NC           2    281 0.00712
#>  4 0001-0782 2017    CC BY              2    281 0.00712
#>  5 0001-0782 2017    CC BY-NC-ND        3    281 0.0107 
#>  6 0001-0782 2018    CC BY              3    302 0.00993
#>  7 0001-0782 2018    CC BY-NC-SA        2    302 0.00662
#>  8 0001-0782 2019    CC BY              6    280 0.0214 
#>  9 0001-0782 2019    CC BY-SA           1    280 0.00357
#> 10 0001-0782 2019    CC BY-NC-ND        4    280 0.0143 
#> # ℹ 190,415 more rows
```
