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
#> # A tibble: 198,236 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-1541    2023           322               48              50 Global 
#>  2 0001-4788    2020            49                5              12 Global 
#>  3 0001-4966    2026             8                6               6 Germany
#>  4 0001-5458    2025            14                0               0 Global 
#>  5 0001-5970    2022            14               11              11 Germany
#>  6 0001-6446    2021             5                0               0 Germany
#>  7 0001-6519    2021            71                0               0 Global 
#>  8 0001-6810    2017            47                7               2 Global 
#>  9 0001-7868    2025            71                2               2 Germany
#> 10 0001-8244    2026            11                8               9 Global 
#> # ℹ 198,226 more rows
```
