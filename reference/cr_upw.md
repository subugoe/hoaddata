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
#> # A tibble: 179,386 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-2785    2023           157                0               0 Global 
#>  2 0001-4966    2022          2454              125             147 Global 
#>  3 0001-5342    2017            12                1               1 Global 
#>  4 0001-5830    2019             1                0               0 Germany
#>  5 0001-6373    2017             1                0               0 Germany
#>  6 0001-6373    2021            32               10              11 Global 
#>  7 0001-6810    2024            63               31              29 Global 
#>  8 0001-6969    2017            41                0               0 Global 
#>  9 0001-7868    2018           119                0               0 Global 
#> 10 0001-7868    2020            61                0               0 Germany
#> # ℹ 179,376 more rows
```
