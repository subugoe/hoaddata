WITH
  cc_country AS (
  SELECT
    issn_l,
    cr_year,
    country_code,
    cc,
    COUNT(DISTINCT doi) AS cc_articles
  FROM
    `hoad-dash.oam.cc_openalex_inst`
  GROUP BY
    issn_l,
    cr_year,
    country_code,
    cc )
SELECT
  DISTINCT inst.issn_l,
  inst.cr_year,
  inst.country_code,
  cc,
  cc_articles,
  articles,
  cc_articles / articles AS prop
FROM (
  SELECT
    issn_l,
    cr_year,
    country_code,
    COUNT(DISTINCT doi) AS articles
  FROM
    `hoad-dash.oam.cr_openalex_inst_full`
  GROUP BY
    country_code,
    issn_l,
    cr_year ) AS inst
LEFT JOIN
  cc_country
ON
  inst.issn_l = cc_country.issn_l
  AND inst.cr_year = cc_country.cr_year
  AND inst.country_code = cc_country.country_code
ORDER BY
  prop DESC
