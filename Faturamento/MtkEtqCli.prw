#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

#DEFINE X_LINHA1 					1
#DEFINE X_LINHA2   		   	2
#DEFINE X_LINHA3 					3
#DEFINE X_LINHA4 					4
#DEFINE X_LINHA5             5
#DEFINE X_LINHA6             6
#DEFINE X_LINHA7             7

#DEFINE X_CONTR7   				7 // NUMERO DE ETIQUETAS
#DEFINE X_CONTR8   				8
#DEFINE X_CONTR9   				9
#DEFINE X_CONTR10   			  10


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MtkEtqCli ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Geracao de Etiquetas para o Cliente                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MtkEtqCli()

Local  _lRet :=.T.

SetPrvt("CSTRING,AORD,CDESC1,CDESC2,CDESC3,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND")
SetPrvt("WCABEC0,WCABEC1,WCABEC2,CONTFL")
SetPrvt("LI,NTAMANHO,TITULO,WNREL,ADRIVER,ACODFOL")
SetPrvt("NCONT,NORDEM,CFILDE,CFILATE,CCCDE,CCCATE")
SetPrvt("CMATDE,CMATATE,CNOMEDE,CNOMEATE,CCHAPADE,CCHAPAATE")
SetPrvt("CSITUACAO,CCATEGORIA,DDATAREF,NTIPFOR,NTAMETIQ,NNUMLIN")
SetPrvt("NCOLUNAS,CINICIO,CFIM,CINDCOND,CFOR,CARQNTX")
SetPrvt("CHAVE,CFILIALANT,CCCANT,NFUNC,CLINHA1,CDESCEMP")
SetPrvt("CDESCEND,CDESCATIV,CDESCCGC,NTPINSC,WCCTO,WTURNO")
SetPrvt("X,CNORMAL_A,CNORMAL_D,CCOMPRI_A,CCOMPRI_D,CEXPAND_A")
SetPrvt("CESPAND_D,CSEXTO_A,CSEXTO_D,COITAVO_A,COITAVO_D,CEXPOEN_A")
SetPrvt("CEXPOEN_D,CINDICE_A,CINDICE_D,CDESCFUNC,LTESTE,NCOL")
SetPrvt("XW,VEZ,INI,MZ,CDESCCCTO,SOMA")
SetPrvt("CDESCTURN,")

Private _cPerg := ""
Private _aLin  := {}
Private nQtdEtq:= 0



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCodFol := {}
nCont   := 0

#IFNDEF  WINDOWS
	#Translate PSAY => SAY
#Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis  (Basicas)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := "SC5"
cDesc1  := "Emiss„o da Etiqueta dos Cliente"
cDesc2  := "Ser  impresso de acordo com os parametros solicitados pelo"
cDesc3  := "usuario."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
aArray – Array aReturn, preenchido pelo SetPrint
[1] Reservado para Formulário
[2] Reservado para Nº de Vias
[3] Destinatário
[4] Formato => 1-Comprimido 2-Normal
[5] Mídia => 1-Disco 2-Impressora
[6] Porta ou Arquivo 1-LPT1... 4-COM1...
[7] Expressão do Filtro
[8] Ordem a ser selecionada
[9]..[10]..[n] Campos a Processar (se houver)
cAlias – Alias do arquivo a ser impresso.
*/
aReturn  := { "Zebrado",1,"Administra‡„o",2,2,1,"",1 }


NomeProg := "MtkEtqCli"
nLastKey := 0
_cPerg   := "MTK_ET"+SPACE(4)
lEnd     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis (Programa)                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wCabec0  := 2
wCabec1  := ""
wCabec2  := ""
Contfl   := 1
Li       := 0
//nTamanho := "P"
nTamanho := 18
tamanho:="P"
limite:=80


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GravaSX1(_cPerg)

IF pergunte(_cPerg,.T.)
	
	//
	// Busca os Dados para montagem do array  _aLin
	//
	Processa({|| ImpDados(_aLin)},Titulo)
	
	
	If len(_aLin) = 0
		Aviso("ATENCAO", "Nenhum produto foi encontrado para o pedido ou pedido nao existe.",{"&Ok"})
		_lRet := .f.
	Endif
	
	
	If _lRet
		//
		// Seleciona a quantidade desejada com base no array _aLin
		//
		RptStatus({|| _lRet:=Selecao(_aLin) },Titulo)
		
	Endif
	
	
	If _lRet
		//
		// Inicia processo de Impressao com base no array _aLin
		//
		RptStatus({|| ImpEtiqu(_aLin)},Titulo)
		
	Endif
	
Endif


Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MtkEtqCli ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Busca os Dados a serem Impressos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDados(_aLin)
LOCAL _cQuery := ""
Local _nPos   := 0


dbSelectArea("SD2")
DbSetOrder(8) //D2_PEDIDO+D2_ITEMPV

dbSelectArea("SCJ")
DbSetOrder(1) //-> Num + Cli + Loja

dbSelectArea("SCK")
DbSetOrder(3) //-> Filial+Produto+Orcamento

DbSelectArea("SA1")
DbSetOrder(1)

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("SD2")
DbSetOrder(1)



#IFDEF TOP
	
	cQuery := ""
	cQuery := "SELECT COUNT(*)  TOT "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += "WHERE "
	cQuery += "SD2.D2_FILIAL  ='"+xFilial("SD2")+"' AND "
	cQuery += "SD2.D2_PEDIDO  >='"+mv_par01+"' AND "
	cQuery += "SD2.D2_PEDIDO  <='"+mv_par02+"' AND "
	cQuery += "SD2.D2_DOC     >='"+mv_par03+"' AND "
	cQuery += "SD2.D2_SERIE   >='"+mv_par04+"' AND "
	cQuery += "SD2.D2_DOC     <='"+mv_par05+"' AND "
	cQuery += "SD2.D2_SERIE   <='"+mv_par06+"' AND "
	cQuery += "SD2.D_E_L_E_T_=' ' "
	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
	ProcRegua(TMP->TOT)
	DbSelectArea("TMP")
	DbCloseArea()
	
	
	aStru     := SD2->(dbStruct())
	lQuery    := .T.
	cAlias := "SC5MA215PROC"
	
	cQuery := "SELECT * "
	cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
	cQuery += "WHERE "
	cQuery += "SD2.D2_FILIAL  ='"+xFilial("SD2")+"' AND "
	cQuery += "SD2.D2_PEDIDO  >='"+mv_par01+"' AND "
	cQuery += "SD2.D2_PEDIDO  <='"+mv_par02+"' AND "
	cQuery += "SD2.D2_DOC     >='"+mv_par03+"' AND "
	cQuery += "SD2.D2_SERIE   >='"+mv_par04+"' AND "
	cQuery += "SD2.D2_DOC     <='"+mv_par05+"' AND "
	cQuery += "SD2.D2_SERIE   <='"+mv_par06+"' AND "
	cQuery += "SD2.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA , D2_ITEM , D2_COD " // MESMA ORDEM UTILIZADA NA IMPRESSAO SD2 INDEX (3)
	//cQuery += "ORDER BY D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA , D2_COD , D2_ITEM " // MESMA ORDEM UTILIZADA NA IMPRESSAO SD2 INDEX (3)
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	For nX := 1 To Len(aStru)
		If ( aStru[nX][2] <> "C" )
			TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	
	
#ENDIF


While !(cAlias)->( Eof() )
	
	
	IncProc()
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cancela ImpresÆo ao se pressionar <ALT> + <A>                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	SA1->(DbSelectArea("SA1"),DbSetOrder(1),DbSeek(xFilial("SA1")+(cAlias)->D2_CLIENTE+(cAlias)->D2_LOJA))
	SC5->(DbSelectArea("SC5"),DbSetOrder(1),DbSeek(xFilial("SC5")+(cAlias)->D2_PEDIDO))
	SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+(cAlias)->D2_COD))
	SC6->(DbSelectArea("SC6"),DbSetOrder(1),DbSeek(xFilial("SC6")+(cAlias)->D2_PEDIDO+(cAlias)->D2_ITEMPV))


	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	
	nQtdEtq := (cAlias)->D2_QUANT
	
	//_aLin  := {"","","","",""}
	AADD(_aLin,{"","","","","","",nQtdEtq,nQtdEtq,(cAlias)->D2_COD,(cAlias)->D2_DOC})
	_nPos := Len(_aLin)
	
	
	// Transform(cDescCgc,"@R ##.###.###/####-##")
	//-> Linha 001 - Nome Reduzido do Cliente e CGC do Cliente (A1_NREDUZ e A1_CGC)
	If Empty(AllTrim(SA1->A1_NREDUZ)) .And. Empty(SA1->A1_CGC)
		_aLin[_nPos][X_LINHA1] := "Sem Fantasia e sem CGC "
	Else
		If Empty(AllTrim(SA1->A1_NREDUZ))
			_aLin[_nPos][X_LINHA1] := "Sem Fantasia - "+Transform(SA1->A1_CGC,"@R ##.###.###/####-##")
		Else
			_aLin[_nPos][X_LINHA1] := AllTrim(SA1->A1_NREDUZ)+": "+Transform(SA1->A1_CGC,"@R ##.###.###/####-##")
		EndIf
	EndIf
	
	_cCodCGC := SM0->M0_CGC           
     
	_aLin[_nPos][X_LINHA2] := Alltrim(SM0->M0_NOME)+": "+Transform(_cCodCGC,"@R ##.###.###/####-##")
	
	
	//-> Linha 004 - "Descr.: " + Referencia + Sufixo (B1_X_REFER e B1_X_SUFIX)
	_aLin[_nPos][X_LINHA4] := "Descr....: " + AllTrim(SB1->B1_X_REFER)+" "+AllTrim(SB1->B1_X_SUFIX)+"-"+Alltrim(SB1->B1_X_MARCA)
	
	
	//-> Parte-se do Principio que todo Pedido eh um espelho do Orcamento...
	dbSelectArea("SCJ")
	DbSeek(xFilial("SCJ") + SC5->C5_X_NUM + SC5->C5_CLIENTE + SC5->C5_LOJACLI)
	If Found()
		
		//-> Linha 003 - "Material: " + Código do Cliente + " / " + Sku da Mtk (CK_X_PRCLI e B1_COD)
		_aLin[_nPos][X_LINHA3] := "Prod: "+Substr(AllTrim(SC6->C6_X_PRCLI),1,16)+"  Sku: "+AllTrim(SB1->B1_COD)
		//-> Linha 005 - "Pedido: " + Nro.Ped.Cliente + " N.F. " + Nro. da Nota Fiscal (CJ_COTCLI e F2_DOC) se tiver havido o faturamento.
		If Empty(AllTrim(SC5->C5_X_COTCL))
			_aLin[_nPos][X_LINHA5] := "Ped.: - x - "
		Else
			_aLin[_nPos][X_LINHA5] := "Ped.: " + AllTrim(SC5->C5_X_COTCL)
		EndIf
		
	Else
		
		//-> Linha 003 - "Material: " + Código do Cliente + " / " + Sku da Mtk (CK_X_PRCLI e B1_COD)
		_aLin[_nPos][X_LINHA3] := "Prod: "+Substr(AllTrim(SC6->C6_X_PRCLI),1,16)+" Sku : "+AllTrim(SB1->B1_COD)
		//-> Linha 003 - "Material: " + Código do Cliente + " / " + Sku da Mtk (CK_X_PRCLI e B1_COD)
		//_aLin[3] := "Material: - x -  Sku : "+AllTrim(SB1->B1_COD)
		//-> Linha 005 - "Pedido: " + Nro.Ped.Cliente + " N.F. " + Nro. da Nota Fiscal (CJ_COTCLI e F2_DOC) se tiver havido o faturamento.
		_aLin[_nPos][X_LINHA5] := "Ped.Inter: " + AllTrim((cAlias)->D2_PEDIDO)
		//_aLin[5] := "Ped.: - x - "
		
	EndIf
	
	
	// RESERVA+ITEM
	_aLin[_nPos][X_LINHA6] := "Reserva: "+SC6->C6_X_RESERV+" Item :"+SC6->C6_X_ITEMO
	
	_aLin[_nPos][X_CONTR7] := nQtdEtq
	_aLin[_nPos][X_CONTR8] := nQtdEtq
		
	(cAlias)->( dbSkip() )     
		
Enddo

DbSelectArea(cAlias)
DbCloseArea()

Return





/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpEtiqu  ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Efetua a Impressao das Etiquetas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpEtiqu(_aLin)
Local _nPos   := 0
Local _nJ     := 0
Local _nX     := 0

Titulo := "EMISSO ETIQUETA DO CLIENTE"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="ImpEtiqu"

aOrdem := {}

//wnrel:=SetPrint(cString,wnrel,_cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.)
//     SetPrint(cAlias,cNomRel,cPerg,cDesc1,cDesc2,cDesc3,cDesc4, lDic,aOrdem, lComp, cClass)
wnrel:=SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.f.,  aOrdem,.f.,tamanho,"",.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//
// Efetua a Impressao das Etiquetas
//
@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "

@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "

@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "
@ Prow()+1, 1 PSAY " "

For _nPos := 1 to len(_aLin)
	
	For _nJ:=1 To _aLin[_nPos][X_CONTR7]
		
		//SetPrc(0,0)
		
		For _nX := 1 To 6
			
			@ Prow(), 2 PSAY _aLin[_nPos][_nX]
			//@ LI, 2 PSAY _aLin[X]
			
			@ Prow()+1, 1 PSAY " "
			//LI := LI + 1
			
		Next _nX
		
		@ Prow()+1, 1 PSAY " "
		@ Prow()+1, 1 PSAY " "
		@ Prow()+1, 1 PSAY " "
		
	Next _nJ
	
Next _nPos



//
// Gera Uma Etiqueta Em Branco
//
_aLin  := {Space(10),Space(10),Space(10),Space(10),Space(10)}

For X := 1 To Len(_aLin)
	
	//@ LI, 3 PSAY _aLin[X]
	@ Prow(), 3 PSAY _aLin[X]
	
	@ Prow()+1, 2 PSAY " "
	//LI := LI + 1
	
Next X


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	DbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return









*-------------------------
Static Function GravaSX1(_cPerg)
Local _aPerg := {}
Local _nI := 0
Local _nJ := 0

aadd(_aPerg,{_cPerg,"01","Pedido Inicial: ","","","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","",""      ,"","","","","","","","","","","","","","","","","","","","","CBL",""})
aadd(_aPerg,{_cPerg,"02","Pedido Final:   ","","","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CBL",""})
aadd(_aPerg,{_cPerg,"03","Nota Inicial:   ","","","mv_ch3","C",09,0,0,"G","","MV_PAR03","","","",""      ,"","","","","","","","","","","","","","","","","","","","","CBL",""})
aadd(_aPerg,{_cPerg,"04","Serie Inicial:  ","","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","CBL",""})
aadd(_aPerg,{_cPerg,"05","Nota Final:     ","","","mv_ch5","C",09,0,0,"G","","MV_PAR05","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","CBL",""})
aadd(_aPerg,{_cPerg,"06","Serie Final:    ","","","mv_ch6","C",03,0,0,"G","","MV_PAR06","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","CBL",""})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao exista a Pergunta a mesma sera criada.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX1")
dbSetOrder(1)
For _nI := 1 To Len(_aPerg)
	If !dbSeek(_cPerg+_aPerg[_nI,2])
		RecLock("SX1",.T.)
		For _nJ := 1 To Len(_aPerg[_nI])
			FieldPut(_nJ,_aPerg[_nI,_nJ])
		Next _nJ
		SX1->( MsUnlock() )
	Endif
Next _nI

Return





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Selecao  º Autor ³                    º Data ³  31/07/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Define a quantidade de Etiquetas a serem emitidas          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorna   ³ Matriz com as Formas de Pagamento                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Selecao(_aLin)
Local lRet           := .T.
Local aGetArea        := GetArea()
Local aParam          := {}
Local nOpcA           := 0
Local aSizeAut		  := MsAdvSize(,.F.)
Local aObjects		  := {}
Local aInfo 		  := {}
Local aPosGet		  := {}
Local aPosObj		  := {}
Local nY           := 0

Private aHeader   := {}
Private aCols     := {}
Private nopc      := 3
//Private aRotina   := {{,,0,4}}
PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private oDlg,oGet

Private _nImpEti:=0
Private _nVTotal:=0
Private _cProdut:=0
Private _nLinha1:=0
Private _nLinha2:=0
Private _nLinha3:=0
Private _nLinha4:=0
Private _nLinha5:=0
Private _nLinha6:=0
Private _nLinha7:=0

Private cCadastro := "Define Quantidade a serem Impressas"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens no Cabecalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("B1_X_REFER")

//AADD(aHeader,{"Produto",X3_CAMPO,X3_PICTURE,X3_TAMANHO+16+4,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

AADD(aHeader,{"Qtde a Imprimir" ,"ImpEti"   ,"@E 999.999",10,2,"U_VALNQETI(.T.)","","N",,})
AADD(aHeader,{"Total Etiquetas" ,"VTotal"   ,"@E 999.999",10,2,"","","N",,})
AADD(aHeader,{"Documento"       ,"Docume"   ,"@!"        ,30,0,"","","C",,})
AADD(aHeader,{"Produto"         ,"Produt"   ,"@!"        ,30,0,"","","C",,})
AADD(aHeader,{"Linha 1"         ,"Linha1"   ,"@!"        ,30,0,"","","C",,})
AADD(aHeader,{"Linha 2"         ,"Linha2"   ,"@!",30,0,"","","C",,})
AADD(aHeader,{"Linha 3"         ,"Linha3"   ,"@!",30,0,"","","C",,})
AADD(aHeader,{"Linha 4"         ,"Linha4"   ,"@!",30,0,"","","C",,})
AADD(aHeader,{"Linha 5"         ,"Linha5"   ,"@!",30,0,"","","C",,})
AADD(aHeader,{"Linha 6"         ,"Linha6"   ,"@!",30,0,"","","C",,})


_nImpEti   := aScan(aHeader,{|x| AllTrim(x[2])=="ImpEti"})
_nVTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="VTotal"})
_nDoc      := aScan(aHeader,{|x| AllTrim(x[2])=="Docume"})
_nProdut   := aScan(aHeader,{|x| AllTrim(x[2])=="Produt"})
_nLinha1   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha1"})
_nLinha2   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha2"})
_nLinha3   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha3"})
_nLinha4   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha4"})
_nLinha5   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha5"})
_nLinha6   := aScan(aHeader,{|x| AllTrim(x[2])=="Linha6"})


MontAcols(_aLin,aCols)

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("B1_X_REFER")


AAdd( aObjects, { 0,    100, .T., .T. } )
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
//aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,30,  65,90,120  ,140,155  ,255,280},;
//                                                       {05,30,  80,105,  155,180,  235,265}})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL
                                      
oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"U_VALNQETI()","U_VALNQETI()",,.F.,{"ImpEti"},2)
oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:nMax:=Len(Acols)


ACTIVATE MSDIALOG oDlg ON INIT PAR_BAR(oDlg,{|| nOpcA := 1, oDlg:End()},{||oDlg:End()})


if nOpca = 1
	
	For nY:=1 to Len(acols)
		
		_aLin[nY][07] :=  aCols[nY,_nImpEti]
		
	Next
	
	lRet           := .T.
	
Else
	
	lRet           := .F.
	
Endif

RETURN(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontAcolsº Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a Inclusao de informacoes no Acols                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontAcols(_aLin,aCols)

Local nLin   := 0
Local nY     := 0

aCols := {}

//_aLin := aSort(_aLin,,,{|x,y| x[X_CONTR10]+x[X_CONTR9] <  y[X_CONTR10]+y[X_CONTR9] })

For nY = 1 to Len(_aLin)
	
	 AADD(aCols,Array(Len(aHeader)+1))
	 nLin                        := Len(aCols)
	 aCols[nLin,Len(aHeader)+1] := .F.                    // Nao Deletado
	
	 aCols[nLin,_nImpEti]               := _aLin[nY][X_CONTR8]  // Quantidade a ser Escolhida
	 aCols[nLin,_nVTotal]               := _aLin[nY][X_CONTR7]  // Quantidade Original
	 aCols[nLin,_nDoc]                  := _aLin[nY][X_CONTR10] // Numero do Documento
	 aCols[nLin,_nProdut]               := _aLin[nY][X_CONTR9]  // Produto
	 aCols[nLin,_nLinha1]               := _aLin[nY][X_LINHA1]
	 aCols[nLin,_nLinha2]               := _aLin[nY][X_LINHA2]
	 aCols[nLin,_nLinha3]               := _aLin[nY][X_LINHA3]
	 aCols[nLin,_nLinha4]               := _aLin[nY][X_LINHA4]
	 aCols[nLin,_nLinha5]               := _aLin[nY][X_LINHA5]
	 aCols[nLin,_nLinha6]               := _aLin[nY][X_LINHA6]
	
Next nY


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ U_VALNQETIº Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o Conteudo do Parametro Digitado                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VALNQETI(lValid)
Local  lRet := .T.
Local  _nVal_Atu := ""
Local  _nVal_Par := ""
Local  _nVal_Pro := ""
Local  _nVal_Con := ""
Local  _nVal_Des := ""
Local  _cConteudo:= 0
Local  nX        := 0

DEFAULT lValid   := .F.


_nVal_ImpEti :=IIF(lValid .AND. TYPE("M->ImpEti")     <>"U",&("M->ImpEti")   ,aCols[n][_nImpEti] )
_nVal_VTotal :=IIF(lValid .AND. TYPE("M->VTotal")     <>"U",&("M->VTotal")   ,aCols[n][_nVTotal] )

If _nVal_ImpEti > _nVal_VTotal
	Aviso("ATENCAO", "A quantidade a ser impressa nao pode ser maior que a quantidade Inicial.",{"&Ok"})
	lRet := .f.
Endif

if _nVal_ImpEti < 0
	Aviso("ATENCAO", "A quantidade a ser impressa nao pode ser menor que Zero.",{"&Ok"})
	lRet := .f.
Endif

Return(lRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PAR_BAR   ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifico                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PAR_BAR(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

//AADD(aButtons, {"S4WB011N"      , {||U_MFATC03(ACOLS[N][_xProduto])}, "<F4> - Consulta Estoque da Malha Logistica" })
//AADD(aButtons, {"CARGA"      	, {||U_MFATC06()}	, "Busca Itens do Contrato"})
//AADD(aButtons, {"PRODUTO"    	, {||U_MFATC02()}	, "Substitui Item do Contrato"})
//AADD(aButtons, {"VENDEDOR"    	, {||U_MFATC07(cCliente)}	, "Seleciona Clientes p/ Geracao do Pedido"})

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))
