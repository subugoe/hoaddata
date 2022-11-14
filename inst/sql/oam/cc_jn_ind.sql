  # cc_jn_ind cc licenses by journal and year (absolute and relative)
  # Overall article volume by journal and year
WITH
  jn_total AS (
  SELECT
    DISTINCT cr_journal_id,
    cr_year,
    COUNT(DISTINCT doi) OVER (PARTITION BY cr_journal_id, cr_year) AS jn_all
  FROM
    `hoad-dash.oam.cc_md` ),
  # Immediate cc license
  cc_year AS (
  SELECT
    DISTINCT cr_journal_id,
    cr_year,
    cc,
    COUNT(DISTINCT doi) OVER (PARTITION BY cr_journal_id, cr_year, cc) AS cc_total
  FROM
    `hoad-dash.oam.cc_md` AS cc_md
  WHERE
    vor = 1
    AND NOT cc IS NULL # there are few cases where the cc regex extraction did not work
    )
  # Bringing it together
SELECT
  *,
  cc_total / jn_all as prop
FROM (
  SELECT
    jn_total.cr_journal_id,
    jn_total.cr_year,
    cc,
    cc_total,
    jn_all
  FROM
    jn_total
  LEFT JOIN
    cc_year
  ON
    jn_total.cr_journal_id = cc_year.cr_journal_id
    AND jn_total.cr_year = cc_year.cr_year )
