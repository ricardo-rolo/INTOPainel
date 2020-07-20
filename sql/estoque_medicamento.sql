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
    6501780, 1670049, 9460087, 9070017,
        1480231, 1480100, 9380512, 9380105,
        9670260, 9010340, 9010308, 9320048,
        9470181, 9480350, 9490016, 1470031,
        9540056, 9230065, 9230030, 9230057,
        9480193, 9460118, 1460010, 9460117,
        9480207, 9320064, 9150087, 9480266,
        1480320, 9480321, 1480061, 9480053,
        9060011, 9610097, 9610070, 9460176,
        9460095, 9460079, 9460054, 1460052,
        9600016, 9030074, 9060046, 9590225,
        9460036, 9480348, 1480142, 9480347,
        9460192, 9610062, 9480290, 9480150,
        9480151, 9680107, 9610054, 9470090,
        9110001, 9110009, 9060062, 9120073,
        9120081, 9120057, 1460010, 9320056,
        9230004, 1480061, 9380350, 9320153,
        9610071, 9230073, 9030074, 6502560,
        1480142, 9610062, 9610054, 9470155,
        6502604, 6502603, 6502471, 6502572,
        6502514
  );
