#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"


User Function NFREEZE()

Local cCadastro   := "TESTE PROPRIEDADE NFREEZE"
Local nOpc        := 3          // Nao trocar caso contrario comecara a
Local nOpcA 	  := 0          // incluir linhas no acols.
Local nLin        := 0
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)
Local aAltGr	  := {}
Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5

Private oGet
PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis utilizadas no posicionamento dos elementos do Acols           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private xF4_FILIAL := 0
Private xF4_CODIGO := 0
Private xF4_TIPO   := 0
Private xF4_ICM    := 0
Private xF4_IPI    := 0
Private xF4_CREDIPI:= 0
Private xF4_ESTOQUE:= 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader e aCols                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols         := {}
aHeader       := {}

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("F4_FILIAL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_CODIGO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_TIPO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_ICM")          // FABRI
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_IPI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_CREDIPI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("F4_ESTOQUE")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicao dos itens no novo acols                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
xF4_FILIAL := aScan(aHeader,{|x| AllTrim(x[2])=="F4_FILIAL"})
xF4_CODIGO := aScan(aHeader,{|x| AllTrim(x[2])=="F4_CODIGO"})
xF4_TIPO   := aScan(aHeader,{|x| AllTrim(x[2])=="F4_TIPO"})
xF4_ICM    := aScan(aHeader,{|x| AllTrim(x[2])=="F4_ICM"})
xF4_IPI    := aScan(aHeader,{|x| AllTrim(x[2])=="F4_IPI"})
xF4_CREDIPI:= aScan(aHeader,{|x| AllTrim(x[2])=="F4_CREDIPI"})
xF4_ESTOQUE:= aScan(aHeader,{|x| AllTrim(x[2])=="F4_ESTOQUE"})

DbSelectArea("SF4")
DbSetORder(1)                   
DbGotop()

While !SF4->(EOF())
	
	AADD(aCols,Array(Len(aHeader)+1))
    nLin:=Len(Acols)
	
	aCols[nLin][Len(aHeader)+1]:= .f.
	aCols[nLin][xF4_FILIAL]         := SF4->F4_FILIAL
	aCols[nLin][xF4_CODIGO]         := SF4->F4_CODIGO
	aCols[nLin][xF4_TIPO]           := SF4->F4_TIPO
	aCols[nLin][xF4_ICM]            := SF4->F4_ICM
	aCols[nLin][xF4_IPI]            := SF4->F4_IPI
	aCols[nLin][xF4_CREDIPI]        := SF4->F4_CREDIPI
	aCols[nLin][xF4_ESTOQUE]        := SF4->F4_ESTOQUE
	
	SF4->(DBSKIP())
	
Enddo



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 7,16
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD


AAdd( aObjects, { 0,     210, .T., .T. } )
AAdd( aObjects, { 116,   160, .F., .T. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas
AAdd( aObjects, { 0,     020, .F., .F. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas

aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj := MsObjSize( aInfo, aObjects )
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{195,250}})

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel

oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,,,,.T.,aAltGr,4/*nFreeze*/)
oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:oBrowse:lDisablePaint := .F.
oGet:oBrowse:nFreeze := 4      
oGet:nMax:=Len(Acols)

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{||nOpcA := 1,if(oget:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()}) CENTERED


Return



Static Function RfatBar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


