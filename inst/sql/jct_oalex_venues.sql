WITH
  my_jns AS (
  SELECT
    issn_l,
    ARRAY_AGG(STRUCT(container_title)
    ORDER BY
      year DESC, n DESC
    LIMIT
      1)[
  OFFSET
    (0)].*
  FROM (
    SELECT
      issn_l,
      container_title,
      EXTRACT (YEAR
      FROM
        issued) AS year,
      COUNT(DISTINCT md.doi) AS n
    FROM
      `hoad-dash.hoaddata.cc_md` AS md
    INNER JOIN
      `subugoe-collaborative.cr_instant.snapshot` AS cr
    ON
      md.doi = cr.doi
    GROUP BY
      issn_l,
      year,
      container_title
    ORDER BY
      n DESC )
  GROUP BY
    issn_l),
  oalex AS (
  SELECT
    homepage_url as display_name,
    issn_l
  FROM
    `subugoe-collaborative.openalex.sources`
  WHERE
    works_count > 10
    AND homepage_url IS NOT NULL )
SELECT
  *
FROM
  my_jns
LEFT JOIN
  oalex
ON
  my_jns.issn_l = oalex.issn_l