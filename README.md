# hoaddata

<!-- badges: start -->
[![update-data.yaml](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml/badge.svg)](https://github.com/njahn82/hoaddashtest/actions/workflows/update-data.yaml)

<!-- badges: end -->

This package contains information about the open access uptake of
hybrid journals. These journals belong to national transformative agreements in 
Germany as listed by the [Open Access Monitor](https://open-access-monitor.de/#/publications). 

The main purpose of hoaddata is to ship data for hybrid open access monitoring 
dashboards, which are currently under development at the SUB Göttingen with the 
support of the [Deutsche Forschungsgemeinschaft](https://gepris.dfg.de/gepris/projekt/416115939?context=projekt&task=showDetail&id=416115939&). By providing the data as an R package, hoaddata can be also 
used for other data analytics tasks with R.

Data cover the publication period 2017 - 2022.

## Installation

You can install hoaddata from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("njahn82/hoaddashtest", dependencies = "Imports")
```
## Datasets

This package provides the following data tables.

### Journal-level data

- `?oam_hybrid_jns`: Hybrid Journals listed in the Open Access Monitor. Data were 
gathered from <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>, validated and 
enriched with ISSN variants. 

- `?cc_jn_ind`: Prevalence of Creative Commons license variants by year and 
hybrid journal as obtained from Crossref.

- `?cc_openalex_inst_jn_ind`: First author country affiliations per journal, 
year and Creative Commons license

### Article-level data

- `?cc_openalex_inst`: Article-level affiliation data from first authors as obtained
from OpenAlex. Covers only open access articles under a Creative Commons license
in a hybrid journal.

## Data gathering

The `data-raw` folder contains code used to generate the hoaddata datasets.

Most of the data was obtained by interfacing the [subugoe-collaborative 
scholarly data warehouse](https://github.com/naustica/bqsub), a collection of 
big scholarly datasets hosted on Google Big Query and maintained by the 
SUB Göttingen. [Crossref](https://www.crossref.org/) was used for determining 
the publication volume and articles provided under a CC license, 
while affiliation data was gathered from [OpenAlex](https://openalex.org/). 

You can find the corresponding SQL code in the `inst/sql/` folder.

The data package is automatically build with GitHub Actions. Each merge event 
into the main branch triggers a data update by calling the scripts in the
`data-raw/` folder. Data changes will be incorporated in the package and 
tracked with Git. This makes it easy to update and reproduce different version 
of the data contained in hoaddata.


## Data re-use and licenses

Datasets are released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute these
materials in any form, for any purpose, commercial or non-commercial, and by any 
means.

Crossref asserts no claims of ownership to individual items of bibliographic 
metadata and associated Digital Object Identifiers (DOIs) acquired through the 
use of the Crossref Free Services. Individual items of bibliographic metadata 
and associated DOIs may be cached and incorporated into the user's content and systems.

OpenAlex data is made available under the CC0 license. 

This work re-used the following dataset: 

Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene, 2021, "Open Access Monitor: 
Zeitschriftenlisten", <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>.

published under CC BY 4.0.
