WITH md_coverage AS (SELECT
  DISTINCT doi,
  cr_year,
  agreement, lead,
  # TDM
  CASE
    WHEN intended_application = "text-mining" THEN 1
  ELSE
  0
END
  AS has_tdm,
  # ORCID
  CASE
    WHEN ORCID IS NOT NULL THEN 1
  ELSE
  0
END has_orcid,
  has_funder,
  # Abstract
  has_abstract,
  # Has references
  has_ref
FROM (
  SELECT
    raw.DOI AS doi,
    raw.agreement, lead,
    raw.cr_year,
    link.intended_application,
    author.ORCID,
    CASE WHEN ARRAY_LENGTH(funder) != 0 THEN 1 ELSE 0 END AS has_funder,
    has_abstract,
    has_ref
  FROM
    `hoad-dash.oam.cr_raw` AS raw,
    UNNEST(link) AS link,
    UNNEST(author) AS author
    INNER JOIN `hoad-dash.oam.cc_md` as cc_md ON raw.doi = cc_md.doi
    INNER JOIN `hoad-dash.oam.cr_openalex_inst_full` as oalex ON raw.doi = oalex.doi
    INNER JOIN `hoad-dash.oam.oam_hybrid_jns` as jns ON raw.cr_journal_id = jns.cr_journal_id
    WHERE
   ( vor = 1
    AND NOT cc IS NULL) AND country_code = "DE") )

SELECT cr_year, agreement, lead,
COUNT(DISTINCT doi) AS article_total,
COUNT(DISTINCT IF(has_tdm = 1, doi, NULL)) AS tdm_total,
COUNT(DISTINCT IF(has_orcid = 1, doi, NULL)) AS orcid_total,
COUNT(DISTINCT IF(has_funder = 1, doi, NULL)) AS funder_total,
COUNT(DISTINCT IF(has_abstract = 1, doi, NULL)) AS abstract_total,
COUNT(DISTINCT IF(has_ref = 1, doi, NULL)) AS ref_total
FROM md_coverage
GROUP BY cr_year, agreement, lead
