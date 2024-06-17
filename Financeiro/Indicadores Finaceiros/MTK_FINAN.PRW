#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

#DEFINE X_PESQUISA		    	1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTK_FINAN ºAutor  ³                    º Data ³  22/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de Consulta de Estatisticas Financeiras                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTK_FINAN()

Local  cCadastro   := "Indicadores de Performace Impresarial"
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
Local  nFldMed     := 0        //Posicao do Folder corrente

Local  oDlgCons
                    
Local bSetKey4

Local cFABRI    := GetMark()
Local lInverte  := .f.
Private cArqB1   := ""
Private _cArqPRO := ""
Private aStru2   :={}
Private aCampos  :={}


Private _ColAno    := 0
Private  aTitles   := {}
Private oGet00,oGet01,oGet02,oGet03,oGet04,oGet05,oGet06,oGet07,oGet08,oGet09,oGet10
Private lInfMed    := .T.
Private nFldAnt    := 1    //Posicao do ultimo Folder selecionado
Private nControGD  := 0    // variavel para controle da ultima GETDADOS editada devido ao problema de que quando se esta editando a getdados e depois clica direto no OK nao e' executado o CODBLOCK de LOSTFOCUS da GETDADOS.
Private aCols0     := {}
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

Private aHeader0,aHeader1,aHeader2,aHeader3,aHeader4,aHeader5,aHeader6,aHeader7,aHeader8,aHeader9,aHeader10

Private aSvHeader  := {}
Private aSvCols    := {}

Private cProduto
PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Existem locais em que esta rotina e chamada de dentro de um acols        ³
//³por este motivo e necessario guardar o acols anterior antes de proceguir.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aCols      :={}
Private aHeader    :={}
Private aDefAno    :={}
Private aNPasta    :={}

Private nTotMes    :=6 

Private _cAnoAtu  := SUBSTR(DTOS(dDataBase),1,4)     //2
Private _nAnoIni  := val(substr(_cAnoAtu,2,3))-(nTotMes)     //0006-6=0000
Private dDataIni  := DTOS(ctod("01/01/"+substr(_cAnoAtu,1,1)+strzero(_nAnoIni,3)))  // Data Inicial
Private dDataFin  := DTOS(LastDaY(Ctod("01/12/"+STR(YEAR(dDataBase)))))              // Data Final
Private nY        := 0
Private nValor    := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPages ,"HEADER 1")
AADD(aTitles,"PMR")
Aadd(aNPasta,"Prazo Medio de Recebimento") // Nome da Pasta

Aadd(aPages,"HEADER 2")
AADD(aTitles,"PMP")
Aadd(aNPasta,"Prazo Medio de Pagamento")   // Nome da Pasta

Aadd(aPages,"HEADER 3")
AADD(aTitles,"PME")
Aadd(aNPasta,"Prazo Medio de Estoque")   // Nome da Pasta

/*
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
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Buscanda todas as informacoes  para  ³
//³ tela.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| InfoTela()},"Aguarde...Levantando Informacoes sobre o Produto")

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
bSetKey4  :=SetKey(VK_F4 , {|| DemForm() })

@ 015,005   TO 130,380 OF oDlgCons PIXEL
                                   
/*
aCols  := Aclone(acols0)
aHeader:= Aclone(aHeader0)
n      := 1
oGet00:=MSGetDados():New(015,005,130,380,nopcao,,.T.,,.F.,{},,,,,,,,)
oGet00:oBrowse:bGotFocus 	:={|| Fd_EntraSup(0,acols0,aHeader0)}
//oGet00:oBrowse:bLostFocus:={|| Fd_Sai(1)}
oGet00:oBrowse:Default()
oGet00:oBrowse:Refresh()
//oGet00:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
*/

oGet00:= MsSelect():New("TRB","T_OK",,aCampos,@lInverte,@cFABRI,{015,005,130,380})
//oGet00:bMark := {| | MfatDisp(oRefe,@cRefe,aStru,oMark)}   // Atualiza outras telas quando dispara o
//oMark:oBrowse:lhasMark = .t.                             // evento click
//oMark:oBrowse:lCanAllmark := .t.
//oMark:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark) } // Permite FABRIr um, inverter,
//oGet00:Browse:nFreeze := 3  // congelando estas colunas ocorre um "flicker" na tela
// oMark:oBrowse:nColPos := 1


aPosObj:={ {},{140,05,295,380}}

nBotFd   := (aPosObj[2,3]-aPosObj[2,1])
nRigFd   := (aPosObj[2,4]-aPosObj[2,2])
nBotGetD := (aPosObj[2,3]-aPosObj[2,1]-15)
nRigGetD := (aPosObj[2,4]-aPosObj[2,2]-2)

oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,aPages,oDlgCons,,,,.T.,.F.,nRigFd,nBotFd,)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 01	- Prazo Medio de Recebimento|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols  := Aclone(acols1)
aHeader:= Aclone(aHeader1)
n      := 1

oGet01:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[1])
oGet01:oBrowse:bGotFocus 	:={|| Fd_Entra(1,acols1,aHeader1)}
//oGet01:oBrowse:bLostFocus:={|| Fd_Sai(1)}
oGet01:oBrowse:Default()
oGet01:oBrowse:Refresh()
//oGet01:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 02	- Prazo Medio de Pagamento  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols  := Aclone(acols2)
aHeader:= Aclone(aHeader2)
n      := 1

oGet02:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[2])
oGet02:oBrowse:bGotFocus 	:={|| Fd_Entra(2,acols2,aHeader2)}
//oGet02:oBrowse:bLostFocus:={|| Fd_Sai(1)}
oGet02:oBrowse:Default()
oGet02:oBrowse:Refresh()
//oGet02:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 03	- Prazo Medio de Estoque    |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols  := Aclone(aCols3)
aHeader:= Aclone(aHeader3)
n      := 1

oGet03:= MSGetDados():New(0,0,nBotGetd,nRigGetd,nOpcao,cLinOK,cTudOk,,lGetD,,3,,,,,,,oFolder:aDialogs[3])
oGet03:oBrowse:bGotFocus 	:={|| Fd_Entra(2,aCols3,aHeader3)}
//oGet02:oBrowse:bLostFocus:={|| Fd_Sai(1)}
oGet03:oBrowse:Default()
oGet03:oBrowse:Refresh()
//oGet02:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)


//Salva os dados editados na troca de pasta no folder
oFolder:bSetOption := {|nAt|DefPasta(nFldMed:=nAt,nFldAnt:=oFolder:nOption,)}
oFolder:bChange    := {||If(!lInfMed,(oFolder:SetOption(nFldAnt),oFolder:Refresh()),.T.)}
oFolder:SetOption(1)


ACTIVATE MSDIALOG oDlgCons ON INIT RfatBar(oDlgCons,{|| oDlgCons:End()},{||oDlgCons:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)


//FimEstrut2("TRB",cArqB1)   // Finaliza o uso do Temporario funcao dentro do sigacusb
If Select("TRB") <> 0
  TRB->(DbcloseArea())
Endif



Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³DefAno    ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consolida por ano as Informacoes encontradas nas pastas    ³±±
±±³          ³ Chave : Descricao da Operacao + Ano da Operacao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ DefAno(EXPN1,EXPN2,EXPN3,EXPN4,EXPO1)                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Indentifica o nome da Operacao             	     ³±±
±±³			 ³ EXPN2 = Indentifica a Ano                                  ³±±
±±³			 ³ EXPN3 = Indentifica a Mes                 			        ³±±
±±³			 ³ EXPN4 = Indentifica o Valor                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DefAno(cTitulo,cAno,cMes,nValor)
Local nPos := Ascan(aDefAno,{|x| x[1]+x[2] ==  cTitulo+cAno })
If nPos = 0
   AADD(aDefAno,{cTitulo,cAno,nValor})  // Guardo Titulo, Ano e Valor
Else
   Aviso('Atencao','Ja foi lancando um valor para este Titulo e Ano.',{'Ok'})
Endif   

Return



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

	If nGotMed   = 1  // Disponivel
		aHeader := aClone(aHeader1)
		nUsado  := Len(aHeader1)
		aCols   := aClone(aCols1)
		N 		  := 1
		oGet01:oBrowse:lDisablePaint:= .F.
		oGet01:oBrowse:Refresh(.T.)
	Elseif nGotMed = 2 //Malha
		aHeader := aClone(aHeader2)
		nUsado  := Len(aHeader2)
		aCols   := aClone(aCols2)
		N 		  := 1
		oGet02:oBrowse:lDisablePaint:= .F.
		oGet02:oBrowse:Refresh(.T.)
	Elseif nGotMed = 3 //Matriz
		aHeader := aClone(aHeader3)
		nUsado  := Len(aHeader3)
		aCols   := aClone(aCols3)
		N 		:= 1
		oGet03:oBrowse:lDisablePaint:= .F.
		oGet03:oBrowse:Refresh(.T.)
   /*
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
	*/
	EndIf
		
	
Endif



/*

lInfMed := .T.

If nLostMed # NIL
If nLostMed == 1 //Medicoes
oGetMed:oBrowse:lDisablePaint := .T.
oGetMed:oBrowse:Refresh(.T.)

//Atualiza os niveis das Medicoes
Q215AtuMed(nLostMed)

//Atualiza o Contador de Medicoes e Nao-conformidades
Q215SumMed(nLostMed)

ElseIf nLostMed == 2 //Nao-conformidades
oGetNCs:oBrowse:lDisablePaint := .T.
oGetNCs:oBrowse:Refresh(.T.)

//Atualiza os niveis das Nao-conformidades
Q215AtuMed(nLostMed)

//Atualiza o Contador de Nao-conformidades
Q215SumMed(nLostMed)


ElseIf nLostMed == 4 //Instrumentos
oGetIns:oBrowse:lDisablePaint := .T.
oGetIns:oBrowse:Refresh(.T.)
aMedicao[4,nMedAtu] := aClone(aCols)

EndIf
EndIf
*/
/*
ElseIf nGotMed == 2 //Nao-conformidades
//dbSelectArea("QEU")
aHeader := aClone(aSavaHeader[HEAD_NCS])
nUsado  := Len(aHeader)
aCols   := aClone(aMedicao[2,nMedAtu])
N 		:= 1
//lInfMed := Q215ChkMed(nPosLab,nPosEns,,nMedAtu,cCarta,1,.F.,.T.,.T.)
oGetNCs:oBrowse:lDisablePaint := .F. //If(lInfMed,.F.,.T.)
oGetNCs:oBrowse:Refresh(.T.)

ElseIf nGotMed == 3 //Cronica
/*
lInfMed := Q215ChkMed(nPosLab,nPosEns,nMedAtu,nNcoAtu,,2,.F.,.T.,.T.)
If lInfMed
oCronica:Show()
Else
oCronica:Hide()
EndIf
oCronica:Refresh()
ElseIf nGotMed == 4 //Instrumentos
dbSelectArea("QET")
aHeader := aClone(aSavaHeader[HEAD_INST])
nUsado  := Len(aHeader)
aCols   := aClone(aMedicao[4,nMedAtu])
N 		:= 1
lInfMed := Q215ChkMed(nPosLab,nPosEns,,nMedAtu,cCarta,1,.F.,.T.,.T.)
oGetIns:oBrowse:lDisablePaint := If(lInfMed,.F.,.T.)
oGetIns:oBrowse:Refresh(.T.)
EndIf
*/
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fd_Entra   ³Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna aCols e aHeader quando se foca a GETDADOS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nE - Numero da GetDados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fd_Entra(nE,_acols,_aHeader)
Local cVar  := "oGet"+StrZero(nE,2)
//aHeader	:= AClone(aSvHeader[nE])
//aCols		:= AClone(aSvCols[nE])
aHeader	   := AClone(_aHeader)
aCols		   := AClone(_aCols)
n			   := 1
oFolder:SetOption(nE)
oFolder:Refresh()
&cVar:oBrowse:Refresh()
//nControGD := nE
//nFoldAtu := nE
return


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fd_Entra   ³Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna aCols e aHeader quando se foca a GETDADOS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nE - Numero da GetDados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fd_EntraSup(nE,_acols,_aHeader)
Local cVar  := "oGet"+StrZero(nE,2)
aHeader	   := AClone(_aHeader)
aCols		   := AClone(_aCols)
nUsado      := Len(_aHeader)
n			   := 1
&cVar:oBrowse:lDisablePaint:= .F.
&cVar:oBrowse:Refresh(.T.)

return




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fd_Sai     ³Autor ³ Eduardo Motta         ³ Data ³ 12.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Guarda aCols e aHeader quando se sai da GETDADOS           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nE - Numero da GetDados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function Fd_Sai(nE)
aSvHeader[nE]	:= aClone(aHeader)
aSvCols[nE]		:= aClone(aCols)
n			       := len(aCols)
nControGD      := 0
return
*/


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
±±³Parametros³ oDlgProd: 	Objeto Dialog                                 ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RfatBar(oDlgProd,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

//aadd(aButtons,{"POSCLI",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi‡„o de Cliente" }) 	//"Posi‡„o de Cliente"

Return (EnchoiceBar(oDlgProd,bOK,bcancel,,aButtons))


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
Static Function InfoTela()
Local cAno := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aHeader1 - Acols1                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader1   :={}
aCols1     :={}

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("C6_NUM")      
AADD(aHeader1,{"Ano","ANO",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_NUM")
AADD(aHeader1,{"Mes","MES",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"112010001"
AADD(aHeader1,{"Contas a Receber",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"311010001"
AADD(aHeader1,{"RT periodo",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARGE") //"PMR"
AADD(aHeader1,{"PMR DIAS ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARCA") //"PMR"
AADD(aHeader1,{"",X3_CAMPO,"@!",1,0,,,"C",,})
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aHeader2 - Acols2                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader2   :={}
aCols2     :={}
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("C6_NUM")      
AADD(aHeader2,{"Ano","ANO",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_NUM")
AADD(aHeader2,{"Mes","MES",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"112010001"
AADD(aHeader2,{"Contas a Pagar (Importados/Nacionais)",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"311010001"
AADD(aHeader2,{"RT periodo",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARGE") //"PMR"
AADD(aHeader2,{"PMP DIAS ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARCA") //"PMR"
AADD(aHeader2,{"",X3_CAMPO,"@!",1,0,,,"C",,})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aHeader3 - Acols3                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader3   :={}
aCols3     :={}
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("C6_NUM")      
AADD(aHeader3,{"Ano","ANO",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_NUM")
AADD(aHeader3,{"Mes","MES",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"112010001"
AADD(aHeader3,{"Contas a Pagar (Importados/Nacionais)",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CT7_ATUDEB") //"311010001"
AADD(aHeader3,{"RT periodo",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARGE") //"PMR"
AADD(aHeader3,{"PMP DIAS ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_X_MARCA") //"PMR"
AADD(aHeader3,{"",X3_CAMPO,"@!",1,0,,,"C",,})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche  Acols1 e aHeader1 - PRAZO MEDIO DE RECEBIMENTO               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru     := CT7->(dbStruct())
lQuery    := .T.
cAlias := "_v$PMR"
cQuery := ""
cQuery := "SELECT * "
cQuery += " FROM v$PMR " 
//MemoWrit("RESERVA.Sql",cQuery)   //   Apenas utilizado para validar a query.
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
		TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX

While !(cAlias)->( Eof() )
	
		///
		/// CALCULO PMR  -  ( aCols1 - aHeader1 )
      ///
		If  alltrim((cAlias)->CT7_CONTA) $ ('311010001|112010001') 

			nLin := Ascan(aCols1,{|x| x[1]+x[2] == (cAlias)->(ANO+MES) })
			If  nLin = 0 
				 AADD(aCols1,Array(Len(aHeader1)+1))                  
				 nLin := Len(aCols1)
				 aCols1[nLin,Len(aHeader1)+1] := .F.

				 aCols1[nLin][1]      := (cAlias)->ANO
				 aCols1[nLin][2]      := (cAlias)->MES
    			 aCols1[nLin][3]      := 0
	   		 aCols1[nLin][4]      := 0
             aCols1[nLin][5]      := 0
         Endif    
			
         If  '112010001' $ (cAlias)->CT7_CONTA     /// (CT7_CONTA = '311010001' AND CT7_LP<>'Z') OR CT7_CONTA='112010001'         
 				 aCols1[nLin][3]      := (cAlias)->(CT7_ATUDEB-CT7_ATUCRD)
         Else
				 aCols1[nLin][4]      := (cAlias)->(CT7_ATUCRD-CT7_ATUDEB)
         Endif
         
          nDias := 30 * val((cAlias)->MES)

		    aCols1[nLin][5]     :=  ((aCols1[nLin][3] * nDias) / aCols1[nLin][4]) 
  

		Endif
		
		(cAlias)->(Dbskip())
		
EndDo
	
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())
	
if Len(aCols1) = 0
	AADD(aCols1,Array(Len(aHeader1)+1))
	nLin := Len(aCols1)
	aCols1[nLin,Len(aHeader1)+1] := .F.
	aCols1:=PrencAcols(aCols1,aHeader1)
Endif

//
// Informacoes que serao utilizadas para montagem do Consolidado Anual
//
// aTitles  Indentifica a Linha que esta sendo tratada
// aCols1   Indentifica a pasta que esta sendo tratada
// nY       Indentifica a Linha do Acols
// 2        Indentifica a Coluna do Acols que contem o Ano
// nValor   Indendifica o Valor a ser gravado na chave (titulo+ano)
For nY := 1 to Len(acols1)                   
    If aCols1[nY][2] = "12" // SOMENTE MES 12
       DefAno(aNPasta[1],aCols1[nY][1],aCols1[nY][2],aCols1[nY][5])//Titulo,Ano,Mes,Valor
    Endif  
Next nY


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche  Acols2 e aHeader2 - PRAZO MEDIO DE PAGAMENTO                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru     := CT7->(dbStruct())
lQuery    := .T.
cAlias := "_v$PMP"
cQuery := ""
cQuery := "SELECT * "
cQuery += " FROM v$PMP " 
//MemoWrit("RESERVA.Sql",cQuery)   //   Apenas utilizado para validar a query.
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
		TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX

While !(cAlias)->( Eof() )
	
		///
		/// CALCULO PMP  -  ( aCols2 - aHeader2)
      ///
		If  alltrim((cAlias)->CT7_CONTA) $ ('115010002|115010003|212010001|212020001')

			nLin := Ascan(ACOLS2,{|x| x[1]+x[2] == (cAlias)->(ANO+MES) })
			If  nLin = 0 
				 AADD(ACOLS2,Array(Len(AHEADER2)+1))                  
				 nLin := Len(ACOLS2)
				 ACOLS2[nLin,Len(AHEADER2)+1] := .F.

				 ACOLS2[nLin][1]      := (cAlias)->ANO
				 ACOLS2[nLin][2]      := (cAlias)->MES
    			 ACOLS2[nLin][3]      := 0
	   		 ACOLS2[nLin][4]      := 0
             ACOLS2[nLin][5]      := 0
         Endif    
			
         If  alltrim((cAlias)->CT7_CONTA) $ ('212010001|212020001') 
     			 ACOLS2[nLin][3]      +=  (cAlias)->(CT7_ATUCRD-CT7_ATUDEB)
         Else
				 ACOLS2[nLin][4]      +=  (cAlias)->(CT7_ATUDEB-CT7_ATUCRD)
         Endif
         
         
          nDias := 30 * val((cAlias)->MES)

		    aCols2[nLin][5]     :=  ((aCols2[nLin][3] * nDias) / aCols2[nLin][4]) 


		Endif
		
		(cAlias)->(Dbskip())
		
EndDo
	
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())
	
if Len(ACOLS2) = 0
	AADD(ACOLS2,Array(Len(AHEADER2)+1))
	nLin := Len(ACOLS2)
	ACOLS2[nLin,Len(AHEADER2)+1] := .F.
	ACOLS2:=PrencAcols(ACOLS2,AHEADER2)
Endif

//
// Informacoes que serao utilizadas para montagem do Consolidado Anual
//
// aTitles  Indentifica a Linha que esta sendo tratada
// ACOLS2   Indentifica a pasta que esta sendo tratada
// nY       Indentifica a Linha do Acols
// 2        Indentifica a Coluna do Acols que contem o Ano
// nValor   Indendifica o Valor a ser gravado na chave (titulo+ano)
For nY := 1 to Len(acols2)                   
    If aCols2[nY][2] = "12" // SOMENTE MES 12
       DefAno(aNPasta[2],aCols2[nY][1],aCols2[nY][2],aCols2[nY][5])//Titulo,Ano,Mes,Valor
    Endif  
Next nY





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche  Acols3 e aHeader3 - PRAZO MEDIO DE ESTOQUE                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStru     := CT7->(dbStruct())
lQuery    := .T.
cAlias := "_v$PME"
cQuery := ""
cQuery := "SELECT * "
cQuery += " FROM v$PME " 
//MemoWrit("RESERVA.Sql",cQuery)   //   Apenas utilizado para validar a query.
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
For nX := 1 To Len(aStru)
	If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
		TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
	EndIf
Next nX

While !(cAlias)->( Eof() )
	
		///
		/// CALCULO PME  -  ( aCols3 - aHeader3)
      ///
		If  alltrim((cAlias)->CT7_CONTA) $  ('115010001','115010002','115010003','115010004','115010005','115010006','115010007','115010009',;
                                            '115010015','115010016','115010017','115010018','115010019','115010020','115010021') 

			 nLin := Ascan(aCols3,{|x| x[1]+x[2] == (cAlias)->(ANO+MES) })
			 If  nLin = 0 
			  	  AADD(aCols3,Array(Len(aHeader3)+1))                  
			     nLin := Len(aCols3)
				  aCols3[nLin,Len(aHeader3)+1] := .F.

				  aCols3[nLin][1]      := (cAlias)->ANO
				  aCols3[nLin][2]      := (cAlias)->MES
    			  aCols3[nLin][3]      := 0
	   		  aCols3[nLin][4]      := 0
              aCols3[nLin][5]      := 0
          Endif    
			
			 //
			 //  Vl.Bruto Estoque
			 //
	    	 If  alltrim((cAlias)->CT7_CONTA) $ ('115010001','115010002','115010003','115010004','115010005','115010006','115010007','115010009')
              aCols3[nLin][3]      +=  (cAlias)->(CT7_ATUDEB-CT7_ATUCRD)	  
	       Endif
		  
			 //
			 //  Despesas com Estoque
			 //
          If  alltrim((cAlias)->CT7_CONTA) $ ('115010015','115010016','115010017','115010018','115010019','115010020','115010021') 
              aCols3[nLin][3]      +=  (cAlias)->(CT7_ATUCRD-CT7_ATUDEB)	  
          Endif

			 //
			 //  Compras
			 //
          If  alltrim((cAlias)->CT7_CONTA) $ ('115010002','115010003')
 			  	  aCols3[nLin][4]      +=  (cAlias)->(CT7_ATUDEB-CT7_ATUCRD)
          Endif
         
        
          nDias := 30 * val((cAlias)->MES)

	       aCols3[nLin][5]     :=  ((aCols3[nLin][3] * nDias) / aCols3[nLin][4]) 


		Endif
		
		(cAlias)->(Dbskip())
		
EndDo
	
DbSelectArea(cAlias)
(cAlias)->(DbCloseArea())
	
if Len(aCols3) = 0
	AADD(aCols3,Array(Len(aHeader3)+1))
	nLin := Len(aCols3)
	aCols3[nLin,Len(aHeader3)+1] := .F.
	aCols3:=PrencAcols(aCols3,aHeader3)
Endif

//
// Informacoes que serao utilizadas para montagem do Consolidado Anual
//
// aTitles  Indentifica a Linha que esta sendo tratada
// aCols3   Indentifica a pasta que esta sendo tratada
// nY       Indentifica a Linha do Acols
// 2        Indentifica a Coluna do Acols que contem o Ano
// nValor   Indendifica o Valor a ser gravado na chave (titulo+ano)
For nY := 1 to Len(aCols3)                   
    If aCols3[nY][2] = "12" // SOMENTE MES 12
       DefAno(aNPasta[2],aCols3[nY][1],aCols3[nY][2],aCols3[nY][5])//Titulo,Ano,Mes,Valor
    Endif  
Next nY







//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tela Superior - Utilizando um TRB                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nAnoIni:=0
aStru2:={}
aCampos:={}
AADD(aStru2  ,{"T_OK","C", 2 , 0} )
//AADD(aCampos,{"T_OK",""," "," "})

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("B1_DESC")      
AADD(aStru2 ,{"INDICA",X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{"INDICA","","Indicadores Financeiros/Sistemicos",X3_PICTURE})


DbSeek("C6_X_MARGE")      
For nY:=1 to nTotMes // Pegar sempre os ultimos 06 Anos
    _nAnoIni:=_nAnoIni+1
    cAno:=substr(_cAnoAtu,1,1)+strzero(_nAnoIni,3)
    AADD(aStru2 ,{"N_"+cAno,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
    AADD(aCampos,{"N_"+cAno,"",cAno,X3_PICTURE})
Next nY

AADD(aStru2  ,{"FINALIZ","C" ,1, 0} )  // Este campo e apenas para corrigir
AADD(aCampos,{"FINALIZ","","",""})    // o ultimo item do acols para nao ficar com um espaco enorme.



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Trb Vazio                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqB1   := CriaTrab(aStru2,.T.)
_cArqPRO := CriaTrab(,.F.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)
//IndRegua("TRB",_cArqPRO,"INDICA",,,"Indexando Registros...")  // DESATIVA O INDEX
IndRegua("TRB",_cArqPRO,"FINALIZ",,,"Indexando Registros...")  // DESATIVA O INDEX
dbGotop()

DbSelectArea("TRB")
For nY:= 1 to Len(aDefAno) 
    _LinOperacao:= Alltrim(aDefAno[ny][1])
    _ColAno:= 'N_'+aDefAno[nY][2]
    IF !DbSeek(_LinOperacao)           // BUSTA O SISTEMA E GRAVA O VALOR DO ANO NA COLUNA CORRETA
       Reclock("TRB",.T.)
       TRB->INDICA:= _LinOperacao
       &_ColAno:= aDefAno[nY][3] // GRAVA NO ANO
    	 Msunlock()
    Endif
Next nY

dbGotop()

Return



Static Function DemForm()

Local uValor := 0
Local nY     := 0
Local aDemFom:= {}
          

AADD(aDemFom,"           INDICADOPRES SISTEMICOS                   ")
AADD(aDemFom,"           =======================                   ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom," A) PRAZO MEDIO DE RECEBIMENTO                       ")
AADD(aDemFom,"    --------------------------                       ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    UTILIZA AS SEGUINTES CONTAS CONTABEIS P/ CALCULO:")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    112010001 - DUPLICATAS A RECEBER                 ")
AADD(aDemFom,"    311010001 - FATURAMENTO BRUTO DE PRODUTOS        ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    ONDE:                                            ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    PMR := DUPLICATAS A RECEBER / TOTAL DE VENDAS    ")
AADD(aDemFom,"           --------------------------------------    ")
AADD(aDemFom,"                      NUMERO DE DIAS                 ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom," B) PRAZO MEDIO DE PAGAMENTO                         ")
AADD(aDemFom,"    ------------------------                         ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    UTILIZA AS SEGUINTES CONTAS CONTABEIS P/ CALCULO:")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    212010001 - FORNECEDORES NACIONAIS               ")
AADD(aDemFom,"                           +                         ")
AADD(aDemFom,"    212020001 - FORNECEDORES IMPORTADOS              ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    115010002 - COMPRAS DE MERCADORIAS NACIONAIS     ")
AADD(aDemFom,"                           +                         ")
AADD(aDemFom,"    115010003 - COMPRAS DE MERCADORIAS IMPORTADOS    ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    ONDE:                                            ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"    PMP := DUPLICATAS A PAGAR / TOTAL DE COMPRAS     ")
AADD(aDemFom,"           --------------------------------------    ")
AADD(aDemFom,"                      NUMERO DE DIAS                 ")
AADD(aDemFom,"                                                     ")
AADD(aDemFom,"                                                     ")

For nY := 1 to len(aDemFom)
	
	/*
	if alltrim(aPrVenda[nY,02]) = ""
		uValor := SPACE(14)
	Elseif  alltrim(aPrVenda[nY,05])    = "C"
		uValor := aPrVenda[nY,03]
	Else
		uValor := TRANSFORM(aPrVenda[nY,03],"@E 9,999,999,999.99")
	Endif
	*/
	AutoGrLog(aDemFom[nY])
	
Next nY

MostraErro()

Return



/* QUERY UTILIZADA PARA O PME ONDE SAO BUSCADAS AS INFORMACOES
SELECT CT7_CONTA,SUBSTR(CT7_DATA,1,4) ANO, SUBSTR(CT7_DATA,5,2) MES ,  MAX(CT7_ATUCRD) CT7_ATUCRD , MAX(CT7_ATUDEB) CT7_ATUDEB,
MAX(CT7_ATUCRD)  - MAX(CT7_ATUDEB) 
FROM CT7010
WHERE  CT7_CONTA  IN ('115010001','115010002','115010003','115010004','115010005','115010006','115010007','115010009',
                      '115010015','115010016','115010017','115010018','115010019','115010020','115010021',
                      '115010002','115010003') AND
       NOT (CT7_ATUCRD -  CT7_ATUDEB = 0 AND SUBSTR(CT7_DATA,5,2) = '12' ) AND
       D_E_L_E_T_<>'*'
GROUP BY CT7_CONTA,SUBSTR(CT7_DATA,1,4), SUBSTR(CT7_DATA,5,2)
ORDER BY CT7_CONTA,ANO,MES;
*/