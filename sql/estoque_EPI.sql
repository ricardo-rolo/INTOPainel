SELECT
  cd_produto,
  ds_produto,
  qt_estoque,
  ds_unidade
FROM
  (
    SELECT
      estoque.cd_estoque,
      estoque.ds_estoque,
      especie.cd_especie,
      especie.ds_especie,
      classe.cd_classe,
      classe.ds_classe,
      sub_clas.cd_sub_cla,
      sub_clas.ds_sub_cla,
      produto.cd_produto,
      upper(produto.ds_produto) ds_produto,
      SUM (est_pro.qt_estoque_atual) / dbamv.verif_vl_fator_prod(produto.cd_produto) qt_estoque,
      DBAMV.verif_ds_unid_prod(produto.cd_produto) ds_unidade
    FROM
      dbamv.estoque ESTOQUE,
      dbamv.est_pro,
      dbamv.produto,
      dbamv.sub_clas,
      dbamv.classe,
      dbamv.especie
    WHERE
      estoque.cd_estoque = est_pro.cd_estoque
      AND est_pro.cd_produto IN (
        SELECT
          cd_produto
        FROM
          dbamv.produto a
        WHERE
          (
            a.cd_produto = produto.cd_produto
          )
      )
      AND produto.cd_sub_cla = sub_clas.cd_sub_cla
      AND produto.cd_classe = sub_clas.cd_classe
      AND produto.cd_especie = especie.cd_especie
      AND sub_clas.cd_classe = classe.cd_classe
      AND sub_clas.cd_especie = especie.cd_especie
      AND classe.cd_especie = especie.cd_especie
      AND produto.sn_mestre = 'N'
      AND produto.sn_kit = 'N'
      AND estoque.cd_multi_empresa = 1
    GROUP BY
      produto.ds_produto,
      produto.cd_produto
  )
WHERE
  CD_PRODUTO in (
    (
      SELECT
        CD_PRODUTO
      FROM
        DBAMV.PRODUTO
      WHERE
        CD_PRODUTO IN (33020103, 191400, 154590, 202592, 201375, 202606, 20800, 154614, 154590)
    )
  )
