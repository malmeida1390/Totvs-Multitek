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
±±ºPrograma  ³MPL_016   ºAutor  ³ Anderson           º Data ³  12/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Amarracao EIS   (SOMENTE SQL)                               º±±
±±ºParametros³Originalmente SAO duas telas no Sistema Anterior MultiTek,  º±±
±±º          ³agora na msma tela poderemos escolher efetuar a amarracao  º±±
±±º          ³por REFENCIA ou MOSTRAR TODOS OS EISs EM BRANCO.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºIMPORTANTE³Quando existirem dados no movimento da planilha, cada alte- º±±
±±º**********³racao de EIS deve ALTERAR o EIS antigo na base da planilha. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_016()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Em funcao da utilizacao de Interfaces de varios      ³
//³ programas e aconselhaveu manter todas as variaveis   ³
//³ como Local evitando o uso de Private                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aGetArea  := GetArea()
Local cCadastro := "Amarrar EIS/PMM - Selecao por Referencia/Grupo"
Local lInverte  := .f.
Local cFABRI    := GetMark()
Local cRefe     := CriaVar("SB1->B1_X_REFER")
Local cSufix    := CriaVar("SB1->B1_X_SUFIX")
Local cMarc     := CriaVar("SB1->B1_X_MARCA")
Local cSimil    := CriaVar("SB1->B1_X_SIMIL")
Local oMark , oListB , oRefe,oSufix,oMarc,oDlgProd,oQuan
Local cArqB1    := ""
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aPosGet   := {}
Local aSizeAut	 := MsAdvSize(,.F.)

Private _cArqPro:= ""
Private aStru   := {}
Private aCampos := {}
Private aListB  := {{""}}


Aviso("ATENCAO", "Sr. usuario qualquer alteracao no EIS de um produto que tenha Historico sera necessario o REPROCESSAMENTO ou efetivacao de um novo FECHAMENTO DA PLANILHA. Portanto e importante alinhar todas as novas alteracoes relativas a Eis com a nova data de Fechamento da Planilha.",{"&Ok"})
//
// Caso o usuario avisado sobre o processo venha a continuar a operacao o acesso ao 
// MANUTENCAO DA PLANILHA sera travado ate o novo fechamento.
//
// O parametro abaixo e tratado pelos programas:
//
//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Estrutura do TRB - MarkBrowse ou Browse         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// SOMENTE SE FOR MARKBROWSER
//AADD(aStru  ,{"T_OK","C", 2 , 0})
//AADD(aCampos,{"T_OK",""," "," "})

// CAMPO UTILIZADO PARA INDICAR QUE EIS AINDA PRECISA SER AMARRADO
AADD(aStru  ,{"T_EIS","C", 1 , 0})
AADD(aCampos,{"T_EIS","","X"," "})

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_COD")       // SKU
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
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

DbSeek("B1_ORIGEM")	    // Origem  //B1_X_NC_IM
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


DbSeek("B1_X_SIMIL")	// Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SBSIM")	// Grupo de Similaridade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


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

@ nGetLin-20,aPosGet[1,1]	SAY "AMARRAR EIS/PMM - SELECAO POR REFERENCIA" size 200,8 OF oDlgProd PIXEL
@ nGetLin,aPosGet[1,1]		SAY "Referencia"  size 100,8 OF oDlgProd PIXEL

@ nRefLin,aPosGet[1,2]  MSGET oRefe  VAR cRefe  Picture "@!" /*F3 "Z31"*/ Size 50,8 OF oDlgProd PIXEL  When .T. Valid ExistRefe(@aListB,@oListB,@oMark,cArqB1,@aStru,@M->cRefe,@M->cSufix,@M->cMarc,@oRefe,@oQuan,@oSufix,cFabri)

@ aPosObj[2,1],05 LISTBOX oListB FIELDS;
HEADER "      Simil" ;
SIZE 50,100;
COLSIZES 30 ;
OF oDlgProd PIXEL ;
ON CHANGE (GeraMarkB(aListB[oListB:nAt][X_SIMIL],@cArqB1,@aStru,@oMark,M->cRefe,M->cSufix,M->cMarc,oListB))
oListB:SetArray(aListB)
oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}

oMark := MsSelect():New("TRB",/*"T_OK"*/,,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],060,aPosObj[2,3],aPosObj[2,4]})
//oMark:bMark := { || MfatDisp(cFABRI,lInverte,@oMark) }   // Atualiza outras telas quando dispara o evento click
//oMark:oBrowse:lhasMark = .T.
//oMark:oBrowse:lCanAllmark := .T.
//oMark:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark) } // Permite inverter,
//oMark:oBrowse:nFreeze  := 4  // Utilizado para congelar um determinado numero de colunas no browser

// ACIMA ALGUMAS LINHAS FORAMA BLOQUEADAS, AS QUAIS SERIAM USADAS CASO ESTE BROWSER FOSSE MARKBROWSER
// NO OMARK ONDE CRIA-SE A MSSELECT, CASO NAO PASSEMOS O CAMPO QUE TERA A MARCA (T_OK) ELE SE COMPORTA COMO UM BROWSER SIMPLES

nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 3

@ nGetLin-2,aPosGet[1,7]		BUTTON "Sair"		SIZE 30, 15 OF oDlgProd PIXEL ACTION (oDlgProd:End())
@ nGetLin-2,aPosGet[1,7]-40   	BUTTON "Alterar"	SIZE 30, 15 OF oDlgProd PIXEL ACTION (_FindEIS(cFABRI,aListB),oMark:oBrowse:Refresh(.t.))


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

// CASO FOR MARKBROWSER
// Esta funcao marcaria ou desmarcaria tudo no MarkBrowser, mas como o objetivo
// deste browser eh somente marcar os que foram clicados (alterando ou nao o EIS)
// Esta funcao ficarah aqui so para referencia e caso tambem seja necessaria

/*
Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()
While !Eof()
RecLock("TRB")
IF  T_OK == cFABRI
TRB->T_OK := Space(2)
Else
TRB->T_OK := cFABRI
Endif
MsUnlock()
dbSkip()
Enddo
TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)
*/

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

If !Empty(cRefe)    // Se for digitada a Referencia
	
	
	
	aStruSB1  := SB1->(dbStruct())
	lQuery    := .T.
	cAliasSB1 := "MFATC02SB1"
	
	
	//
	// Define todas as Similaridades Envolvidas
	//
	cQuery := ""
	cQuery := "SELECT B1_X_SIMIL "
	cQuery += "FROM "
	cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_X_REFER ='"+cRefe+"' AND "
	cQuery += "SB1.D_E_L_E_T_<>'*' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	DbSelectArea(cAliasSB1)
	
	
	// A etapa abaixo monta uma String enorme com todo o Simil que pode ser usado
	// na proxima Query
	_concSimil := ""
	While !(cAliasSB1)->(Eof())
		
		If !((cAliasSB1)->B1_X_SIMIL $  _concSimil)
			_concSimil:= _concSimil + "'" + (cAliasSB1)->B1_X_SIMIL + "',"
		Endif
		(cAliasSB1)->(Dbskip())
		
	Enddo
	_concSimil := substr(_concSimil,1,len(_concSimil)-1)
	(cAliasSB1)->(DbcloseArea())
	
	lContinue:= If(alltrim(_concSimil) = "",.f.,.t.)
	
	if 	lContinue
		
		//
		//  Contador de Registros
		//
		cQuery := ""
		cQuery := "SELECT COUNT(*) AS nCount "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1")+"  (NOLOCK)  SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_X_SIMIL IN ("+_concSimil+") AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
		nCount := (cAliasSB1)->nCount
		(cAliasSB1)->(DbcloseArea())
		
		
		//
		// Inicia Processo de Filtro
		//
		cQuery := ""
		cQuery := "SELECT * "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.B1_X_SIMIL IN ("+_concSimil+") AND "
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
			
			//
			// Define Separacao dos Itens por Similaridade
			//
			nPos := Ascan(aListB,{|x| x[1] == (cAliasSB1)->B1_X_SIMIL })
			If  nPos = 0 .and. alltrim(cRefe) <> ""
				AADD(aListB,{ (cAliasSB1)->B1_X_SIMIL } )
			Endif
			
			DbSelectArea("TRB")
			Reclock("TRB",.T.)
			
			TRB->B1_COD      :=  (cAliasSB1)->B1_COD
			TRB->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
			TRB->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
			TRB->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA
			TRB->B1_ORIGEM   :=  (cAliasSB1)->B1_ORIGEM
			TRB->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
			TRB->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
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
			/*
			IF Empty((cAliasSB1)->B1_X_EIS10)
			TRB->T_OK		  :=  cFabri
			EndIf
			*/
			IF Empty((cAliasSB1)->B1_X_EIS10)
				TRB->T_EIS       :=  "X"
			EndIf
			MsUnlock()
			
			
			DbSelectArea(cAliasSB1)
			(cAliasSB1)->(DBSKIP())
			
		Enddo
		
		
		If lQuery
			dbSelectArea(cAliasSB1)
			dbCloseArea()
		EndIf
		
	Endif
	
Else
	
	// Anderson 2a Parte (Pesquisa por EIS)
	// ===================================
	// Em Conversa com o Sr. Milton e Sr. Eduardo os mesmo informaram que NAO HA
	// necessidade de se ter a pesquisa por EIS, basta ter uma alternativa na tela, para
	// que sejam mostrados todos as SKU em branco e seus grupos de similaridade sejam
	// apresentados no browser.
	// Vamos criar um botao expandir para que seja possivel mostrar outras SKUs com a
	// mesma caracteristiva (Similaridade)
	
	//
	// Busca pela unidade de Medida
	//
	
	aStruSB1  := SB1->(dbStruct())
	lQuery    := .T.
	cAliasSB1 := "M016SB1"
	
	cQuery := ""
	cQuery := "SELECT SB1.* "
	cQuery += "FROM "
	cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_X_EIS10  = '  ' AND "
	cQuery += "SB1.D_E_L_E_T_ <> '*'"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	For nX := 1 To Len(aStruSB1)
		If ( aStruSB1[nX][2] <> "C".and. alltrim(aStruSB1[nX][1])$cQuery )
			TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
		EndIf
	Next nX
	
	(cAliasSB1)->(DbGotop())
	
	//ProcRegua(nCount)
	ProcRegua(3)
	
	IncProc() //1
	
	// Abaixo abastecemos um array contendo os SIMILs encontrados para depois poder
	// Varrer o SB1 e procurar por todas as SKUs daqueles SIMILs e abastecer o TRB
	While !(cAliasSB1)->(Eof())
		
		nPos := Ascan(aListB,{|x| x[1] == (cAliasSB1)->B1_X_SIMIL})
		If  nPos = 0
			AADD(aListB,{(cAliasSB1)->B1_X_SIMIL} )
		Endif
		
		DbSelectArea(cAliasSB1)
		(cAliasSB1)->(DBSKIP())
		
	EndDo
	
	IncProc() //2
	
	For _i := 1 to Len(aListB)
		
		
		DbSelectArea("SB1")
   	DbOrderNickname("B1SIMIL")    //22/07/2008_Virada_         //B1_X_SIMIL + EIS
		//DbSetOrder(10)
		DbSeek(xFilial("SB1")+aListB[_i][1])
		
		While !EOF() .and. xFilial("SB1") == SB1->B1_FILIAL .and. aListB[_i][1] == SB1->B1_X_SIMIL
			
			Reclock("TRB",.T.)
			TRB->B1_COD         :=  SB1->B1_COD
			TRB->B1_X_REFER     :=  SB1->B1_X_REFER
			TRB->B1_X_SUFIX     :=  SB1->B1_X_SUFIX
			TRB->B1_X_MARCA     :=  SB1->B1_X_MARCA
			TRB->B1_ORIGEM      :=  SB1->B1_ORIGEM   //B1_X_NC_IM(NAO E ESTE CAMPO SEGUNDO O MAURICIO)
			TRB->B1_X_SIMIL     :=  SB1->B1_X_SIMIL
			TRB->B1_X_SBSIM     :=  SB1->B1_X_SBSIM
			TRB->B1_X_EIS01	  :=  SB1->B1_X_EIS01
			TRB->B1_X_EIS02	  :=  SB1->B1_X_EIS02
			TRB->B1_X_EIS03	  :=  SB1->B1_X_EIS03
			TRB->B1_X_EIS04	  :=  SB1->B1_X_EIS04
			TRB->B1_X_EIS05	  :=  SB1->B1_X_EIS05
			TRB->B1_X_EIS06	  :=  SB1->B1_X_EIS06
			TRB->B1_X_EIS07	  :=  SB1->B1_X_EIS07
			TRB->B1_X_EIS08	  :=  SB1->B1_X_EIS08
			TRB->B1_X_EIS09	  :=  SB1->B1_X_EIS09
			TRB->B1_X_EIS10	  :=  SB1->B1_X_EIS10
			/*
			IF Empty((cAliasSB1)->B1_X_EIS10)
			TRB->T_OK		  :=  cFabri
			EndIf
			*/
			IF Empty(SB1->B1_X_EIS10)
				TRB->T_EIS       :=  "X"
			EndIf
			MsUnlock()
			
			DbSelectArea("SB1")
			DbSkip()
			
		Enddo
		
	Next
	
	If lQuery
		dbSelectArea(cAliasSB1)
		dbCloseArea()
	EndIf
	
Endif

if  len(aListB)=0
	
	
	aListB:={{""}}
	
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
	oListB:nAt   := 1    // Posiciona no Primeiro Item
	oListB:Refresh()
	
	cRefe := CriaVar("SB1->B1_X_REFER")
	oRefe :Refresh()
	SetFocus(oListB:hWnd)
	
	Aviso('Atencao','Nenhum item foi encontrado para a referencia...',{'Ok'})
	
Else
	
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

/*if EmptY(cRefe)
Return(.f.)
Endif
*/

Processa({|| GeraListB(aListB,oListB,cRefe,cSufix,cMarc,oMark,oRefe,cArqB1,aStru,cFabri),"Aguarde...Buscando Simil"})

GeraMarkB(aListB[1][1],@cArqB1,@aStru,@oMark,cRefe,cSufix,cMarc,oListB)


Return(.t.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ _FindEIS ºAutor  ³ Anderson           º Data ³  12/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Monta tela para preencimento do EIS adequado, conforme seu  º±±
±±º          ³cadastro e estrutura.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _FindEIS(cFabri,aListB)

Local nPLin  :=0
Local nPcol  :=0

If Len(aListB) == 1
	If  Empty(aListB[1][1])
		Aviso('Atencao','Falta Amarrar Similaridade a este Item !',{'Ok'})
		Return
	EndIf
EndIf

Private oDlgCons
PRIVATE _lValTela := .T.
PRIVATE  cCadastro1  := "Consulta Cadastro de EIS"
PRIVATE oEisCod1,oEisCod2,oEisCod3,oEisCod4,oEisCod5,oEisCod6,oEisCod7,oEisCod8,oEisCod9,oEisCod0
PRIVATE	oTEisCod1,oTEisCod2,oTEisCod3,oTEisCod4,oTEisCod5,oTEisCod6,oTEisCod7,oTEisCod8,oTEisCod9,oTEisCod0
PRIVATE oTEisDes1,oTEisDes2,oTEisDes3,oTEisDes4,oTEisDes5,oTEisDes6,oTEisDes7,oTEisDes8,oTEisDes9,oTEisDes0

Public cEisCod1 := If(!Empty(TRB->B1_X_EIS01),TRB->B1_X_EIS01,SPACE(2))
Public cEisCod2 := If(!Empty(TRB->B1_X_EIS02),TRB->B1_X_EIS02,SPACE(2))
Public cEisCod3 := If(!Empty(TRB->B1_X_EIS03),TRB->B1_X_EIS03,SPACE(2))
Public cEisCod4 := If(!Empty(TRB->B1_X_EIS04),TRB->B1_X_EIS04,SPACE(2))
Public cEisCod5 := If(!Empty(TRB->B1_X_EIS05),TRB->B1_X_EIS05,SPACE(2))
Public cEisCod6 := If(!Empty(TRB->B1_X_EIS06),TRB->B1_X_EIS06,SPACE(2))
Public cEisCod7 := If(!Empty(TRB->B1_X_EIS07),TRB->B1_X_EIS07,SPACE(2))
Public cEisCod8 := If(!Empty(TRB->B1_X_EIS08),TRB->B1_X_EIS08,SPACE(2))
Public cEisCod9 := If(!Empty(TRB->B1_X_EIS09),TRB->B1_X_EIS09,SPACE(2))
Public cEisCod0 := If(!Empty(TRB->B1_X_EIS10),TRB->B1_X_EIS10,SPACE(2))
Public aTrataEIS:={}


lRet:=ValidEis()


DEFINE MSDIALOG oDlgCons TITLE cCadastro1 FROM 106,65 TO 230+300,750 OF oMainWnd pixel

@ 020,020   SAY "Codigo EIS:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 020,050   MSGET oEisCod1  VAR  cEisCod1     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,064	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("1",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,074   MSGET oEisCod2  VAR  cEisCod2     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,089	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("2",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,100   MSGET oEisCod3  VAR  cEisCod3     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,114	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("3",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,125   MSGET oEisCod4  VAR  cEisCod4     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,139	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("4",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,150   MSGET oEisCod5  VAR  cEisCod5     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,164	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("5",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,175   MSGET oEisCod6  VAR  cEisCod6     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,189	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("6",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,200   MSGET oEisCod7  VAR  cEisCod7     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,214	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("7",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,225   MSGET oEisCod8  VAR  cEisCod8     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,239	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("8",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,250   MSGET oEisCod9  VAR  cEisCod9     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,264	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("9",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())
@ 020,275   MSGET oEisCod0  VAR  cEisCod0     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid  ValidEis() When .T.
@ 019,289	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("10",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),ValidEis())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getDados 10								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPLin:=30
nPcol:=070

//@ 0,0   TO nBotGetd,nRigGetd   PIXEL

@ nPLin+010,nPcol SAY "Familia                   " size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+020,nPcol SAY "Divisao Familia           " size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+030,nPcol SAY "Tipo Familia              " size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+040,nPcol SAY "Divisao Construtiva       " size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+050,nPcol SAY "1 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+060,nPcol SAY "2 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+070,nPcol SAY "3 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+080,nPcol SAY "4 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+090,nPcol SAY "5 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5
@ nPLin+100,nPcol SAY "6 Caracteristica Principal" size 100,8   PIXEL //FONT oFntFecha5

@ nPLin+010,nPcol+73 MSGET oTEisCod1  VAR  aTrataEIS[01,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+020,nPcol+73 MSGET oTEisCod2  VAR  aTrataEIS[02,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+030,nPcol+73 MSGET oTEisCod3  VAR  aTrataEIS[03,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+040,nPcol+73 MSGET oTEisCod4  VAR  aTrataEIS[04,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+050,nPcol+73 MSGET oTEisCod5  VAR  aTrataEIS[05,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+060,nPcol+73 MSGET oTEisCod6  VAR  aTrataEIS[06,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+070,nPcol+73 MSGET oTEisCod7  VAR  aTrataEIS[07,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+080,nPcol+73 MSGET oTEisCod8  VAR  aTrataEIS[08,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+090,nPcol+73 MSGET oTEisCod9  VAR  aTrataEIS[09,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.
@ nPLin+100,nPcol+73 MSGET oTEisCod0  VAR  aTrataEIS[10,1]  Picture "@!"           Size 15,7   PIXEL  When .F. Valid .t.

@ nPLin+010,nPcol+100 MSGET oTEisDes1  VAR  aTrataEIS[01,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+020,nPcol+100 MSGET oTEisDes2  VAR  aTrataEIS[02,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+030,nPcol+100 MSGET oTEisDes3  VAR  aTrataEIS[03,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+040,nPcol+100 MSGET oTEisDes4  VAR  aTrataEIS[04,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+050,nPcol+100 MSGET oTEisDes5  VAR  aTrataEIS[05,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+060,nPcol+100 MSGET oTEisDes6  VAR  aTrataEIS[06,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+070,nPcol+100 MSGET oTEisDes7  VAR  aTrataEIS[07,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+080,nPcol+100 MSGET oTEisDes8  VAR  aTrataEIS[08,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+090,nPcol+100 MSGET oTEisDes9  VAR  aTrataEIS[09,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.
@ nPLin+100,nPcol+100 MSGET oTEisDes0  VAR  aTrataEIS[10,2]  Picture "@!"           Size 110,7   PIXEL  When .F. Valid .t.

@ nPLin+120,230   BUTTON "&Confirmar"	SIZE 40, 15 OF oDlgCons PIXEL ACTION  (_AtualBrw(cFabri,cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0))
@ nPLin+120,270   BUTTON "&Sair"	 	SIZE 40, 15 OF oDlgCons PIXEL ACTION  (oDlgCons:End())

ACTIVATE MSDIALOG oDlgCons CENTERED 


Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³_AtualBrw ³ Autor ³ Anderson              ³ Data ³ 12/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Browse ao clicar no botao SAIR                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _AtualBrw(cFabri,cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0)

Local nConsumo := 0
Local cABC     := ""
Local cPQR	   := ""
Local cNeoil   := ""
Local nTmea    := 0
Local nDesv	   := 0
Local c123     := ""
Local cXYZ     := ""
Local nLtAut   := 0
Local nPTAUT   := 0
Local nEstSe   := 0
Local cEis     := ""
Local cSimil   := ""

Local nGiro    := 0
Local cGiro    := ""
Local cItemCpr := "S"

Local cNI      := ""
Local nLeadTime:= 0
Local nApaAno  := 0

Local lEncontrou := .F.

Local _cSku      := ""
Local _cSimil    := ""
Local _cEis      := ""
Local _lProcBloc := .F.


_lValTela := .T.

If Empty(cEisCod0) // Caso tenha escolhido um EIS por incompleto
	
	Aviso('Atencao','O Eis nao foi digitado por Completo confirmacao nao sera aceita..',{'Ok'})
	
Else
	
	DbSelectArea("TRB")
	RecLock("TRB",.F.)
	//TRB->T_OK        :=  Space(2)
	TRB->B1_X_EIS01	  :=  cEisCod1
	TRB->B1_X_EIS02	  :=  cEisCod2
	TRB->B1_X_EIS03	  :=  cEisCod3
	TRB->B1_X_EIS04	  :=  cEisCod4
	TRB->B1_X_EIS05	  :=  cEisCod5
	TRB->B1_X_EIS06	  :=  cEisCod6
	TRB->B1_X_EIS07	  :=  cEisCod7
	TRB->B1_X_EIS08	  :=  cEisCod8
	TRB->B1_X_EIS09	  :=  cEisCod9
	TRB->B1_X_EIS10	  :=  cEisCod0
	TRB->T_EIS		  :=  Space(1)
	MsUnlock()
	
	
	// Solicitado pelo Mauricio Gravar os dados do Simil e Eis no novo produto.
	cSimil := TRB->B1_X_SIMIL
	cEis   := TRB->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)
	
	DbSelectArea("SB1")
	DbOrderNickname("B1SIMIL")             //B1_X_SIMIL + EIS
	IF  Dbseek(xFilial("SB1") + cSimil + cEis)
		
		lEncontrou := .T.
		
		nConsumo := SB1->B1_X_CONSM
		cABC     := SB1->B1_X_ABC
		cPQR	    := SB1->B1_X_PQR
		cNeoil   := SB1->B1_X_NEOIL
		nTmea    := SB1->B1_X_TMEA
		nDesv	:= SB1->B1_X_DESVP
		c123     := SB1->B1_X_123
		cXYZ     := SB1->B1_X_XYZ
		nLtAut   := SB1->B1_X_LTAUT
		nPTAUT   := SB1->B1_X_PTAUT
		nEstSe   := SB1->B1_X_ESTSE
		
		nGiro    := SB1->B1_X_GIROQ
		cGiro    := SB1->B1_X_LMN
		cItemCpr := "S"
		
		cNI      := SB1->B1_X_NC_IM
		nLeadTime:= SB1->B1_X_LT
		nApaAno  := SB1->B1_X_APN_A
		
	Else
		
		lEncontrou := .F.
		
	Endif
	
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+TRB->B1_COD)

		RecLock("SB1",.F.)
		SB1->B1_X_EIS01 := TRB->B1_X_EIS01
		SB1->B1_X_EIS02 := TRB->B1_X_EIS02
		SB1->B1_X_EIS03 := TRB->B1_X_EIS03
		SB1->B1_X_EIS04 := TRB->B1_X_EIS04
		SB1->B1_X_EIS05 := TRB->B1_X_EIS05
		SB1->B1_X_EIS06 := TRB->B1_X_EIS06
		SB1->B1_X_EIS07 := TRB->B1_X_EIS07
		SB1->B1_X_EIS08 := TRB->B1_X_EIS08
		SB1->B1_X_EIS09 := TRB->B1_X_EIS09
		SB1->B1_X_EIS10 := TRB->B1_X_EIS10
		
		
		SB1->B1_X_CONSM  := nConsumo
		SB1->B1_X_ABC    := cABC
		SB1->B1_X_PQR    := cPQR
		SB1->B1_X_NEOIL  := cNeoil
		SB1->B1_X_TMEA   := nTmea
		SB1->B1_X_DESVP  := nDesv
		SB1->B1_X_123    := c123
		SB1->B1_X_XYZ    := cXYZ
		SB1->B1_X_LTAUT  := nLtAut
		SB1->B1_X_PTAUT  := nPTAUT
		SB1->B1_X_ESTSE  := nEstSe
		
		
		SB1->B1_X_GIROQ  := nGiro
		SB1->B1_X_LMN    := cGiro
		SB1->B1_X_ITCPR  := cItemCpr
		
		SB1->B1_X_NC_IM  := cNI
		SB1->B1_X_LT     := nLeadTime
		SB1->B1_X_APN_A  := nApaAno

    	SB1->B1_X_CUSVA  := (SB1->B1_X_DESVP / SB1->B1_X_CONSM)*100  // Custo de Variacao

		MsUnlock()



      ////
      // A funcao abaixo tem como objetivo ajustar os historicos em funcao da inclusao ou alteracao do Eis.
      // E importante deixar claro ao usuario que apos a efetivacao desta manutencao devera ser efetuada um novo fechamento da 
      // Planilha.
      ////
		MsgRun( OemToAnsi( "Aguarde. Efetuando ajustes nos Historicos por Sku e Simil e Eis..." ),"",{||U_RegravaEIS(.F.)})

	EndIf
	
	If !lEncontrou
		
		U__AtuSkus(nil,nil,nil,"SB1")

	Endif
	
EndIf

oDlgCons:End()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidEis  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Trara Codigo Eis retornando todas as informacoes posiveis   º±±
±±º          ³                                                            º±±
±±ºParametro ³Codigo do Produto                                           º±±
±±º          ³                                                            º±±
±±ºRetorna   ³aTrataEIS[1 a 10,1]  Codigo Eis de 1 a 10                   º±±
±±º          ³aTrataEIS[1 a 10,1]  Caracteristica da Posicao              º±±
±±º          ³aTrataEIS[1 a 10,1]  Codigo Eis Concatenado                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static  Function ValidEis()
Local  aGetArea:= GetArea()
Local  nY     := 0
Local  lRet   :=.T.

Local  cTEisCod1:=cTEisCod2:=cTEisCod3:=cTEisCod4:=cTEisCod5:=cTEisCod6:=cTEisCod7:=cTEisCod8:=cTEisCod9:=cTEisCod10 := "00"
Local  cTEisDes1:=cTEisDes2:=cTEisDes3:=cTEisDes4:=cTEisDes5:=cTEisDes6:=cTEisDes7:=cTEisDes8:=cTEisDes9:=cTEisDes10 := "Classificacao nao Encontra"
Local  cTCodEIS := "0000000000000000000"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rastreando informacoes do EIS        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTeisCod1 := cEisCod1
cTeisCod2 := cEisCod2
cTeisCod3 := cEisCod3
cTeisCod4 := cEisCod4
cTeisCod5 := cEisCod5
cTeisCod6 := cEisCod6
cTeisCod7 := cEisCod7
cTeisCod8 := cEisCod8
cTeisCod9 := cEisCod9
cTeisCod10:= cEisCod0



cTCodEIS:= If(!Empty(cEisCod1),cEisCod1,"")
cTCodEIS+= If(!Empty(cEisCod2),cEisCod2,"")
cTCodEIS+= If(!Empty(cEisCod3),cEisCod3,"")
cTCodEIS+= If(!Empty(cEisCod4),cEisCod4,"")
cTCodEIS+= If(!Empty(cEisCod5),cEisCod5,"")
cTCodEIS+= If(!Empty(cEisCod6),cEisCod6,"")
cTCodEIS+= If(!Empty(cEisCod7),cEisCod7,"")
cTCodEIS+= If(!Empty(cEisCod8),cEisCod8,"")
cTCodEIS+= If(!Empty(cEisCod9),cEisCod9,"")
cTCodEIS+= If(!Empty(cEisCod0),cEisCod0,"")



DbselectArea("Z10")
If  !DbSeek(xFilial("Z10")+cTCodEIS)

     Aviso('Atencao','Rever  digitacao do Eis...',{'Ok'})
	
 	 lRet := .f.
	
Else
	
	DbSelectArea("Z01")
	If Dbseek(xFilial("Z01")+cTeisCod1)
		cTeisDes1 := Z01->Z01_DESC01
	Endif
	
	DbSelectArea("Z02")
	If Dbseek(xFilial("Z02")+cTeisCod1+cTeisCod2)
		cTeisDes2 := Z02->Z02_DESC02
	Endif
	
	DbSelectArea("Z03")
	If Dbseek(xFilial("Z03")+cTeisCod1+cTeisCod2+cTeisCod3)
		cTeisDes3 := Z03->Z03_DESC03
	Endif
	
	DbSelectArea("Z04")
	If Dbseek(xFilial("Z04")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4)
		cTeisDes4 := Z04->Z04_DESC04
	Endif
	
	DbSelectArea("Z05")
	If Dbseek(xFilial("Z05")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5)
		cTeisDes5 := Z05->Z05_DESC05
	Endif
	
	DbSelectArea("Z06")
	If Dbseek(xFilial("Z06")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5+cTeisCod6)
		cTeisDes6 := Z06->Z06_DESC06
	Endif
	
	DbSelectArea("Z07")
	If Dbseek(xFilial("Z07")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5+cTeisCod6+cTeisCod7)
		cTeisDes7 := Z07->Z07_DESC07
	Endif
	
	DbSelectArea("Z08")
	If Dbseek(xFilial("Z08")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5+cTeisCod6+cTeisCod7+cTeisCod8)
		cTeisDes8 := Z08->Z08_DESC08
	Endif
	
	DbSelectArea("Z09")
	If Dbseek(xFilial("Z09")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5+cTeisCod6+cTeisCod7+cTeisCod8+cTeisCod9)
		cTeisDes9 := Z09->Z09_DESC09
	Endif
	
	DbSelectArea("Z10")
	If Dbseek(xFilial("Z10")+cTeisCod1+cTeisCod2+cTeisCod3+cTeisCod4+cTeisCod5+cTeisCod6+cTeisCod7+cTeisCod8+cTeisCod9+cTeisCod10)
		cTeisDes10 := Z10->Z10_DESC10
	Endif
	
Endif

aTrataEIS:= {}

AADD(aTrataEIS,{cTeisCod1,cTeisDes1,cTCodEis})
AADD(aTrataEIS,{cTeisCod2,cTeisDes2,cTCodEis})
AADD(aTrataEIS,{cTeisCod3,cTeisDes3,cTCodEis})
AADD(aTrataEIS,{cTeisCod4,cTeisDes4,cTCodEis})
AADD(aTrataEIS,{cTeisCod5,cTeisDes5,cTCodEis})
AADD(aTrataEIS,{cTeisCod6,cTeisDes6,cTCodEis})
AADD(aTrataEIS,{cTeisCod7,cTeisDes7,cTCodEis})
AADD(aTrataEIS,{cTeisCod8,cTeisDes8,cTCodEis})
AADD(aTrataEIS,{cTeisCod9,cTeisDes9,cTCodEis})
AADD(aTrataEIS,{cTeisCod10,cTeisDes10,cTCodEis})

If oTEisCod1 # NIL
	oTEisCod1:Refresh()
	oTEisCod2:Refresh()
	oTEisCod3:Refresh()
	oTEisCod4:Refresh()
	oTEisCod5:Refresh()
	oTEisCod6:Refresh()
	oTEisCod7:Refresh()
	oTEisCod8:Refresh()
	oTEisCod9:Refresh()
	oTEisCod0:Refresh()
	
	oTEisDes1:Refresh()
	oTEisDes2:Refresh()
	oTEisDes3:Refresh()
	oTEisDes4:Refresh()
	oTEisDes5:Refresh()
	oTEisDes6:Refresh()
	oTEisDes7:Refresh()
	oTEisDes8:Refresh()
	oTEisDes9:Refresh()
	oTEisDes0:Refresh()
Endif

RestArea(aGetArea)

Return(lRet)





