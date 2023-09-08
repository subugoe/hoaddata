-- Publication statistics for institutions participating in transformative agreements (TA)
-- The resulting table allows us to determine the impact TAs have on the open access publication activity of participating institutions.

WITH
  -- ESAC TA / institutions matching table
  esac_journals AS (
    SELECT
      DISTINCT hybrid_jns.issn_l AS matching_issn, -- Extracting ISSN
      hybrid_jns.esac_id, -- ESAC ID of the TA
      esac_publisher, -- Publisher information
      start_date, -- Agreement start date
      EXTRACT(YEAR FROM start_date) AS start_year, -- Extracting the year from start_date
      end_date, -- Agreement end date
      EXTRACT(YEAR FROM end_date) AS end_year, -- Extracting the year from end_date
      issn_l, -- ISSN of the journal
      jct_inst.ror, -- ROR ID of the institution
      jct_inst.ror_main, -- Main ROR ID of the institution
      oalex.id AS oalex_inst_id -- OpenAlex institution ID
    FROM
      `subugoe-collaborative.hoaddata.jct_hybrid_jns` AS hybrid_jns
    -- Join with participating institutions
    INNER JOIN
      `subugoe-collaborative.hoaddata.jct_inst_enriched` AS jct_inst
    ON
      jct_inst.esac_id = hybrid_jns.esac_id
    -- OpenAlex / ROR Matching
    INNER JOIN
      `subugoe-collaborative.openalex.institutions` AS oalex
    ON
      jct_inst.ror = oalex.ror
  ),

  -- Publications per year, institution, and agreement
  inst_per_year AS (
    SELECT
      DISTINCT esac_journals.*, -- Include columns from the previous CTE
      oalex_inst.doi, -- DOI of the publication
      oalex_inst.cr_year, -- Publication year
      cc, -- CC license information
      cr.issued, -- Date of publication
      esac_journals.ror AS ror_rel, -- ROR ID related to the journal
      esac_journals.ror_main AS ror_id, -- Main ROR ID related to the journal
      CASE
        WHEN (DATE(cr.issued) BETWEEN DATE(start_date) AND DATE(end_date)) THEN TRUE -- Check if publication is within the agreement's date range
        ELSE FALSE
      END AS ta, -- Flag indicating if the publication is within the agreement
      CASE
        WHEN cc IS NOT NULL THEN TRUE -- Check if the publication has a CC license
        ELSE FALSE
      END AS has_cc -- Flag indicating if the publication has a CC license
    FROM
      esac_journals
    INNER JOIN
      `subugoe-collaborative.hoaddata.cr_openalex_inst_full` AS oalex_inst
    ON
      esac_journals.oalex_inst_id = oalex_inst.id
      AND oalex_inst.issn_l = esac_journals.matching_issn
    LEFT JOIN
      `subugoe-collaborative.hoaddata.cc_openalex_inst` AS oa
    ON
      oalex_inst.doi = oa.doi
    INNER JOIN
      `subugoe-collaborative.cr_instant.snapshot` AS cr
    ON
      oalex_inst.doi = cr.doi
  )

-- Selecting relevant columns for the final result
SELECT
  doi,
  cr_year,
  matching_issn AS issn_l,
  esac_id AS ta_journal_portfolio,
  esac_publisher,
  ta AS ta_active,
  cc,
  ror_rel AS ror_matching,
  ror_id AS ror_main
FROM
  inst_per_year
-- Ordering the result set
ORDER BY
  ta_journal_portfolio,
  cr_year DESC;
