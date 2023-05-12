# # Country OA by TA
WITH country_oa_ta AS (
  SELECT COUNT(DISTINCT doi) AS oa_n,
    cr_oalex.cr_year,
    cr_oalex.country_code,
    cr_oalex.issn_l,
    CASE
      WHEN EXISTS (
        SELECT *
        FROM `subugoe-collaborative.hoaddata.esac_jn_inst` AS jct_inst
        WHERE jct_inst.ror_id = oalex.ror
          AND jct_inst.issn_l = jns.issn_l
      ) THEN TRUE
      ELSE FALSE
    END AS has_ta
  FROM `subugoe-collaborative.hoaddata.cc_openalex_inst` cr_oalex
    LEFT JOIN `subugoe-collaborative.openalex.institutions` oalex ON cr_oalex.id = oalex.id
    LEFT JOIN `subugoe-collaborative.hoaddata.jct_hybrid_jns` jns ON cr_oalex.issn_l = jns.issn_l
  GROUP BY cr_oalex.cr_year,
    issn_l,
    cr_oalex.country_code,
    has_ta
  ORDER BY oa_n DESC
),
# # Country publications by TA
country_pubs_ta AS (
  SELECT COUNT(DISTINCT doi) AS n,
    cr_oalex.cr_year,
    cr_oalex.country_code,
    cr_oalex.issn_l,
    CASE
      WHEN EXISTS (
        SELECT *
        FROM `subugoe-collaborative.hoaddata.esac_jn_inst` AS jct_inst
        WHERE jct_inst.ror_id = oalex.ror
          AND jct_inst.issn_l = jns.issn_l
      ) THEN TRUE
      ELSE FALSE
    END AS has_ta
  FROM `subugoe-collaborative.hoaddata.cr_openalex_inst_full` cr_oalex
    LEFT JOIN `subugoe-collaborative.openalex.institutions` oalex ON cr_oalex.id = oalex.id
    LEFT JOIN `subugoe-collaborative.hoaddata.jct_hybrid_jns` jns ON cr_oalex.issn_l = jns.issn_l --WHERE ror = "https://ror.org/01y9bpm73"
    --WHERE cr_oalex.id = "https://openalex.org/I98358874" AND issn_l = "Elsevier"
  GROUP BY cr_oalex.cr_year,
    cr_oalex.country_code,
    issn_l,
    has_ta
  ORDER BY n DESC
),
# ### Institutional publication volume by year and TA including OA
share_table AS (
  SELECT country_oa_ta.oa_n,
    country_pubs_ta.*
  FROM country_pubs_ta
    LEFT JOIN country_oa_ta ON country_pubs_ta.cr_year = country_oa_ta.cr_year
    AND country_pubs_ta.country_code = country_oa_ta.country_code
    AND country_pubs_ta.issn_l = country_oa_ta.issn_l
    AND country_pubs_ta.has_ta = country_oa_ta.has_ta
) # ### Country publication volume by year and TA including OA
#
SELECT
DISTINCT issn_l,
country_code,
cr_year,
CASE
  WHEN oa_n IS NULL THEN 0
  ELSE oa_n
END AS oa_n,
n,
has_ta
FROM share_table