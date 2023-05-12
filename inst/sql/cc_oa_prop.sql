## Journal OA Proportion Test
    WITH cc_prop AS (
      SELECT DISTINCT doi,
        CASE
          WHEN cc IS NOT NULL
          AND vor = 1 THEN 1
          ELSE 0
        END AS cc,
        issn_l
      FROM `subugoe-collaborative.hoaddata.cc_md_all`
    ),
    total AS (
      SELECT COUNT(DISTINCT doi) AS total,
        SUM(cc_prop.cc) AS cc_total,
        issn_l
      FROM cc_prop
      GROUP BY issn_l
    )
    SELECT *
    FROM (
        SELECT *,
          total.cc_total / total.total AS prop
        FROM total
      )
    WHERE prop > 0.95
    ORDER BY prop DESC