#' Hybrid Journals listed in the Open Access Monitor
#'
#' The dataset contains hybrid journals available as filter in the
#' \href{https://open-access-monitor.de/}{German Open Access Monitor}.
#' The dataset was unified and enriched with ISSN variants and ISSN-L.
#'
#' Variables:
#'
#' \describe{
#'     \item{vertrag}{Transformative aggrement from a German consortium (in brackets)}
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
#'     \item{issn}{International Standard Serial Number (ISSN), a ID to refer to a specific journal's media version}
#'     }
#'
#' @source Pollack, Philipp; Lindstrot, Barbara; Barbers, Irene, 2021,
#' Open Access Monitor: Zeitschriftenlisten \url{https://doi.org/10.26165/JUELICH-DATA/VTQXLM}
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
#' License information for author accepted manuscripts ("aam") and
#' with time lag between licensing and publication (delayed OA) were not
#' considered.
#'
#' Variables:
#'
#' \describe{
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
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
#' Variables:
#' \describe{
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code`)}
#'     \item{cc}{Normalized Creative Commons variant.}
#'     \item{cc_total}{Number of articles under Creative Commons variant by journal, year and country affiliation}
#'     \item{jn_all}{Yearly journal output by year and country affiliation}
#'     \item{prop}{Proportion of articles under CC license variant by journal, year and country affiliation}
#'     }
#' @keywords jndatasets
#' @examples
#'   cc_openalex_inst_jn_ind[cc_openalex_inst_jn_ind$issn_l %in%  "0138-9130" &
#'                          cc_openalex_inst_jn_ind$country_code %in% c("DE", "CN"),]
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
#' Variables:
#'
#' \describe{
#'     \item{doi}{DOI for the OA article}
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
#'     \item{cr_year}{Earliest publication year (Crossref field `issued`)}
#'     \item{country_code}{The country where this institution is located, represented as an ISO two-letter country code. (OpenAlex field `country_code`)}
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
