# hoaddata

<!-- badges: start -->
[![update-data.yaml](https://github.com/subugoe/hoaddata/actions/workflows/update-data.yaml/badge.svg)](https://github.com/subugoe/hoaddata/actions/workflows/update-data.yaml)

<!-- badges: end -->

This package contains information about the open access uptake of
hybrid journals. 

The main purpose of hoaddata is to provide data for the [Hybrid Open Access  
Dashboard (HOAD)](https://subugoe.github.io/hoaddash/), being developed at the SUB Göttingen with the 
support of the [Deutsche Forschungsgemeinschaft](https://gepris.dfg.de/gepris/projekt/416115939?context=projekt&task=showDetail&id=416115939&). 
By making the data available as an R package, hoaddata can also be used for 
other data analytics tasks with R.

The data cover the publication period 2017 - 2023.

## Installation

You can install hoaddata from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("subugoe/hoaddata", dependencies = "Imports")
```

## Data sources

The package combines open data from multiple sources as follows:

- Journals included in transformative agreements were obtained from the [cOAlition S Transformative Agreements Public Data](https://journalcheckertool.org/transformative-agreements/) (July 2021, July 2022 and May 23 snapshots). Agreements with German consortia were derived from [Germany's Open Access Monitor](https://doi.org/10.26165/JUELICH-DATA/VTQXLM) (March 2022). We enriched both journal data sources with ISSN-L, a linking identifier for ISSN variants. Then, we excluded fully open access journals from the cOAlition S Transformative Agreements Public Data by cross-checking with several datasets of fully open access journals: the [Directory of Open Access Journals (DOAJ)](https://doaj.org/), [Bielefeld GOLD OA](https://doi.org/10.4119/unibi/2961544) and [Unpaywall](https://unpaywall.org/).
- [Crossref](https://www.crossref.org/) is our main data source for determining the publication volume in hybrid journals including the uptake of Open Access through Creative Commons licenses. The [ESAC guidelines](https://esac-initiative.org/about/transformative-agreements/reference-guide/), a community recommendation for negotiating transformative agreements, require publishers to make key metadata elements publicly available through Crossref, such as Creative Commons licensing information for Open Access articles. As a [Crossref Metadata Plus subscriber](https://www.crossref.org/services/metadata-retrieval/metadata-plus/), we used monthly Crossref snapshots to derive publication data.
- [OpenAlex](https://openalex.org/) is our data source for determining the country affiliation of lead authors. A [lead author](https://en.wikipedia.org/wiki/Lead_author) is the first named author of a scholarly article who has usually carried out most of the research presented in the article, although author roles can vary across disciplines. We used OpenAlex monthly snaphots as a data source to determine lead author affiliations.
- To highlight potential gaps between Crossref open licensing metadata and information provided via journal webpages, we used [Unpaywall](https://unpaywall.org/) via OpenAlex as a complementary data source for Open Access articles in hybrid journals.


## Data gathering

The `data-raw` folder contains the R code used to generate the hoaddata datasets.

Most of the data was obtained by connecting to the [subugoe-collaborative 
scholarly data warehouse](https://subugoe.github.io/scholcomm_analytics/data.html),
a collection of big scholarly datasets hosted on Google Big Query and maintained by the 
SUB Göttingen. [Crossref](https://www.crossref.org/) was used to determine 
the publication volume and articles made available under a CC license, 
while affiliation data was gathered from [OpenAlex](https://openalex.org/). 

You can find the corresponding SQL code in the `inst/sql/` folder.

The data package is automatically built using GitHub Actions. Every merge event 
in the main branch triggers a data update by calling the scripts in the
`data-raw/` folder. Data changes are merged into the package and 
tracked with Git. This makes it easy to update and reproduce different versions 
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

OpenAlex and Journal Checker Tool data are made available under the CC0 license. 

[Transformative Agreements Public Data](https://journalcheckertool.org/transformative-agreements/) is made available under the  CC0 license. 

This work re-used the following dataset: 

Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene, Stanzel, Franziska, 2021, "Open Access Monitor: 
Zeitschriftenlisten (V2)", <https://doi.org/10.26165/JUELICH-DATA/VTQXLM>.

published under CC BY 4.0.
