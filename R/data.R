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
#' This dataset contains the number and proportion of articles with Creative
#' Commons license (CC) by license variant and year for hybrid journals as
#' listed by the German Open Access monitor since 2017.
#'
#' Journal's article volume was calculated using the Crossref database snapshot.
#' Note that only articles published in regular issues aside from supplements
#' containing conference contributions like meeting abstracts,
#' indicated by non-numeric pagination were included. Also, non-scholarly
#' journal content, such as the table of contents were excluded,
#' following Unpaywall's paratext recognition approach, which was expanded to
#' include patterns indicating corrections.
#'
#' CC licenses were also identified through Crossref metadata records.
#' License information for author accepted manuscripts ("aam") were not
#' considered.
#'
#' Variables:
#'
#' \describe{
#'     \item{cr_journal_id}{Crossref journal ID}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{cc}{Normalized Creative Commons variant. Ordered factor by license variant permissiveness}
#'     \item{cc_total}{Number of articles under Creative Commons variant}
#'     \item{jn_all}{Yearly journal output}
#'     \item{prop}{Proportion of CC licensed articles}
#'     }
#'
#' @keywords jndatasets
#' @examples
#' cc_jn_ind
"cc_jn_ind"

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
#' Note that whole counting in which every original article or review was
#' counted once per country of affiliation of the first authors were used.
#' Because first authors can have multiple affiliations from different countries,
#' please use \code{\link{cc_jn_ind}} to determine a journal's publication
#' volume.
#'
#' Variables:
#' \describe{
#'     \item{cr_journal_id}{Crossref journal ID}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code`)}
#'     \item{cc}{Normalized Creative Commons variant. \code{NA} represents articles, which were not provided under a CC license}
#'     \item{articles_under_cc_variant}{Number of articles under Creative Commons variant, grouped by journal, year and country affiliation}
#'     \item{articles_total}{Yearly journal output by year and country affiliation}
#'     }
#' @keywords jndatasets
#' @examples
#' # Scientometrics (Crossref journal ID: 2795)
#'   subset(cc_openalex_inst_jn_ind,
#'     cr_journal_id %in% "2795" & country_code %in% c("DE", "CN"))
"cc_openalex_inst_jn_ind"

#' Hybrid OA publishing output from first authors
#'
#' This dataset comprises affiliation information from first authors for each
#' open access article published in hybrid journals as listed in
#' \link[hoaddata]{oam_hybrid_jns}.
#'
#' A first author is often considered as lead author(\url{https://en.wikipedia.org/wiki/Lead_author})
#' who has usually undertaken most of the research presented in the article,
#' although author roles can vary across disciplines.
#' We used OpenAlex as data source for determining the lead author's affiliation.
#'
#' In case where OpenALEX did not record an country affiliation, we extracted
#' country names from the display_name using regular expressions.
#'
#' Variables:
#'
#' \describe{
#'     \item{doi}{DOI for the OA article}
#'     \item{cr_journal_id}{Crossref journal ID}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{cc}{Normalized Creative Commons variant.}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code` and extra country extraction)}
#'     \item{id}{The OpenAlex ID for this institution}
#'     \item{display_name}{The primary name of the institution (OpenAlex field `display_name`)}
#'     }
#'
#'  To our knowledge, OpenAlex does not provide information about corresponding
#'  authors and their affiliation.
#'
#' @keywords articledatasets
#' @examples
#' # Hybrid OA articles with lead author from Uni Göttingen
#' cc_openalex_inst[cc_openalex_inst$id %in% "https://openalex.org/I74656192",]
"cc_openalex_inst"

#' @importFrom tibble tibble
NULL
