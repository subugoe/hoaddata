
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hoaddata

<!-- badges: start -->

[![update-data.yaml](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml/badge.svg)](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml)

<!-- badges: end -->

This package contains indicators about the open access uptake of hybrid
journals, which belong to national transformative agreements in Germany
as listed by the [Open Access
Monitor](https://open-access-monitor.de/#/publications).

## Installation

You can install hoaddata from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("njahn82/hoaddashtest", dependencies = "Imports")
```

## Data tables

This package provides the following data tables.

### `oam_hybrid_jns`

Hybrid Journals listed in the Open Access Monitor. Data were gathered
from <https://doi.org/10.26165/JUELICH-DATA/VTQXLM> and enriched with
ISSN variants.

``` r
oam_hybrid_jns
#> # A tibble: 10,765 × 3
#>    vertrag     issn_l    issn     
#>    <chr>       <chr>     <chr>    
#>  1 ACM (hebis) 0360-0300 0360-0300
#>  2 ACM (hebis) 0360-0300 1557-7341
#>  3 ACM (hebis) 1550-4832 1550-4832
#>  4 ACM (hebis) 1550-4832 1550-4840
#>  5 ACM (hebis) 1936-7236 1936-7228
#>  6 ACM (hebis) 1936-7236 1936-7236
#>  7 ACM (hebis) 1549-6325 1549-6325
#>  8 ACM (hebis) 1549-6325 1549-6333
#>  9 ACM (hebis) 1544-3558 1544-3558
#> 10 ACM (hebis) 1544-3558 1544-3965
#> # … with 10,755 more rows
```

### `cc_jn_ind`

Aggregated data about the prevalence of Creative Commons license
variants by year and hybrid journal as obtained from Crossref.

``` r
cc_jn_ind
#> # A tibble: 41,319 × 6
#>    issn_l    cr_year cc          cc_total jn_all     prop
#>    <chr>     <fct>   <fct>          <int>  <int>    <dbl>
#>  1 0009-4536 2019    <NA>              NA    256 NA      
#>  2 0253-2964 2021    CC BY              1    256  0.00391
#>  3 1124-4909 2021    CC BY-NC-ND        1    256  0.00391
#>  4 1359-4184 2018    CC BY-SA           1    256  0.00391
#>  5 0032-3888 2019    CC BY-NC-ND        1    256  0.00391
#>  6 0253-2964 2021    CC BY-NC-ND        1    256  0.00391
#>  7 2058-9883 2019    CC BY-NC           2    256  0.00781
#>  8 0006-3592 2018    CC BY-NC           3    256  0.0117 
#>  9 1359-4184 2018    CC BY-NC-SA        3    256  0.0117 
#> 10 1359-4184 2018    CC BY-NC-ND        3    256  0.0117 
#> # … with 41,309 more rows
```

### `cr_olax_inst`

Article-level affiliation data from first authors as obtained from
OpenAlex.

``` r
cr_olax_inst
#> # A tibble: 291,049 × 7
#>    doi                      issn_l cr_year cc    country_code id    display_name
#>    <chr>                    <chr>    <int> <chr> <chr>        <chr> <chr>       
#>  1 10.1007/s00482-017-0217… 0932-…    2017 CC BY <NA>         <NA>  <NA>        
#>  2 10.1007/s00586-017-5204… 0940-…    2017 CC BY <NA>         <NA>  <NA>        
#>  3 10.1038/onc.2017.97      0950-…    2017 CC B… <NA>         <NA>  <NA>        
#>  4 10.1002/cncr.30558       0008-…    2017 CC B… <NA>         <NA>  <NA>        
#>  5 10.1007/s00280-017-3417… 0344-…    2017 CC BY <NA>         <NA>  <NA>        
#>  6 10.1007/s10495-017-1405… 1360-…    2017 CC BY <NA>         <NA>  <NA>        
#>  7 10.1007/s10943-017-0457… 0022-…    2017 CC BY <NA>         <NA>  <NA>        
#>  8 10.1007/s00723-017-0968… 0937-…    2017 CC BY <NA>         <NA>  <NA>        
#>  9 10.1007/s12325-017-0616… 0741-…    2017 CC BY <NA>         <NA>  <NA>        
#> 10 10.1088/1361-6498/aa914a 0952-…    2017 CC BY <NA>         <NA>  <NA>        
#> # … with 291,039 more rows
```

## Data re-use and licenses

Datasets are released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute these materials in any form, for any purpose, commercial or
non-commercial, and by any means.

Crossref asserts no claims of ownership to individual items of
bibliographic metadata and associated Digital Object Identifiers (DOIs)
acquired through the use of the Crossref Free Services. Individual items
of bibliographic metadata and associated DOIs may be cached and
incorporated into the user’s content and systems.

This work re-used the following dataset:

Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene, 2021, “Open Access
Monitor: Zeitschriftenlisten”,
<https://doi.org/10.26165/JUELICH-DATA/VTQXLM>.

published under CC BY 4.0.
