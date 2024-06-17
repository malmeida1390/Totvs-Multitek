#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCustoNeg  บAutor  ณ                    บ Data ณ  08/05/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTrata Custo Negativo de Produtos                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMultitek                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CustoNeg()

/*
SELECT  B2_VATU1,B2_VATU2,B2_VATU3,B2_VATU4,B2_VATU5
FROM SB2010
WHERE
B2_VFIM1  < 0  OR  B2_VFIM2 < 0  OR  B2_VFIM3 < 0 OR B2_VFIM4 < 0 OR B2_VFIM5  < 0 OR
B2_VATU1  < 0  OR  B2_VATU2 < 0  OR  B2_VATU3 < 0 OR B2_VATU4 < 0 OR  B2_VATU5 < 0 OR
B2_CM1    < 0  OR  B2_CM2   < 0  OR  B2_CM3   < 0 OR B2_CM4   < 0 OR B2_CM5 < 0


SELECT D3_CUSTO1,D3_CUSTO2,D3_CUSTO3,D3_CUSTO4,D3_CUSTO5
FROM SD3010
WHERE
D3_CUSTO1 < 0 OR D3_CUSTO2 < 0 OR D3_CUSTO3 < 0 OR D3_CUSTO4 < 0 OR D3_CUSTO5 < 0


SELECT  D1_CUSTO,D1_CUSTO2,D1_CUSTO3,D1_CUSTO4,D1_CUSTO5
FROM SD1010
WHERE
D1_CUSTO < 0 OR D1_CUSTO2 < 0 OR D1_CUSTO3 < 0 OR D1_CUSTO4 < 0 OR D1_CUSTO5 < 0


SELECT D2_CUSTO1,D2_CUSTO2,D2_CUSTO3,D2_CUSTO4,D2_CUSTO5
FROM SD2010
WHERE
D2_CUSTO1 < 0 OR D2_CUSTO2 < 0 OR D2_CUSTO3 < 0 OR D2_CUSTO4 < 0 OR D2_CUSTO5 < 0


Select * from sb9010 where
B9_VINI1 < 0 OR B9_VINI2 < 0 OR B9_VINI3 < 0 OR B9_VINI4 < 0 OR B9_VINI5 < 0


*/

aStruSB2  := SB2->(dbStruct())
lQuery    := .T.
cAliasSB2 := "MFATC02SB2"

cQuery := ""

cQuery := " SELECT R_E_C_N_O_ RECNO FROM "
cQuery += RetSqlName("SB2")+" (NOLOCK) SB2 "
cQuery += " WHERE
cQuery += " ( B2_VFIM1  < 0  OR  B2_VFIM2 < 0  OR  B2_VFIM3 < 0 OR B2_VFIM4 < 0 OR B2_VFIM5  < 0 OR
cQuery += "   B2_VATU1  < 0  OR  B2_VATU2 < 0  OR  B2_VATU3 < 0 OR B2_VATU4 < 0 OR  B2_VATU5 < 0 OR
cQuery += "   B2_CM1    < 0  OR  B2_CM2   < 0  OR  B2_CM3   < 0 OR B2_CM4   < 0 OR B2_CM5 < 0 ) AND "
cQuery += " D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB2,.T.,.T.)
DbSelectArea(cAliasSB2)

While !(cAliasSB2)->(Eof())
	DbSelectArea("SB2")
	DbGoto((cAliasSB2)->RECNO)
	Reclock("SB2",.F.)
	IIf ( B2_VFIM1 < 0 , B2_VFIM1 := 0, )
	IIf ( B2_VFIM2 < 0 , B2_VFIM2 := 0, )
	IIf ( B2_VFIM3 < 0 , B2_VFIM3 := 0, )
	IIf ( B2_VFIM4 < 0 , B2_VFIM4 := 0, )
	IIf ( B2_VFIM5 < 0 , B2_VFIM5 := 0, )

	IIf ( B2_VATU1 < 0 , B2_VATU1 := 0, )
	IIf ( B2_VATU2 < 0 , B2_VATU2 := 0, )
	IIf ( B2_VATU3 < 0 , B2_VATU3 := 0, )
	IIf ( B2_VATU4 < 0 , B2_VATU4 := 0, )
	IIf ( B2_VATU5 < 0 , B2_VATU5 := 0, )

	IIf ( B2_CM1   < 0 , B2_CM1   := 0, )
	IIf ( B2_CM2   < 0 , B2_CM2   := 0, )
	IIf ( B2_CM3   < 0 , B2_CM3   := 0, )
	IIf ( B2_CM4   < 0 , B2_CM4   := 0, )
	IIf ( B2_CM5   < 0 , B2_CM5   := 0, )

	MsUnlock()
	DbSelectArea(cAliasSB2)
	(cAliasSB2)->(Dbskip())
Enddo

(cAliasSB2)->(DbCloseArea())

/////////////////////////////////////////////////////////

aStruSD3  := SD3->(dbStruct())
lQuery    := .T.
cAliasSD3 := "MFATC02SD3"

cQuery := ""

cQuery := " SELECT R_E_C_N_O_ RECNO FROM "
cQuery += RetSqlName("SD3")+" (NOLOCK) SD3 "
cQuery += " WHERE
cQuery += " ( D3_CUSTO1 < 0 OR D3_CUSTO2 < 0 OR D3_CUSTO3 < 0 OR D3_CUSTO4 < 0 OR D3_CUSTO5 < 0 ) AND "
cQuery += "  D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD3,.T.,.T.)
DbSelectArea(cAliasSD3)

While !(cAliasSD3)->(Eof())
	DbSelectArea("SD3")
	DbGoto((cAliasSD3)->RECNO)
	Reclock("SD3",.F.)
	IIf ( D3_CUSTO1 < 0 , D3_CUSTO1 :=0, )
	IIf ( D3_CUSTO2 < 0 , D3_CUSTO2 :=0, )
	IIf ( D3_CUSTO3 < 0 , D3_CUSTO3 :=0, )
	IIf ( D3_CUSTO4 < 0 , D3_CUSTO4 :=0, )
	IIf ( D3_CUSTO5 < 0 , D3_CUSTO5 :=0, )
	MsUnlock()
	DbSelectArea(cAliasSD3)
	(cAliasSD3)->(Dbskip())
Enddo

(cAliasSD3)->(DbCloseArea())


/////////////////////////////////////////////////////////

aStruSD1  := SD1->(dbStruct())
lQuery    := .T.
cAliasSD1 := "MFATC02SD1"

cQuery := ""

cQuery := " SELECT R_E_C_N_O_ RECNO FROM "
cQuery += RetSqlName("SD1")+" (NOLOCK) SD1 "
cQuery += " WHERE
cQuery += " ( D1_CUSTO < 0 OR D1_CUSTO2 < 0 OR D1_CUSTO3 < 0 OR D1_CUSTO4 < 0 OR D1_CUSTO5 < 0 ) AND "
cQuery += "  D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
DbSelectArea(cAliasSD1)

While !(cAliasSD1)->(Eof())
	DbSelectArea("SD1")
	DbGoto((cAliasSD1)->RECNO)
	Reclock("SD1",.F.)
	IIf ( D1_CUSTO  < 0 , D1_CUSTO  :=0, )
	IIf ( D1_CUSTO2 < 0 , D1_CUSTO2 :=0, )
	IIf ( D1_CUSTO3 < 0 , D1_CUSTO3 :=0, )
	IIf ( D1_CUSTO4 < 0 , D1_CUSTO4 :=0, )
	IIf ( D1_CUSTO5 < 0 , D1_CUSTO5 :=0, )
	MsUnlock()
	DbSelectArea(cAliasSD1)
	(cAliasSD1)->(Dbskip())
Enddo

(cAliasSD1)->(DbCloseArea())


/////////////////////////////////////////////////////////

aStruSD2  := SD2->(dbStruct())
lQuery    := .T.
cAliasSD2 := "MFATC02SD2"
cQuery := ""
cQuery := " SELECT R_E_C_N_O_ RECNO  FROM "
cQuery += RetSqlName("SD2")+" (NOLOCK) SD2 "
cQuery += " WHERE
cQuery += " ( D2_CUSTO1 < 0 OR D2_CUSTO2 < 0 OR D2_CUSTO3 < 0 OR D2_CUSTO4 < 0 OR D2_CUSTO5 < 0 ) AND "
cQuery += " D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
DbSelectArea(cAliasSD2)

While !(cAliasSD2)->(Eof())
	DbSelectArea("SD2")
	DbGoto((cAliasSD2)->RECNO)
	Reclock("SD2",.F.)
	IIf ( D2_CUSTO1 < 0 , D2_CUSTO1  :=0, )
	IIf ( D2_CUSTO2 < 0 , D2_CUSTO2 :=0, )
	IIf ( D2_CUSTO3 < 0 , D2_CUSTO3 :=0, )
	IIf ( D2_CUSTO4 < 0 , D2_CUSTO4 :=0, )
	IIf ( D2_CUSTO5 < 0 , D2_CUSTO5 :=0, )
	MsUnlock()
	DbSelectArea(cAliasSD2)
	(cAliasSD2)->(Dbskip())
Enddo

(cAliasSD2)->(DbCloseArea())


/////////////////////////////////////////////////////////

aStruSB9  := SB9->(dbStruct())
lQuery    := .T.
cAliasSB9 := "MFATC02SB9"
cQuery := ""
cQuery := " SELECT R_E_C_N_O_ RECNO FROM "
cQuery += RetSqlName("SB9")+" (NOLOCK) SB9 "
cQuery += " WHERE
cQuery += " ( B9_VINI1 < 0 OR B9_VINI2 < 0 OR B9_VINI3 < 0 OR B9_VINI4 < 0 OR B9_VINI5 < 0 ) AND "
cQuery += " D_E_L_E_T_<>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB9,.T.,.T.)
DbSelectArea(cAliasSB9)

While !(cAliasSB9)->(Eof())
	DbSelectArea("SB9")
	DbGoto((cAliasSB9)->RECNO)
	Reclock("SB9",.F.)
	IIf ( B9_VINI1 < 0 , B9_VINI1:=0 , )
	IIf ( B9_VINI2 < 0 , B9_VINI2:=0 , )
	IIf ( B9_VINI3 < 0 , B9_VINI3:=0 , )
	IIf ( B9_VINI4 < 0 , B9_VINI4:=0 , )
	IIf ( B9_VINI5 < 0 , B9_VINI5:=0 , )
	MsUnlock()
	DbSelectArea(cAliasSB9)
	(cAliasSB9)->(Dbskip())
Enddo

(cAliasSB9)->(DbCloseArea())


Return
