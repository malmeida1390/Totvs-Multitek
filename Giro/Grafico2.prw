#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
#INCLUDE "MSGRAPHIC.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Grafico2 ³ Autor ³                    º Data ³  04/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grafico Entradas x Saidas x Saldos                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis)
Local oDlg
Local cPerg         := "FTC164" + SPACE(4)
Local aCorSer    	:= { 	CLR_HBLUE, CLR_HRED, CLR_HGREEN, CLR_YELLOW, CLR_BLACK,;
CLR_WHITE, CLR_GRAY, CLR_HCYAN, CLR_HMAGENTA }, nCorSer := 1

Local nOpcA         := 0
Local aSizeAut		:= MsAdvSize(,.F.)
Local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}
Local aTipo         := {  "Entradas",;
"Saidas",;
"Saldo",;
"Entradas x Saidas",;
"Saldo x Entradas ",;
"Saldo x Saidas",;
"Sld x Entradas x Saidas"}
Local cTipo       := ""
Local aVisual     := {  "Mensal",;
"Diario"}
Local cVisual     := ""
Local aCbx 		   := {  "Linha","Area","Pontos","Barras","Piramide","Cilindro",;
"Barras Horizontal","Piramide Horizontal","Cilindro Horizontal",;
"Pizza","Forma","Linha rapida","Flexas","GANTT","Bolha" }

Local cTipCons 	 := ""
Local aTipCons     := {  "Consulta p/ Produto","Consulta p/ Eis"  }


Local nSer, nQtdSer

Local cTitulo       := "Grafico Estoque - Saldo x Saidas x Entradas"
Local NposX         := 0
Local NposY         := 0

Local nTipCons      := 1    // 1 - Consulta por Sku  e 2 - Consulta por Eis
Local cProduto      := criavar("B1_COD")
Local c_Simil       := criavar("B1_X_SIMIL")
Local c_Eis         := space(20)
Local dDtIni        := ctod("")
Local dDtFim        := GETMV("MV_ULMES")

Private n_Eis       := 1
Private nSerie1     := 0
Private nSerie2     := 0
Private nSerie3     := 0

Private oFont := TFont():New("Arial",,12,.f.,.T.,5,.f.,5,.f.,.F.)

Private oGraphic,oSer,oVisual,oTipo,oDtIni,oDtFim,oProduto,oTipCons,oSimil,o_Eis
Private oBTn1,oBTn2,oBTn3,oBTn4,oBTn5,oBTn6

Private nExcl := 0


DEFAULT nCbx        := 1
DEFAULT nTipo       := 7
DEFAULT nVisual     := 2   //-> Estava 1
DEFAULT aNseries    := {.T.,.T.,.T.}
DEFAULT aParametro  := {nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim}
DEFAULT aSerieM     :={}
DEFAULT aSerieD     :={}
DEFAULT a_Eis       :={}

nTipCons            := aParametro[1]
cProduto            := aParametro[2]      // Variaveis do Padrao
c_Simil             := aParametro[3]
n_Eis               := aParametro[4]
dDtIni              := aParametro[5]
dDtFim              := aParametro[6]

cCbx 		        := aCbx[nCbx]         // Tipo de Grafico
cTipCons            := aTipCons[nTipCons] // Eis ou Produto
cTipo               := aTipo[nTipo]       // numero de Series
cVisual             := aVisual[nVisual]   // Mensal ou Anual
lSer1_Sld           := aNseries[1]        // Series a serem mostradas
lSer2_Ent           := aNseries[2]
lSer3_Sai           := aNseries[3]


If n_Eis = 0
   n_Eis            := 1
Endif

If Len(a_Eis) > 0
   c_Eis            := a_Eis[n_Eis]
Endif



DbSelectArea("SB1")
DbSeek(xFilial("SB1")+cProduto)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 TO 500,900 OF oMainWnd PIXEL


@ 020, 095 MSGRAPHIC oGraphic SIZE 340, 158 OF oDlg PIXEL

if  Len(aSerieM) <> 0
	// Abastece o Grafico com o vetor Gerado
	Processa({|| AbastGraf(aSerieM,aSerieD,cVisual,aNseries[1],aNseries[2],aNseries[3],nCbx,nTipCons)},OemToAnsi("Gráfico"),OemToAnsi("Gerando Grafico..."))

Endif

oGraphic:SetMargins( 2, 9, 9, 9 )
// Habilita a legenda, apenas se houver mais de uma serie de dados.
oGraphic:SetLegenProp( GRP_SCRTOP, CLR_GREEN, GRP_SERIES, .T.)
oGraphic:SetGradient( GDBOTTOMTOP, CLR_HGRAY, CLR_WHITE )    
If nTipCons = 1
  oGraphic:SetTitle( "Grafico de Movimentacoes do Produto " ,"Produto :  "+SB1->B1_DESC, CLR_HRED , A_LEFTJUST , GRP_TITLE )
Else
  oGraphic:SetTitle( "Grafico de Movimentacoes do Eis    " , "Eis  :  "   +c_Eis       , CLR_HRED , A_LEFTJUST , GRP_TITLE )
Endif  
//oGraphic:SetTitle( "(Azul) Saldo / (Verde) Entradas / (Vermelho) Saidas","", CLR_HRED, A_LEFTJUST , GRP_FOOT  )
oGraphic:lShowHint:=.f.            // Desabilita Hint   ????
// Habilita Rotacao do Grafico
oGraphic:l3D := !oGraphic:l3D
// Habilita Consulta dos dados do Grafico
oGraphic:bRClicked := {|o,x,y| oMenu:Activate(x,y,oGraphic) } // Posição x,y em relação a Dialog
MENU oMenu POPUP
MENUITEM "Consulta dados do grafico" Action BrowseVetor(aSerieM,aSerieD,cVisual)
ENDMENU


//
//  Parametros
//
@ 018,014  TO  185,90 LABEL 'Parametros' OF oDlg  PIXEL


@ 030, 016 	SAY "Tipo de Consulta" OF oDlg FONT oBold PIXEL
@ 042, 016 	MSCOMBOBOX oTipCons VAR cTipCons ITEMS aTipCons SIZE 70, 80 OF oDlg;
PIXEL ON CHANGE	(nTipCons := oTipCons:nAt,;
aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim},;
oDlg:End(),;
U_Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis))


If nTipCons = 1
	
	@ 055, 016 	SAY "Produto" OF oDlg  FONT oBold PIXEL
	@ 067, 016 	MSGET oProduto VAR cProduto F3 "SB1" SIZE 070, 10 OF oDlg;
	PIXEL VALID (ValProd(cProduto))
	
	@ 105, 016 	SAY "Periodo de" OF oDlg FONT oBold PIXEL
	@ 117, 016 	MSGET oDtIni VAR dDtIni SIZE 070, 10 OF oDlg;
	PIXEL
	
	@ 130, 016 	SAY "Ate" OF oDlg FONT oBold PIXEL
	@ 142, 016 	MSGET oDtFim VAR dDtFim SIZE 070, 10 OF oDlg WHEN .F.;
	PIXEL VALID (ValData(dDtIni,dDtFim))
	
//	@ 167, 028	BUTTON "Confirma" SIZE 40,14 OF oDlg;
//	PIXEL ACTION (IIf(ValProd(cProduto) .and. ValData(dDtIni,dDtFim),;
//    (aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim},;
//	ProcGra(@aSerieM,@aSerieD,aParametro,cTipo,aTipo,cVisual,aVisual,nCbx,nTipCons,aCbx,cProduto,dDtIni,dDtFim,nTipo,c_Simil,c_Eis,@a_Eis,n_Eis,oSimil,o_Eis,.T.,nVisual,aNseries),;
//	oDlg:End(),;
//	),))
	
Else
	
	
	@ 055, 016 	SAY "Simil" OF oDlg FONT oBold PIXEL
	@ 067, 016 	MSGET oSimil VAR c_Simil   F3 "SZ2" SIZE 070, 10 OF oDlg;
	PIXEL VALID (U_VLDSIMIL(c_Simil,@a_Eis,o_Eis,@n_Eis,@c_Eis))
	
	@ 080, 016 	SAY "Eis" OF oDlg FONT oBold PIXEL
	@ 092, 016 	MSCOMBOBOX o_Eis VAR c_Eis ITEMS a_Eis SIZE 70, 80 OF oDlg;
	PIXEL ON CHANGE	(n_Eis := o_Eis:nAt)
	
	@ 105, 016 	SAY "Periodo de" OF oDlg FONT oBold PIXEL
	@ 117, 016 	MSGET oDtIni VAR dDtIni SIZE 070, 10 OF oDlg;
	PIXEL
	
	@ 130, 016 	SAY "Ate" OF oDlg FONT oBold PIXEL
	@ 142, 016 	MSGET oDtFim VAR dDtFim SIZE 070, 10 OF oDlg WHEN .F.;
	PIXEL ;//ON CHANGE	(oDlg:End(),U_Grafico2(nCbx,nTipo,nVisual,aNseries))
	VALID (ValData(dDtIni,dDtFim))
	
//	@ 167, 028	BUTTON "Confirma" SIZE 40,14 OF oDlg;
//	PIXEL ACTION (IIf(ValData(dDtIni,dDtFim),;
//    (aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim},;
//	ProcGra(@aSerieM,@aSerieD,aParametro,cTipo,aTipo,cVisual,aVisual,nCbx,nTipCons,aCbx,cProduto,dDtIni,dDtFim,nTipo,c_Simil,c_Eis,@a_Eis,n_Eis,oSimil,o_Eis,.T.,nVisual,aNseries),;
//	oDlg:End(),;
//	),))
	
	
Endif


@ 167, 028	BUTTON "Confirma" SIZE 40,14 OF oDlg;
PIXEL ACTION (IIf(ValData(dDtIni,dDtFim),;
(aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim},;
ProcGra(@aSerieM,@aSerieD,aParametro,cTipo,aTipo,cVisual,aVisual,nCbx,nTipCons,aCbx,cProduto,dDtIni,dDtFim,nTipo,c_Simil,c_Eis,@a_Eis,n_Eis,oSimil,o_Eis,.T.,nVisual,aNseries),;
oDlg:End();
),))


  


NposX:=15
NposY:=80

//
//  Legenda
//
@ 175+NposX, 014 TO  230+NPOSX,90 LABEL 'Legenda' OF oDlg  PIXEL
if lSer1_Sld
	@ 192+NPOSX, 040 	SAY "Saldo    "   OF oDlg FONT oBold COLOR RGB(055,153,200) PIXEL
Endif
if lSer2_Ent
	@ 203+NPOSX, 040 	SAY "Entradas "   OF oDlg FONT oBold COLOR RGB(162,164,91)  PIXEL
Endif
If lSer3_Sai
	@ 214+NPOSX, 040 	SAY "Saidas   "   OF oDlg FONT oBold COLOR RGB(255,0,0)     PIXEL
Endif


//
//  Visualizacao
//
@ 175+NposX, 014+NposY  TO  230+NPOSX,435 LABEL 'Visualizacao' OF oDlg  PIXEL

@ 180+NPOSX, 016+NposY 	SAY "Series" OF oDlg FONT oBold PIXEL
@ 192+NPOSX, 016+NposY 	MSCOMBOBOX oTipo VAR cTipo ITEMS aTipo SIZE 077, 120 OF oDlg;
PIXEL ON CHANGE	(nTipo := oTipo:nAt,;
aNseries:=DefinTipo(nTipo),;
oDlg:End(),U_Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis))


@ 180+NPOSX, 095+NposY 	SAY "Tipo de grafico" OF oDlg FONT oBold PIXEL //"Tipo de grafico"
@ 192+NPOSX, 095+NposY 	MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 077, 120 OF oDlg;
PIXEL ON CHANGE	(nCbx := oSer:nAt,;
oDlg:End(),U_Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis))


@ 205+NPOSX, 016+NposY 	SAY "Visualizacao" OF oDlg FONT oBold PIXEL
@ 215+NPOSX, 016+NposY 	MSCOMBOBOX oVisual VAR cVisual ITEMS aVisual SIZE 077, 120 OF oDlg;
PIXEL ON CHANGE	(nVisual := oVisual:nAt,;
oDlg:End(),U_Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis))
//aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim},;
//ProcGra(@aSerieM,@aSerieD,aParametro,cTipo,aTipo,cVisual,aVisual,nCbx,nTipCons,aCbx,cProduto,dDtIni,dDtFim,nTipo,c_Simil,c_Eis,@a_Eis,n_Eis,oSimil,o_Eis,.F.),;


@ 190+NPOSX, 174+NposY 	BUTTON oBTn1 PROMPT "Rotacao &-" SIZE 40,14 OF oDlg PIXEL ACTION AltGrafico(oGraphic, "ROTACAO-", nSerie1) //"Rotacao &-"
@ 190+NPOSX, 216+NposY 	BUTTON oBTn2 PROMPT "Rotacao &+" SIZE 40,14 OF oDlg PIXEL ACTION AltGrafico(oGraphic, "ROTACAO+", nSerie1) //"Rotacao &+"
@ 190+NPOSX, 258+NposY 	BUTTON o3D   PROMPT "3D" SIZE 40,14 OF oDlg PIXEL ACTION AltGrafico(oGraphic, "EFEITO", o3D)
@ 190+NPOSX, 301+NposY 	BUTTON oBTn3 PROMPT "&Salva BMP" SIZE 40,14 OF oDlg PIXEL ACTION GrafSavBmp( oGraphic ) //"&Salva BMP"


@ 213+NPOSX, 216+NposY 	BUTTON oBTn4 PROMPT "&Imprimir"  SIZE 40,12 OF oDlg PIXEL ACTION CtbGrafPrint(oGraphic,"Movimentacoes do Estoque",{cTitulo},, .F.,,;
{ 260, 	((oGraphic:nRight - oGraphic:nLeft) * 3) + 525,((oGraphic:nBottom - oGraphic:nTop) * 3) + 425 }) 
//{0, 0900, 1500 , 2100 })
//@ 213+NPOSX, 216+NposY 	BUTTON oBTn4 PROMPT "&Imprimir"  SIZE 40,12 OF oDlg PIXEL ACTION CtbGrafPrint(oGraphic,"Movimentacoes do Estoque",{cTitulo},,,,;


@ 213+NPOSX, 258+NposY 	BUTTON oBTn5 PROMPT "&E-mail"    SIZE 40,12 OF oDlg PIXEL ACTION U_PmsGrafMail(oGraphic,cTitulo,{cTitulo },,,) //"&E-mail"
@ 213+NPOSX, 301+NposY 	BUTTON oBTn6 PROMPT "&Sair"      SIZE 40,12 OF oDlg PIXEL ACTION oDlg:End() //"&Sair"


ACTIVATE MSDIALOG oDlg ON INIT ENCHO_BAR(oDlg,{|| nOpcA := 1, oDlg:End()},{||oDlg:End()}) CENTER


Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProcGra  ³ Autor ³                       ³ Data ³ 04.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Geracao dos Vetores aSerieM,aSerieD                        ³±±
±±³          ³ Abastecimento do Grafico                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcGra(aSerieM,aSerieD,aParametro,cTipo,aTipo,cVisual,aVisual,nCbx,nTipCons,aCbx,;
cProduto,dDtIni,dDtFim,nTipo,c_Simil,c_Eis,a_Eis,n_Eis,oSimil,o_Eis,lRefaz,nVisual,aNseries)

//-> 28/11/05
If EmptY(dDtIni)
	Aviso("ATENCAO", "Favor informar a data Inicial...",{"&Ok"})
	SetFocus(oDtIni:hWnd)
	Return .f.
Elseif EmptY(dDtFim)
	Aviso("ATENCAO", "Favor informar a data Final....",{"&Ok"})
	SetFocus(oDtFim:hWnd)
	Return .f.
Endif
                                   
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Analisa a necessidade de estar refazendo os calculos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRefaz

	if  nTipCons != aParametro[1] .or.;
		cProduto != aParametro[2] .or.;
		c_Simil  != aParametro[3] .or.;
		dDtIni   != aParametro[5] .or.;
		c_Eis    != a_Eis[aParametro[4]] .or.;
		dDtFim   != aParametro[6] 
		
		lRefaz  := .T.
	Endif
	
Endif


//if  lRefaz
	
	aNseries:=DefinTipo(nTipo)
	//aNseries[1] - usa Serie 1 - Saldo
	//aNseries[2] - usa Serie 2 - Entradas
	//aNseries[3] - usa Serie 3 - Saidas
	
	Processa({|| GVetor(nTipCons,cProduto,c_Simil,c_Eis,dDtIni,dDtFim,@aSerieM,@aSerieD,oSimil,o_Eis)},OemToAnsi("Gráfico"),OemToAnsi("Processando Informacoes..."))

//Endif


	
If len(aSerieM) = 0
	
	Aviso("ATENCAO", "Nao existem informacoes para o periodo definido",{"&Ok"})
	//ElseIf len(aSerieM) != 12 .and. len(aSerieM) != 360
	//	Aviso("ATENCAO", "Tamanho do Vetor retornado da funcao gera GVetor() esta Icorreto...",{"&Ok"})
	
Else
	
	// Abastece o Grafico com o vetor Gerado
	Processa({|| AbastGraf(aSerieM,aSerieD,cVisual,aNseries[1],aNseries[2],aNseries[3],nCbx,nTipCons)},OemToAnsi("Gráfico"),OemToAnsi("Gerando Grafico..."))
	aParametro:={nTipCons,cProduto,c_Simil,n_Eis,dDtIni,dDtFim}
	U_Grafico2(nCbx,nTipo,nVisual,aNseries,aParametro,aSerieM,aSerieD,a_Eis)
	
	
Endif
  

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GVetor   ³ Autor ³                       ³ Data ³ 04.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processa o conteudo da matriz a serie p/ o Grafico         ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GVetor(nTipCons,cProduto,c_Simil,c_Eis,dDtIni,dDtFim,aSerieM,aSerieD,oSimil,o_Eis)
Local _aSerieD   := {}
Local _aSerieM   := {}
Local _nSldOntem := 0
Local _nSld      := 0
Local _aTmp      := {}
Local _nI        := 0
Local dNovDat     := dDtIni
Local c_EisProd   := ""
Local _cAlmoxPGMM := ""



// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³1 Desabilita Botoes                                                               ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  oGraphic # Nil
	oGraphic:Disable()
	oSer:Disable()
	oVisual:Disable()
	oTipo:Disable()
	oDtIni:Disable()
	oDtFim:Disable()
	
	//oProduto:Disable()
	//oSimil:Disable()
	//o_Eis:Disable()
	
	oBTn1:Disable()
	oBTn2:Disable()
	oBTn3:Disable()
	oBTn4:Disable()
	oBTn5:Disable()
	oBTn6:Disable()
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³2 Efetua a montagem do Vetor com utilizando database                              ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// O vetor abaixo tera o saldo da data inicial ate a data base (em funcao do saldo ser 
// retroativo)
// aSerieD  (Vetor retornado deve conter sempre 4 posicoes na seguinte ordem
//          aSerieM[1][1] Saldo
//          aSerieM[1][2] Entrada
//          aSerieM[1][3] Saidas
//          aSerieM[1][4] Data (Todas as tadas que inglobam o Periodo)
// aSerieM  (Vetor retornado deve conter sempre 4 posicoes na seguinte ordem
//          aSerieM[1][1] Saldo  (Acumulado do  Saldo no Mes)
//          aSerieM[1][2] Entrada(Acumulado das Entradas)
//          aSerieM[1][3] Saidas (Acumulado das Saidas)
//          aSerieM[1][4] Data   (Somente Ultimo dia do Mes)

aSerieM:={}
aSerieD:={}
dNovDat  := dDtIni
While  dNovDat != dDataBase     //dDtFim
	dNovDat := dNovDat + 1
	aadd(aSerieD,{0,0,0, dNovDat })
	nPos := aScan(aSerieM,{|x| x[4] == LastDay( dNovDat ) })
	if nPos = 0
		aadd(aSerieM,{0,0,0,LastDay( dNovDat )})
	Endif
Enddo

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³3 Com base no Vetor inicia o Analise do Giro                                      ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//---------------------------------------------------------------
//
//   Algoritmo para Calculo do Giro de Estoque de uma SKU
//
//   Recebe os seguintes Parametros
//
//   Codigo [Char 15]      -> Codigo SKU (B1_COD) ou Codigo EIS
//   Ident [Pertence(S/E)] -> S indica SKU,   E indica EIS
//   DataIni [Date]        -> Data Inicial do Movimento
//   DataFim [Date]        -> Data Final do Movimento
//   lRegua [.t./.f.]      -> .t. para processamento com regua e .f. para sem regua
//   nSaldoIni             -> Saldo da Malha deste item
//
//   Retorna Valor do Giro ou -1 em caso de erro
//
//---------------------------------------------------------------
if nTipCons = 1
	
	//_fGiro(_cCodigo, _cIdent, _dDataIni, _dDataFim, lRegua, aSerieM,aSerieD,_lRetVetorG,aSimil,aSku)
	//Como data fim esta sendo utilizada a DataBase para que se possa compor o saldo de dDataFim
	U__fGiro( cProduto , "S" , dDtIni , dDataBase , .T. ,aSerieM,aSerieD)
	//-> Tratamento para recalculo dos Saldos nos vetores aSerieM e aSerieD
	//-> 17/11/04 - Marcelo Vicente
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o Saldo em estoque do produto na database para efetuar o retroativo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-> Para efeito de testes...
	//-> Se mudar o criterio, nao esquecer de alterar em Giro.prw tambem
	_cAlmoxPGMM  := GetMV("MV_ALMFECH")
	
	_nSld := 0
	//_aTmp := U_SaldoSb2(cProduto,_cAlmoxPGMM)
	_aTmp := U_SaldoSb2(cProduto)
	_nSldOntem := _aTmp[01,10]
	
Else
	//_fGiro(_cCodigo, _cIdent, _dDataIni, _dDataFim, lRegua, aSerieM,aSerieD,_lRetVetorG,aSimil,aSku)
	//Como data fim esta sendo utilizada a DataBase para que se possa compor o saldo de dDataFim
	U__fGiro( alltrim(c_Eis)+c_Simil , "E" , dDtIni ,  dDataBase   , .T. ,aSerieM,aSerieD)
	
	// Falta estoque por Eis.
	
	//-> Para efeito de testes...
	//-> Se mudar o criterio, nao esquecer de alterar em Giro.prw tambem
	_cAlmoxPGMM  := GetMV("MV_ALMFECH")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o Saldo em estoque do Eis na database para efetuar o retroativo    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("SB1")
	DbOrderNickName("B1SIMIL")   //-> Por Simil + EIS
	
	DbSeek( xFilial("SB1") +c_Simil  + alltrim(c_Eis) )
	
	While SB1->( !Eof() ) .And. xFilial("SB1")==SB1->B1_FILIAL .And. ;
		SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+;
		B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)==alltrim(c_Eis) .And.;
		B1_X_SIMIL == c_Simil
		
		DbSelectArea("SB1")
		
		DbSelectArea("Z10")
		DbSetOrder(1)
		DbSeek( xFilial("Z10") + alltrim(c_Eis) )
		
		DbSelectArea("Z10")
		If !Found()
			SB1->( DbSkip() )
			Loop
		EndIf
		
		//---------------------------------------------------------------------------
		// Chamada de Funcao Externa
		// MFATC12.PRW - Marcelo Almeida
		//
		// User Function SaldoSb2(cProduto)
		// Return(aSaldo)
		//
		// Retorna VETOR com 3 linhas contendo os saldos de Malha, da Matriz e das Filiais
		//       Coluna 1 - Saldo do Estoque Disponivel
		//       Coluna 2 - Controla Estoque  - Qtde nossa em Poder de Terceiros
		//       Coluna 3 - Controla Estoque  - Qtde Terceiros em Nosso Poder
		//       Coluna 4 - Nao Controla Est. - Saldo em Poder de Terceiros
		//       Coluna 5 - Quantidade reservada - Pedido de Venda
		//       Coluna 6 - Quantidade Empenhada
		//       Coluna 7 - Prevista para entrar (via Compras ou OP)
		//       Coluna 8 - Em pedido de Vendas ainda nao liberado p/ Faturar
		//       Coluna 9 - Disponivel + Prevista para Entrar
		//
		// Se _lTFiliais == .f.
		//     Matriz (Linha 2) - Eh o que interessa!!!!!!!
		// Senao
		//     Matriz (Linha 2) + Filiais (Linha 3) - Eh o que interessa!!!!!!!
		//---------------------------------------------------------------------------
		
		
		//_aTmp := U_SaldoSb2(SB1->B1_COD,_cAlmoxPGMM)
		_aTmp := U_SaldoSb2(SB1->B1_COD)
		_nSldOntem :=  _nSldOntem + _aTmp[01,10]
		
		DbSelectArea("SB1")
		SB1->( DbSkip() )
	EndDo
	
Endif


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³4 Com o resultado da analise do Giro nos vetores aSerieM e aSerieD                ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// - Guardaremos o resultado em outro Vetor.
// - E Remontaremos os Vetores aSerieM e aSerieD somente com o periodo desejado.
_aSerieD :=  aClone(aSerieD)
_aSerieM :=  aClone(aSerieM)
aSerieM  :=  {}
aSerieD  :=  {}             


dNovDat  := dDtIni
While  dNovDat != dDtFim
	dNovDat := dNovDat + 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona todos os dias do periodo na matriz para garantir a perfeita visualizacao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aSerieD,{0,0,0, dNovDat })
	
	nPos := aScan(aSerieM,{|x| x[4] == LastDay( dNovDat ) })
	if nPos = 0
		aadd(aSerieM,{0,0,0,LastDay( dNovDat )})
	Endif
Enddo



// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³5 Agora tendo os seguintes vetores aSerieD, _aSerieD, aSerieM, _aSerieM           ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// - Iremos aproveitar e guardar somente o periodo desejado pelo o usuario preenchendo
//   os vetores aSerieM e aSerieD
For _nI:=Len(_aSerieD)  To 1 Step -1
	//-> Saldo + Saidas - Entradas
	_nSld := _nSldOntem  + _aSerieD[_nI,3] - _aSerieD[_nI,2]
	_aSerieD[_nI,1] := _nSld
	_nSldOntem  := _nSld
	
	U_ProcVG(aSerieM,aSerieD,_aSerieD[_nI,1],_aSerieD[_nI,2],_aSerieD[_nI,3],_aSerieD[_nI,4])
	
Next _nI


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³6 A Habilitacao dos Botoes nao sera necessario pois a funcao GRAFICO2 sera chamada³
// ³novamente.                                                                        ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Habilita  Botoes 
//
//If  oGraphic # Nil
//	oGraphic:Enable()
//	oSer:Enable()
//	oVisual:Enable()
//	oTipo:Enable()
//	oDtIni:Enable()
//	oDtFim:Enable()
	
	//oProduto:Enabled()
	//oSimil:Enabled()
	//o_Eis:Enabled()
	
//	oBTn1:Enable()
//	oBTn2:Enable()
//	oBTn3:Enable()
//	oBTn4:Enable()
//	oBTn5:Enable()
//	oBTn6:Enable()
//Endif



// ???
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³Trecho abaixo nao sei se e valido, rever com marcelo ???                          ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nSldBCK :=_nSldOntem
For _nI:=Len(aSerieM)  To 1 Step -1
//-> Saldo + Saidas - Entradas
_nSld := _nSldBCK  + aSerieM[_nI,3] - aSerieM[_nI,2]
aSerieM[_nI,1] := _nSld
_nSldBCK := _nSld
Next _nI

//Remonta a matriz a Envelope para nao gravar sinal zerado
For _nP := Len(aSerieD) To 1 STEP -1
If aSerieD[_nP,4] <  dDtIni    .or.  aSerieD[_nP,4] > dDtFim
ADel(aSerieD,_nP)
nExcl := nExcl + 1
Endif
Next _nP

If nExcl > 0
Asize(aSerieD,(Len(aSerieD)-nExcl)) 	//Remonta o tamanho da Matriz
Endif
//

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ProcVg   ³ Autor ³                    º Data ³  04/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Esta funcao e utilizada somente para filtrar o periodo     º±±
±±º          ³ desejado.                                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ProcVG(aSerieM,aSerieD,nSaldo,nEntrada,nSaida,dData)
Local nPos := 0
                    
	
	nPos := aScan(aSerieD,{|x| x[4] == dData })
	if nPos != 0
		aSerieD[nPos][1] := nSaldo
		aSerieD[nPos][2] := nEntrada
		aSerieD[nPos][3] := nSaida
	Endif
	
	nPos := aScan(aSerieM,{|x| x[4]==LastDay( dData ) })
	if nPos != 0
		aSerieM[nPos][1] =  nSaldo
		aSerieM[nPos][2] += nEntrada
		aSerieM[nPos][3] += nSaida
	Endif
	

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AbastGraf ³ Autor ³                       ³ Data ³ 04.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processa o conteudo da matriz a serie p/ o Grafico         ³±±
±±³          ³                                                            ³±±
±±³ Parametro³ aSerieM  =>(Vetor com [1]Saldos/[2]Entradas/[3]Saidas/[4]Data ³±±
±±³          ³ cVisual =>(Mensal / Anual)                                 ³±±
±±³          ³ lSer1_Sld =>(.T. - Mostra Saldos   / Serie1 )              ³±±
±±³          ³ lSer2_Ent =>(.T. - Mostra Entradas / Serie2 )              ³±±
±±³          ³ lSer3_Sai =>(.T. - Mostra Saidas   / Serie3 )              ³±±
±±³          ³ nCbx    =>(numero do grafico a ser usado)                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AbastGraf(aSerieM,aSerieD,cVisual,lSer1_Sld,lSer2_Ent,lSer3_Sai,nCbx,nTipCons)

Local aMes     := { "JAN","FEV","MAR","ABR","MAI","JUN",;
"JUL","AGO","SET","OUT","NOV","DEZ"}
Local dDiaMes  := ""   // Ultimo dia do Mes
Local cMes     := ""   // Mes correspodente
Local cLegenda := ""
Local nSer     := ""
Local lRet     := .T.


// Adiciona mais uma série de dados, conforme o tipo do grafico
If lSer1_Sld 
	nSerie1 := oGraphic:CreateSerie(nCbx)
	if (nSerie1 = GRP_CREATE_ERR)
		ApMsgAlert(OemToAnsi("Nao foi possivel criar a Serie 1 (Saldo)"))
		lRet := .f.
	Endif
Endif
if lSer2_Ent .and. lRet 
	nSerie2 := oGraphic:CreateSerie(nCbx)
	if (nSerie2 = GRP_CREATE_ERR)
		ApMsgAlert(OemToAnsi("Nao foi possivel criar a Serie 2 (Entradas)"))
		lRet := .f.
	Endif
Endif
if lSer3_Sai .and. lRet 
	nSerie3 := oGraphic:CreateSerie(nCbx)
	if (nSerie3 = GRP_CREATE_ERR)
		ApMsgAlert(OemToAnsi("Nao foi possivel criar a Serie 3 (Saidas)"))
		lRet := .f.
	Endif
Endif


If !lRet
	Return
Endif

if  substr(cVisual,1,1)="M"
	
	For nSer := 1 To Len(aSerieM)
		
		cLegenda := aMes[month(aSerieM[nSer,4])]
		
		//oGraphic:Add(nSerie1, conteudo , Picture  , cor )
		if lSer1_Sld
			oGraphic:Add(nSerie1, aSerieM[nSer][1]   , cLegenda    ,RGB(055,153,200)) // Saldo
		Endif
		if lSer2_Ent
			oGraphic:Add(nSerie2 , aSerieM[nSer][2]  , cLegenda    ,RGB(162,164,91))   // Entradas (Verde)
		Endif
		If lSer3_Sai
			oGraphic:Add(nSerie3, aSerieM[nSer][3]*-1, cLegenda    ,RGB(255,0,0))    // Saidas
		Endif
		
	Next
	
Else
	
	For nSer := 1 To Len(aSerieD)
		
		cLegenda := strzero(day(aSerieD[nSer,4]),2)+"/"+strzero(month(aSerieD[nSer,4]),2)
		
		//oGraphic:Add(nSerie1, conteudo , Picture  , cor )
		if lSer1_Sld
			oGraphic:Add(nSerie1,  aSerieD[nSer][1]   , cLegenda    ,RGB(055,153,200)) // Saldo
		Endif
		if lSer2_Ent
			oGraphic:Add(nSerie2 , aSerieD[nSer][2]   , cLegenda    ,RGB(162,164,91))   // Entradas (Verde)
		Endif
		If lSer3_Sai
			oGraphic:Add(nSerie3,  aSerieD[nSer][3]*-1, cLegenda    ,RGB(255,0,0))    // Saidas
		Endif
		
	Next
	
Endif

//oGraphic:Refresh() JA TENTEI ISTO MAS NAO FUNCIONOU

Return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DefinTipo³ Autor ³                       ³ Data ³ 04.10.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Retorna uma matriz com tres posicoes  apos analise do cTipo³±±
±±³          ³                                                            ³±±
±±³ Parametro³ [1] .t. - usa serie 1 - Saldo                              ³±±
±±³          ³ [2] .t. - usa serie 2 - Entradas                           ³±±
±±³          ³ [3] .t. - usa serie 3 - Saidas                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DefinTipo(nTipo)
Local lSaldos  := .f.
Local lSaidas  := .f.
Local lEntradas:= .f.


If  nTipo =  1  // Entradas
	lSaldos  := .f.
	lEntradas:= .T.
	lSaidas  := .f.
ElseIf nTipo =  2  // Saidas
	lSaldos  := .f.
	lEntradas:= .f.
	lSaidas  := .T.
ElseIf nTipo =  3  // Saldo
	lSaldos  := .T.
	lEntradas:= .f.
	lSaidas  := .f.
ElseIf nTipo =  4  // Entradas x Saidas
	lSaldos  := .f.
	lEntradas:= .T.
	lSaidas  := .T.
ElseIf nTipo =  5  // Entradas x Saldos
	lSaldos  := .T.
	lEntradas:= .T.
	lSaidas  := .F.
ElseIf nTipo =  6  // Saidas x Saldos
	lSaldos  := .T.
	lEntradas:= .f.
	lSaidas  := .T.
ElseIf nTipo =  7  // Entradas x Saidas x Saldos
	lSaldos  := .T.
	lEntradas:= .T.
	lSaidas  := .T.
Endif

//       Serie1   Serie2   Serie3
Return({lSaldos,lEntradas,lSaidas})



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ AltGrafico  ³ Autor ³                       ³ Data ³ 07.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa operacoes no grafico dependendo do parametro          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbc020 / Ctbc030                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AltGrafico(oGraphic, cAcao, uParam1, uParam2, uParam3)

If oGraphic # Nil
	If cAcao = "EFEITO"
		oGraphic:l3D := !oGraphic:l3D
		If uParam2 = Nil
			uParam1:cCaption := If(oGraphic:l3D, "2D", "3D")
		Else
			If oGraphic:l3D
				uParam1:Show()
				uParam2:Hide()
			Else
				uParam2:Show()
				uParam1:Hide()
			Endif
		Endif
	ElseIf cAcao = "ROTACAO+" .And. oGraphic:l3D
		oGraphic:ChgRotat( uParam1, 1, .F. ) // nRotation tem que estar entre 1 e 30 passos
		If .F. // uParam2 # Nil
			If oGraphic:nRotation = 30
				uParam2:Disabled()
			Else
				uParam2:Enabled()
			Endif
		Endif
	ElseIf cAcao = "ROTACAO-" .And. oGraphic:l3D
		oGraphic:ChgRotat( uParam1, 1, .T. ) // nRotation tem que estar entre 1 e 30 passos
		If .F. // uParam3 # Nil
			If oGraphic:nRotation = 1
				uParam3:Disabled()
			Else
				uParam3:Enabled()
			Endif
		Endif
	Endif
Endif

Return .T.




*----------------------------
Static Function BrowseVetor(aSerieM,aSerieD,cVisual)

Local nOpcA         := 0
Local aSizeAut		:= MsAdvSize(,.F.)
Local aObjects		:= {}
Local aInfo 		:= {}
Local aPosGet		:= {}
Local aPosObj		:= {}

Private aHeader     := {}
Private aCols       := {}
Private nopc        := 3
PRIVATE aRotina     := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private oDlgDados,oGet

Private _nPos_Data  := 0
Private _nPos_Entra := 0
Private _nPos_Saida := 0
Private _nPos_Saldo := 0
Private _nPos_vazio := 0
Private _nPos_FSaldo:= 0

Private cCadastro := "Dados utilizados na montagem do Grafico"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criar os campos de cabecalho do oGet        ³         ///??? pode filtrar pelo tipo
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aHeader,{"Data"         ,"_Data"  ,"@!",02,0,"","","D",})
AADD(aHeader,{"Saldo Inicial","_Saldo" ,"@!",20,2,"","","N",})
AADD(aHeader,{"Entradas"     ,"_Entra" ,"@!",30,0,"","","N",})
AADD(aHeader,{"Saidas"       ,"_Saida" ,"@!",15,2,"","","N",})
AADD(aHeader,{"Saldo Final"  ,"_FSaldo","@!",20,2,"","","N",})
AADD(aHeader,{""             ,"_vazio" ,"@!",1,0,"","","C",})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens no Cabecalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nPos_Data  := aScan(aHeader,{|x| AllTrim(x[2])=="_Data"})
_nPos_Entra := aScan(aHeader,{|x| AllTrim(x[2])=="_Entra"})
_nPos_Saida := aScan(aHeader,{|x| AllTrim(x[2])=="_Saida"})
_nPos_Saldo := aScan(aHeader,{|x| AllTrim(x[2])=="_Saldo"})
_nPos_vazio := aScan(aHeader,{|x| AllTrim(x[2])=="_vazio"})
_nPos_FSaldo:= aScan(aHeader,{|x| AllTrim(x[2])=="_FSaldo"})


If  substr(cVisual,1,1)="M"
	
	For _nI:=1 To  Len(aSerieM)
		AADD(aCols,Array(Len(aHeader)+1))
		aCols[_nI,Len(aHeader)+1] := .F.
		
		aCols[_nI,_nPos_Data]  := aSerieM[_nI,4]
		aCols[_nI,_nPos_Saldo] := aSerieM[_nI,1]
		aCols[_nI,_nPos_Entra] := aSerieM[_nI,2]
		aCols[_nI,_nPos_Saida] := aSerieM[_nI,3]
		aCols[_nI,_nPos_FSaldo]:= aSerieM[_nI,1]+aSerieM[_nI,2]-aSerieM[_nI,3]
		aCols[_nI,_nPos_vazio] := ""
		
	Next _nI
	
Else
	
	For _nI:=1 To  Len(aSerieD)
		AADD(aCols,Array(Len(aHeader)+1))
		aCols[_nI,Len(aHeader)+1] := .F.
		
		aCols[_nI,_nPos_Data]  := aSerieD[_nI,4]
		aCols[_nI,_nPos_Saldo] := aSerieD[_nI,1]
		aCols[_nI,_nPos_Entra] := aSerieD[_nI,2]
		aCols[_nI,_nPos_Saida] := aSerieD[_nI,3]
		aCols[_nI,_nPos_FSaldo]:= aSerieD[_nI,1]+aSerieD[_nI,2]-aSerieD[_nI,3]
		aCols[_nI,_nPos_vazio] := ""
		
	Next _nI
	
Endif

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

DEFINE MSDIALOG oDlgDados TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL

oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,,,,.F.,,2)
oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:nMax:=Len(Acols)

/*
oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"U_ValcPar()","U_ValcPar()",,.F.,{"_cCon"},2)
oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:nMax:=Len(Acols)
*/

ACTIVATE MSDIALOG oDlgDados ON INIT PAR_BAR(oDlgDados,{|| nOpcA := 1, oDlgDados:End()},{||oDlgDados:End()})

RETURN


Static Function PAR_BAR(oDlgDados,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlgDados,bOK,bcancel,,aButtons))



Static Function ENCHO_BAR(oDlgDados,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlgDados,bOK,bcancel,,aButtons))



Static Function ValProd(cProduto)
Local lRet := .t.

DbSelectArea("SB1")
DbSetorder(1)
If !Dbseek(xFilial("SB1")+cProduto)
	Aviso("ATENCAO", "Produto nao Cadastrado...",{"&Ok"})
	lRet := .f.
Endif

Return(lRet)


Static Function ValData(dDtIni,dDtFim)
Local lRet :=.T.

If EmptY(dDtIni)
	Aviso("ATENCAO", "Favor informar a data Inicial...",{"&Ok"})
	//lRet := .f.
	SetFocus(oDtIni:hWnd)
	lRet := .T.
Elseif EmptY(dDtFim)
	Aviso("ATENCAO", "Favor informar a data Final....",{"&Ok"})
	lRet := .f.
Elseif  dDtIni > dDtFim
	Aviso("ATENCAO", "Data Inicial maior que data Final...",{"&Ok"})
	lRet := .f.
Endif

Return(lRet)

