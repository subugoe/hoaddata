WITH
  country_missing AS (
  SELECT
    REPLACE( REPLACE( REPLACE( REPLACE(country, "Deutschland", "Germany"), "USA", "United States"), "UK", "United Kingdom"), "Österreich", "Austria") AS country,
    doi,
    display_name
  FROM (
    SELECT
      doi,
      display_name,
      RTRIM(array_reverse(SPLIT(display_name, ' '))[
      OFFSET
        (0)], ".|,") AS country
    FROM
      `hoad-dash.hoaddata.cr_openalex_inst_full_raw`
    WHERE
      country_code IS NULL )),
  my_matching AS (
  SELECT
    DISTINCT iso2c,
    country,
    doi,
    display_name
  FROM
    `hoad-dash.hoaddata.countrycodes` AS iso
  INNER JOIN
    country_missing
  ON
    iso.country_name_en = country_missing.country
  WHERE
    iso2c IS NOT NULL)
SELECT
  DISTINCT
  cr_openalex_inst_full_raw.doi,
  issn_l,
  cr_year,
--  country_code,
  id,
IF
  (country_code IS NULL,
    iso2c,
    country_code) AS country_code,
    cr_openalex_inst_full_raw.display_name
FROM
  `hoad-dash.hoaddata.cr_openalex_inst_full_raw` AS cr_openalex_inst_full_raw
LEFT OUTER JOIN
 my_matching
ON
  my_matching.doi = cr_openalex_inst_full_raw.doi
  AND my_matching.display_name = cr_openalex_inst_full_raw.display_name