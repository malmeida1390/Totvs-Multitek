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
±±ºPrograma  ³MPL_018   ºAutor  ³ Anderson           º Data ³  26/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela que Personaliza Itens de Compra                        º±±
±±ºParametros³Esta tela permite selecionar atraves de uma referencia,     º±±
±±º          ³todas as SKUs separadas por grupo de similaridade, onde     º±±
±±º          ³poderemos marcar os itens que deverao ou nao ser considera- º±±
±±º          ³dos itens de compra.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_018()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Em funcao da utilizacao de Interfaces de varios      ³
//³ programas e aconselhaveu manter todas as variaveis   ³
//³ como Local evitando o uso de Private                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aGetArea  := GetArea()
Local cCadastro := "Personalizar Itens de Compra"
Local lInverte  := .f.
Local aStru     := {}
Local aCampos   := {}
Local cFABRI    := GetMark()
Local cRefe     := CriaVar("SB1->B1_X_REFER")
Local cSufix    := CriaVar("SB1->B1_X_SUFIX")
Local cMarc     := CriaVar("SB1->B1_X_MARCA")
Local cSimil    := CriaVar("SB1->B1_X_SIMIL")
Local oMark , oListB , oRefe,oSufix,oMarc,oDlgProd,oQuan
Local cArqB1    := ""

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)
                        

Private aListB     := {{""}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Estrutura do TRB - MarkBrowse ou Browse         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// SOMENTE SE FOR MARKBROWSER
AADD(aStru  ,{"T_OK","C", 2 , 0} )
AADD(aCampos,{"T_OK",""," "," "})

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_ITCPR")	// Referencia
AADD(aStru  ,{X3_CAMPO,X3_TIPO,3,0} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_REFER")	// Referencia
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SUFIX")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_MARCA")	// Fabricante
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_ORIGEM")	   // Origem  // B1_X_NC_IM
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

AADD(aStru  ,{"T_SLDMAL","N", 14 , 2} )
AADD(aCampos,{"T_SLDMAL","","Sld.Malha","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDMAT","N", 14 , 2} )
AADD(aCampos,{"T_SLDMAT","","Matriz","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDFIL","N", 14 , 2} )
AADD(aCampos,{"T_SLDFIL","","Filiais","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDCON","N", 14 , 2} )
AADD(aCampos,{"T_SLDCON","","Consignados","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDTRA","N", 14 , 2} )
AADD(aCampos,{"T_SLDTRA","","Transito","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDEMP","N", 14 , 2} )
AADD(aCampos,{"T_SLDEMP","","Empenhado","@E 99,999,999,999"})

AADD(aStru  ,{"T_SLDCLASS","N", 14 , 2} )
AADD(aCampos,{"T_SLDCLASS","","Classificar","@E 99,999,999,999"})

DbSeek("B1_X_PQR")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_NEOIL")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_XYZ")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_123")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_ABC")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_APN_A")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_TMEA")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_COD")       // SKU
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SIMIL")	// Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SBSIM")	// Grupo de Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_EIS01")	// EIS Codigo 01
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N1",X3_PICTURE})

DbSeek("B1_X_EIS02")	// EIS Codigo 02
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N2",X3_PICTURE})

DbSeek("B1_X_EIS03")	// EIS Codigo 03
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N3",X3_PICTURE})

DbSeek("B1_X_EIS04")	// EIS Codigo 04
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N4",X3_PICTURE})

DbSeek("B1_X_EIS05")	// EIS Codigo 05
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N5",X3_PICTURE})

DbSeek("B1_X_EIS06")	// EIS Codigo 06
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N6",X3_PICTURE})

DbSeek("B1_X_EIS07")	// EIS Codigo 07
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N7",X3_PICTURE})

DbSeek("B1_X_EIS08")	// EIS Codigo 08
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N8",X3_PICTURE})

DbSeek("B1_X_EIS09")	// EIS Codigo 09
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N9",X3_PICTURE})

DbSeek("B1_X_EIS10")	// EIS Codigo 10
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","N0",X3_PICTURE})

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

@ nGetLin-20,aPosGet[1,1]	SAY "PERSONALIZAR ITENS DE COMPRA" size 200,8 OF oDlgProd PIXEL
@ nGetLin,aPosGet[1,1]		SAY "Referencia" size 100,8 OF oDlgProd PIXEL
//@ nGetLin,aPosGet[1,1]+100	SAY "Sufixo" size 100,8 OF oDlgProd PIXEL
//@ nGetLin,aPosGet[1,1]+200	SAY "Marca" size 100,8 OF oDlgProd PIXEL

@ aPosObj[2,1],05 LISTBOX oListB FIELDS;
HEADER "      Simil" ;
SIZE 50,100;
COLSIZES 30 ;
OF oDlgProd PIXEL ;
ON CHANGE (GeraMarkB(aListB[oListB:nAt][X_SIMIL],@cArqB1,@aStru,@oMark,M->cRefe,M->cSufix,M->cMarc,oListB))
oListB:SetArray(aListB)
oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}

oMark := MsSelect():New("TRB","T_OK",,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],060,aPosObj[2,3],aPosObj[2,4]})
oMark:bMark := { || MfatDisp(cFABRI,lInverte,@oMark) }   // Atualiza outras telas quando dispara o evento click
oMark:oBrowse:lhasMark = .T.
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark) } // Permite inverter,
//oMark:oBrowse:nFreeze  := 4  // Utilizado para congelar um determinado numero de colunas no browser

// ACIMA ALGUMAS LINHAS FORAMA BLOQUEADAS, AS QUAIS SERIAM USADAS CASO ESTE BROWSER FOSSE MARKBROWSER
// NO OMARK ONDE CRIA-SE A MSSELECT, CASO NAO PASSEMOS O CAMPO QUE TERA A MARCA (T_OK) ELE SE COMPORTA COMO UM BROWSER SIMPLES

nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 3

@ nGetLin-2,aPosGet[1,7]+40	BUTTON "Sair"			   		SIZE 30, 15 OF oDlgProd PIXEL ACTION oDlgProd:End()
//@ nGetLin-2,aPosGet[1,7]-40	BUTTON "Alterar"				SIZE 30, 15 OF oDlgProd PIXEL ACTION (_FindEIS(cFABRI,aListB),oMark:oBrowse:Refresh(.t.))
@ nGetLin-2,005					BUTTON "Marcar Todos"			SIZE 50, 15 of oDlgProd PIXEL ACTION _MarDes("M",cFabri,oMark)
@ nGetLin-2,060					BUTTON "Desmarcar Todos"		SIZE 50, 15 of oDlgProd PIXEL ACTION _MarDes("D",cFabri,oMark)
@ nGetLin-2,115					BUTTON "Marcar para SIM"		SIZE 50, 15 of oDlgProd PIXEL ACTION _MarSIM(cFABRI,lInverte,oMarK)
@ nGetLin-2,170					BUTTON "Marcar para NAO"		SIZE 50, 15 of oDlgProd PIXEL ACTION _MarNAO(cFABRI,lInverte,oMarK)

@ nRefLin,aPosGet[1,2]		MSGET oRefe  VAR cRefe  Picture "@!" /*F3"Z31"*/ Size 50,8 OF oDlgProd PIXEL  When .T. Valid ExistRefe(@aListB,@oListB,@oMark,cArqB1,@aStru,@M->cRefe,@M->cSufix,@M->cMarc,@oRefe,@oQuan,@oSufix,cFabri)
//@ nRefLin,aPosGet[1,2]+100	MSGET oSufix VAR cSufix Picture "@!" /*F3 "Coloque AQUI o ALIAS"*/  Size 50,8 OF oDlgProd PIXEL  When .T.
//@ nRefLin,aPosGet[1,2]+200	MSGET oMarc  VAR cMarc  Picture "@!" /*F3 "Coloque AQUI o ALIAS"*/  Size 50,8 OF oDlgProd PIXEL  When .T. Valid ExistRefe(@aListB,@oListB,@oMark,cArqB1,@aStru,@M->cRefe,@M->cSufix,@M->cMarc,@oRefe,@oQuan,@oSufix,cFabri)

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


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatDisp  ³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³MfatDisp													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MfatDisp(cFABRI,lInverte,oMark)

// CASO FOR MARKBROWSER
// AQUI deveria ter uma condicao para saber se esta marcado ou NAO (UM IF) porem o mesmo foi retirado,
// Sempre que o usuario der 2 cliques sera chamada esta funcao.

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatInvS  ³ Autor ³Anderson               ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte FABRIoes 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MfatInvS     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MfatInvS(cFABRI,oMark)

// Esta funcao marca ou desmarca tudo no MarkBrowser, NA VERDADE ela INVERTE TUDO.

Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()

While !Eof()
	RecLock("TRB",.F.)
	IF  T_OK == cFABRI
		TRB->T_OK := Space(2)
	Else
		TRB->T_OK := cFABRI
	Endif
	
	MsUnlock()
	DbSkip()
	
Enddo

TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³_MarDes   ³ Autor ³Anderson               ³ Data ³ 28/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marcar ou Desmarcar realmente tudo                         ³±±
±±³          ³ Pois a Funcao do Microsiga ate marca e desmarca tudo, mas  ³±±
±±³          ³ o objetivo dela eh efetuar a inversao (nao atendo, mas esta³±±
±±³          ³ disponivel na funcao acima (MfatInvS).                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Multi-Tek     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _MarDes(_cOp,cFabri,oMark)

Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()

While !Eof()
	
	RecLock("TRB",.F.)
	IF  _cOp == "D"
		TRB->T_OK := Space(2)
	Else
		TRB->T_OK := cFABRI
	Endif
	MsUnlock()
	DbSkip()
	
Enddo

TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³_MarSIM   ³ Autor ³Anderson               ³ Data ³ 28/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marcar todos os marcados para SIM no TRB e no SB1          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Multi-Tek    											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _MarSIM(cFABRI,lInverte,oMarK)


Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()

While !Eof()
	
	If IsMark("T_OK",cFABRI,lInverte)
		
		RecLock("TRB",.F.)
		TRB->B1_X_ITCPR :=  "SIM"
		MsUnlock()
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+TRB->B1_COD)
			
			RecLock("SB1",.F.)
			SB1->B1_X_ITCPR :=  "S"
			MsUnlock()
			
		EndIF
		
	EndIF
	
	DbSelectArea("TRB")
	DbSkip()
	
Enddo

TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³_MarNAO   ³ Autor ³Anderson               ³ Data ³ 28/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marcar todos os marcados para NAO no TRB e no SB1          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Multi-Tek    											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _MarNAO(cFABRI,lInverte,oMarK)


Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()

While !Eof()
	
	If IsMark("T_OK",cFABRI,lInverte)
		
		RecLock("TRB",.F.)
		TRB->B1_X_ITCPR :=  "NAO"
		MsUnlock()
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+TRB->B1_COD)
			
			RecLock("SB1",.F.)
			SB1->B1_X_ITCPR :=  "N"
			MsUnlock()
			
		EndIF
		
	EndIF
	
	DbSelectArea("TRB")
	DbSkip()
	
Enddo

TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)

Return



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

Static Function GeraListB(aListB,oListB,cRefe,cSufix,cMarc,oMark,oRefe,cArqB1,aStru,cFabri)

Local cChave   := ""
Local aPrVenda  := {}
Local nCount    := 0
Local lBucaUnid := .F.
Local lQuery    := .F.
Local lContinua := .T.
Local cAliasSB1 := "SB1"
Local aStruSB1  := {}
Local aSaldoEst := {}

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

If !Empty(cRefe)    // Se for digitada a Referencia

    /* Conforme solicitacao do Sr. Mauricio somente efetua busca
    pela referencia 21.09.04  
	//
	// Busca pela unidade de Medida
	//
	DbSelectArea("SZ3")
	DbSetOrder(2)       // Z3_FILIAL +  Z3_DESC  (NOVO INDICE)
	if DbSeek(xFilial("SZ3") + cRefe )
		lBucaUnid := .T.
		cChave   := "B1_X_MEDID"
	Else
		lBucaUnid := .F.
		cChave   := "B1_X_REFER"
	Endif
	*/
	
	
	aStruSB1  := SB1->(dbStruct())
	lQuery    := .T.
	cAliasSB1 := "MPL016SB1"
	
	cQuery := ""
	cQuery := "SELECT COUNT(*) AS nCount "
	cQuery += "FROM "
	cQuery += RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	//if lBucaUnid
	//	cQuery += "SB1.B1_X_MEDID ='"+SZ3->Z3_CODIGO +"' AND "
	//Else
		cQuery += "SB1.B1_X_REFER ='"+cRefe+"' AND "
	//Endif
	If !Empty(cSufix)
		cQuery += "SB1.B1_X_SUFIX ='"+cSufix+"' AND "
	EndIF
	If !Empty(cMarc)
		cQuery += "SB1.B1_X_MARCA ='"+cMarc+"' AND "
	EndIf
	cQuery += "SB1.B1_X_SIMIL <> '' AND " // Aqui filtramos todos os registro do SB1 que NAO forem ref. materiais (MRP MULTI-TEK)
	cQuery += "SB1.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	nCount := (cAliasSB1)->nCount
	(cAliasSB1)->(DbcloseArea())
	
	
	cQuery := ""
	cQuery := "SELECT SB1.* "
	cQuery += "FROM "
	cQuery += RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	//if lBucaUnid
	//	cQuery += "SB1.B1_X_MEDID ='"+SZ3->Z3_CODIGO +"' AND "
	//Else
		cQuery += "SB1.B1_X_REFER ='"+cRefe+"' AND "
	//Endif
	If !Empty(cSufix)
		cQuery += "SB1.B1_X_SUFIX ='"+cSufix+"' AND "
	EndIF
	If !Empty(cMarc)
		cQuery += "SB1.B1_X_MARCA ='"+cMarc+"' AND "
	EndIf
	cQuery += "SB1.B1_X_SIMIL <> '' AND " // Aqui filtramos todos os registro do SB1 que NAO forem ref. materiais (MRP MULTI-TEK)
	cQuery += "SB1.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	For nX := 1 To Len(aStruSB1)
		If ( aStruSB1[nX][2] <> "C" .and. alltrim(aStruSB1[nX][1])$cQuery)
			TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
		EndIf
	Next nX
	
	(cAliasSB1)->(DbGotop())
	
	ProcRegua(nCount)
	
	While !(cAliasSB1)->(Eof())
		
		If  !lQuery
			
			//If lBucaUnid
			//	if  SZ3->Z3_CODIGO <> &cChave
			//		Exit
			//	Endif
			//Else
				if  cRefe <> &cChave
					Exit
				Endif
			//Endif
		Endif
		
		IncProc()
		
 		if 	lContinua
			
			//
			// Define Separacao dos Itens por Similaridade
			//
			nPos := Ascan(aListB,{|x| x[1] == (cAliasSB1)->B1_X_SIMIL })
			If  nPos = 0 .and. alltrim(cRefe) <> ""
				AADD(aListB,{ (cAliasSB1)->B1_X_SIMIL } )
			Endif
			
			
			//
			// Define Saldos em estoque
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Parametros : Codigo do Produto                                            ³
			//³                                                                          ³
			//³Retorna:                                                                  ³
			//³                                                                          |
			//³[01]     MALHA                                                            ³
			//³[01][01] SaldoSb2() // Saldo Disponivel                                   ³
			//³[01][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
			//³[01][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
			//³[01][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
			//³[01][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
			//³[01][06] B2_QEMP    // Quantidade Empenhada                               ³
			//³[01][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
			//³[01][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
			//³[01][09] B2_QCLASS  // Quant.a Classificar                                ³
			//³[01][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
			//³                                                                          |
			//³[02]     MATRIZ                                                           ³
			//³[02][01] SaldoSb2() // Saldo Disponivel                                   ³
			//³[02][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
			//³[02][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
			//³[02][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
			//³[02][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
			//³[02][06] B2_QEMP    // Quantidade Empenhada                               ³
			//³[02][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
			//³[02][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
			//³[02][09] B2_QCLASS  // Quant.a Classificar                                ³
			//³[02][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
			//³                                                                          |
			//³                                                                          |
			//³[03]     FILIAL                                                           ³
			//³[03][01] SaldoSb2() // Saldo Disponivel                                   ³
			//³[03][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
			//³[03][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
			//³[03][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
			//³[03][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
			//³[03][06] B2_QEMP    // Quantidade Empenhada                               ³
			//³[03][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
			//³[03][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
			//³[03][09] B2_QCLASS  // Quant.a Classificar                                ³
			//³[03][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
			//³                                                                          |
			//³                                                                          |
			//³[04]     CONSIGNADOS                                                      ³
			//³[04][01] SaldoSb2() // Saldo Disponivel                                   ³
			//³[04][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
			//³[04][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
			//³[04][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
			//³[04][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
			//³[04][06] B2_QEMP    // Quantidade Empenhada                               ³
			//³[04][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
			//³[04][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
			//³[04][09] B2_QCLASS  // Quant.a Classificar                                ³
			//³[04][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSaldoEst  := U_SaldoSb2((cAliasSB1)->B1_COD)  // MFATC12.PRW
			
			Reclock("TRB",.T.)
			TRB->T_SLDMAL    :=  aSaldoEst[01][10]   //  Malha  (Disp + PC)
			TRB->T_SLDMAT    :=  aSaldoEst[02][10]   //  Matriz (Disp + PC)
			TRB->T_SLDFIL    :=  aSaldoEst[03][10]   //  Filial (Disp + PC)
			TRB->T_SLDCON    :=  aSaldoEst[04][10]   //  Filial (Disp + PC)
			TRB->T_SLDTRA    :=  aSaldoEst[01][07]   //  Malha  (B2_SALPEDI - Prev.Entrar)
			TRB->T_SLDEMP    :=  aSaldoEst[01][06]   //  Malha  (Empenhada)
			TRB->T_SLDCLASS  :=  aSaldoEst[01][09]   //  Malha  (Empenhada)

			TRB->B1_X_ITCPR  :=  If((cAliasSB1)->B1_X_ITCPR=="S","SIM","NAO")
			TRB->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
			TRB->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
			TRB->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA
			TRB->B1_ORIGEM   :=  (cAliasSB1)->B1_ORIGEM  //B1_X_NC_IM
			TRB->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
			TRB->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
			TRB->B1_X_PQR	  :=  (cAliasSB1)->B1_X_PQR
			TRB->B1_X_NEOIL	  :=  (cAliasSB1)->B1_X_NEOIL
			TRB->B1_X_XYZ	  :=  (cAliasSB1)->B1_X_XYZ
			TRB->B1_X_123	  :=  (cAliasSB1)->B1_X_123
			TRB->B1_X_ABC	  :=  (cAliasSB1)->B1_X_ABC
			TRB->B1_X_APN_A	  :=  (cAliasSB1)->B1_X_APN_A
			TRB->B1_X_TMEA	  :=  (cAliasSB1)->B1_X_TMEA
			TRB->B1_COD      :=  (cAliasSB1)->B1_COD
			TRB->B1_X_EIS01	  :=  (cAliasSB1)->B1_X_EIS01
			TRB->B1_X_EIS02	  :=  (cAliasSB1)->B1_X_EIS02
			TRB->B1_X_EIS03	  :=  (cAliasSB1)->B1_X_EIS03
			TRB->B1_X_EIS04	  :=  (cAliasSB1)->B1_X_EIS04
			TRB->B1_X_EIS05	  :=  (cAliasSB1)->B1_X_EIS05
			TRB->B1_X_EIS06	  :=  (cAliasSB1)->B1_X_EIS06
			TRB->B1_X_EIS07	  :=  (cAliasSB1)->B1_X_EIS07
			TRB->B1_X_EIS08	  :=  (cAliasSB1)->B1_X_EIS08
			TRB->B1_X_EIS09	  :=  (cAliasSB1)->B1_X_EIS09
			TRB->B1_X_EIS10	  :=  (cAliasSB1)->B1_X_EIS10
			
			
			MsUnlock()
			
		Endif
		
		DbSelectArea(cAliasSB1)
		(cAliasSB1)->(DBSKIP())
		
	Enddo
	
	If lQuery
		dbSelectArea(cAliasSB1)
		dbCloseArea()
	EndIf
	
EndIf

if  len(aListB)=0

	aListB:={{""}}
	
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
	oListB:Refresh()
	
	cRefe := CriaVar("SB1->B1_X_REFER")
	oRefe :Refresh()
	//SetFocus(oRefe:hWnd)
	SetFocus(oListB:hWnd)

	Aviso('Atencao','Nenhum item foi encontrado para a Referencia',{'Ok'})
	
Else
	
	// Orderno os Similares
	aSort( aListB, , , { |x,y| y[1] > x[1] } )
	
	// Sem estas tres linhas o reflesh nao ocorre de maneira correta.
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
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

Static Function GeraMarkB(cSimil,cArqB1,aStru,oMark,cRefe,cSufix,cMarc,oListB)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Trb de acordo com a Similaridade                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Select("TRB") <> 0 .and. !EmptY(cSimil)
	dbSelectArea("TRB")
	Set Filter to TRB->B1_X_SIMIL = cSimil
    IndRegua("TRB",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
	DbGotop()
Endif

oMark:oBrowse:Refresh(.t.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ExistRefe ³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Refencia                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExistRefe(aListB,oListB,oMark,cArqB1,aStru,cRefe,cSufix,cMarc,oRefe,oQuan,oSufix,cFabri)

If Empty(cRefe)
	
	Aviso('Atencao','A referencia DEVE ser informada',{'Ok'})
	cRefe     := CriaVar("SB1->B1_X_REFER")
	oRefe:Refresh()
	
	//SetFocus(oRefe:hWnd)
	SetFocus(oListB:hWnd)
	
	Return
	
Endif


Processa({|| GeraListB(aListB,oListB,cRefe,cSufix,cMarc,oMark,oRefe,cArqB1,aStru,cFabri),"Aguarde...Buscando Simil"})

GeraMarkB(aListB[1][1],@cArqB1,@aStru,@oMark,cRefe,cSufix,cMarc,oListB)


Return(.t.)



