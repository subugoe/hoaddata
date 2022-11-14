WITH
 -- CC publication volume by journal, year and first author country affiliation
  country_by_cc AS (
  SELECT
    cr_journal_id,
    cr_year,
    country_code,
    cc,
    COUNT(DISTINCT doi) AS articles
  FROM (
    SELECT
      alex.doi,
      cr_journal_id,
      cr_year,
      country_code,
      cc
    FROM
      `hoad-dash.oam.cr_openalex_inst_full` alex
    LEFT JOIN (
      SELECT
        cc,
        doi
      FROM
        `hoad-dash.oam.cc_openalex_inst` ) AS cc_oa
    ON
      alex.doi = cc_oa.doi )
  GROUP BY
    cr_journal_id,
    cr_year,
    country_code,
    cc
  ORDER BY
    cr_journal_id,
    cr_year,
    country_code,
    cc DESC ),
    -- Publication volume by journal, year and first author country affiliation
  all_articles AS (
  SELECT
    cr_journal_id,
    cr_year,
    country_code,
    SUM(articles) AS all_articles
  FROM
    country_by_cc
  GROUP BY
    cr_journal_id,
    cr_year,
    country_code
  ORDER BY
    cr_year DESC )
 -- Join into a single dataset
SELECT
  all_articles.cr_journal_id,
  all_articles.cr_year,
  all_articles.country_code,
  cc,
  articles AS articles_under_cc_variant,
  all_articles.all_articles AS articles_total
FROM
  country_by_cc
LEFT JOIN
  all_articles
ON
  country_by_cc.cr_year = all_articles.cr_year
  AND country_by_cc.cr_journal_id = all_articles.cr_journal_id
  -- There are journals without Open Alex affiliation!
  AND (country_by_cc.country_code = all_articles.country_code
    OR (country_by_cc.country_code IS NULL
      AND all_articles.country_code IS NULL))
ORDER BY
  cr_year DESC
