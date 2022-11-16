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
cc_md.doi,
issn_l,
cr_year,
id,
country_code,
display_name
FROM
`hoad-dash.jct.cc_md` AS cc_md
LEFT OUTER JOIN
first_aff
ON
cc_md.doi = LOWER(first_aff.doi)