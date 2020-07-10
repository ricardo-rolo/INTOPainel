-- Consumo Mensal
select
  ITMVTO_ESTOQUE.CD_PRODUTO,
  PRODUTO.DS_PRODUTO,
  SUM(ITMVTO_ESTOQUE.QT_MOVIMENTACAO * UNI_PRO.VL_FATOR) AS CONSUMO_MENSAL,
  EXTRACT(month from MVTO_ESTOQUE.DT_MVTO_ESTOQUE) as MES,
  EXTRACT(year from MVTO_ESTOQUE.DT_MVTO_ESTOQUE) as ANO
from
  ITMVTO_ESTOQUE
  join UNI_PRO on (
    ITMVTO_ESTOQUE.CD_PRODUTO = UNI_PRO.CD_PRODUTO and
    ITMVTO_ESTOQUE.CD_UNI_PRO = UNI_PRO.CD_UNI_PRO  ---- estava no registro Original do Carlos - ou seja é necessário considerar a unidade do produto naquele lote de movimentacao
  )
  join MVTO_ESTOQUE on (
    ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE = MVTO_ESTOQUE.CD_MVTO_ESTOQUE
  )
  join PRODUTO on (
    ITMVTO_ESTOQUE.CD_PRODUTO = PRODUTO.CD_PRODUTO
  )
  join COTA_SETOR on (    --- Não estamos apresentando cota - retiraria esse join - apenas consume recurso de maquina
    PRODUTO.CD_PRODUTO = COTA_SETOR.CD_PRODUTO
  )
  join SETOR on (  --- idem para este Join ---- Não estamos apresentando esta informação - retiraria esse join - apenas consume recurso de maquina
    COTA_SETOR.CD_SETOR = SETOR.CD_SETOR
  )
where
  ITMVTO_ESTOQUE.CD_PRODUTO in (
    SELECT
      CD_PRODUTO
    FROM
      DBAMV.PRODUTO
    WHERE DBAMV.PRODUTO.CD_PRODUTO in (154614, 191400, 201375, 97100068, 97100069, 97100070, 33020103, 940183, 96100029, 5100643, 20800, 200557, 202800, 33002102, 33002101, 202606, 21011, 202592)
  )
  AND MVTO_ESTOQUE.DT_MVTO_ESTOQUE > to_date('2020-01-01', 'yyyy-mm-dd')
  GROUP BY ITMVTO_ESTOQUE.CD_PRODUTO, PRODUTO.DS_PRODUTO, EXTRACT(month from MVTO_ESTOQUE.DT_MVTO_ESTOQUE), EXTRACT(year from MVTO_ESTOQUE.DT_MVTO_ESTOQUE)
