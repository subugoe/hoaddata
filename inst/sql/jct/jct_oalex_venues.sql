SELECT
  DISTINCT jct.issn_l,
  oalex.id,
  oalex.display_name,
  oalex.homepage_url
FROM
  `hoad-dash.jct.cc_md` AS jct
LEFT JOIN
  `subugoe-collaborative.openalex.venues` oalex
ON
  jct.issn_l = oalex.issn_l