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
#> # A tibble: 202,254 × 6
#>    issn_l    cr_year article_total upw_hybrid_total cr_hybrid_total cat    
#>    <chr>       <int>         <int>            <int>           <int> <chr>  
#>  1 0001-1541    2025           427               59              59 Global 
#>  2 0001-2785    2021           176                0               0 Global 
#>  3 0001-4842    2019           351               28               0 Global 
#>  4 0001-5172    2017           196                8              10 Global 
#>  5 0001-5970    2019           244               18              18 Global 
#>  6 0001-6489    2026           124               12              23 Global 
#>  7 0001-6810    2023             4                4               4 Germany
#>  8 0001-6969    2018            37                0               0 Global 
#>  9 0001-6969    2020             3                0               0 Germany
#> 10 0001-7868    2026            31                1               1 Germany
#> # ℹ 202,244 more rows
```
