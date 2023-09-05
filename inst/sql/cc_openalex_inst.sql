SELECT DISTINCT cc_md.doi,
  cc_md.issn_l,
  cc_md.cr_year,
  cc,
  inst.country_code,
  ror
FROM `subugoe-collaborative.hoaddata.cc_md` AS cc_md
  LEFT JOIN `subugoe-collaborative.hoaddata.cr_openalex_inst_full` as inst ON cc_md.doi = inst.doi
  LEFT JOIN `subugoe-collaborative.openalex.institutions` as oalex ON inst.id = oalex.id
WHERE vor = 1
  AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
ORDER BY doi