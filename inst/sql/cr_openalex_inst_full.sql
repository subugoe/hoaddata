SELECT
  doi,
  issn_l,
  cr_year,
  id,
  country_code,
  display_name
FROM (
  SELECT
    doi,
    issn_l,
    cr_year,
    institutions
  FROM (
    SELECT
      cc_md.doi AS doi,
      issn_l,
      cr_year,
      authorships
    FROM
      `hoad-dash.oam.cc_md` AS cc_md
    LEFT JOIN
      `subugoe-collaborative.openalex.works` AS openalex
    ON
      cc_md.doi = openalex.doi ),
    UNNEST(authorships)
  WHERE
    author_position = "first"),
  UNNEST(institutions)
