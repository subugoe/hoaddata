#' Hybrid Journals
#' @examples
#' jct_hybrid_jns
"jct_hybrid_jns"

#' Hybrid Journals listed in the Open Access Monitor
#'
#' The dataset contains hybrid journals available as a filter in the
#' \href{https://open-access-monitor.de/}{German Open Access Monitor}.
#' The dataset was unified and mapped to the
#' \href{https://www.crossref.org/titleList/}{Crossref title list}.
#'
#' There's no direct data exchange between Crossref and the ISSN agency.
#' Instead, publishers register journal-level metadata when they first deposit
#' metadata for a given journal, including all ISSN(s). Crossref makes sure that
#' article and journal metadata match.
#'
#' More info about Crossref's handling of ISSN registration can be found in this
#' support thread:
#' \url{https://community.crossref.org/t/parallel-titles-for-a-given-issn/2183}
#'
#'
#' Variables:
#'
#' \describe{
#'     \item{agreement}{Transformative agreement from a German consortium}
#'     \item{lead}{Institution leading the nationwide consortium}
#'     \item{cr_journal_id}{Crossref journal ID}
#'     \item{issn}{International Standard Serial Number (ISSN), a ID to refer to a specific journal's media version}
#'     }
#'
#' @source Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene,
#' Stanzel, Franziska 2022, Open Access Monitor: Zeitschriftenlisten (v2)
#' \url{https://doi.org/10.26165/JUELICH-DATA/VTQXLM}
#'
#' @keywords jndatasets
#' @examples
#' oam_hybrid_jns
"oam_hybrid_jns"

#' Prevalence of Creative Commons licenses by variant, year and journal
#'
#' This dataset contains the number and proportion of open access articles
#' with Creative Commons license (CC) by license variant and year for hybrid journals
#' included in the cOAlition S Journal Checker Tool.
#'
#' Publication period is 2017 - 2022.
#'
#' Journal's article volume was calculated using Crossref metadata snapshot.
#' Note that only articles published in regular issues aside from supplements
#' containing conference contributions like meeting abstracts,
#' indicated by non-numeric pagination, were included. Also, non-scholarly
#' journal content, such as the table of contents were excluded. In doing so,
#' we followed Unpaywall's paratext recognition approach, which we expanded to
#' include patterns indicating corrections.
#'
#' CC licenses were also identified through Crossref.
#' License information for author accepted manuscripts ("aam") were not
#' considered.
#'
#' Variables:
#'
#' \describe{
#'     \item{issn_l}{Linking ISSN}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{cc}{Normalized Creative Commons variant. Ordered factor by license variant permissiveness}
#'     \item{cc_total}{Number of articles under Creative Commons variant}
#'     \item{jn_all}{Yearly journal output}
#'     \item{prop}{Proportion of CC licensed articles}
#'     }
#'
#' @keywords jndatasets
#' @examples
#' jn_ind
"jn_ind"

#' First author country affiliations per journal, year and Creative Commons license
#'
#' This dataset contains the number and proportion of open access articles in
#' hybrid journals by country, year and Creative Commons license variant.
#'
#' Country affiliations were determined using the first author affiliation as
#' listed by OpenAlex.
#' A first author is often considered as lead
#' author(\url{https://en.wikipedia.org/wiki/Lead_author})
#' who has usually undertaken most of the research presented in the article,
#' although author roles can vary across disciplines.
#'
#' Note that full counting in which every original article or review was
#' counted once per country of affiliation of the first authors was applied.
#' Because first authors can have multiple affiliations from different countries,
#' don't use this dataset, but \code{\link{jn_ind}} to determine a journal's
#' publication volume.
#'
#' Variables:
#' \describe{
#'     \item{issn_l}{Linking ISSN}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code`)}
#'     \item{cc}{Normalized Creative Commons variant. \code{NA} represents articles, which were not provided under a CC license}
#'     \item{articles_under_cc_variant}{Number of articles under Creative Commons variant, grouped by journal, year and country affiliation}
#'     \item{articles_total}{Yearly journal output by year and country affiliation}
#'     }
#' @keywords jndatasets
#' @examples
#' # Country output China vs Germany in Scientometrics (ISSN-L: 0138-9130)
#'   subset(jn_aff,
#'     issn_l %in% "0138-9130" & country_code %in% c("DE", "CN"))
"jn_aff"

#' Hybrid OA publishing output from first authors
#'
#' This dataset comprises affiliation information from first authors for each
#' open access article published in hybrid journals as listed in
#' \link[hoaddata]{oam_hybrid_jns}.
#'
#' A first author is often considered as lead author (\url{https://en.wikipedia.org/wiki/Lead_author})
#' who has usually undertaken most of the research presented in the article,
#' although author roles can vary across disciplines.
#' We used OpenAlex as data source for determining the lead author's affiliation.
#'
#' In case where OpenAlex did not record an country affiliation, we extracted
#' country names from the display_name using regular expressions.
#'
#' Variables:
#'
#' \describe{
#'     \item{doi}{DOI for the OA article}
#'     \item{issn_l}{Linking ISSN}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{cc}{Normalized Creative Commons variant.}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code` and extra country extraction)}
#'     \item{ror}{ROR Organizational ID}
#'     }
#'
#'  To our knowledge, OpenAlex does not provide information about corresponding
#'  authors and their affiliation.
#'
#' @keywords articledatasets
#' @examples
#' # Hybrid OA articles with lead author from Uni Göttingen
#' cc_articles[cc_articles$ror %in% "https://ror.org/01y9bpm73",]
"cc_articles"

#' Crossref Metadata Coverage
#'
#' This dataset gives information about metadata coverage per year and agreement.
#'
#' The following Crossref metadata were analysed:
#'
#' \describe{
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{issn_l}{Linking ISSN}
#'     \item{articles_total}{Yearly journal output by year and country affiliation}
#'     \item{tdm_total}{The number of articles containing full text URLs in the metadata}
#'     \item{orcid_total}{The number of articles containing at least one ORCID in the metadata}
#'     \item{funder_total}{The number of articles with funding metadata}
#'     \item{abstract_total}{The number of articles with open abstracts}
#'     \item{ref_total}{The number of articles with open reference lists)}
#'     \item{cat}{Global output or from first-authors based in Germany}
#'     }
#'
#' @keywords articledatasets
#' @examples
#' # OA Articles in Scientometrics from first-authors in Germany: Metadata coverage
#' cr_md[cr_md$issn_l == "0138-9130" & cr_md$cat == "Germany",]
"cr_md"

#' License coverage Crossref vs Unpaywall
#'
#' Comparision of license metadata in Crossref with Unpaywall
#' via OpenALEX per journal, year and country affiliation (Germany).
#'
#' @examples
#' cr_upw
"cr_upw"

#' Hybrid Journals: Venues Metadata
#'
#' This datasets contains information about journals. These journals come from
#' the Journal Checker Tool.
#'
#' @examples
#' jct_oalex_venues
"jct_oalex_venues"


#' @importFrom tibble tibble
NULL
