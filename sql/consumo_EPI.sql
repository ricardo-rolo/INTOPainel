SELECT
  ITMVTO_ESTOQUE.CD_PRODUTO,
  PRODUTO.DS_PRODUTO,
  SUM(ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR) AS CONSUMO_MENSAL,
  EXTRACT(MONTH FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) AS MES,
  EXTRACT(YEAR FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) AS ANO,
  EXTRACT(DAY FROM LAST_DAY(DT_MVTO_ESTOQUE)) AS CNT_DIAS,
  CEIL(SUM(ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR)/EXTRACT(DAY FROM LAST_DAY(DT_MVTO_ESTOQUE))) AS CONSUMO_DIARIO_MEDIO
FROM
  ITMVTO_ESTOQUE
  JOIN UNI_PRO ON (
    ITMVTO_ESTOQUE.CD_PRODUTO = UNI_PRO.CD_PRODUTO AND
    ITMVTO_ESTOQUE.CD_UNI_PRO = UNI_PRO.CD_UNI_PRO  ---- ESTAVA NO REGISTRO ORIGINAL DO CARLOS - OU SEJA É NECESSÁRIO CONSIDERAR A UNIDADE DO PRODUTO NAQUELE LOTE DE MOVIMENTACAO
  )
  JOIN MVTO_ESTOQUE ON (
    ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE = MVTO_ESTOQUE.CD_MVTO_ESTOQUE AND
    MVTO_ESTOQUE.TP_MVTO_ESTOQUE IN ('P', 'S')
  )
  JOIN PRODUTO ON (
    ITMVTO_ESTOQUE.CD_PRODUTO = PRODUTO.CD_PRODUTO
  )
WHERE
  ITMVTO_ESTOQUE.CD_PRODUTO IN (33020103, 191400, 154590, 202592, 201375, 202606, 20800, 154614, 154590)
  AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE > TO_DATE('2020-03-16', 'YYYY-MM-DD')
  AND (EXTRACT(MONTH FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) != EXTRACT(MONTH FROM SYSDATE) OR EXTRACT(YEAR FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) != EXTRACT(YEAR FROM SYSDATE))
  GROUP BY ITMVTO_ESTOQUE.CD_PRODUTO, PRODUTO.DS_PRODUTO, EXTRACT(MONTH FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE), EXTRACT(YEAR FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE), EXTRACT(DAY FROM LAST_DAY(DT_MVTO_ESTOQUE))
  UNION
  SELECT
  ITMVTO_ESTOQUE.CD_PRODUTO,
  PRODUTO.DS_PRODUTO,
  SUM(ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR) AS CONSUMO_MENSAL,
  EXTRACT(MONTH FROM SYSDATE) AS MES,
  EXTRACT(YEAR FROM SYSDATE) AS ANO,
  EXTRACT(DAY FROM SYSDATE) AS CNT_DIAS,
  CEIL((SUM(ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR)/EXTRACT(DAY FROM SYSDATE))) AS CONSUMO_DIARIO_MEDIO
FROM
  ITMVTO_ESTOQUE
  JOIN UNI_PRO ON (
    ITMVTO_ESTOQUE.CD_PRODUTO = UNI_PRO.CD_PRODUTO AND
    ITMVTO_ESTOQUE.CD_UNI_PRO = UNI_PRO.CD_UNI_PRO  ---- ESTAVA NO REGISTRO ORIGINAL DO CARLOS - OU SEJA É NECESSÁRIO CONSIDERAR A UNIDADE DO PRODUTO NAQUELE LOTE DE MOVIMENTACAO
  )
  JOIN MVTO_ESTOQUE ON (
    ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE = MVTO_ESTOQUE.CD_MVTO_ESTOQUE AND
    MVTO_ESTOQUE.TP_MVTO_ESTOQUE IN ('P', 'S')
  )
  JOIN PRODUTO ON (
    ITMVTO_ESTOQUE.CD_PRODUTO = PRODUTO.CD_PRODUTO
  )
WHERE
  ITMVTO_ESTOQUE.CD_PRODUTO IN (33020103, 191400, 154590, 202592, 201375, 202606, 20800, 154614, 154590)
  AND EXTRACT(MONTH FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) = EXTRACT(MONTH FROM SYSDATE) AND EXTRACT(YEAR FROM MVTO_ESTOQUE.DT_MVTO_ESTOQUE) = EXTRACT(YEAR FROM SYSDATE)
  GROUP BY ITMVTO_ESTOQUE.CD_PRODUTO, PRODUTO.DS_PRODUTO, EXTRACT(MONTH FROM SYSDATE), EXTRACT(YEAR FROM SYSDATE), EXTRACT(DAY FROM SYSDATE)
  ORDER BY ANO ASC, MES ASC, DS_PRODUTO ASC;
