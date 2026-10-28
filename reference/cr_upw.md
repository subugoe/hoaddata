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
#> # A tibble: 202,097 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-2092    2025           195                1               0 Global 
#>  2 0001-2998    2021            60                6               5 Global 
#>  3 0001-4338    2018           166                0               0 Global 
#>  4 0001-4370    2026            57                0               0 Global 
#>  5 0001-4966    2020            54               21              20 Germany
#>  6 0001-5547    2025             1                0               0 Germany
#>  7 0001-5792    2022             1                1               1 Germany
#>  8 0001-5954    2024             1                0               0 Germany
#>  9 0001-6268    2018           332               33              33 Global 
#> 10 0001-6322    2018            28                4               4 Germany
#> # ℹ 202,087 more rows
```
