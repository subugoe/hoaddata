# cc_jn_ind cc licenses by journal and year (absolute and relative)
# Overall article volume by journal and year
WITH jn_total AS (
  SELECT DISTINCT issn_l,
    cr_year,
    COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year) AS jn_all
  FROM `subugoe-collaborative.hoaddata.cc_md`
),
# Immediate cc license
cc_year AS (
  SELECT DISTINCT issn_l,
    cr_year,
    cc,
    COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year, cc) AS cc_total
  FROM `subugoe-collaborative.hoaddata.cc_md` AS cc_md
  WHERE vor = 1
    AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
) # Bringing it together
SELECT *,
  cc_total / jn_all as prop
FROM (
    SELECT jn_total.issn_l,
      jn_total.cr_year,
      cc,
      cc_total,
      jn_all
    FROM jn_total
      LEFT JOIN cc_year ON jn_total.issn_l = cc_year.issn_l
      AND jn_total.cr_year = cc_year.cr_year
  )
ORDER BY issn_l,
  cr_year