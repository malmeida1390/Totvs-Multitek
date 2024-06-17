#INCLUDE "MATA340.CH"
#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA340  ³ Autor ³ Eveli Morasco         ³ Data ³ 11/03/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera requisicoes e devolucoes para acertar estoque de acor-³±±
±±³          ³ do com a digitacao do inventario                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Rodrigo Sart.³07/08/98³16465A³Acerto na gravacao da data do inventario³±±
±±³ Fernando Joly³01/02/99³19590A³Acerto na Impress„o do Relatorio.       ³±±
±±³Rodrigo Sart. ³22/04/99³XXXXXX³Incluido tratamento p/ INTERNET         ³±±
±±³Rodrigo Sart. ³13/05/99³21692A³Alterado programa para tratar corretamen³±±
±±³              ³        ³      ³te saldos por Lote e Localizacao Fisica ³±±
±±³Rodrigo Sart. ³01/07/99³22290A³Alterada chamada da funcao CalcEstL     ³±±
±±³Fernando Joly ³04/08/99³23131A³Cria‡ao do Ponto de Entrada MT340D3     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATA340(lBatch,cCodInv)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL oDlg,nOpca:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 -Pesquisa e Posiciona em um Banco de Dados              ³
//³    2 -Simplesmente Mostra os Campos                          ³
//³    3 -Inclui registros no Bancos de Dados                    ³
//³    4 -Altera o registro corrente                             ³
//³    5 -Estorna registro selecionado gerando uma contra-partida³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP
	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
#ENDIF
lBatch := IIF(lBatch==Nil,.f.,lBatch)
PRIVATE aRotina := { {STR0001,"MATA340" ,0 ,1 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,2 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,3 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,4 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,5 ,19} }	//"Processar"

PRIVATE nHdlPrv   	// Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE cLoteEst 		// Numero do lote para lancamentos do estoque
PRIVATE lLocCQ:=.T.	// Flag usado para indicar se criou IndRegua no SD7
PRIVATE cNomArq		//	Nome do arquivo temporario criado pela IndRegua
PRIVATE nNewOrd

IF lBatch
	nOpca := 1
Endif

If __cInternet != Nil
	lBatch := .T.
EndIf
IF !lBatch
	If Substr(cAcesso,19,1) == " "
		Help ( " ", 1, "SEMPERM" )
		Return .F.
	EndIf
	DEFINE MSDIALOG oDlg FROM  96,4 TO 355,625 TITLE OemToAnsi(STR0002) PIXEL	//"Acerto do Invent rio"
	@ 18, 9 TO 99, 300 LABEL "" OF oDlg  PIXEL
	@ 29, 15 Say OemToAnsi(STR0003) SIZE 275, 10 OF oDlg PIXEL	//"Este programa ir  gerar movimenta‡”es de ajuste para corrigir o saldo do estoque."
	@ 38, 15 Say OemToAnsi(STR0004) SIZE 275, 10 OF oDlg PIXEL	//"Estas movimenta‡”es ser„o baseadas nas contagens realizadas e cadastradas na Rotina Invent rio."
	@ 48, 15 Say OemToAnsi(STR0005) SIZE 275, 10 OF oDlg PIXEL	//"O programa dever  gerar uma Requisi‡„o ou uma Devolu‡„o autom tica, dependendo da diferen‡a encontrada."
	@ 58, 15 Say OemToAnsi(STR0006) SIZE 255, 10 OF oDlg PIXEL	//"Nota: Ser  considerado apenas o estoque inventariado na data da sele‡„o (parƒmetros)."
	@ 68, 15 Say OemToAnsi(STR0007) SIZE 255, 10 OF oDlg PIXEL	//"Caso algum produto apresente divergˆncias, ser  gerado um relat¢rio."
	@ 78, 15 Say OemToAnsi(STR0008) SIZE 275, 10 OF oDlg PIXEL	//"Se o almoxarifado inventariado for o almoxarifado do CQ, sera considerada como quantidade em estoque "
	@ 88, 15 Say OemToAnsi(STR0009) SIZE 100, 10 OF oDlg PIXEL	//"a quantidade rejeitada."
	DEFINE SBUTTON FROM 108,209 TYPE 5 ACTION Pergunte("MTA340",.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
Endif
If nOpca == 1
	If lBatch
		MA340Process(lBatch,cCodInv)
	Else
		Processa({|lend| MA340Process(lBatch)},STR0002,STR0010,.F.)	//"Acerto do Invent rio"###"Efetuando Acerto do Inventario..."
	Endif
EndIf

If !lLocCQ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve as ordens originais do arquivo                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RetIndex("SD7")
	Set Filter to
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice de trabalho                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomArq += OrdBagExt()
	Delete File &(cNomArq)
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA340Process³ Autor ³ Rodrigo de A. Sartorio³ Data ³28/11/95³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o Acerto do Inventario.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA340                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MA340Process(lBatch,cCodInv)
LOCAL lOpca,cCod,cLocal,dData,nQuant,nQtSegUm
LOCAL lPassou,cApropri,cNumSeq,aCM:={},aCusto:={},aCM1:={}
LOCAL lDigita,lAglutina,lEstNeg :=If(GetMV('MV_ESTNEG')=='N',.F.,.T.)
LOCAL aSaldo:=Array(7)
LOCAL aLogs:={{}},i,z,cLog:=""
LOCAL nAchou,lMovto:=.F.
LOCAL cLote:="",cLoteCtl:="",dDtValid:="",cNumSerie:="",cLocaliza:=""
LOCAL cLocalCQ:=GetMv("MV_CQ")
LOCAL dDataFec:=GETMV("MV_ULMES")
LOCAL cCusMed :=GETMV("MV_CUSMED")
LOCAL nEmpenho:=0          
LOCAL cAliasSql:="SB7",lQuery:=.F.
Local aStruSB7 := {},cQuery:=""

Do While .T.
	dbSelectArea("SB2")
	IF lBatch
		pergunte("MTA340",.F.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega as perguntas selecionadas                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cCodInv#NIL
			MV_PAR01 := SB7->B7_DATA
			MV_PAR03 := 2
			MV_PAR05 := SB7->B7_COD
			MV_PAR06 := SB7->B7_COD
			MV_PAR07 := SB7->B7_LOCAL
			MV_PAR08 := SB7->B7_LOCAL
			MV_PAR09 := Posicione('SB1',1, xFilial('SB1')+SB7->B7_COD,"B1_GRUPO")
			MV_PAR10 := MV_PAR09
			MV_PAR11 := cCodInv
			MV_PAR12 := cCodInv
		EndIf
	Else
		pergunte("MTA340",.F.)
		lOpca:=.T.
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 - Data a ser considerada                              ³
	//³ mv_par02 - Em qual centro de custo sera' jogada a diferenca    ³
	//³ mv_par03 - Se deve mostrar os lancamentos contabeis            ³
	//³ mv_par04 - Se deve aglutinar os lancamentos contabeis          ³
	//³ mv_par05 - De  Produto                                         ³
	//³ mv_par06 - Ate Produto                                         ³
	//³ mv_par07 - De  Local                                           ³
	//³ mv_par08 - Ate Local                                           ³
	//³ mv_par09 - De  Grupo                                           ³
	//³ mv_par10 - Ate Grupo                                           ³
	//³ mv_par11 - De  Documento                                       ³
	//³ mv_par12 - Ate Documento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lBatch
		lOpca := .T.
	Endif
	
	If !lOpca
		Exit
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX5")
		dbSeek(xFilial()+"09EST")
		cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
		PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
		PRIVATE cArquivo	// Nome do arquivo contra prova
		dbSelectArea("SB7")
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Totaliza registros de digitacao de inventario                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lQuery:=.T.
				cAliasSQL := "SB7SQL"
				aStruSB7 := SB7->(dbStruct())
				cQuery := "SELECT SUM(SB7.B7_QUANT) TOTQUANT, SUM(SB7.B7_QTSEGUM) TOTQUANT2,"
				cQuery += " B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID,B7_DOC  FROM "
				cQuery += RetSqlName("SB7")+" SB7 ,"
				cQuery += RetSqlName("SB1")+" SB1  "
				cQuery += " WHERE SB7.B7_FILIAL='"+xFilial("SB7")+"' AND"
				cQuery += " SB7.B7_DATA='"+DTOS(mv_par01)+"' AND"
				cQuery += " SB7.B7_COD>='"+mv_par05+"' AND SB7.B7_COD<='"+mv_par06+"' AND"
				cQuery += " SB7.B7_LOCAL>='"+mv_par07+"' AND SB7.B7_LOCAL<='"+mv_par08+"' AND"
				cQuery += " SB7.B7_DOC>='"+mv_par11+"' AND SB7.B7_DOC<='"+mv_par12+"' AND"
				cQuery += " SB7.D_E_L_E_T_<>'*' AND"
				cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"' AND"
				cQuery += " SB1.B1_COD=SB7.B7_COD AND" 
				cQuery += " SB1.B1_GRUPO>='"+mv_par09+"' AND SB1.B1_GRUPO<='"+mv_par10+"' AND"
				cQuery += " SB1.D_E_L_E_T_<>'*' GROUP BY B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID,B7_DOC" 
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSQL,.F.,.T.)
				For nX := 1 To Len(aStruSB7)
					If aStruSB7[nX][2]<>"C" .And. FieldPos(aStruSB7[nX][1])<>0
						TcSetField(cAliasSQL,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
					EndIf
				Next nX
			Else
				cFilSB7 := 'DTOS(B7_DATA)=="'+dtos(mv_par01)+'".And.'
				cFilSB7 += 'B7_DOC>="'+mv_par11+'".And.B7_DOC<="'+mv_par12+'"'
				MsFilter(cFilSB7)
				dbSetOrder(1)		
				dbSeek(xFilial()+dtos(mv_par01))		
			EndIf		
		#ELSE
			dbSetOrder(1)		
			dbSeek(xFilial()+dtos(mv_par01))		
		#ENDIF
		If !lBatch
			ProcRegua(LastRec(),21,6)
		EndIf
		While !EOF() .And. If(lQuery,.T.,B7_FILIAL+dtos(B7_DATA) == xFilial()+dtos(mv_par01))
			If !lBatch
				IncProc()
			EndIf
			If !lQuery
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra pelo documento digitado                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If B7_DOC < mv_par11 .Or. B7_DOC > mv_par12
					dbSkip()
					Loop
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra pelo codigo do produto                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If B7_COD < mv_par05 .Or. B7_COD > mv_par06
					dbSkip()
					Loop
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra pelo almoxarifado inventariado                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If B7_LOCAL < mv_par07 .Or. B7_LOCAL > mv_par08
					dbSkip()
					Loop
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra itens com digitacao incorreta rastreabilidade         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Rastro(B7_COD) .And. Empty(B7_LOTECTL) .Or. (Rastro(B7_COD,"S") .And. Empty(B7_NUMLOTE))
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra itens com digitacao incorreta localizacao fisica      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Localiza(B7_COD) .And. Empty(B7_LOCALIZ+B7_NUMSERI)
				dbSkip()
				Loop
			EndIf
			
			cCod     := B7_COD
			cLocal   := B7_LOCAL
			dData    := B7_DATA
			cLote	 := B7_NUMLOTE
			cLoteCtl := B7_LOTECTL
			dDtValid := B7_DTVALID
			nQuant   := 0
			nQtSegUm := 0
			nEmpenho := 0
			cLocaliza:=B7_LOCALIZ
			cNumSerie:=B7_NUMSERI
			
			SB1->(dbSeek(xFilial("SB1")+cCod))

			If !lQuery
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra pelo grupo do produto                                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SB1->B1_GRUPO < mv_par09 .Or. SB1->B1_GRUPO > mv_par10
					dbSkip()
					Loop
				EndIf
				
				Do While !Eof() .And. B7_FILIAL+dtos(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE;
					== xFilial()+dtos(mv_par01)+cCod+cLocal+cLocaliza+cNumSerie+cLoteCtl+cLote
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra pelo documento digitado                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If B7_DOC >= mv_par11 .And. B7_DOC <= mv_par12
						nQuant	+=B7_QUANT
						nQtSegum	+=B7_QTSEGUM
					EndIf
					dbSKip()
				EndDo
			Else
				nQuant   := (cAliasSQL)->TOTQUANT
				nQtSegum := (cAliasSQL)->TOTQUANT2
				(cAliasSQL)->(dbSkip())
			EndIf
			
			cApropri := "0"
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !dbSeek(xFilial()+cCod+cLocal)
				CriaSB2(cCod,cLocal)
			EndIf
			If Rastro(cCod) .Or. Localiza(cCod)
				aSaldo:=u_CalcEstL(cCod,cLocal,mv_par01+1,cLoteCtl,cLote,cLocaliza,cNumSerie)
				If Localiza(cCod)
					nEmpenho:=EmpLocLz(cCod,cLocal,cLoteCTL,cLote,cLocaliza,cNumSerie)
					cLog:="SBF"
					aSaldo[7]:=aSaldo[1]*SB1->B1_CONV
				ElseIf Rastro(cCod)
					nEmpenho:=EmpLote(cCod,cLocal,cLoteCTL,cLote)
					cLog:="SB8"
				EndIf
			Else
				If cLocal == cLocalCQ
					aSaldo := A340QtdCQ(cCod,cLocal,mv_par01+1,"")
				Else
					aSaldo := CalcEst(cCod,cLocal,mv_par01+1)
					If !lEstNeg
						nEmpenho:=SB2->B2_RESERVA
						cLog:="SB2E"
					EndIf
				EndIf
			EndIf
			//--> Verifica se o saldo do produto no armazem esta disponivel
			If SB2->B2_STATUS $ "2"
				cLog := "SB2I"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve gravar a data do inventario    ³
			//³ independentemente do saldo em estoque           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SB2->B2_DINVENT <= mv_par01 .And. SB2->B2_STATUS # "2"
				dbSelectArea("SB2")
				RecLock("SB2",.F.)
				Replace B2_DINVENT With mv_par01
				MsUnlockAll()
			EndIf
			If (QtdComp(aSaldo[1]) != QtdComp(nQuant) .Or. QtdComp(aSaldo[7]) != QtdComp(nQtSegum)) .And. B2_DINVENT <= mv_par01
				If QtdComp(nEmpenho) <= QtdComp(nQuant) .And. SB2->B2_STATUS # "2"
					If nHdlPrv == NIL
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Cria o cabecalho do arquivo de prova        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nHdlPrv := HeadProva(cLoteEst,"MATA340",Subs(cUsuario,7,6),@cArquivo)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Pega o numero sequencial do movimento      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cNumseq := ProxNum()
					dbSelectArea("SD3")
					RecLock("SD3",.T.)
					Replace	D3_FILIAL  With xFilial(),	D3_COD     With cCod,;
						D3_DOC     With "INVENT" ,	D3_EMISSAO With mv_par01,;
						D3_CC      With mv_par02 ,	D3_GRUPO   With SB1->B1_GRUPO,;
						D3_LOCAL   With cLocal   ,	D3_UM      With SB1->B1_UM,;
						D3_NUMSEQ  With cNumSeq  ,	D3_SEGUM   With SB1->B1_SEGUM,;
						D3_CONTA   With SB1->B1_CONTA,;
						D3_QUANT   With Abs(nQuant - aSaldo[1]),;
						D3_QTSEGUM With Abs(nQtSegUm - aSaldo[7]),;
						D3_TIPO    With SB1->B1_TIPO,;
						D3_LOCALIZ With cLocaliza,;
						D3_NUMSERI With cNumSerie,;
						D3_LOTECTL With cLoteCtl,;
						D3_NUMLOTE With cLote,;
						D3_USUARIO With SubStr(cUsuario,7,15),;
						D3_DTVALID With dDtValid
					If aSaldo[1] > nQuant
						Replace D3_TM With "999",D3_CF With "RE"+cApropri
					Else
						Replace D3_TM With "499",D3_CF With "DE"+cApropri
					EndIf
					Replace D3_CHAVE With SubStr(D3_CF,2,1)+IIF(D3_CF=="DE4","9","0")
					
					If (ExistBlock( "MT340D3" ) )
						ExecBlock("MT340D3",.F.,.F.)
					EndIf
					
					If cCusMed == "O"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pega os custos medios atuais               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pega os custos medios finais               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aCM := PegaCMFim(SD3->D3_COD,SD3->D3_LOCAL)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava o custo da movimentacao              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aCusto := GravaCusD3(aCM)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o saldo atual do estoque com os dados do SD3 ³
					//³ e caso retorne .T. grava o registro para log de saldo ³
					//³ negativo.											  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If B2AtuComD3(aCusto,,.F.)
						If !lEstNeg
							For i:=1 to Len(aLogs)
								nAchou:=ASCAN(aLogs[i],{|x| x[1] == "SB2" .And. x[2]+x[3] == SD3->D3_COD+SD3->D3_LOCAL})
								If nAchou > 0
									Exit
								EndIf
							Next i
							If nAchou == 0
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Adiciona registro em array p/ baixar empenho.  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Len(aLogs[Len(aLogs)]) > 4095
									AADD(aLogs,{})
								EndIf
								AADD(aLogs[Len(aLogs)],{"SB2",SD3->D3_COD,SD3->D3_LOCAL,"","","",""})
							EndIf
						EndIf
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o saldo final do estoque com os dados do SD3 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If dData <= dDataFec
						B2FimComD3(aCusto)
					EndIf
					If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Gera o lancamento no arquivo de prova           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SD3->D3_TM <= "500"
							nTotal+=DetProva(nHdlPrv,"676","MATA340",cLoteEst)
						Else
							nTotal+=DetProva(nHdlPrv,"674","MATA340",cLoteEst)
						EndIf
					EndIf
					aSaldo := CalcEst(SD3->D3_COD,SD3->D3_LOCAL,Ctod("31/12/49","ddmmyy"))
					RecLock("SB2")
					Replace B2_QATU  With aSaldo[1]
					Replace B2_VATU1 With aSaldo[2]
					Replace B2_VATU2 With aSaldo[3]
					Replace B2_VATU3 With aSaldo[4]
					Replace B2_VATU4 With aSaldo[5]
					Replace B2_VATU5 With aSaldo[6]
					MsUnlockAll()
				Else
					For i:=1 to Len(aLogs)
						nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5]+x[6]+x[7] == cCod+cLocal+cLoteCtl+cLote+cLocaliza+cNumSerie})
						If nAchou > 0
							Exit
						EndIf
					Next i
					If nAchou == 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Adiciona registro em array p/ baixar empenho.  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If Len(aLogs[Len(aLogs)]) > 4095
							AADD(aLogs,{})
						EndIf
						AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,cLocaliza,cNumSerie})
					EndIf
				EndIf
			EndIf
			dbSelectArea(cAliasSql)
		EndDo
		Exit
	EndIf
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se ele criou o arquivo de prova ele deve gravar o rodape'    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
	pergunte("MTA340",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 - Data a ser considerada                              ³
	//³ mv_par02 - Em qual centro de custo sera' jogada a diferenca    ³
	//³ mv_par03 - Se deve mostrar os lancamentos contabeis            ³
	//³ mv_par04 - Se deve aglutinar os lancamentos contabeis          ³
	//³ mv_par05 - De  Produto                                         ³
	//³ mv_par06 - Ate Produto                                         ³
	//³ mv_par07 - De  Local                                           ³
	//³ mv_par08 - Ate Local                                           ³
	//³ mv_par09 - De  Grupo                                           ³
	//³ mv_par10 - Ate Grupo                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDigita   := Iif(mv_par03 == 1,.T.,.F.)
	lAglutina := Iif(mv_par04 == 1,.T.,.F.)
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)
EndIf
MsUnlockAll()

If lQuery
	dbSelectArea(cAliasSQL)
	dbCloseArea()
	dbSelectArea("SB7")
Else
	RETINDEX("SB7")
	Set Filter to
EndIf

If Len(aLogs[1]) > 0
	For i:=1 to Len(aLogs)
		For z:=1 to Len(aLogs[i])
			// Verifica saldo em estoque
			If aLogs[i,z,1] == "SB2"
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial()+aLogs[i,z,2]+aLogs[i,z,3])
					If B2_QATU > 0 .And. B2_STATUS # "2"
						aLogs[i,z,1] := "OK"
					EndIf
				EndIf
			EndIf
		Next z
	Next i
	A340LstNeg(aLogs)
EndIf
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A340LstNeg³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 10/01/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Produtos que ficaram com o saldo negativo     ³±±
±±³          ³ ou tiveram itens que nao podem ser inventariados           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST/SIGAPCP                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function A340LstNeg(aLogs)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL titulo   := STR0014	//"Itens nao Inventariados"
LOCAL cDesc1   := STR0015	//"O relatorio lista os produtos que nao puderam ser inventariados por "
LOCAL cDesc2   := STR0016	//"alguma situacao que impede a correta contagem de seus saldos e lista "
LOCAL cDesc3   := STR0017	//"tb produtos que continuam com saldo divergente apos o processamento."
LOCAL cString  := "SB2"
LOCAL wnrel    := "MATA340"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn:= {STR0018,1,STR0019, 2, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0,cPerg:="      "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C340Imp(@lEnd,wnRel,titulo,aLogs)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C340IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 10/01/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA340  			                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C340Imp(lEnd,WnRel,titulo,aLogs)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "P"
LOCAL nTipo    := 0
LOCAL cRodaTxt := STR0020	//"REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL i,z

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis para controlar cursor de progressao     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(aLogs))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := STR0021	//"OCOR PRODUTO         DESCRICAO       LOCAL   QUANTIDADE     LOTE      SUB-LOTE"
cabec2 := STR0023 //"                                            LOCALIZACAO     NUMERO DE SERIE   "
//                   1234 123456789012345 12345678901234545 12   12345678901234  1234567890 123456
//                                                               123456789012345 12345678901234567890
//                   0         1         2         3         4         5         6         7         8
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890

SB1->(dbSetOrder(1))
SB2->(dbSetOrder(1))

For i:=1 to Len(aLogs)
	IncRegua()
	For z:=1 to Len(aLogs[i])
		If aLogs[i,z,1] != "OK"
			If li > 58
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			SB1->(dbSeek(xFilial("SB1")+aLogs[i,z,2]))
			SB2->(dbSeek(xFilial("SB2")+aLogs[i,z,2]+aLogs[i,z,3]))
			@ li,000 PSay aLogs[i,z,1]
			@ li,005 PSay aLogs[i,z,2] Picture PesqPict("SD3","D3_COD",15)
			@ li,021 PSay Left(SB1->B1_DESC,15) Picture PesqPict("SB1","B1_DESC",15)
			@ li,039 PSay aLogs[i,z,3] Picture PesqPict("SD3","D3_LOCAL",2)
			@ li,044 PSay SB2->B2_QATU	Picture PesqPictQt("B2_QATU",14)
			@ li,060 PSay aLogs[i,z,4]	Picture PesqPict("SB7","B7_LOTECTL",10)
			@ li,071 PSay aLogs[i,z,5]	Picture PesqPict("SB7","B7_NUMLOTE",8)
			If !Empty(aLogs[i,z,6]+aLogs[i,z,7])
				li++
				@ li,044 PSay aLogs[i,z,6]	Picture PesqPict("SB7","B7_LOCALIZ",15)
				@ li,060 PSay aLogs[i,z,7]	Picture PesqPict("SB7","B7_NUMSERI",20)
			EndIf
			li++
		EndIf
	Next z
Next i


IF li != 80
	If li > 55
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,10 PSay STR0011  //"Legenda das Ocorrencias"
	li++
	@ li,10 PSay STR0012  //"SB2 - > Itens com saldo negativo nos Saldos em estoque."
	li++
	@ li,10 PSay STR0013  //"SB2E/SB8/SBF - > Itens empenhados / reservados no arquivo SB2/SB8/SBF"
	li++
	@ li,10 PSay STR0024  //"SB2I  - > Itens com saldo Indisponivel nos Saldos em Estoque"
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A340QtdCQ ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 05/05/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Calcula o saldo rejeitado do produto no almoxarifado de CQ. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA340                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A340QtdCQ(cProduto,cLocal,dData,cLote)
Local cAlias:= Alias(), nOrdem := IndexOrd()
Local cCond
Local aQtd:={0,0,0,0,0,0,0}
dbSelectArea("SD7")
If lLocCQ
	cNomArq:= CriaTrab("",.F.)
	cCond:='D7_ESTORNO != "S" .And. D7_TIPO == 2 .And. DTOS(D7_DATA) < "'+DTOS(dData)+'"'
	IndRegua("SD7",cNomArq,"D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE",,cCond,STR0022)	//"Selecionando Registros..."
	nNewOrd:=RetIndex("SD7")
	DbSelectArea("SD7")
	#IFNDEF TOP
		DbSetIndex(cNomArq+OrdBagExt())
	#ENDIF
	lLocCQ:=.F.
	DbSetOrder(nNewOrd+1)
EndIf
dbGotop()
If Empty(cLote)
	dbSeek(xFilial()+cProduto+cLocal)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL == xFilial()+cProduto+cLocal
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
Else
	dbSeek(xFilial()+cProduto+cLocal+cLote)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE == xFilial()+cProduto+cLocal+cLote
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
EndIf

If aQtd[1] > 0
	// Subtraio qtd. j  devolvida
	dbSelectArea("SD2")
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto+cLocal)
	Do While !Eof() .And. D2_FILIAL+D2_COD+D2_LOCAL == xFilial()+cProduto+cLocal
		If D2_TIPO != "D"
			dbSkip()
			Loop
		EndIf
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial()+SD2->D2_TES) .And. F4_ESTOQUE == "S"
			aQtd[1] -= SD2->D2_QUANT
		EndIf
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial()+cProduto)
		aQtd[7]:= ConvUm(SB1->B1_COD,aQtd[1],aQtd[7],2)
	EndIf
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
Return aQtd




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CalcEstL ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 15/05/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Saldo inicial por Produto/Local do arquivo SD5   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpA1 := CalcEstL(ExpC1,ExpC2,ExpD1,ExpC3,ExpC4,ExpC5,ExpC6)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do Produto                                  ³±±
±±³          ³ ExpC2 = Local (Almoxarifado)                               ³±±
±±³          ³ ExpD1 = Data para obter o Saldo Inicial.                   ³±±
±±³          ³ ExpC3 = Lote                                               ³±±
±±³          ³ ExpC4 = Sub-Lote                                           ³±±
±±³          ³ ExpC5 = Localizacao                                        ³±±
±±³          ³ ExpC6 = Numero de Serie                                    ³±±
±±³          ³ ExpL1 = Verifica se obtem o saldo por Sub-Lote com rastro L³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACUS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcEstL(cCod,cLocal,dData,cLoteCtl,cNumLote,cLocaliz,cNumSeri,lConsSub)

Local aSaldo     := {0, 0, 0, 0, 0, 0, 0}
Local aAreaAnt   := GetArea()
Local aAreaSBJ   := SBJ->(GetArea())
Local aAreaSBK   := SBK->(GetArea())
Local aAreaSD5   := SD5->(GetArea())
Local aAreaSDB   := SDB->(GetArea())
Local lRastro    := Rastro(cCod)
Local lSRastro   := Rastro(cCod, 'S')
Local lHasRec    := .F.
Local cCompSBJ   := ''
Local cCompSBK   := ''
Local cCompSBK1  := ''
Local cCompSD5   := ''
Local cCompSDB   := ''
Local cCompSDB1  := ''
Local cSeekSBJ   := ''
Local cSeekSBK   := ''
Local cSeekSBK1  := ''
Local cSeekSD5   := ''
Local cSeekSDB   := ''
Local cSeekSDB1  := ''
Local dUltFec    := CtoD('  /  /  ')
Local cFiltroSD5 := ''
#IFDEF TOP
	dbSelectArea("SD5")
	cFiltroSD5 := dbFilter()
	If !Empty(cFiltroSD5)
		cFiltroSD5 += ".And. OrderBy("+StrTran(ClearKey(IndexKey()),"+",",")+")"
		Set Filter To
	EndIf	
#ENDIF			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche os parametros n„o inicializados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dData    := If(dData==Nil, dDataBase, dData)
cLoteCtl := If(cLoteCtl==Nil, CriaVar('D5_LOTECTL'), cLoteCtl)
cNumLote := If(cNumLote==Nil, CriaVar('D5_NUMLOTE'), cNumLote)
cLocaliz := If(cLocaliz==Nil, CriaVar('DB_LOCALIZ'), cLocaliz)
cNumSeri := If(cNumSeri==Nil, CriaVar('DB_NUMSERI'), cNumSeri)
lConsSub := If(Valtype(lConsSub) # "L", .F. ,lConsSub)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se obtem o saldo por Sub-Lote mesmo com rastro L   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lConsSub .And. lRastro .And. !Empty(cNumLote)
	lSRastro:=.T.
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna o Saldo Inicial da Rastreabilidade (SBJ ou SD5)     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cLocaliz+cNumSeri) .And. !Empty(cLoteCtl)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura no SBJ por Saldos Iniciais ref. ao Ultimo Fechamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('SBJ')
	dbSetOrder(2)
	cSeekSBJ := xFilial('SBJ') + cCod + cLocal + cLoteCtl
	cCompSBJ := 'BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL'
	If !Empty(cNumLote) .And. lSRastro
		dbSetOrder(1)
		cSeekSBJ += cNumLote
		cCompSBJ += '+BJ_NUMLOTE'
	EndIf

	dbSeek(cSeekSBJ)
	lHasRec := .F.
	Do While !Eof() .And. cSeekSBJ == &(cCompSBJ)
		If BJ_DATA >= dData .And. lHasRec
			Exit
		Else
			lHasRec := .T.
			dUltFec := If(BJ_DATA>dUltFec .And. BJ_DATA <= dData,BJ_DATA,dUltFec)
		EndIf
		dbSkip()
	EndDo
	If lHasRec
		cSeekSBJ+=DTOS(dUltFec)
		cCompSBJ+="+DTOS(BJ_DATA)"
		dbSeek(cSeekSBJ)
		Do While !Eof() .And. &(cCompSBJ) == cSeekSBJ
			aSaldo[1] += BJ_QINI
			aSaldo[7] += BJ_QISEGUM
			dUltFec   := BJ_DATA
			dbSkip()
		EndDo
	EndIf
	RestArea(aAreaSBJ)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura no SD5 por Movimentacoes posteriores ao Ultimo SBJ  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (QtdComp(aSaldo[1]+aSaldo[7])==QtdComp(0)) .Or. (QtdComp(aSaldo[1]+aSaldo[7])>QtdComp(0).And.!Empty(dUltFec))
		dbSelectArea('SD5')
		dbSetOrder(2)
		cCompSD5 := 'D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL'
		cSeekSD5 := xFilial('SD5')+cCod+cLocal+cLoteCtl

		If !Empty(cNumLote) .And. lSRastro
			cCompSD5 += '+D5_NUMLOTE'
			cSeekSD5 += cNumLote
		EndIf

		If dbSeek(cSeekSD5, .F.)
			Do While !Eof() .And. &(cCompSD5) == cSeekSD5
				If !Empty(dUltFec) .And. D5_DATA <= dUltFec
					dbSkip()
					Loop
				EndIf				
				If D5_DATA < dData .And. D5_ESTORNO # 'S'
					If D5_ORIGLAN<='500' .Or. Substr(D5_ORIGLAN,1,2) $ 'DE·PR·MA'
						aSaldo[1] += D5_QUANT
						aSaldo[7] += D5_QTSEGUM
					Else
						aSaldo[1] -= D5_QUANT
						aSaldo[7] -= D5_QTSEGUM
					EndIf
				EndIf
				dbSkip()
			EndDo
		EndIf
		RestArea(aAreaSD5)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna o Saldo Inicial da Localiza‡Æo (SBK ou SDB)         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(cLocaliz+cNumSeri)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura no SBK por Saldos Iniciais ref. ao Ultimo Fechamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('SBK')
	dbSetOrder(2)

	cSeekSBK := xFilial('SBK') + cCod + cLocal
	cCompSBK := 'BK_FILIAL+BK_COD+BK_LOCAL'

	cCompSBK1 := 'BK_LOCALIZ+BK_NUMSERI'
	cSeekSBK1 := cLocaliz + cNumSeri
	If lRastro
		cCompSBK1 += '+BK_LOTECTL'
		cSeekSBK1 += cLoteCtl
		If !Empty(cNumLote) .And. lSRastro
			dbSetOrder(1)
			cCompSBK1 += '+BK_NUMLOTE'
			cSeekSBK1 += cNumLote
		EndIf
	EndIf

	If dbSeek(cSeekSBK, .F.)
		Do While !Eof() .And. &(cCompSBK) == cSeekSBK
			If &(cCompSBK1) == cSeekSBK1
				If BK_DATA > dData
					Exit
				EndIf
				aSaldo[1] := BK_QINI
				aSaldo[7] := BK_QISEGUM
				dUltFec   := BK_DATA
				If BK_DATA == dData
					RestArea(aAreaSBK)
					RestArea(aAreaAnt)
					Return aSaldo
				EndIf
			EndIf
			dbSkip()
		EndDo
	EndIf
	RestArea(aAreaSBK)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura no SDB por Movimentacoes posteriores ao Ultimo SBJ  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (QtdComp(aSaldo[1]+aSaldo[7])==QtdComp(0)) .Or. (QtdComp(aSaldo[1]+aSaldo[7])>QtdComp(0).And.!Empty(dUltFec))

		dbSelectArea('SDB')
		dbSetOrder(1)
		cSeekSDB := xFilial('SDB') + cCod + cLocal
		cCompSDB := 'DB_FILIAL+DB_PRODUTO+DB_LOCAL'

		cSeekSDB1 := cLocaliz + cNumSeri
		cCompSDB1 := 'DB_LOCALIZ+DB_NUMSERI'
		If lRastro
			cSeekSDB1 += cLoteCtl
			cCompSDB1 += '+DB_LOTECTL'
			If !Empty(cNumLote) .And. lSRastro
				cSeekSDB1 += cNumLote
				cCompSDB1 += '+DB_NUMLOTE'
			EndIf
		EndIf

		If dbSeek(cSeekSDB, .F.)
			Do While !Eof() .And. &(cCompSDB) == cSeekSDB
				If !Empty(dUltFec) .And. DB_DATA <= dUltFec
					dbSkip()
					Loop
				EndIf				
				If &(cCompSDB1) == cSeekSDB1 .And. DB_DATA < dData .And. DB_ESTORNO # 'S' .And. DB_ATUEST # "N"
					If DB_TM<='500' .Or. Substr(DB_TM,1,2) $ 'DE·PR·MA'
						aSaldo[1] += SDB->DB_QUANT
					Else
						aSaldo[1] -= SDB->DB_QUANT
					EndIf
				EndIf
				dbSkip()
			EndDo
		EndIf
		RestArea(aAreaSDB)
	EndIf
EndIf

#IFDEF TOP
	If !Empty(cFiltroSD5)
		SD5->(dbSetFilter({||&cFiltroSD5},cFiltroSD5))
		SD5->(dbGoTop(aAreaSD5[3]))
	EndIf
#ENDIF			

RestArea(aAreaAnt)
Return(aSaldo)

