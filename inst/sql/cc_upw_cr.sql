  # License Metadata Gaps
  # Comparision of license metadata in Crossref with Unpaywall via OpenALEX per
  # journal, year and country affiliation (Germany).
  #
  # 1. Get hybrid oa articles
WITH
  hybrid_oa_upw AS (
  SELECT
    DISTINCT oalex.doi
  FROM
    `subugoe-collaborative.openalex.works` AS oalex
  WHERE
    open_access.oa_status = "hybrid" ),
  # 2. Germany OA evidence per source
  oalex_cc_de AS (
  SELECT
    DISTINCT cc_cr.doi,
    cc_cr.issn_l,
    cc_cr.cr_year,
    CASE
      WHEN EXISTS ( SELECT doi FROM hybrid_oa_upw WHERE doi = cc_cr.doi) THEN 1
    ELSE
    0
  END
    AS upw_hybrid,
    CASE
      WHEN ( cc IS NOT NULL AND vor = 1 ) THEN 1
    ELSE
    0
  END
    AS cr_hybrid,
    CASE
      WHEN country_code = "DE" THEN 1
    ELSE
    0
  END
    AS germany
  FROM
    `subugoe-collaborative.hoaddata.cc_md` AS cc_cr
  LEFT OUTER JOIN
    `subugoe-collaborative.hoaddata.cr_openalex_inst_full` AS oalex_inst
  ON
    LOWER(cc_cr.doi) = LOWER(oalex_inst.doi) ),
  # 3. Global stats
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
        WHEN EXISTS ( SELECT doi FROM hybrid_oa_upw WHERE doi = cc_cr.doi) THEN 1
      ELSE
      0
    END
      AS upw_hybrid,
      CASE
        WHEN ( cc IS NOT NULL AND vor = 1 ) THEN 1
      ELSE
      0
    END
      AS cr_hybrid
    FROM
      `subugoe-collaborative.hoaddata.cc_md` AS cc_cr )
      # Combine with Germany stats
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
      germany = 1 )
  ORDER BY
    issn_l,
    cr_year,
    cat )
SELECT
  *
FROM
  u