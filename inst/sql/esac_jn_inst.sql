SELECT DISTINCT inst.esac_id,
  ror_id,
  issn_l
FROM `subugoe-collaborative.hoaddata.jct_inst_short` AS inst
  INNER JOIN `subugoe-collaborative.hoaddata.jct_hybrid_jns` AS jns ON inst.esac_id = jns.esac_id