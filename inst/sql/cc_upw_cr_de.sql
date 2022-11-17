WITH
  cr_upw AS (
  SELECT
    cc_cr.doi,
    cc_cr.issn_l,
    cc_cr.cr_year,
    cc_cr.cc,
    oalex.country_code,
    upw.oa_status
  FROM
    `hoad-dash.hoaddata.cc_md` AS cc_cr
  INNER JOIN
    `hoad-dash.hoaddata.cr_openalex_inst_full` AS oalex
  ON
    cc_cr.doi = oalex.doi
  LEFT JOIN
    `subugoe-collaborative.upw_instant.snapshot` AS upw
  ON
    LOWER(cc_cr.doi) = LOWER(upw.doi)
  WHERE
    cc_cr.cr_year < 2022
    AND country_code = "DE")
SELECT
  DISTINCT issn_l,
  cr_year,
  COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year) AS article_total,
  SUM(upw_hybrid) OVER (PARTITION BY issn_l, cr_year) AS upw_hybrid_total,
  SUM(cr_hybrid) OVER (PARTITION BY issn_l, cr_year) AS cr_hybrid_total,
FROM (
  SELECT
    DISTINCT 
    doi,
    agg.issn_l,
    cr_year,
    CASE
      WHEN oa_status = "hybrid" THEN 1
    ELSE
    0
  END
    AS upw_hybrid,
    CASE
      WHEN cc IS NULL THEN 0
    ELSE
    1
  END
    AS cr_hybrid
  FROM
    cr_upw AS agg
  INNER JOIN
    `hoad-dash.hoaddata.jct_hybrid_jns` AS jns
  ON
    agg.issn_l = jns.issn_l )
ORDER BY
  cr_hybrid_total DESC