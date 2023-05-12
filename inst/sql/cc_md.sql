## Article-level license information
CREATE OR REPLACE TABLE
  `hoad-dash.hoaddata.cc_md_all` AS (
  WITH
    normalized_cc AS (
    SELECT
      doi,
      RTRIM(REGEXP_EXTRACT(lic.url, r'by.*?/'), "/") AS cc,
      lic.content_version,
      lic.delay_in_days
    FROM
      `hoad-dash.hoaddata.cr_raw`,
      UNNEST(license) AS lic
    WHERE
      REGEXP_CONTAINS(LOWER(lic.url), "creativecommons.org") ),
    cc_md AS (
    SELECT
      DISTINCT cr_raw.doi,
      issn_l,
      cr_year,
      CASE
        WHEN (`cc` = 'by') THEN ('CC BY')
        WHEN (`cc` = 'by-sa') THEN ('CC BY-SA')
        WHEN (`cc` = 'by-nc') THEN ('CC BY-NC')
        WHEN (`cc` = 'by-nc-sa') THEN ('CC BY-NC-SA')
        WHEN (`cc` = 'by-nd') THEN ('CC BY-ND')
        WHEN (`cc` = 'by-nc-nd') THEN ('CC BY-NC-ND')
        WHEN (`cc` = 'by-ncnd') THEN ('CC BY-NC-ND')
        WHEN (`cc` = 'by-ncsa ') THEN ('CC BY-NC-SA')
    END
      AS `cc`,
      CASE
        WHEN content_version != "am" THEN 1
      ELSE
      0
    END
      AS vor,
      CASE
        WHEN delay_in_days = 0 THEN 1
      ELSE
      0
    END
      AS IMMEDIATE
    FROM
      normalized_cc AS cc_df
    RIGHT OUTER JOIN
      `hoad-dash.hoaddata.cr_raw` AS cr_raw
    ON
      cc_df.doi = cr_raw.doi ),
    cc_md_raw AS (
      # Fix ambigue license information in crossref metadata, eg: "10.1111/bjd.16343"
    SELECT
      *
    FROM (
      SELECT
        *,
        ROW_NUMBER() OVER(PARTITION BY doi ORDER BY cc) AS ROW
      FROM
        `cc_md`) AS tmp
    WHERE
      ROW = 1 )
  SELECT
    DISTINCT doi,
    issn_l,
    cr_year,
    CASE
    # Delayed OA Rockefeller, nasty hack
      WHEN cc = "CC BY-NC-SA" AND issn_l IN ('0021-9525', '0022-1007', '0022-1295') THEN NULL
    ELSE
    cc
  END
    AS cc,
    vor,
    IMMEDIATE
  FROM
    cc_md_raw );

## Journal OA Proportion Test
CREATE OR REPLACE TABLE
  `hoad-dash.hoaddata.jn_oa_prop` AS (
  WITH
    cc_prop AS (
    SELECT
      DISTINCT doi,
      CASE
        WHEN cc IS NOT NULL AND vor = 1 THEN 1
      ELSE
      0
    END
      AS cc,
      issn_l
    FROM
      `hoa-article.jct.cc_md_raw` ),
    total AS (
    SELECT
      COUNT(DISTINCT doi) AS total,
      SUM(cc_prop.cc) AS cc_total,
      issn_l
    FROM
      cc_prop
    GROUP BY
      issn_l )
  SELECT
    *
  FROM (
    SELECT
      *,
      total.cc_total / total.total AS prop
    FROM
      total )
  WHERE
    prop > 0.95
  ORDER BY
    prop DESC);


## Remove journals with OA share > .95 from article-level dataset
SELECT
  DISTINCT *
FROM
 `hoad-dash.hoaddata.cc_md_all` AS cc_md
WHERE
  NOT EXISTS(
  SELECT
    issn_l
  FROM
    `hoad-dash.hoaddata.jn_oa_prop` AS oa_journals
  WHERE
    cc_md.issn_l = oa_journals.issn_l)