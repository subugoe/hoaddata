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
#> # A tibble: 198,248 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-2785    2019           207                0               0 Global 
#>  2 0001-2998    2017            60                1               1 Global 
#>  3 0001-3072    2017             2                0               0 Germany
#>  4 0001-4338    2024           137                0               0 Global 
#>  5 0001-4788    2017            37                2               3 Global 
#>  6 0001-4842    2024            25               19              19 Germany
#>  7 0001-4842    2026            64                6               9 Global 
#>  8 0001-4966    2024          2267              156             152 Global 
#>  9 0001-5385    2019            79                0               0 Global 
#> 10 0001-5903    2020            27               11              11 Global 
#> # ℹ 198,238 more rows
```
