  # License Metadata Gaps
  # Comparision of license metadata in Crossref with Unpaywall via OpenALEX per
  # journal, year and country affiliation (Germany).
WITH
  oalex_cc_de AS (
  SELECT
    DISTINCT cc_cr.doi,
    cc_cr.issn_l,
    cc_cr.cr_year,
    CASE
      WHEN open_access.oa_status = "hybrid" THEN 1
    ELSE
    0
  END
    AS upw_hybrid,
    CASE
      WHEN cc IS NULL THEN 0
    ELSE
    1
  END
    AS cr_hybrid,
    CASE
      WHEN country_code = "DE" THEN 1
    ELSE
    0
  END
    AS germany
  FROM
    `hoad-dash.hoaddata.cc_md` AS cc_cr
  LEFT JOIN
    `subugoe-collaborative.openalex.works` AS oalex
  ON
    LOWER(cc_cr.doi) = LOWER(oalex.doi)
  LEFT OUTER JOIN
    `hoad-dash.hoaddata.cr_openalex_inst_full` AS oalex_inst
  ON
    LOWER(cc_cr.doi) = LOWER(oalex_inst.doi) ),
  u AS (
  SELECT
    DISTINCT issn_l,
    cr_year,
    COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year) AS article_total,
    SUM(upw_hybrid) OVER (PARTITION BY issn_l, cr_year) AS upw_hybrid_total,
    SUM(cr_hybrid) OVER (PARTITION BY issn_l, cr_year) AS cr_hybrid_total,
    CAST("Global" AS STRING) AS cat
  FROM (
    SELECT
      DISTINCT cc_cr.doi,
      cc_cr.issn_l,
      cc_cr.cr_year,
      CASE
        WHEN open_access.oa_status = "hybrid" THEN 1
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
      `hoad-dash.hoaddata.cc_md` AS cc_cr
    LEFT JOIN
      `subugoe-collaborative.openalex.works` AS oalex
    ON
      LOWER(cc_cr.doi) = LOWER(oalex.doi) )
  UNION ALL (
    SELECT
      DISTINCT issn_l,
      cr_year,
      COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year) AS article_total,
      SUM(upw_hybrid) OVER (PARTITION BY issn_l, cr_year) AS upw_hybrid_total,
      SUM(cr_hybrid) OVER (PARTITION BY issn_l, cr_year) AS cr_hybrid_total,
      CAST("Germany" AS STRING) AS cat
    FROM
      oalex_cc_de
    WHERE
      germany = 1)
  ORDER BY
    issn_l,
    cr_year,
    cat )
SELECT
  *
FROM
  u