#INCLUDE "MATR090.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR090A ³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da rela‡„o de Compras                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR090(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Bruno        ³09/12/98³melhor³Acerto para impressao na Argentina.     ³±±
±±³ Cesar Valadao³31/08/99³21449A³Impressao do campo D1_LOCAL.            ³±±
±±³ Patricia Sal.³17/12/99³XXXXXX³Troca da PesqPictQt() pela PesqPict()   ³±±
±±³              ³        ³      ³Conversao campo Fornec.(20 pos.)/ Acerto³±±
±±³              ³        ³      ³das Includes.                           ³±±
±±³ Patricia Sal.³14/02/00³002574³Acerto na Totalizacao das NF's.         ³±±
±±³ Paulo Augusto³26/05/00³Melhor³Acerto para imprimir o imposto1 no campo³±±
±±³              ³        ³      ³de IVA que estava usando o IPI          ³±±
±±³ Patricia Sal.³11/07/00³005088³Validar Filtro Usuario.                 ³±±
±±³ Marcello     ³23/08/00³oooooo³Impressao da relacao em outras moedas   ³±±
±±³ Alex Lemes   ³23/04/02³      ³Revisao Geral Implementacao Query p/SQL ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos Hirak  ³09/02/04³XXXXXX³Imprimir B1_CODITE quando for gestao de ³±±
±±³              ³        ³      ³Concessionarias ( MV_VEICULO = "S")     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATR090A()

LOCAL wnrel     := "MATR090"
LOCAL nOrdem    := 1
LOCAL limite    := 220
LOCAL cString   := "SD1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea1	:= Getarea() 
LOCAL nI			:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lVEIC		:= UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod	:= {}
Private aSB1Ite	:= {}
Private nCOL1		:= 0
Private nCOL2		:= 0
Private XSB1, xSD1, xSD2, xSF1, xSF2 , xSF4, xSA2, xSA1
Private cCABPROD  := STR0014 //"TOTAL PRODUTO     --> "
PRIVATE titulo  := OemToAnsi(STR0001)	//"Relacao de Compras"
PRIVATE cDesc1  := OemToAnsi(STR0002)	//"Este relatorio ira imprimir a relacao de itens"
PRIVATE cDesc2  := OemToAnsi(STR0003)	//"referentes a compras efetuadas."
PRIVATE cDesc3  := ""
PRIVATE cPerg   := "MTR090"+SPACE(4)
PRIVATE tamanho := "G"
PRIVATE aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006) ,OemToAnsi(STR0007)}//" Fornecedor         "###" Data De Digitacao  "###" Tipo+Grupo+Codigo  "###" Grupo+Codigo   "
PRIVATE aReturn := {OemToAnsi(STR0008),1,OemToAnsi(STR0009), 1, 2, 1, "",1}		//"Zebrado"###"Administracao"
PRIVATE aLinha  := { }
PRIVATE nomeprog:= "MATR090"
PRIVATE nLastKey:= 0

dbselectarea("SD2")
dbsetorder(1)
XSD2		:= XFILIAL("SD2")

dbselectarea("SF2")
dbsetorder(1)
XSF2		:= XFILIAL("SF2")

dbselectarea("SA2")
dbsetorder(1)
XSA2		:= XFILIAL("SA2")

dbselectarea("SF4")
dbsetorder(1)
XSF4		:= XFILIAL("SF4")

dbselectarea("SF1")
dbsetorder(1)
XSF1		:= XFILIAL("SF1")

dbselectarea("SD1")
dbsetorder(1)
XSD1		:= XFILIAL("SD1")

dbselectarea("SA1")
dbsetorder(1)
XSA1		:= XFILIAL("SA1")

dbselectarea("SB1")
dbsetorder(1)
XSB1		:= XFILIAL("SB1")


cabec2:= ""
m_pag := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

if lVEIC

	nCOL1		:= LEN(cCABPROD)
	nCOL2		:= AT('PRODU', UPPER(cCABPROD))

	IF nCOL2 > 0 
	   FOR nI := nCOL2 TO nCOL1
   	   IF SUBSTR(cCABPROD,nI,1) == ' '
   	      EXIT
   	   ENDIF
		 NEXT // nCOL2
	ENDIF		 
	nCOL2	:= nI
   DBSELECTAREA("SX1")
   DBSETORDER(1)
   DBSEEK(cPerg)
   DO WHILE SX1->X1_GRUPO == cPerg .AND. !SX1->(EOF())
      IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Ite[1] .OR. UPPER(SX1->X1_F3) <> "VR4")

         RECLOCK("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Ite[1]
         SX1->X1_F3 := "VR4"
         DBCOMMIT()
         MSUNLOCK()
         
      ENDIF
      DBSKIP()
   ENDDO
   DBCOMMITALL()
   RESTAREA(aArea1)
else
   DBSELECTAREA("SX1")
   DBSETORDER(1)
   DBSEEK(cPerg)
   DO WHILE SX1->X1_GRUPO == cPerg .AND. !SX1->(EOF())
      IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")

         RECLOCK("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Cod[1]
         SX1->X1_F3 := "SB1"
         DBCOMMIT()
         MSUNLOCK()
         
      ENDIF
      DBSKIP()
   ENDDO
   DBCOMMITALL()
   RESTAREA(aArea1)
endif

Pergunte("MTR090",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto de                           ³
//³ mv_par02             // Produto Ate                          ³
//³ mv_par03             // Data digitacao de                    ³
//³ mv_par04             // Data digitacao Ate                   ³
//³ mv_par05             // Fornecedor de                        ³
//³ mv_par06             // Fornecedor Ate                       ³
//³ mv_par07             // Imprime Devolucao ?                  ³
//³ mv_par08             // Filtra Dt Devolucao ?                ³
//³ mv_par09             // Moeda                                ³
//³ mv_par10             // Otras moedas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
If nLastKey == 27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return
Endif

If Type("NewHead")#"U"
	Titulo := NewHead
EndIf
nomeprog:=wnRel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica campos para selecao dos indexados (Marcos Hirakawa  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]

RptStatus({|lEnd| C090Imp      ( @lEnd,wnRel   ,cString, nOrdem)},ALLTRIM(titulo)+" ("+alltrim(aOrd[nOrdem])+")") // titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CA090Imp ³ Autor ³Alexandre Inacio Lemes ³ Data ³25/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MTR090                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C090Imp(lEnd,WnRel,cString, nOrdem)

LOCAL cbCont    := 0
LOCAL nTotal    := 0
LOCAL nTotTip   := 0
LOCAL nTotGrp   := 0
LOCAL nTotProd  := 0
LOCAL nTotForn  := 0
LOCAL nCnt      := 0
LOCAL nTotQt1   := 0
LOCAL nTotQt2   := 0
LOCAL nTotQt3   := 0
LOCAL nTotVal1  := 0
LOCAL nTotVal2  := 0
LOCAL nTotVal3  := 0
LOCAL nTotDtVal := 0
LOCAL nTotDtCus := 0
LOCAL nTotDtQt  := 0
LOCAL nPosNome  := 133
LOCAL nTamNome  := 040
LOCAL nTamReduz := 026
LOCAL nDecs     := Msdecimais(mv_par09) //casas decimais utilizadas na moeda da impressao
LOCAL cTipAnt   := ""
LOCAL cChave    := ""
LOCAL condicao  := ""
LOCAL cGrpAnt   := ""
LOCAL cCondSD2  := ""
LOCAL cIndice   := ""
LOCAL cNomeArq  := ""
LOCAL cNomeArq1 := ""
LOCAL cQuery    := ""
LOCAL cAliasSF1 := "SF1"
LOCAL cAliasSD1 := "SD1"
LOCAL cAliasSB1 := "SB1"
LOCAL cAliasSA1 := "SA1"
LOCAL cAliasSA2 := "SA2"
LOCAL cAliasSF4 := "SF4"
LOCAL aStrucSF1 := {}
LOCAL aStrucSD1 := {}
LOCAL aStrucSB1 := {}
LOCAL aStrucSA1 := {}
LOCAL aStrucSA2 := {}
LOCAL aStrucSF4 := {}
LOCAL nSD1 		:= 0
LOCAL nSF1 		:= 0
LOCAL nSA1 		:= 0
LOCAL nSA2 		:= 0
LOCAL nSF4 		:= 0  
LOCAL nY		:= 0
LOCAL cTipGrp	:= ""
LOCAL cProdAnt	:= ""
LOCAL cQuebra	:= ""
LOCAL aRec      := {}
LOCAL aImposto	:= {}
LOCAL nImpInc   := 0
LOCAL nImpNoInc	:= 0
LOCAL nImpos	:= 0
LOCAL cCampImp  := ""
LOCAL nTaxa		:= 0
LOCAL nMoeda	:= 0
LOCAL dDtDig    := dDataBase
LOCAL aTotais   := {0,0,0,0,0,0,0,0,0,0,0,0}
LOCAL aTamSXG   := TamSXG("001")
LOCAL lFiltro   := .T.                                                 
LOCAL lQuery    := .F.
Local cName     := ""
Local cQryAdd   := ""
Local nX        := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Elementos do aTotais                                        ³
//³01 e 02 = Total Imposto nao incluido e incluido / NF        ³
//³03 e 04 = Total Imposto nao incluido e incluido / Fornecedor³
//³05 e 06 = Total Imposto nao incluido e incluido / Data      ³
//³07 e 08 = Total Imposto nao incluido e incluido / Grupo     ³
//³09 e 10 = Total Imposto nao incluido e incluido / Tipo      ³
//³11 e 12 = Total Imposto nao incluido e incluido / Geral     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lT

SF1->(dbsetorder(1))
SF2->(dbsetorder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica conteudo da variavel p/ Grupo de Clientes (001)      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If cPaisLoc == "BRA"
	If aTamSXG[1] <> aTamSXG[3]
		cabec1:= "NOTA         PRODUTO  DESCRICAO                  PEDIDO - ITEM     QUANTIDADE UM      PR.UNITARIO  IPI             VALOR  ICM  CODIGO               RAZAO SOCIAL               TP TES TIPO GRUPO DATA DIG.           CUSTO LO"
		//        XXXXXXXXXXXX XXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXX XX XXX X   XXXX  XX/XX/XXXX XXXXXXXXXXXXXXX XX
		//        0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
		//        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789

	Else
		cabec1:= "NOTA         PRODUTO  DESCRICAO                  PEDIDO - ITEM     QUANTIDADE UM      PR.UNITARIO  IPI             VALOR  ICM  CODIGO RAZAO SOCIAL                             TP TES TP  GRUPO  DATA DIG.           CUSTO LO"
		//        XXXXXXXXXXXX XXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXX XXXXX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXX X   XXXX  XX/XX/XXXX XXXXXXXXXXXXXXX XX
		//        0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
		//        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Endif
Else
	cabec1:= STR0022
EndIf


li := 80

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta IndRegua caso liste NFs de devolucao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par07 == 1
	cNomeArq1:= CriaTrab("",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica data caso FILTRE NFs de devolucao fora do periodo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par08 == 1
		cCondSD2	:=	( "D2_FILIAL == '" + xSD2 + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)>='" + DTOS(mv_par03) + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)<='" + DTOS(mv_par04) + "'" )
	Else
		cCondSD2	:=	( "D2_FILIAL == '" + xSD2 + "'")
	EndIf
	cCondSD2 +=	( ".And. !(" + IsRemito(2,'SD2->D2_TIPODOC') + ")" )
				
	dbSelectArea("SD2")
	IndRegua("SD2",cNomeArq1,"D2_COD+D2_NFORI+D2_ITEMORI+D2_SERIORI+D2_CLIENTE+D2_LOJA",,cCondSD2,STR0010)		//"Selecionando Registros..."
	nIndSD2 := RetIndex("SD2")
	dbSelectArea("SD2")
	#IFNDEF TOP
		dbSetIndex(cNomeArq1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSD2+1)
	dbGoTop()
EndIf

// Se nao utiliza tamanho min., considera tamanho maximo e altera LayOut referente ao Grupo 001.
If aTamSXG[1]  <>  aTamSXG[3]
	nPosNome += aTamSXG[4] - aTamSXG[3]
	nTamNome -= aTamSXG[4] - aTamSXG[3]
Endif

#IFDEF TOP
	If (TcSrvType()#'AS/400')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Query para SQL                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aStrucSF1 := SF1->(dbStruct())
		aStrucSD1 := SD1->(dbStruct())
		aStrucSB1 := SB1->(dbStruct())
		aStrucSA1 := SA1->(dbStruct())
		aStrucSA2 := SA2->(dbStruct())
		aStrucSF4 := SF4->(dbStruct())
		cALiasSF1 := "QRYSD1"
		cAliasSD1 := "QRYSD1"
		cALiasSB1 := "QRYSD1"
		cALiasSA1 := "QRYSD1"
		cALiasSA2 := "QRYSD1"
		If mv_par11 == 1
			cALiasSF4 := "QRYSD1"
      Endif    
		lQuery :=.T.

      cQuery := "SELECT D1_FILIAL"	// 01
      cQuery += ", D1_DOC"	// 02
      cQuery += ", D1_SERIE"	// 03
      cQuery += ", D1_FORNECE"	// 04
      cQuery += ", D1_LOJA"	// 05
      cQuery += ", D1_DTDIGIT"	// 06
      cQuery += ", D1_COD"	// 07
      cQuery += ", D1_QUANT"	// 08
      cQuery += ", D1_VUNIT"	// 09
      cQuery += ", D1_TOTAL"	// 10
      cQuery += ", D1_TES"	// 11
      cQuery += ", D1_IPI"	// 12
      cQuery += ", D1_PICM"	// 13
      cQuery += ", D1_TIPO"	// 14
      cQuery += ", D1_TP"	// 15
      cQuery += ", D1_GRUPO"	// 16
      cQuery += ", D1_CUSTO"	// 17
      cQuery += ", D1_LOCAL"	// 18
      cQuery += ", D1_QTDEDEV"	// 19
      cQuery += ", D1_ITEM"	// 20
      cQuery += ", D1_UM"	// 21


		If lVEIC
	      cQuery += ", B1_CODITE"	// 22
      Endif

		DbSelectArea("SX3")
		DbSetOrder(2)
		DbSeek("D1_VALIMP") 
		While !Eof() .And. X3_ARQUIVO == "SD1" .And. X3_CAMPO = "D1_VALIMP"
			cQryAdd +=	(IIF( EMPTY(ALLTRIM(cQryAdd)),"",", ") + X3_CAMPO )
			DbSkip()
		EndDo   
      If !Empty(aReturn[7])
			For nX := 1 To SD1->(FCount())
				cName := SD1->(FieldName(nX))
			 	If AllTrim( cName ) $ aReturn[7]
		      	If aStrucSD1[nX,2] <> "M"  
		      		If !cName $ cQuery .And. !cName $ cQryAdd
							cQryAdd +=	(IIF( EMPTY(ALLTRIM(cQryAdd)),"",", ") + cName )
			       	Endif 	
					EndIf
				EndIf 			       	
			Next nX
      Endif    
      If ! Empty(Alltrim(cQryAdd))
	      cQuery += ", " + cQryAdd	// 23
		endif

      cQuery += ", F1_MOEDA"	// 24
      cQuery += ", F1_TXMOEDA"	// 25
      cQuery += ", F1_DTDIGIT"	// 26

		If mv_par11 == 1
			cQuery += ", F4_AGREG"	// 27
      Endif

		cQuery += ", B1_DESC"	// 28
		cQuery += ", B1_UM"	// 29

		cQuery += ", A1_NOME"	// 30
		cQuery += ", A1_NREDUZ"	// 31
		cQuery += ", SD1.R_E_C_N_O_ SD1RECNO" 	// 32

		cQuery += ", D1_PEDIDO"	// 21
		cQuery += ", D1_ITEMPC"	// 21

		cQuery += " FROM " + RetSqlName("SF1") + "  (NOLOCK) SF1"
		cQuery += ", " + RetSqlName("SD1") + "  (NOLOCK) SD1"
		cQuery += ", " + RetSqlName("SB1") + "  (NOLOCK) SB1"
		cQuery += ", " + RetSqlName("SA1") + "  (NOLOCK) SA1"
		If mv_par11 == 1
			cQuery += ", " + RetSqlName("SF4") + "  (NOLOCK) SF4"
		Endif 

      cQuery += " WHERE"
      cQuery += " SF1.F1_FILIAL='" + xSF1 + "'" 
    	cQuery += " AND NOT (" + IsRemito(3,'SF1.F1_TIPODOC') + ")"
	   cQuery += " AND SF1.D_E_L_E_T_ <> '*'"
	   cQuery += " AND SD1.D1_FILIAL = '" + xSD1 + "'"
      cQuery += " AND SD1.D1_DOC = SF1.F1_DOC"
      cQuery += " AND SD1.D1_SERIE = SF1.F1_SERIE"
      cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE"
      cQuery += " AND SD1.D1_LOJA = SF1.F1_LOJA"
      cQuery += " AND SD1.D1_TIPO IN ('D','B')"
      cQuery += " AND SD1.D_E_L_E_T_ <> '*'"
      cQuery += " AND SB1.B1_FILIAL ='" + xSB1 + "'"
      cQuery += " AND SB1.B1_COD = SD1.D1_COD"
      cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
      If mv_par11 == 1
			cQuery += " AND SF4.F4_FILIAL ='" + xSF4 + "'"
			cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"
			cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
		Endif	      
		cQuery += " AND SA1.A1_FILIAL ='" + xSA1 + "'"
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE"
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA"
		cQuery += " AND SA1.D_E_L_E_T_ <> '*'"
		IF ! lVEIC
			cQuery += " AND D1_COD >= '" + MV_PAR01 + "'"
			cQuery += " AND D1_COD <= '" + MV_PAR02 + "'"
		ELSE
			cQuery += " AND B1_CODITE >= '" + MV_PAR01 + "'"
			cQuery += " AND B1_CODITE <= '" + MV_PAR02 + "'"
		ENDIF			
		cQuery += " AND D1_DTDIGIT >= '" + DTOS(MV_PAR03) + "'"
		cQuery += " AND D1_DTDIGIT <= '" + DTOS(MV_PAR04) + "'"
		cQuery += " AND D1_FORNECE >= '" + MV_PAR05 + "'"
		cQuery += " AND D1_FORNECE <= '" + MV_PAR06 + "'"
		
		cQuery += " UNION "

		cQuery += "SELECT D1_FILIAL"	// 01 
		cQuery += ", D1_DOC"	// 02
		cQuery += ", D1_SERIE"	// 03
		cQuery += ", D1_FORNECE"	// 04
		cQuery += ", D1_LOJA"	// 05
		cQuery += ", D1_DTDIGIT"	// 06
		cQuery += ", D1_COD"	// 07
		cQuery += ", D1_QUANT"	// 08
		cQuery += ", D1_VUNIT"	// 09
		cQuery += ", D1_TOTAL"	// 10
		cQuery += ", D1_TES"	// 11
		cQuery += ", D1_IPI"	// 12
		cQuery += ", D1_PICM"	// 13
		cQuery += ", D1_TIPO"	// 14
		cQuery += ", D1_TP"	// 15
		cQuery += ", D1_GRUPO"	// 16
		cQuery += ", D1_CUSTO"	// 17
		cQuery += ", D1_LOCAL"	// 18
		cQuery += ", D1_QTDEDEV"	// 19
		cQuery += ", D1_ITEM"	// 20
		cQuery += ", D1_UM"	// 21

		If lVEIC
	      cQuery += ", B1_CODITE"	// 22
      Endif

      If ! Empty(Alltrim(cQryAdd))
			cQuery += ", " + cQryAdd	// 23
		Endif
		cQuery += ", F1_MOEDA"	// 24
		cQuery += ", F1_TXMOEDA"	// 25
		cQuery += ", F1_DTDIGIT"	// 26

		If mv_par11 == 1
			cQuery +=", F4_AGREG"	// 27
		Endif
		cQuery += ", B1_DESC"	// 28
		cQuery += ", B1_UM"	// 29
		cQuery += ", A2_NOME"	// 30
		cQuery += ", A2_NREDUZ"	// 31

		cQuery += ", SD1.R_E_C_N_O_ SD1RECNO"	// 32

		cQuery += ", D1_PEDIDO"	// 21
		cQuery += ", D1_ITEMPC"	// 21
		
		cQuery += " FROM " + RetSqlName("SF1") + "  (NOLOCK) SF1"
		cQuery += ", " + RetSqlName("SD1") + "  (NOLOCK) SD1"
		cQuery += ", " + RetSqlName("SB1") + "  (NOLOCK) SB1"
		cQuery += ", " + RetSqlName("SA2") + "  (NOLOCK) SA2"
		If mv_par11 == 1
			cQuery += ", " + RetSqlName("SF4") + "  (NOLOCK) SF4"
		Endif 
		cQuery += " WHERE"
		cQuery += " SF1.F1_FILIAL='" + xSF1 + "'"
		cQuery += " AND SF1.D_E_L_E_T_ <> '*'"
		cQuery += " AND SD1.D1_FILIAL = '" + xSD1 + "'"
		cQuery += " AND SD1.D1_DOC = SF1.F1_DOC"
		cQuery += " AND SD1.D1_SERIE = SF1.F1_SERIE"
		cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE"
		cQuery += " AND SD1.D1_LOJA = SF1.F1_LOJA"
		cQuery += " AND SD1.D1_TIPO NOT IN ('D','B')"
		cQuery += " AND NOT (" + IsRemito(3,'SD1.D1_TIPODOC') + ")"
		cQuery += " AND SD1.D_E_L_E_T_ <> '*'"
		cQuery += " AND SB1.B1_FILIAL ='" + xSB1 + "'"
		cQuery += " AND SB1.B1_COD = SD1.D1_COD"
		cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
		If mv_par11 == 1
			cQuery += " AND SF4.F4_FILIAL ='" + xSF4 + "'"
			cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"
			cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
		Endif    
		cQuery += " AND SA2.A2_FILIAL ='" + xSA2 + "'"
		cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE"
		cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA"
		cQuery += " AND SA2.D_E_L_E_T_ <> '*'"
		IF ! lVEIC
			cQuery += " AND D1_COD >= '" + MV_PAR01 + "'"
			cQuery += " AND D1_COD <= '" + MV_PAR02 + "'"
		Else
			cQuery += " AND B1_CODITE >= '" + MV_PAR01 + "'"
			cQuery += " AND B1_CODITE <= '" + MV_PAR02 + "'"
		Endif	
		cQuery += " AND D1_DTDIGIT >= '" + DTOS(MV_PAR03) + "'"
		cQuery += " AND D1_DTDIGIT <= '" + DTOS(MV_PAR04) + "'"
		cQuery += " AND D1_FORNECE >= '" + MV_PAR05 + "'"
		cQuery += " AND D1_FORNECE <= '" + MV_PAR06 + "'"

		If nOrdem == 1
			cQuery += " ORDER BY 4,5,2,3,20"	 //D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE, D1_ITEM	
		ElseIf nOrdem == 2 
			cQuery += " ORDER BY 6,4,5,2,3,20" //D1_DTDIGIT,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE, D1_ITEM		
		ElseIf nOrdem == 3 
			If ! lVEIC
				cQuery += " ORDER BY 15,16,7,6" //D1_TP,D1_GRUPO,D1_COD,D1_DTDIGIT
			Else
			   // O Campo 22 é B1_CODITE para Gestão de Concessionárias !
				cQuery += " ORDER BY 15,16,22,6" //D1_TP,D1_GRUPO,B1_CODITE,D1_DTDIGIT
			Endif
		ElseIf nOrdem == 4 
			If ! lVEIC
				cQuery += " ORDER BY 16,7,6"    //D1_GRUPO,D1_COD,D1_DTDIGIT
			Else
			   // O Campo 22 é B1_CODITE para Gestão de Concessionárias !
				cQuery += " ORDER BY 16,22,6"    //D1_GRUPO,B1_CODITE,D1_DTDIGIT
			Endif
		Endif

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cALiasSD1,.T.,.T.) //"Seleccionado registros"

		For nSD1 := 1 to Len(aStrucSD1)
         If aStrucSD1[nSD1,2] != 'C' .and.  alltrim(aStrucSD1[nSD1][1])$cQuery 
            TCSetField(cALiasSD1, aStrucSD1[nSD1,1], aStrucSD1[nSD1,2],aStrucSD1[nSD1,3],aStrucSD1[nSD1,4])
         EndIf	
      Next nSD1

      For nSF1 := 1 to Len(aStrucSF1)
         If aStrucSF1[nSF1,2] != 'C' .and.  alltrim(aStrucSF1[nSF1][1])$cQuery 
            TCSetField(cALiasSF1, aStrucSF1[nSF1,1], aStrucSF1[nSF1,2],aStrucSF1[nSF1,3],aStrucSF1[nSF1,4])
         EndIf	
      Next nSF1 
      
      For nSB1 := 1 to Len(aStrucSB1)
         If aStrucSB1[nSB1,2] != 'C' .and.  alltrim(aStrucSB1[nSB1][1])$cQuery
            TCSetField(cALiasSB1, aStrucSB1[nSB1,1], aStrucSB1[nSB1,2],aStrucSB1[nSB1,3],aStrucSB1[nSB1,4])
         EndIf	
      Next nSB1
      
      For nSA1 := 1 to Len(aStrucSA1)
         If aStrucSA1[nSA1,2] != 'C' .and.  alltrim(aStrucSA1[nSA1][1])$cQuery
            TCSetField(cALiasSA1, aStrucSA1[nSA1,1], aStrucSA1[nSA1,2],aStrucSA1[nSA1,3],aStrucSA1[nSA1,4])
         EndIf	
      Next nSA1
      
      For nSA2 := 1 to Len(aStrucSA2)
         If aStrucSA2[nSA2,2] != 'C' .and.  alltrim(aStrucSA2[nSA2][1])$cQuery 
            TCSetField(cALiasSA2, aStrucSA2[nSA2,1], aStrucSA2[nSA2,2],aStrucSA2[nSA2,3],aStrucSA2[nSA2,4])
         EndIf	
      Next nSA2

      If mv_par11 == 1
          For nSF4 := 1 to Len(aStrucSF4)
             If aStrucSF4[nSF4,2] != 'C' .and.  alltrim(aStrucSF4[nSF4][1])$cQuery
                TCSetField(cALiasSF4, aStrucSF4[nSF4,1], aStrucSF4[nSF4,2],aStrucSF4[nSF4,3],aStrucSF4[nSF4,4])
             EndIf	
          Next nSF4
      Endif    
   Else 
#ENDIF        
		cNomeArq := CriaTrab("",.F.)
		dbSelectArea(cAliasSD1)
		If nOrdem == 1
			cChave   := mv_par05
			Condicao := IIF( !Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			Condicao += " .And. D1_FORNECE <= '" + mv_par06 + "'"
			cIndice  := "D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
		ElseIf nOrdem == 2
			cChave   := dtos(mv_par03)
			Condicao := IIF( !Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			Condicao +=	" .And. dtos(D1_DTDIGIT) <= '" + dtos(mv_par04) + "'"
			cIndice  := "Dtos(D1_DTDIGIT)+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
		ElseIf nOrdem == 3
			Condicao := IIF(! Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			cIndice  := "D1_TP+D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
      ElseIf nOrdem == 4
			Condicao := IIF(! Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
	      cIndice  := "D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
      Endif
		Condicao += " .And. !(" + IsRemito(2,'SD1->D1_TIPODOC') + ")"			
      IndRegua("SD1",cNomeArq,cIndice,,Condicao,STR0010)		//"Selecionando Registros..."
      nIndSD1 := RetIndex("SD1")
      dbSelectArea(cAliasSD1)
		#IFNDEF TOP
      	dbSetIndex(cNomeArq+OrdBagExt())
		#ENDIF	   
      dbSetOrder(nIndSD1+1)	
      If nOrdem == 1 .Or. nOrdem == 2
			MsSeek(cChave,.T.)
      Else
			dbGoTop()
      Endif
#IFDEF TOP
	Endif
#ENDIF                   

SetRegua(SD1->(RecCount())) // Total de Elementos da Regua
dbSelectArea(cAliasSD1)

nTotQt   := 0
nTotVal  := 0
// INICIO. VERIFICAR SE O PRIMEIRO REGISTRO É IMPRIMÍVEL ! MARCOS HIRAKAWA
IF ! lVEIC
	If mv_par11 == 1
	   DO WHILE !(cAliasSD1)->(EOF())
   	   IF SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) )
				EXIT
			ENDIF
	      (cAliasSD1)->(DBSKIP())		
		ENDDO
	Endif	
	cProdAnt := (cAliasSD1)->D1_COD
	cGrpAnt  := (cAliasSD1)->D1_GRUPO
	cTipAnt  := (cAliasSD1)->D1_TP
	cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
	cCodAnt  := (cAliasSD1)->D1_DOC
	cForna   := (cAliasSD1)->D1_FORNECE
	cSerNf   := (cAliasSD1)->D1_SERIE
ELSE
   DO WHILE !(cAliasSD1)->(EOF())
      IF SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD)) .and. ;
      (SB1->B1_CODITE >= MV_PAR01 .AND. SB1->B1_CODITE <= MV_PAR02)
			If (mv_par11 <> 1) ;
			.or. (mv_par11 == 1 .AND. SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
				EXIT
			ENDIF
		Endif	
		(cAliasSD1)->(DBSKIP())
	ENDDO
	cProdAnt := (cAliasSD1)->D1_COD
	cGrpAnt  := (cAliasSD1)->D1_GRUPO
	cTipAnt  := (cAliasSD1)->D1_TP
	cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
	cCodAnt  := (cAliasSD1)->D1_DOC
	cForna   := (cAliasSD1)->D1_FORNECE
	cSerNf   := (cAliasSD1)->D1_SERIE
ENDIF
// FIM. VERIFICAR SE O PRIMEIRO REGISTRO É IMPRIMÍVEL ! MARCOS HIRAKAWA

If nOrdem == 1
	cQuebra      := (cAliasSD1)->D1_FORNECE
Elseif nOrdem == 2
	cQuebraDtDig := (cAliasSD1)->D1_DTDIGIT
Endif

If !lQuery
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ posiciona o cabecalho da nota                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(cAliasSF1)->(MsSeek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
Endif

nTaxa   :=(cAliasSF1)->F1_TXMOEDA
nMoeda  :=(cAliasSF1)->F1_MOEDA
dDtDig  :=(cAliasSF1)->F1_DTDIGIT

dbSelectArea(cAliasSD1)
While !Eof()
	
	If lEnd
		@PROW()+1,001 PSAY STR0011		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	IF ! lVEIC
	
		lFiltro := Iif(((cAliasSD1)->D1_COD < mv_par01 .Or. (cAliasSD1)->D1_COD > mv_par02) .Or.;
		((cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04) .Or.;
		((cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06),.F.,.T.)
	
	ELSe
	
		If ;
      ( SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD)) .AND. ;
      (SB1->B1_CODITE < mv_par01 .OR. SB1->B1_CODITE > mv_par02) ) ;
		.Or.;
		( (cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04 ) ;
		.Or.;
		( (cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06 )
		
			lFiltro := .F.
		else
			lFiltro := .T.
		Endif
	
	ENDIF	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o Filtro do usuario                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7]) .And. lFiltro
		lFiltro := Iif(&(aReturn[7]),.T.,.F.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Moeda                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par10==2  //nao imprimir notas com moeda diferente da escolhida
		if if((cAliasSF1)->F1_MOEDA==0,1,(cAliasSF1)->F1_MOEDA) != mv_par09
			lFiltro := .F.
		endif
	endif
	
	#IFDEF SHELL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Despreza Nota Fiscal Cancelada.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD1)->D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Nota Fiscal sem TES de acordo com parametro         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1 .And. Empty((cAliasSD1)->D1_TES)
		lFiltro := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICAR SE TEM O TES NA TABELA SF4, QDO TEM O PARAMETRO 11,³
	//³ E SEM SER FILTRADO POR SQL QUERY.     MARCOS HIRAKAWA        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFiltro .AND. (!lQuery) .And.( mv_par11=1 ) .And. (!Empty((cAliasSD1)->D1_TES));
	.AND.  (!SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
		lFiltro := .F.
	ENDIF

	If lFiltro
		
		If li > 59
			cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		// SO' IMPRIMIRA' B1_CODITE SE FOR NA ORDEM DE FORNECEDOR E DATA DE DIGITACAO!
		@ li,000 PSAY (cAliasSD1)->D1_DOC Picture PesqPict("SD1","D1_DOC",Len((cAliasSD1)->D1_DOC))

		IF lVEIC .AND. (nOrdem == 1 .OR. nOrdem == 2)
			If !lQuery
				dbSelectArea(cAliasSB1)
				dbSetOrder(1)
				MsSeek(xSB1 + (cAliasSD1)->D1_COD )
			ENDIF
			@ li,013 PSAY '[ ' + (cAliasSB1)->B1_CODITE + ' ]'
			li++
		ELSE
		   @ li,013 PSAY SUBSTR((cAliasSD1)->D1_COD,1,6) Picture PesqPict("SD1","D1_COD",6)
      ENDIF
      
		If !lQuery
			dbSelectArea(cAliasSB1)
			dbSetOrder(1)
			MsSeek(xSB1 + (cAliasSD1)->D1_COD )
		Endif

		//@ li,029 PSAY Substr((cAliasSB1)->B1_DESC,1,30)
		@ li,021 PSAY Substr((cAliasSB1)->B1_DESC,1,26)
		
		dbSelectArea(cAliasSD1)
		
		If cPaisLoc <> "BRA"
			aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
			nImpInc	:=	0
			nImpNoInc:=	0
			nImpos	:=	0
			For nY:=1 to Len(aImpostos)
				cCampImp:=(cAliasSD1)+"->"+(aImpostos[nY][2])
				nImpos:=&cCampImp
				nImpos:=xmoeda(nImpos,nMoeda,mv_par09,dDtDig,nDecs+1,nTaxa)
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+=nImpos
				Else
					If aImpostos[nY][3]=="2"
						nImpInc-=nImpos
					Else
						nImpNoInc+=nImpos
					Endif
				EndIf
			Next
			aTotais[01] += nImpNoInc // Total imposto nao incluido / NF
			aTotais[02] += nImpInc   // Total imposto incluido     / NF
			aTotais[03] += nImpNoInc // Total imposto nao incluido / Fornecedor
			aTotais[04] += nImpInc   // Total imposto incluido     / Fornecedor
			aTotais[05] += nImpNoInc // Total imposto nao incluido / Data
			aTotais[06] += nImpInc   // Total imposto incluido     / Data
			aTotais[07] += nImpNoInc // Total imposto nao incluido / Grupo
			aTotais[08] += nImpInc   // Total imposto incluido     / Grupo
			aTotais[09] += nImpNoInc // Total imposto nao incluido / Tipo
			aTotais[10] += nImpInc   // Total imposto incluido     / Tipo
			aTotais[11] += nImpNoInc // Geral imposto nao incluido
			aTotais[12] += nImpInc   // Geral imposto incluido
		Endif

      //                              
      //  CUSTOMIZACAO - PEDIDO DE COMPRA + ITEM
      //
		@ li,049 PSAY (cAliasSD1)->D1_PEDIDO+" - "+(cAliasSD1)->D1_ITEMPC
		
		@ li,062 PSAY (cAliasSD1)->D1_QUANT    Picture PesqPict("SD1","D1_QUANT",14)
		@ li,077 PSAY (cAliasSD1)->D1_UM       Picture PesqPict("SD1","D1_UM",2)
		@ li,080 PSAY xmoeda((cAliasSD1)->D1_VUNIT,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_VUNIT",16,mv_par09)
		     
		If cPaisloc=="BRA"
			@ li,097 PSAY (cAliasSD1)->D1_IPI  Picture PesqPict("SD1","D1_IPI",5)
			@ li,103 PSAY xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,120 PSAY (cAliasSD1)->D1_PICM Picture PesqPict("SD1","D1_PICM",5)
			@ li,126 PSAY (cAliasSD1)->D1_FORNECE
		Else
			@ li,097 PSAY nImpNoInc   	Picture TM(nImpNoInc,12)
			@ li,110 PSAY xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,127 PSAY nImpInc     	Picture TM(nImpInc,12)
			@ li,140 PSAY (cAliasSD1)->D1_FORNECE
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exibir Cod. e Nome do Fornecedor/Cliente conf. o tipo da Nota ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD1)->D1_TIPO $ "DB"
			If !lQuery
				dbSelectArea(cAliasSA1)
				dbSetOrder(1)
				If MsSeek(xSA1 + (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					If cPaisLoc == "BRA"
						@ li,nPosNome PSAY Substr((cAliasSA1)->A1_NOME,1,nTamNome)
					Else
						@ li,147 PSAY Left((cAliasSA1)->A1_NREDUZ,nTamReduz)
					EndIf
				Endif
			Else
				If cPaisLoc == "BRA"
					@ li,nPosNome PSAY Substr((cAliasSA1)->A1_NOME,1,nTamNome)
				Else
					@ li,147 PSAY Left((cAliasSA1)->A1_NREDUZ,nTamReduz)
				EndIf
			Endif
		Else
			If !lQuery
				dbSelectArea(cAliasSA2)
				dbSetOrder(1)
				If MsSeek(xSA2 + (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					If cPaisLoc == "BRA"
						@ li,nPosNome PSAY Substr((cAliasSA2)->A2_NOME,1,nTamNome)
					Else
						@ li,147 PSAY Left((cAliasSA2)->A2_NREDUZ,nTamReduz)
					EndIf
				Endif
			Else
				If cPaisLoc == "BRA"
					@ li,nPosNome PSAY Substr((cAliasSA2)->A1_NOME,1,nTamNome)
				Else
					@ li,147 PSAY Left((cAliasSA2)->A1_NREDUZ,nTamReduz)
				Endif
			Endif
		EndIf
		
		dbSelectArea(cAliasSD1)
		
		@ li,174 PSAY (cAliasSD1)->D1_TIPO		Picture PesqPict("SD1","D1_TIPO",2)
		@ li,177 PSAY (cAliasSD1)->D1_TES		Picture PesqPict("SD1","D1_TES",3)
		@ li,181 PSAY (cAliasSD1)->D1_TP		Picture PesqPict("SD1","D1_TP",2)
		@ li,185 PSAY (cAliasSD1)->D1_GRUPO		Picture PesqPict("SD1","D1_GRUPO",4)
		@ li,191 PSAY (cAliasSD1)->D1_DTDIGIT
		nAuxCus:=xmoeda((cAliasSD1)->D1_CUSTO,1,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
		@ li,201 PSAY nAuxCus					Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
		@ li,218 PSAY (cAliasSD1)->D1_LOCAL		Picture PesqPict("SD1","D1_LOCAL",2)
		
		If !lQuery .Or. mv_par11 == 2
			dbSelectArea(cAliasSF4)
			MsSeek(xSF4 + (cAliasSD1)->D1_TES)
		Endif
		
		If (cAliasSF4)->F4_AGREG <> "N"
			nTotForn += nAuxCus //D1_CUSTO
			nTotProd += nAuxCus //D1_CUSTO
			nTotal   += nAuxCus //D1_CUSTO
			nTotDtCus+= nAuxCus //D1_CUSTO
			nAuxTot:=xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
			nTotQt   += (cAliasSD1)->D1_QUANT
			nTotVal  += nAuxTot //D1_TOTAL
			nTotQt1  += (cAliasSD1)->D1_QUANT
			nTotVal1 += nAuxTot //D1_TOTAL
			nTotQt2  += (cAliasSD1)->D1_QUANT          // Total Geral da Quant.
			nTotVal2 += nAuxTot //D1_TOTAL   // Total Geral do Valor
			nTotQt3  += (cAliasSD1)->D1_QUANT
			nTotVal3 += nAuxTot //D1_TOTAL
			nTotDtQt += (cAliasSD1)->D1_QUANT
			nTotDtVal+= nAuxTot //D1_TOTAL
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificar a existencia de Devolucoes de Compras.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasSD1)
		If (cAliasSD1)->D1_QTDEDEV <> 0 .And. mv_par07 == 1
			AADD(aRec,Iif(lQuery,SD1RECNO,Recno()))
		Endif
		nCnt+=1
		li++
		
	Endif
	
	dbSelectArea(cAliasSD1)
	dbSkip()
	IncRegua()
   IF ! lVEIC
   
		lFiltro := Iif(((cAliasSD1)->D1_COD < mv_par01 .Or. (cAliasSD1)->D1_COD > mv_par02) .Or.;
		((cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04) .Or.;
		((cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06),.F.,.T.)
		
	ELSE
		
		If ;
      ( SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD )) .AND. ;
       (SB1->B1_CODITE < mv_par01 .OR. SB1->B1_CODITE > mv_par02);
      );
		.Or.;
		( (cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04 );
		.Or.;
		( (cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06 )
		
			lFiltro := .F.
		else
			lFiltro := .T.
		Endif
		
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o Filtro do usuario                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aReturn[7]) .And. lFiltro
		lFiltro := Iif(&(aReturn[7]),.T.,.F.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Moeda                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par10==2  //nao imprimir notas com moeda diferente da escolhida
		if if((cAliasSF1)->F1_MOEDA==0,1,(cAliasSF1)->F1_MOEDA) != mv_par09
			lFiltro := .F.
		endif
	endif
	
	#IFDEF SHELL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Despreza Nota Fiscal Cancelada.                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasSD1)->D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Nota Fiscal sem TES de acordo com parametro         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1 .And. Empty((cAliasSD1)->D1_TES)
		lFiltro := .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ VERIFICAR SE TEM O TES NA TABELA SF4, QDO TEM O PARAMETRO 11,³
	//³ E SEM SER FILTRADO POR SQL QUERY.     MARCOS HIRAKAWA        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFiltro .AND. (!lQuery) .And.( mv_par11=1 ) .And. (!Empty((cAliasSD1)->D1_TES));
	.AND.  (!SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
		lFiltro := .F.
	ENDIF

	If ;
	(;
	 (;
	  ( (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE <> cCodAnt+cSerNF+cForna .And. nOrdem <3 );
    .Or.;
     ( (cAliasSD1)->D1_COD <> cProdAnt .And. nOrdem >2);
    );
    .And.;
	 lFiltro;
	);
	.Or.;
	Eof()
		
		nSaveRec := Iif( lQuery, SD1RECNO, Recno() )
		
		If nCnt >= 1 .And. nOrdem < 3
			ImpTotN(nTotProd,titulo,nOrdem,aTotais)
			aTotais[1] := 0 // Total imposto nao incluido / NF
			aTotais[2] := 0 // Total imposto incluido     / NF
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratar Devolucoes de Compras.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		For i:=1 to Len(aRec)
			
			dbSelectArea("SD1")
			dbGoto(aRec[i])
			dbSelectArea("SD2")
			MsSeek(SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			SF2->(MsSeek(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
			
			nTaxa   :=SF2->F2_TXMOEDA
			nMoeda  :=SF2->F2_MOEDA
			dDtDig  :=SF2->F2_EMISSAO
			
			While !Eof() .And. SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
				SD2->D2_COD+SD2->D2_NFORI+SD2->D2_ITEMORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA
				
				dbSelectArea("SF4")

				if !empty(SD2->D2_TES) .and. MsSeek(xSF4 + SD2->D2_TES)

					dbSelectArea("SD2")
					If i == 1
						@ li++,000 PSAY STR0012		//'-Devolucoes:'
					Endif
					
					@ li,000 PSAY SD2->D2_DOC Picture PesqPict("SD2","D2_DOC",Len((cAliasSD1)->D1_DOC))
	
					IF lVEIC .AND. (nOrdem == 1 .OR. nOrdem == 2)
						If !lQuery
							dbSelectArea(cAliasSB1)
							dbSetOrder(1)
							MsSeek(xSB1 + SD1->D1_COD)
						ENDIF
						@ li,013 PSAY '[ ' + (cAliasSB1)->B1_CODITE + ' ]'
						li++
					ENDIF
	
					@ li,013 PSAY SD2->D2_COD Picture PesqPict("SD2","D2_COD",6)
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					If MsSeek(xSB1 + SD1->D1_COD,.F.)
						@ li,029 PSAY Substr(SB1->B1_DESC,1,30)
					Endif
					
					dbSelectArea("SD2")
					
					If cPaisLoc <> "BRA"
						aImpostos:=TesImpInf(SD2->D2_TES)
						nImpInc	:=	0
						nImpNoInc:=	0
						nImpos	:=	0
						For nY:=1 to Len(aImpostos)
							cCampImp:="SD2->"+(aImpostos[nY][2])
							nImpos:=&cCampImp
							nImpos:=xmoeda(nImpos,nMoeda,mv_par09,dDtDig,nDecs+1,nTaxa)
							If ( aImpostos[nY][3]=="1" )
								nImpInc	+=nImpos
							Else
								If aImpostos[nY][3]=="2"
									nImpInc-=nImpos
								Else
									nImpNoInc+=nImpos
								Endif
							EndIf
						Next
						aTotais[01] += nImpNoInc // Total imposto nao incluido / NF
						aTotais[02] += nImpInc   // Total imposto incluido     / NF
						aTotais[03] += nImpNoInc // Total imposto nao incluido / Fornecedor
						aTotais[04] += nImpInc   // Total imposto incluido     / Fornecedor
						aTotais[05] += nImpNoInc // Total imposto nao incluido / Data
						aTotais[06] += nImpInc   // Total imposto incluido     / Data
						aTotais[07] += nImpNoInc // Total imposto nao incluido / Grupo
						aTotais[08] += nImpInc   // Total imposto incluido     / Grupo
						aTotais[09] += nImpNoInc // Total imposto nao incluido / Tipo
						aTotais[10] += nImpInc   // Total imposto incluido     / Tipo
						aTotais[11] += nImpNoInc // Geral imposto nao incluido
						aTotais[12] += nImpInc   // Geral imposto incluido
					Endif
					
					@ li,060 PSAY SD2->D2_QUANT * -1 Picture PesqPict("SD2","D2_QUANT",16)
					@ li,077 PSAY SD2->D2_UM		  Picture PesqPict("SD2","D2_UM",2)
					@ li,080 PSAY xmoeda(SD2->D2_PRCVEN,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA) Picture PesqPict("SD2","D2_PRCVEN",16,mv_par09)
					
					If cPaisloc=="BRA"
						@ li,097 PSAY SD2->D2_IPI		Picture PesqPict("SD2","D2_IPI",5)
						@ li,103 PSAY xmoeda(SD2->D2_TOTAL * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)	Picture PesqPict("SD2","D2_TOTAL",16,mv_par09)
						@ li,120 PSAY SD2->D2_PICM		Picture PesqPict("SD2","D2_PICM",5)
						@ li,126 PSAY SD2->D2_CLIENTE
					Else
						@ li,097 PSAY nImpNoInc   Picture  TM(nImpNoInc,12)
						@ li,110 PSAY xmoeda(D2_TOTAL * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)	Picture PesqPict("SD2","D2_TOTAL",16,mv_par09)
						@ li,127 PSAY nImpInc     Picture  TM(nImpInc,12)
						@ li,140 PSAY SD2->D2_CLIENTE
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Exibir Cod. e Nome do Fornecedor/Cliente conf. o tipo da Nota ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					If MsSeek(xSA2 + SD2->D2_CLIENTE + SD2->D2_LOJA)
						If cPaisLoc == "BRA"
							@ li,nPosNome  PSAY Substr(("SA2")->A2_NOME,1,nTamNome)
						Else
							@ li,147 PSAY Left(("SA2")->A2_NREDUZ,nTamReduz)
						EndIf
					Endif
					
					dbSelectArea("SD2")
					
					@ li,174 PSAY SD2->D2_TIPO		Picture PesqPict("SD2","D2_TIPO",2)
					@ li,177 PSAY SD2->D2_TES		Picture PesqPict("SD2","D2_TES",3)
					@ li,181 PSAY SD2->D2_TP		Picture PesqPict("SD2","D2_TP",1)
					@ li,185 PSAY SD2->D2_GRUPO		Picture PesqPict("SD2","D2_GRUPO",4)
					@ li,191 PSAY SD2->D2_EMISSAO
					@ li,201 PSAY xmoeda(SD2->D2_CUSTO1 * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)  Picture PesqPict("SD2","D2_CUSTO1",15,mv_par09)
					@ li,218 PSAY SD2->D2_LOCAL		Picture PesqPict("SD2","D2_LOCAL",2)
					
					dbSelectArea("SF4")
					MsSeek(xSF4 + SD2->D2_TES)
					
					If SF4->F4_AGREG <> "N"
						nAuxCus:=xmoeda(SD2->D2_CUSTO1,1,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						nAuxTot:=xmoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						nTotQt1  -= SD2->D2_QUANT
						nTotVal1 -= nAuxTot //D2_TOTAL
						nTotQt2  -= SD2->D2_QUANT
						nTotVal2 -= nAuxTot //D2_TOTAL
						nTotForn -= nAuxCus //D2_CUSTO1
						nTotal   -= nAuxCus //D2_CUSTO1
						nTotDtQt  -= SD2->D2_QUANT
						nTotDtVal -= nAuxTot //D2_TOTAL
						nTotDtCus -= nAuxCus //D2_CUSTO1
						
						nTotQt   -= SD2->D2_QUANT
						nTotVal  -= nAuxTot //D2_TOTAL
						nTotQt3  -= SD2->D2_QUANT
						nTotVal3 -= nAuxTot //D2_TOTAL
						nTotProd -= nAuxCus //D2_CUSTO1
						
					Endif
					
					li++
				endif	
				dbSelectArea("SD2")
				dbSkip()
				
			EndDo
			
			dbSelectArea(cAliasSD1)
			
		Next
		
		dbgoto(nSaveRec)
		// Alterei a posicao da linha abaixo ! marcos hirakawa.
		// aRec := {}
		dbSelectArea(cAliasSD1)

		If nOrdem == 1 .Or. nOrdem == 2
			
			If Len(aRec) <> 0
				@ li++,000 PSAY Replicate('-',220)
			Endif
			
			If nCnt >= 1
				
				If  nOrdem == 1 .and. (cAliasSD1)->D1_FORNECE <> cQuebra .Or. nOrdem == 2 .and. (cAliasSD1)->D1_FORNECE <> cForna
					ImpTotF(nTotForn,titulo,nOrdem,nTotQt1,nTotVal1,aTotais)
					aTotais[3] := 0 // Total imposto nao incluido / Fornecedor
					aTotais[4] := 0 // Total imposto incluido     / Fornecedor
					nTotForn   := 0
					ntotQt1    := 0
					nTotVal1   := 0
				Endif
				
				IF nOrdem == 2 .and. (cAliasSD1)->D1_DTDIGIT <> cQuebraDtDig
					ImpTotDt(nTotDtCus,titulo,nOrdem,nTotDtQt,nTotDtVal,cQuebraDtDig,aTotais)
					aTotais[5] := 0 // Total imposto nao incluido / Data
					aTotais[6] := 0 // Total imposto incluido     / Data
					nTotDtVal  := 0
					nTotDtCus  := 0
					nTotDtQt   := 0
				Endif
				
			Endif
			
			If !lQuery
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ posiciona o cabecalho da nota                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				(cAliasSF1)->(MsSeek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
			EndIf
			
			nTaxa   := (cAliasSF1)->F1_TXMOEDA
			nMoeda  := (cAliasSF1)->F1_MOEDA
			dDtDig  := (cAliasSF1)->F1_DTDIGIT
			cCodAnt := (cAliasSD1)->D1_DOC
			cForna  := (cAliasSD1)->D1_FORNECE
			cSerNf  := (cAliasSD1)->D1_SERIE
			nTotProd:= 0
			nTotQt  := 0
			nTotVal := 0
			nCnt    := 0
			
			If nOrdem == 1
				cQuebra      := (cAliasSD1)->D1_FORNECE
			Elseif nOrdem == 2
				cQuebraDtDig := (cAliasSD1)->D1_DTDIGIT
			Endif
			
		Else
			
			If (nTotProd <> 0 .Or. cProdAnt <> (cAliasSD1)->D1_COD) .And. nCnt >= 1
				ImpTotPr(nTotProd,cTipGrp,titulo,nOrdem,cProdAnt)
			EndIf
			nTotGrp += nTotProd
			nTotProd := 0
			nTotQt   := 0
			nTotVal  := 0
			cProdAnt := (cAliasSD1)->D1_COD
			nCnt     := 0
			
			If IIf(nOrdem == 3,(cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO <> cTipGrp,(cAliasSD1)->D1_GRUPO <> cGrpAnt)
				If nTotGrp <> 0
					ImpTotGrp(nTotGrp,cGrpAnt,cTipAnt,titulo,nOrdem,nTotQt1,nTotVal1,aTotais)
					aTotais[07] := 0 // Total imposto nao incluido / Grupo
					aTotais[08] := 0 // Total imposto incluido     / Grupo
				EndIf
				nTotTip += nTotGrp
				nTotGrp  := 0
				nTotQT1  := 0
				nTotVal1 := 0
				cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
				cGrpAnt  := (cAliasSD1)->D1_GRUPO
			Endif
			
			If IIf(nOrdem == 3,(cAliasSD1)->D1_TP <> cTipAnt,.t.)
				If nTotTip <> 0 .and. nOrdem == 3
					ImpTotTip(nTotTip,cTipAnt,titulo,nOrdem,nTotQt3,nTotVal3,aTotais)
					aTotais[09] := 0 // Total imposto nao incluido / Tipo
					aTotais[10] := 0 // Total imposto incluido     / Tipo
				EndIf
				nTotTip := 0
				nTotQt3 := 0
				nTotVal3:= 0
				cTipAnt := (cAliasSD1)->D1_TP
			Endif
			
		Endif
		// Alterado a posicao da linha abaixo ! ver acima ! marcos hirakawa.
		aRec := {}
		
	Endif
	
EndDo

If li <> 80
	If nTotal <> 0
		If li > 55
			cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
		Else
			If nOrdem == 2
				li++
			Endif
		Endif
		
		@ li,000 PSAY STR0013		//"TOTAL GERAL       --> "
		@ li,060 PSAY nTotQt2   		Picture PesqPict("SD1","D1_QUANT",16)
		If cPaisLoc == "BRA"
			@ li,103 PSAY nTotVal2  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		Else
			@ li,097 PSAY aTotais[11] 	Picture TM(aTotais[7],12)
			@ li,110 PSAY nTotVal2  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,127 PSAY aTotais[12] 	Picture TM(aTotais[8],12)
		EndIf
		@ li,201 PSAY nTotal    		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
		li++
		Roda(CbCont,"NOTAS","G")
	Endif
Endif

#IFDEF TOP
	dbSelectArea(cAliasSD1)
	dbCloseArea()
#ENDIF

RetIndex("SD1")
dbSelectArea("SD1")
dbClearFilter()
dbSetOrder(1)

RetIndex("SD2")
dbSelectArea("SD2")
dbClearFilter()
dbSetOrder(1)

If File(cNomeArq+OrdBagExt())
	Ferase(cNomeArq+OrdBagExt())
Endif

If File(cNomeArq1+OrdBagExt())
	Ferase(cNomeArq1+OrdBagExt())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotPr ³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime total do produto                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTotPr(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotPr(nTotProd,cTipGrp,titulo,nOrdem,cProdAnt)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
IF ! lVEIC
	@ li,000 PSAY STR0014		//"TOTAL PRODUTO     --> "
ELSE
   SB1->(DBSETORDER(1))
   SB1->(DBSEEK(XSB1 + cProdAnt))
	@ li,000 PSAY SUBSTR(cCABPROD,1,nCOL2) + ' [ ' + SB1->B1_CODITE + ' ] ' +;
	SUBSTR(cCABPROD,nCOL2 + 1)
	
ENDIF	
@ li,060 PSAY nTotQt   		Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103 PSAY nTotVal  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,110 PSAY nTotVal  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
EndIf
@ li,201 PSAY nTotProd 		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
li++
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotGrp³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime total do Grupo                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTotGrp(void)                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotGrp(nTotGrp,cGrupo,cTipAnt,titulo,nOrdem,nTotQt1,nTotVal1,aTotais)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
@ li,000 PSAY STR0015+cGrupo+"  --> "		//"TOTAL GRUPO "
@ li,060 PSAY nTotQt1  			Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103 PSAY nTotVal1 		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,097 PSAY aTotais[07] 	Picture TM(aTotais[07],12)
	@ li,110 PSAY nTotVal1 		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	@ li,127 PSAY aTotais[08] 	Picture TM(aTotais[08],12)
EndIf
@ li,201 PSAY nTotGrp  			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
If nOrdem == 4
	li+=2
Else
	li++
Endif
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotTip³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Total do Tipo                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTotTip(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotTip(nTotTip,cTipo,titulo,nOrdem,nTotQt3,nTotVal3,aTotais)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
@ li,000 PSAY STR0016+cTipo+"    --> "		//"TOTAL TIPO  "
@ li,060 PSAY nTotQt3   		Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103 PSAY nTotVal3  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,097 PSAY aTotais[09] 	Picture TM(aTotais[09],12)
	@ li,110 PSAY nTotVal3  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	@ li,127 PSAY aTotais[10] 	Picture TM(aTotais[10],12)
EndIf
@ li,201 PSAY nTotTip   		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
li+=2
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotN  ³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Total da Nota Fiscal                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTotN(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotN(nTotProd,titulo,nOrdem,aTotais)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotProd <> 0
	@ li,000 PSAY STR0017		//"TOTAL NOTA FISCAL --> "
	@ li,060 PSAY nTotQt 			Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103 PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097 PSAY aTotais[1] 	Picture TM(aTotais[1],12)
		@ li,110 PSAY nTotVal	  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127 PSAY aTotais[2] 	Picture TM(aTotais[2],12)
	EndIf
	@ li,201 PSAY nTotProd			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li+=1
EndIf
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotF  ³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Total do Fornecedor                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTotF(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotF(nTotProd,titulo,nOrdem,nTotQt1,nTotVal1,aTotais)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotProd <> 0
	@ li,000 PSAY STR0018		//"TOTAL FORNECEDOR  --> "
	@ li,060 PSAY nTotQt1  			Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103 PSAY nTotVal1 		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097 PSAY aTotais[3] 	Picture TM(aTotais[3],12)
		@ li,110 PSAY nTotVal1 		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127 PSAY aTotais[4] 	Picture TM(aTotais[4],12)
	EndIf
	@ li,201 PSAY nTotProd 			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li+=2
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotDt ³ Autor ³ Rogerio F. Guimaraes  ³ Data ³ 05.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Total das Notas por data de digitacao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpTotDT                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR090                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpTotDt(nTotCus,titulo,nOrdem,nTotQt,nTotVal,cQuebraDtDig,aTotais)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotVal <> 0
	@ li,000 PSAY STR0019+DTOC(cQuebraDtDig) //"TOT.DA DATA "
	@ li,060 PSAY nTotQt 			Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103 PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097 PSAY aTotais[5] 	Picture TM(aTotais[5],12)
		@ li,110 PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127 PSAY aTotais[6] 	Picture TM(aTotais[6],12)
	EndIf
	@ li,201 PSAY nTotCus			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li++
	@ li,000 PSAY Replicate("-",220)
	li+=1
EndIf
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³08.12.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor :={} 
Local aHelpEng :={} 
Local aHelpSpa :={} 
      
/*-----------------------MV_PAR01--------------------------*/
Aadd( aHelpPor, "Listar apenas Notas Fiscais com TES     " )
Aadd( aHelpPor, "Sim ou Nao                              " )

Aadd( aHelpEng, "Only list Invoices with TES             " )
Aadd( aHelpEng, "Yes or No                               " )

Aadd( aHelpSpa, "Listar solo Facturas con TES            " ) 
Aadd( aHelpSpa, "Si o No                                 " ) 

PutSx1( "MTR090","11","Somente NF com TES ?","Solo Fact.con TES ?","Only Inv with TES ?","mv_chb",;
"N",1,0,0,"C","","","","","mv_par11","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

Return
