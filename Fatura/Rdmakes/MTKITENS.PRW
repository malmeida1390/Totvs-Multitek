#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTKITENS  ³ Autor ³ Eduardo Riera         ³ Data ³ 08.12.97  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pesquisa por itens do Orcamento                              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTKITENS()

Local cCadastro := "Consulta de Itens do Orcamento"
Local nY        := 0
Local cCodigo   := SPACE(6)
Local cLoja     := CriaVar("A1_LOJA")
Local bSetKey4
Local bSetKey12
Local bSetKey8
Local nOpc      := 3          // Nao trocar caso contrario comecara a

Local oDlgProd,oCodigo,oLoja
Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5,oCombo2,oCombo3,oCombo4,oPrCli,oMarca,oCotCli
Local oCotCl,oVendedor
Local oRefe,oSufix

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Local oData1,oData2
Local dData1     := Ctod("01/"+STRZERO(Month(dDatabase),2)+"/"+STR(Year(dDatabase),4))
Local dData2     :=dDatabase
Local aAltGr     := {}
Local nLin       := 0


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

Private nQtdEnt    := 0
Private nValEnt    := 0
Private nQtdSai    := 0
Private nValSai    := 0
Private nMargem    := 0

Private aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private lF8        := .T.
Private _cArqPRO   := ""
Private cArqB1     := ""
Private cProcName  := FunName()
Private oGet

Private cNReduz    := SPACE(30)
Private cPrCli     := CriaVar("C6_X_PRCLI")
Private cCotCli    := CriaVar("CJ_COTCLI")
Private cCotcl     := CriaVar("CJ_X_COTCL")
Private cVendedor  := CriaVar("CJ_X_VEND1")


Private cRefe      := CriaVar("B1_X_REFER")
Private cSufix     := CriaVar("B1_X_SUFIX")
Private cMarca     := CriaVar("B1_X_MARCA")

Private nPRODUTO   := 0

Private aCols      := {}
Private aHeader    := {}

Private aItems2    := {} // ORDEM DE APRESENTACAO
Private cCombo2    := ""
Private aItems4    := {} // ORDEM DE APRESENTACAO
Private cCombo4    := ""
Private nPos       := 0
Private aCampos  :={;
"CJ_NUM    ",;
"CK_ITEM   ",;
"CJ_EMISSAO",;
"A1_NREDUZ ",;
"CK_DESCRI ",;
"CK_QTDVEN ",;
"CK_X_CTSTD",;
"CK_X_PRUN ",;
"CK_PRCVEN ",;
"CK_VALOR  ",;
"CK_X_MARGE",;
"CK_X_MARGV",;
"CK_PRODUTO",;
"CJ_X_VEND1",;
"A1_X_VEND2",;
"A1_X_VEND3",;
"A1_X_VEND4",;
"A1_X_VEND5",;
"CJ_CONDPAG",;
"CJ_X_CGC  ",;
"CJ_VALIDA ",;
"CJ_X_DTPRE",;
"CJ_TRANSP ",;
"CJ_STATUS ",;
"CJ_X_ST_CI",;
"CJ_X_TPFRT",;
"CJ_COTCLI ",;
"CJ_X_COTCL",;
"CK_X_PRCLI",;
"CK_X_RESER",;
"CK_X_ITEM0",;
"CK_OBS    ",;
"CJ_X_NUMPV",;
"C5_EMISSAO",;
"CK_X_USER ",;
"CK_X_DTLIB",;
"CK_X_PIS  ",;
"CK_X_COFIN",;
"CK_X_CPMF ",;
"CK_X_ICM  ",;
"CK_X_IPI  ",;
"B1_X_SIMIL",;
"B1_X_SBSIM"}

//"CK_PEDCLI ",;
//"CK_X_MARGA",;
//"CK_X_LIBER"}
//"CK_PRUNIT ",;
//"CJ_X_LIBER",;
//"CK_TES    ",;
//"CK_CLASFIS",;
//"CJ_TIPLIB ",;
//"CJ_MOEDA  ",;
//"CJ_X_MARGE",;
//"CJ_X_MARGV",;
//"CJ_X_MARGA",;
//"CJ_X_NFTRI",;
//"CK_UM     ",;
//"CJ_CLIENTE",;
//"CJ_LOJA   ",;
///"CJ_LOJAENT",;
//"CK_X_REFER",;
//"CK_X_SUFIX",;
//"CK_X_MARCA",;
//"CJ_FRETE  ",;

//"CJ_TIPO   ",;
//"CK_DESCONT",;
//"CK_VALDESC",;
//"CK_NUMPV  ",;
//"CK_X_OBS
//"CJ_MENNOTA",;
//"CJ_NOMCLI ",;
//"CJ_FRETAUT",;
//"CK_FILIAL ",;
//"CK_CLIENTE",;
//"CK_LOJA   ",;
//"CK_X_ENDEN",;
//"CK_COTCLI ",;
//"CK_ITECLI ",;
//"CJ_X_NUM  ",;
//"CJ_TPCARGA",;
//"CJ_X_BAREN",;
//"CJ_X_CIDEN",;
//"CJ_X_UFEN ",;
//"CJ_X_ENDEN",;
//"CJ_TABELA ",;
//"CJ_DESC3  ",;
//"CJ_DESC1  ",;
//"CJ_DESC2  ",;
//"CJ_DESC4  ",;
//"CJ_PARC1  ",;
//"CJ_DATA1  ",;
//"CJ_PARC2  ",;
//"CJ_DATA2  ",;
//"CJ_PARC3  ",;
//"CJ_DATA3  ",;
//"CJ_PARC4  ",;
//"CJ_DATA4  ",;
//"CJ_SEGURO ",;
//"CJ_DESPESA",;
//"CJ_DESCONT",;
//"CJ_PDESCAB",;
//"CJ_TXMOEDA",;
//"CK_X_DTENT",;
//"CK_X_ENTRE",;
//"CK_LOCAL  ",;
//"CK_LOCNOME",;
//"CK_NUMOP  ",;
//"CK_OPC    ",;
//"CK_CONTRAT",;
//"CK_ITEMCON",;

Private aItems3    := {} // LEGENDA DO ORCAMENTO
Private cCombo3    := ""

aadd(aItems3,"Todos               ")
aadd(aItems3,"Liberado  em Aberto ")
aadd(aItems3,"Bloqueado em Aberto ")
aadd(aItems3,"Orcamento Baixado   ")
aadd(aItems3,"Orcamento Cancelado ")
aadd(aItems3,"Orcamento aprovado  ")
aadd(aItems3,"Orcamento nao Orcado")

cCombo3    :="Todos               "



DbSelectArea("SX3")
DbSetOrder(2)
For nY := 1 to Len(aCampos)
	DbSeek(aCampos[nY])
	AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Next
AADD(aHeader,{" "            ,"ALT_VAZIO"  ,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

//
// Monta o Primeiro Acols
//
AADD(aCols,Array(Len(aHeader)+1))
nLin                        := Len(aCols)
aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado
DbSelectArea("SX3")
DbSetOrder(2)
For nPos := 1 to Len(aHeader)-1
	DbSeek(aHeader[nPos][2])
	IF !EMPTY(SX3->X3_CBOX)
		aCols[nLin, nPos   ]       := SX3->X3_RELACAO
	ENDIF
Next nPos


//
// Coloca em Ordem de acordo com a definicao do combo
//
Aadd(aItems4,"Nenhuma")
For nY := 1 to Len(aHeader)-1   // O -1 E PARA EVITAR A ENTRADA DO ULTIMO CAMPO EM BRANCO
    if !("C5_EMISSAO" $ aHeader[nY][2])
    	 aadd(aItems2,aHeader[nY][1])
	    aadd(aItems4,aHeader[nY][1])
	 Endif   
Next
cCombo2    := aItems2[1]
cCombo4    := aItems4[1]




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


AAdd( aObjects, { 100, 060, .t., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 030, .t., .f. } )

// Esta matriz contem os limites da tela
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{005, 025, 050, 110, 120,      160,175,208,217,250,270},;
{005, 098, 120, 160, 200 ,250},;   //050, 130, 180, 250}/*{100,190,180,250}*/
{005, 025, 057, 078, 110 ,128,  160,175     ,217,250,270},;
{005, 025, 057, 078, 110 ,128,  160,175     ,217,250,270}})
nGetLin := aPosObj[3,1]


nPRODUTO:= aScan(aHeader,{|x| AllTrim(x[2])=="CK_PRODUTO"})

DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel
bSetKey4  :=SetKey(VK_F4 , {|| U_MFATC03(aCols[n][nPRODUTO])})
//bSetKey8  := SetKey(VK_F8  ,{|| lF8:=IF(lF8,.F.,.T.) ,GeraMarkB(@cArqB1,@aStru,@oMark,M->cCodigo,oMark)})

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlgProd PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlgProd PIXEL

nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1]
nGetLin := nGetLin - 17


@ nGetLin,aPosGet[1,1]  SAY "Cod.Cliente.:" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin,aPosGet[1,2]  MSGET oCodigo  VAR cCodigo F3 "FA8" Picture "@!"   Size 30,8 OF oDlgProd PIXEL  When .T.;
//Valid ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)

@ nGetLin,aPosGet[1,3] MSGET oLoja  VAR cLoja  Picture "@!"   Size 20,8 OF oDlgProd PIXEL  When .T.;
Valid ExistCli(oGet,cCodigo,cLoja,oData1,oData2,aCols,dData1,dData2)

@ nGetLin,aPosGet[1,4]  SAY cNReduz size 100,8 OF oDlgProd PIXEL          //FONT oFntFecha5


@ nGetLin,aPosGet[1,6]  SAY "De"  size 100,8 OF oDlgProd PIXEL                          //FONT oFntFecha5
@ nGetLin,aPosGet[1,7]  MSGET oData1 VAR dData1  size 50,8 OF oDlgProd PIXEL  When .T.


@ nGetLin,aPosGet[1,8]   SAY "Ate" size 100,8 OF oDlgProd PIXEL                        //FONT oFntFecha5
@ nGetLin,aPosGet[1,9]  MSGET oData2 VAR dData2  size 50,8 OF oDlgProd PIXEL  When .T.

//
// Combo para Definir Ordem Desejada
//
@ nGetLin ,aPosGet[1,10]   SAY "Ordem (A):" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin ,aPosGet[1,11]   MSCOMBOBOX oCombo2 VAR cCombo2 ITEMS aItems2 SIZE 50,50 OF oDlgProd PIXEL Valid .t.


nGetLin += 15


@ nGetLin,aPosGet[3,01]  SAY "Ped. Cliente" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin,aPosGet[3,02]  MSGET oCotCli   VAR cCotCli  Picture "@!"   Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,03]  SAY "Cod.Cliente"  size 100,8 OF oDlgProd PIXEL                      //FONT oFntFecha5
@ nGetLin,aPosGet[3,04]  MSGET oPrCli    VAR cPrCli   Picture "@!"   Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,05]  SAY "Cot.Cliente"  size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
@ nGetLin,aPosGet[3,06]  MSGET oCotCl    VAR cCotCl  Picture "@!"    Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,07]  SAY "Vendedor"     size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
@ nGetLin,aPosGet[3,08]  MSGET oVendedor VAR cVendedor Picture "@!"    Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[3,09]   MSCOMBOBOX oCombo3 VAR cCombo3 ITEMS aItems3 SIZE 50,50 OF oDlgProd PIXEL Valid .t.

@ nGetLin ,aPosGet[3,10]   SAY "Ordem (B):" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin ,aPosGet[3,11]   MSCOMBOBOX oCombo4 VAR cCombo4 ITEMS aItems4 SIZE 50,50 OF oDlgProd PIXEL Valid .t.


nGetLin += 15


@ nGetLin,aPosGet[4,01]  SAY "Referencia" size 100,8 OF oDlgProd PIXEL                   //FONT oFntFecha5
@ nGetLin,aPosGet[4,02]  MSGET oRefe      VAR cRefe   Picture "@!"   Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[4,03]  SAY "Sufixo"     size 100,8 OF oDlgProd PIXEL                      //FONT oFntFecha5
@ nGetLin,aPosGet[4,04]  MSGET oSufix     VAR cSufix  Picture "@!"   Size 50,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[4,05]  SAY "Marca"      size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
@ nGetLin,aPosGet[4,06]  MSGET oMarca     VAR cMarca  Picture "@!"    Size 50,8 OF oDlgProd PIXEL

//@ nGetLin,aPosGet[4,07]  SAY "Vendedor"     size 100,8 OF oDlgProd PIXEL                       //FONT oFntFecha5
//@ nGetLin,aPosGet[4,08]  MSGET oVendedor VAR cVendedor Picture "@!"    Size 50,8 OF oDlgProd PIXEL

@ nGetLin-3,aPosGet[4,11] BUTTON "&Renovar"	  SIZE 40, 15 OF oDlgProd PIXEL ACTION;
(Iif( ValTudo(oGet,oCotCli,oData1,oData2,aCols,cCotCli,dData1,dData2,cCodigo,cLoja,cPrCli,cMarca),;
MsgRun( OemToAnsi( "Aguarde. Efetuando Pesquisa..." ),"",{||MontaAcols(oGet,oCotCli,oData1,oData2,aCols,cCotCli,dData1,dData2,cCodigo,cLoja)}),.T.))




oGet:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,,.T.,aAltGr,4/*nFreeze*/)
//oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:oBrowse:lDisablePaint := .F.
//oGet:oBrowse:nColPos := 5
//oGet:oBrowse:GoDown()
oGet:oBrowse:nFreeze := 2        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
//oGet:oBrowse:nColPos := xPrcven  // Posiciona no Preco de Venda
oGet:nMax:=Len(Acols)




nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 5
@ nGetLin ,aPosGet[2,1]  SAY "Tot.pecas orcadas   ==> QTD.: " of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,2]  SAY nQtdSai                          Picture "@E 999,999,999" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
@ nGetLin ,aPosGet[2,3]  SAY "Val.Total R$:"                  of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
@ nGetLin ,aPosGet[2,4]  SAY nValSai                          Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED
//@ nGetLin ,aPosGet[2,5]  SAY "Margem.: "                     of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HBLUE
//@ nGetLin ,aPosGet[2,6]  SAY nMargem                         Picture "@E 999,999,999.99" of oDlgProd PIXEL  FONT oFntFecha5 COLOR CLR_HRED


ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,;
{|| oDlgProd:End()},{|| oDlgProd:End()}) CENTERED
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

aadd(aButtons,{"S4WB011N",{||U_MFATC03(aCols[n][nPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })

Return (EnchoiceBar(oDlgProd,bOK,bcancel,,aButtons))



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ExistRefe| Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monsta a Lista de Itens das Ultimas Compras com base no TMP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ExistRefe(oGet,oCotCli,oData1,oData2,aCols,cCotCli,dData1,dData2)

Local lRet := .T.

DbSelectArea("SB1")
DbGoTop()
DbOrderNickname("B1REFER")             //B1_X_REFER + B1_X_SIMIL

If !EmptY(cCotCli)
	If  !Dbseek(xFilial("SB1") + cCotCli )
		Aviso("ATENCAO", "Referencia nao Encontrada...",{"&Ok"})
		lRet := .f.
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
Static Function ValTudo(oGet,oCotCli,oData1,oData2,aCols,cCotCli,dData1,dData2)
Local lRet := .T.

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
Static Function MontaAcols(oGet,oCotCli,oData1,oData2,aCols,cCotCli,dData1,dData2,cCodigo,cLoja)


Local cChave   := ""
Local nCount    := 0
Local lQuery    := .F.
Local lContinua := .T.
Local _cAlias := "SB1"
Local aStruSB1  := {}
Local nLin      := 0

Local aStru     := {}
Local nX        := 0

Local	nPosA     := 0
Local nPosB     := 0

Local cOrdem1   := ""
Local cOrdem2   := ""

Local nNumPos   := 0
Local nDatPos   := 0           
Local nI		:= 1

aCols           := {}

nQtdEnt    := 0
nValEnt    := 0
nQtdSai    := 0
nValSai    := 0
nMargem    := 0


#IFDEF TOP
	
	aStruSB1  := SB1->(dbStruct())
	lQuery    := .T.
	_cAlias := "MCONSPR"
	
	cQuery := ""
	cQuery := " Select "
	
	For nPos := 1 to len(aHeader)-1

    	 If  !("C5_EMISSAO" $ aHeader[nPos][2])
     		  cQuery += aHeader[nPos][2]
			  If nPos <> len(aHeader)-1
				  cQuery += ","
			  Endif
		 Endif

	Next nY
	
	cQuery += " From "
	cQuery += RetSqlName("SCJ")+"  (NOLOCK) SCJ ,"
	cQuery += RetSqlName("SCK")+"  (NOLOCK) SCK ,"
	cQuery += RetSqlName("SA1")+"  (NOLOCK) SA1 ,"
	cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1  "
	cQuery += " Where "
	cQuery += " CJ_FILIAL='"+xFilial("SCJ")+"' AND "
	cQuery += " CK_FILIAL='"+xFilial("SCK")+"' AND "
	cQuery += " A1_FILIAL='"+xFilial("SA1")+"' AND "
	cQuery += " B1_FILIAL='"+xFilial("SB1")+"' AND "
	
	
	cQuery += "	CJ_NUM     = CK_NUM      AND "
	cQuery += "	A1_COD     = CJ_CLIENTE  AND "
	cQuery += "	A1_LOJA    = CJ_LOJA     AND "
	
	cQuery += "	B1_COD     = CK_PRODUTO  AND "
	
	cQuery += " CJ_EMISSAO BETWEEN '"+DTOS(dData1)+"' AND '"+DTOS(dData2)+"' AND "
	
	If !Empty(cCodigo)
		cQuery += " A1_COD     = '"+cCodigo+"'  AND "
	Endif

	If !Empty(cLoja)
		cQuery += " A1_LOJA    = '"+cLoja  +"'  AND "
	Endif
	
	If !EmptY(cRefe)
		cQuery += " CK_X_REFER  = '"+cRefe+"'  AND "
	Endif
	
	If !EmptY(cSufix)
		cQuery += " CK_X_SUFIX  = '"+cSufix+"'  AND "
	Endif
	
	If !EmptY(cMarca)
		cQuery += " CK_X_MARCA  LIKE '%"+cMarca+"%'  AND "
	Endif
	
	
	If !EmptY(cCotCli)
		cQuery += " CJ_COTCLI  = '"+cCotCli+"'  AND "
	Endif
	
	If  !EmptY(cPrCli)
		cQuery += " CK_X_PRCLI = '"+cPrCli+"'  AND "
	Endif
	
	
	If  !EmptY(cCotcl)
		cQuery += " CJ_X_COTCL = '"+cCotcl+"'  AND "
	Endif
	
	If  !EmptY(cVendedor)
		cQuery += "( CJ_X_VEND1 = '"+cVendedor+"'  OR "
		cQuery += " A1_X_VEND2 = '"+cVendedor+"'   OR "
		cQuery += " A1_X_VEND3 = '"+cVendedor+"'   OR "
		cQuery += " A1_X_VEND4 = '"+cVendedor+"'   OR "
		cQuery += " A1_X_VEND5 = '"+cVendedor+"') AND "
	Endif
	
	If alltrim(aItems3[2]) $ cCombo3 // "Liberado  em Aberto "
		cQuery += " CJ_STATUS= 'A' AND  CJ_X_MARGA = 'L' AND "
	ElseIf alltrim(aItems3[3]) $ cCombo3 // "Bloqueado em Aberto "
		cQuery += " CJ_STATUS= 'A' AND  CJ_X_MARGA = 'B' AND "
	ElseIf alltrim(aItems3[4]) $ cCombo3 // "Orcamento Baixado   "
		cQuery += " CJ_STATUS= 'B' AND "
	ElseIf alltrim(aItems3[5]) $ cCombo3 // "Orcamento Cancelado "
		cQuery += " CJ_STATUS= 'C' AND  "
	ElseIf alltrim(aItems3[6]) $ cCombo3 // "Orcamento aprovado  "
		cQuery += " CJ_STATUS= 'E' AND "
	ElseIf alltrim(aItems3[7]) $ cCombo3 // "Orcamento nao Orcado"
		cQuery += " CJ_STATUS= 'D' AND "
	Endif
	
	cQuery += "	SCJ.D_E_L_E_T_ <> '*' AND "
	cQuery += "	SCK.D_E_L_E_T_ <> '*' AND "
	cQuery += "	SB1.D_E_L_E_T_ <> '*' AND "
	cQuery += "	SA1.D_E_L_E_T_ <> '*' "
	
	// Coloca em Ordem de acordo com a definicao do combo
	nPosA := aScan(aHeader,{|x| AllTrim(x[1])== Alltrim(cCombo2)})
	nPosB := aScan(aHeader,{|x| AllTrim(x[1])== Alltrim(cCombo4)})
	
	If nPosB = 0 // nPosB = 1 indica nenhuma

		cQuery += "	ORDER BY "+aHeader[nPosA][2]
		
	Else
		
		cQuery += "	ORDER BY "+aHeader[nPosA][2]+","+aHeader[nPosB][2]
		
	Endif
	
	MemoWrit("MTKITENS.Sql",cQuery)   //   Apenas utilizado para validar a query.
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
	
	aStru     := SCJ->(dbStruct())
	For nX := 1 To Len(aStru)
		If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
			TcSetField(_cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	aStru     := SCK->(dbStruct())
	For nX := 1 To Len(aStru)
		If ( aStru[nX][2] <> "C" .And. alltrim(aStru[nX][1])$cQuery )
			TcSetField(_cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
	
	DbSelectArea(_cAlias)
	
	While !(_cAlias)->(Eof())
		
		AADD(aCols,Array(Len(aHeader)+1))
		nLin                        := Len(aCols)
		aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado
		
		
		For nPos:= 1 to Len(aHeader)-1
			    
			 If  !("C5_EMISSAO" $ aHeader[nPos][2])
 	      		aCols[nLin , nPos] := 	(_cAlias)->&(aHeader[nPos][2])
			 Endif
		
		Next nPos
		
		
		nQtdSai += (_cAlias)->CK_QTDVEN
		nValSai += (_cAlias)->CK_VALOR
      nMargem += (_cAlias)->CK_X_MARGV
		
		(_cAlias)->(Dbskip())
		
	Enddo
	
	(_cAlias)->(DbcloseArea())
	
#ENDIF
      


IF len(acols) <> 0

   //
   // Grava a data do Pedido no Acols.
   //
	
	nNumPos:= aScan(aHeader,{|x| AllTrim(x[2])=="CJ_X_NUMPV"})
	nDatPos:= aScan(aHeader,{|x| AllTrim(x[2])=="C5_EMISSAO"})
	
	For nI:= 1 to Len(Acols)
		
		If  !Empty(aCols[nI , nNumPos ])
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			If Dbseek(xFilial("SC5")+aCols[nI , nNumPos])
				aCols[nI , nDatPos] := 	SC5->C5_EMISSAO
			Endif
			
		Endif
		
	Next nI
	
	
Else
	
	
	Aviso("ATENCAO", "Nenhum produto foi encontrado...",{"&Ok"})
	//
	// Monta o Primeiro Acols
	//
	AADD(aCols,Array(Len(aHeader)+1))
	nLin                        := Len(aCols)
	aCols[nLin,Len(aHeader)+1] := .F.           // Nao Deletado
	DbSelectArea("SX3")
	DbSetOrder(2)
	For nPos := 1 to Len(aHeader)-1
		DbSeek(aHeader[nPos][2])
		IF !EMPTY(SX3->X3_CBOX)
			aCols[nLin, nPos   ]       := SX3->X3_RELACAO
		ENDIF
	Next nPos
Endif


Return

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

DbSelectArea("SA1")
DbGoTop()
DbSetOrder(1)
If !Empty(cCodigo) 
	If  !Dbseek(xFilial("SA1") + cCodigo  )
		Aviso("ATENCAO", "Cliente nao Cadastrado...",{"&Ok"})
		cNReduz    := space(30)
		lRet := .f.
	Else
		cNReduz    := SA1->A1_NREDUZ
	Endif
Endif


Return(lRet)

