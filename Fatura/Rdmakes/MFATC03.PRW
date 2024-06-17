#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

#DEFINE X_PESQUISA		    	1
#Define _nD_ENTER         Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC03   ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta Chamada Atraves da Tecla F4 para detalhes sobre:   º±±
±±º          ³Qtd. Filial                                                 º±±
±±º          ³Qtd. Consignados                                            º±±
±±º          ³Qtd. Transito                                               º±±
±±º          ³Qtd. Empenhada                                              º±±
±±º          ³Codigo EIS                                                  º±±
±±º          ³                                                            º±±
±±ºParametros³Existe somente um parametro que e o codigo do produto       º±±
±±º          ³atraves deste toda a tela se alimenta.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC03(cProduto)

Local  bSetKey4
Local  bSetKey12
Local  cCadastro   := "Consulta da SKU"
Local  nPLin       := 0
Local  nPcol       := 0

Local  aHeadAux    := {}
Local  aColsAux    := {}

Local  aSizeAut    := MsAdvSize()
Local  aObjects    := {}
Local  aPosObj     := {}
Local  nBotGetD    := 0
Local  nRigGetD    := 0
Local  nBotFd      := 0
Local  nRigFd      := 0
Local  nopcao      := 1

Local  cLinOK      := ""
Local  cTudOk      := ""
Local  lGetD       := .F.
Local  aPages      := {}
Local  aTitles     := {}
Local  nFldMed     := 0        //Posicao do Folder corrente

Local  oSKUOOOO,oGSIMILO,oEIS0000,oREFERE,oSUFIXO,oFABRIO,oSBGRUPO,oORIGEM
Local  oSMALHA,oSDISPO,oSMATRIZ,oSFILIAL,oSCONSIG,oRESERVA,oSTRANSI,oSEMPENH ,oCLASSIF,oFatura
Local  oDlgCons
Local  oEisCod1,oEisCod2,oEisCod3,oEisCod4,oEisCod5,oEisCod6,oEisCod7,oEisCod8,oEisCod9
Local  oEisDes1,oEisDes2,oEisDes3,oEisDes4,oEisDes5,oEisDes6,oEisDes7,oEisDes8,oEisDes9

Private T_SKUOOOO   := ""
Private T_GSIMILO   := ""
Private T_REFERE    := ""
Private T_SUFIXO    := ""
Private T_FABRIO    := ""
Private T_SBGRUPO   := ""
Private T_ORIGEM    := ""
Private T_SMALHA    :=0
Private T_SDISPO    :=0
Private T_SMATRIZ   :=0
Private T_SFILIAL   :=0
Private T_SCONSIG   :=0
Private T_RESERVA   :=0
Private T_STRANSI   :=0
Private T_SEMPENH   :=0
Private T_CLASSIF   :=0
Private T_FATURA    :=0
Private aTrataEIS   := {}


Private oGet01,oGet02,oGet03,oGet04,oGet05,oGet06,oGet07,oGet08,oGet09,oGet10
Private lInfMed    := .T.
Private nFldAnt    := 1    //Posicao do ultimo Folder selecionado
Private nControGD  := 0    // variavel para controle da ultima GETDADOS editada devido ao problema de que quando se esta editando a getdados e depois clica direto no OK nao e' executado o CODBLOCK de LOSTFOCUS da GETDADOS.
Private aCols1     := {}
Private aCols2     := {}
Private aCols3     := {}
Private aCols4     := {}
Private aCols5     := {}
Private aCols6     := {}
Private aCols7     := {}
Private aCols8     := {}
Private aCols9     := {}
Private aCols10    := {}
Private aHeader1,aHeader2,aHeader3,aHeader4,aHeader5,aHeader6
Private aHeader7,aHeader8,aHeader9,aHeader10


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Existem locais em que esta rotina e chamada de dentro de um acols        ³
//³por este motivo e necessario guardar o acols anterior antes de prosseguir.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


If  Type("aCols") != "U"
	aHeadAux	       := aClone(aHeader)
	aColsAux	       := aClone(aCols)
	aCols              :={}
	aHeader            :={}
Else
	Private aCols      :={}
	Private aHeader    :={}
Endif


If cProduto = Nil .or. Empty(cProduto)
	If cProduto = Nil
		Aviso('Atencao','Ocorre erro na chamda da funcao MFATC03.'+chr(13)+chr(13)+;
		'Nao foi passado parametro com o Cod.do Produto.',{'Ok'})
	Else
		Aviso('Atencao','Nao foi escolhida nenhuma SKU para estar mostrando Detalhes',{'Ok'})
	Endif
	
	aHeader := aClone(aHeadAux)
	aCols   := aClone(aColsAux)
	
	Return(cProduto)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Produto                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SB1")
DbSetOrder(1)
If !Dbseek(xFilial("SB1")+cProduto)
	Aviso('Atencao','Produto '+alltrim(cProduto)+' nao cadastrado.'+chr(13)+;
	'Verificar Cadastro de Produtos (SB1)',{'Ok'})

	aHeader := aClone(aHeadAux)

	Return(cProduto)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aTitles,"Sld da Malha")
Aadd(aPages,"HEADER 1")
AADD(aTitles,"Malha(Disp)")
Aadd(aPages,"HEADER 2")
AADD(aTitles,"Matriz(Disp)")
Aadd(aPages,"HEADER 3")
AADD(aTitles,"Filiais(Disp)" )
Aadd(aPages,"HEADER 4")
AADD(aTitles,"Consignado")
Aadd(aPages,"HEADER 5")
AADD(aTitles,"Transito")
Aadd(aPages,"HEADER 6")
AADD(aTitles,"Reservado")
Aadd(aPages,"HEADER 7")
AADD(aTitles,"Empenho")
Aadd(aPages,"HEADER 8")
AADD(aTitles,"a Classificar")
Aadd(aPages,"HEADER 9")
AADD(aTitles,"a Faturar")
Aadd(aPages,"HEADER 10")
AADD(aTitles,"Codigo Eis")
Aadd(aPages,"HEADER 11")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Buscanda todas as informacoes  para  ³
//³ tela.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// A Funcao abaixo e chamada de dentro da funcao acima.
Processa({|| InfoTela(cProduto,@T_SKUOOOO,@T_GSIMILO,@T_REFERE,@T_SUFIXO,;
@T_FABRIO,@T_SBGRUPO,@T_ORIGEM,@T_SMALHA,@T_SDISPO,@T_SMATRIZ,@T_SFILIAL,;
@T_SCONSIG,@T_RESERVA,@T_STRANSI,@T_SEMPENH,@T_CLASSIF,@aTrataEIS)},;
"Aguarde...Levantando Informacoes sobre o Produto")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetuando montagem de Tela           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 7,16
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Janela de Consulta          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 //BOLD

DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM 106,65 TO 700,835  OF oMainWnd pixel
bSetKey4 :=SetKey(VK_F4,nil)
bSetKey12:=SetKey(VK_F12,nil)

@ 030,005   TO 145,380 OF oDlgCons PIXEL


@ 035,010   SAY "SKU     "                  size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,100   SAY "SIMIL   "                  size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,170   SAY "SG SIMIL"                  size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,250   SAY "EIS     "                  size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 050,010   SAY "REFERENCIA"                size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,100   SAY "SUFIXO "                   size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,170   SAY "MARCA"                     size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,250   SAY "ORIGEM "                   size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 065,045   SAY "Sld da Malha"             size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 065,130   SAY "Malha(Disp)"              size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 065,205   SAY "Matriz(Disp)"             size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 065,290   SAY "Filiais(Disp)"            size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5

@ 090,045   SAY "Consignado"               size 100,8 OF oDlgCons FONT oBold  PIXEL //FONT oFntFecha5
@ 090,130   SAY "Transito"                 size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 090,205   SAY "Reservado"                size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 090,290   SAY "Empenho"                  size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5

@ 115,045   SAY "a Classificar"            size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5
@ 115,130   SAY "a Faturar"                size 100,8 OF oDlgCons FONT oBold PIXEL //FONT oFntFecha5

@ 035,045   MSGET oSKUOOOO  VAR T_SKUOOOO     Picture "@!"           Size 40,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 035,125   MSGET oGSIMILO  VAR T_GSIMILO     Picture "@!"           SIZE 30,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 035,200   MSGET oSBGRUPO  VAR T_SBGRUPO     Picture "@!"           SIZE 30,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 035,285   MSGET oEIS0000  VAR aTrataEIS[1,3]Picture "@!"           Size 80,8 OF oDlgCons PIXEL  When .F. Valid .t.

@ 050,045   MSGET oREFERE   VAR T_REFERE      Picture "@!"           Size 50,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 050,125   MSGET oSUFIXO   VAR T_SUFIXO      Picture "@!"           SIZE 30,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 050,200   MSGET oFABRIO   VAR T_FABRIO      Picture "@!"           Size 20,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 050,285   MSGET oORIGEM   VAR T_ORIGEM      Picture "@!"           Size 20,8 OF oDlgCons PIXEL  When .F. Valid .t.

@ 075,045   MSGET oSMALHA   VAR T_SMALHA       Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 075,125   MSGET oSDISPO   VAR T_SDISPO       Picture "@E 999,999,999"  SIZE 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 075,200   MSGET oSMATRIZ  VAR T_SMATRIZ      Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 075,285   MSGET oSFILIAL  VAR T_SFILIAL      Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.

@ 100,045   MSGET oSCONSIG  VAR T_SCONSIG      Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 100,125   MSGET oSTRANSI  VAR T_STRANSI      Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 100,200   MSGET oRESERVA  VAR T_RESERVA      Picture "@E 999,999,999"  SIZE 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 100,285   MSGET oSEMPENH  VAR T_SEMPENH      Picture "@E 999,999,999"  Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.

@ 125,045   MSGET oCLASSIF  VAR T_CLASSIF       Picture "@E 999,999,999" Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.
@ 125,125   MSGET oFATURA   VAR T_FATURA        Picture "@E 999,999,999" Size 70,8 OF oDlgCons PIXEL  When .F. Valid .t.


aPosObj:={ {},{150,05,295,380}}

nBotFd   := (aPosObj[2,3]-aPosObj[2,1])
nRigFd   := (aPosObj[2,4]-aPosObj[2,2])
nBotGetD := (aPosObj[2,3]-aPosObj[2,1]-15)
nRigGetD := (aPosObj[2,4]-aPosObj[2,2]-2)

oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,aPages,oDlgCons,,,,.T.,.F.,nRigFd,nBotFd,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 02	- Malha	    				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader2
aCols		:= aCols2
n          := len(aCols)

oGet02 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[1])
//oGet02:oBrowse:bGotFocus 	:={|| Fd_Entra(3)}
//oGet02:oBrowse:bLostFocus 	:={|| Fd_Sai(3)}
oGet02:oBrowse:Default()
oGet02:oBrowse:Refresh()
//oGet02:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 01	- Disponivel	 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader1
aCols		:= aCols1
n          := len(aCols)

oGet01 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[2])
//oGet01:oBrowse:bGotFocus 	:={|| Fd_Entra(3)}
//oGet01:oBrowse:bLostFocus 	:={|| Fd_Sai(3)}
oGet01:oBrowse:Default()
oGet01:oBrowse:Refresh()
//oGet01:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 03		- Matriz				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader3
aCols		:= aCols3
n          := len(aCols)

oGet03 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[3])
//oGet03:oBrowse:bGotFocus 	:={|| Fd_Entra(2)}
//oGet03:oBrowse:bLostFocus 	:={|| Fd_Sai(2)}
oGet03:oBrowse:Default()
oGet03:oBrowse:Refresh()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 04	- Filial    				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader4
aCols		:= aCols4
n          := len(aCols)

oGet04 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nopcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[4])
//oGet04:oBrowse:bGotFocus 	:={|| Fd_Entra(1)}
//oGet04:oBrowse:bLostFocus 	:={|| Fd_Sai(1)}
oGet04:oBrowse:Default()
oGet04:oBrowse:Refresh()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 05- Consignado					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader5
aCols		:= aCols5
n          := len(aCols)

oGet05 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[5])
//oGet05:oBrowse:bGotFocus 	:={|| Fd_Entra(4)}
//oGet05:oBrowse:bLostFocus 	:={|| Fd_Sai(4)}
oGet05:oBrowse:Default()
oGet05:oBrowse:Refresh()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 06	 - Transito 				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader6
aCols		:= aCols6
n          := len(aCols)

oGet06 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[6])
//oGet06:oBrowse:bGotFocus 	:={|| Fd_Entra(5)}
//oGet06:oBrowse:bLostFocus :={|| Fd_Sai(5)}
oGet06:oBrowse:Default()
oGet06:oBrowse:Refresh()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 08	- Reserva       			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader8
aCols		:= aCols8
n           := len(aCols)


oGet08 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[7])
//oGet08:oBrowse:bGotFocus 	    :={|| Fd_Entra(7)}
//oGet08:oBrowse:bLostFocus 	:={|| Fd_Sai(7)}
oGet08:oBrowse:Default()
oGet08:oBrowse:Refresh()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 07	- Empenho   				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader7
aCols		:= aCols7
n           := len(aCols)

oGet07 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[8])
//oGet07:oBrowse:bGotFocus 	:={|| Fd_Entra(6)}
//oGet07:oBrowse:bLostFocus 	:={|| Fd_Sai(6)}
oGet07:oBrowse:Default()
oGet07:oBrowse:Refresh()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 09	- a Classificao  			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader9
aCols		:= aCols9
n           := len(aCols)

oGet09 	:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[9])
//oGet09:oBrowse:bGotFocus 	:={|| Fd_Entra(7)}
//oGet09:oBrowse:bLostFocus 	:={|| Fd_Sai(7)}
oGet09:oBrowse:Default()
oGet09:oBrowse:Refresh()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 10								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader 	:= aHeader10
aCols		:= aCols10
n           := len(aCols)

oGet10:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[10])
oGet10:oBrowse:Default()
oGet10:oBrowse:Refresh()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 11								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nPLin:=0
nPcol:=080

@ 0,0   TO nBotGetd,nRigGetd OF oFolder:aDialogs[11] PIXEL

@ nPLin+010,nPcol SAY "Familia                   " size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+020,nPcol SAY "Divisao Familia           " size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+030,nPcol SAY "Tipo Familia              " size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+040,nPcol SAY "Divisao Construtiva       " size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+050,nPcol SAY "1 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+060,nPcol SAY "2 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+070,nPcol SAY "3 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+080,nPcol SAY "4 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+090,nPcol SAY "5 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5
@ nPLin+100,nPcol SAY "6 Caracteristica Principal" size 100,8 OF oFolder:aDialogs[11] PIXEL //FONT oFntFecha5

@ nPLin+010,nPcol+73 MSGET oEisCod1  VAR  aTrataEIS[01,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+020,nPcol+73 MSGET oEisCod2  VAR  aTrataEIS[02,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+030,nPcol+73 MSGET oEisCod3  VAR  aTrataEIS[03,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+040,nPcol+73 MSGET oEisCod4  VAR  aTrataEIS[04,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+050,nPcol+73 MSGET oEisCod5  VAR  aTrataEIS[05,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+060,nPcol+73 MSGET oEisCod6  VAR  aTrataEIS[06,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+070,nPcol+73 MSGET oEisCod7  VAR  aTrataEIS[07,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+080,nPcol+73 MSGET oEisCod8  VAR  aTrataEIS[08,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+090,nPcol+73 MSGET oEisCod9  VAR  aTrataEIS[09,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+100,nPcol+73 MSGET oEisCod9  VAR  aTrataEIS[10,1]  Picture "@!"           Size 15,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.

@ nPLin+010,nPcol+100 MSGET oEisDes1  VAR  aTrataEIS[01,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+020,nPcol+100 MSGET oEisDes2  VAR  aTrataEIS[02,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+030,nPcol+100 MSGET oEisDes3  VAR  aTrataEIS[03,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+040,nPcol+100 MSGET oEisDes4  VAR  aTrataEIS[04,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+050,nPcol+100 MSGET oEisDes5  VAR  aTrataEIS[05,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+060,nPcol+100 MSGET oEisDes6  VAR  aTrataEIS[06,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+070,nPcol+100 MSGET oEisDes7  VAR  aTrataEIS[07,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+080,nPcol+100 MSGET oEisDes8  VAR  aTrataEIS[08,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+090,nPcol+100 MSGET oEisDes9  VAR  aTrataEIS[09,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.
@ nPLin+100,nPcol+100 MSGET oEisDes9  VAR  aTrataEIS[10,2]  Picture "@!"           Size 110,7 OF oFolder:aDialogs[11] PIXEL  When .F. Valid .t.


//Salva os dados editados na troca de pasta no folder
//aHeader 	:= aHeader1
//aCols		:= aCols1
//n           := len(aCols)
oFolder:bSetOption := {|nAt|DefPasta(nFldMed:=nAt,nFldAnt:=oFolder:nOption,)}
oFolder:bChange    := {||If(!lInfMed,(oFolder:SetOption(nFldAnt),oFolder:Refresh()),.T.)}
//oFolder:SetOption(1)


ACTIVATE MSDIALOG oDlgCons ON INIT RfatBar(oDlgCons,{|| oDlgCons:End()},{||oDlgCons:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F12,bSetKey12)


aHeader := aClone(aHeadAux)
aCols   := aClone(aColsAux)

Return(cProduto)






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InfoTela  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca todas as informacoes para a tela.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InfoTela(cProduto,T_SKUOOOO,T_GSIMILO,T_REFERE,T_SUFIXO,;
T_FABRIO,T_SBGRUPO,T_ORIGEM,T_SMALHA,T_SDISPO,T_SMATRIZ,T_SFILIAL,;
T_SCONSIG,T_RESERVA,T_STRANSI,T_SEMPENH,T_CLASSIF,aTrataEIS)

Local aSaldoEst := {}

ProcRegua(5)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Saldos                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Incproc("Levantando Saldos em Estoque")   //1

aSaldoEst := U_SaldoSb2(cProduto)  // MONTACOLS.PRW

T_SMALHA    :=  aSaldoEst[01][11] + aSaldoEst[04][11]
T_SDISPO    :=  aSaldoEst[01][12] + aSaldoEst[04][12]
T_SMATRIZ   :=  aSaldoEst[02][12]
T_SFILIAL   :=  aSaldoEst[03][12]
T_SCONSIG   :=  aSaldoEst[04][12]   // CONSIGNADO
T_RESERVA   :=  aSaldoEst[01][05]   // RESERVA
T_STRANSI   :=  aSaldoEst[01][07]   // A FATURAR
T_SEMPENH   :=  aSaldoEst[01][06]   // EMPENHADO
T_FATURA    :=  aSaldoEst[01][08]   // A FATURAR
T_CLASSIF   :=  aSaldoEst[01][09]   // A CLASSIFICAR

T_SKUOOOO   := SB1->B1_COD
T_GSIMILO   := SB1->B1_X_SIMIL
T_REFERE    := SB1->B1_X_REFER
T_SUFIXO    := SB1->B1_X_SUFIX
T_FABRIO    := SB1->B1_X_MARCA
T_ORIGEM    := SB1->B1_ORIGEM
T_SBGRUPO   := SB1->B1_X_SBSIM

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rastreando informacoes do EIS        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTrataEIS:=U_TrataEIS(SB1->B1_COD)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando o aHeader e o Acols         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// aHeader
//
aHeader1:=aHeader2:=aHeader3:=;
aHeader4:=aHeader5:=;
aHeader9:=U_MONTACOLS("DISPONIVEL ","H") // aHedear(1/2/3/4/5/9)
aHeader6:=U_MONTACOLS("TRANSITO   ","H") // aHeader6
aHeader7:=U_MONTACOLS("EMPENHADO  ","H") // aHeader7
aHeader8:=U_MONTACOLS("RESERVADO  ","H") // aHeader8
aHeader10:=U_MONTACOLS("FATURAR   ","H") // aHedear(1/2/3/4/5/9)

//
// aCols
//
Incproc("Levantando Display Saldo Disponivel")  //2
U_MONTACOLS("DISPONIVEL","A", aHeader1 ) // aCols(1/2/3/4/5/8/9)
Incproc("Levantando Display Saldo em Transito") //3
U_MONTACOLS("TRANSITO  ","A", aHeader6 ) // aCols6
Incproc("Levantando Display Saldo Empenhado")   //4
U_MONTACOLS("EMPENHADO ","A", aHeader7 ) // aCols7
Incproc("Levantando Display Saldo Reservado")   //5
U_MONTACOLS("RESERVADO ","A", aHeader8 ) // aCols8
Incproc("Levantando Display Saldo a Faturar")
U_MONTACOLS("FATURAR  ","A", aHeader10 ) // aCols10


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na Entrada no Primeiro Acols|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(aHeader1)
aCols   := aClone(aCols1)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTACOLS ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta funcao tem como objetivo retornar o resultado da busta º±±
±±º          ³da Qtd. Filial,Consignado,Transito,Empenhado                º±±
±±º          ³                                                            º±±
±±º          ³Para tanto possui os seguintes parametros:                  º±±
±±º          ³                                                            º±±
±±º          ³Objetivo  :=  "FILIAL"      - Qtd Filiais                   º±±
±±º          ³              "MATRIZ"      - Qtd Matriz                    º±±
±±º          ³              "MALHA        - Qtd Malha                     º±±
±±º          ³              "CONSIGNADOS" - Qtd Consignados               º±±
±±º          ³              "TRANSITO"    - Qtd Transito                  º±±
±±º          ³              "EMPENHADO"   - Qtd Empenhado                 º±±
±±º          ³              "CLASSIFICAR  - Qtd a classificar             º±±
±±º          ³              "RESERVA"     - Qtd a reservar                º±±
±±º          ³Motivo    :=  "A"           - aCols                         º±±
±±º          ³              "H"           - Header                        º±±
±±º          ³              "Q"           - Somente as Quantidades        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MONTACOLS(Objetivo,cMotivo,_aHeader)
Local uRet
Local _aArea := GetArea()


Objetivo := Alltrim(Upper(Objetivo))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o Motivo a Operacao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	
	// Motivo retorno aHeader
	Case  cMotivo = "H"
		
		uRet := U_MaHeader(cMotivo,Objetivo)
		
		// Motivo retorno o Acols
	Case  cMotivo = "A"
		
		if len(_aHeader)= 0
			Aviso("ATENCAO", "Processo Abortado Tentantiva de Montar Acols sem ter aHeader"+chr(13)+chr(13)+;
			"Contactar Analista Microsiga",{"&Ok"})
			uRet := Nil
		Else
			uRet := U_MaCols(cMotivo,Objetivo,_aHeader)
		Endif
		
EndCase


RestArea(_aArea)

Return(uRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MaHeader  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta funcao tem como objetivo retornar o resultado da busta º±±
±±º          ³o aHeader                                                   º±±
±±º          ³                                                            º±±
±±º          ³Para tanto possui os seguintes parametros:                  º±±
±±º          ³                                                            º±±
±±º          ³Objetivo  :=  "FILIAL"      - Qtd Filiais                   º±±
±±º          ³              "CONSIGNADOS" - Qtd Consignados               º±±
±±º          ³              "TRANSITO"    - Qtd Transito                  º±±
±±º          ³              "EMPENHADO"   - Qtd Empenhado                 º±±
±±º          ³              "TOTAL    "   - Qtd Total                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MaHeader(cMotivo,Objetivo)
Local _AHEADER  := {}

DbSelectArea("SX3")
DbSetOrder(2)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Malha:e a Somatoria de todas as Filiais menos o Almox. Bloq.  ³
//³               Conclusao: Somatoria da Saldo Matriz + Saldo Filial.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Matriz:Demonstra apenas a Filial "01" definida como matriz    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Filial:Todas as Filiais Menos os Armazens Bloqueados     ³
//|                e menos o saldo da Matriz                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo Consignado:Somente Filial da Matriz Buscar os Almox. Bloqueados  ³
//³                 atraves do Parametro.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Objetivo $ "MALHA|DISPONIVEL|MATRIZ|FILIAL|CONSIGNADO|CLASSIFICAR"
	
	
	DbSeek("CK_PRODUTO")     //  Filiais
	AADD(_AHEADER,{"Filiais","DESCRI",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("B6_LOCAL")       //  Armazens
	AADD(_AHEADER,{"Armazens","LOCAL",X3_PICTURE,35,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("B6_QUANT")       //  Quantidade
	AADD(_AHEADER,{"Quantidade","QTDE",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	//AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	//AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	//AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	//AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	//AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	
	
ELSEIf Objetivo $ "RESERVADO|FATURAR"
	
	
	DbSeek("CK_PRODUTO")     //  Filiais
	AADD(_AHEADER,{"Filiais","DESCRI",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C6_LOCAL")       //  Armazens
	AADD(_AHEADER,{"Armazens","LOCAL",X3_PICTURE,35,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C6_QTDVEN")       //  Quantidade
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C6_NUM")        //   Numero do Pedido
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C5_VEND1")      //  Codigo Vendedor Interno
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C5_X_DTPRE")      //  Data Prevista para Faturamento
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("A1_NOME")        //  Nome do Cliente
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Saldo em Transito:Somente Filial da Matriz pois teoricamente das filiais³
	//³                  nao sera efetuada Venda. (c5/c6)  (COMPRAS)           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ELSEIf Objetivo $ "TRANSITO"
	
	DbSeek("CK_PRODUTO")     //  Filiais
	AADD(_AHEADER,{"Filiais","DESCRI",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C6_LOCAL")       //  Armazens
	AADD(_AHEADER,{"Armazens","LOCAL",X3_PICTURE,35,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C7_QUANT")       //  Quantidade
	AADD(_AHEADER,{"Quantidade","QTDE",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C1_NUM")          //  Num da Solicitacao de Compras
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C7_NUM")          //  Num do Pedido de Compras
	AADD(_AHEADER,{X3_TITULO,"C7_NUMPC",X3_PICTURE,X3_TAMANHO+5,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C2_NUM")           // Num da Op
	AADD(_AHEADER,{X3_TITULO,"C2_NUMOP",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C7_X_DTCON")       //  Data de Confirmacao
	AADD(_AHEADER,{"Dt.Confirmacao",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	//	DbSeek("W3_DT_EMB")        //  Data de Embarque
	//	AADD(_AHEADER,{"Prev.Embarque",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	//	DbSeek("W3_DT_ENTR")       //  Data de Entraga
	//	AADD(_AHEADER,{"Prev.Porto",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("C2_OBS")          //  Observacao (Solicitacao / Pedido / OP)
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Saldo Empenhado:  Com base no SD4                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ELSEIf Objetivo $ "EMPENHADO"
	
	DbSeek("CK_PRODUTO")     //  Filial
	AADD(_AHEADER,{"Filial","DESCRI",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("D4_LOCAL")       //  Armazens
	AADD(_AHEADER,{"Armazens","LOCAL",X3_PICTURE,35,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("D4_QUANT")       //  Quantidade Empenhada
	AADD(_AHEADER,{"Qtde Empenhada",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("D4_OP")          //  Numero da Op
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("D4_DATA")        //  Data
	AADD(_AHEADER,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	AADD(_AHEADER,{"","FINALIZA","@!",1,0,,X3_USADO,"C",,})
	
Endif

Return(_AHEADER)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MaCols    ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esta funcao tem como objetivo Montar o acols                º±±
±±º          ³da Qtd. Filial,Consignado,Transito,Empenhado                º±±
±±º          ³                                                            º±±
±±º          ³Para tanto possui os seguintes parametros:                  º±±
±±º          ³                                                            º±±
±±º          ³Objetivo  :=  "FILIAL"      - Qtd Filiais                   º±±
±±º          ³              "MATRIZ"      - Qtd Matriz                    º±±
±±º          ³              "MALHA        - Qtd Malha                     º±±
±±º          ³              "CONSIGNADOS" - Qtd Consignados               º±±
±±º          ³              "TRANSITO"    - Qtd Transito                  º±±
±±º          ³              "EMPENHADO"   - Qtd Empenhado                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MaCols(cMotivo,Objetivo,_AHEADER)

Local nLin      := 0
Local nPos      := 0
Local lQuery    := .F.
Local lContinua := .T.
Local cAlias    := ""
Local aStru     := {}
Local _cStrAlmox:= ""
Local _aFilSmo  := {}
Local _aNomeAlm := {}
Local _Recno    := 0
Local aElem     := {}
Local _cFilial_ := ""
Local _uString  := _cParAlmox:= GETMV("MV_ALMCONS")
Local cProduto  := SB1->B1_COD
Local nFatura   :=0
Local lC9_BLEST :=.f.
Local dDtEmbar  := CTOD("")
Local dDtEntre  := CTOD("")
Local nReserva  := 0

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
DbSelectArea("NNR")
_Recno := RECNO()
DbGotop()
While !eof()
	//AADD(_aNomeAlm,{SZB->ZB_LOCAL,SZB->ZB_LOCNOME})
	AADD(_aNomeAlm,{NNR->NNR_CODIGO,NNR->NNR_DESCRI})
	NNR->(DBSKIP())
Enddo
Dbgoto(_Recno)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Malha:e a Somatoria de todas as Filiais menos o Almox. Bloq.  ³
//³               Conclusao: Somatoria da Saldo Matriz + Saldo Filial.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Matriz:Demonstra apenas a Filial "01" definida como matriz    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo da Filial:Todas as Filiais Menos os Armazens Bloqueados     ³
//|                e menos o saldo da Matriz                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Saldo Consignado:Somente Filial da Matriz Buscar os Almox. Bloqueados  ³
//³                 atraves do Parametro.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Objetivo $ "MALHA|DISPONIVEL|MATRIZ|FILIAL|CONSIGNADO|CLASSIFICAR"
	
	
	#IFDEF TOP
		
		cAlias    := "MA215SB2"
		aStru     := SB2->(dbStruct())
		lQuery    := .T.
		
		cQuery := "SELECT * "
		cQuery += "FROM "
		cQuery += RetSqlName("SB2")+" (NOLOCK) SB2 "
		cQuery += "WHERE "
		cQuery += "SB2.B2_FILIAL<>'  ' AND "
		cQuery += "SB2.B2_COD='"+cProduto+"' AND "
		cQuery += "SB2.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY B2_FILIAL,B2_LOCAL "
		cQuery := ChangeQuery(cQuery)
		
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery)
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		
		DbgoTop()
		
	#ELSE
		
		cAlias := "SB2"
		dbSelectArea(cAlias)
		DbOrderNickname("B2CODIGO") // CODIGO + ARMAZEM
		DbSeek(cProduto)
		
	#ENDIF
	
	While !(cAlias)->(Eof())      //.And. xFilial("SB2") == (cAlias)->B2_FILIAL
		
		lContinua := .T.
		
		If !lQuery
			
			If  !((cAlias)->B2_COD == cProduto)
				Exit
			Endif
			
		EndIf
		
		
		If  lContinua
			
			
			// Saldo Dispnivel
			nSaldo := SaldoSb2(.T.,,,,,cAlias)	//nSaldo := nSaldo - (cAlias)->B2_QPEDVEN  // Subtrai quantidade a Faturar e Nao soma a B2_QACLASS
			
			// Malha := Disponivel + a Classificar + (Prev.p/Entrar SC1/SC7/SC2)
			nMalha := (cAlias)->B2_QATU + (cAlias)->B2_SALPEDI
			
			// Saldo Disponivel
			if nSaldo != 0                   //.and. !((cAlias)->B2_LOCAL  $ _cStrAlmox)
				AADD(aCols1,Array(Len(_AHEADER)+1))
				nLin := Len(aCols1)
				aCols1[nLin,Len(_AHEADER)+1] := .F.
				aCols1[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
				aCols1[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
				aCols1[nLin][3]      := nSaldo
				aCols1[nLin][4]      := "."
				//aCols1[nLin][5]      := "."
				//aCols1[nLin][6]      := "."
				//aCols1[nLin][7]      := "."
				//aCols1[nLin][8]      := "."
				//aCols1[nLin][9]      := "."
			Endif
			
			
			// Malha       ( Todos os Armazens inclusive consignados)
			if nMalha != 0
				AADD(aCols2,Array(Len(_AHEADER)+1))
				nLin := Len(aCols2)
				aCols2[nLin,Len(_AHEADER)+1] := .F.
				aCols2[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
				aCols2[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
				aCols2[nLin][3]      := nMalha
				aCols2[nLin][4]      := "."
				aCols2[nLin][5]      := "."
				//aCols2[nLin][6]      := "."
				//aCols2[nLin][7]      := "."
				//aCols2[nLin][8]      := "."
				//aCols2[nLin][9]      := "."
			Endif
			
			//Classificar
			if (cAlias)->B2_NAOCLAS != 0
				AADD(aCols9,Array(Len(_AHEADER)+1))
				nLin := Len(aCols9)
				aCols9[nLin,Len(_AHEADER)+1] := .F.
				aCols9[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
				aCols9[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
				aCols9[nLin][3]      := (cAlias)->B2_NAOCLAS
				aCols9[nLin][4]      := "."
				//aCols9[nLin][5]      := "."
				//aCols9[nLin][6]      := "."
				//aCols9[nLin][7]      := "."
				//aCols9[nLin][8]      := "."
		        //aCols9[nLin][9]      := "."
			Endif
			
			if nSaldo != 0
				//Consignados
				If	(cAlias)->B2_LOCAL  $ _cStrAlmox
					
					AADD(aCols5,Array(Len(_AHEADER)+1))
					nLin := Len(aCols5)
					aCols5[nLin,Len(_AHEADER)+1] := .F.
					aCols5[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
					aCols5[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
					aCols5[nLin][3]      := nSaldo
					aCols5[nLin][4]      := "."
					//aCols5[nLin][5]      := "."
					//aCols5[nLin][6]      := "."
					//aCols5[nLin][7]      := "."
					//aCols5[nLin][8]      := "."
					//aCols5[nLin][9]      := "."

				Else
					
					If  B2_FILIAL='01'
						
						//Matriz
						AADD(aCols3,Array(Len(_AHEADER)+1))
						nLin := Len(aCols3)
						aCols3[nLin,Len(_AHEADER)+1] := .F.
						aCols3[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
						aCols3[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
						aCols3[nLin][3]      := nSaldo
						aCols3[nLin][4]      := "."
						//aCols3[nLin][5]      := "."
						//aCols3[nLin][6]      := "."
						//aCols3[nLin][7]      := "."
						//aCols3[nLin][8]      := "."
						//aCols3[nLin][9]      := "."
					
					Else
						
						//Filial
						AADD(aCols4,Array(Len(_AHEADER)+1))
						nLin := Len(aCols4)
						aCols4[nLin,Len(_AHEADER)+1] := .F.
						aCols4[nLin][1]      := NomeFil((cAlias)->B2_FILIAL,_aFilSmo)
						aCols4[nLin][2]      := NomeArm((cAlias)->B2_LOCAL,_aNomeAlm)
						aCols4[nLin][3]      := nSaldo
						aCols4[nLin][4]      := "."
						//aCols4[nLin][5]      := "."
						//aCols4[nLin][6]      := "."
						//aCols4[nLin][7]      := "."
						//aCols4[nLin][8]      := "."
						//aCols4[nLin][9]      := "."
					
					Endif
					
				Endif
				
			Endif
			
			
		Endif
		
		(cAlias)->(Dbskip())
		
	EndDo
	
	
	If  lQuery
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	Endif
	
	
	if Len(aCols1) = 0
		AADD(aCols1,Array(Len(_AHEADER)+1))
		nLin := Len(aCols1)
		aCols1[nLin,Len(_AHEADER)+1] := .F.
		aCols1:=PrencAcols(aCols1,_AHEADER)
	Endif
	if Len(aCols2) = 0
		AADD(aCols2,Array(Len(_AHEADER)+1))
		nLin := Len(aCols2)
		aCols2[nLin,Len(_AHEADER)+1] := .F.
		aCols2:=PrencAcols(aCols2,_AHEADER)
	Endif
	if Len(aCols3) = 0
		AADD(aCols3,Array(Len(_AHEADER)+1))
		nLin := Len(aCols3)
		aCols3[nLin,Len(_AHEADER)+1] := .F.
		aCols3:=PrencAcols(aCols3,_AHEADER)
	Endif
	if Len(aCols4) = 0
		AADD(aCols4,Array(Len(_AHEADER)+1))
		nLin := Len(aCols4)
		aCols4[nLin,Len(_AHEADER)+1] := .F.
		aCols4:=PrencAcols(aCols4,_AHEADER)
	Endif
	if Len(aCols5) = 0
		AADD(aCols5,Array(Len(_AHEADER)+1))
		nLin := Len(aCols5)
		aCols5[nLin,Len(_AHEADER)+1] := .F.
		aCols5:=PrencAcols(aCols5,_AHEADER)
	Endif
	if Len(aCols9) = 0
		AADD(aCols9,Array(Len(_AHEADER)+1))
		nLin := Len(aCols9)
		aCols9[nLin,Len(_AHEADER)+1] := .F.
		aCols9:=PrencAcols(aCols9,_AHEADER)
	Endif
	
	
	
ELSEIf Objetivo $ "RESERVADO"
	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC6->(dbStruct())
		lQuery    := .T.
		cAlias := "SC1MA215PROC"
		
		cQuery := ""
		cQuery := "SELECT SC6.C6_FILIAL , SC6.C6_LOCAL, SC6.C6_QTDVEN , SC6.C6_QTDENT , SC6.C6_QTDEMP , SC6.C6_NUM , SC6.C6_ENTREG ,  SC5.C5_VEND1 , SA1.A1_NOME , SC5.C5_X_DTPRE , SC6.C6_NOTA, SC9.C9_QTDLIB, SC6.C6_ITEM "
		cQuery += " FROM "+RetSqlName("SC6")+"  (NOLOCK)  SC6, "
		cQuery += RetSqlName("SC5")+"  (NOLOCK) SC5, "
		cQuery += RetSqlName("SA1")+"  (NOLOCK) SA1, "
		cQuery += RetSqlName("SF4")+"  (NOLOCK) SF4, "
		cQuery += RetSqlName("SC9")+"  (NOLOCK) SC9 "
		cQuery += "WHERE "
		
		cQuery += "SC6.C6_FILIAL<>'  ' AND "
		cQuery += "SC5.C5_FILIAL<>'  ' AND "
		cQuery += "SA1.A1_FILIAL<>'  ' AND "
		cQuery += "SF4.F4_FILIAL ='  ' AND "
		cQuery += "SC9.C9_FILIAL<>'  ' AND "
		
		cQuery += "SF4.F4_ESTOQUE='S'  AND "
		cQuery += "SF4.F4_CODIGO = SC6.C6_TES AND "
		cQuery += "SC6.C6_BLQ <> 'S"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += "SC6.C6_BLQ <> 'R"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += "SC6.C6_PRODUTO = '"+cProduto+"' AND "
		cQuery += "SC5.C5_FILIAL  = SA1.A1_FILIAL AND " 
		cQuery += "SC5.C5_FILIAL = SC6.C6_FILIAL AND "
		cQuery += "SC5.C5_NUM     = SC6.C6_NUM AND "
		cQuery += "SC5.C5_CLIENTE = SA1.A1_COD AND "
		cQuery += "SC5.C5_LOJACLI = SA1.A1_LOJA AND "
		
		cQuery += "SC9.C9_PEDIDO  = SC6.C6_NUM AND "
		cQuery += "SC9.C9_CLIENTE = SC5.C5_CLIENTE AND "
		cQuery += "SC9.C9_LOJA    = SC5.C5_LOJACLI AND "
		cQuery += "SC9.C9_ITEM    = SC6.C6_ITEM  AND "
		cQuery += "SC9.C9_BLEST   = '  '  AND "
		cQuery += "SC9.C9_BLCRED  = '  ' AND "
		
		cQuery += "SC6.D_E_L_E_T_=' ' AND "
		cQuery += "SC5.D_E_L_E_T_=' ' AND "
		cQuery += "SF4.D_E_L_E_T_=' ' AND "
		cQuery += "SC9.D_E_L_E_T_=' ' AND "
		cQuery += "SA1.D_E_L_E_T_=' ' "
		
		MemoWrit("RESERVA.Sql",cQuery)   //   Apenas utilizado para validar a query.
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		aStru     := SC6->(dbStruct())
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery)
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		aStru     := SC5->(dbStruct())
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		
	#ELSE
		
		lQuery := .F.
		cAlias := "SC6"
		cQuery := ""
		cQuery := "C6_PRODUTO = '"+cProduto+"' .And. "
		cQuery += "(C6_BLQ<>'S ' .AND. C6_BLQ<>'R ' .And. "
		cQuery += "C6_QTDVEN<>C6_QTDENT) .OR. (C6_QTDVEN=C6_QTDENT .AND. DTOS(C6_ENTREG)>='"+DTOS(dDataBase-31)+"')"
		Set Filter To &cQuery
		MsSeek(xFilial("SC6"))
		
	#ENDIF
	
	While !(cAlias)->( Eof() )
		
		lContinua := .T.
		
		If !lQuery
			DbSelectArea("SC5")
			DbSetorder(1)
			Dbseek(xFilial("SC5")+(cAlias)->C6_NUM)
			
			DbSelectArea("SA1")
			DbSetorder(1)
			Dbseek(xFilial("SA1")+(cAlias)->C6_CLI+(cAlias)->C6_LOJA)
			
			DbSelectArea("SC6")
		EndIf
		
		
		//	23.10.2006
		// RESERVA   - Para ser uma reserva e obrigatorio ter um registro no SC9 e o mesmo estar aguardando
		//             impressao de nota fiscal isto cacteriza uma reserva.
		// A FATURAR - Nao pode ter nenhum registro do item gravado no SC9 ou ter SC9 bloqueado
		// ------------------------------------------------------------------------------------------------
		DbSelectArea("SC9")
		DbSetOrder(1)
		If DbSeek( (cAlias)->C6_FILIAL+(cAlias)->C6_NUM+(cAlias)->C6_ITEM )
			lContinua:=.f.
			While !SC9->(EOF()) .and. (cAlias)->C6_FILIAL+(cAlias)->C6_NUM+(cAlias)->C6_ITEM = SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM)
				If Empty(SC9->C9_NFISCAL)
					lContinua:=.t.
				Endif
				SC9->(DBSKIP())
			Enddo
		Else
			lContinua:=.f.
		Endif
		// ------------------------------------------------------------------------------------------------
		
		
		If lContinua
			AADD(aCols8,Array(Len(_AHEADER)+1))
			nLin := Len(aCols8)
			aCols8[nLin,Len(_AHEADER)+1] := .F.
			
			aCols8[nLin][1]      := NomeFil((cAlias)->C6_FILIAL,_aFilSmo)
			aCols8[nLin][2]      := NomeArm((cAlias)->C6_LOCAL,_aNomeAlm)
			aCols8[nLin][3]      := (cAlias)->C9_QTDLIB //(cAlias)->C6_QTDEMP  // //ALMEIDA 13/04/06- JOAO ESTA VALIDANDO.
			aCols8[nLin][4]      := Iif(lQuery,(cAlias)->C6_NUM,SC5->C6_NUM )
			aCols8[nLin][5]      := Iif(lQuery,(cAlias)->C5_VEND1  ,SC5->C5_VEND1   )
			aCols8[nLin][6]      := Iif(lQuery,(cAlias)->C5_X_DTPRE,SC5->C5_X_DTPRE )
			aCols8[nLin][7]      := Iif(lQuery,(cAlias)->A1_NOME   ,SA1->A1_NOME    )
			aCols8[nLin][8]      := "."
		Endif
		
		
		(cAlias)->(Dbskip())
		
	EndDo
	
	
	If  lQuery
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	Endif
	
	if Len(aCols8) = 0
		AADD(aCols8,Array(Len(_AHEADER)+1))
		nLin := Len(aCols8)
		aCols8[nLin,Len(_AHEADER)+1] := .F.
		aCols8:=PrencAcols(aCols8,_AHEADER)
	Endif
	
	
ELSEIf Objetivo $ "FATURAR"  // PODE SER ITENS BLOQUEADOS OU CUJO O PEDIDO NAO FOI LIBERADO AINDA.
	
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC6->(dbStruct())
		lQuery    := .T.
		cAlias := "SC1MA215PROC"
		
		//
		// Busca todos os itens a Faturar
		//
		
		// Na Query 1 a)Estamos tratando pedidos liberados parcialmente Item sem bloqueio de estoque     desconto RESERVA
		//            b)Estamos tratando pedidos liberados parcialmente Item com bloqueio de estoque nao desconto RESERVA
		//            c)Estamos tratando item sem liberacao de estoque.
		
		// Na Query 2 a)Estamos tratando pedidos Faturado parcialmente, ou seja tem diferanca a faturar que nao esta RESERVA
		//              exemplo vendou 60 pecas faturou parcial 15 saldo a faturar bloqueado de 45
		
		cQuery := ""
		cQuery += "SELECT SC6.C6_FILIAL , SC6.C6_LOCAL, SC6.C6_QTDVEN , SC6.C6_QTDENT , SC6.C6_QTDEMP , SC6.C6_NUM , SC6.C6_ITEM, SC6.C6_ENTREG ,  SC5.C5_VEND1 , SA1.A1_NOME , SC5.C5_X_DTPRE , SC6.C6_NOTA , SC6.R_E_C_N_O_  ,  '1' AS QUERY , "
		cQuery += _nD_ENTER+" SC6.C6_BLQ,	' '  AS C9_BLEST, ' '  AS C9_BLOQUEI,  0 AS C9_QTDLIB "
		cQuery += _nD_ENTER+" FROM "+RetSqlName("SC6")+" (NOLOCK)  SC6, "
		cQuery += _nD_ENTER+RetSqlName("SC5")+"  (NOLOCK) SC5, "
		cQuery += _nD_ENTER+RetSqlName("SF4")+"  (NOLOCK) SF4, "
		cQuery += _nD_ENTER+RetSqlName("SA1")+"  (NOLOCK) SA1  "
		cQuery += _nD_ENTER+"WHERE "
		
		cQuery += _nD_ENTER+"SC6.C6_FILIAL<>'  ' AND "
		cQuery += _nD_ENTER+"SC5.C5_FILIAL<>'  ' AND "
		cQuery += _nD_ENTER+"SF4.F4_FILIAL ='  ' AND "
		cQuery += _nD_ENTER+"SA1.A1_FILIAL<>'  ' AND "
		
		cQuery += _nD_ENTER+"SF4.F4_CODIGO = SC6.C6_TES AND "
		
		cQuery += _nD_ENTER+"SC5.C5_FILIAL = SC6.C6_FILIAL AND "
		cQuery += _nD_ENTER+"SC5.C5_NUM    = SC6.C6_NUM AND "
		
		
		cQuery += _nD_ENTER+"SA1.A1_FILIAL = SC5.C5_FILIAL  AND "
		cQuery += _nD_ENTER+"SA1.A1_COD    = SC5.C5_CLIENTE AND "
		cQuery += _nD_ENTER+"SA1.A1_LOJA   = SC5.C5_LOJACLI AND "
		
		
		cQuery += _nD_ENTER+"SF4.F4_ESTOQUE = 'S'  AND "
		cQuery += _nD_ENTER+"SC6.C6_BLQ  <> 'S"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += _nD_ENTER+"SC6.C6_BLQ  <> 'R"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += _nD_ENTER+"SC6.C6_NOTA  = '" +Space(Len(SC6->C6_NOTA)) +"' AND "
		cQuery += _nD_ENTER+"SC6.C6_PRODUTO = '"+cProduto+"' AND "
		
		cQuery += _nD_ENTER+"SC6.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SC5.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SF4.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SA1.D_E_L_E_T_=' '     "
		
		cQuery += _nD_ENTER+" UNION "
		
		//
		// Este union tem como objetivo buscar os pedidos que ja foram faturados parcialmente ou seja
		// a query e igual a de cima mas o numero de nota fiscal deve ser preenchido isto garante que nao
		// seja duplica  informacoes na juncao destas duas query e o C6_QTDVEN <> C6_QTDENT garante pergarmos
		// somente os casos que estao como parcial.
		//
		
		cQuery += _nD_ENTER+"SELECT SC6.C6_FILIAL , SC6.C6_LOCAL, SC6.C6_QTDVEN , SC6.C6_QTDENT , SC6.C6_QTDEMP , SC6.C6_NUM ,SC6.C6_ITEM, SC6.C6_ENTREG ,  SC5.C5_VEND1 , SA1.A1_NOME , SC5.C5_X_DTPRE , SC6.C6_NOTA , SC6.R_E_C_N_O_ ,  '2' AS QUERY ,"
		cQuery += _nD_ENTER+" SC6.C6_BLQ, '' AS C9_BLEST , '' AS C9_BLOQUEI,0 AS C9_QTDLIB"
		cQuery += _nD_ENTER+" FROM "+RetSqlName("SC6")+" (NOLOCK)  SC6, "
		cQuery += _nD_ENTER+RetSqlName("SC5")+" (NOLOCK)  SC5, "
		cQuery += _nD_ENTER+RetSqlName("SF4")+" (NOLOCK)  SF4, "
		cQuery += _nD_ENTER+RetSqlName("SA1")+" (NOLOCK)  SA1  "
		cQuery += _nD_ENTER+"WHERE "
		
		cQuery += _nD_ENTER+"SC6.C6_FILIAL<>'  ' AND "
		cQuery += _nD_ENTER+"SC5.C5_FILIAL<>'  ' AND "
		cQuery += _nD_ENTER+"SF4.F4_FILIAL ='  ' AND "
		cQuery += _nD_ENTER+"SA1.A1_FILIAL<>'  ' AND "
		
		cQuery += _nD_ENTER+"SF4.F4_CODIGO = SC6.C6_TES AND "
		
		cQuery += _nD_ENTER+"SC5.C5_FILIAL = SC6.C6_FILIAL AND "
		cQuery += _nD_ENTER+"SC5.C5_NUM    = SC6.C6_NUM AND "
		
		cQuery += _nD_ENTER+"SA1.A1_FILIAL = SC5.C5_FILIAL  AND "
		cQuery += _nD_ENTER+"SA1.A1_COD    = SC5.C5_CLIENTE AND "
		cQuery += _nD_ENTER+"SA1.A1_LOJA   = SC5.C5_LOJACLI AND "
		
		
		cQuery += _nD_ENTER+"SF4.F4_ESTOQUE = 'S'  AND "
		cQuery += _nD_ENTER+"SC6.C6_BLQ  <> 'S"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += _nD_ENTER+"SC6.C6_BLQ  <> 'R"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		cQuery += _nD_ENTER+"SC6.C6_NOTA <> '" +Space(Len(SC6->C6_NOTA))+"' AND "  // DIFERENCA DA QUERY ANTERIOR
		cQuery += _nD_ENTER+"SC6.C6_PRODUTO = '"+cProduto+"' AND "
		
		cQuery += _nD_ENTER+"SC6.C6_QTDVEN <>  SC6.C6_QTDENT AND "                  // DIFERENCA DA QUERY ANTERIOR
		
		cQuery += _nD_ENTER+"SC6.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SC5.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SF4.D_E_L_E_T_=' ' AND "
		cQuery += _nD_ENTER+"SA1.D_E_L_E_T_=' ' "
		
		MemoWrit("AFATURAR.Sql",cQuery)   //   Apenas utilizado para validar a query.
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
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
		
	#ELSE
		
		lQuery := .F.
		cAlias := "SC6"
		cQuery := ""
		cQuery := "C6_PRODUTO = '"+cProduto+"' .And. "
		cQuery += "(C6_BLQ<>'S ' .AND. C6_BLQ<>'R ' .And. "
		cQuery += "C6_QTDVEN<>C6_QTDENT) .OR. (C6_QTDVEN=C6_QTDENT .AND. DTOS(C6_ENTREG)>='"+DTOS(dDataBase-31)+"')"
		Set Filter To &cQuery
		MsSeek(xFilial("SC6"))
		
	#ENDIF
	
	While !(cAlias)->( Eof() )
		
		lContinua := .T.
		
		
		// Na Query 1 a)Estamos tratando pedidos liberados parcialmente Item sem bloqueio de estoque     desconto RESERVA
		//            b)Estamos tratando pedidos liberados parcialmente Item com bloqueio de estoque nao desconto RESERVA
		
		
		// Na Query 2 a)Estamos tratando pedidos Faturado parcialmente, ou seja tem diferanca a faturar que nao esta RESERVA
		//              exemplo vendou 60 pecas faturou parcial 15 saldo a faturar bloqueado de 45
		
		If (cAlias)->QUERY = "1"
			
			
			//
			// Este seek trata a situacao (A),(B) da Query 1 ou seja o item foi Liberado mas tenho que analisar se "
			// ha Bloqueio de estoque.
			//
			lC9_BLEST:=.f.
			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek((cAlias)->C6_FILIAL+(cAlias)->C6_NUM+(cAlias)->C6_ITEM)
				lC9_BLEST:= EMPTY(SC9->C9_BLEST)
			Endif
			
			If  lC9_BLEST
				// Parcial
				nFatura:= (cAlias)->C6_QTDVEN - (cAlias)->C6_QTDEMP
			Else
				//
				// Este seek trata a situacao (C) da Query 1 - Item nao foi liberado."
				//
				nFatura:= (cAlias)->C6_QTDVEN
			Endif
			
			
		Else
			
			nReserva := 0			

			DbSelectArea("SC9")  //	23.10.2006 - ALTERACAO MOTIVO NAO PODEM INTRAR COMO FATURADOS ITENS QUE CONTENHAM SB9 (RESERVA)
			DbSetOrder(1)
			If DbSeek((cAlias)->C6_FILIAL+(cAlias)->C6_NUM+(cAlias)->C6_ITEM)
            While (cAlias)->C6_FILIAL+(cAlias)->C6_NUM+(cAlias)->C6_ITEM = SC9->C9_FILIAL+C9_PEDIDO+C9_ITEM
                  If Empty(SC9->C9_NFISCAL) .and. Empty(SC9->C9_BLEST)
                     nReserva  := nReserva + SC9->C9_QTDLIB  // Pronta para Faturar
                  Endif   
                  SC9->(DBSKIP())
            Enddo
         Endif
                                 
         // TOTAL A FATURAR  =  QUANTIDADE VENDIDA   -   QUANTIDADE FATURADA   -   QUANTIDADE RESERVADA
			nFatura:= (cAlias)->C6_QTDVEN - (cAlias)->C6_QTDENT - nReserva

		Endif
		
		
		lContinua:=IIf(nFatura=0,.F.,.T.)
		
		
		If lContinua
		

			DbSelectArea("SC5")
			DbSetOrder(1)
			Dbseek((cAlias)->C6_FILIAL+(cAlias)->C6_NUM)
			If  SC5->C5_TIPO $ 'D|B'
    			_cNome := POSICIONE("SA2",1,(cAlias)->C6_FILIAL+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NREDUZ")
			Else
    			_cNome := POSICIONE("SA1",1,(cAlias)->C6_FILIAL+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
			Endif
			
			//Faturar
			AADD(aCols10,Array(Len(_AHEADER)+1))
			nLin := Len(aCols10)
			aCols10[nLin,Len(_AHEADER)+1] := .F.
			
			aCols10[nLin][1]      := NomeFil((cAlias)->C6_FILIAL,_aFilSmo)
			aCols10[nLin][2]      := NomeArm((cAlias)->C6_LOCAL,_aNomeAlm)
			aCols10[nLin][3]      := nFatura
			aCols10[nLin][4]      := Iif(lQuery,(cAlias)->C6_NUM,SC5->C6_NUM )
			aCols10[nLin][5]      := Iif(lQuery,(cAlias)->C5_VEND1  ,SC5->C5_VEND1   )
			aCols10[nLin][6]      := Iif(lQuery,(cAlias)->C5_X_DTPRE,SC5->C5_X_DTPRE )
			aCols10[nLin][7]      := _cNome  //Iif(lQuery,(cAlias)->A1_NOME   ,SA1->A1_NOME    )
			aCols10[nLin][8]      := "."
			
		Endif
		
		(cAlias)->(Dbskip())
		
	EndDo
	
	
	If  lQuery
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	Endif
	
	if Len(aCols10) = 0
		AADD(aCols10,Array(Len(_AHEADER)+1))
		nLin := Len(aCols10)
		aCols10[nLin,Len(_AHEADER)+1] := .F.
		aCols10:=PrencAcols(aCols10,_AHEADER)
	Endif
	
ELSEIf Objetivo $ "TRANSITO"  // Importacoes
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados acumulados da Solicitacao de Compra         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC1->(dbStruct())
		lQuery    := .T.
		cAlias := "SC1MA215PROC"
		
		cQuery := ""
		cQuery := "SELECT SC1.C1_FILIAL , SC1.C1_LOCAL, SC1.C1_QUJE , SC1.C1_QUANT , SC1.C1_NUM , SC1.C1_DATPRF , SC1.C1_OBS "
		cQuery += "FROM "+RetSqlName("SC1")+"  (NOLOCK) SC1 "
		cQuery += "WHERE "
		cQuery += "SC1.C1_FILIAL<>'  ' AND "
		cQuery += "SC1.C1_RESIDUO<>'S' AND "
		cQuery += "SC1.C1_QUANT - SC1.C1_QUJE > 0  AND "
		//cQuery += "SC1.C1_QUJE < SC1.C1_QUANT AND "
		cQuery += "SC1.C1_PRODUTO = '"+cProduto+"' AND "
		cQuery += "SC1.D_E_L_E_T_=' ' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery)
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	#ELSE
		
		lQuery := .F.
		cAlias := "SC1"
		cQuery := ""
		//cQuery := "C1_FILIAL=='"+xFilial("SC1")+"' .And. "
		cQuery += "C1_QUJE < C1_QUANT .And."
		cQuery += "C1_PRODUTO = '"+cProduto+"'"
		Set Filter To &cQuery
		MsSeek(xFilial("SC1"))
		
	#ENDIF
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados acumulados da Solicitacao de compra         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		lContinua := .T.
		
		If !lQuery
			// Caso se relacione com outra tabela
		EndIf
		
		
		If lContinua
			
			//Transito
			AADD(ACOLS6,Array(Len(_AHEADER)+1))
			nLin := Len(ACOLS6)
			ACOLS6[nLin,Len(_AHEADER)+1] := .F.
			ACOLS6[nLin][01]      := NomeFil((cAlias)->C1_FILIAL,_aFilSmo)
			ACOLS6[nLin][02]      := NomeArm((cAlias)->C1_LOCAL,_aNomeAlm)
			ACOLS6[nLin][03]      := (cAlias)->C1_QUANT - (cAlias)->C1_QUJE
			ACOLS6[nLin][04]      := (cAlias)->C1_NUM  // Num. Solicitacao
			ACOLS6[nLin][05]      := ""                 // Num. PC
			ACOLS6[nLin][06]      := ""                 // Num. OP
			ACOLS6[nLin][07]      := CTOD("")
			//			ACOLS6[nLin][08]      := CTOD("")
			//			ACOLS6[nLin][09]      := CTOD("")
			ACOLS6[nLin][08]      := (cAlias)->C1_OBS
			aCols6[nLin][09]      := "."
			
			
			
			
		EndIf
		
		(cAlias)->(DbSkip())
	EndDo
	If lQuery
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SC1")
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados acumulados do Pedido de Compra              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC7->(dbStruct())
		lQuery    := .T.
		cAlias := "SC7MA215PROC"
		
		cQuery := ""
		cQuery := "SELECT SC7.C7_FILIAL , SC7.C7_LOCAL, SC7.C7_QUJE , SC7.C7_QUANT , SC7.C7_NUM , SC7.C7_X_DTCON , SC7.C7_NUMIMP , SC7.C7_ITEM, SC7.C7_OBS "
		cQuery += "FROM "+RetSqlName("SC7")+" (NOLOCK) SC7 "
		cQuery += "WHERE "
		cQuery += "SC7.C7_FILIAL<>'  ' AND "
		cQuery += "SC7.C7_QUANT - SC7.C7_QUJE > 0  AND "
		//cQuery += "SC7.C7_QUJE < C7_QUANT AND "
		cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "
		cQuery += "SC7.C7_PRODUTO = '"+cProduto+"' AND "
		cQuery += "SC7.D_E_L_E_T_=' ' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery )
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		
	#ELSE
		
		lQuery := .F.
		cAlias := "SC7"
		cQuery  := ""
		//cQuery := "C7_FILIAL=='"+xFilial("SC7")+"' .And. "
		cQuery += "C7_QUJE < C7_QUANT .And. "
		cQuery += "C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' .And. "
		cQuery += "C7_PRODUTO = '"+cProduto+"'"
		Set Filter To &cQuery
		MsSeek(xFilial("SC7"))
		
	#ENDIF
	
	While !Eof() //    .And. (cAlias)->C7_FILIAL == xFilial("SC7")
		lContinua := .T.
		
		If !lQuery
			// Caso se relacione com outra tabela
		EndIf
		
		If lContinua
			
			/*
			dDtEmbar := CTOD("")
			dDtEntre := CTOD("")
			cObs     := ""
			DbSelectArea("SW3")
			DbSetOrder(8)          // W3_PO_NUM + W3_POSICAO
			If DbSeek(xFilial("SW3")+(cAlias)->C7_NUMIMP+SPACE(15-LEN((cAlias)->C7_NUMIMP))+(cAlias)->C7_ITEM) // POSICIONA NO PO
			
			dDtEntre := SW3->W3_DT_ENTR
			dDtEmbar := SW3->W3_DT_EMB
			
			DbSelectArea("SW5")
			DbGoTop()
			DbOrderNickname("PONUM")   // W5_PO_NUM+W5_POSICAO  // POSICIONA NO PL
			If DbSeek(xFilial("SW5")+(cAlias)->C7_NUMIMP+SPACE(15-LEN((cAlias)->C7_NUMIMP))+(cAlias)->C7_ITEM)
			
			// DEVIDO MOTIVO ABAIXO CONSTRU O WHILE PARA PEGAR O ULTIMO REGISTRO QUE PROVAVELMENTE TEM O W5_HAWB PREENCHIDO
			//W5_PO_NUM  W5_POSICAO W5_HAWB
			//004135     0001        <BRANCO>
			//004135     0001        000050
			
			While !SW5->(EOF()) .and. xFilial("SW5")+(cAlias)->C7_NUMIMP+SPACE(15-LEN((cAlias)->C7_NUMIMP))+(cAlias)->C7_ITEM = SW5->(W5_FILIAL+W5_PO_NUM+W5_POSICAO)
			SW5->(DBSKIP())
			Enddo
			
			SW5->(DBSKIP(-1))
			cObs:=  StatusSW5()     // "Lendo Itens da L.I"
			If EmptY(cObs)
			cObs:=  StatusSW7()  // "Lendo Itens da D.I"
			dDtEmbar := SW6->W6_DT_EMB
			Endif
			
			Endif
			
			Endif
			*/
			
			
			//Transito
			AADD(ACOLS6,Array(Len(_AHEADER)+1))
			nLin := Len(ACOLS6)
			ACOLS6[nLin,Len(_AHEADER)+1] := .F.
			ACOLS6[nLin][01]      := NomeFil((cAlias)->C7_FILIAL,_aFilSmo)
			ACOLS6[nLin][02]      := NomeArm((cAlias)->C7_LOCAL,_aNomeAlm)
			ACOLS6[nLin][03]      := (cAlias)->C7_QUANT - (cAlias)->C7_QUJE
			ACOLS6[nLin][04]      := ""                                       // Num. Solicitacao
			ACOLS6[nLin][05]      := (cAlias)->C7_NUM+"-"+(cAlias)->C7_ITEM  // Num. PC
			ACOLS6[nLin][06]      := ""                                       // Num. OP
			ACOLS6[nLin][07]      := (cAlias)->C7_X_DTCON
			//			ACOLS6[nLin][08]      := dDtEmbar
			//			ACOLS6[nLin][09]      := dDtEntre
			ACOLS6[nLin][08]      := (cAlias)->C7_OBS  // If(!Empty(cObs),cObs,(cAlias)->C7_OBS)
			aCols6[nLin][09]      := "."
			
		EndIf
		DbSelectArea(cAlias)
		
		(cAlias)->(DbSkip())
		
	EndDo
	
	If lQuery
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SC7")
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados acumulados das Ordens de Producao           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC2")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SC2->(dbStruct())
		lQuery    := .T.
		cAlias := "SC2MA215PROC"
		
		cQuery := ""
		cQuery := "SELECT SC2.C2_FILIAL , SC2.C2_LOCAL, SC2.C2_QUJE , SC2.C2_QUANT , SC2.C2_PERDA, SC2.C2_NUM , SC2.C2_DATPRF , SC2.C2_OBS "
		cQuery += "FROM "+RetSqlName("SC2")+" (NOLOCK) SC2 "
		cQuery += "WHERE "
		//cQuery += "SC2.C2_FILIAL='"+xFilial("SC2")+"' AND "
		cQuery += "SC2.C2_QUANT-SC2.C2_QUJE-SC2.C2_PERDA>0 AND "
		cQuery += "((SC2.C2_DATRF='"+Dtos(Ctod(""))+"' AND "
		cQuery += "SC2.C2_QUANT-SC2.C2_QUJE-SC2.C2_PERDA>0) OR "
		cQuery += "(SC2.C2_DATRF<>'"+Dtos(Ctod(""))+"')) AND "
		cQuery += "SC2.C2_PRODUTO = '"+cProduto+"' AND "
		cQuery += "SC2.D_E_L_E_T_=' ' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		For nX := 1 To Len(aStru)
			If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery )
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	#ELSE
		
		lQuery := .F.
		cAlias := "SC2"
		cQuery := ""
		//cQuery := "C2_FILIAL='"+xFilial("SC2")+"' .And. "
		cQuery += "((C2_DATRF='"+Dtos(Ctod(""))+"' .And. "
		cQuery += "C2_QUANT-C2_QUJE-C2_PERDA>0) .OR. "
		cQuery += "(C2_DATRF<>'"+Dtos(Ctod(""))+"')) .AND. "
		cQuery += "C2_PRODUTO = '"+cProduto+"'"
		Set Filter To &cQuery
		MsSeek(xFilial("SC2"))
		
	#ENDIF
	
	While  !Eof()   //.And. (cAlias)->C2_FILIAL == xFilial("SC2") )
		lContinua := .T.
		
		If !lQuery
			// Caso se relacione com outra tabela
		EndIf
		
		If lContinua
			
			
			//Transito
			AADD(ACOLS6,Array(Len(_AHEADER)+1))
			nLin := Len(ACOLS6)
			ACOLS6[nLin,Len(_AHEADER)+1] := .F.
			ACOLS6[nLin][01]      := NomeFil((cAlias)->C2_FILIAL,_aFilSmo)
			ACOLS6[nLin][02]      := NomeArm((cAlias)->C2_LOCAL,_aNomeAlm)
			ACOLS6[nLin][03]      := (cAlias)->C2_QUANT - (cAlias)->C2_QUJE - (cAlias)->C2_PERDA
			ACOLS6[nLin][04]      := ""                 // Num. Solicitacao
			ACOLS6[nLin][05]      := ""                 // Num. PC
			ACOLS6[nLin][06]      := (cAlias)->C2_NUM  // Num. OP
			ACOLS6[nLin][07]      := (cAlias)->C2_DATPRF
			//ACOLS6[nLin][08]     := CTOD("")
			//ACOLS6[nLin][09]     := CTOD("")
			ACOLS6[nLin][08]     := (cAlias)->C2_OBS
			aCols6[nLin][09]     := "."
			
		EndIf
		
		(cAlias)->(DbSkip())
		
	EndDo
	If lQuery
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SC2")
		
	EndIf
	
	
	if Len(aCols6) = 0
		AADD(aCols6,Array(Len(_AHEADER)+1))
		nLin := Len(aCols6)
		aCols6[nLin,Len(_AHEADER)+1] := .F.
		aCols6:=PrencAcols(aCols6,_AHEADER)
		
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Saldo Empenhado:  Com base no SD4                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ELSEIf Objetivo $ "EMPENHADO"
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os dados acumulados dos empenhos da OP               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD4")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SD4->(dbStruct())
		lQuery    := .T.
		cAlias := "SD4MA215PROC"
		
		cQuery := ""
		cQuery := "SELECT SD4.D4_FILIAL, SD4.D4_LOCAL , SD4.D4_QUANT, SD4.D4_OP , SD4.D4_DATA "
		cQuery += "FROM "+RetSqlName("SD4")+"  (NOLOCK) SD4 "
		cQuery += "WHERE "
		cQuery += "SD4.D4_FILIAL='  ' AND "
		cQuery += "SD4.D4_COD = '"+cProduto+"' AND "
		cQuery += "SD4.D4_QUANT > 0 AND "
		cQuery += "SD4.D_E_L_E_T_=' ' "
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		For nX := 1 To Len(aStru)
			If  aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery
				TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
		
	#ELSE
		
		lQuery := .F.
		cAlias := "SD4"
		cQuery := ""
		//cQuery := "D4_FILIAL='"+xFilial("SD4")+"' .AND. "
		cQuery += "D4_COD = '"+cProduto+"' .AND. "
		cQuery += "D4_QUANT > 0 "
		Set Filter To &cQuery
		MsSeek(xFilial("SD4"))
		
	#ENDIF
	
	While !Eof()  //.And. (cAlias)->D4_FILIAL == xFilial("SD4")
		lContinua := .T.
		
		If !lQuery
			// Caso se relacione com outra tabela
		EndIf
		
		If lContinua
			
			AADD(aCols7,Array(Len(_AHEADER)+1))
			nLin := Len(aCols7)
			aCols7[nLin,Len(_AHEADER)+1] := .F.
			aCols7[nLin][1]      := NomeFil((cAlias)->D4_FILIAL,_aFilSmo)
			aCols7[nLin][2]      := NomeArm((cAlias)->D4_LOCAL,_aNomeAlm)
			aCols7[nLin][3]      := (cAlias)->D4_QUANT
			aCols7[nLin][4]      := (cAlias)->D4_OP
			aCols7[nLin][5]      := (cAlias)->D4_DATA
			aCols7[nLin][6]      := "."
			
		EndIf
		
		(cAlias)->(DbSkip())
		
	EndDo
	
	If lQuery
		dbSelectArea(cAlias)
		dbCloseArea()
		dbSelectArea("SD4")
	EndIf
	
	
	if Len(aCols7) = 0
		AADD(aCols7,Array(Len(_AHEADER)+1))
		nLin := Len(aCols7)
		aCols7[nLin,Len(_AHEADER)+1] := .F.
		aCols7:=PrencAcols(aCols7,_AHEADER)
	Endif
	
Endif


Return




Static Function NomeFil(_cFil,_aFilSmo)
Local nPos     := aScan(_aFilSmo,{|x| AllTrim(x[1])==_cFil })
Local cConteudo:= _cFil + " - " + (IIf(nPos <> 0 , _aFilSmo[nPos][2] ,"" ))
Return(cConteudo)

Static Function NomeArm(_cLocal,_aNomeAlm)
Local nPos     := aScan(_aNomeAlm,{|x| AllTrim(x[1])==_cLocal })
Local cConteudo:= _cLocal + " - " + (IIf(nPos <> 0 , _aNomeAlm[nPos][2],"Nome do Arm. Nao Cadastrado" ))
Return(cConteudo)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do Mfatc01                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlgCons: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RfatBar(oDlgCons,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

aadd(aButtons,{"POSCLI",{|| U_CONSEIC()  }, "Consulta Itens de Importacao" })

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TrataEIS  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Trara Codigo Eis retornando todas as informacoes posiveis   º±±
±±º          ³                                                            º±±
±±ºParametro ³Codigo do Produto                                           º±±
±±º          ³                                                            º±±
±±ºRetorna   ³aResult[1 a 10,1]  Codigo Eis de 1 a 10                     º±±
±±º          ³aResult[1 a 10,1]  Caracteristica da Posicao                º±±
±±º          ³aResult[1 a 10,1]  Codigo Eis Concatenado                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TrataEIS(cProduto)
Local  aGetArea:= GetArea()
Local  nY     := 0
Local  aResult:= {}

Local  cEisCod1:=cEisCod2:=cEisCod3:=cEisCod4:=cEisCod5:=cEisCod6:=cEisCod7:=cEisCod8:=cEisCod9:=cEisCod10 := "00"
Local  cEisDes1:=cEisDes2:=cEisDes3:=cEisDes4:=cEisDes5:=cEisDes6:=cEisDes7:=cEisDes8:=cEisDes9:=cEisDes10 := "Classificacao nao Encontra"
Local  cCodEIS := "0000000000000000000"


DbSelectArea("SB1")
DbSetOrder(1)
If !Dbseek(xFilial("SB1")+cProduto)
	
	AADD(aResult,{cEisCod1,cEisDes1,cCodEIS})
	AADD(aResult,{cEisCod2,cEisDes2,cCodEIS})
	AADD(aResult,{cEisCod3,cEisDes3,cCodEIS})
	AADD(aResult,{cEisCod4,cEisDes4,cCodEIS})
	AADD(aResult,{cEisCod5,cEisDes5,cCodEIS})
	AADD(aResult,{cEisCod6,cEisDes6,cCodEIS})
	AADD(aResult,{cEisCod7,cEisDes7,cCodEIS})
	AADD(aResult,{cEisCod8,cEisDes8,cCodEIS})
	AADD(aResult,{cEisCod9,cEisDes9,cCodEIS})
	AADD(aResult,{cEisCod10,cEisDes10,cCodEIS})
	
Else
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rastreando informacoes do EIS        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cEisCod1 := SB1->B1_X_EIS01
	cEisCod2 := SB1->B1_X_EIS02
	cEisCod3 := SB1->B1_X_EIS03
	cEisCod4 := SB1->B1_X_EIS04
	cEisCod5 := SB1->B1_X_EIS05
	cEisCod6 := SB1->B1_X_EIS06
	cEisCod7 := SB1->B1_X_EIS07
	cEisCod8 := SB1->B1_X_EIS08
	cEisCod9 := SB1->B1_X_EIS09
	cEisCod10:= SB1->B1_X_EIS10
	
	cCodEIS  := cEisCod1+cEisCod2+cEisCod3+cEisCod4+;
	cEisCod5+cEisCod6+cEisCod7+cEisCod8+;
	cEisCod9+cEisCod10
	
	
	DbSelectArea("Z01")
	If Dbseek(xFilial("Z01")+cEisCod1)
		cEisDes1 := Z01->Z01_DESC01
	Endif
	
	DbSelectArea("Z02")
	If Dbseek(xFilial("Z02")+cEisCod1+cEisCod2)
		cEisDes2 := Z02->Z02_DESC02
	Endif
	
	DbSelectArea("Z03")
	If Dbseek(xFilial("Z03")+cEisCod1+cEisCod2+cEisCod3)
		cEisDes3 := Z03->Z03_DESC03
	Endif
	
	DbSelectArea("Z04")
	If Dbseek(xFilial("Z04")+cEisCod1+cEisCod2+cEisCod3+cEisCod4)
		cEisDes4 := Z04->Z04_DESC04
	Endif
	
	DbSelectArea("Z05")
	If Dbseek(xFilial("Z05")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5)
		cEisDes5 := Z05->Z05_DESC05
	Endif
	
	DbSelectArea("Z06")
	If Dbseek(xFilial("Z06")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6)
		cEisDes6 := Z06->Z06_DESC06
	Endif
	
	DbSelectArea("Z07")
	If Dbseek(xFilial("Z07")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7)
		cEisDes7 := Z07->Z07_DESC07
	Endif
	
	DbSelectArea("Z08")
	If Dbseek(xFilial("Z08")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8)
		cEisDes8 := Z08->Z08_DESC08
	Endif
	
	DbSelectArea("Z09")
	If Dbseek(xFilial("Z09")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8+cEisCod9)
		cEisDes9 := Z09->Z09_DESC09
	Endif
	
	DbSelectArea("Z10")
	If Dbseek(xFilial("Z10")+cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8+cEisCod9+cEisCod10)
		cEisDes10 := Z10->Z10_DESC10
	Endif
	
	
	AADD(aResult,{cEisCod1,cEisDes1,cCodEIS})
	AADD(aResult,{cEisCod2,cEisDes2,cCodEIS})
	AADD(aResult,{cEisCod3,cEisDes3,cCodEIS})
	AADD(aResult,{cEisCod4,cEisDes4,cCodEIS})
	AADD(aResult,{cEisCod5,cEisDes5,cCodEIS})
	AADD(aResult,{cEisCod6,cEisDes6,cCodEIS})
	AADD(aResult,{cEisCod7,cEisDes7,cCodEIS})
	AADD(aResult,{cEisCod8,cEisDes8,cCodEIS})
	AADD(aResult,{cEisCod9,cEisDes9,cCodEIS})
	AADD(aResult,{cEisCod10,cEisDes10,cCodEIS})
	
Endif


RestArea(aGetArea)

Return(aResult)






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³DefPasta³ Autor ³Paulo Emidio de Barros ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza a selecao na mudanca de Folder dos Ensaios vincula-³±±
±±³			 ³ dos ao Laboratorio selecionado							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DefPasta(EXPN1,EXPN2,EXPN3,EXPN4,EXPO1,EXPC7,EXPL1)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao do Laboratorio corrente					  ³±±
±±³			 ³ EXPN2 = Posicao do ensaio corrente						  ³±±
±±³			 ³ EXPN3 = Posicao do Folder da medicao atual			      ³±±
±±³			 ³ EXPN4 = Posicao do ultimo Folder selecionado			      ³±±
±±³			 ³ EXPO1 = Objeto da Cronica							      ³±±
±±³			 ³ EXPL1 = verifica se os Instrumentos sao obrigatorios		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIEA215()  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefPasta(nGotMed,nLostMed)
Local lRetorno := .T.
Local nInsVzo  := 0
Local nQtdMed  := 0
Local nX       := 0
Local nY       := 0



If nGotMed # NIL
	If nGotMed   = 1 //Disponivel
		aHeader := aClone(aHeader2)
		nUsado  := Len(aHeader2)
		aCols   := aClone(aCols2)
		N 		:= 1
		oGet02:oBrowse:lDisablePaint:= .F.
		oGet02:oBrowse:Refresh(.T.)
	Elseif nGotMed = 2 //Malha
		aHeader := aClone(aHeader1)
		nUsado  := Len(aHeader1)
		aCols   := aClone(aCols1)
		N 		:= 1
		oGet01:oBrowse:lDisablePaint:= .F.
		oGet01:oBrowse:Refresh(.T.)
	Elseif nGotMed = 3 //Matriz
		aHeader := aClone(aHeader3)
		nUsado  := Len(aHeader3)
		aCols   := aClone(aCols3)
		N 		:= 1
		oGet03:oBrowse:lDisablePaint:= .F.
		oGet03:oBrowse:Refresh(.T.)
	Elseif nGotMed = 4 //Filial
		aHeader := aClone(aHeader4)
		nUsado  := Len(aHeader4)
		aCols   := aClone(aCols4)
		N 		:= 1
		oGet04:oBrowse:lDisablePaint:= .F.
		oGet04:oBrowse:Refresh(.T.)
	Elseif nGotMed = 5 //Consigado
		aHeader := aClone(aHeader5)
		nUsado  := Len(aHeader5)
		aCols   := aClone(aCols5)
		N 		:= 1
		oGet05:oBrowse:lDisablePaint:= .F.
		oGet05:oBrowse:Refresh(.T.)
	Elseif nGotMed = 6 //Transito
		aHeader := aClone(aHeader6)
		nUsado  := Len(aHeader6)
		aCols   := aClone(aCols6)
		N 		:= 1
		oGet06:oBrowse:lDisablePaint:= .F.
		oGet06:oBrowse:Refresh(.T.)
	Elseif nGotMed = 7 //Reservado
		aHeader := aClone(aHeader8)
		nUsado  := Len(aHeader8)
		aCols   := aClone(aCols8)
		N 		:= 1
		oGet08:oBrowse:lDisablePaint:= .F.
		oGet08:oBrowse:Refresh(.T.)
	Elseif nGotMed = 8 //Empenhado
		aHeader := aClone(aHeader7)
		nUsado  := Len(aHeader7)
		aCols   := aClone(aCols7)
		N 		:= 1
		oGet07:oBrowse:lDisablePaint:= .F.
		oGet07:oBrowse:Refresh(.T.)
	Elseif nGotMed = 9 //Classificar
		aHeader := aClone(aHeader9)
		nUsado  := Len(aHeader9)
		aCols   := aClone(aCols9)
		N 		:= 1
		oGet09:oBrowse:lDisablePaint:= .F.
		oGet09:oBrowse:Refresh(.T.)
	Elseif nGotMed = 10 //Faturar
		aHeader := aClone(aHeader10)
		nUsado  := Len(aHeader10)
		aCols   := aClone(aCols10)
		N 		:= 1
		oGet10:oBrowse:lDisablePaint:= .F.
		oGet10:oBrowse:Refresh(.T.)
	EndIf
	
Endif


Return(lRetorno)


Static Function PrencAcols(_aCols,_AHEADER)

For nY:= 1 to len(_aHeader)
	if      _aHeader[ny][8]== "N"
		_aCOLS[1][ny]:= 0
	Elseif  _aHeader[ny][8]== "D"
		_aCOLS[1][ny]:= dDataBase
	Elseif  _aHeader[ny][8]== "C"
		_aCOLS[1][ny]:= ""
	Endif
Next nY

Return(_aCols)

/*

FILIAL   PRODUTO   ALMOX   QUANT.FIS

01       10        01        10
01       10        02        10
01       10        03        10
01       20        01        10
01       20        02        10
01       20        03        10
02       10        01        10
02       10        02        10
02       10        03        10
02       20        01        10
02       20        02        10
02       20        03        10

*/


User Function CONSEIC()
EICIP175()
Return
//Static Function MenuDef() 

// U_MFATC02B()                                                                                                                                                                                            
// QUE CHAMA A U_MFATC03() QUE ROTINA ABAIXO   

// REFERENCIA 200KBE  SKU 125655

//Local aBkRotina:=aRotina := {}
//Local aBkRotina:=aRotina := {}
//Private cAvStaticCall := "EICIP175"/
//Local aRotinaaBkRotina:=aRotina := {}

//Return StaticCall(EICIP170, MenuDef) 
