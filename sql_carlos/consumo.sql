--------------------------------------------------------
--  Arquivo criado - Sexta-feira-Junho-19-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View VDIC_CONSUMO_N95
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DBAMV"."VDIC_CONSUMO_N95" ("CD_SETOR", "NM_SETOR", "CD_PRODUTO", "DT_MVTO_ESTOQUE", "COTA", "CONSUMO", "DIFERENCA") AS 
  SELECT   r.cd_setor, 
         s.nm_setor, 
         p.cd_produto, 
         r.dt_mvto_estoque, 
         SUM (NVL(cota, 0)) AS cota,
         SUM (NVL (consumo, 0)) AS consumo,   
         SUM (NVL (consumo, 0)) - SUM (NVL (cota, 0)) AS diferenca
FROM (SELECT c.cd_setor, 
             c.cd_produto, ROUND ((c.qt_cota / c.nr_dias) * 30) AS cota,
             0 AS consumo, NULL AS dt_mvto_estoque
      FROM dbamv.cota_setor c
      WHERE TO_CHAR (c.cd_produto) LIKE '154590'
          UNION
      SELECT   m.cd_setor, i.cd_produto, 0 AS cota,
               SUM (i.qt_movimentacao * u.vl_fator) AS consumo, m.dt_mvto_estoque
      FROM dbamv.mvto_estoque m, dbamv.itmvto_estoque i, dbamv.uni_pro u
      WHERE TO_CHAR (m.dt_mvto_estoque, 'yyyy') LIKE '2020'
            AND m.tp_mvto_estoque IN ('P', 'S')
            AND TO_CHAR (i.cd_produto) LIKE '154590'
            AND m.cd_mvto_estoque = i.cd_mvto_estoque
            AND i.cd_uni_pro = u.cd_uni_pro
       GROUP BY m.dt_mvto_estoque, m.cd_setor, i.cd_produto) r,
       dbamv.setor s,
       dbamv.especie e,
       dbamv.produto p
WHERE e.tp_especie IN ('A', 'E')
     AND r.cd_setor = s.cd_setor
     AND p.cd_produto = r.cd_produto
     AND p.cd_especie = e.cd_especie
GROUP BY r.cd_setor, s.nm_setor, p.cd_produto, r.dt_mvto_estoque
  HAVING SUM (NVL (consumo, 0)) > SUM (NVL (cota, 0))
ORDER BY 3, r.dt_mvto_estoque;
