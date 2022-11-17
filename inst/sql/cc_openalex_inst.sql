SELECT
  DISTINCT
  cc_md.doi,
  cc_md.issn_l,
  cc_md.cr_year,
  cc,
  country_code,
  id,
  display_name
  FROM
    `hoad-dash.hoaddata.cc_md` AS cc_md
  LEFT JOIN `hoad-dash.hoaddata.cr_openalex_inst_full` as inst ON cc_md.doi = inst.doi
  WHERE
    vor = 1
    AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
ORDER BY doi