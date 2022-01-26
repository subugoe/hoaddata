# cc_jn_ind cc licenses by journal and year (absolute and relative)

# Overall article volume by journal and year
WITH
  jn_total AS (
  SELECT
    DISTINCT issn_l,
    cr_year,
    COUNT(DISTINCT doi) OVER (PARTITION BY issn_l, cr_year) AS jn_all
  FROM
    `hoad-dash.oam.cc_md`
)

# Article volume by journal, year and cc variant
# Only immediate cc licenses applied to vor are considered
SELECT * , cc_total / jn_all as prop
FROM(
SELECT
  DISTINCT
  jn_total.issn_l,
  jn_total.cr_year,
  cc,
  COUNT(DISTINCT doi) OVER (PARTITION BY jn_total.issn_l, jn_total.cr_year, cc) AS cc_total,
  jn_all
FROM
  `hoad-dash.oam.cc_md` AS cc_md
RIGHT OUTER JOIN
  jn_total
ON
  cc_md.issn_l = jn_total.issn_l
  AND cc_md.cr_year = jn_total.cr_year
WHERE
  vor = 1
  AND immediate = 1
  AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
ORDER BY
  cr_year DESC
)
