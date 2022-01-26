WITH normalized_cc AS (SELECT
  doi,
  RTRIM(REGEXP_EXTRACT(lic.url, r'by.*?/'), "/") AS cc,
  lic.content_version,
  lic.delay_in_days
FROM
  `hoad-dash.oam.cr_raw`, UNNEST(license) AS lic
WHERE
  REGEXP_CONTAINS(LOWER(lic.url), "creativecommons.org")
 )

SELECT
  cr_raw.doi,
  issn_l,
  cr_year,
  cc,
  CASE
    WHEN content_version != "am" THEN 1 ELSE 0
END
  AS vor,
  CASE
    WHEN delay_in_days = 0 THEN 1 ELSE 0
END
  AS immediate
FROM
  normalized_cc as cc_df
RIGHT OUTER JOIN `hoad-dash.oam.cr_raw` as cr_raw ON cc_df.doi = cr_raw.doi
