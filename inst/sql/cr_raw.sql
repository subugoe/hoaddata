-- CREATE OR REPLACE TABLE `hoad-dash.oam.cr_raw` AS (
SELECT
  issn_l,
  vertrag,
  doi,
  EXTRACT (YEAR
  FROM
    issued) AS cr_year,
  CASE
    WHEN abstract IS NOT NULL THEN 1
END
  AS has_abstract,
  CASE
    WHEN ARRAY_LENGTH(reference) != 0 THEN 1
END
  AS has_ref,
  license,
  author,
  link,
  funder
FROM (
  SELECT
    SPLIT(issn, ",") AS issn,
    doi,
    issued,
    license,
    abstract,
    reference,
    author,
    link,
    funder
  FROM
    `subugoe-collaborative.cr_instant.snapshot`
  WHERE
    NOT REGEXP_CONTAINS(title,'^Author Index$|^Back Cover|^Contents$|^Contents:|^Cover Image|^Cover Picture|^Editorial Board|^Front Cover|^Frontispiece|^Inside Back Cover|^Inside Cover|^Inside Front Cover|^Issue Information|^List of contents|^Masthead|^Title page|^Correction$|^Corrections to|^Corrections$|^Withdrawn')
    AND (NOT REGEXP_CONTAINS(page, '^S')
      OR page IS NULL) -- include online only articles, lacking page or issue
    AND (NOT REGEXP_CONTAINS(issue, '^S')
      OR issue IS NULL) ) AS `tbl_cr`,
  UNNEST(issn) AS issn
INNER JOIN
  `hoad-dash.oam.oam_hybrid_jns`
ON
  issn = `hoad-dash.oam.oam_hybrid_jns`.`issn`
--)
