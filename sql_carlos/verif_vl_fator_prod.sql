create FUNCTION VERIF_VL_FATOR_PROD (
    VCD_PRODUTO IN NUMBER,
    VTP_RELATORIO IN VARCHAR2 := NULL
) RETURN NUMBER IS -- PL/SQL Specification
-- PL/SQL Specification
CURSOR c1 (pTpRelatorio IN VARCHAR2) IS
SELECT uni_pro.vl_fator
FROM dbamv.uni_pro
WHERE uni_pro.cd_produto = vcd_produto
    AND uni_pro.tp_relatorios = pTpRelatorio
    AND uni_pro.sn_ativo = 'S';
CURSOR C_Tp_Unidade(pTpGrupo In Varchar2) IS
Select 1 Grupo,
    Config_Unidade.Cd_Ordem,
    Config_Unidade.Tp_Unidade
From Dbamv.Config_Unidade,
    Dbamv.Grupo_Unidade
Where Config_Unidade.Cd_Grupo = Grupo_Unidade.Cd_Grupo
    and Grupo_Unidade.Tp_Grupo = pTpGrupo
Union
Select 2 Grupo,
    Config_Unidade.Cd_Ordem,
    Config_Unidade.Tp_Unidade
From Dbamv.Config_Unidade,
    Dbamv.Grupo_Unidade
Where Config_Unidade.Cd_Grupo = Grupo_Unidade.Cd_Grupo
    and Grupo_Unidade.Tp_Grupo = 'R'
Order By 1,
    2;
nVl_Fator NUMBER;
-- PL/SQL Block
-- PL/SQL Block
BEGIN -- *** Caso tenha sido informado um tipo default ***
IF VTp_Relatorio IS NOT NULL THEN OPEN C1(VTp_Relatorio);
FETCH C1 INTO nVl_Fator;
CLOSE C1;
IF nVl_Fator IS NOT NULL THEN RETURN nVl_Fator;
END IF;
END IF;
FOR C2 IN C_Tp_Unidade(VTp_Relatorio) LOOP OPEN C1(C2.Tp_Unidade);
FETCH C1 INTO nVl_Fator;
CLOSE C1;
EXIT
WHEN nVl_Fator IS NOT NULL;
END LOOP;
RETURN NVL(nVl_Fator, 1);
END;
/