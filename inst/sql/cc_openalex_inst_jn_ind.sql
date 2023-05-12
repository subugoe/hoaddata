WITH -- CC publication volume by journal, year and first author country affiliation
country_by_cc AS (
  SELECT issn_l,
    cr_year,
    country_code,
    cc,
    COUNT(DISTINCT doi) AS articles
  FROM (
      SELECT alex.doi,
        issn_l,
        cr_year,
        country_code,
        cc
      FROM `subugoe-collaborative.hoaddata.cr_openalex_inst_full` alex
        LEFT JOIN (
          SELECT cc,
            doi
          FROM `subugoe-collaborative.hoaddata.cc_openalex_inst`
        ) AS cc_oa ON alex.doi = cc_oa.doi
    )
  GROUP BY issn_l,
    cr_year,
    country_code,
    cc
  ORDER BY issn_l,
    cr_year,
    country_code,
    cc DESC
),
-- Publication volume by journal, year and first author country affiliation
all_articles AS (
  SELECT issn_l,
    cr_year,
    country_code,
    SUM(articles) AS all_articles
  FROM country_by_cc
  GROUP BY issn_l,
    cr_year,
    country_code
  ORDER BY cr_year DESC
) -- Join into a single dataset
SELECT all_articles.issn_l,
  all_articles.cr_year,
  all_articles.country_code,
  cc,
  articles AS articles_under_cc_variant,
  all_articles.all_articles AS articles_total
FROM country_by_cc
  LEFT JOIN all_articles ON country_by_cc.cr_year = all_articles.cr_year
  AND country_by_cc.issn_l = all_articles.issn_l -- There are journals without Open Alex affiliation!
  AND (
    country_by_cc.country_code = all_articles.country_code
    OR (
      country_by_cc.country_code IS NULL
      AND all_articles.country_code IS NULL
    )
  )
ORDER BY cr_year DESC