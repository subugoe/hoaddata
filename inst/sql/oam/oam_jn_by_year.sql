SELECT
  issn_l,
  cr_year,
  COUNT(DISTINCT doi) AS publication_volume
FROM
  `hoad-dash.oam.cr_raw`
GROUP BY
  issn_l,
  cr_year
