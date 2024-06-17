#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "XMLXFUN.CH"
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MTK410   ³ Rev.  ³ Eduardo Riera         ³ Data ³ 26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de atualizacao de Pedidos de Venda                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void MATA410(void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTK410(xAutoCab,xAutoItens,nOpcAuto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                    
Local   aCores     := {}
Local   cArmaFech  := GetMv("MV_ARMFECH")
	
PRIVATE aHeadSC6   := {}
PRIVATE aHeadSCV   := {}
PRIVATE l410Auto   := xAutoCab <> NIL  .And. xAutoItens <> NIL
PRIVATE aAutoCab   := {}
PRIVATE aAutoItens := {}
PRIVATE aRotina := { { OemToAnsi(STR0001),"AxPesqui"  ,0,1},;		//"Pesquisar"
	{ OemToAnsi(STR0002),"A410Visual",0,2},;		//"Visual"
	{ OemToAnsi(STR0003),"U_I410MTK",0,3},;		//"Incluir"
	{ OemToAnsi(STR0005),"A410Deleta",0,5,21},;	//"Excluir"
	{ OemToAnsi(STR0032),"A410Legend" ,0,3,0} }    //"Legenda"

//	{ OemToAnsi(STR0004),"A410Altera",0,4,20},;  	//"Alterar"


PRIVATE cCadastro := OemToAnsi(STR0007) //"Atualiza‡„o de Pedidos de Venda"
If ( cPaisLoc != "BRA" )
	PRIVATE aArrayAE:={}
	PRIVATE lImpMsg:=.T.
EndIf
DEFAULT nOpcAuto := 3

If  !(cFilAnt $ cArmaFech)     

	Aviso("Atencao","Rotina somente pode ser utilizada pelas Filiais contidas no parametro MV_ARMFECH "+;
          " (ARMAZEM FECHADOS).",{'Ok'})

    RETURN
    
Endif    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeadSC6 para otimizacao das rotinas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ABI")     


If SC5->(FieldPos("C5_BLQ")) == 0
	aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA)",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E'",'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA)",'BR_AMARELO'}}	//Pedido Liberado
Else
	aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
				{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
				{ "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
Endif
				

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
	If ( X3USO(SX3->X3_USADO) .And.;
			!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
			Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
			Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
			cNivel >= SX3->X3_NIVEL )
		Aadd(aHeadSC6,{ TRIM(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeadSCV para otimizacao das rotinas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SCV")
While !Eof() .And. SX3->X3_ARQUIVO == "SCV"
	If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		Aadd(aHeadSCV, { AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
			SX3->X3_CONTEXT } )								
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo


mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)


dbSelectArea("SC5")
dbSetOrder(1)
dbClearFilter()
SetKey(VK_F12,Nil)
Return(.T.)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³I410MTK   ³ Rev.  ³                       ³ Data ³26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina Expecifica utilizada na Inclusao de Pedidos de       ³±±
±±³          ³Origem Almoxarifados Fechados.                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do cabecalho do pedido de venda                ³±±
±±³          ³ExpN2: Recno do cabecalho do pedido de venda                ³±±
±±³          ³ExpN3: Opcao do arotina                                     ³±±
±±³          ³ExpL4: Indica se o acols e aheader foram inicializados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a interface com o usua³±±
±±³          ³rio e o pedido de vendas                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function I410MTK(cAlias,nReg,nOpc,lOrcamento)

Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aInfo     := {}
Local aProdDesc := {}
Local nOpcA 	:= 0
Local nCntFor	:= 0
Local nNumDec   := TamSX3("C6_VALOR")[2]
Local nGetLin   := 0
Local nUsado	:= 0
Local cCampo	:=	""
Local cCadastro := "Atualizacao de Pedidos de Venda - Expecifico Multitek (Armazem Fechados) "
Local cPedido   := ""
Local lContinua := .T.
Local lLiber	:= .F.
Local lTransf	:= .F.
Local oDlg
Local oGetD
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oCodBarra

Local aAltGr  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar array PRIVATE p/ integracao com sistema de Distribuicao - NAO REMOVER ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aDistrInd:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega perguntas do MATA440 e BROWDEV                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA440",.F.)
lLiber := MV_PAR02 == 1
lTransf:= MV_PAR01 == 1
Pergunte("MTA410",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel utilizada p/definir Op. Triangulares.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IsTriangular( (MV_PAR03==1) )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTela[0][0]
PRIVATE aGets[0]
PRIVATE bArqF3
PRIVATE bCpoF3
PRIVATE aTrocaF3  := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
PRIVATE lMV_ACESDEV := .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O Orcamento de Venda n„o permite grade de produtos                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lOrcamento := If(ValType(lOrcamento)=="L",lOrcamento,.F.)
l416Auto   := If (Type("l416Auto") == "U",.f.,l416Auto)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³A inicializacao das variaveis ja foi feita pela rotina de Orcamento     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ( !lOrcamento )
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
	PRIVATE aHeader   := {}
	PRIVATE aCols     := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva a integridade dos campos de Bancos de Dados    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa desta forma para criar uma nova instancia de variaveis private ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory( "SC5", .T., .F. )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aHeader                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("aHeadSC6")=="U"
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SC6")
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
			IF ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .And.;
				(	!AllTrim(SX3->X3_CAMPO)=="C6_NUM" 	.And.;
				AllTrim(SX3->X3_CAMPO)<>"C6_QTDEMP"	.And.;
				AllTrim(SX3->X3_CAMPO)<>"C6_QTDENT" ) 

				nUsado++
				Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO	,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
	Else
		aHeader := aClone(aHeadSC6)
		nUsado  := Len(aHeader)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aCols                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		If ( AllTrim(aHeader[nCntFor][2]) == "C6_ITEM" )
			aCols[1][nCntFor] := "01"
		EndIf
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
	
EndIf


//
// Campos que seram alteraveis pelo usuario durante utilizadao do especifico
// 
For nCntFor := 2 To Len(aHeader)
	If   ALLTRIM(aHeader[nCntFor][2]) $ "C6_PRODUTO|C6_QTDVEN|C6_TES|C6_CF|C6_LOCAL" 
	     aadd(aAltGr,aHeader[nCntFor][2])
         aHeader[nCntFor][1] := alltrim(aHeader[nCntFor][1])+" (*)"
	Endif
Next nCntFor


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array com as formas de pagamento do SX5³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ma410MtFor(@aHeadFor,@aColsFor)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( M->C5_TIPO $ "DB" )
	aTrocaF3 := {{"C5_CLIENTE","SA2"}}
Else
	aTrocaF3 := {}
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,265}} )
nGetLin := aPosObj[3,1] 


DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "SC5", nReg, nOpc, , , , , aPosObj[1],,3,,,"U_VALIDALL(aCols,aHeader)")

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_VALIDALL(aCols,aHeader)","U_VALIDALL(aCols,aHeader)","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,aAltGr,1,,300)

M->C5_TIPO := "N"

ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,;
{|| nOpcA := 1 , IIf( U_VALIDALL(aCols,aHeader) , (  IIf( U_ANALACOLS(aCols,aHeader,nOpc) , oDlg:End() , nOpcA:=0 ) ), nOpcA:=0 ) } ,;
{|| nOpcA := 0 , oDlg:End()}  ,;
nOpc )  CENTERED



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Gravacao do Pedido de Venda (NORMAL) e                         ³
//³atualizacao do SZV.                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nOpcA == 1 )
	
	If !U_GrvPed(nOpc)
		Aviso("Atencao","Cancelada Geracao do Pedido.",{'Ok'})
	Endif
	
Else
	
	If !( nModulo == 29 .And. Type("l410Auto") <> "U" .And. l410Auto)
		If ( __lSX8 )
			RollBackSX8()
		EndIf
	EndIf
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade da Tela de Entrada                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
Return( nOpcA )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDALL  º Autor ³                    º Data ³  12/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida todos os campos necessarios para prosseguir com a   º±±
±±º          ³ Nota Fiscal Tipo Normal possa prosceguir.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function VALIDALL(aCols,aHeader)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens do Acols          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL _C6_ITEM    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    }) // Codigo do Produto
LOCAL _C6_PRODUTO := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" }) // Codigo do Produto
LOCAL _C6_DESCRI  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"  }) // Descrição do Produto
LOCAL _C6_UM      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"      }) // Unidade de medida
LOCAL _C6_QTDVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  }) // Quantidade Vendida
LOCAL _C6_TES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     }) // Tipo de Saida do Item (TES Inteligente)
LOCAL _C6_CF      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"      }) // Codigo Fiscal da Operação
LOCAL _C6_DESCONT := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT" }) // % Total dos Descontos
LOCAL _C6_VALDESC := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC" }) // Valor Total dos Descontos
LOCAL _C6_PRCVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  }) // Preco Unitario Liquido
LOCAL _C6_VALOR   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   }) // Valor Total do Item
LOCAL _C6_ENTREG  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"  }) // Data da Entrega
LOCAL _C6_LOCAL   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   }) // Almoxarifado
LOCAL _C6_PRUNIT  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"  }) // Preço Unitário de Tabela
LOCAL _C6_CLI     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLI"     }) // Código do Cliente
LOCAL _C6_LOJA    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOJA"    }) // Loja do Cliente
LOCAL _C6_NUM     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUM"     }) // Numero do Pedido
Local _C6_X_CHAVE := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_CHAVE" })

Local lRet        := .T.
Local nY          := 0


If EmptY(M->C5_CLIENTE)
	
	Aviso("Atencao"," Favor informar o Codigo do Cliente (Campo Obrigatorio). ",{'Ok'})
	
	lRet := .F.
	
ElseIF EmptY(M->C5_LOJACLI)
	
	Aviso("Atencao"," Favor informar a Loja do Cliente (Campo Obrigatorio). ",{'Ok'})
	
	lRet := .F.
	
ElseIF Empty(M->C5_CONDPAG)
	
	Aviso("Atencao"," Favor informar as Condicoes de Pagamento da Nota Fiscal (Campo Obrigatorio). ",{'Ok'})
	
	lRet := .F.
	
ElseIF Empty(M->C5_TIPOCLI)
	
	Aviso("Atencao"," Favor informar o Tipo de Cliente (Campo Obrigatorio). ",{'Ok'})
	
	lRet := .F.
	
	
Endif


If lRet
	
	For nY:= 1 to Len(aCols)
		
		If !aCols[nY][len(aHeader)+1]

			If     EmptY(aCols[nY][_C6_PRODUTO])
				
				Aviso("Atencao"," Favor informar o Codigo do Produto no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.
				
			ElseIf aCols[nY][_C6_QTDVEN] = 0
				
				Aviso("Atencao"," Favor informar a Quantidade no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.
				
			//ElseIf aCols[nY][_C6_PRCVEN] = 0
				
			//	Aviso("Atencao"," Favor informar o R$ Simulado no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
			//	lRet := .F.
				
			ElseIf EmptY(aCols[nY][_C6_TES])
				
				Aviso("Atencao"," Favor informar o Tes no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.
				
			ElseIf EmptY(aCols[nY][_C6_CF])
				
				Aviso("Atencao"," Favor informar o CF no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.
				
			//ElseIf EmptY(aCols[nY][_C6_LOCAL])
				
			//	Aviso("Atencao"," Favor informar o Armazem no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
			//	lRet := .F.
				
			ElseIf EmptY(aCols[nY][_C6_LOCAL])
				
				Aviso("Atencao"," Favor informar o Armazem. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.


			ElseIf EmptY(aCols[nY][_C6_ENTREG])
				
				Aviso("Atencao"," Favor informar a Data de Entrega no Item "+STRZERO(nY,4)+" da Nf. (Campo Obrigatorio). ",{'Ok'})
				
				lRet := .F.
				
			Endif
			
		Endif
		
	Next
	
Endif

/*
Em funcao de estamos trantando com quantidades disponivel.
Durante a montagem do Pedido deviria estar RESERVANDO as quantidades no SZ? pois
dois fatores poderiam afetar o processo:

1. Dois usuarios utilizando a rotina de Simultaneamente
2. O Usuario digitando o produto dentro da Nota  duas vezes.

Para efetar a ocorrencia estou adontando 2 procedimentos:

1. Criacao de um parametro que ira trabalhar como semafaro, ou seja somente
tem acesso a rotina um usuario por vez.

2. No processo de validacao do acols consistir se o usuario nao esta digitando 
o mesmo produto mais de uma vez.
*/

Return (lRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvPed    º Autor ³                    º Data ³  12/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida todos os campos necessarios para prosseguir com a   º±±
±±º          ³ Geracao do Pedido.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GrvPed(nOpc)


Local aCabPV 	:= {}
Local aItemPV	:= {}
Local aItem  	:= {}
Local lRet      := .T.

//Local nOpc  	:= 3  //3- inclusao   4- Alteração   5- exclusao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens do Acols          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL _C6_ITEM    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    }) // Codigo do Produto
LOCAL _C6_PRODUTO := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" }) // Codigo do Produto
LOCAL _C6_DESCRI  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"  }) // Descrição do Produto
LOCAL _C6_UM      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"      }) // Unidade de medida
LOCAL _C6_QTDVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  }) // Quantidade Vendida
LOCAL _C6_TES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     }) // Tipo de Saida do Item (TES Inteligente)
LOCAL _C6_CF      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"      }) // Codigo Fiscal da Operação
LOCAL _C6_DESCONT := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT" }) // % Total dos Descontos
LOCAL _C6_VALDESC := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC" }) // Valor Total dos Descontos
LOCAL _C6_PRCVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  }) // Preco Unitario Liquido
LOCAL _C6_VALOR   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   }) // Valor Total do Item
LOCAL _C6_ENTREG  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"  }) // Data da Entrega
LOCAL _C6_LOCAL   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   }) // Almoxarifado
LOCAL _C6_PRUNIT  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"  }) // Preço Unitário de Tabela
LOCAL _C6_CLI     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLI"     }) // Código do Cliente
LOCAL _C6_LOJA    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOJA"    }) // Loja do Cliente
LOCAL _C6_NUM     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUM"     }) // Numero do Pedido
Local _C6_X_CHAVE := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_CHAVE" })
Local _C6_CLASFIS := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS" })
Local _C6_TPOP    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TPOP"    })
Local _C6_QTDLIB  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"  })
Local _C6_NUMLOTE := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE" })
Local _C6_LOTECTL := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL" })
Local _C6_LOCALIZ := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCALIZ" })
Local _C6_NUMSERI := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMSERI" })
Local _C6_IDENTB6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6" })
Local _C6_GRADE   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_GRADE"   })
Local _C6_RESERVA := aScan(aHeader,{|x| AllTrim(x[2])=="C6_RESERVA" })
Local _C6_SERVIC  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERVIC"  })


Private lMshelpAuto := .T.
Private lMsErroAuto := .F.
 



//Cabecalho
aCabPV:=;
{{"C5_FILIAL" 	,xFilial("SC5")	,Nil},; // Filial do pedido
{"C5_NUM"		,M->C5_NUM		,Nil},; // Numero do pedido
{"C5_TIPO"   	,M->C5_TIPO		,Nil},; // Tipo de pedido
{"C5_CLIENTE"	,M->C5_CLIENTE	,Nil},; // Codigo do cliente
{"C5_LOJACLI"	,M->C5_LOJACLI ,Nil},; // Loja do cliente
{"C5_CLIENT"	,M->C5_CLIENT	,Nil},; // Codigo do cliente de Entrega
{"C5_LOJAENT"   ,M->C5_LOJAENT	,Nil},; // Loja de Entrega
{"C5_CONDPAG"	,M->C5_CONDPAG	,Nil},; // Codigo da condicao de pagamanto
{"C5_TIPOCLI"  	,M->C5_TIPOCLI	,Nil},; // Tipo do cliente
{"C5_TABELA"	,M->C5_TABELA	,Nil},; // Código da Tabela de preço
{"C5_TRANSP"	,M->C5_TRANSP	,Nil},; // Código da Transportadora
{"C5_TIPLIB" 	,M->C5_TIPLIB	,Nil},; // Tipo de Liberacao
{"C5_EMISSAO"	,dDatabase		,Nil},; // Data de emissao Protheus
{"C5_MENPAD"  	,M->C5_MENPAD   ,Nil},; // Mensagem Padrao
{"C5_MOEDA"  	,1				,Nil},; // Moeda - Sempre 1
{"C5_MENNOTA"  	,M->C5_MENNOTA	,Nil}}  // Mensagem p/ NF

//Items
For nY := 1 to  Len(aCols)
	
	aItemPV:=;
	{{"C6_FILIAL"	, xFilial("SC6")		    ,Nil},; // Filial
	{"C6_NUM"		,M->C5_NUM			        ,Nil},; // Numero do Pedido
	{"C6_CLI"		,M->C5_CLIENTE		    	,Nil},; // Código do Cliente
	{"C6_LOJA"		,M->C5_LOJACLI		    	,Nil},; // Loja do Cliente
	{"C6_ITEM"		,STRZERO(nY,2)		        ,Nil},; // Item
	{"C6_PRODUTO"	,aCols[nY][_C6_PRODUTO]     ,Nil},; // Codigo do Produto
	{"C6_DESCRI"	,aCols[nY][_C6_DESCRI]		,Nil},; // Descrição do Produto
	{"C6_UM"		,aCols[nY][_C6_UM]			,Nil},; // Unidade de medida
	{"C6_QTDVEN"	,aCols[nY][_C6_QTDVEN]		,Nil},; // Quantidade Vendida
	{"C6_PRCVEN"	,aCols[nY][_C6_PRCVEN]		,Nil},; // Preco Unitario Liquido
	{"C6_VALOR"		,aCols[nY][_C6_VALOR]		,Nil},; // Valor Total do Item
	{"C6_TES"		,aCols[nY][_C6_TES]		    ,Nil},; // Tipo de Saida do Item (TES Inteligente)
	{"C6_CF"		,aCols[nY][_C6_CF]			,Nil},; // Codigo Fiscal da Operação
	{"C6_ENTREG"	,aCols[nY][_C6_ENTREG]		,Nil},; // Data da Entrega
	{"C6_LOCAL"		,aCols[nY][_C6_LOCAL]		,Nil},; // Almoxarifado
	{"C6_CLASFIS"	,aCols[nY][_C6_CLASFIS]	    ,Nil},; // Classificacao FIscal
	{"C6_TPOP"		,aCols[nY][_C6_TPOP]	    ,Nil},; // Tipo de Op
	{"C6_CLASFIS"	,aCols[nY][_C6_CLASFIS]	    ,Nil},; // Classificacao FIscal
	{"C6_X_CHAVE"	,aCols[nY][_C6_X_CHAVE]     ,Nil}}  // Chave Localizacao no SZV


	//{"C6_X_NF"	    ,aCols[nY][_C6_NFORI]		,Nil},; // Nota do Deposito Fechado
	//{"C6_X_SERI"	,aCols[nY][_C6_SERIORI]	,Nil},; // Serie do Deposito Fechado
	//{"C6_X_ITEM"	,aCols[nY][_C6_ITEMORI]	,Nil}}   // Item do e Origem
	//{"C6_NFORI"	    ,aCols[nY][_C6_NFORI]		,Nil},;  // Nota de Origem
	//{"C6_SERIORI"	,aCols[nY][_C6_SERIORI]	,Nil},;  // Serie de Origem
	//{"C6_ITEMORI"	,aCols[nY][_C6_ITEMORI]	,Nil},;  // Item de Origem



//	{"C6_QTDLIB"	,aCols[nY][_C6_QTDLIB]		,Nil},;  // Classificacao FIscal
//	{"C6_IDENTB6"	,aCols[nY][_C6_IDENTB6]	,Nil},;  // Classificacao FIscal
//	{"C6_PRUNIT"	,aCols[nY][_C6_PRUNIT]		,Nil},;  // Preço Unitário de Tabela
//	{"C6_GRADE"	    ,aCols[nY][_C6_GRADE]    	,Nil},;  // Classificacao FIscal
//	{"C6_SERVIC"	,aCols[nY][_C6_SERVIC]  	,Nil},;  // Classificacao FIscal
//	{"C6_NUMLOTE"	,aCols[nY][_C6_NUMLOTE]	,Nil},;  // Classificacao FIscal
//	{"C6_LOTECTL"	,aCols[nY][_C6_LOTECTL]	,Nil},;  // Classificacao FIscal
//	{"C6_LOCALIZ"	,aCols[nY][_C6_LOCALIZ]	,Nil},;  // Classificacao FIscal
//	{"C6_NUMSERI"	,aCols[nY][_C6_NUMSERI]	,Nil},;  // Classificacao FIscal


	aAdd(aItem, aItemPV)
	
Next nY
                                       
DbSelectArea("SB1")

MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPv,aItem,nOpc)

If lMsErroAuto
	
	MOSTRAERRO() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
	
	lRet := .F.
	
Else
	
	// Estando tudo correto irei atualizar o SZV
	
	For nX := 1 to len(aCols)
		
		
		
		cChave:=aCols[nX][_C6_X_CHAVE]//DOC+SERIE+FORNECEDOR+LOJA+PRODUTO+ITEM //aCols[nX][_C6_SERIORI]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][_C6_PRODUTO]+aCols[nX][_C6_ITEMORI]
		DbSelectArea("SZV")
		dbSetOrder(1) // ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_COD + ZV_ITEM
		If dbSeek(cChave)
			Reclock("SZV",.F.)
			ZV_QTD_DEV := ZV_QTD_DEV - aCols[nX][_C6_QTDVEN]
			ZV_UPEDVEN := M->C5_NUM
			MsUnlock()
		Endif


        // Nao estava conseguindo gravar o Item de Origem no SC6 via SigaAuto
        // para tanto estou utilizando a trecho abaixo
		//cChave:=M->C5_NUM+aCols[nX][_C6_ITEM]+aCols[nX][_C6_PRODUTO]
		//DbSelectArea("SC6")
		//dbSetOrder(1)
		//If dbSeek(xFilial("SC6")+cChave)
		//	Reclock("SC6",.F.)
		//	C6_ITEMORI := aCols[nX][_C6_ITEMORI]
		//	MsUnlock()
		//Endif


		
	Next nX
	
Endif


Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ANALACOLS º Autor ³                    º Data ³  12/04/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida Inclusao de Pedidos de Venda (Somente filiais       º±±
±±º          ³ Inclusao / Alteracao                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function ANALACOLS(aCols,aHeader,nOpc)

Local aAreaDados := GetArea()
Local lContinua       := .T.
Local aColsBack  := aClone(aCols)
Local nUsado     := 0

Local cPRODUTO   := ""

Local nY         := 0
Local nX         := 0
Local nPosAcols  := 0
Local nQtdDisp   := 0
Local nQtdSol    := 0

Local nGrvSZV    := 0   //  Qtde a gravar  no  SZV
Local nGrvAcols  := 0   //  Qtde a gravar no  aCols
Local nQtdven    := 0   //  Qtde a buscar na prox. vez ate zerar
Local lQuery     := .T.
Local cAlias     := ""

LOCAL _C6_PRCVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  }) // Preco Unitario Liquido
LOCAL _C6_VALOR   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   }) // Valor Total do Item

Local _nPRODUTO  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local _nQTDVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local _C6_X_CHAVE:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_CHAVE"})
Local _C6_ITEM   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta funcao ira revazer o acols com base   ³
//³no SZV dividindo as quantidades se necess. ³
//³ario no acols em funcao das Nf e Serie Orig|
//³                                           ³
//³Caso o nao tenha entregue quant.           ³
//³suficiente para atender ao Pedido o        ³
//³processamento nao ira continuar            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If  nOpc = 3   // Inclusao
	
	aCols := {}
	nUsado:= len(aHeader)+1
	
	For nY:= 1 to len(aColsBack)
		
		If !aColsBack[nY][nUsado]
			
			nQTDVEN := aColsBack[nY][_nQTDVEN]
			cPRODUTO:= aColsBack[nY][_nPRODUTO]
			
			
			nQtdSol := aColsBack[nY][_nQTDVEN]  // Quantidade Solicitada
			
			#IFDEF TOP
				
				cAlias    := "MA215SZV"
				aStru     := SZV->(dbStruct())
				lQuery    := .T.

				If select(cAlias) <> 0 
				   DbSelectArea(cAlias)
				   dbCloseArea()
				Endif
				
				
				cQuery := "SELECT * "
				cQuery += "FROM "
				cQuery += RetSqlName("SZV")+" SZV "
				cQuery += "WHERE "
				cQuery += "SZV.ZV_FILIAL='"+xFilial("SZV")+"' AND "
				//cQuery += "SZV.ZV_FORNECE='"+M->C5_CLIENTE+"' AND "
				//cQuery += "SZV.ZV_LOJA='"+M->C5_LOJACLI+"' AND "
				cQuery += "SZV.ZV_COD='"+cProduto+"' AND "
				cQuery += "SZV.ZV_QTD_DEV>0 AND "
				cQuery += "SZV.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY ZV_FILIAL,ZV_COD,ZV_EMISSAO "
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
				For nX := 1 To Len(aStru)
					If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery )
						TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
				
				DbgoTop()
				
				If (cAlias)->(Eof())
					
					Aviso("Atencao","Cancelada a Geracao do Pedido. "+;
					" Nao ha Notas Fiscais de Entrada "+;
					" para o Produto "+cPRODUTO   ,{'Ok'})
					
					lContinua  := .F.
					
				Endif
				
			#ELSE
				
				cAlias := "SZV"
				
				dbSelectArea("SZV")
				dbSetOrder(2) //ZV_FILIAL+ZV_COD+Dtos(ZV_EMISSAO)


				If !DbSeek(xFilial("SZV")+cPRODUTO)
					
					Aviso("Atencao","Cancelada a Geracao do Pedido. "+;
					" Nao ha Notas Fiscais de Entrada "+;
					" para o Produto "+cPRODUTO +" ver item "+strzero(nY,4)+"." ,{'Ok'})

				
					lContinua  := .F.
					
				Endif
				
				
			#ENDIF
			
			
			if lContinua
				
				
				nQtdDisp :=0
				
				While !(cAlias)->(Eof())  .and.;
                      (xFilial("SZV")+cPRODUTO) == ((cAlias)->(ZV_FILIAL+ZV_COD))
					
					
					// Efetuo a copia do elemento pertencente ao AcolsBack no Acols
					// ate o saldo ser suficiente para o atendimento.
					AADD(aCols,Array(nUsado))
					
					nPosAcols:=Len(aCols)
					
					For nX := 1 to nUsado
						aCols[nPosAcols][nX]:=aColsBack[nY][nX]

		                If aCols[nPosAcols][nX] = nil 
	            	 
	            		   if aHeader[nPosAcols][8] = "N" 
	            			  aCols[nPosAcols][nX]:=0
		                   ElseIf aHeader[nY][8] = "C" 
	            			  aCols[nPosAcols][nX]:=""
                           Endif

			            Endif                     

					Next
					
					
					If !lQuery
						
						If  (cAlias)->ZV_QTD_DEV = 0
							(cAlias)->(DBSKIP())
							LOOP
						Endif
						
					Endif
					
					
					nQtdDisp:=nQtdDisp + (cAlias)->ZV_QTD_DEV
					
					// Vendido e Maior que o disponivel no registro
					// abato somente a parte disponivel
					If nQtdVen   >= (cAlias)->ZV_QTD_DEV
						
						nGrvAcols:= (cAlias)->ZV_QTD_DEV                  //  Qtde a gravar no  aCols
						nQtdVen  := nQTDVEN  - (cAlias)->ZV_QTD_DEV       //  Qtde a buscar na prox. vez
						
					ElseIF nQTDVEN < (cAlias)->ZV_QTD_DEV
						                  
						nGrvAcols:= nQTDVEN                          //  Qtde a gravar no  aCols
						nQtdven  := 0                                //  Qtde a buscar na prox. vez
						
					Endif


					aCols[nPosAcols][_nQTDVEN ] := nGrvAcols
                    aCols[nPosAcols][_C6_ITEM]  := STRZERO(nPosAcols,2)
                    aCols[nPosAcols][_C6_PRCVEN]:= (cAlias)->ZV_VUNIT
					aCols[nPosAcols][_C6_VALOR] := NOROUND(aCols[nPosAcols][_C6_PRCVEN] * nGrvAcols,2)
                    // Chave para reposicionar o SZU
					aCols[nPosAcols][_C6_X_CHAVE]:=(cAlias)->(ZV_FILIAL+ZV_DOC+ZV_SERIE+ZV_FORNECE+ZV_LOJA+ZV_COD+ZV_ITEM)
					
					// Nao ha necessidade de continuar pois a quantidade
					// necessaria para atender a NF ja foi atendida.
					If  nQtdVen = 0
						Exit
					Endif
					
					(cAlias)->(DBSKIP())
					
				Enddo
				
				
				if  nQtdVen <>  0
					
					Aviso("ATENCAO", "Cancelada a Geracao do Pedido. "+;
					"Nao ha quantidade suficientes do produto "+cPRODUTO +;
					"para Geracao do Pedido.."+chr(13)+;
					"O Item "+strzero(nY,4)+" que contem o  Produto "+cPRODUTO+" somente possui disponivel"+;
					" para geracao do pedido a quantidade de "+  str(nQtdDisp) +" unidades."+;
					" Sendo que voce esta solicitado no mesmo Item  a quantidade de " + str(nQtdSol) +" unidades.",{"&Ok"})
					
					lContinua  := .F.
					
					Exit
					
				Endif
				
			Endif
			
		Endif
		
		// Nao deixa ir para o proximo item
		If !lContinua
			Exit
		Endif
		
	Next nY
	
	If lContinua .and. Empty(SC5->C5_MENNOTA)
		M->C5_MENNOTA := "NOTA ARMAZEM FECHADO"
	Endif
	
Endif


if !lContinua
	
	// Caso tenha ocorrido falha na operacao retorno o Acols Corrente.
	aCols := aClone(aColsBack)
	
Endif


If lQuery

	dbSelectArea(cAlias)
	dbCloseArea()

Endif

Return(lContinua)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma410Bar  ³ Autor ³ Eduardo Riera         ³ Data ³ 18.02.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do BROWDEV                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                     ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma410Bar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

If ( nOpc == 3 .Or. nOpc == 4 )
	aadd(aButtons,{"POSCLI",{|| If(M->C5_TIPO=="N".And.!Empty(M->C5_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},STR0022 }) 	//"Posi‡„o de Cliente"
EndIf
aadd(aButtons,{"BUDGET",{|| Ma410ForPg(nOpc)},STR0041 }) //"Formas de Pagamento"
aadd(aButtons,{"RELATORIO",{||Ma410Impos()},STR0043 })	//"Planilha Financeira"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para verificar se o usuario pode acessar a formacao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If ExistBlock("A410BPRC")
	If ExecBlock("A410BPRC",.F.,.F.)
		aadd(aButtons,{"AUTOM",{||Ma410Forma()},STR0056 })	//"Formacao de Precos"
	Endif
Else
	aadd(aButtons,{"AUTOM",{||Ma410Forma()},STR0056 })	//"Formacao de Precos"
Endif

If ( aRotina[ nOpc, 4 ] == 2 .Or. aRotina[ nOpc, 4 ] == 6 ) .And. !AtIsRotina("A410TRACK")
	AAdd(aButtons,{ "ORDEM", {|| A410Track() }, STR0050 } )  // "System Tracker"
EndIf


//If ExistBlock("A410CONS")
//	aButtonUsr := ExecBlock("A410CONS",.F.,.F.)
//	If ValType(aButtonUsr) == "A"
//		For nI   := 1  To  Len(aButtonUsr)
//			Aadd(aButtons,aClone(aButtonUsr[nI]))
//		Next nI
//	EndIf
//EndIf
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MA410ForPg³ Autor ³Henry Fila             ³ Data ³17.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Interface com o usuario das formas de pagamento             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Opcao do aRotina                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo controlar a interface com o   ³±±
±±³          ³usuario das formas de pagamento                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais/Distribuicao/Logistica                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ma410ForPg(nOpcX)

Local aArea     := GetArea()
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := MsAdvSize()
Local nOpcA     := 0
Local oDlg
Local oGetDad

PRIVATE N := 1
PRIVATE aHeader := aClone(aHeadFor)
PRIVATE aCols   := aClone(aColsFor)

AAdd( aObjects, { 100, 100, .t., .t. } )

aSize[ 3 ] -= 50
aSize[ 4 ] -= 50

aSize[ 5 ] -= 100
aSize[ 6 ] -= 100

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
aPosObj := MsObjSize( aInfo, aObjects )

dbSelectArea("SCV")
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0041) From aSize[7],00 to aSize[6],aSize[5] Of oMainWnd PIXEL
oGetDad := MsGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcX,"M410FmLok()","M410FmTOk()",,.T.,,,,99)
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(oGetDad:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()}) CENTERED
If nOpcA == 1
	aHeadFor := aClone(aHeader)
	aColsFor   := aClone(aCols)
EndIf
RestArea(aArea)
Return(.T.)
