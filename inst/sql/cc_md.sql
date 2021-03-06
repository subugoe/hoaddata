WITH
  normalized_cc AS (
  SELECT
    doi,
    RTRIM(REGEXP_EXTRACT(lic.url, r'by.*?/'), "/") AS cc,
    lic.content_version,
    lic.delay_in_days
  FROM
    `hoad-dash.oam.cr_raw`,
    UNNEST(license) AS lic
  WHERE
    REGEXP_CONTAINS(LOWER(lic.url), "creativecommons.org") )
SELECT
  DISTINCT cr_raw.doi,
  cr_journal_id,
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
  AS immediate
FROM
  normalized_cc AS cc_df
RIGHT OUTER JOIN
  `hoad-dash.oam.cr_raw` AS cr_raw
ON
  cc_df.doi = cr_raw.doi
