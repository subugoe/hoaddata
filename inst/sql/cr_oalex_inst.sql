WITH
  cc_oa AS (
  SELECT
    *
  FROM
    `hoad-dash.oam.cc_md` AS cc_md
  WHERE
    vor = 1
    AND immediate = 1
    AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
    ),
  inst AS (
  SELECT
    doi,
    id,
    country_code,
    author_position
  FROM (
    SELECT
      *
    FROM (
      SELECT
        doi,
        authorships
      FROM
        `subugoe-collaborative.openalex.works`),
      UNNEST(authorships) ),
    UNNEST(institutions))
SELECT
  doi,
  issn_l,
  cr_year,
  cc,
  oalex_country.country_code,
  oalex_country.id,
  display_name
FROM (
  SELECT
    DISTINCT cc_oa.doi AS doi,
    issn_l,
    cr_year,
    cc,
    country_code,
    id
  FROM
    cc_oa
  LEFT JOIN
    inst
  ON
    cc_oa.doi = inst.doi
  WHERE
    author_position = "first" ) AS oalex_country
LEFT JOIN
  `subugoe-collaborative.openalex.institutions` AS oalex_inst
ON
  oalex_country.id = oalex_inst.id
