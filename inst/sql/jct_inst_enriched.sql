WITH
  obtain_associated_ror_ids AS (
    -- Part 1: Retrieve data from OpenAlex institution table to include associated institutions
    SELECT
      esac_id,  -- ESAC TA ID
      jct_inst.ror_id AS ror_jct,  -- ROR identifier from JCT
      inst.ror AS ror_associated  -- ROR identifier for associated institutions from OpenAlex
    FROM
      `subugoe-collaborative.hoaddata.jct_inst` AS jct_inst
    LEFT JOIN
      `subugoe-collaborative.openalex.institutions` AS oalex_inst
    ON
      jct_inst.ror_id = oalex_inst.ror
    LEFT JOIN
      UNNEST(oalex_inst.associated_institutions) AS inst
    ORDER BY
      esac_id
  ),
  create_matching_table AS (
    SELECT
      esac_id,
      'ror_jct' AS ror_type,
      ror_jct AS ror
    FROM
      obtain_associated_ror_ids
    UNION ALL
    SELECT
      esac_id,
      'ror_associated' AS ror_type,
      ror_associated AS ror
    FROM
      obtain_associated_ror_ids
  )
SELECT
  DISTINCT create_matching_table.*,
  start_date,
  end_date
FROM
  create_matching_table
INNER JOIN
  `subugoe-collaborative.hoaddata.jct_inst` AS jct_inst
ON
  create_matching_table.esac_id = jct_inst.esac_id
ORDER BY
  esac_id,
  ror