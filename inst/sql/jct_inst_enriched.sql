-- This query is designed to identify institutions participating in transformative agreements.
-- JCT does not cover all associated institutions, eg. university hospitals and MPG institutes.
-- Here, we include associated institutions to ensure comprehensive coverage

-- Common Table Expression (CTE) - matching:
WITH matching AS (
    -- Part 1: Retrieve data from 'oalex_inst' to include associated institutions
    (
        SELECT 
            esac_id,          -- ESAC TA ID
            oalex_inst.ror AS ror_main,  -- ROR identifier for the main institution
            inst.ror AS ror  -- ROR identifier for associated institutions
        FROM 
            `subugoe-collaborative.hoaddata.jct_inst` AS jct_inst
        INNER JOIN 
            `subugoe-collaborative.openalex.institutions` as oalex_inst 
        ON 
            jct_inst.ror_id = oalex_inst.ror
        INNER JOIN  
            UNNEST(oalex_inst.associated_institutions) as inst 
        ORDER BY 
            esac_id
    )
    UNION ALL
    -- Part 2: Retrieve data from 'jct_inst' for the main institutions
    SELECT 
        esac_id,              -- ESAC TA ID
        ror_id AS ror_main,   -- ROR identifier for the main institution
        ror_id AS ror         -- ROR identifier for the main institution (no associated institutions)
    FROM 
        `subugoe-collaborative.hoaddata.jct_inst` AS jct_inst
    ORDER BY 
        esac_id, ror_main
)

-- Main Query:
-- Select data from the 'matching' CTE and join it with 'jct_inst' to retrieve additional details.
SELECT 
    DISTINCT matching.*,        -- Data from the 'matching' CTE
    start_date,        -- Start date of participation in transformative agreement
    end_date           -- End date of participation in transformative agreement
FROM 
    matching
INNER JOIN 
    `subugoe-collaborative.hoaddata.jct_inst` AS jct_inst 
ON 
    matching.esac_id = jct_inst.esac_id
ORDER BY 
    esac_id, ror_main
