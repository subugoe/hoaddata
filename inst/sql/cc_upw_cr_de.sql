WITH
  cr_upw AS (
  SELECT
    cc_cr.doi,
    cc_cr.cr_journal_id,
    cc_cr.cr_year,
    cc_cr.cc,
    oalex.country_code,
    upw.oa_status
  FROM
    `hoad-dash.oam.cc_md` AS cc_cr
  INNER JOIN
    `hoad-dash.oam.cr_openalex_inst_full` AS oalex
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
  DISTINCT agreement, lead,
  cr_year,
  COUNT(DISTINCT doi) OVER (PARTITION BY agreement, lead, cr_year) AS article_total,
  SUM(upw_hybrid) OVER (PARTITION BY agreement, lead, cr_year) AS upw_hybrid_total,
  SUM(cr_hybrid) OVER (PARTITION BY agreement, lead, cr_year) AS cr_hybrid_total,
FROM (
  SELECT
    DISTINCT agreement, lead,
    doi,
    agg.cr_journal_id,
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
    `hoad-dash.oam.oam_hybrid_jns` AS jns
  ON
    agg.cr_journal_id = jns.cr_journal_id )
ORDER BY
  cr_hybrid_total DESC
