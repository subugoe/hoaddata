#' Hybrid Journals listed in the Open Access Monitor
#'
#' The dataset contains hybrid journals available as filter in the
#' \href{https://open-access-monitor.de/}{German Open Access Monitor}.
#' The dataset was unified and enriched with ISSN variants and ISSN-L.
#'
#' @format A data frame with 3 variables
#'   \describe{
#'     \item{vertrag}{Transformative aggrement from a German consortium (in brakets)}
#'     \item{issn_l}{Linking International Standard Serial Number (ISSN-L), an umbrella ID for all media versions of the journal}
#'     \item{issn}{International Standard Serial Number (ISSN), a ID to refer to a specific journal's media version}
#'     }
#' @source \url{https://doi.org/10.26165/JUELICH-DATA/VTQXLM}
"oam_hybrid_jns"

#' Yearly publication volume
"oam_jns_by_year"

#' @importFrom tibble tibble
NULL
