# License coverage Crossref vs Unpaywall

Comparision of license metadata in Crossref with Unpaywall via OpenALEX
per journal, year and country affiliation (Germany).

## Usage

``` r
cr_upw
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
139839 rows and 6 columns.

## Examples

``` r
cr_upw
#> # A tibble: 191,304 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-1541    2024            11                9               9 Germany
#>  2 0001-4788    2022            39               10              10 Global 
#>  3 0001-5172    2019             9                4               4 Germany
#>  4 0001-5547    2021            76               11              10 Global 
#>  5 0001-6268    2021            34               29              29 Germany
#>  6 0001-6489    2022             1                0               0 Germany
#>  7 0001-6810    2025             1                1               1 Germany
#>  8 0001-690X    2019           133               14              15 Global 
#>  9 0001-8392    2023            49               13              13 Global 
#> 10 0001-8678    2023            58                0               2 Global 
#> # ℹ 191,294 more rows
```
