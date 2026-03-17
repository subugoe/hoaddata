# Overview: Hybrid OA data

``` r
library(hoaddata)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

## Datasets

This package provides the following data tables.

### `oam_hybrid_jns`

Hybrid Journals listed in the Open Access Monitor. Data were gathered
from <https://doi.org/10.26165/JUELICH-DATA/VTQXLM> and enriched with
ISSN variants.

``` r
oam_hybrid_jns
#> # A tibble: 14,603 × 3
#>    vertrag                    issn_l    issn     
#>    <chr>                      <chr>     <chr>    
#>  1 De Gruyter (SUB Göttingen) 0306-0322 0306-0322
#>  2 De Gruyter (SUB Göttingen) 0306-0322 1865-8717
#>  3 De Gruyter (SUB Göttingen) 0003-5696 0003-5696
#>  4 De Gruyter (SUB Göttingen) 0003-5696 1613-0421
#>  5 De Gruyter (SUB Göttingen) 1438-2091 1438-2091
#>  6 De Gruyter (SUB Göttingen) 1438-2091 1868-9426
#>  7 De Gruyter (SUB Göttingen) 0232-8461 0232-8461
#>  8 De Gruyter (SUB Göttingen) 0232-8461 2196-6761
#>  9 De Gruyter (SUB Göttingen) 0003-6390 0003-6390
#> 10 De Gruyter (SUB Göttingen) 0003-6390 2156-7093
#> # ℹ 14,593 more rows
```

Number of investigated journals: 7512

By agreement

``` r
oam_hybrid_jns %>%
  group_by(vertrag) %>%
  summarise(journals = n_distinct(issn_l)) %>%
  arrange(desc(journals))
#> # A tibble: 20 × 2
#>    vertrag                    journals
#>    <chr>                         <int>
#>  1 Springer Hybrid (DEAL)         2116
#>  2 Elsevier (DEAL)                1859
#>  3 Wiley Hybrid (DEAL)            1412
#>  4 Sage (BSB)                      980
#>  5 CUP (BSB)                       332
#>  6 TaylorFrancis (ZBW)             270
#>  7 De Gruyter (SUB Göttingen)      105
#>  8 Karger (BSB)                     71
#>  9 De Gruyter (ZBW)                 70
#> 10 ACM (hebis)                      60
#> 11 IOP (TIB)                        56
#> 12 RSC (TIB)                        38
#> 13 Nature (MPDL)                    35
#> 14 Hogrefe (SUB Göttingen)          32
#> 15 AIP (TIB)                        30
#> 16 BMJ (BSB)                        28
#> 17 SPIE (TIB)                       11
#> 18 Thieme (ZB MED)                   7
#> 19 Portland Press (TIB)              5
#> 20 ECS (TIB)                         2
```

### `jn_ind`

Aggregated data about the prevalence of Creative Commons license
variants by year and hybrid journal as obtained from Crossref.

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

Number of active journals: 13361

Number of open access articles with Creative Commons license: 2102560

Creative Commons Breakdown:

``` r
jn_ind %>%
  filter(!is.na(cc)) %>%
  group_by(cc) %>%
  summarise(articles = sum(cc_total)) %>%
  arrange(desc(articles))
#> # A tibble: 6 × 2
#>   cc          articles
#>   <fct>          <int>
#> 1 CC BY        1368249
#> 2 CC BY-NC-ND   521070
#> 3 CC BY-NC      208905
#> 4 CC BY-NC-SA     3581
#> 5 CC BY-SA         411
#> 6 CC BY-ND         344
```

### `jn_aff`

First author country affiliations per journal, year and Creative Commons
license

``` r
jn_aff
#> # A tibble: 2,958,562 × 6
#>    issn_l    cr_year country_code cc       articles_under_cc_va…¹ articles_total
#>    <chr>       <int> <chr>        <chr>                     <int>          <int>
#>  1 0227-5910    2026 AU           CC BY                         1              3
#>  2 2572-7958    2026 US           NA                            6              7
#>  3 0306-2619    2026 US           CC BY                         5             44
#>  4 1742-5468    2026 US           CC BY                         1              2
#>  5 2352-7102    2026 CA           CC BY                         8             17
#>  6 2210-3155    2026 IN           NA                           12             14
#>  7 2754-6969    2026 BD           NA                            1              1
#>  8 1557-2013    2026 GB           CC BY-N…                      2              3
#>  9 1056-7895    2026 CN           NA                            5              5
#> 10 0896-5811    2026 US           CC BY                         1              6
#> # ℹ 2,958,552 more rows
#> # ℹ abbreviated name: ¹​articles_under_cc_variant
```

### `cc_articles`

Article-level affiliation data from first authors as obtained from
OpenAlex.

``` r
cc_articles
#> # A tibble: 2,924,785 × 6
#>    doi                     issn_l    cr_year cc          country_code ror       
#>    <chr>                   <chr>       <int> <chr>       <chr>        <chr>     
#>  1 10.1002/1438-390x.1017  1438-3896    2019 CC BY       AT           https://r…
#>  2 10.1002/1438-390x.1019  1438-3896    2019 CC BY-NC-ND NA           https://r…
#>  3 10.1002/1438-390x.1019  1438-3896    2019 CC BY-NC-ND US           https://r…
#>  4 10.1002/1438-390x.12015 1438-3896    2019 CC BY-NC-ND PL           https://r…
#>  5 10.1002/1438-390x.12015 1438-3896    2019 CC BY-NC-ND ZA           https://r…
#>  6 10.1002/1438-390x.12016 1438-3896    2019 CC BY-NC    JP           https://r…
#>  7 10.1002/1438-390x.12018 1438-3896    2019 CC BY-NC-ND JP           https://r…
#>  8 10.1002/1438-390x.12018 1438-3896    2019 CC BY-NC-ND JP           https://r…
#>  9 10.1002/1438-390x.12019 1438-3896    2019 CC BY       JP           https://r…
#> 10 10.1002/1438-390x.12019 1438-3896    2019 CC BY       JP           https://r…
#> # ℹ 2,924,775 more rows
```

``` r
cc_articles %>%
  group_by(cc) %>%
  summarise(articles = n_distinct(doi))
#> # A tibble: 6 × 2
#>   cc          articles
#>   <chr>          <int>
#> 1 CC BY        1368249
#> 2 CC BY-NC      208905
#> 3 CC BY-NC-ND   521070
#> 4 CC BY-NC-SA     3581
#> 5 CC BY-ND         344
#> 6 CC BY-SA         411
```

### `cr_md`

Crossref metadata coverage.

``` r
cr_md
#> # A tibble: 132,018 × 9
#>    cr_year issn_l    article_total tdm_total orcid_total funder_total
#>      <int> <chr>             <int>     <int>       <int>        <int>
#>  1    2017 0001-0782             9         9           0            6
#>  2    2018 0001-0782             5         5           0            3
#>  3    2019 0001-0782            11        11           0            4
#>  4    2020 0001-0782             4         4           0            1
#>  5    2020 0001-0782             1         1           0            0
#>  6    2021 0001-0782            26        26           0           16
#>  7    2021 0001-0782             2         2           0            2
#>  8    2022 0001-0782            30        30           0           15
#>  9    2022 0001-0782             1         1           0            1
#> 10    2023 0001-0782            24        24           0            8
#> # ℹ 132,008 more rows
#> # ℹ 3 more variables: abstract_total <int>, ref_total <int>, cat <chr>
```
