#include "protheus.ch"

User Function bgCFret()

Private aRotina := {}
Private cCadastro := "Cadastros do Frete"

AAdd(aRotina, {"Pesquisar" ,"AxPesqui" , 0, 1})
AAdd(aRotina, {"Incluir"   ,"U_bgCFret_", 0, 3})
AAdd(aRotina, {"cIdades"   ,"U_bgCFret_", 0, 4})
AAdd(aRotina, {"pReços"    ,"U_bgCFret_", 0, 4})
AAdd(aRotina, {"Excluir"   ,"U_bgCFret_", 0, 5})
AAdd(aRotina, {"Copiar"    ,"U_bgCFret_", 0, 6})
AAdd(aRotina, {"conf. Frete","U_bgCnFret", 0, 6})

dbSelectArea("SZO")
dbSetOrder(1)
dbGoTop()

mBrowse(,,,,"SZO",,,,,3) // 3 é o default, duplo clique

Return nil

//----------------------------------------------------------------------------------------------------------------//
// Modelo 3.
//----------------------------------------------------------------------------------------------------------------//

User Function bgCFret_(cAlias, nRecno, nOpc)

Local nOpcE
Local nOpcG
Local lRet  := .T.
Local nTipo := 0

Private nOpcFrete    := nOpc
Private aCols        := {}
Private aHeader      := {}
Private aCpoEnchoice := {}
Private aAltEnchoice := {}
Private aAlt         := {}

If nOpcFrete == 2 // Incluir
	nOpcE := 3
	nOpcG := 3
	nTipo := 1
EndIf

If nOpcFrete == 3 // Alterar
	If Empty(SZO->ZO_TRANSP)
		If !MsgYesNo("Cuidado, você está alterando uma região padrão. Altere somente para correção de erros.", "Continua?")
			Return
		EndIf
	EndIf

	nOpcE := 4
	nOpcG := 4
	nTipo := 1
EndIf

If nOpcFrete == 4 // Preços
	If Empty(SZO->ZO_TRANSP)
		Alert("Não é possível definir preços em uma região padrão.", "Atenção!")
		Return
	EndIf

	SZN->(dbSetOrder(1))
	If SZN->(dbSeek(xFilial("SZN")+SZO->ZO_COD))
		nOpcE := 4
		nOpcG := 4
	Else
		nOpcE := 3
		nOpcG := 3
	EndIf
	
	nTipo := 2
EndIf

If nOpcFrete == 5 // Excluir
	nOpcE := 5
	nOpcG := 5
	nTipo := 1
EndIf

If nOpcFrete == 6 // Copiar
	nOpcE := 3
	nOpcG := 3
	nTipo := 1

	If !Empty(SZO->ZO_TRANSP)
		If !MsgYesNo("Você está copiando a partir de uma região específica para uma transportadora.","Confirma?")
			Return
		EndIf
	EndIf
EndIf

If nTipo == 1
	// Cria variaveis de memoria dos campos da tabela Pai.
	// 1o. parametro: Alias do arquivo --> é case-sensitive, ou seja precisa ser como está no Dic.Dados.
	// 2o. parametro: .T.              --> cria variaveis em branco, preenchendo com o inicializador-padrao.
	//                .F.              --> preenche com o conteudo dos campos.
	RegToMemory("SZO", (nOpcFrete==2 .or. nOpcFrete==6))
	If nOpcFrete == 6
		M->ZO_DESC := SZO->ZO_DESC
		M->ZO_DTRANSP := ""
		M->ZO_DTATU := dDataBase
	EndIf

	// Cria variaveis de memoria dos campos da tabela Filho.
	RegToMemory("SZD", (nOpcFrete==2))

	CriaHeadMn()

	CriaColsMn(nOpcFrete, nOpcE, nOpcG)

	lRet := Modelo3("Região / Municipios", "SZO", "SZD", aCpoEnchoice, "U_bgCFretE" /*cLinOK*/, "U_bgCFretA" /*cTudoOK*/, nOpcE, nOpcG, "AllwaysTrue" /*cFieldOK*/, .T. /*lVirtual*/, 9999 /*nLinhas*/, aAltEnchoice, 0 /*nFreeze*/)

	If lRet
		If      nOpcFrete == 2 .Or. nOpcFrete == 6
			Processa({||GrvDadosMn()}, "Região / Municipios", "Gravando os dados, aguarde...")
		ElseIf nOpcFrete == 3
			Processa({||AltDadosMn()}, "Região / Municipios", "Alterando os dados, aguarde...")
		ElseIf nOpcFrete == 5
			If MsgYesNo("Confirma a exclusão de todos os dados dessa região, incluindo preços e taxas?", "ATENÇÃO!")
				Processa({||ExcDadosMn()}, "Região / Municipios", "Excluindo os dados, aguarde...")
			EndIf
		EndIf
	Else
		RollBackSX8()
	EndIf
ElseIf nTipo == 2
	// Cria variaveis de memoria dos campos da tabela Pai.
	// 1o. parametro: Alias do arquivo --> é case-sensitive, ou seja precisa ser como está no Dic.Dados.
	// 2o. parametro: .T.              --> cria variaveis em branco, preenchendo com o inicializador-padrao.
	//                .F.              --> preenche com o conteudo dos campos.
	RegToMemory("SZN", (nOpcE==3))
	If nOpcE == 3
		M->ZN_REGIAO := SZO->ZO_COD
	EndIf

	// Cria variaveis de memoria dos campos da tabela Filho.
	RegToMemory("SZJ", (nOpcE==3))

	CriaHeadPr()

	CriaColsPr(nOpcFrete, nOpcE, nOpcG)

	lRet := Modelo3("Preços e Taxas", "SZN", "SZJ", aCpoEnchoice, "U_bgCFretB" /*cLinOK*/, "U_bgCFretC" /*cTudoOK*/, nOpcE, nOpcG, "AllwaysTrue" /*cFieldOK*/, .T. /*lVirtual*/, 9999 /*nLinhas*/, aAltEnchoice, 0 /*nFreeze*/)

	If lRet
		If nOpcE == 3
			Processa({||GrvDadosPr()}, "Preços e Taxas", "Gravando os dados, aguarde...")
		ElseIf nOpcE == 4
			Processa({||AltDadosPr()}, "Preços e Taxas", "Alterando os dados, aguarde...")
		EndIf
	Else
		RollBackSX8()
	EndIf
EndIf
Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function CriaHeadMn()

aHeader      := {}
aCpoEnchoice := {}
aAltEnchoice := {}

// aHeader é igual ao do Modelo2.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZD")

While !SX3->(EOF()) .And. SX3->X3_Arquivo == "SZD"
	
	If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
		cNivel >= SX3->X3_Nivel .And.;                  // Nivel do Usuario é maior que o Nivel do Campo.
		Trim(SX3->X3_Campo) $ "ZD_MUN/ZD_DMUN/ZD_PRAZDE/ZD_PRAZATE"
		
		AAdd(aHeader, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
		
	EndIf
	
	SX3->(dbSkip())
	
End

// Campos da Enchoice.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZO")

While !SX3->(EOF()) .And. SX3->X3_Arquivo == "SZO"
	
	If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
		cNivel >= SX3->X3_Nivel                         // Nivel do Usuario é maior que o Nivel do Campo.
		
		// Campos da Enchoice.
		AAdd(aCpoEnchoice, X3_Campo)
		
		// Campos da Enchoice que podem ser editadas.
		// Se tiver algum campo que nao deve ser editado, nao incluir aqui.
		AAdd(aAltEnchoice, X3_Campo)
		
	EndIf
	
	SX3->(dbSkip())
	
End

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function CriaColsMn(nOpcFrete, nOpcE, nOpcG)

Local nQtdCpo := 0
Local i       := 0
Local nCols   := 0

nQtdCpo := Len(aHeader)
aCols   := {}
aAlt    := {}

If nOpcFrete == 2       // Inclusao.
	
	AAdd(aCols, Array(nQtdCpo+1))
	
	For i := 1 To nQtdCpo
		aCols[1][i] := CriaVar(aHeader[i][2])
	Next
	
	aCols[1][nQtdCpo+1] := .F.
	
Else
	
	dbSelectArea("SZD")
	dbSetorder(1)
	dbSeek(xFilial("SZD") + SZO->ZO_COD)
	
	While !EOF() .And. SZD->ZD_Filial == xFilial("SZD") .And. SZD->ZD_REGIAO == SZO->ZO_COD
		
		AAdd(aCols, Array(nQtdCpo+1))
		nCols++
		
		For i := 1 To nQtdCpo
			If aHeader[i][10] <> "V"
				aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))
			Else
				aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
			EndIf
		Next
		
		aCols[nCols][nQtdCpo+1] := .F.
		
		AAdd(aAlt, Recno())
		
		dbSkip()
		
	End
	
EndIf

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function GrvDadosMn()

Local bCampo := {|nField| Field(nField)}
Local i      := 0
Local y      := 0

ProcRegua(Len(aCols) + FCount())

ConfirmSx8()

// Grava o registro da tabela Pai, obtendo o valor de cada campo
// a partir da var. de memoria correspondente.

dbSelectArea("SZO")
RecLock("SZO", .T.)
For i := 1 To FCount()
	IncProc()
	If "FILIAL" $ FieldName(i)
		FieldPut(i, xFilial("SZO"))
	Else
		FieldPut(i, M->&(Eval(bCampo,i)))
	EndIf
Next
SZO->ZO_DTATU := dDataBase
MSUnlock()

// Grava os registros da tabela Filho.

dbSelectArea("SZD")
dbSetorder(1)

For i := 1 To Len(aCols)
	IncProc()
	If !aCols[i][Len(aHeader)+1]       // A linha nao esta deletada, logo, pode gravar.
		RecLock("SZD", .T.)
			SZD->ZD_FILIAL := xFilial("SZD")
			SZD->ZD_REGIAO   := SZO->ZO_COD
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
		MSUnlock()
	EndIf
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function AltDadosMn()

Local i      := 0
Local y      := 0

ProcRegua(Len(aCols) + FCount())

dbSelectArea("SZO")
RecLock("SZO", .F.)

For i := 1 To FCount()
	IncProc()
	If "FILIAL" $ FieldName(i)
		FieldPut(i, xFilial("SZO"))
	Else
		FieldPut(i, M->&(fieldname(i)))
	EndIf
Next
SZO->ZO_DTATU := dDataBase
MSUnlock()

dbSelectArea("SZD")
dbSetOrder(1)

For i := 1 To Len(aCols)
	
	If i <= Len(aAlt)
		
		dbGoTo(aAlt[i])
		RecLock("SZD", .F.)
		
		If aCols[i][Len(aHeader)+1]
			dbDelete()
		Else
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
		EndIf
		
		MSUnlock()
		
	Else
		
		If !aCols[i][Len(aHeader)+1]
			RecLock("SZD", .T.)
			ZD_FILIAL := xFilial("SZD")
			ZD_REGIAO := SZO->ZO_COD
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
			MSUnlock()
		EndIf
		
	EndIf
	
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function ExcDadosMn()

ProcRegua(Len(aCols))   // +1 é por causa da exclusao do arq. de cabeçalho.

dbSelectArea("SZD")
dbSetOrder(1)
dbSeek(xFilial("SZD") + SZO->ZO_COD)

While !EOF() .And. SZD->ZD_FILIAL == xFilial("SZD") .And. SZD->ZD_REGIAO == SZO->ZO_COD
	IncProc()
	RecLock("SZD", .F.)
	dbDelete()
	MSUnlock()
	dbSkip()
End

dbSelectArea("SZN")
dbSetOrder(1)
If dbSeek(xFilial("SZN") + SZO->ZO_COD)
	IncProc()
	RecLock("SZN", .F.)
	dbDelete()
	MSUnlock()
	dbSkip()
End

dbSelectArea("SZJ")
dbSetOrder(1)
dbSeek(xFilial("SZJ") + SZO->ZO_COD)

While !EOF() .And. SZJ->ZJ_FILIAL == xFilial("SZJ") .And. SZJ->ZJ_REGIAO == SZO->ZO_COD
	IncProc()
	RecLock("SZJ", .F.)
	dbDelete()
	MSUnlock()
	dbSkip()
End

dbSelectArea("SZO")
dbSetOrder(1)
IncProc()
RecLock("SZO", .F.)
dbDelete()
MSUnlock()

Return Nil

//----------------------------------------------------------------------------------------------------------------//
// Linha OK dos Municípios
User Function bgCFretE()

	Local lRet := .T.

	If lRet .And. GDFieldGet("ZD_PRAZDE") > GDFieldGet("ZD_PRAZATE")
		Alert("[Prazo DE] maior que [Prazo ATÉ].")
		lRet := .F.
	EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
// Tudo OK dos Municípios
User Function bgCFretA()

Local i,y
Local lRet := .T.
Local nDel := 0
Local cMun := ""
Local aArea := GetArea()
Local cQuery

// Exclui Municipios repetidos
For i:=1 to Len(aCols)
	For y:=i+1 To Len(aCols)
		If !(aCols[i][Len(aHeader)+1]) .And. (aCols[y,1] == aCols[i,1])
			aCols[i][Len(aHeader)+1] := .T.
		Endif
	Next
Next

If lRet .And. Empty(M->ZO_DESC)
	Alert("Informe um nome para região.")
	lRet := .F.
EndIf

If lRet .And. nOpcFrete == 3 .And. Empty(SZO->ZO_TRANSP) .And. !Empty(M->ZO_TRANSP)
	Alert("Essa é uma região padrão e não pode ter transportadora.")
	lRet := .F.
EndIf

If lRet .And. nOpcFrete == 3 .And. !Empty(SZO->ZO_TRANSP) .And. Empty(M->ZO_TRANSP)
	Alert("Essa é uma região específica de uma transportadora e deve continuar sendo.")
	lRet := .F.
EndIf

If lRet .And. nOpcFrete == 2 .And. Empty(M->ZO_TRANSP)
	lRet := MsgYesNo("Confirma a inclusão de uma região padrão?", "Região sem transportadora")
Endif

If lRet .And. nOpcFrete == 6 .And. Empty(M->ZO_TRANSP)
	Alert("Informe uma transportadora.")
	lRet := .F.
Endif

If lRet .And. !Empty(M->ZO_TRANSP)
	// Verificar municipios atendidas em outras regiões
	For i := 1 To Len(aCols)
		If !GdDeleted(i)
			cMun := GdFieldGet("ZD_MUN", i)
			cDMun := GdFieldGet("ZD_DMUN", i)

			cQuery := "select ZO_COD, ZO_DESC from SZO010 inner join SZD010 on SZD010.D_E_L_E_T_ = '' and ZD_FILIAL = '"+xFilial("SZD")+"' and ZO_COD = ZD_REGIAO and ZD_MUN ='"+cMun+"' and ZD_REGIAO <> '"+M->ZO_COD+"' where ZO_TRANSP = '"+M->ZO_TRANSP+"' and ZO_FILIAL = '"+xFilial("SZO")+"' and SZO010.D_E_L_E_T_ = ''"
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PED",.T.,.T.)
			dbSelectArea("PED")
			dbGoTop()
			While !Eof()
				If MsgYesNo("O municipio ["+AllTrim(cMun)+"-"+AllTrim(cDMun)+"] já é atendido por essa transportadora pela região ["+AllTrim(PED->ZO_COD)+"-"+AllTrim(PED->ZO_DESC)+"].", "Excluir municipio?")
					aCols[i][Len(aHeader)+1] := .T.
				Else
					lRet := .F.
				EndIf
				dbSkip()
			End

			dbCloseArea()
			
		EndIf
	Next
EndIf

For i := 1 To Len(aCols)
	If aCols[i][Len(aHeader)+1]
		nDel++
	EndIf
Next

If lRet .And. nDel == Len(aCols)
	MsgInfo("Para excluir todos os itens, utilize a opção EXCLUIR", "Região / Municipios")
	lRet := .F.
EndIf

RestArea(aArea)

Return lRet


//----------------------------------------------------------------------------------------------------------------//
Static Function CriaHeadPr()

aHeader      := {}
aCpoEnchoice := {}
aAltEnchoice := {}

// aHeader é igual ao do Modelo2.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZJ")

While !SX3->(EOF()) .And. SX3->X3_Arquivo == "SZJ"
	
	If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
		cNivel >= SX3->X3_Nivel .And.;                 // Nivel do Usuario é maior que o Nivel do Campo.
		Trim(SX3->X3_Campo) $ "ZJ_PESODE/ZJ_PESOATE/ZJ_VALOR/ZJ_VALOREX/ZJ_GRIS/ZJ_ADV"
		
		AAdd(aHeader, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
		
	EndIf
	
	SX3->(dbSkip())
	
End

// Campos da Enchoice.

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZN")

While !SX3->(EOF()) .And. SX3->X3_Arquivo == "SZN"
	
	If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo é usado.
		cNivel >= SX3->X3_Nivel .And.;                 // Nivel do Usuario é maior que o Nivel do Campo.
		!(Trim(SX3->X3_Campo) $ "ZN_REGIAO")

		// Campos da Enchoice.
		AAdd(aCpoEnchoice, X3_Campo)
		
		// Campos da Enchoice que podem ser editadas.
		// Se tiver algum campo que nao deve ser editado, nao incluir aqui.
		AAdd(aAltEnchoice, X3_Campo)
		
	EndIf
	
	SX3->(dbSkip())
	
End

Return Nil


//----------------------------------------------------------------------------------------------------------------//
Static Function CriaColsPr(nOpcFrete, nOpcE, nOpcG)

Local nQtdCpo := 0
Local i       := 0
Local nCols   := 0

nQtdCpo := Len(aHeader)
aCols   := {}
aAlt    := {}

If nOpcE == 3         // Inclusao.
	
	AAdd(aCols, Array(nQtdCpo+1))
	
	For i := 1 To nQtdCpo
		aCols[1][i] := CriaVar(aHeader[i][2])
	Next
	
	aCols[1][nQtdCpo+1] := .F.
	
Else
	
	dbSelectArea("SZJ")
	dbSetorder(1)
	dbSeek(xFilial("SZJ") + SZN->ZN_REGIAO)
	
	While !EOF() .And. SZJ->ZJ_Filial == xFilial("SZJ") .And. SZJ->ZJ_REGIAO == SZN->ZN_REGIAO
		If aScan(aAlt, RecNo())==0		
			AAdd(aCols, Array(nQtdCpo+1))
			nCols++
			
			For i := 1 To nQtdCpo
				If aHeader[i][10] <> "V"
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))
				Else
					aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
				EndIf
			Next
			
			aCols[nCols][nQtdCpo+1] := .F.
			        
			AAdd(aAlt, Recno())
			dbSkip()
		Else 
			Exit
		Endif
	End
	
EndIf

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function GrvDadosPr()

Local bCampo := {|nField| Field(nField)}
Local i      := 0
Local y      := 0

ProcRegua(Len(aCols) + FCount())

ConfirmSx8()

// Grava o registro da tabela Pai, obtendo o valor de cada campo
// a partir da var. de memoria correspondente.

dbSelectArea("SZN")
RecLock("SZN", .T.)
For i := 1 To FCount()
	IncProc()
	If "FILIAL" $ FieldName(i)
		FieldPut(i, xFilial("SZN"))
	Else
		FieldPut(i, M->&(Eval(bCampo,i)))
	EndIf
Next
SZN->ZN_DTATU := dDataBase
MSUnlock()

// Grava os registros da tabela Filho.

dbSelectArea("SZJ")
dbSetorder(1)

For i := 1 To Len(aCols)
	
	IncProc()
	
	If !aCols[i][Len(aHeader)+1]       // A linha nao esta deletada, logo, pode gravar.
		RecLock("SZJ", .T.)
			SZJ->ZJ_FILIAL := xFilial("SZJ")
			SZJ->ZJ_REGIAO := SZO->ZO_COD
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
		MSUnlock()
	EndIf
	
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
Static Function AltDadosPr()

Local i      := 0
Local y      := 0

ProcRegua(Len(aCols) + FCount())

dbSelectArea("SZN")
RecLock("SZN", .F.)

For i := 1 To FCount()
	IncProc()
	If "FILIAL" $ FieldName(i)
		FieldPut(i, xFilial("SZN"))
	Else
		FieldPut(i, M->&(fieldname(i)))
	EndIf
Next
SZN->ZN_DTATU := dDataBase
MSUnlock()

dbSelectArea("SZJ")
dbSetOrder(1)

For i := 1 To Len(aCols)
	
	If i <= Len(aAlt)
		
		dbGoTo(aAlt[i])
		RecLock("SZJ", .F.)
		
		If aCols[i][Len(aHeader)+1]
			dbDelete()
		Else
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
		EndIf
		
		MSUnlock()
		
	Else
		
		If !aCols[i][Len(aHeader)+1]
			RecLock("SZJ", .T.)
			ZJ_FILIAL := xFilial("SZJ")
			ZJ_REGIAO := SZO->ZO_COD
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
			MSUnlock()
		EndIf
		
	EndIf
	
Next

Return Nil

//----------------------------------------------------------------------------------------------------------------//
// Linha OK dos Preços
User Function bgCFretB()

	Local lRet := .T.

	If lRet .And. GDFieldGet("ZJ_PESODE") >= GDFieldGet("ZJ_PESOATE")
		Alert("[Peso DE] maior ou igual que [Peso ATÉ].")
		lRet := .F.
	EndIf

	If lRet .And. GDFieldGet("ZJ_VALOR") <= 0 .And. GDFieldGet("ZJ_VALOREX") <= 0
		Alert("[Valor Fixo] ou [Valor p/ KG] em branco.")
		lRet := .F.
	EndIf

Return lRet

//----------------------------------------------------------------------------------------------------------------//
// Tudo OK dos Preços
User Function bgCFretC()

	Local lRet := .T.
	Local nPesoADe
	Local nPesoAAte
	Local nPesoBDe
	Local nPesoBAte
	Local i,y

	For i:=1 to Len(aCols)
		nPesoADe := GDFieldGet("ZJ_PESODE", i)
		nPesoAAte := GDFieldGet("ZJ_PESOATE", i)

		For y:=i+1 To Len(aCols)
			nPesoBDe := GDFieldGet("ZJ_PESODE", y)
			nPesoBAte := GDFieldGet("ZJ_PESOATE", y)
			If !GdDeleted(i) .And. !GdDeleted(y) .And. ;
			((nPesoADe >= nPesoBDe .And. nPesoADe < nPesoBAte) .Or. (nPesoAAte > nPesoBDe .And. nPesoAAte <= nPesoBAte) .Or.; // Faixas de peso sobrepostas
			 (nPesoADe >= nPesoBDe .And. nPesoAAte <= nPesoBAte) .Or. (nPesoADe <= nPesoBDe .And. nPesoAAte >= nPesoBAte)) // Faixas de peso uma dentro da outra

				Alert("A faixa de peso ["+AllTrim(Str(nPesoADe))+"-"+AllTrim(Str(nPesoAAte))+"] conflita com a faixa ["+AllTrim(Str(nPesoBDe))+"-"+AllTrim(Str(nPesoBAte))+"].", "Atenção!")
				lRet := .F.
			Endif
		Next
	Next

Return lRet


//----------------------------------------------------------------------------------------------------------------//
// Inicializador padrão
User Function bgCFretD()
	cRet := ""
	SZZ->(dbSetOrder(1))

	IF !INCLUI .And. SZZ->(dbSeek(xFilial("SZZ")+SZD->ZD_MUN))
		cRet := AllTrim(SZZ->ZZ_DESCRIC)+" - "+AllTrim(SZZ->ZZ_ESTADO)
	EndIf

	Return cRet