SELECT
  DISTINCT cc_md.issn_l,
  issn,
  esac_publisher,
  esac_id
FROM
  `hoad-dash.jct.cc_md` AS cc_md
INNER JOIN
  `hoad-dash.jct.jct_jns` AS jct
ON
  cc_md.issn_l = jct.issn_l
  