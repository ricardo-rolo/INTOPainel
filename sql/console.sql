SELECT OWNER, VIEW_NAME FROM ALL_VIEWS
    WHERE VIEW_NAME LIKE '%VDIC%'
    AND VIEW_NAME LIKE '%ESTOQUE%';

SELECT OWNER, TABLE_NAME, NUM_ROWS FROM ALL_ALL_TABLES
    WHERE REGEXP_LIKE(TABLE_NAME, 'DOCUMENTO')
    AND NUM_ROWS > 0;

SELECT * FROM all_tab_modifications
    WHERE ALL_TAB_MODIFICATIONS.TIMESTAMP > TO_DATE('2020-01-01', 'YYYY-MM-DD') ORDER BY ALL_TAB_MODIFICATIONS.TIMESTAMP DESC;

SELECT *
FROM DBAMV.ITMVTO_ESTOQUE;

SELECT *
FROM DBAMV.MVTO_ESTOQUE;

SELECT
    MVTO_ESTOQUE.CD_MVTO_ESTOQUE,
    MVTO_ESTOQUE.CD_ESTOQUE,
    MVTO_ESTOQUE.DT_MVTO_ESTOQUE,
    MVTO_ESTOQUE.HR_MVTO_ESTOQUE,
    MVTO_ESTOQUE.CD_UNID_INT,
    MVTO_ESTOQUE.CD_SETOR,
    MVTO_ESTOQUE.CD_ESTOQUE_DESTINO,
    ITMVTO_ESTOQUE.CD_PRODUTO,
    PRODUTO.DS_PRODUTO
FROM DBAMV.MVTO_ESTOQUE
LEFT JOIN DBAMV.ITMVTO_ESTOQUE ON (DBAMV.MVTO_ESTOQUE.CD_MVTO_ESTOQUE = DBAMV.ITMVTO_ESTOQUE.CD_MVTO_ESTOQUE)
LEFT JOIN DBAMV.PRODUTO ON (DBAMV.ITMVTO_ESTOQUE.CD_PRODUTO = PRODUTO.CD_PRODUTO)
    WHERE TO_DATE(MVTO_ESTOQUE.DT_MVTO_ESTOQUE) > TO_DATE('2020-01-01', 'YYYY-MM-DD');

SELECT *
FROM DBAMV.LICITACAO
    WHERE DT_LICITACAO IS NOT NULL
          ORDER BY DT_LICITACAO DESC;


SELECT
    PRODUTO.CD_PRODUTO,
    PRODUTO.DS_PRODUTO,
    PRODUTO.QT_ESTOQUE_ATUAL
FROM DBAMV.PRODUTO
     WHERE REGEXP_LIKE(PRODUTO.DS_PRODUTO,'LUVA|AVENTAL|MÁSCARA|MASCARA|ÁLCOOL|ALCOOL|ÓCULOS|OCULOS|SAPATILHA|TOUCA|COVID|CLOROQUINA');

SELECT
    PRODUTO_ULTIMAS_COMPRAS.CD_PRODUTO,
    PRODUTO_ULTIMAS_COMPRAS.DT_ENTRADA,
    PRODUTO_ULTIMAS_COMPRAS.HR_ENTRADA,
    PRODUTO_ULTIMAS_COMPRAS.QT_ENTRADA
FROM DBAMV.PRODUTO_ULTIMAS_COMPRAS
    WHERE DT_ENTRADA > TO_DATE('2020-01-01', 'yyyy-mm-dd');

SELECT *
FROM DBAMV.EST_ATUAL
    WHERE CD_PRODUTO IN (
        SELECT CD_PRODUTO FROM PRODUTO
            WHERE REGEXP_LIKE(PRODUTO.DS_PRODUTO,'LUVA|AVENTAL|MÁSCARA|MASCARA|ÁLCOOL|ALCOOL|ÓCULOS|OCULOS|SAPATILHA|TOUCA|COVID')
        )
    AND ATUAL IS NOT NULL;

SELECT
    PRODUTO.CD_PRODUTO,
    PRODUTO.DS_PRODUTO,
    PRODUTO.QT_ESTOQUE_ATUAL,
    EST_ATUAL.CD_ESTOQUE,
    EST_ATUAL.CD_ESPECIE,
    EST_ATUAL.DS_UNIDADE,
    EST_ATUAL.ATUAL
FROM DBAMV.PRODUTO LEFT JOIN DBAMV.EST_ATUAL ON (PRODUTO.CD_PRODUTO = EST_ATUAL.CD_PRODUTO)
     WHERE REGEXP_LIKE(PRODUTO.DS_PRODUTO,'LUVA|AVENTAL|MÁSCARA|MASCARA|ÁLCOOL|ALCOOL|ÓCULOS|OCULOS|SAPATILHA|TOUCA|COVID');

SELECT *
FROM DBAMV.VDIC_COMPRA;


