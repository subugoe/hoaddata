
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hoaddata

<!-- badges: start -->

[![update-data.yaml](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml/badge.svg)](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml)

<!-- badges: end -->

hoaddata contains indicators about the open access uptake of hybrid
journals, which belong to national transformative agreements in Germany
as listed by the [Open Access
Monitor](https://open-access-monitor.de/#/publications).

## Installation

You can install hoaddata from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("njahn82/hoaddashtest")
```

## Data tables

This package provides the following data tables.

### Hybrid journal list

`?oam_hybrid_jns`: Hybrid Journals listed in the Open Access Monitor.
Data were gathered from <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>
and enriched with ISSN variants.

``` r
library(hoaddata)
library(dplyr) # For data analytics

# Data structure
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

Summary statistics:

``` r
# Journals by transformative agreement
oam_hybrid_jns %>%
  group_by(vertrag) %>%
  summarise(n = n_distinct(issn_l)) %>%
  arrange(desc(n)) %>%
  knitr::kable()
```

| vertrag                 |    n |
|:------------------------|-----:|
| Springer Hybrid (DEAL)  | 2098 |
| Wiley Hybrid (DEAL)     | 1429 |
| Sage (BSB)              |  980 |
| CUP (BSB)               |  282 |
| TaylorFrancis (ZBW)     |  267 |
| IOP (TIB)               |  116 |
| Karger (BSB)            |   71 |
| ACM (hebis)             |   62 |
| De Gruyter (ZBW)        |   45 |
| RSC (TIB)               |   39 |
| Hogrefe (SUB Göttingen) |   35 |
| Nature (MPDL)           |   33 |
| AIP (TIB)               |   32 |
| BMJ (BSB)               |   28 |
| SPIE (TIB)              |    9 |
| Thieme 2 (ab 2021)      |    6 |
| ECS (TIB)               |    2 |
| Thieme 1 (ab 2019)      |    1 |

### Creative commons licensing

`?cc_jn_ind`: Aggregated data about the prevalence of Creative Commons
license variants by year and hybrid journal as obtained from Crossref.

``` r
cc_jn_ind
#> # A tibble: 35,981 × 6
#>    issn_l    cr_year cc          cc_total jn_all     prop
#>    <chr>     <fct>   <fct>          <int>  <int>    <dbl>
#>  1 0009-4536 2019    <NA>              NA    256 NA      
#>  2 0032-3888 2019    CC BY-NC-ND        1    256  0.00391
#>  3 1359-4184 2018    CC BY-SA           1    256  0.00391
#>  4 2058-9883 2019    CC BY-NC           2    256  0.00781
#>  5 1359-4184 2018    CC BY-NC-ND        3    256  0.0117 
#>  6 1359-4184 2018    CC BY-NC-SA        3    256  0.0117 
#>  7 0006-3592 2018    CC BY-NC           3    256  0.0117 
#>  8 0014-3820 2018    CC BY-NC           3    256  0.0117 
#>  9 0090-4392 2021    CC BY-NC           3    256  0.0117 
#> 10 2058-9883 2019    CC BY              3    256  0.0117 
#> # … with 35,971 more rows
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
