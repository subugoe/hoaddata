#' Hybrid Journals listed in the Open Access Monitor
#'
#' The dataset contains hybrid journals available as filter in the
#' \href{https://open-access-monitor.de/}{German Open Access Monitor}.
#' The dataset was unified and enriched with ISSN variants and ISSN-L.
#'
#' Variables:
#'
#' \describe{
#'     \item{vertrag}{Transformative aggrement from a German consortium (in brakets)}
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
#'     \item{issn}{International Standard Serial Number (ISSN), a ID to refer to a specific journal's media version}
#'     }
#'
#' @source \url{https://doi.org/10.26165/JUELICH-DATA/VTQXLM}
#'
#' @keywords datasets
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
#' @keywords datasets
#' @examples
#' cc_jn_ind
"cc_jn_ind"

#' Hybrid OA publishing output from first authors
#'
#' This dataset comprises affiliation information from first authors for each
#' open access article published in hybrid journals as
#' listed by the German Open Access monitor since 2017.
#'
#' Affiliation data was obtained from OpenAlex.
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
#' @keywords datasets
#' @examples
#' # Hybrid OA articles with lead author from Uni Göttingen
#' cr_olax_inst[cr_olax_inst$id %in% "https://openalex.org/I74656192",]
"cr_olax_inst"
