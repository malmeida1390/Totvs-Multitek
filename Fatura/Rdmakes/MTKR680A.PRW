#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"
#INCLUDE  "MATR680.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ MATR680A ³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Pedidos nao entregues						      	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTKR680A()

LOCAL cDesc1    := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2    := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3    := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MTKR680A"
LOCAL ny        := 0

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog:= "MTKR680A"
PRIVATE cPerg	 :=	IIf(cPaisLoc == "BRA","MTR680"+SPACE(4),"MR680A"+SPACE(4))
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0
PRIVATE titulo  := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Variaveis utilizadas no Transito
//

Private lQuery    := .F.
Private lContinua := .T.
Private cAlias    := ""
Private aStru     := {}
Private _Recno    := 0
Private _cFilial_ := ""
Private cProduto  := ""
Private nFatura   := 0
Private _uString  := _cParAlmox:= GETMV("MV_ALMCONS")
Private aElem     := {}
Private _cStrAlmox:= ""
Private _aFilSmo  := {}
Private _aNomeAlm := {}

Private aCols6    := {}
Private aHeader6  := U_MONTACOLS("TRANSITO   ","H")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata o parametro para poder ser utilizado pelas Query's               ³
//³o conteudo fica quardado na variavel _cStrAlmox                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While Len(_uString) > 0             // necessario extrair outras formas ja esta
	AADD(aElem,U_Parse(@_uString))    // pronto.
End
_cStrAlmox := ""
For nY := 1 to len(aElem)
	_cStrAlmox := _cStrAlmox + "'" + aElem[nY] + "'"
	If nY <> Len(aElem)
		_cStrAlmox := _cStrAlmox + ","
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Array Com todos os Nomes das Filians para Facilitar as Operacoes ³
//³evitando o uso de Dbseek tracado por um Ascan                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SM0")
_Recno := RECNO()
DbGotop()
While !eof()
	AADD(_aFilSmo,{SM0->M0_CODFIL,SM0->M0_FILIAL})
	SM0->(DBSKIP())
Enddo
Dbgoto(_Recno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Associa Almoxarifado utilizado a um nome previamente cadastrado na     ³
//³tabela SZB.                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZB")
_Recno := RECNO()
DbGotop()
While !eof()
	//AADD(_aNomeAlm,{SZB->ZB_LOCAL,SZB->ZB_LOCNOME})
	AADD(_aNomeAlm,{NNR->NNR_CODIGO,NNR->NNR_DESCRI})
	SZB->(DBSKIP())
Enddo
Dbgoto(_Recno)
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 				    	        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    			 ³
//³ mv_par01				// Do Pedido	                     ³
//³ mv_par02				// Ate o Pedido	                     ³
//³ mv_par03				// Do Produto				         ³
//³ mv_par04				// Ate o Produto					 ³
//³ mv_par05				// Do Cliente						 ³
//³ mv_par06				// Ate o cliente					 ³
//³ mv_par07				// Da data de entrega	    		 ³
//³ mv_par08				// Ate a data de entrega			 ³
//³ mv_par09				// Em Aberto , Todos 				 ³
//³ mv_par10				// C/Fatur.,S/Fatur.,Todos 			 ³
//³ mv_par11				// Mascara							 ³
//³ mv_par12				// Aglutina itens grade 			 ³
//³ mv_par13				// Considera Residuos (Sim/Nao)		 ³
//³ mv_par14				// Lista Tot.Faturados(Sim/Nao)		 ³
//³ mv_par15				// Salta pagina na Quebra(Sim/Nao)	     ³
//³ mv_par16				// Do vendedor                 		 ³
//³ mv_par17				// Ate o vendedor                    |
//³ mv_par18				// Qual a moeda                      |
//³ As proximas pertencem ao grupo MR680A que eh so para         |
//³ Localizacoes...                                     	     ³
//³ mv_par18				// Movimenta stock    (Sim/Nao)	     ³
//³ mv_par19		      // Gen. Doc (Factura/Remito/Ent. Fut/Todos) ³
//³ mv_par21		      // Imprime Similaridade                  ³
//³ mv_par22		      // Imprime Transito                      ³
//³ mv_par22		      // Com Transito/Sem Transito/Ambos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 					     ³
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aOrd :={STR0007,STR0008,STR0009,STR0010,STR0022}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680IMP	³ Autor ³ Alexandre Incaio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio 	         								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR680									            				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis   										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL dData     := CtoD("  /  /  ")
//LOCAL cTotPed   := "NUM = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
//LOCAL limite    := 220
LOCAL CbCont    := 0
LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0
Local cAreaTRB  := ""

Private nPosSimil:=0
Private aSimil   :={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

If MV_PAR20= 1
	
	//
	// Processo de Montagem da Matriz contendo os produtos  similares
	//
	aSimil:=MontaSimil()
	
	//
	// Orderno os Similares
	//
	aSort( aSimil, , , { |x,y| x[5]+x[6] < y[5]+y[6] } )
	
	
Endif


dbSelectArea("TRB")


Do Case
	Case nOrdem = 1
		cQuebra := "NUM = cNum"
		titulo  := titulo +" - "+ STR0007 //"Por Pedido"
		//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		cabec1  := "NUMERO DATA DE   CODIGO LOJA /NOME DO CLIENTE    IT  CODIGO DO DESCRICAO DO             MARGEM PEDIDO DO             COD. PRODUTO          DATA DE   QUANTIDADE  QUANTIDADE  QUANTIDADE  MATRIZ    DEPOS.02  VL TOTAL "
		cabec2  := "PEDIDO EMISSAO                                       PRODUTO   MATERIAL                   %    CLIENTE               DO CLIENTE            ENTREGA   PEDIDA      ENTREGUE    PENDENTE    ARMAZ 01  ARMAZ 01  DO ITEM. "
		
	Case nOrdem = 2
		
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+STR0008 //"Por Produto"
		//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		cabec1  := "CODIGO DO   DESCRICAO DO             MARGEM PEDIDO DO             CODIGO DO             NUMERO  IT  DATA DE   DATA DE   CODIGO LOJA /NOME DO CLIENTE QUANTIDADE  QUANTIDADE  QUANTIDADE  MATRIZ    DEPOS.02  VALOR TOTAL "
		cabec2  := "PRODUTO     MATERIAL                   %    CLIENTE               CLIENTE               PEDIDO      EMISSAO   ENTREGA                                PEDIDA      ENTREGUE    PENDENTE    ARMAZ 01  ARMAZ 01  DO ITEM.    "
		
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+STR0009 //"Por Cliente"
		//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		cabec1  := "CODIGO-LOJA/NOME DO CLIENTE     NUMERO  IT  DATA DE   CODIGO DO   DESCRICAO DO          MARGEM PEDIDO DO             CODIGO DO             DATA DE   QUANTIDADE  QUANTIDADE  QUANTIDADE MATRIZ     DEPOS.02  VALOR TOTAL "
		cabec2  := "                                PEDIDO      EMISSAO   PRODUTO     MATERIAL                %    CLIENTE               CLIENTE               ENTREGA   PEDIDA      ENTREGUE    PENDENTE   ARMAZ 01   ARMAZ 01  DO ITEM.    "
		
	Case nOrdem = 4
		
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + STR0018 //" - Por Data de Entrega"
		//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		cabec1  := " DATA DE   NUMERO  DATA DE   CODIGO LOJA /NOME DO CLIENTE    IT  CODIGO DO   DESCRICAO DO         MARGEM PEDIDO DO             CODIGO DO             QUANTIDADE  QUANTIDADE  QUANTIDADE MATRIZ     DEPOS.02  VALOR TOTAL "
		cabec2  := " ENTREGA   PEDIDO  EMISSAO                                       PRODUTO     MATERIAL               %    CLIENTE               CLIENTE               PEDIDA      ENTREGUE    PENDENTE   ARMAZ 01   ARMAZ 01  DO ITEM.    "
		
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo + STR0022 //" - Por Vendedor"
		//          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		cabec1  := "CODIGO VENDEDOR                 NUMERO  IT  DATA DE   CODIGO DO   DESCRICAO DO         MARGEM PEDIDO DO             CODIGO DO             DATA DE    QUANTIDADE  QUANTIDADE  QUANTIDADE MATRIZ     DEPOS.02  VALOR TOTAL "
		cabec2  := "                                PEDIDO      EMISSAO   PRODUTO     MATERIAL                $   CLIENTE               CLIENTE               ENTREGA    PEDIDA      ENTREGUE    PENDENTE   ARMAZ 01   ARMAZ 01              "
		
		
		
EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica campo para quebra							       		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNum	  := NUM
	cProduto:= PRODUTO
	cCli	  := CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis Totalizadoras     		    				              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
	nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
	
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
		nTotItem+= nValor
		nTIGeral+= nValor
	EndIf
	
	If nTotVen > QUANTIDADE .Or. nTotEnt > ENTREGUE
		lImpTot := .T.
	Else
		lImpTot := .F.
	EndIf
	
	IF (nFirst = 0 .And. nOrdem != 4).Or. nOrdem == 4
		
		li++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o cabecalho da linha		    					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case nOrdem = 1
				@li,  0 Psay NUM
				@li,  7 Psay TRB->EMISSAO
				@li, 17 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 30)
			Case nOrdem = 2
				@li,  0 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,10),Substr(PRODUTO,1,10))
				@li, 12 Psay Left(TRB->DESCRICAO, 22)
				
			Case nOrdem = 3
				@li,  0 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 30)
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != NUM+CLIENTE+DtoS(DATENTR)
					@li,  1 Psay DATENTR
					@li, 11 Psay NUM
					@li, 19 Psay EMISSAO
					@li, 29 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 30 )
					cNumPed := NUM
					cNumCli := CLIENTE
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  0 Psay Left(TRB->VENDEDOR+" "+NOMEVEN, 30)
		EndCase
		
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nValor  := 0
		nReg    := 0
		
		While !Eof() .And.xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNUM == NUM
			
			nReg	 := Recno()
			
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
			nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
			lImpTot := .T.
			
		End
		
		nTotSal += nSaldo
		nTotItem+= nValor
		nTIGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime a linha Conforme a ordem selecionada na setprint	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case nOrdem = 1
			@li, 49  Psay ITEM
			@li, 53  Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,10),Substr(PRODUTO,1,10))
			@li, 63  Psay Left(TRB->DESCRICAO, 22)
			
			@li, 85  Psay TRB->C6_X_MARGE PICTURE "9999.99"
			
			@li, 95  Psay Left(TRB->C5_X_COTCL, 20)
			@li, 117 Psay Left(TRB->C6_X_PRCLI, 20)
			
			@li,139  Psay DATENTR
			
		Case nOrdem = 2
			
			@li, 35 Psay TRB->C6_X_MARGE PICTURE "9999.99"
			@li, 44 Psay Left(TRB->C5_X_COTCL, 20)
			@li, 66 Psay Left(TRB->C6_X_PRCLI, 20)
			
			@li, 88  Psay NUM
			@li, 96  Psay ITEM
			@li, 100 Psay EMISSAO
			@li, 110 Psay DATENTR
			@li, 120 Psay Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,24)
			
		Case nOrdem = 3
			
			@li,  32 Psay NUM
			@li,  40 Psay ITEM
			@li,  44 Psay EMISSAO
			@li,  54 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,10),Substr(PRODUTO,1,10))
			@li,  66 Psay Left(TRB->DESCRICAO,19)
			@li,  87 Psay TRB->C6_X_MARGE PICTURE "9999.99"
			
			@li,  95 Psay Left(TRB->C5_X_COTCL, 20)
			@li, 117 Psay Left(TRB->C6_X_PRCLI, 20)
			
			@li, 139 Psay DATENTR
			
		Case nOrdem = 4
			
			@li, 61 Psay ITEM
			@li, 65 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,10),Substr(PRODUTO,1,10))
			@li, 75 Psay Left(TRB->DESCRICAO, 21)
			
			@li, 97 Psay TRB->C6_X_MARGE PICTURE "9999.99"
			
			@li, 105 Psay Left(TRB->C5_X_COTCL, 20)
			@li, 127 Psay Left(TRB->C6_X_PRCLI, 20)
			
		OtherWise
			
			@li, 32 Psay NUM
			@li, 40 Psay ITEM
			@li, 44 Psay EMISSAO
			@li, 54 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,10),Substr(PRODUTO,1,10))
			@li, 66 Psay Left(TRB->DESCRICAO,19)
			
			@li, 86  Psay TRB->C6_X_MARGE PICTURE "9999.99"
			
			@li, 94 Psay Left(TRB->C5_X_COTCL, 20)
			@li, 116 Psay Left(TRB->C6_X_PRCLI, 20)
			
			@li, 138 Psay DATENTR
			
	EndCase
	
	
	@li,149 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	PICTURE "99999.99"
	@li,161 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)	PICTURE "99999.99"
	@li,173 Psay nSaldo	PICTURE "99999.99"
	//
	// Alteracao processo 52 - 13/05/06
	//
	
	@Li,184 Psay SLDATU  PICTURE "99999.99"
	@Li,194 Psay SLDATU2 PICTURE "99999.99"
	@li,203 Psay nValor	PICTURE PesqPict("SC6","C6_VALOR",15)
	li++
	
	//
	// Imprime a Quantidades em Transito para Este Produto
	//
	If MV_PAR21 = 1
		
		cAreaTRB:=TRB->(GetArea())
		ImprTrans(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,@li)
		RestArea(cAreaTRB)
		
	Endif
	
	//
	// Imprime a Similarida encontrada para este produto
	//
	If MV_PAR20 = 1
		
		cAreaTRB:=TRB->(GetArea())
		ImprSimil(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,@li)
		RestArea(cAreaTRB)
		
	Endif
	
	
	
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total do Pedido                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cTotPed
		If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4
			@Li,000 Psay STR0025
			@Li, 203 /*173*/ Psay nTotItem PICTURE PesqPict("SC6","C6_VALOR",15)
			If nOrdem = 3
				li+=2
			Else
				li++
			ENdif
			nTotitem:= 0
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Total ou linha divisora conforme a quebra		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2
				@Li,000 Psay STR0025
				@Li,149+1 Psay nTotVen PICTURE "99999.99"
				@Li,161+1 Psay nTotEnt PICTURE "99999.99"
				@Li,173+1 Psay nTotSal PICTURE "99999.99"
				li++
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif
		
		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
		
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nFirst  := 0
		
	Endif
	
End

If nTIGeral > 0
	li++
	@Li,000 Psay STR0026
	@Li,149 Psay nTVGeral PICTURE "99999.99"
	@Li,161 Psay nTEGeral PICTURE "99999.99"
	@Li,173 Psay nTSGeral PICTURE "99999.99"
	@Li,203 /*173*/ Psay nTIGeral PICTURE PesqPict("SC6","C6_VALOR",15)
EndIf

li++
@Li,000 Psay "Observacao: A Coluna disponivel mostra       :  Saldo Matriz  Disponivel          + Saldo Matriz Reserva               "
li++
@Li,000 Psay "            A coluna Deposito Fechado mostra :  Saldo Deposito Fechado Disponivel + Saldo Deposito Fechado Reserva     "

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivos de trabalho.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
                                                      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ C680TRB	³ Autor ³ Alexandre Inacio Lemes³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria Arquivo de Trabalho                             	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MATR660													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function C680TRB(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aCampos   := {}
LOCAL aTam      := ""
//LOCAL cKey      := ""
//LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cPedIni   := MV_PAR01
LOCAL cPedFim   := MV_PAR02
LOCAL cProIni   := MV_PAR03
LOCAL cProFim   := MV_PAR04
LOCAL cCliIni   := MV_PAR05
LOCAL cCliFim   := MV_PAR06
LOCAL cDatIni   := MV_PAR07
LOCAL cDatFim   := MV_PAR08
LOCAL nTipVal   := IIF(cPaisLoc == "BRA",MV_PAR19,MV_PAR20)
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
//LOCAL _nValor	 := 0
Local _aSaldoEst := {}
//Local _VSimil   := {}
Local lContinua := .T.
Local cAlias    := "" 

Private cQuery  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NREDUZ")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )

//
// Campos Novos
//
aTam:=TamSX3("C5_X_COTCL")
AADD(aCampos,{ "COTCL","C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_X_PRCLI")
AADD(aCampos,{ "PEDCL","C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NREDUZ")
AADD(aCampos,{ "NREDUZ" ,"C",aTam[1],aTam[2] } )  // Matriz + Fl02 Disponvivel
aTam:=TamSX3("B2_QATU")
AADD(aCampos,{ "SLDATU " ,"N",aTam[1],aTam[2] } )  // Matriz + Fl02 Disponvivel
AADD(aCampos,{ "SLDATU2" ,"N",aTam[1],aTam[2] } )  // Matriz + Fl02 Disponvivel
aTam:=TamSX3("B1_X_SIMIL")
AADD(aCampos,{ "SIMIL" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_X_COTCL")
AADD(aCampos,{ "C5_X_COTCL" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_X_PRCLI")
AADD(aCampos,{ "C6_X_PRCLI" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_X_MARGE")
AADD(aCampos,{"C6_X_MARGE" ,"N",aTam[1],aTam[2] } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
Do Case
	Case nOrdem = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 3
		IndRegua("TRB",cArqTrab,"FILIAL+NREDUZ+NUM+ITEM",,,STR0015)  //"Selecionando Registros..."
		//		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0015)  //"Selecionando Registros..."
	Case nOrdem = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOS(DATENTR)+NUM+ITEM",,,STR0015) //"Selecionando Registros..."
	Case nOrdem = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0015)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o Filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)


cAlias := "ALIASC6"

cQuery := "SELECT C6_PRODUTO,C6_CLI,C6_LOJA,C6_TES,C6_NUM,C6_BLQ,C6_QTDVEN,C6_QTDENT,"							
cQuery += "C6_FILIAL,C6_ENTREG,C6_ITEM,C6_DESCRI,C6_GRADE,C6_ITEMGRD,C6_BLOQUEI,C6_VALOR,C6_PRCVEN,C6_X_PRCLI,C6_X_MARGE "                  
cQuery += "FROM "+RetSqlName("SC6")+" (NOLOCK) "
cQuery += "WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQuery += "C6_NUM >= '"+cPedIni+"' AND "
cQuery += "C6_NUM <= '"+cPedFim+"' AND "
cQuery += "C6_PRODUTO >= '"+cProIni+"' AND "
cQuery += "C6_PRODUTO <= '"+cProFim+"' AND "
cQuery += "C6_CLI >= '"+cCliIni+"' AND "
cQuery += "C6_CLI <= '"+cCliFim+"' AND "
cQuery += "C6_ENTREG >= '"+Dtos(cDatIni)+"' AND "
cQuery += "C6_ENTREG <= '"+Dtos(cDatFim)+"' AND  "

If mv_par13 == 3
	cQuery += "C6_BLQ = 'R ' AND "
Endif

cQuery += "D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY "+SqlOrder(IndexKey())

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias)

aStru     := SC6->(dbStruct())
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
		TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX
aStru     := SC5->(dbStruct())
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
		TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX

DbgoTop()

While !(cAlias)->(Eof())  //.And. (cAlias)->C6_FILIAL == xFilial("SC6")
	
	If (Empty(aReturn[7]) .Or. &(aReturn[7]) )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial()+ (cAlias)->C6_CLI + (cAlias)->C6_LOJA )
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek( xFilial(("SF4"))+(cAlias)->C6_TES )
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek( xFilial(("SC5"))+(cAlias)->C6_NUM )
		
		
		dbSelectArea(cAlias)
		
		// ALMEIDA  VALIDANDO
		//If (cAlias)->C6_ENTREG >=  SC5->C5_EMISSAO
		//	dbSkip()
		//	Loop
		//Endif
		
		
		If cPaisLoc <> "BRA"
			If ( SF4->F4_ESTOQUE == "S" .And. mv_par18 == 2 ) .Or. ( SF4->F4_ESTOQUE!= "S" .And. mv_par18 == 1 )
				dbSkip()
				Loop
			Endif
			If mv_par19 <> 4 .And. SC5->(FIELDPOS("C5_DOCGER")) > 0
				If (mv_par19 == 1 .And. SC5->C5_DOCGER <> '1' ) .Or.;//Gera nota
					(mv_par19 == 2 .And. SC5->C5_DOCGER <> '2' ) .Or.;//Gera REMITO
					(mv_par19 == 3 .And. SC5->C5_DOCGER <> '3' ) //Entrega futura
					dbSkip()
					Loop
				Endif
			Endif
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se esta dentro dos parametros						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet:=ValidMasc((cAlias)->C6_PRODUTO,MV_PAR11)
		
		If Alltrim((cAlias)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		
		
		If ((C6_QTDENT < C6_QTDVEN .And. MV_PAR09 == 1) .Or. (MV_PAR09 == 2)).And.;
			((nSaldo == 0 .And. MV_PAR14 == 1.And.Alltrim((cAlias)->C6_BLQ)<>"R").Or. nSaldo <> 0).And.;
			((SF4->F4_DUPLIC == "S" .And. MV_PAR10 == 1) .Or. (SF4->F4_DUPLIC == "N";
			.And. MV_PAR10 == 2).Or.(MV_PAR10 == 3));
			.And. At(SC5->C5_TIPO,"DB") = 0 .And.lRet
			
			If nOrdem = 5
				
				cVend := "1"
				
				For nX := 1 to nQtdVend
					
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					
					If !EMPTY(cVendedor) .And. (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						
						
						//
						// Define Saldos em estoque
						//
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Parametros : Codigo do Produto                                                                  ³
						//³                                                                                                ³
						//³Retorna:                                                                                        ³
						//³                                                                                                |
						//³[01]     MALHA                                                                                  ³
						//³[01][01] SaldoSb2()                       // DISPONIVEL                                         ³
						//³[01][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
						//³[01][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
						//³[01][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
						//³[01][05] B2_RESERVA                       // RESERVADO                                          ³
						//³[01][06] B2_QEMP                          // EMPENHADO                                          ³
						//³[01][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
						//³[01][08] B2_QPEDVEN                       // A FATURAR                                          ³
						//³[01][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
						//³[01][10] SB2->B2_QATU                     // FISICO                                             ³
						//³[01][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
						//³[01][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
						//³                                                                                                |
						//³[02]     MATRIZ                                                                                 ³
						//³[02][01] SaldoSb2()                       // DISPONIVEL                                         ³
						//³[02][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
						//³[02][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
						//³[02][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
						//³[02][05] B2_RESERVA                       // RESERVADO                                          ³
						//³[02][06] B2_QEMP                          // EMPENHADO                                          ³
						//³[02][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
						//³[02][08] B2_QPEDVEN                       // A FATURAR                                          ³
						//³[02][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
						//³[02][10] SB2->B2_QATU                     // FISICO                                             ³
						//³[02][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
						//³[02][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
						//³                                                                                                |
						//³[03]     FILIAL                                                                                 ³
						//³[03][01] SaldoSb2()                       // DISPONIVEL                                         ³
						//³[03][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
						//³[03][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
						//³[03][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
						//³[03][05] B2_RESERVA                       // RESERVADO                                          ³
						//³[03][06] B2_QEMP                          // EMPENHADO                                          ³
						//³[03][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
						//³[03][08] B2_QPEDVEN                       // A FATURAR                                          ³
						//³[03][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
						//³[03][10] SB2->B2_QATU                     // FISICO                                             ³
						//³[03][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
						//³[03][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
						//³                                                                                                |
						//³[04]     CONSIGNADO                                                                             ³
						//³[04][01] SaldoSb2()                       // DISPONIVEL                                         ³
						//³[04][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
						//³[04][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
						//³[04][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
						//³[04][05] B2_RESERVA                       // RESERVADO                                          ³
						//³[04][06] B2_QEMP                          // EMPENHADO                                          ³
						//³[04][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
						//³[04][08] B2_QPEDVEN                       // A FATURAR                                          ³
						//³[04][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
						//³[04][10] SB2->B2_QATU                     // FISICO                                             ³
						//³[04][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
						//³[04][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
						//³                                                                                                |
						//³[05]     DEPOSITO FECHADO                                                                       ³
						//³[05][01] SaldoSb2()                       // DISPONIVEL                                         ³
						//³[05][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
						//³[05][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
						//³[05][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
						//³[05][05] B2_RESERVA                       // RESERVADO                                          ³
						//³[05][06] B2_QEMP                          // EMPENHADO                                          ³
						//³[05][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
						//³[05][08] B2_QPEDVEN                       // A FATURAR                                          ³
						//³[05][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
						//³[05][10] SB2->B2_QATU                     // FISICO                                             ³
						//³[05][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
						//³[05][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
						//³                                                                                                |
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						
						_aSaldoEst := U_SaldoSb2((cAlias)->C6_PRODUTO,,"01")             // MFATC12.PRW
						
						
						If MV_PAR22   = 1               // Valida Somente Listar Pedidos com Transito
							lContinua:=IIf( _aSaldoEst[01][07] <> 0 , .T. , .f. )
						Elseif MV_PAR22 = 2               //  Valida Somente Listar Pedidos sem Transito
							lContinua:=IIf( _aSaldoEst[01][07]  = 0 , .T. , .f. )
						Else
							lContinua:=.T.
						Endif
						
						
						if lContinua
							
							
							SB1->(dbSelectArea("SB1"),	dbSetOrder(1),dbSeek( xFilial("SB1")+(cAlias)->C6_PRODUTO))
							SA3->(dbSelectArea("SA3"),	dbSetOrder(1),dbSeek( xFilial("SA3")+cVendedor))
							
							dbSelectArea("TRB")
							RecLock("TRB",.T.)
							
							REPLACE VENDEDOR   WITH cVendedor
							REPLACE NOMEVEN    WITH SA3->A3_NOME
							REPLACE FILIAL     WITH (cAlias)->C6_FILIAL
							REPLACE NUM        WITH (cAlias)->C6_NUM
							REPLACE EMISSAO    WITH SC5->C5_EMISSAO
							REPLACE CLIENTE    WITH (cAlias)->C6_CLI
							REPLACE NOMECLI    WITH SA1->A1_NREDUZ
							REPLACE LOJA       WITH (cAlias)->C6_LOJA
							REPLACE DATENTR    WITH (cAlias)->C6_ENTREG
							REPLACE ITEM       WITH (cAlias)->C6_ITEM
							REPLACE PRODUTO    WITH (cAlias)->C6_PRODUTO
							REPLACE DESCRICAO  WITH (cAlias)->C6_DESCRI
							REPLACE QUANTIDADE WITH (cAlias)->C6_QTDVEN
							REPLACE ENTREGUE   WITH (cAlias)->C6_QTDENT
							REPLACE GRADE      WITH (cAlias)->C6_GRADE
							REPLACE ITEMGRD    WITH (cAlias)->C6_ITEMGRD
							REPLACE TES        WITH (cAlias)->C6_TES
							REPLACE BLQ        WITH (cAlias)->C6_BLQ
							REPLACE BLOQUEI    WITH (cAlias)->C6_BLOQUEI
							If nTipVal == 1 //--  Imprime Valor Total do Item
								nValor:=(cAlias)->C6_VALOR
							Else
								//--  Imprime Saldo
								If TRB->QUANTIDADE==0
									nValor:=(cAlias)->C6_VALOR
								Else
									nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAlias)->C6_PRCVEN
									nValor := If(nValor<0,0,nValor)
								EndIf
							EndIf
							
							REPLACE VALOR      WITH nValor
							REPLACE MOEDA      WITH SC5->C5_MOEDA
							REPLACE COTCL      WITH SC5->C5_X_COTCL
							REPLACE PEDCL      WITH (cAlias)->C6_X_PRCLI
							REPLACE NREDUZ     WITH SA1->A1_NREDUZ
							REPLACE SLDATU     WITH _aSaldoEst[02][12] + _aSaldoEst[02][05]  // Matriz  Disponivel + Matriz Reserva
							REPLACE SLDATU2    WITH _aSaldoEst[05][12] + _aSaldoEst[05][05]  // Deposito Fechado Disponivel + Deposito Reserva
							REPLACE SIMIL      WITH SB1->B1_X_SIMIL  // Similar
							
							REPLACE C5_X_COTCL WITH SC5->C5_X_COTCL                           // Pedido do Cliente
							REPLACE C6_X_PRCLI WITH (cAlias)->C6_X_PRCLI                   // Codigo do Cliente
							REPLACE C6_X_MARGE WITH (cAlias)->C6_X_MARGE                   // Marge
							
							
							MsUnLock()
							
						Endif
						
					Endif
					
					cVend := Soma1(cVend,1)
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					
				Next nX
				
			Else
				
				lVend := .F.
				cVend := "1"
				
				For nX := 1 to nQtdVend
					cVendedor := SC5->(FieldGet(FieldPos("C5_VEND"+cVend)))
					If (cVendedor >= MV_PAR16 .And. cVendedor <= MV_PAR17 )
						lVend :=.T.
						Exit
					Endif
					cVend := Soma1(cVend,1)
				Next nX
				
				If lVend
					
					
					_aSaldoEst := U_SaldoSb2((cAlias)->C6_PRODUTO)  // MFATC12.PRW
					
					
					If MV_PAR22   = 1               // Valida Somente Listar Pedidos com Transito
						lContinua:=IIf( _aSaldoEst[01][07] <> 0 , .T. , .f. )
					Elseif MV_PAR22 = 2               //  Valida Somente Listar Pedidos sem Transito
						lContinua:=IIf( _aSaldoEst[01][07]  = 0 , .T. , .f. )
					Else
						lContinua:=.T.
					Endif
					
					
					if lContinua
						
						SB1->(dbSelectArea("SB1"),	dbSetOrder(1),dbSeek( xFilial("SB1")+(cAlias)->C6_PRODUTO))
						SA3->(dbSelectArea("SA3"),	dbSetOrder(1),dbSeek( xFilial("SA3")+cVendedor))
						
						
						dbSelectArea("TRB")
						RecLock("TRB",.T.)
						
						REPLACE FILIAL     WITH (cAlias)->C6_FILIAL
						REPLACE NUM        WITH (cAlias)->C6_NUM
						REPLACE EMISSAO    WITH SC5->C5_EMISSAO
						REPLACE CLIENTE    WITH (cAlias)->C6_CLI
						REPLACE NOMECLI    WITH SA1->A1_NREDUZ
						REPLACE LOJA       WITH (cAlias)->C6_LOJA
						REPLACE DATENTR    WITH (cAlias)->C6_ENTREG
						REPLACE ITEM       WITH (cAlias)->C6_ITEM
						REPLACE PRODUTO    WITH (cAlias)->C6_PRODUTO
						REPLACE DESCRICAO  WITH (cAlias)->C6_DESCRI
						REPLACE QUANTIDADE WITH (cAlias)->C6_QTDVEN
						REPLACE ENTREGUE   WITH (cAlias)->C6_QTDENT
						REPLACE GRADE      WITH (cAlias)->C6_GRADE
						REPLACE ITEMGRD    WITH (cAlias)->C6_ITEMGRD
						REPLACE TES        WITH (cAlias)->C6_TES
						REPLACE BLQ        WITH (cAlias)->C6_BLQ
						REPLACE BLOQUEI    WITH (cAlias)->C6_BLOQUEI
						If nTipVal == 1 //--  Imprime Valor Total do Item
							nValor:=(cAlias)->C6_VALOR
						Else
							//--  Imprime Saldo
							If TRB->QUANTIDADE==0
								nValor:=(cAlias)->C6_VALOR
							Else
								nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAlias)->C6_PRCVEN
								nValor := If(nValor<0,0,nValor)
							EndIf
						EndIf
						REPLACE VALOR      WITH nValor
						REPLACE MOEDA      WITH SC5->C5_MOEDA
						
						REPLACE COTCL  WITH SC5->C5_X_COTCL
						REPLACE PEDCL  WITH (cAlias)->C6_X_PRCLI
						REPLACE NREDUZ WITH SA1->A1_NREDUZ
						REPLACE SLDATU  WITH _aSaldoEst[02][12] + _aSaldoEst[02][05]  // Matriz  Disponivel + Matriz Reserva
						REPLACE SLDATU2 WITH _aSaldoEst[05][12] + _aSaldoEst[05][05]  // Deposito Fechado Disponivel + Deposito Reserva
						REPLACE SIMIL   WITH SB1->B1_X_SIMIL  // Similar
						
						REPLACE C5_X_COTCL WITH SC5->C5_X_COTCL                           // Pedido do Cliente
						REPLACE C6_X_PRCLI WITH (cAlias)->C6_X_PRCLI                   // Codigo do Cliente
						REPLACE C6_X_MARGE WITH (cAlias)->C6_X_MARGE                   // Marge
						
					Endif
					
					lVend := .F.
					
					MsUnLock()
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
	dbSelectArea(cAlias)
	IncProc()
	dbSkip()
	
Enddo

dbSelectArea(cAlias)
dbClosearea()
dbSelectArea("SC6")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Paulo Eduardo       ³Data³ 17.03.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
LOCAL cKey     := ""
LOCAL aHelpPor := {}
LOCAL aHelpEng := {}
LOCAL aHelpSpa := {}

If cPaisLoc <> "BRA"
	
	PutSx1("MR680A"+SPACE(4),"20","Imprime             ","                    ","                    ","mv_chl","N",1,0,1,"C","","","","","mv_par20",;
	"Valor Total","","","",;
	"Saldo","","")
	
	If MsSeek("MR680A")
		While !(EOF()) .and. SX1->X1_GRUPO == "MR680A"
			cKey := "P." + SX1->X1_GRUPO + SX1->X1_ORDEM + "."
			If SX1->X1_ORDEM < "18"
				
				If Empty(SX1->X1_HELP)
					RecLock("SX1",.F.)
					SX1->X1_HELP := ".MTR680" + SX1->X1_ORDEM + "."
					MsUnlock()
				EndIf
				
			Else
				
				If SX1->X1_ORDEM == "18"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe se o TES gera movimentacao")
					aAdd(aHelpPor,"no estoque")
					aAdd(aHelpSpa,"Informe si el TES genera movimiento")
					aAdd(aHelpSpa,"en el stock.")
					aAdd(aHelpEng,"Inform whether TIO generates stock")
					aAdd(aHelpEng,"movement.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "19"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe o tipo de documento a ser")
					aAdd(aHelpPor,"gerado.")
					aAdd(aHelpSpa,"Informe el tipo de documento que se")
					aAdd(aHelpSpa,"generara.")
					aAdd(aHelpEng,"Inform the document type to be")
					aAdd(aHelpEng,"generated.")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				ElseIf SX1->X1_ORDEM == "20"
					aHelpPor := {}
					aHelpSpa := {}
					aHelpEng := {}
					aAdd(aHelpPor,"Informe qual valor sera impresso")
					aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
					aAdd(aHelpSpa,"")
					aAdd(aHelpSpa,"")
					aAdd(aHelpEng,"")
					aAdd(aHelpEng,"")
					PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
				EndIf
				
			EndIf
			DbSkip()
		EndDo
	EndIf
	
Else
	
	dbSelectArea("SX1")
	If MsSeek("MTR68013")
		If Empty(SX1->X1_DEF03)
			RecLock("SX1",.F.)
			SX1->X1_DEF03 := "Somente"
			MsUnlock()
		Endif
	Endif
	
	PutSx1("MTR680"+SPACE(4),"18","Qual a Moeda       ?","Cual Moneda        ?","Which Currency     ?","mv_chi","N",1,0,1,"C","","","","","mv_par18",;
	"Moeda 1","Moneda 1","Currency 1","",;
	"Moeda 2","Moneda 2","Currency 2",;
	"Moeda 3","Moneda 3","Currency 3",;
	"Moeda 4","Moneda 4","Currency 4",;
	"Moeda 5","Moneda 5","Currency 5",{"Informe qual a moeda sera considerada na","emissao do relatorio.                   "})
	
	PutSx1("MTR680"+SPACE(4),"19","Imprime             ","                    ","                    ","mv_chj","N",1,0,1,"C","","","","","mv_par19",;
	"Valor Total","","","",;
	"Saldo","","")
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	aAdd(aHelpPor,"Informe qual valor sera impresso")
	aAdd(aHelpPor,"no campo 'VALOR TOTAL'")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	PutSX1Help("P.MTR68019.",aHelpPor,aHelpEng,aHelpSpa)
	
	
	PutSx1("MTR680"+SPACE(4),"20","Gerar Rel.Similares ","                    ","                    ","mv_chl","N",1,0,1,"C","","","","","mv_par20",;
	"Sim","","","",;
	"Nao","","")
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	aAdd(aHelpPor,"Gerar relacao de produtos similares")
	aAdd(aHelpPor,"que contem Estoque")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	PutSX1Help("P.MTR68020.",aHelpPor,aHelpEng,aHelpSpa)
	
	
EndIf

Return



//
// Funcao utilizada no Browse durante Liberacao do Pedido
//
User Function SaldoSc9(cProduto,cTipoSaldo)

_aSaldoEst := U_SaldoSb2(cProduto,,"01")             // MFATC12.PRW

if cTipoSaldo='01'
	
	Return(_aSaldoEst[06][12] )  // Matriz  Disponivel
	
ElseIF cTipoSaldo='02'
	
	//
	// Nas filiais nao existe o conceito de deposito Fechado.
	//
	If CFILANT <> "01"
		Return(0)
	Else
		Return(_aSaldoEst[05][12] )  // Deposito Fechado Disponivel
	Endif
	
ElseIF cTipoSaldo='03'
	
	//
	//  Somente Saldo da Filial corrente no caso de matriz somar com o saldo do deposito fechado.
	//
	If CFILANT <> "01"
		Return(_aSaldoEst[06][05] )   // Reserva  (matriz + Deposito Fechado)
	Else
		Return(_aSaldoEst[06][05] + _aSaldoEst[02][05])   // Reserva  (matriz + Deposito Fechado)
	Endif
	
Endif

Return(nil)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³MontaSimil³ Autor ³                       ³ Data ³ 15.03.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Define similaridades a serem Impressas para cada produto   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaSimil()

aSimil:={}

DbSelectarea("TRB")
DbGotop()

While !TRB->(EOF())
	
	//
	// Analiza se na Matriz ja nao foi colocado os similares
	//
	nPosSimil := aScan( aSimil , {|x| ALLTRIM(x[5]) == ALLTRIM(TRB->SIMIL)})
	
	If nPosSimil = 0
		
		DbSelectArea("SB1")
		DbOrderNickname("B1SIMIL")                   //B1_X_SIMIL + EIS
		If DbSeek(xFilial("SB1")+TRB->SIMIL)
			
			While !SB1->(EOF()) .and. xFilial("SB1")+TRB->SIMIL =  SB1->(B1_FILIAL+B1_X_SIMIL)
				
				//
				// Nao entra o codigo que esta no Pedido
				//
				If SB1->B1_COD = TRB->PRODUTO
					SB1->(DBSKIP())
					LOOP
				Endif
				
				//
				// Define Saldos em estoque
				//
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Parametros : Codigo do Produto                                                                  ³
				//³                                                                                                ³
				//³Retorna:                                                                                        ³
				//³                                                                                                |
				//³[01]     MALHA                                                                                  ³
				//³[01][01] SaldoSb2()                       // DISPONIVEL                                         ³
				//³[01][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
				//³[01][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
				//³[01][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
				//³[01][05] B2_RESERVA                       // RESERVADO                                          ³
				//³[01][06] B2_QEMP                          // EMPENHADO                                          ³
				//³[01][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
				//³[01][08] B2_QPEDVEN                       // A FATURAR                                          ³
				//³[01][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
				//³[01][10] SB2->B2_QATU                     // FISICO                                             ³
				//³[01][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
				//³[01][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
				//³                                                                                                |
				//³[02]     MATRIZ                                                                                 ³
				//³[02][01] SaldoSb2()                       // DISPONIVEL                                         ³
				//³[02][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
				//³[02][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
				//³[02][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
				//³[02][05] B2_RESERVA                       // RESERVADO                                          ³
				//³[02][06] B2_QEMP                          // EMPENHADO                                          ³
				//³[02][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
				//³[02][08] B2_QPEDVEN                       // A FATURAR                                          ³
				//³[02][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
				//³[02][10] SB2->B2_QATU                     // FISICO                                             ³
				//³[02][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
				//³[02][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
				//³                                                                                                |
				//³[03]     FILIAL                                                                                 ³
				//³[03][01] SaldoSb2()                       // DISPONIVEL                                         ³
				//³[03][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
				//³[03][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
				//³[03][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
				//³[03][05] B2_RESERVA                       // RESERVADO                                          ³
				//³[03][06] B2_QEMP                          // EMPENHADO                                          ³
				//³[03][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
				//³[03][08] B2_QPEDVEN                       // A FATURAR                                          ³
				//³[03][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
				//³[03][10] SB2->B2_QATU                     // FISICO                                             ³
				//³[03][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
				//³[03][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
				//³                                                                                                |
				//³[04]     CONSIGNADO                                                                             ³
				//³[04][01] SaldoSb2()                       // DISPONIVEL                                         ³
				//³[04][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
				//³[04][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
				//³[04][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
				//³[04][05] B2_RESERVA                       // RESERVADO                                          ³
				//³[04][06] B2_QEMP                          // EMPENHADO                                          ³
				//³[04][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
				//³[04][08] B2_QPEDVEN                       // A FATURAR                                          ³
				//³[04][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
				//³[04][10] SB2->B2_QATU                     // FISICO                                             ³
				//³[04][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
				//³[04][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
				//³                                                                                                |
				//³[05]     DEPOSITO FECHADO                                                                       ³
				//³[05][01] SaldoSb2()                       // DISPONIVEL                                         ³
				//³[05][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
				//³[05][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
				//³[05][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
				//³[05][05] B2_RESERVA                       // RESERVADO                                          ³
				//³[05][06] B2_QEMP                          // EMPENHADO                                          ³
				//³[05][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
				//³[05][08] B2_QPEDVEN                       // A FATURAR                                          ³
				//³[05][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
				//³[05][10] SB2->B2_QATU                     // FISICO                                             ³
				//³[05][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
				//³[05][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
				//³                                                                                                |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				
				_aSaldoEst := U_SaldoSb2(SB1->B1_COD,,"01")             // MFATC12.PRW
				
				
				If (_aSaldoEst[02][12] + _aSaldoEst[02][05]) > 0 .OR.;
					(_aSaldoEst[05][12] + _aSaldoEst[05][05]) > 0
					
					aadd(aSimil,{SB1->B1_COD,;
					SB1->B1_DESC,;
					_aSaldoEst[02][12] ,;                     // Matriz  Disponivel
					_aSaldoEst[05][12] ,;                     // Deposito Fechado Disponivel
					SB1->B1_X_SIMIL ,;                          // Similaridade
					SB1->B1_X_SBSIM ,;
					_aSaldoEst[02][05] + _aSaldoEst[05][05],;   // RESERVA
					_aSaldoEst[02][07] + _aSaldoEst[05][07],;   // TRANSITO (SC+PC+OP)
					_aSaldoEst[02][08] + _aSaldoEst[05][08],;   // A FATURAR
					_aSaldoEst[02][09] + _aSaldoEst[05][09]})   // A CLASSIFICAR
					
				Endif
				
				SB1->(DBSKIP())
				
			Enddo
			
		Endif
		
	Endif
	
	DbSelectArea("TRB")
	TRB->(DBSKIP())
	
Enddo


Return(aSimil)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ImprTrans ³ Autor ³                       ³ Data ³ 31.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime as Similaridades encontradas para este programa	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImprTrans(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,li)

Local lReturn := .T.
//
// Com base no produto que estou posicionado devo pegar todos os itens que
// em transito.
//
//                                           - Variavel utilizada dentro MONTACOLS.
cProduto := TRB->PRODUTO
aCols6   :={}
nPosSimil:= 1


//
// A funcao MontaAcols ocorre com base no SB1 que esta posicionado o Produto
//
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+cProduto))


//aHeader6:=U_MONTACOLS("TRANSITO   ","H")   - O aHeader esta sendo chamado no inicio
//                                             da rotina com o objetivo de nao ficar
//                                             chamando todo o tempo ganhando em
//                                             performace
//

// Esta funcao e Utilizada no MFATC03        - Ira gerar um Vetor com o Material que
//                                             esta em transito. No vetor aCols6
U_MONTACOLS("TRANSITO  ","A", aHeader6 )


IF Len(ACOLS6)= 1
	If ACOLS6[nPosSimil][3] = 0
		lReturn := .f.
	Endif
Endif

If Len(acols6)=0
	lReturn := .f.
Endif

//
// Imprime as Similaridades
//
If lReturn
	
	IF li > 52  // retirei 6 pois nao quero somente montar o cabecalho e ir para outra pagina
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	li++
	@li,  030   Psay  ""
	li++
	cabecTrans(@li)
	
	While nPosSimil <= len(ACOLS6)                      //	For nY := nPosSimil to len(aSimil)
		
		IF li > 58
			@li,  030   Psay  "|"+REPLICATE("-",170)+"|"
			li++
			@li,  030   Psay  "Continuacao relacao de similaridade proxima pagina......"
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li++
			@li,  030   Psay  "Continuacao......"
			cabecTrans(@li)
		Endif
		
		@li,   000  Psay  ""
		@li,   030  Psay  "|"
		@li,   041  Psay  substr(ACOLS6[nPosSimil][1],1,30)               // Nome da Filial      //20
		@li,   075  Psay  substr(ACOLS6[nPosSimil][2],1,30)               // Nome do Armazem     //20
		@li,   110  Psay  TRANSFORM(ACOLS6[nPosSimil][3],"@R 9,999,999")  // Quantidade          //09
		
		@li,   125  Psay  alltrim(ACOLS6[nPosSimil][4])                   // Num da Solicitacao  //06
		@li,   135  Psay  alltrim(ACOLS6[nPosSimil][5])                   // Num do PC           //06
		@li,   145  Psay  alltrim(ACOLS6[nPosSimil][6])                   // Num da OP           //06
		
		@li,   155  Psay  ACOLS6[nPosSimil][7]                             // C7_X_DTCON          //10
		@li,   170  Psay  substr(ACOLS6[nPosSimil][8],1,20)                // C7_OBS             //20
		@li,   191  Psay  "|"
		li++
		
		nPosSimil++
		
	Enddo
	
	IF len(ACOLS6) #  0
		@li,  30  Psay  "|"+REPLICATE("-",170)+"|"
		li++
	Endif
	
Endif

Return

//
// Cabecalho Similaridade
//
Static Function cabecTrans(li)

li++
@li,   000  Psay  ""
@li,   030   Psay  "|"+REPLICATE("-",170)+"|"
li++
@li,   000  Psay  ""
@li,   030  Psay  "|"
@li,   041  Psay  "PRODUTOS EM TRANSICO ( SC + PC + OP )"
@li,   201  Psay  "|"
li++
@li,   000  Psay  ""
@li,   030   Psay  "|"+REPLICATE("-",170)+"|"
li++
@li,   000  Psay  ""
@li,   030  Psay  "|"
@li,   041  Psay  "Nome da Filial"
@li,   075  Psay  "Nome do Armazem"
@li,   110  Psay  "Quantidade"
@li,   125  Psay  "Num. SC"
@li,   140  Psay  "Num. PC"
@li,   150  Psay  "Num. OP"
@li,   165  Psay  "Dt.Confirm."
@li,   180  Psay  "Observacoes"
@li,   201  Psay  "|"
li++
@li,   030   Psay  "|"+REPLICATE(" ",170)+"|"
li++

Return





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ImprSimil ³ Autor ³                       ³ Data ³ 31.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime as Similaridades encontradas para este programa	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO					     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImprSimil(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,li)

//
// Como a matriz esta por ordem de similaridade teoricamente deve
// pegar o primeiro simil a partir dai vou  ate o finail buscando
// os proximos
//
nPosSimil := aScan( aSimil ,{|x| AllTrim(x[5])==TRB->SIMIL})

//
// Imprime as Similaridades
//
If nPosSimil # 0
	
	IF li > 52  // retirei 6 pois nao quero somente montar o cabecalho e ir para outra pagina
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Endif
	
	li++
	@li,  060   Psay  ""
	cabeSimil(@li)
	
	While nPosSimil <= len(aSimil)                                           //	For nY := nPosSimil to len(aSimil)
		
		//
		// No momento em que o simil for diferente da similaridade
		// deve abondonar o processo.
		//
		If TRB->SIMIL <> aSimil[nPosSimil][5]
			Exit
		Endif
		
		IF li > 58
			@li,  060   Psay  "|"+REPLICATE("-",112)+"|"
			li++
			@li,  060   Psay  "Continuacao relacao de similaridade proxima pagina......"
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li++
			@li,  060   Psay  "Continuacao......"
			cabeSimil(@li)
		Endif
		
		@li,   000  Psay  ""
		@li,   060  Psay  "|"
		@li,   070  Psay  alltrim(aSimil[nPosSimil][1])
		@li,   086  Psay  alltrim(aSimil[nPosSimil][2])
		@li,   136  Psay  TRANSFORM(aSimil[nPosSimil][7],"@R 9,999,999.99")  // Reservado
		@li,   149  Psay  TRANSFORM(aSimil[nPosSimil][3],"@R 9,999,999.99")  // Matriz Disponivel
		@li,   162  Psay  TRANSFORM(aSimil[nPosSimil][4],"@R 9,999,999.99")  // Filial Disponivel
		@li,   173  Psay  "|"
		li++
		
		//@Li,173     Psay aSimil[nPosSimil][3]  PICTURE  "@E 999,999,999"
		//@Li,185     Psay aSimil[nPosSimil][4]  PICTURE  "@E 999,999,999"
		
		nPosSimil++
		
	Enddo
	
	@li,  060  Psay  "|"+REPLICATE("-",112)+"|"
	li++
	
Endif

Return

//
// Cabecalho Similaridade
//
Static Function cabeSimil(li)


li++
@li,  000  Psay  ""
@li,  060   Psay  "|"+REPLICATE("-",112)+"|"
li++
@li,   000  Psay  ""
@li,  060   Psay  "|"
@li,  070   Psay  "PRODUTOS SIMILARES"
@li,  173   Psay  "|"
li++
@li,  000  Psay  ""
@li,  060   Psay  "|"+REPLICATE("-",112)+"|"
li++
@li,  060   Psay  "|"
@li,  070   Psay  "Codigo"
@li,  086  	Psay  "Produtos Similares em Estoque "
@li,  136   Psay  "Reservado"
@li,  149   Psay  "   Matriz"
@li,  162   Psay  "   Depos.02"
@li,  173   Psay  "|"

li++
@li,  060   Psay  "|"
@li,  149   Psay  "   Dispon."
@li,  162   Psay  "   Dispon."
@li,  173   Psay  "|"

li++
@li,  060   Psay  "|"+REPLICATE(" ",112)+"|"
li++

Return
