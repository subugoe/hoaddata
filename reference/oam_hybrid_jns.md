# Hybrid Journals listed in the Open Access Monitor

The dataset contains hybrid journals available as a filter in the
[German Open Access Monitor](https://open-access-monitor.de/). The
dataset was unified and mapped to the [Crossref title
list](https://www.crossref.org/titleList/).

## Usage

``` r
oam_hybrid_jns
```

## Format

An object of class `spec_tbl_df` (inherits from `tbl_df`, `tbl`,
`data.frame`) with 14603 rows and 3 columns.

## Source

Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene, Stanzel, Franziska
2022, Open Access Monitor: Zeitschriftenlisten (v2)
<https://doi.org/10.26165/JUELICH-DATA/VTQXLM>

## Details

There's no direct data exchange between Crossref and the ISSN agency.
Instead, publishers register journal-level metadata when they first
deposit metadata for a given journal, including all ISSN(s). Crossref
makes sure that article and journal metadata match.

More info about Crossref's handling of ISSN registration can be found in
this support thread:
<https://community.crossref.org/t/parallel-titles-for-a-given-issn/2183>

Variables:

- agreement:

  Transformative agreement from a German consortium

- lead:

  Institution leading the nationwide consortium

- cr_journal_id:

  Crossref journal ID

- issn:

  International Standard Serial Number (ISSN), a ID to refer to a
  specific journal's media version

## Examples

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
