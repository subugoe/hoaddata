WITH
  first_aff AS (
  SELECT
    doi,
    author_position,
    id,
    country_code,
    display_name
  FROM (
    SELECT
      doi,
      author_position,
      institutions
    FROM
      `subugoe-collaborative.openalex.works`,
      UNNEST(authorships)
    WHERE
      author_position = "first" ),
    UNNEST(institutions) )
SELECT
  cr_raw.doi,
  issn_l,
  cr_year,
  id,
  country_code,
  display_name
FROM
  `hoad-dash.oam.cr_raw` AS cr_raw
LEFT OUTER JOIN
  first_aff
ON
  cr_raw.doi = first_aff.doi
