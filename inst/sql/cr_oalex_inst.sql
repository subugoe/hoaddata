SELECT doi,
  issn_l,
  cr_year,
  oalex_inst.country_code,
  oalex_inst.id,
  display_name as inst_name
FROM (
SELECT
  oam.doi,
  country_code,
  id,
  issn_l,
  cr_year
FROM (
  SELECT
    doi,
    inst.id,
    inst.country_code,
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
    UNNEST(institutions) AS inst ) AS oalex
INNER JOIN
  `hoad-dash.oam.cc_md` AS oam
ON
  oalex.doi = oam.doi
WHERE
  cc IS NOT NULL
  AND vor = 1
  AND immediate = 1
  AND author_position = "first" ) as cc_org
  INNER JOIN `subugoe-collaborative.openalex.institutions` AS oalex_inst ON cc_org.id = oalex_inst.id
