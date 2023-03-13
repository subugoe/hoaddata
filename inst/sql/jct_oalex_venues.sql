WITH
  my_jns AS (
  SELECT
    issn_l,
    ARRAY_AGG(STRUCT(container_title)
    ORDER BY
      n DESC
    LIMIT
      1)[
  OFFSET
    (0)].*
  FROM (
    SELECT
      issn_l,
      container_title,
      COUNT(DISTINCT md.doi) AS n
    FROM
      `hoad-dash.hoaddata.cc_md` AS md
    INNER JOIN
      `subugoe-collaborative.cr_instant.snapshot` AS cr
    ON
      md.doi = cr.doi
    GROUP BY
      issn_l,
      container_title
    ORDER BY
      n DESC )
  GROUP BY
    issn_l),
  oalex AS (
  SELECT
    homepage_url,
    issn_l
  FROM
    `subugoe-collaborative.openalex.sources`
  WHERE
    works_count > 10
    AND homepage_url IS NOT NULL )
SELECT
  my_jns.issn_l,
  container_title AS display_name,
  oalex.homepage_url
FROM
  my_jns
LEFT JOIN
  oalex
ON
  my_jns.issn_l = oalex.issn_l