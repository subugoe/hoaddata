-- Combine ESAC TA data with institution information
WITH esac_journals AS (
  SELECT DISTINCT
    hybrid_jns.issn_l AS matching_issn,
    hybrid_jns.esac_id,
    esac_publisher,
    start_date,
    EXTRACT(YEAR FROM start_date) AS start_year,
    end_date,
    EXTRACT(YEAR FROM end_date) AS end_year,
    issn_l,
    jct_inst.ror,
    jct_inst.ror_type,
    oalex.id AS oalex_inst_id
  FROM `subugoe-collaborative.hoaddata.jct_hybrid_jns` AS hybrid_jns
  -- Join with participating institutions
  INNER JOIN `subugoe-collaborative.hoaddata.jct_inst_enriched` AS jct_inst
    ON jct_inst.esac_id = hybrid_jns.esac_id
  -- Match with OpenAlex institutions
  INNER JOIN `subugoe-collaborative.openalex.institutions` AS oalex
    ON jct_inst.ror = oalex.ror
),

-- Gather publication data for institutions per year and link to TA
inst_per_year AS (
  SELECT DISTINCT
    esac_journals.*,
    oalex_inst.doi,
    oalex_inst.cr_year,
    oa.cc,
    cr.issued,
    esac_journals.ror as ror_matched, 
    esac_journals.ror_type as ror_type_,
    -- Determine if publication is within TA date range
    CASE
      WHEN (DATE(cr.issued) BETWEEN DATE(start_date) AND DATE(end_date)) THEN TRUE
      ELSE FALSE
    END AS ta,
    -- Check if publication has a CC license
    CASE
      WHEN oa.cc IS NOT NULL THEN TRUE
      ELSE FALSE
    END AS has_cc
  FROM esac_journals
  -- Join with OpenAlex institution data
  INNER JOIN `subugoe-collaborative.hoaddata.cr_openalex_inst_full` AS oalex_inst
    ON esac_journals.oalex_inst_id = oalex_inst.id
    AND oalex_inst.issn_l = esac_journals.matching_issn
  -- Left join to include publications without CC licenses
  LEFT JOIN `subugoe-collaborative.hoaddata.cc_openalex_inst` AS oa
    ON oalex_inst.doi = oa.doi
  -- Join with Crossref data for publication dates
  INNER JOIN `subugoe-collaborative.cr_instant.snapshot` AS cr
    ON oalex_inst.doi = cr.doi
)

-- Final query to select relevant columns for analysis
SELECT DISTINCT
  doi,
  cr_year,
  matching_issn AS issn_l,
  esac_id AS ta_journal_portfolio,
  esac_publisher,
  ta AS ta_active,
  cc,
  ror_matched as ror,
  ror_type_ as ror_type
FROM inst_per_year
-- Order results by TA journal portfolio, publication year (descending) and DOI
ORDER BY
  ta_journal_portfolio,
  cr_year DESC,
  doi