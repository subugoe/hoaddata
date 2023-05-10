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
  immediate
FROM
  cc_md_raw