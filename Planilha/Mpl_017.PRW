#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_EIS_1			1
#DEFINE X_EIS_2			2
#DEFINE X_EIS_3			3
#DEFINE X_EIS_4			4
#DEFINE X_EIS_5			5
#DEFINE X_EIS_6			6
#DEFINE X_EIS_7			7
#DEFINE X_EIS_8			8
#DEFINE X_EIS_9			9
#DEFINE X_EIS_10		10

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPL_017   ºAutor  ³ Anderson           º Data ³  14/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³Classificacao XYZ - 123 - N/I - Lead Time                   º±±
±±ºDesc.     ³Cadastro Regras de Classificacao - Similaridade             º±±
±±ºParametros³Neste cadastro o usuario informa o SIMIL, serao apresentadosº±±
±±º          ³no browse da esquerda todos os EIS com aquela similaridade, º±±
±±º          ³e no browse da direita serao mostradas as SKUs do EIS posi- º±±
±±º          ³cionado. Tera um botao no rodape da pagina "REGRAS DE CLAS- º±±
±±º          ³FICACAO" a qual permitira alterar CRITICIDADE, AQUISICAO,   º±±
±±º          ³ORIGEM e LEAD-TIME.                                         º±±
±±º          ³                                                            º±±
±±º          ³OBS: A ALTERACAO EFETARA TODAS AS SKUS DAQUELE EIS, LOGO NAOº±±
±±º          ³IMPORTA ONDE O PONTEIRO ESTEJA NO BROWSE, NO FINAL TODOS OS º±±
±±º          ³ITENS DO BROWSE DA DIREITA SOFRERAO AS MODIFICACOES.    ,   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_017()


Local aGetArea  := GetArea()
Local cCadastro := "Cadastro Regras de Classificacao - SImilaridade"
Local lInverte  := .f.
Local cFABRI    := GetMark()
Local cRefe     := CriaVar("SB1->B1_X_REFER")
Local cSufix    := CriaVar("SB1->B1_X_SUFIX")
Local cMarc     := CriaVar("SB1->B1_X_MARCA")
Local oMark ,oListB,oRefe,oSufix,oMarc,oDlgProdo,oSimil,oEIScod
Local cArqB1    := ""
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Private _cArqPro  := ""
Private aStru     := {}
Private aCampos   := {}
Private cSimil    := CriaVar("SB1->B1_X_SIMIL")
Private cEISCod	  := Space(20)

Private aListB     := {{"","","","","","","","","","",0}}



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Estrutura do TRB - Browse                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_REFER")	// Referencia
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SUFIX")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_MARCA")	// Fabricante
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_ORIGEM")	// Origem
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Cdtr",X3_PICTURE})

DbSeek("B1_X_SIMIL")	// Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SBSIM")	// Grupo de Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_XYZ")     // Criticidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_123")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_NC_IM")	// NACIONAL/IMPORTADO
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_LT")       // LEAD TIME 
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_ITCPR")    // Item de Compra
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_LTMAN")    // Lote Manual
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_PTMAN")   // Ponto de Pedido Manual
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SHARE")   // Share
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_COD")       // SKU
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_EIS01")	// EIS Codigo 01
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N1",X3_PICTURE}) // Bloqueado para NAO aparecer no browser, so existir no arquivo temporario

DbSeek("B1_X_EIS02")	// EIS Codigo 02
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N2",X3_PICTURE})

DbSeek("B1_X_EIS03")	// EIS Codigo 03
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N3",X3_PICTURE})

DbSeek("B1_X_EIS04")	// EIS Codigo 04
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N4",X3_PICTURE})

DbSeek("B1_X_EIS05")	// EIS Codigo 05
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N5",X3_PICTURE})

DbSeek("B1_X_EIS06")	// EIS Codigo 06
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N6",X3_PICTURE})

DbSeek("B1_X_EIS07")	// EIS Codigo 07
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N7",X3_PICTURE})

DbSeek("B1_X_EIS08")	// EIS Codigo 08
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N8",X3_PICTURE})

DbSeek("B1_X_EIS09")	// EIS Codigo 09
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N9",X3_PICTURE})

DbSeek("B1_X_EIS10")	// EIS Codigo 10
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","N0",X3_PICTURE})

//Caso queira que criemos um campo a mais para ir na ultima posicao do browser para NAO DEIXAR o ultimo campo com dados MUITO GRANDE
AADD(aStru  ,{"T_FINALIZ","C" ,1, 0} )  // Este campo e apenas para corrigir
AADD(aCampos,{"T_FINALIZ","","",""})    // o ultimo item do acols para nao ficar com um espaco enorme.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Trb Vazio                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqB1   := CriaTrab(aStru,.T.)
_cArqPRO := CriaTrab(,.F.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)
IndRegua("TRB",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
dbGotop()


aSize := MsAdvSize()

aObjects := {}

AAdd( aObjects, { 100, 025, .t., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 025, .t., .f. } )

// Esta matriz contem os limites da tela
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )

// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,	{{020,50,105,135,180,200,255,290}} )
nGetLin := aPosObj[3,1]

DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlgProd PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlgProd PIXEL

nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1]
nGetLin := nGetLin - 3
nRefLin := nGetLin

@ nGetLin-20,aPosGet[1,1]	SAY "CADASTRO REGRAS DE CLASSIFICACAO - SIMILARIDADE" size 200,8 OF oDlgProd PIXEL

@ nGetLin,aPosGet[1,1]		SAY "Similaridade:" size 100,8 OF oDlgProd PIXEL
@ nRefLin,aPosGet[1,2]   	MSGET oSimil  VAR cSimil  Picture "@!" F3 "SZ2"  Size 50,8 OF oDlgProd PIXEL  When .T. Valid ExistSimil(@aListB,@oListB,@oMark,cArqB1,@aStru,@M->cSimil,@M->cSufix,@M->cMarc,@oSimil,@oSufix,cFabri,@oEISCod,@cEISCod)
@ nGetLin,aPosGet[1,1]+130	SAY "Codigo do EIS:" size 100,8 OF oDlgProd PIXEL
@ nRefLin,aPosGet[1,2]+130	MSGET oEISCod VAR cEISCod Picture "@!" Size 70,8 OF oDlgProd PIXEL  When .F.


@ aPosObj[2,1],05 LISTBOX oListB FIELDS;
HEADER "N1","N2","N3","N4","N5","N6","N7","N8","N9","N0" ;
SIZE 115,138;
COLSIZES 10,10,10,10,10,10,10,10,10,10,GetTextWidth(0,"BBBBBBBB");
OF oDlgProd PIXEL ;
ON CHANGE (GeraMarkB(aListB[oListB:nAt][X_EIS_1],aListB[oListB:nAt][X_EIS_2],aListB[oListB:nAt][X_EIS_3],aListB[oListB:nAt][X_EIS_4],aListB[oListB:nAt][X_EIS_5],aListB[oListB:nAt][X_EIS_6],aListB[oListB:nAt][X_EIS_7],aListB[oListB:nAt][X_EIS_8],aListB[oListB:nAt][X_EIS_9],aListB[oListB:nAt][X_EIS_10],@cArqB1,@aStru,@oMark,M->cSufix,M->cMarc,oListB,cSimil,@oEISCod,@cEISCod))

oListB:SetArray(aListB)
oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_EIS_1],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_2],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_3],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_4],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_5],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_6],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_7],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_8],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_9],""),20),;
xPadC(Transform(aListB[oListB:nAt,X_EIS_10],""),20)}}
//Transform(aListB[oListB:nAt,X_EIS_11],"@R 99999%")}}
                              

oMark := MsSelect():New("TRB",,,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],125,aPosObj[2,3],aPosObj[2,4]})
//oMark:oBrowse:nFreeze  := 4  // Utilizado para congelar um determinado numero de colunas no browser


nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 3

@ nGetLin-2,aPosGet[1,7]+40	 BUTTON "Sair"	                   SIZE 30, 15 OF oDlgProd PIXEL ACTION oDlgProd:End()
///@ nGetLin-2,005          	 BUTTON "Quotas"	               SIZE 50, 15 OF oDlgProd PIXEL ACTION (U_MESTC03(cSimil,cEISCod),AjQuotas(aListB,oListB),oMark:oBrowse:Refresh(.t.))
@ nGetLin-2,005        	     BUTTON "Classificacao"	           SIZE 50, 15 OF oDlgProd PIXEL ACTION (U__AtuSkus(cFABRI,aListB,oListB,"TRB"),oMark:oBrowse:Refresh(.t.))

ACTIVATE MSDIALOG oDlgProd CENTERED


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TRB")
dbCloseArea()
If File(cArqB1+".DTC")
	Ferase(cArqB1+".DTC")
Endif
       
If File(_cArqPro+OrdBagExt())
   FErase(_cArqPro+OrdBagExt())
Endif

RestArea(aGetArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    |          ³ Autor ³                       ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratamento do Share                                        ³±±
±±³          ³ ValShare() - Verifica se ha Eis com problema de Share      ³±±
±±³          ³ ValGeral() - Valida todos os Eis sem tem problema de Share ³±±
±±³          ³ AjQuotas() - Apos ajuste do Share na tela de quotas ajusta ³±±
±±³          ³              o Trb atual.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function ValShare(aListB,oListB,lMensagem)   

Local lRet       := .T.
Local _SomaShare := 0  
DbSelectArea("TRB")
DbGotop()              
While !TRB->(EOF())
	_SomaShare += TRB->B1_X_SHARE
	TRB->(DbSkip())
Enddo
if _SomaShare <> 100
   If lMensagem 
	  Aviso("Atencao","Antes de continuar rever na coluna Quotas o valor acumulado "+;
	  "na mesma esta em "+ STR(_SomaShare)+ " sendo que para continuar "+;
	  "a somatoria do % distribuido na coluna Quotas deve ser igual a 100 %",{'Ok'})
    Endif
	lRet:=.F.
Endif

aListB[oListB:nAt][X_EIS_11]:=_SomaShare

Return(lRet)


Static  Function ValGeral(aListB,oListB)
Local lRet
For nY := 1 to len(aListB)
    if aListB[nY][X_EIS_11] <> 100 
	    Aviso("Atencao","Antes de continuar rever na coluna Quotas o valor acumulado por EIS. "+;
	         "A somatoria do % distribuido por Sku das Quotas deve ser igual a 100 % ",{'Ok'})
	   	lRet:=.F.
        Exit
     Endif
Next
Return(lRet)   


Static Function AjQuotas(aListB,oListB)
Local _nRegAnt    := 0
Local _SomaShare  := 0

// Atualizar TRB e SB1
DbSelectArea("TRB")
_nRegAnt := Recno()
DbGoTop()

While !EOF()
    
	DbSelectArea("TRB")
	RecLock("TRB",.F.)
	TRB->B1_X_SHARE := SB1->B1_X_SHARE
    TRB->B1_X_PTMAN := SB1->B1_X_PTMAN 
    TRB->B1_X_LTMAN := SB1->B1_X_LTMAN
    //TRB->B1_X_JUTIF := SB1->B1_X_JUSTF 
	MsUnlock()

	TRB->(DbSkip())

EndDo

ValShare(aListB,oListB,.f.)

DbSelectArea("TRB")
DbGotop(_nRegAnt)

Return
*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraListB³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta List Box da Direita da Tela                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GeraListB(aListB,oListB,cSimil,cSufix,cMarc,oMark,oSimil,cArqB1,aStru,cFabri,oEISCod,cEISCod)

Local cChave   := ""
Local aPrVenda  := {}
Local nCount    := 0
Local aSaldoEst := {}
Local lBucaUnid := .F.
Local lQuery    := .F.
Local lContinua := .T.
Local cAliasSB1 := "SB1"
Local aStruSB1  := {}
Local nPos      := 0
aListB:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()
If File(cArqB1+".DTC")
	Ferase(cArqB1+".DTC")
Endif


cArqB1   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)

If !Empty(cSimil)    // Se for digitada a Referencia
	
	
	#IFDEF TOP
		
		
		aStruSB1  := SB1->(dbStruct())
		lQuery    := .T.
		cAliasSB1 := "MPL017SB1"
		
		cQuery := ""
		cQuery := "SELECT COUNT(*) AS nCount "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1")+ " SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL= '" + xFilial("SB1") + "' AND "
		cQuery += "SB1.B1_X_SIMIL = '" + cSimil +"' AND "
		cQuery += "SB1.D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
		nCount := (cAliasSB1)->nCount
		(cAliasSB1)->(DbcloseArea())
		
		
		cQuery := ""
		cQuery := "SELECT SB1.* "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1") + " SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL= '" + xFilial("SB1") + "' AND "
		cQuery += "SB1.B1_X_SIMIL = '" + cSimil +"' AND "
		cQuery += "SB1.D_E_L_E_T_ <> '*' "
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
		For nX := 1 To Len(aStruSB1)
			If ( aStruSB1[nX][2] <> "C" .and. alltrim(aStruSB1[nX][1])$cQuery)
				TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
			EndIf
		Next nX
		
		(cAliasSB1)->(DbGotop())
		
	#ELSE
		
		cAliasSB1 := "SB1"
		DbSelectArea(cAliasSB1)
		DbGoTop()
		DbOrderNickname("B1SIMIL")             //B1_X_SIMIL + EIS
		
		nCount := 0
		If  Dbseek(xFilial("SB1") + cSimil )
			While !(cAliasSB1)->(Eof())  .and. cSimil = (cAliasSB1)->B1_X_SIMIL
				nCount++
				(cAliasSB1)->(DBSKIP())
			Enddo
		Endif
		
		Dbseek(xFilial(cAliasSB1) + cSimil ) // Define todos os Similares
		
	#ENDIF
	
	ProcRegua(nCount)
	
	While !(cAliasSB1)->(Eof())
		
		If  !lQuery
			if  cSimil <> (cAliasSB1)->B1_X_SIMIL
				Exit
			Endif
		Endif
		
		
		IncProc()
		
		
		//
		// Define Separacao dos Itens por Similaridade
		//
		
		nPos := Ascan(aListB,{ |x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]+x[9]+x[10] == B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10 })
		If  nPos == 0 .and. !Empty(cSimil)
			AADD(aListB,{B1_X_EIS01,B1_X_EIS02,B1_X_EIS03,B1_X_EIS04,B1_X_EIS05,B1_X_EIS06,B1_X_EIS07,B1_X_EIS08,B1_X_EIS09,B1_X_EIS10,0})
		Endif
		
		DbSelectArea("TRB")
		Reclock("TRB",.T.)
		TRB->B1_COD      :=  (cAliasSB1)->B1_COD
		TRB->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
		TRB->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
		TRB->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA
		TRB->B1_ORIGEM	 :=  (cAliasSB1)->B1_ORIGEM
		TRB->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
		TRB->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
		TRB->B1_X_XYZ    :=  (cAliasSB1)->B1_X_XYZ
		TRB->B1_X_123    :=  (cAliasSB1)->B1_X_123
		TRB->B1_X_NC_IM  :=  (cAliasSB1)->B1_X_NC_IM
		TRB->B1_X_EIS01	 :=  (cAliasSB1)->B1_X_EIS01
		TRB->B1_X_EIS02	 :=  (cAliasSB1)->B1_X_EIS02
		TRB->B1_X_EIS03	 :=  (cAliasSB1)->B1_X_EIS03
		TRB->B1_X_EIS04	 :=  (cAliasSB1)->B1_X_EIS04
		TRB->B1_X_EIS05	 :=  (cAliasSB1)->B1_X_EIS05
		TRB->B1_X_EIS06	 :=  (cAliasSB1)->B1_X_EIS06
		TRB->B1_X_EIS07	 :=  (cAliasSB1)->B1_X_EIS07
		TRB->B1_X_EIS08	 :=  (cAliasSB1)->B1_X_EIS08
		TRB->B1_X_EIS09	 :=  (cAliasSB1)->B1_X_EIS09
		TRB->B1_X_EIS10	 :=  (cAliasSB1)->B1_X_EIS10
		TRB->B1_X_LT	 :=  (cAliasSB1)->B1_X_LT
		TRB->B1_X_LTMAN  :=  (cAliasSB1)->B1_X_LTMAN // Lote Manual
		TRB->B1_X_PTMAN  :=  (cAliasSB1)->B1_X_PTMAN // Ponto de Pedido Manual.
		TRB->B1_X_SHARE  :=  (cAliasSB1)->B1_X_SHARE // SHARE
		TRB->B1_X_ITCPR  :=  (cAliasSB1)->B1_X_ITCPR // Item de Compra
		MsUnlock()
		
		
		DbSelectArea(cAliasSB1)
		(cAliasSB1)->(DBSKIP())
		
	Enddo
	
	If lQuery
		dbSelectArea(cAliasSB1)
		dbCloseArea()
	EndIf
	
EndIf

if  len(aListB)=0
	
	aListB     := {{"","","","","","","","","","",""}}
	
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_EIS_1],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_2],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_3],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_4],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_5],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_6],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_7],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_8],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_9],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_10],""),20)}}
    //Transform(aListB[oListB:nAt,X_EIS_11],"@R 99999%")}}
	oListB:Refresh()
	
	cSimil := CriaVar("SB1->B1_X_SIMIL")
	oSimil :Refresh()
	SetFocus(oListB:hWnd)
	
Else

    /*
	// Efetuar uma contagem das Quotas para cada Eis
	// E bom lembrar que este TRB ja filtrou por Simil 
    DbSelectArea("TRB")
    DbGoTop()
    While !EOF()
		  nPos := Ascan(aListB,{ |x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]+x[9]+x[10] == B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10 })
          aListB[nPos][11] += TRB->B1_X_SHARE 
       	  TRB->(DbSkip()) 
    Enddo   	  
    */
	  
	
	// Sem estas tres linhas o reflesh nao ocorre de maneira correta.
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_EIS_1],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_2],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_3],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_4],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_5],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_6],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_7],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_8],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_9],""),20),;
	xPadC(Transform(aListB[oListB:nAt,X_EIS_10],""),20)}}
    //Transform(aListB[oListB:nAt,X_EIS_11],"@R 99999%")}}
	oListB:nAt   := 1    // Posiciona no Primeiro Item
	oListB:Refresh()
	
	// Foco no ListBox
	oListB:SetFocus()

Endif

Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraMarkB³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera dados no Trb conf. solitado no filtro para MarkBrowse ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GeraMarkB(cEIS_1,cEIS_2,cEIS_3,cEIS_4,cEIS_5,cEIS_6,cEIS_7,cEIS_8,cEIS_9,cEIS_10,cArqB1,aStru,oMark,cSufix,cMarc,oListB,cSimil,oEISCod,cEISCod)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Trb de acordo com os EIS contidos no LISTBOX          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If  Select("TRB") <> 0 .and. !EmptY(cSimil)
	cEISCod := (cEIS_1 + cEIS_2 + cEIS_3 + cEIS_4 + cEIS_5 + cEIS_6 + cEIS_7 + cEIS_8 + cEIS_9 + cEIS_10)
	dbSelectArea("TRB")
	Set Filter to (TRB->B1_X_EIS01 + TRB->B1_X_EIS02 + TRB->B1_X_EIS03 + TRB->B1_X_EIS04 + TRB->B1_X_EIS05 + TRB->B1_X_EIS06 + TRB->B1_X_EIS07 + TRB->B1_X_EIS08 + TRB->B1_X_EIS09 + TRB->B1_X_EIS10) = (cEIS_1 + cEIS_2 + cEIS_3 + cEIS_4 + cEIS_5 + cEIS_6 + cEIS_7 + cEIS_8 + cEIS_9 + cEIS_10)
    IndRegua("TRB",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
	DbGotop()
Else
	cEISCod := Space(20)
Endif


oEisCod:Refresh()

oMark:oBrowse:Refresh(.t.)

/*
If  Select("TRB") <> 0 .and. !EmptY(cSimil)
    ValShare(aListB,oListB,.T.)
	DbGotop()
Endif
*/

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ExistSimil³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Refencia                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExistSimil(aListB,oListB,oMark,cArqB1,aStru,cSimil,cSufix,cMarc,oSimil,oSufix,cFabri,oEISCod,cEISCod)

// Gera o Trb e a  Matriz separando por Eis
Processa({|| GeraListB(aListB,oListB,cSimil,cSufix,cMarc,oMark,oSimil,cArqB1,aStru,cFabri,oEISCod,cEISCod),"Aguarde...Buscando Simil"})
                                           
// Pega a Primeira posicao da Matriz e com base nesta filtra o TRB 
GeraMarkB(aListB[oListB:nAt][X_EIS_1],aListB[oListB:nAt][X_EIS_2],aListB[oListB:nAt][X_EIS_3],aListB[oListB:nAt][X_EIS_4],aListB[oListB:nAt][X_EIS_5],aListB[oListB:nAt][X_EIS_6],aListB[oListB:nAt][X_EIS_7],aListB[oListB:nAt][X_EIS_8],aListB[oListB:nAt][X_EIS_9],aListB[oListB:nAt][X_EIS_10],@cArqB1,@aStru,@oMark,cSufix,cMarc,oListB,cSimil,@oEISCod,@cEISCod)
                                          

Return(.t.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _AtuSkus ºAutor  ³ Anderson           º Data ³  12/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Monta tela para preencimento dos dados para atualizar cada  º±±
±±º          ³SKU daquele EIS posicionado.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _AtuSkus(cFabri,aListB,oListB,cAlias)

Local _cDesc01 := ""
Local _cDesc02 := ""
Local _cDesc03 := ""
Local _cDesc04 := ""
Local _cDesc05 := ""
Local _cDesc06 := ""
Local _cDesc07 := ""
Local _cDesc08 := ""
Local _cDesc09 := ""
Local _cDesc10 := ""

Local _cSim	  := ""
Local _cEIS01 := ""
Local _cEIS02 := ""
Local _cEIS03 := ""
Local _cEIS04 := ""
Local _cEIS05 := ""
Local _cEIS06 := ""
Local _cEIS07 := ""
Local _cEIS08 := ""
Local _cEIS09 := ""
Local _cEIS10 := ""

Local oEIS01,oEIS02,oEIS03,oEIS04,oEIS05,oEIS06,oEIS07,oEIS08,oEIS09,oEIS10
Local oDes01,oDes02,oDes03,oDes04,oDes05,oDes06,oDes07,oDes08,oDes09,oDes10
Local oSim,oCriti,oAquis,oItEsc,oLeadT,oItemC,oLtMan,oPtMan,oShare

Private _cCriti := ""
Private _cAquis := ""
Private _nLeadT := 0
Private _cItemC := ""
Private _nLtMan := 0
Private _nPtMan := 0
Private _nShare := 0
Private _cItEsc := ""
            
If "#MPL_017" $ Upper(Funname())
   If Len(aListB) == 1
      If Empty(aListB[1][1])
         Aviso('Atencao','Nao existe nenhum item para alterar, verifique !',{'Ok'})
	     Return
      EndIf
   EndIf
Endif

// Dialog para Mostrar o codigo da EIS posicionada, bem como obter as novas
// classificacoes a serem gravadas em todas as SKUs (Do Browser e do SB1)

// Efetuando Seek em cada Nivel para obter a descricao apropriada para consulta

DbSelectArea("Z01")
DbSeek(xFilial("Z01")+(cAlias)->B1_X_EIS01)
_cDesc01 := Z01->Z01_DESC01

DbSelectArea("Z02")
DbSeek(xFilial("Z02")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02)
_cDesc02 := Z02->Z02_DESC02

DbSelectArea("Z03")
DbSeek(xFilial("Z03")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03)
_cDesc03 := Z03->Z03_DESC03

DbSelectArea("Z04")
DbSeek(xFilial("Z04")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04)
_cDesc04 := Z04->Z04_DESC04

DbSelectArea("Z05")
DbSeek(xFilial("Z05")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05)
_cDesc05 := Z05->Z05_DESC05

DbSelectArea("Z06")
DbSeek(xFilial("Z06")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05+(cAlias)->B1_X_EIS06)
_cDesc06 := Z06->Z06_DESC06

DbSelectArea("Z07")
DbSeek(xFilial("Z07")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05+(cAlias)->B1_X_EIS06+(cAlias)->B1_X_EIS07)
_cDesc07 := Z07->Z07_DESC07

DbSelectArea("Z08")
DbSeek(xFilial("Z08")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05+(cAlias)->B1_X_EIS06+(cAlias)->B1_X_EIS07+(cAlias)->B1_X_EIS08)
_cDesc08 := Z08->Z08_DESC08

DbSelectArea("Z09")
DbSeek(xFilial("Z09")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05+(cAlias)->B1_X_EIS06+(cAlias)->B1_X_EIS07+(cAlias)->B1_X_EIS08+(cAlias)->B1_X_EIS09)
_cDesc09 := Z09->Z09_DESC09

DbSelectArea("Z10") // Nao precisa de seek pois ja estou posicionado no arquivo (browser da tela anterior)
DbSeek(xFilial("Z10")+(cAlias)->B1_X_EIS01+(cAlias)->B1_X_EIS02+(cAlias)->B1_X_EIS03+(cAlias)->B1_X_EIS04+(cAlias)->B1_X_EIS05+(cAlias)->B1_X_EIS06+(cAlias)->B1_X_EIS07+(cAlias)->B1_X_EIS08+(cAlias)->B1_X_EIS09+(cAlias)->B1_X_EIS10)
_cDesc10 := Z10->Z10_DESC10

// Criando variaveis locais para a tela

_cSim	:= (cAlias)->B1_X_SIMIL
_cEIS01 := (cAlias)->B1_X_EIS01
_cEIS02 := (cAlias)->B1_X_EIS02
_cEIS03 := (cAlias)->B1_X_EIS03
_cEIS04 := (cAlias)->B1_X_EIS04
_cEIS05 := (cAlias)->B1_X_EIS05
_cEIS06 := (cAlias)->B1_X_EIS06
_cEIS07 := (cAlias)->B1_X_EIS07
_cEIS08 := (cAlias)->B1_X_EIS08
_cEIS09 := (cAlias)->B1_X_EIS09
_cEIS10 := (cAlias)->B1_X_EIS10
_cCriti := (cAlias)->B1_X_XYZ
_cAquis := (cAlias)->B1_X_123
_nLeadT := (cAlias)->B1_X_LT
_nLtMan := (cAlias)->B1_X_LTMAN   // Lote Manual
_nPtMan := (cAlias)->B1_X_PTMAN   // Ponto de Pedido Manual.
_nShare := (cAlias)->B1_X_SHARE   // SHARE

_cItEsc	:= If((cAlias)->B1_X_NC_IM == "I","IMPORTADO","NACIONAL")
_cItemC := If((cAlias)->B1_X_ITCPR == "S","SIM","NAO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oDlg TITLE "Cadastra Regra de Classificacao" FROM 135,70 TO 580+30,710 OF oMainWnd pixel

@ 010,010 Say OemToAnsi("SIMILARIDADE") Size 70,8 OF oDlg PIXEL

@ 030,010 Say OemToAnsi("Codigo da Familia") Size 70,8 OF oDlg PIXEL
@ 045,010 Say OemToAnsi("Divisao da Familia") Size 70,8 OF oDlg PIXEL
@ 060,010 Say OemToAnsi("Tipo da Familia") Size 70,8 OF oDlg PIXEL
@ 075,010 Say OemToAnsi("Divisao Construtiva") Size 70,8 OF oDlg PIXEL
@ 090,010 Say OemToAnsi("1a. Caracteristica") Size 70,8 OF oDlg PIXEL
@ 105,010 Say OemToAnsi("2a. Caracteristica") Size 70,8 OF oDlg PIXEL
@ 120,010 Say OemToAnsi("3a. Caracteristica") Size 70,8 OF oDlg PIXEL
@ 135,010 Say OemToAnsi("4a. Caracteristica") Size 70,8 OF oDlg PIXEL
@ 150,010 Say OemToAnsi("5a. Caracteristica") Size 70,8 OF oDlg PIXEL
@ 165,010 Say OemToAnsi("6a. Caracteristica") Size 70,8 OF oDlg PIXEL


@ 010,075 MsGet oSim Var _cSim Size 17,10 When .F. OF oDlg PIXEL

@ 030,075 MsGet oEIS01 Var _cEIS01 Size 17,10 When .F. OF oDlg PIXEL
@ 045,075 MsGet oEIS02 Var _cEIS02 Size 17,10 When .F. OF oDlg PIXEL
@ 060,075 MsGet oEIS03 Var _cEIS03 Size 17,10 When .F. OF oDlg PIXEL
@ 075,075 MsGet oEIS04 Var _cEIS04 Size 17,10 When .F. OF oDlg PIXEL
@ 090,075 MsGet oEIS05 Var _cEIS05 Size 17,10 When .F. OF oDlg PIXEL
@ 105,075 MsGet oEIS06 Var _cEIS06 Size 17,10 When .F. OF oDlg PIXEL
@ 120,075 MsGet oEIS07 Var _cEIS07 Size 17,10 When .F. OF oDlg PIXEL
@ 135,075 MsGet oEIS08 Var _cEIS08 Size 17,10 When .F. OF oDlg PIXEL
@ 150,075 MsGet oEIS09 Var _cEIS09 Size 17,10 When .F. OF oDlg PIXEL
@ 165,075 MsGet oEIS10 Var _cEIS10 Size 17,10 When .F. OF oDlg PIXEL

@ 030,100 MsGet oDes01 Var _cDesc01 Size 201,10 When .F. OF oDlg PIXEL
@ 045,100 MsGet oDes02 Var _cDesc02 Size 201,10 When .F. OF oDlg PIXEL
@ 060,100 MsGet oDes03 Var _cDesc03 Size 201,10 When .F. OF oDlg PIXEL
@ 075,100 MsGet oDes04 Var _cDesc04 Size 201,10 When .F. OF oDlg PIXEL
@ 090,100 MsGet oDes05 Var _cDesc05 Size 201,10 When .F. OF oDlg PIXEL
@ 105,100 MsGet oDes06 Var _cDesc06 Size 201,10 When .F. OF oDlg PIXEL
@ 120,100 MsGet oDes07 Var _cDesc07 Size 201,10 When .F. OF oDlg PIXEL
@ 135,100 MsGet oDes08 Var _cDesc08 Size 201,10 When .F. OF oDlg PIXEL
@ 150,100 MsGet oDes09 Var _cDesc09 Size 201,10 When .F. OF oDlg PIXEL
@ 165,100 MsGet oDes10 Var _cDesc10 Size 201,10 When .F. OF oDlg PIXEL

// Linha 1	

@ 190,020 Say OemToAnsi("Criticidade") Size 50,10 OF oDlg PIXEL
@ 190,060 MsGet oCriti Var _cCriti Picture PesqPict("SB1","B1_X_XYZ") Size 30,10 F3 "SZP" OF oDlg PIXEL VALID(ExistCPO("SZP",_cCriti)) // Tipo de Criticidade

@ 190,150 Say OemToAnsi("Aquisicao") Size 50,10 OF oDlg PIXEL
@ 190,195 MsGet oAquis Var _cAquis Picture PesqPict("SB1","B1_X_123") Size 30,10 F3 "SZO" OF oDlg PIXEL VALID(ExistCPO("SZO",_cAquis)) // Tipo de Aquisicao

// Linha 2

@ 205,020 Say OemToAnsi("Origem") Size 50,10 OF oDlg PIXEL
@ 205,060 MSCOMBOBOX oItEsc VAR _cItEsc ITEMS {"NACIONAL","IMPORTADO"} SIZE 80,10 OF oDlg PIXEL                   // Nacional ou Importado

@ 205,150 Say OemToAnsi("Lead Time") Size 50,10 OF oDlg PIXEL
@ 205,195 Msget oLeadT Var _nLeadT Picture PesqPict("SB1","B1_X_LT") Size 30,10 OF oDlg PIXEL                        // Lead Time (Dias)
@ 205,200 Say OemToAnsi("(Dias)") Size 50,10 OF oDlg PIXEL

/*
@ 220,150 Say OemToAnsi("Item de Compra") Size 50,10 OF oDlg PIXEL
@ 220,195 MSCOMBOBOX oItemC VAR _cItemC ITEMS {"SIM","NAO"} SIZE 30,10 OF oDlg PIXEL                   // Nacional ou Importado

// Linha 4

@ 235,020 Say OemToAnsi("Lote Manual") Size 50,10 OF oDlg PIXEL
@ 235,060 Msget oLtMan Var _nLtMan Picture PesqPict("SB1","B1_X_LTMAN") Size 80,10 OF oDlg PIXEL                        // Lead Time (Dias)

@ 235,150 Say OemToAnsi("Pt.Ped.Manual") Size 50,10 OF oDlg PIXEL
@ 235,195 Msget oPtMan Var _nPtMan Picture PesqPict("SB1","B1_X_PTMAN") Size 80,10 OF oDlg PIXEL                        // Lead Time (Dias)
*/


@ 190,260 Button "Confirmar" Size 40,15 Of oDlg Pixel ACTION if(_Atual(aListB,oListB),oDlg:End(),)
@ 205,260 Button "Sair" Size 40,15 Of oDlg Pixel ACTION oDlg:End()


Activate MsDialog oDlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _Atual   ºAutor  ³ Anderson           º Data ³  26/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Atualiza dados no TRB bem como no seu SB1 respectivo        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _Atual(aListB,oListB)

Local _nRegAnt    := 0
Local _SomaShare  := 0


If  "MPL_017" $ Upper(Funname())
	
	// Atualizar TRB e SB1
	DbSelectArea("TRB")
	_nRegAnt := Recno()
	DbGoTop()
	
	While !TRB->(EOF())
		
		DbSelectArea("TRB")
		RecLock("TRB",.F.)
		TRB->B1_X_XYZ		:= _cCriti
		TRB->B1_X_123		:= _cAquis
		TRB->B1_X_NC_IM	:=  if(Alltrim(_cItEsc) == "NACIONAL","N","I")
		TRB->B1_X_LT		:= _nLeadT
		//TRB->B1_X_ITCPR := if(Alltrim(_cItemC) == "NAO","N","S")
		//TRB->B1_X_LTMAN := _nLtMan
		//TRB->B1_X_PTMAN := _nPtMan
		MsUnlock()
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+TRB->B1_COD)
			RecLock("SB1",.F.)
			SB1->B1_X_XYZ		:= _cCriti
			SB1->B1_X_123		:= _cAquis
			SB1->B1_X_NC_IM	    :=  if(Alltrim(_cItEsc) == "NACIONAL","N","I")
			SB1->B1_X_LT		:= _nLeadT
			SB1->B1_X_ITCPR     := if(Alltrim(_cItemC) == "NAO","N","S")
			SB1->B1_X_LTMAN     := _nLtMan
			SB1->B1_X_PTMAN     := _nPtMan
			MsUnlock()
		EndIf
		
		DbSelectArea("TRB")
		TRB->(DbSkip())
		
		
	EndDo
	
	DbSelectArea("TRB")
	DbGotop(_nRegAnt)
	
Else
	
	RecLock("SB1",.F.)
	SB1->B1_X_XYZ		:= _cCriti
	SB1->B1_X_123		:= _cAquis
	SB1->B1_X_NC_IM	    :=  if(Alltrim(_cItEsc) == "NACIONAL","N","I")
	SB1->B1_X_LT		:= _nLeadT
	SB1->B1_X_ITCPR     := if(Alltrim(_cItemC) == "NAO","N","S")
	SB1->B1_X_LTMAN     := _nLtMan
	SB1->B1_X_PTMAN     := _nPtMan
	MsUnlock()
	
	
Endif

Return(.t.)