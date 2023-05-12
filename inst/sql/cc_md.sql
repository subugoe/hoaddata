## Remove journals with OA share > .95 from article-level dataset
SELECT
  DISTINCT *
FROM
 `subugoe-collaborative.hoaddata.cc_md_all` AS cc_md
WHERE
  NOT EXISTS(
  SELECT
    issn_l
  FROM
    `subugoe-collaborative.hoaddata.cc_oa_prop` AS oa_journals
  WHERE
    cc_md.issn_l = oa_journals.issn_l)