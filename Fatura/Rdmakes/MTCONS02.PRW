#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTCONS02  ºAutor  ³                    º Data ³  06/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Produtos Vendidos por Cliente.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTCONS02(cLoja,cNReduz,cVendedor,dData1,dData2,cCombo2,cCombo4,;
cRefe,cSufixo,cMarca,cPedCli,cCdCli,cCombo3)

Local cCadastro := "Consulta de Produtos Vendidos p/ Cliente"
Local nY        := 0
Local bSetKey4
Local bSetKey12
Local bSetKey8
Local nOpc        := 3          // Nao trocar caso contrario comecara a


Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)
Local nRecno      := 0 

Local oData1,oData2
Local aAltGr     := {}
Local nLin       := 0

Local oDlgProd
Private oCodigo,oLoja
Private oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5,oCombo2,oCombo3,oCombo4,oSufixo,oMarca,oRefe

Private cCodigo   := SPACE(6)
Private xCod       := 0
Private xDesc      := 0
Private xCGC       := 0
Private xNREDUZ    := 0
Private xUcom      := 0
Private xDoc       := 0
Private xQuant     := 0
Private xPedido    := 0
Private xPedCli    := 0
Private xVunit     := 0
Private xTip       := 0
Private xTipo      := 0
Private xTotal     := 0
Private xPedCli    := 0

Private xMargE     := 0
Private xMargV     := 0

Private xVend1     := 0
Private xVend2     := 0
Private xVend3     := 0
Private xVend4     := 0
Private xVend5     := 0

Private nQtdEnt    := 0
Private nValEnt    := 0

Private nQtdDev    := 0
Private nValDev    := 0

Private nQtdSai    := 0
Private nValSai    := 0

Private nQtdNFAT   := 0
Private nValNFAT   := 0



Private aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private lF8        := .T.
Private _cArqPRO   := ""
Private cArqB1     := ""
Private cProcName  := FunName()
Private oGet,oPedCli,oCdCli

Private aItems2    := {} // ORDEM DE APRESENTACAO
Private aItems3    := {} // VENDAS/DEVOLUCAO/AMBOS

Private aItems4    := {} // FILIAL DESEJADA
Private oVendedor 
Private lLibSA1    := .T.
Private oSay       
Private cDescricao := "Cod.Cliente.:"  
Private cConsulF3  := "FA8"


Default cLoja      := CriaVar("A1_LOJA")
Default cNReduz    := SPACE(20)
Default cVendedor  := CriaVar("CJ_X_VEND1")
Default dData1     := Ctod("01/"+STRZERO(Month(dDatabase),2)+"/"+STR(Year(dDatabase),4))
Default dData2     := dDatabase
Default cCombo2    := ""
Default cCombo4    := ""
Default cRefe      := CriaVar("B1_X_REFER")
Default cSufixo    := CriaVar("B1_X_SUFIX")
Default cMarca     := CriaVar("B1_X_MARCA")
Default cPedCli    := CriaVar("C5_X_COTCL")
Default cCdCli     := CriaVar("C6_X_PRCLI")
Default cCombo3    := ""


aadd(aItems3,"(S1) Vendas          ")                                   
aadd(aItems3,"(S2) Dev.Vendas      ")
aadd(aItems3,"(S3) Nao Faturado    ")
aadd(aItems3,"(S4) Transferencia   ")
aadd(aItems3,"(S1)+(S2)+(S3)+(S4)  ")
                              
aadd(aItems3,"(E1) Entradas        ")
aadd(aItems3,"(E2) Dev.Compras     ")
aadd(aItems3,"(E1) + (E2)          ")
aadd(aItems3,"Ambos                ")

If(EmptY(cCombo3))
  cCombo3    := aItems3[1]
Endif

DbSelectArea("SM0")
nRecno:= SM0->(RECNO())
DbGotop()
While !SM0->(EOF())  
      If SM0->M0_CODIGO='01'
         aadd(aItems4,SM0->M0_CODFIL+" - "+SM0->M0_FILIAL)
      Endif   
      SM0->(DBSKIP())
Enddo            
aadd(aItems4,"  "+" - "+"Ambas")
DbGoto(nRecno)

If (EmptY(cCombo4))
   cCombo4    := aItems4[1]
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader e aCols                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols         := {}
aHeader       := {}
     



DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("D2_FILIAL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_PEDIDO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D1_ITEM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_DOC")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,10/*D2_DOC||'/'||D2_SERIE*/ ,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_COD")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_DESC")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO+6,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("A1_NREDUZ")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_UCOM")
AADD(aHeader,{"Emissao NF",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_QUANT")
AADD(aHeader,{X3_TITULO,X3_CAMPO,"@E 999,999,999",X3_TAMANHO,0,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_PRCVEN")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_TOTAL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_X_MARGE")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_X_MARGV")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("A1_CGC")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C5_X_COTCL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_X_PRCLI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("D2_TIPO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
//  Troquei o nome do campo  VEND1 a VEND5 em funcao de durante o navegacao pelo browse estar chegando a validacao 
//  do campo inclusive a obrigatoriedade de estar preenchido. 
DbSeek("C5_VEND1")                                                                                             
AADD(aHeader,{X3_TITULO,"VEND1",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C5_VEND2")
AADD(aHeader,{X3_TITULO,"VEND2",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C5_VEND3")
AADD(aHeader,{X3_TITULO,"VEND3",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C5_VEND4")
AADD(aHeader,{X3_TITULO,"VEND4",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C5_VEND5")
AADD(aHeader,{X3_TITULO,"VEND5",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("B1_COD")
AADD(aHeader,{"(S1)/(S2)/(S3)/(E1)/(E2","TIPMOV",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
//AADD(aHeader,{" "              ,"ALT_VAZIO"  ,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})


//
// Coloca em Ordem de acordo com a definicao do combo
//
For nY := 2 to Len(aHeader)
	aadd(aItems2,aHeader[nY][1])
Next

If (EmptY(cCombo2))
  cCombo2 := aHeader[2][1]
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicao dos itens no novo acols                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


xFilial    := aScan(aHeader,{|x| AllTrim(x[2])=="D2_FILIAL"})
xCod       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_COD"})
xDesc      := aScan(aHeader,{|x| AllTrim(x[2])=="B1_DESC"})
xCGC       := aScan(aHeader,{|x| AllTrim(x[2])=="A1_CGC"})
xNREDUZ    := aScan(aHeader,{|x| AllTrim(x[2])=="A1_NREDUZ"})
xUcom      := aScan(aHeader,{|x| AllTrim(x[2])=="B1_UCOM"})
xDoc       := aScan(aHeader,{|x| AllTrim(x[2])=="D2_DOC"})
xQuant     := aScan(aHeader,{|x| AllTrim(x[2])=="D2_QUANT"})
xPedido    := aScan(aHeader,{|x| AllTrim(x[2])=="D2_PEDIDO"})
xItem      := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
xProCli    := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_PRCLI"})
xVunit     := aScan(aHeader,{|x| AllTrim(x[2])=="D2_PRCVEN"})
xTip       := aScan(aHeader,{|x| AllTrim(x[2])=="D2_TIPO"})
xTipo      := aScan(aHeader,{|x| AllTrim(x[2])=="TIPMOV"})
xTotal     := aScan(aHeader,{|x| AllTrim(x[2])=="D2_TOTAL"})
xPedCli    := aScan(aHeader,{|x| AllTrim(x[2])=="C5_X_COTCL"})
xMargE     := aScan(aHeader,{|x| AllTrim(x[2])=="D2_X_MARGE"})
xMargV     := aScan(aHeader,{|x| AllTrim(x[2])=="D2_X_MARGV"})
xVend1     := aScan(aHeader,{|x| AllTrim(x[2])=="VEND1"})
xVend2     := aScan(aHeader,{|x| AllTrim(x[2])=="VEND2"})
xVend3     := aScan(aHeader,{|x| AllTrim(x[2])=="VEND3"})
xVend4     := aScan(aHeader,{|x| AllTrim(x[2])=="VEND4"})
xVend5     := aScan(aHeader,{|x| AllTrim(x[2])=="VEND5"})


AADD(aCols,Array(Len(aHeader)+1))
nLin                        := Len(aCols)
aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado
aCols[nLin, xCod   ]       := "."


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 7,16
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 7,15 BOLD


aSize := MsAdvSize()

aObjects := {}


AAdd( aObjects, { 100, 035, .t., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 045, .t., .f. } )

//AAdd( aObjects, { 100, 035, .t., .f. } )
//AAdd( aObjects, { 100, 100, .t., .t. } )
//AAdd( aObjects, { 100, 025, .t., .f. } )

// Esta matriz contem os limites da tela
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{015,35 ,55,67  ,  110,120  ,  140,153, 189,200   , 235, 247    ,  283    },;
 {060,180,180,250},;
 {015,35,67, 77  ,  110,120  ,  140,153, 189,200   , 235,  247   ,  283    }} )
 //{050,130,180,250},;

nGetLin := aPosObj[3,1]



If ALLTRIM(Substr(cCombo3,2,1)) = "E" // Caso seja Consulta de Entradas

   cDescricao := "Cod.Fornece.:"  
   cConsulF3  := "SA2"

Else                                   // Caso seja Consulta de Saidas

   cDescricao := "Cod.Cliente.:"  
   cConsulF3  := "FA8"

Endif


DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel
bSetKey4  := SetKey(VK_F4  ,{|| U_MFATC03(aCols[n,xCod])})
//bSetKey8  := SetKey(VK_F8  ,{|| lF8:=IF(lF8,.F.,.T.) ,GeraMarkB(@cArqB1,@aStru,@oMark,M->cCodigo,oMark)})

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlgProd PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlgProd PIXEL

nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1]
nGetLin := nGetLin - 10

@ nGetLin  ,aPosGet[1,1] SAY oSay VAR cDescricao  size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
//oSay:SetColor(CLR_HRED,GetSysColor(15))


@ nGetLin  ,aPosGet[1,2] MSGET oCodigo  VAR cCodigo F3 cConsulF3 Picture "@!"   Size 30,8 OF oDlgProd PIXEL  When lLibSA1;
Valid ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)


@ nGetLin  ,aPosGet[1,3] MSGET oLoja  VAR cLoja  Picture "@!"   Size 08,8 OF oDlgProd PIXEL  When lLibSA1;
//Valid ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)

@ nGetLin  ,aPosGet[1,4] SAY cNReduz size 100,8 OF oDlgProd PIXEL          //FONT oFntFecha5


@ nGetLin  ,aPosGet[1,5] SAY "Vend:" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin  ,aPosGet[1,6] MSGET oVendedor VAR cVendedor  Picture "@!"   Size 20,8 OF oDlgProd PIXEL  When .T.;
//Valid ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)


@ nGetLin  ,aPosGet[1,7]  SAY "De"  size 100,8 OF oDlgProd PIXEL                          //FONT oFntFecha5
@ nGetLin  ,aPosGet[1,8]  MSGET oData1 VAR dData1  size 50,8 OF oDlgProd PIXEL  When .T.


@ nGetLin  ,aPosGet[1,9]   SAY "Ate" size 100,8 OF oDlgProd PIXEL                        //FONT oFntFecha5
@ nGetLin  ,aPosGet[1,10]  MSGET oData2 VAR dData2  size 50,8 OF oDlgProd PIXEL  When .T.

@ nGetLin  ,aPosGet[1,11]   SAY "Ordem:"  size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin  ,aPosGet[1,12]   MSCOMBOBOX oCombo2 VAR cCombo2 ITEMS aItems2 SIZE 50,50 OF oDlgProd PIXEL Valid .t.

@ nGetLin  ,aPosGet[1,13]   MSCOMBOBOX oCombo4 VAR cCombo4 ITEMS aItems4 SIZE 50,50;
ON CHANGE ( U_ValidFil(cCombo4,cCodigo,cLoja) )  OF oDlgProd PIXEL Valid .t.

//	@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44  ON CHANGE (nOpt1:=oCbx:nAt)  OF oDlg FONT oDlg:oFont
//	@ 2.1,1.3	MSGET cCampo SIZE 165,10


nGetLin += 15


@ nGetLin,aPosGet[3,01]  SAY "Referencia" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin,aPosGet[3,02]  MSGET oRefe  VAR cRefe  Picture "@!"   Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,03]  SAY "Sufixo" size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
@ nGetLin,aPosGet[3,04]  MSGET oSufixo  VAR cSufixo Picture "@!"   Size 50,8 OF oDlgProd PIXEL
                                                                                      
@ nGetLin,aPosGet[3,05]  SAY "Marca" size 100,8 OF oDlgProd PIXEL                        //FONT oFntFecha5
@ nGetLin,aPosGet[3,06]  MSGET oMarca   VAR cMarca  Picture "@!"   Size 08,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,07]  SAY "Ped.Cli"  size 100,8 OF oDlgProd PIXEL                     //FONT oFntFecha5
@ nGetLin,aPosGet[3,08]  MSGET oPedCli VAR cPedCli  size 50,8 OF oDlgProd PIXEL  When .T.

@ nGetLin,aPosGet[3,09]  SAY "Cd.Cli" size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
@ nGetLin,aPosGet[3,10]  MSGET oCdCli  VAR cCdCli  size 50,8 OF oDlgProd PIXEL  When .T.

//
// Combo Entradas/Saidas/Ambos
//
@ nGetLin ,aPosGet[1,11]   SAY "Oper.:"  size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin ,aPosGet[3,12]   MSCOMBOBOX oCombo3  VAR cCombo3 ITEMS aItems3 SIZE 50,50; 
OF oDlgProd PIXEL Valid ;
(/*oDlgProd:End()*/,U_MTCONS02(cLoja,cNReduz,cVendedor,dData1,dData2,cCombo2,cCombo4,cRefe,cSufixo,cMarca,cPedCli,cCdCli,cCombo3))
//ON CHANGE ( U_ValidFil() ) 

@ nGetLin-03,aPosGet[3,13] BUTTON "&Renovar"	  SIZE 40, 13 OF oDlgProd PIXEL ACTION;
(Iif( ValTudo(oGet,oRefe,oData1,oData2,aCols,cRefe,dData1,dData2,cCodigo,cLoja,cSufixo,cMarca,cCdCli,cCombo4),;
MsgRun( OemToAnsi( "Aguarde. Efetuando Pesquisa..." ),"",{||MontaAcols(oGet,oRefe,oData1,oData2,;
aCols,cRefe,dData1,dData2,cCodigo,cLoja,cNReduz,cVendedor,cCombo2,cCombo4,cSufixo,cMarca,cPedCli,;
cCdCli,cCombo3)}),.T.))



oGet:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,,.T.,aAltGr,4/*nFreeze*/)
//oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:oBrowse:lDisablePaint := .F.
//oGet:oBrowse:nColPos := 5
//oGet:oBrowse:GoDown()
oGet:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
//oGet:oBrowse:nColPos := xPrcven  // Posiciona no Preco de Venda
oGet:nMax:=Len(Acols)


//nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
//nGetLin := nGetLin-5
//@ nGetLin ,aPosGet[2,1]  SAY "Valor Total Vendido  ==> "       of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,2]  SAY nValSai                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED


nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 20
@ nGetLin ,aPosGet[2,1]  SAY "Tot.Pecas Vendidas   ==> QTD.: " of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,2]  SAY nQtdSai                         Picture "@E 999,999,999" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
//@ nGetLin ,aPosGet[2,3]  SAY "Vlr Total R$: "                        of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,4]  SAY nValSai                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED

nGetLin := nGetLin + 10
@ nGetLin ,aPosGet[2,1]  SAY "Tot.Pecas Compradas  ==> QTD.: "   of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,2]  SAY nQtdEnt                          Picture "@E 999,999,999" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
//@ nGetLin ,aPosGet[2,3]  SAY "Vlr Total R$: "                        of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,4]  SAY nValEnt                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED

nGetLin := nGetLin + 10
@ nGetLin ,aPosGet[2,1]  SAY "Tot.Pecas Devolvidas ==> QTD.: "   of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,2]  SAY nQtdDev                          Picture "@E 999,999,999" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
//@ nGetLin ,aPosGet[2,3]  SAY "Vlr Total R$: "                        of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,4]  SAY nValDev                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED

nGetLin := nGetLin + 10
@ nGetLin ,aPosGet[2,1]  SAY "Tot.Pecas Nao Fatur. ==> QTD.: "   of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,2]  SAY nQtdNFAT                          Picture "@E 999,999,999" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
//@ nGetLin ,aPosGet[2,3]  SAY "Vlr Total R$: "                        of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,4]  SAY nValNFAT                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED


//ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,{|| oDlgProd:End()},{|| oDlgProd:End()}) CENTERED
ACTIVATE MSDIALOG oDlgProd ON INIT EnchoiceBar(oDlgProd,{|| oDlgProd:End()},{|| oDlgProd:End()}) CENTERED

SetKey(VK_F4 ,bSetKey4)
//SetKey(VK_F12,bSetKey12)
//SetKey(VK_F8 ,bSetKey8)


Return



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
//aadd(aButtons,{"S4WB011N",{||U_MFATC03(aCols[n][xPRODUTO])}, "< F4 > - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"BUDGET"  ,{|| CONSPER(xPRODUTO,@_dDataIni,@_dDataFinal,@nMaxReg)}, "<F11> -  Consulta Similares" })

aadd(aButtons,{"S4WB011N",{||U_MFATC03(acols[n][xCod])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons, {"PRODUTO", {||U_MFATC02()}	, "Consulta Produtos"})

Return (EnchoiceBar(oDlgProd,bOK,bcancel,,aButtons))



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ExistCli | Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monsta a Lista de Itens das Ultimas Compras com base no TMP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)

Local lRet := .T.

cNReduz    := space(20)

DbSelectArea("SA1")
DbGoTop()
DbSetOrder(1)

If !Empty(cCodigo) 
	
	If  !Dbseek(xFilial("SA1") + cCodigo )
		Aviso("ATENCAO", "Cliente nao Cadastrado...",{"&Ok"})
		cNReduz    := space(20)
		lRet := .f.
	Else
		cNReduz    := SUBSTR(SA1->A1_NREDUZ,1,20)
	Endif
	
Endif


Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ValData  | Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Analiza Data digitada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValTudo(oGet,oRefe,oData1,oData2,aCols,cRefe,dData1,dData2,cCodigo,cLoja,cSufixo,cMarca,cCdCli,cCombo4)
Local lRet := .T.

If !Empty(cCdCli)   
	If ALLTRIM(Substr(cCombo4,1,2)) == "-" 
		Aviso("ATENCAO", "Favor definir uma filial pois foi selecionado o Codigo do Cliente(Cd.Cli)",{"&Ok"})
		lRet := .F.
	EndIf
EndIf

if  Empty(dData1)
	Aviso("ATENCAO", "Favor definir a data inicial...",{"&Ok"})
	lRet := .F.
Endif

if  Empty(dData2)
	Aviso("ATENCAO", "Favor definir a data Final...",{"&Ok"})
	lRet := .F.
Endif

if !Empty(dData1) .and. !Empty(dData2)
	if dData1 > dData2
		Aviso("ATENCAO", "Segunda Data esta maior que a primeira data favor corrigir...",{"&Ok"})
		lRet := .F.
	Endif
Endif


DbSelectArea("SA1")
DbGoTop()
DbSetOrder(1)

If  !Dbseek(xFilial("SA1") + cCodigo + cLoja )
	cNReduz    := space(30)
Else
	cNReduz    := SA1->A1_NREDUZ
Endif
*/

Return(lRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |MontaAcols| Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monsta a Lista de Itens das Ultimas Compras com base no TMP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaAcols(oGet,oRefe,oData1,oData2,aCols,cRefe,dData1,dData2,cCodigo,cLoja,;
cNReduz,cVendedor,cCombo2,cCombo4,cSufixo,cMarca,cPedCli,cCdCli,cCombo3)



Local cChave    := ""
Local nCount    := 0
Local lQuery    := .F.
Local lContinua := .T.
Local _cAlias   := "SB1"
Local aStruSB1  := {}
Local nLin      := 0
Local nPos0     := 0
Local nPos1     := 0
Local nPos2     := 0



aCols           := {}

nQtdEnt    := 0
nValEnt    := 0

nQtdDev    := 0
nValDev    := 0

nQtdSai    := 0
nValSai    := 0

nQtdNFAT    := 0
nValNFAT    := 0


#IFDEF TOP
	
	aStruSB1  := SB1->(dbStruct())
	lQuery    := .T.
	_cAlias := "MCONSPR"
	
	cQuery := ""


	If  alltrim(cCombo3) $ "Ambos|(S1) Vendas|(S1)+(S2)+(S3)+(S4)"

		// Saidas Tipo ('N','C','I','P')
		//
		cQuery += " Select D2_FILIAL             AS FILIAL,  B1_COD      AS COD    , B1_DESC       AS DES    , B1_X_MARCA      AS MAR  , A1_CGC      AS CGC , A1_NREDUZ AS NOM , D2_EMISSAO AS DAT, D2_ITEM  AS ITEM, D2_TOTAL   AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 ,  C5_VEND2    AS VEND2  , C5_VEND3      AS VEND3  , C5_VEND4        AS VEND4, C5_VEND5  AS VEND5 , "
		cQuery += "        D2_DOC||'/'||D2_SERIE AS DOC   ,  D2_QUANT    AS QTD    , D2_PEDIDO       AS PED  , D2_ITEM AS ITEM_PV,  C6_X_PRCLI      AS CLI  , D2_PRCVEN   AS VLR , D2_TIPO    AS TIP, "
		cQuery += "        '(S1) Vendas' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM,  C5_X_COTCL  AS PEDCLI , SD2.R_E_C_N_O_  AS REC  ,"
		cQuery += "        D2_X_MARGE            AS MARGE ,  D2_X_MARGV  AS MARGV  , "
		cQuery += "        F4_DUPLIC             AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA1")+" SA1 ,"
		cQuery += RetSqlName("SF4")+" SF4 ,"
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5  "
		cQuery += " Where "
		cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += " F4_FILIAL='"+xFilial("SF4")+"' AND "

        If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
		   cQuery += " D2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
		   cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	   	   cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	   	   cQuery += " A1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
        Else
  		   cQuery += " D2_FILIAL<>'99' AND "
     	   cQuery += " C6_FILIAL<>'99' AND "
  		   cQuery += " C5_FILIAL<>'99' AND " 
  		   cQuery += " A1_FILIAL<>'99' AND " 
        Endif	   

       cQuery += " C6_FILIAL=D2_FILIAL  AND "
	   cQuery += " C5_FILIAL=D2_FILIAL  AND "
	   cQuery += " A1_FILIAL=D2_FILIAL   AND "

	
		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif

		if !EMPTY(cCodigo)
		
   		cQuery += " D2_CLIENTE ='"+cCodigo+"' AND "
		
		Endif

		if !EMPTY(cLoja)

  	   	cQuery += " D2_LOJA    ='"+cLoja+"' AND "
		
		Endif



		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif

		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
		   cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "

		Endif


		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		
		cQuery += " F4_CODIGO = D2_TES   AND " 
		cQuery += " F4_DUPLIC = 'S'      AND "
		cQuery += "	D2_PEDIDO = C6_NUM   AND "
		cQuery += "	D2_PEDIDO = C5_NUM   AND "
		cQuery += "	D2_ITEMPV = C6_ITEM  AND "
		cQuery += "	D2_CLIENTE= A1_COD   AND "
		cQuery += "	D2_LOJA   = A1_LOJA  AND "
		cQuery += "	D2_COD    = B1_COD   AND "
		cQuery += " D2_TIPO in ('N','I','P','C')  AND "
		cQuery += " D2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SD2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*' "
		
	Endif


	If  alltrim(cCombo3) $ "Ambos|(S1)+(S2)+(S3)+(S4)"

		cQuery += "UNION "
		
	Endif


	If  alltrim(cCombo3) $ "Ambos|(S2) Dev.Vendas|(S1)+(S2)+(S3)+(S4)"
		
		//
		// Saidas Tipo ('D','B')   // Devolucao de Vendas ( ENTRADAS (DEVOLUCAO DE VENDAS OU RETORNO DE BENEFICIAMETO)
		//
		
		cQuery += " Select D1_FILIAL             AS FILIAL, B1_COD                AS COD   , B1_DESC     AS DES    , B1_X_MARCA      AS MAR  , A1_CGC          AS CGC   , A1_NREDUZ AS NOM , D1_EMISSAO AS DAT, D1_ITEM  AS ITEM, D1_TOTAL   AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 , C5_VEND2              AS VEND2 , C5_VEND3    AS VEND3  , C5_VEND4        AS VEND4, C5_VEND5        AS VEND5 , "
		cQuery += "        D1_DOC||'/'||D1_SERIE AS DOC   , D1_QUANT    AS QTD    , ' '             AS PED  , D1_ITEM AS ITEM_PV   , ' '             AS CLI , D1_VUNIT  AS VLR , D1_TIPO    AS TIP, "
		cQuery += "        '(S2) Dev.Vendas' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM, '      '    AS PEDCLI , SD1.R_E_C_N_O_  AS REC  , "
		cQuery += "        0                     AS MARGE , 0           AS MARGV  , "
		cQuery += "        ' '                   AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SD1")+" SD1 ,"
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5 ,"
		cQuery += RetSqlName("SA1")+" SA1  "
      
      
		cQuery += " Where "

	   cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "

      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
		   cQuery += " D1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
  	       cQuery += " D2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
  		   cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	       cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND " 
	       cQuery += " A1_FILIAL='"+Substr(cCombo4,1,2)+"' AND " 
      Else
		   cQuery += " D1_FILIAL<>'99' AND "
  		   cQuery += " D2_FILIAL<>'99' AND "
     	    cQuery+= " C6_FILIAL<>'99' AND "
  		   cQuery += " C5_FILIAL<>'99' AND " 
  		   cQuery += " A1_FILIAL<>'99' AND " 
      Endif	   
    
    	cQuery += " D2_FILIAL=D1_FILIAL AND "
		cQuery += " C6_FILIAL=D1_FILIAL AND "
		cQuery += " C5_FILIAL=D1_FILIAL AND "
		cQuery += " A1_FILIAL=D1_FILIAL AND "
 
		if !EMPTY(cCodigo)

		   cQuery += " D1_FORNECE ='"+cCodigo+"' AND "
		   
		Endif

		if !EMPTY(cLoja)

		   cQuery += " D1_LOJA    ='"+cLoja+"' AND "
		   
		Endif


		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif

		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
	   		cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "
		   
		Endif


		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
	
		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif

   	cQuery += "	 B1_FILIAL =  '  '    AND "
   	cQuery += "	 D1_COD    = B1_COD   AND "
		cQuery += "	 C6_FILIAL = D1_FILIAL AND "
		  
	  	cQuery += "	 A1_LOJA   = D1_LOJA    AND "
      cQuery += "	 A1_COD    = D1_FORNECE AND "
																						
   	cQuery += "	 D1_FORNECE= D2_CLIENTE AND "	
    	cQuery += "	 D1_LOJA   = D2_LOJA    AND "
   	cQuery += "	 D1_NFORI  = D2_DOC     AND "
   	cQuery += "	 D1_SERIORI= D2_SERIE   AND "
   	cQuery += "	 D1_ITEMORI= D2_ITEM    AND "
				                 
   	cQuery += "	 C5_FILIAL = D1_FILIAL   AND "
		cQuery += "	 C5_NUM    = C6_NUM      AND "
	 	cQuery += "  C6_NUM    = D2_PEDIDO   AND "
	  	cQuery += "	 C6_ITEM   = D2_ITEMPV   AND "
					
   	cQuery += "	D1_TIPO in ('D','B')    AND "
		cQuery += " D1_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SA1.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SD2.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SD1.D_E_L_E_T_ <> '*' "

	Endif


	If  alltrim(cCombo3) $ "Ambos|(S1)+(S2)+(S3)+(S4)"

		cQuery += "UNION "
		
	Endif
 

	If  alltrim(cCombo3) $ "Ambos|(S4) Transferencia|(S1)+(S2)+(S3)+(S4)"

		// Saidas Tipo ('N','C','I','P')
		//
		cQuery += " Select D2_FILIAL             AS FILIAL,  B1_COD      AS COD    , B1_DESC       AS DES    , B1_X_MARCA      AS MAR  , A1_CGC      AS CGC , A1_NREDUZ AS NOM , D2_EMISSAO AS DAT, D2_ITEM  AS ITEM, D2_TOTAL   AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 ,  C5_VEND2    AS VEND2  , C5_VEND3      AS VEND3  , C5_VEND4        AS VEND4, C5_VEND5  AS VEND5 , "
		cQuery += "        D2_DOC||'/'||D2_SERIE AS DOC   ,  D2_QUANT    AS QTD    , D2_PEDIDO       AS PED  , D2_ITEM AS ITEM_PV,  C6_X_PRCLI      AS CLI  , D2_PRCVEN   AS VLR , D2_TIPO    AS TIP, "
		cQuery += "        '(S1) Vendas' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM,  C5_X_COTCL  AS PEDCLI , SD2.R_E_C_N_O_  AS REC  ,"
		cQuery += "        D2_X_MARGE            AS MARGE ,  D2_X_MARGV  AS MARGV  , "
		cQuery += "        F4_DUPLIC             AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA1")+" SA1 ,"
		cQuery += RetSqlName("SF4")+" SF4 ,"
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5  "
		cQuery += " Where "

      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
		   cQuery += " D2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
		   cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	   	   cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	   	   cQuery += " A1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
      Else
  		   cQuery += " D2_FILIAL<>'99' AND "
     	   cQuery += " C6_FILIAL<>'99' AND "
  		   cQuery += " C5_FILIAL<>'99' AND " 
  		   cQuery += " A1_FILIAL<>'99' AND " 
     Endif	   

		cQuery += " C6_FILIAL=D2_FILIAL AND "
		cQuery += " C5_FILIAL=D2_FILIAL AND "
		cQuery += " A1_FILIAL=D2_FILIAL AND "
 
	
		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif

		if !EMPTY(cCodigo)
		
   		cQuery += " D2_CLIENTE ='"+cCodigo+"' AND "
		
		Endif

		if !EMPTY(cLoja)

  	   	cQuery += " D2_LOJA    ='"+cLoja+"' AND "
		
		Endif



		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif

		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
	   		cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "
		   
		Endif


		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		
		cQuery += " F4_CODIGO = D2_TES   AND " 
		cQuery += " F4_DUPLIC <> 'S'     AND "
		cQuery += "	D2_PEDIDO = C6_NUM   AND "
		cQuery += "	D2_PEDIDO = C5_NUM   AND "
		cQuery += "	D2_ITEMPV = C6_ITEM  AND "
		cQuery += "	D2_CLIENTE= A1_COD   AND "
		cQuery += "	D2_LOJA   = A1_LOJA  AND "
		cQuery += "	D2_COD    = B1_COD   AND "
		cQuery += " D2_TIPO in ('N','I','P','C')  AND "
		cQuery += " D2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SD2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*' "



      /*
		cQuery += "UNION "

		// Saidas Tipo ('B')  -  ANALIZA  O CADASTRO DE FORNECEDORES NAO LEVANDO EM CONSIDERACAO O CLIENTE
		//
		cQuery += " Select D2_FILIAL             AS FILIAL,  B1_COD      AS COD    , B1_DESC       AS DES    , B1_X_MARCA      AS MAR  , A2_CGC      AS CGC , A2_NREDUZ AS NOM , D2_EMISSAO AS DAT, D2_ITEM  AS ITEM, D2_TOTAL   AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 ,  C5_VEND2    AS VEND2  , C5_VEND3      AS VEND3  , C5_VEND4        AS VEND4, C5_VEND5  AS VEND5 , "
		cQuery += "        D2_DOC||'/'||D2_SERIE AS DOC   ,  D2_QUANT    AS QTD    , D2_PEDIDO       AS PED  , D2_ITEM AS ITEM_PV,  C6_X_PRCLI      AS CLI  , D2_PRCVEN   AS VLR , D2_TIPO    AS TIP, "
		cQuery += "        '(S1) Vendas' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM,  C5_X_COTCL  AS PEDCLI , SD2.R_E_C_N_O_  AS REC  ,"
		cQuery += "        D2_X_MARGE            AS MARGE ,  D2_X_MARGV  AS MARGV  , "
		cQuery += "        F4_DUPLIC             AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA2")+" SA2 ,"
		cQuery += RetSqlName("SF4")+" SF4 ,"
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5  "
		cQuery += " Where "
		cQuery += " A2_FILIAL=D2_FILIAL AND "
		cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += " F4_FILIAL='"+xFilial("SF4")+"' AND "

      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
		   cQuery += " D2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
		   cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	   	cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
      Else
  		   cQuery += " D2_FILIAL<>'99' AND "
     		cQuery += " C6_FILIAL<>'99' AND "
  		   cQuery += " C5_FILIAL<>'99' AND " 
      Endif	   

   	cQuery += "	D2_FILIAL=C6_FILIAL   AND " 
   	cQuery += "	C5_FILIAL=C6_FILIAL   AND " 
		cQuery += "	C5_NUM  = C6_NUM   AND " 
	
		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif
     
		//if !EMPTY(cCodigo)
		//
   	//	cQuery += " D2_CLIENTE ='"+cCodigo+"' AND "
		//
		//Endif
      //
		//if !EMPTY(cLoja)
      //
  	   //	cQuery += " D2_LOJA    ='"+cLoja+"' AND "
		//
		//Endif


		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif

		if !EMPTY(cCdCli)

		   cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
		   
		Endif


		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		
		cQuery += " F4_CODIGO = D2_TES   AND " 
		cQuery += " F4_DUPLIC <> 'S'     AND "
		cQuery += "	D2_PEDIDO = C6_NUM   AND "
		cQuery += "	D2_ITEMPV = C6_ITEM  AND "
		cQuery += "	D2_CLIENTE= A2_COD   AND "
		cQuery += "	D2_LOJA   = A2_LOJA  AND "
		cQuery += "	D2_COD    = B1_COD   AND "
		cQuery += " D2_TIPO in ('B')  AND "
		cQuery += " D2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SD2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*' "
      */

	Endif

	If  alltrim(cCombo3) $ "Ambos|(S1)+(S2)+(S3)+(S4)"

		cQuery += "UNION "
		
	Endif

	
	If  alltrim(cCombo3) $ "Ambos|(S3) Nao Faturado|(S1)+(S2)+(S3)+(S4)"

		//
		// Saidas Tipo ('N','C','I','P')
		//
		cQuery += " Select C9_FILIAL             AS FILIAL, B1_COD      AS COD    , B1_DESC     AS DES    , B1_X_MARCA  AS MAR  , A1_CGC          AS CGC , A1_NREDUZ AS NOM , '        ' AS DAT, '   '  AS ITEM, C9_PRCVEN * C9_QTDLIB AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 , C5_VEND2    AS VEND2  , C5_VEND3    AS VEND3  , C5_VEND4    AS VEND4, C5_VEND5        AS VEND5 , "
		cQuery += "        '      '||'/'||'   '  AS DOC   , C9_QTDLIB   AS QTD    , C5_NUM     AS PED    , C6_ITEM     AS ITEM_PV , C6_X_PRCLI      AS CLI , C9_PRCVEN AS VLR , C5_TIPO    AS TIP, "
		cQuery += "        '(S3) Nao Faturado' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM, C5_X_COTCL  AS PEDCLI , SC9.R_E_C_N_O_  AS REC  ,"
		cQuery += "        C6_X_MARGE            AS MARGE , C6_X_MARGV  AS MARGV  , "
		cQuery += "        '  '                  AS DUPL  "

		cQuery += " From "

		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA1")+" SA1 ,"
		cQuery += RetSqlName("SC9")+" SC9 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5  "

		cQuery += " Where "

		cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "

      	If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
			cQuery += " C9_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " A1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
      	Else
			cQuery += " C9_FILIAL<>'99' AND "
			cQuery += " C6_FILIAL<>'99' AND "
			cQuery += " C5_FILIAL<>'99' AND "
			cQuery += " A1_FILIAL<>'99' AND "
	     Endif	   

		cQuery += " C5_FILIAL=C9_FILIAL AND "
		cQuery += " C6_FILIAL=C9_FILIAL AND "
		cQuery += " A1_FILIAL=C9_FILIAL AND "

		cQuery += " C5_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	C5_NUM   = C6_NUM   AND "

		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif

		if !EMPTY(cCodigo)
		
   		cQuery += " C5_CLIENTE ='"+cCodigo+"' AND "
		
		Endif


		if !EMPTY(cLoja)

  	   	cQuery += " C5_LOJACLI ='"+cLoja+"' AND "
		
		Endif


		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif


		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
		   cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "

		Endif


		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		

		cQuery += " C9_FILIAL =C6_FILIAL AND "
		cQuery += "	C9_PEDIDO = C6_NUM   AND "
		cQuery += "	C9_ITEM   = C6_ITEM  AND "
		cQuery += "	C5_CLIENTE= A1_COD   AND "
		cQuery += "	C5_LOJACLI= A1_LOJA  AND "
		cQuery += "	C9_PRODUTO= B1_COD   AND "
		cQuery += " C5_TIPO  in ('N','I','P','C')  AND "
       /*
		cQuery += "	C9_BLEST <> '  ' AND "         // SOMENTE OS NAO FATURADOS
		cQuery += "	C9_BLEST <> '10' AND "
		*/
		cQuery += "	( (C9_BLEST <> '  ' AND 	C9_BLEST <> '10')  OR  (C9_BLEST = '  ' AND 	C9_BLCRED = ' ' ) ) AND "
      //cQuery += " C6_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC9.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*' "


		cQuery += "UNION "


		//
		// Saidas Tipo ('B') SAIDAS DO TIPO B ANALISA CADASTRO DE FORNECEDORES NAO SERA LEVADO EM CONSIDERACAO
		//                   O CLIENTE
		cQuery += " Select C9_FILIAL             AS FILIAL, B1_COD      AS COD    , B1_DESC     AS DES    , B1_X_MARCA  AS MAR  , A2_CGC          AS CGC , A2_NREDUZ AS NOM , '        ' AS DAT, '   '  AS ITEM, C9_PRCVEN * C9_QTDLIB AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 , C5_VEND2    AS VEND2  , C5_VEND3    AS VEND3  , C5_VEND4    AS VEND4, C5_VEND5        AS VEND5 , "
		cQuery += "        '      '||'/'||'   '  AS DOC   , C9_QTDLIB   AS QTD    , C5_NUM     AS PED    , C6_ITEM     AS ITEM_PV , C6_X_PRCLI      AS CLI , C9_PRCVEN AS VLR , C5_TIPO    AS TIP, "
		cQuery += "        '(S3) Nao Faturado' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM, C5_X_COTCL  AS PEDCLI , SC9.R_E_C_N_O_  AS REC  ,"
		cQuery += "        C6_X_MARGE            AS MARGE , C6_X_MARGV  AS MARGV  , "
		cQuery += "        '  '                  AS DUPL  "

		cQuery += " From "

		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA2")+" SA2 ,"
		cQuery += RetSqlName("SC9")+" SC9 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5  "

		cQuery += " Where "

		cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "

      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
			cQuery += " C9_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " A2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
      Else
			cQuery += " C9_FILIAL<>'99' AND "
			cQuery += " C6_FILIAL<>'99' AND "
			cQuery += " C5_FILIAL<>'99' AND "
			cQuery += " A2_FILIAL<>'99' AND "
      Endif	   

	  cQuery += " C6_FILIAL=C9_FILIAL AND "
	  cQuery += " C5_FILIAL=C9_FILIAL AND "
	  cQuery += " A2_FILIAL=C9_FILIAL AND "

		cQuery += " C5_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	C5_NUM   = C6_NUM   AND "

		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif

		if !EMPTY(cCodigo)
		
   		cQuery += " C5_CLIENTE ='"+cCodigo+"' AND "
		
		Endif


		if !EMPTY(cLoja)

  	   	cQuery += " C5_LOJACLI ='"+cLoja+"' AND "
		
		Endif


		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif


		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
  	   		cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "

		Endif


		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		

		cQuery += " C9_FILIAL =C6_FILIAL AND "
		cQuery += "	C9_PEDIDO = C6_NUM   AND "
		cQuery += "	C9_ITEM   = C6_ITEM  AND "
		cQuery += "	C5_CLIENTE= A2_COD   AND "
		cQuery += "	C5_LOJACLI= A2_LOJA  AND "
		cQuery += "	C9_PRODUTO= B1_COD   AND "
		cQuery += " C5_TIPO  in ('B')  AND "
       /*
		cQuery += "	C9_BLEST <> '  ' AND "         // SOMENTE OS NAO FATURADOS
		cQuery += "	C9_BLEST <> '10' AND "
		*/
		cQuery += "	( (C9_BLEST <> '  ' AND 	C9_BLEST <> '10')  OR  (C9_BLEST = '  ' AND 	C9_BLCRED = ' ' ) ) AND "
      //cQuery += " C6_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC9.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*' "

		
	Endif


	If  alltrim(cCombo3) $ "Ambos"
		
		cQuery += "UNION "
		
	Endif



	
	If  alltrim(cCombo3) $ "Ambos|(E1) Entradas|(E1) + (E2)"

		//
		// Saidas Tipo ('N','C','I','P')
		//
		cQuery += " Select D1_FILIAL             AS FILIAL,  B1_COD      AS COD    ,  B1_DESC       AS DES    , B1_X_MARCA      AS MAR  , A2_CGC          AS CGC , A2_NREDUZ AS NOM , D1_EMISSAO AS DAT, D1_ITEM  AS ITEM, D1_TOTAL   AS TOTAL ,"
		cQuery += "        '     '               AS VEND1 ,  '     '     AS VEND2  ,  '     '       AS VEND3  , '     '         AS VEND4, '     '         AS VEND5 , "
		cQuery += "        D1_DOC||'/'||D1_SERIE AS DOC   ,  D1_QUANT    AS QTD    ,  D1_PEDIDO       AS PED  , D1_ITEM AS ITEM_PV , '     '         AS CLI , D1_VUNIT AS VLR , D1_TIPO    AS TIP, "
		cQuery += "        '(E1) Entradas' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM,  '     '     AS PEDCLI ,  SD1.R_E_C_N_O_  AS REC  ,"
		cQuery += "        0                     AS MARGE ,  0           AS MARGV  , "
		cQuery += "        '  '                  AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SA2")+" SA2 ,"
		cQuery += RetSqlName("SF4")+" SF4 ,"
		cQuery += RetSqlName("SD1")+" SD1  "
	 
		cQuery += " Where "

		cQuery += " A2_FILIAL=D1_FILIAL AND "
		cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += " F4_FILIAL='"+xFilial("SF4")+"' AND "


      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
			cQuery += " D1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
			cQuery += " A2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
      Else
			cQuery += " A2_FILIAL<>'99' AND "
			cQuery += " D1_FILIAL<>'99' AND "
      Endif	   


		if !EMPTY(cCodigo)
		
   		cQuery += " D1_FORNECE ='"+cCodigo+"' AND "
		
		Endif

		if !EMPTY(cLoja)

  	   	cQuery += " D1_LOJA    ='"+cLoja+"' AND "
		
		Endif

		
		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			         
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
		
		cQuery += " F4_CODIGO  = D1_TES  AND "
		cQuery += " F4_ESTOQUE = 'S'     AND "
		cQuery += "	D1_FORNECE= A2_COD   AND "
		cQuery += "	D1_LOJA   = A2_LOJA  AND "
		cQuery += "	D1_COD    = B1_COD   AND "
		cQuery += " D1_TIPO IN ('N','I','P','C')  AND "
		cQuery += " D1_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SA2.D_E_L_E_T_ <> '*' AND "
		cQuery += "	SD1.D_E_L_E_T_ <> '*'     "
		
	Endif


	If  alltrim(cCombo3) $ "Ambos|(E1) + (E2)"
		
		cQuery += "UNION "
		
	Endif


	If  alltrim(cCombo3) $ "Ambos|(E2) Dev.Compras|(E1) + (E2)"

		//
		// Saidas Tipo ('D','B')   // Devolucao de Vendas ( ENTRADAS (DEVOLUCAO DE VENDAS OU RETORNO DE BENEFICIAMETO)
		//
		
		cQuery += " Select D2_FILIAL             AS FILIAL, B1_COD                AS COD   , B1_DESC     AS DES    , B1_X_MARCA      AS MAR  , A2_CGC          AS CGC   , A2_NREDUZ AS NOM , D2_EMISSAO AS DAT, D2_ITEM  AS ITEM, D2_TOTAL   AS TOTAL ,"
		cQuery += "        C5_VEND1              AS VEND1 , C5_VEND2              AS VEND2 , C5_VEND3    AS VEND3  , C5_VEND4        AS VEND4, C5_VEND5        AS VEND5 , "
		cQuery += "        D2_DOC||'/'||D2_SERIE AS DOC   , D2_QUANT    AS QTD    , ' '             AS PED  , D2_ITEM AS ITEM_PV   , ' '             AS CLI ,  D2_PRCVEN AS VLR , D2_TIPO    AS TIP, "
		cQuery += "       	'(E2) Dev.Compras' AS TIPO, B1_X_SIMIL AS SIMIL , "
		cQuery += "        B1_X_SBSIM            AS SUBSIM, '      '    AS PEDCLI , SD1.R_E_C_N_O_  AS REC  , "
		cQuery += "        0                     AS MARGE , 0           AS MARGV  , "
		cQuery += "        ' '                   AS DUPL  "
		cQuery += " From "
		cQuery += RetSqlName("SB1")+" SB1 ,"
		cQuery += RetSqlName("SD1")+" SD1 ,"
		cQuery += RetSqlName("SD2")+" SD2 ,"
		cQuery += RetSqlName("SC6")+" SC6 ,"
		cQuery += RetSqlName("SC5")+" SC5 ,"
		cQuery += RetSqlName("SA2")+" SA2  "
      
      
		cQuery += " Where "

	   cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "

      If ALLTRIM(Substr(cCombo4,1,2)) <> "-" 
		   cQuery += " D2_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
  	      cQuery += " D1_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
  		   cQuery += " C6_FILIAL='"+Substr(cCombo4,1,2)+"' AND "
	      cQuery += " C5_FILIAL='"+Substr(cCombo4,1,2)+"' AND " 
	      cQuery += " A2_FILIAL='"+Substr(cCombo4,1,2)+"' AND " 
      Else
		   cQuery += " D2_FILIAL<>'99' AND "
  		   cQuery += " D1_FILIAL<>'99' AND "
     		cQuery += " C6_FILIAL<>'99' AND "
  		   cQuery += " C5_FILIAL<>'99' AND " 
  		   cQuery += " A2_FILIAL<>'99' AND " 
      Endif	   

    	cQuery += "	D1_FILIAL=D2_FILIAL   AND "
    	cQuery += "	C6_FILIAL=D2_FILIAL   AND "
    	cQuery += "	C5_FILIAL=D2_FILIAL   AND "
    	cQuery += "	A2_FILIAL=D1_FILIAL   AND "

		cQuery += "	A2_COD   =D2_CLIENTE  AND "
		cQuery += "	A2_LOJA  =D2_LOJA     AND "


		if !EMPTY(cCodigo)

		   cQuery += " D2_CLIENTE ='"+cCodigo+"' AND "
		   
		Endif

		if !EMPTY(cLoja)

		   cQuery += " D2_LOJA    ='"+cLoja+"' AND "
		   
		Endif


		if !EMPTY(cPedCli)

		   cQuery += " C5_X_COTCL ='"+cPedCli+"' AND "
		   
		Endif

		if !EMPTY(cCdCli)

		   //cQuery += " C6_X_PRCLI ='"+cCdCli+"' AND "
	   		cQuery += " C6_X_PRCLI LIKE '%"+alltrim(cCdCli)+"%'  AND "
		   
		Endif


		if !EMPTY(cRefe)
			
			cQuery += " B1_X_REFER ='"+cRefe+"' AND "
			
		Endif
		
		if !EMPTY(cSufixo)
			
			cQuery += " B1_X_SUFIX ='"+cSufixo+"' AND "
			
		Endif
		
		if !Empty(cMarca)
			
			cQuery += " B1_X_MARCA ='"+cMarca+"' AND "
			
		Endif
	
		cQuery += "	D2_NFORI   = D1_DOC    AND "
		cQuery += "	D2_SERIORI = D1_SERIE  AND "
      cQuery += "	D2_ITEMORI = D1_ITEM   AND "

   	cQuery += "	C6_FILIAL = D2_FILIAL  AND " 
		cQuery += "	C6_NUM    = D2_PEDIDO  AND "
		cQuery += "	C6_ITEM   = D2_ITEMPV  AND "

  		cQuery += "	C5_NUM   = C6_NUM   AND "

		If  !EmptY(cVendedor)
			cQuery += "( C5_VEND1 = '"+cVendedor+"'  OR "
			cQuery += " C5_VEND2 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND3 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND4 = '"+cVendedor+"'   OR "
			cQuery += " C5_VEND5 = '"+cVendedor+"') AND "
		Endif
		

		cQuery += "	 D2_COD    = B1_COD     AND "
		cQuery += "	 D1_COD    = B1_COD     AND "
		cQuery += " D2_TIPO in ('D','B')   AND "
		cQuery += " D2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' AND "
		cQuery += "	SB1.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SA2.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SD2.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SC6.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SC5.D_E_L_E_T_ <> '*'  AND "
		cQuery += "	SD1.D_E_L_E_T_ <> '*' "

   Endif



   MemoWrit("Consulta02.Sql",cQuery)   //   Apenas utilizado para validar a query.

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)


	// Mostra a GetDados Fases
	oGet:Show()
	oGet:oBrowse:Show()
	oGet:oBrowse:nAt	:= 1
	oGet:oBrowse:lDisablePaint := .F.
	
	// Atualiza aHeader e aCols com dados de Fases
	//aHeader	:={}
	//aHeader := Aclone(aSvFolder[2,1])
	//aCols	:= Aclone(aSvFolder[2,2])
	//aCols	:={}
	

	DbSelectArea(_cAlias)
	DbGotop()
	While !(_cAlias)->(Eof())
		
		
		AADD(aCols,Array(Len(aHeader)+1))
		nLin                        := Len(aCols)
		aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado

      SB1->(DbSelectArea("SB1"),DbSetorder(1),Dbseek(xFilial("SB1")+(_cAlias)->COD ))
      DbSelectArea(_cAlias)

		aCols[nLin, xFilial] := (_cAlias)->FILIAL
		aCols[nLin, xCod   ] := (_cAlias)->COD   // Codigo
		aCols[nLin, xDesc  ] := (_cAlias)->DES + IF(SB1->B1_X_PRODU="2","MTK",SPACE(3))    // Descricao
		aCols[nLin, xCGC   ] := (_cAlias)->CGC    // CGC
		aCols[nLin, xnReduz] := (_cAlias)->NOM    // Nome Reduz
		aCols[nLin, xUcom  ] := STOD((_cAlias)->DAT) // Emissao
		aCols[nLin, xDoc   ] := (_cAlias)->DOC    // Doc
		aCols[nLin, xQuant ] := (_cAlias)->QTD    // Qtde
		aCols[nLin, xPedido] := (_cAlias)->PED    // Num. do Pedido
		aCols[nLin, xItem]   := (_cAlias)->ITEM_PV// Num. do Item
		aCols[nLin, xProCli] := (_cAlias)->CLI    // Pedido do Cliente
		aCols[nLin, xVunit ] := (_cAlias)->VLR    // Valor Unitario
		aCols[nLin, xTip   ] := (_cAlias)->TIP    // Tipo do Documento
		aCols[nLin, xTipo  ] := (_cAlias)->TIPO   // DEVOLUCAO-VENDAS
		aCols[nLin, xTotal ] := (_cAlias)->TOTAL  // Total
		aCols[nLin,	xPedCli] := (_cAlias)->PEDCLI // Pedido do Cliente
		aCols[nLin,	xMargE]  := (_cAlias)->MARGE  // Marge Percentual
		aCols[nLin,	xMargV]  := (_cAlias)->MARGV  // Marge Valor

		aCols[nLin,	xVend1]  := (_cAlias)->VEND1  // Comissao Vendedor 1
		aCols[nLin,	xVend2]  := (_cAlias)->VEND2  // Comissao Vendedor 2
		aCols[nLin,	xVend3]  := (_cAlias)->VEND3  // Comissao Vendedor 3
		aCols[nLin,	xVend4]  := (_cAlias)->VEND4  // Comissao Vendedor 4
		aCols[nLin,	xVend5]  := (_cAlias)->VEND5  // Comissao Vendedor 5

        
        //
        // Valida para verificar se nao existem campos nil no Acols.
        // Se ocorrer preencher
        //
        For nXX:=1 to len(aHeader)
            if aCols[nLin,nXX] = nil
               if aHeader[nXX][8]='D' 
 	              aCols[nLin,nXX] = ctod("")
 	           ElseIF aHeader[nXX][8]='N' 
				  aCols[nLin,nXX] = 0
               ElseIF aHeader[nXX][8]='C' 
				  aCols[nLin,nXX] = '.'  
			   Endif	            
            Endif
        Next    
          

		if  "(S1) Vendas"          $ (_cAlias)->TIPO   // 	.AND.  (_cAlias)->DUPL = 'S'
		
			 nQtdSai += (_cAlias)->QTD
			 nValSai += (_cAlias)->TOTAL

		Elseif  "(S2) Dev.Vendas"   $ (_cAlias)->TIPO

			 nQtdDev += (_cAlias)->QTD
			 nValDev += (_cAlias)->TOTAL

		Elseif  "(E1) Entradas"    $ (_cAlias)->TIPO

			 nQtdEnt += (_cAlias)->QTD
			 nValEnt += (_cAlias)->TOTAL

		Elseif  "(S3) Nao Faturado" $ (_cAlias)->TIPO

			 nQtdNFAT += (_cAlias)->QTD
			 nValNFAT += (_cAlias)->TOTAL

		Endif


		(_cAlias)->(Dbskip())
		
	Enddo
	
	
	(_cAlias)->(DbcloseArea())
	

#ENDIF

IF len(acols) = 0    

	Aviso("ATENCAO", "Nenhum produto foi encontrado com esta Referencia...",{"&Ok"})
	AADD(aCols,Array(Len(aHeader)+1))
	nLin                        := 1
	aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado
	aCols[nLin, xCod   ]       := "."
	aCols[nLin, xDesc  ]       := "."


Else

	// Coloca em Ordem de acordo com a definicao do combo
   nPos0      := aScan(aHeader,{|x| AllTrim(x[2])==ALLTRIM("D2_FILIAL")})
   nPos1      := aScan(aHeader,{|x| AllTrim(x[1])==ALLTRIM(cCombo2)    })
   nPos2      := aScan(aHeader,{|x| AllTrim(x[2])==ALLTRIM("D1_ITEM")  })
   
   
   If Alltrim(aHeader[nPos1][2]) = "D2_PEDIDO" 
 	   aCols := Asort(aCols,,,{|x,y| x[nPos0]+x[nPos1]+x[nPos2]  <  y[nPos0]+y[nPos1]+y[nPos2] })
   Else  
      cTipo := aHeader[nPos1][8] 
      if cTipo = "C"
        aCols := Asort(aCols,,,{|x,y| x[nPos0]+x[nPos1] <  y[nPos0]+y[nPos1] })
      ElseiF cTipo = "D"
        aCols := Asort(aCols,,,{|x,y| x[nPos0]+DTOC(x[nPos1]) <  y[nPos0]+DTOC(y[nPos1]) })
      ElseIF cTipo = "N"
        //aCols := Asort(aCols,,,{|x,y| x[nPos0]+STR(x[nPos1])  <  y[nPos0]+STR(y[nPos1]) })
        aCols := Asort(aCols,,,{|x,y| x[nPos1]  <  x[nPos1] })
      Endif
   Endif

Endif


// Refresh na tela Fases
n	:= Len(aCols)
oGet:oBrowse:Refresh(.T.)
oGet:ForceRefresh()

Return

                                  



User Function ValidFil(cCombo4,cCodigo,cLoja)

//Local nOpt1:=oCombo4:nAt

If ALLTRIM(Substr(cCombo4,1,2)) = "-"
   
   lLibSA1  := .F.  // Bloqueia a Alteracaodo Cliente

Else
                                  
   lLibSA1   := .T.  // Libera a Alteracao do Cliente

   cFilial   := cFilAnt  := ALLTRIM(Substr(cCombo4,1,2))   // Este processo viabiliza a Consulta do Cliente na Filial Desejada SXB

Endif

cCodigo   := SPACE(6)
cLoja     := CriaVar("A1_LOJA")

oCodigo:Refresh()
oLoja:Refresh()

Return

