--------------------------------------------------------
--  Arquivo criado - Sexta-feira-Junho-19-2020   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View VDIC_ESTOQUE_COVID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "DBAMV"."VDIC_ESTOQUE_COVID" ("CD_PRODUTO", "DS_PRODUTO", "QT_ESTOQUE", "DS_UNIDADE") AS 
  SELECT cd_produto, 
       ds_produto, 
       qt_estoque, 
       ds_unidade
FROM (
SELECT   e.cd_estoque,
         e.ds_estoque,
         esp.cd_especie,
         esp.ds_especie,
         c.cd_classe,
         c.ds_classe,
         sc.cd_sub_cla,
         sc.ds_sub_cla,
         p.cd_produto,
         upper(p.ds_produto) ds_produto,
         SUM (es.qt_estoque_atual) / dbamv.verif_vl_fator_prod(p.cd_produto) qt_estoque,
         DBAMV.verif_ds_unid_prod(p.cd_produto) ds_unidade
    FROM dbamv.estoque e,
         dbamv.est_pro es,  
         dbamv.produto p,
         dbamv.sub_clas sc,
         dbamv.classe c,
         dbamv.especie esp
   WHERE e.cd_estoque = es.cd_estoque
     AND es.cd_produto IN 
      (SELECT cd_produto
       FROM dbamv.produto a
       WHERE ('N' = 'N' AND a.cd_produto = p.cd_produto) OR ('N' = 'S' AND a.cd_produto = p.cd_produto)
      )
     AND p.cd_sub_cla = sc.cd_sub_cla
     AND p.cd_classe = sc.cd_classe
     AND p.cd_especie = esp.cd_especie
     AND sc.cd_classe = c.cd_classe
     AND sc.cd_especie = esp.cd_especie
     AND c.cd_especie = esp.cd_especie
     AND p.sn_mestre = 'N'
     AND p.sn_kit = 'N'
     AND e.cd_multi_empresa = 1
   GROUP BY p.ds_produto,
         p.cd_produto
)
WHERE cd_produto in (154590,33020103,202592,154614);
REM INSERTING into DBAMV.VDIC_ESTOQUE_COVID
SET DEFINE OFF;
Insert into DBAMV.VDIC_ESTOQUE_COVID (CD_PRODUTO,DS_PRODUTO,QT_ESTOQUE,DS_UNIDADE) values ('154590','MASCARA PARA PROTEÇÃO CONTRA BACILO DE BAAR','1875','UNIDADE');
Insert into DBAMV.VDIC_ESTOQUE_COVID (CD_PRODUTO,DS_PRODUTO,QT_ESTOQUE,DS_UNIDADE) values ('154614','OCULOS DE PROTEÇÃO','2317','UNIDADE');
Insert into DBAMV.VDIC_ESTOQUE_COVID (CD_PRODUTO,DS_PRODUTO,QT_ESTOQUE,DS_UNIDADE) values ('202592','MASCARA DESCART. TRIPLA C/FILT.BACT.GRAMAT.30CM VISCOS CX-50','9750','UNIDADE');
Insert into DBAMV.VDIC_ESTOQUE_COVID (CD_PRODUTO,DS_PRODUTO,QT_ESTOQUE,DS_UNIDADE) values ('33020103','AVENTAL DE PROCEDIMENTO - AMARELO','8288','UNIDADE');
