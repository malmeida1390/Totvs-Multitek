#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1


//PrVenda


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC02   ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Produtos                                        º±±
±±ºParametros³Nao foi necessario passar parametros pois todas informacoes º±±
±±º          ³sao geradas apartir da referencia.                          º±±
±±º          ³                                                            º±±
±±º          ³Durante a gravacao verifico se gero Acols ou se uso Tmp1    º±±
±±º          ³Estou analizando a origem da informacao via Acols ou Tmp1   º±±
±±º          ³para poder tratar para isto estou utilizando a funcao       º±±
±±º          ³funname devido esta funcao estar sendo utilizada pelo orca- º±±
±±º          ³mento e pelo Contrato.                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Em funcao da utilizacao de Interfaces de varios      ³
//³ programas e aconselhaveu manter todas as variaveis   ³
//³ como Local evitando o uso de Privante                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aGetArea  := GetArea()
//Local nOpca     := 0
Local cCadastro := "Consulta de Produtos"
Local aRotBack  := aClone( aRotina )
Local nY        := 0
Local aBackRot  := aClone( aRotina )
Local aStru     := {}
Local aCampos   := {}
Local cRefe     := CriaVar("B1_X_REFER")
Local cSufix    := CriaVar("B1_X_SUFIX")
Local cMarc     := CriaVar("B1_X_MARCA")
Local cSimil    := CriaVar("B1_X_SIMIL")
Local nQuan     := 0
Local bSetKey4
Local bSetKey12
Local bSetKey8

Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5
Local cPRODUTO  := ""
Local ii        := 0
Local nQTDVEN   := 0
Local nQTDFIM   := 0
Local nPRODUTO  := 0
Local nREFE     := 0

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Local _nGetRent  := 0
Local _nGetRenVr := 0
Local _cStatus   := "L"
Local _nElem     := 0

Local aHeadAux	  := aClone(aHeader)
Local aColsAux	  := IIf("MATA415" $ Upper(Funname()) ,  {}              ,aClone(aCols))
Local nNAux       := Iif("MATA415" $ Upper(Funname()) ,  TMP1->(RECNO()) ,n)
Local oListB , oRefe,oSufix,oMarc,oDlgProd,oQuan


Private lInverte  := .f.
Private cFABRI     := GetMark()
Private oMark2
Private lF8        := .T.
Private _cArqPRO   := ""
Private _cArqB1     := ""
Private aListB     := {{""}}
Private BX_X_REFER := CriaVar("SB1->B1_X_REFER")
Private BX_X_SUFIX := CriaVar("SB1->B1_X_SUFIX")
Private BX_X_MARCA := CriaVar("SB1->B1_X_MARCA")

Private oBX_X_REFER , oBX_X_SUFIX , oBX_X_MARCA
Private lSemafaro := .T.  // Controla o semafaro para ativacao da tecla enviar somente e possivel quando tela esta construida devido
// na versao Protheus10 ter apresentado erro.

Private cProcName := FunName()
Private _cIndComer:= IIF("MATA415" $ Upper(Funname()) ,M->CJ_X_ST_CI,IIF( UPPER(CJ_X_ST_CI) $ "INDUSTRIA","I",IIF( UPPER(CJ_X_ST_CI) $ "CONSUMO","C",IIF( UPPER(CJ_X_ST_CI) $ "REVENDA","R","" ))))
Private _cGetCond := IIF("MATA415" $ Upper(Funname()) ,M->CJ_CONDPAG,M->CCONDPAG)
Private _cCliente := IIF("MATA415" $ Upper(Funname()) ,M->CJ_CLIENTE, cCliente   )
Private _cLoja    := IIF("MATA415" $ Upper(Funname()) ,M->CJ_LOJA   , cLoja      )
Private _nFrete   := IIF("MATA415" $ Upper(Funname()) ,M->CJ_X_FRETE,M->nFrete  )

Private _cClient  := IIF("MATA415" $ Upper(Funname()) ,M->CJ_CLIENT  , cCliente   )
Private _cLojaEnt := IIF("MATA415" $ Upper(Funname()) ,M->CJ_LOJAENT , cLoja      )



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o item no Cadastro de Clientes                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
DbSetorder(1)
Dbseek(xFilial("SA1")+_cCliente+_cLoja)


If "MATA415" $ Upper(Funname())
	If Empty(M->CJ_X_VEND1)  //.and. substr(GetMv("MV_COMICAL"),1,1) <> "T"
		Aviso("ATENCAO", "Favor informar o Vendedor Interno.",{"&Ok"})
		Return
	Endif
	If Empty(M->CJ_X_TPVEN)  //.and. substr(GetMv("MV_COMICAL"),1,1) <> "T"
		Aviso("ATENCAO", "Favor informar o tipo de Venda.",{"&Ok"})
		Return
	Endif
Else
	If Empty(M->cVend1)  //.and. substr(GetMv("MV_COMICAL"),1,1) <> "T"
		Aviso("ATENCAO", "Favor informar o Vendedor Interno.",{"&Ok"})
		Return
	Endif
	If Empty(M->cCondpag)  //.and. substr(GetMv("MV_COMICAL"),1,1) <> "T"
		Aviso("ATENCAO", "Favor informar a Condicao de Pagamento.",{"&Ok"})
		Return
	Endif
Endif

If Empty(_cIndComer)  //.and. substr(GetMv("MV_COMICAL"),1,1) <> "T"
	Aviso("ATENCAO", "Favor informar o tipo de venda Industria, Consumo ou Revenda...",{"&Ok"})
	Return
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Arrays auxiliares para armazenar a getdados principal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aBackRot := aClone(aRotina)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A rotina abaixo apenas verifica na pilha de chamda se estamos          ³
//³ utilizando o "MFATC05" pois neste rotina devolvemos apenas             ³
//³ um codigo do produto.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Empty(cProcName)
	If cProcName $ "U_MFATC05"   // Geracao Pedido atraves do Contrato
		nQTDVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"})
		nPRODUTO  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
		nREFE     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_REFER"})
		
		If Empty(aCols[n][nPRODUTO])
			Aviso('Atencao','Esta rotina permite substituir item do contrato'+chr(13)+chr(13)+;
			'Mas somente e ativada mediante a escolha de um item de contrato',{'Ok'})
			Return
		Endif
		nQuan     := aCols[n][nQTDVEN]
		cRefe     := aCols[n][nREFE]
		Exit
	Endif
	ii++
	cProcName := UPPER(AllTrim(ProcName(ii)))
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Estrutura do Trb - Mark Browse                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru  ,{"T_OK","C", 2 , 0} )
AADD(aCampos,{"T_OK",""," "," "})

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_REFER")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SUFIX")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_MARCA")         // "Marca - Origem - Prod."
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO+10,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Marca - Origem - Producao"/*X3_TITULO*/,X3_PICTURE})

//DbSeek("B1_ORIGEM")         // ORIGEM
//AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("CK_PRCVEN")          // Preco Simulado
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Preco Sugerido",X3_PICTURE})


DbSeek("CK_X_MARGE")          //  % Rentabilidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})              // Nao Mostrar no Browse

DbSeek("CK_X_MARGV")          // $  Rentabilidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})              // Nao Mostrar no Browse

DbSeek("CK_X_MARGA")          // Avaliacao da Margem
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})              // Nao Mostrar no Browse

AADD(aStru  ,{"T_SMALHA","N" , 14 , 0} )
AADD(aCampos,{"T_SMALHA","","Sld da Malha","@E 999,999,999"})

AADD(aStru  ,{"T_SDISPO","N" , 14 , 0} )
AADD(aCampos,{"T_SDISPO","","Malha(Disp)","@E 999,999,999"})

AADD(aStru  ,{"T_SMATRIZ","N" , 14 , 0} )
AADD(aCampos,{"T_SMATRIZ","","Estoque+Deposito","@E 999,999,999"})
//AADD(aCampos,{"T_SMATRIZ","","Matriz(Disp)","@E 999,999,999"}) //alteracao Nasser 09/02/07

AADD(aStru  ,{"T_SFILIAL","N" , 14 , 0} )
AADD(aCampos,{"T_SFILIAL","","Filiais(Disp)","@E 999,999,999"})

AADD(aStru  ,{"T_SCONSIG","N" , 14 , 0} )
AADD(aCampos,{"T_SCONSIG","","Consignados","@E 999,999,999"})

AADD(aStru  ,{"T_STRANSI","N" , 14 , 0} )
AADD(aCampos,{"T_STRANSI","","Transito","@E 999,999,999"})

AADD(aStru  ,{"T_RESERVA","N" , 14 , 0} )
AADD(aCampos,{"T_RESERVA","","Reserva","@E 999,999,999"})

AADD(aStru  ,{"T_SEMPENH","N" , 14 , 0} )
AADD(aCampos,{"T_SEMPENH","","Empenho","@E 999,999,999"})

AADD(aStru  ,{"T_FATURAR","N" , 14 , 0} )
AADD(aCampos,{"T_FATURAR","","A Faturar","@E 999,999,999"})

AADD(aStru  ,{"T_CLASSIF","N" , 14 , 0} )
AADD(aCampos,{"T_CLASSIF","","A Classificar","@E 999,999,999"})


DbSeek("B1_UM")              // UNIDADE
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_ABC")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_GIROQ")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_LMN")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_PQR")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_NEOIL")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_XYZ")     // Criticidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_123")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_NC_IM")         // Origem
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_TMEA")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_COD")       // SKU
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Cod.SKU MTK",X3_PICTURE})

DbSeek("B1_X_SIMIL")     // B1_SIMIL
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SBSIM")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


AADD(aStru  ,{"T_EIS","C",20,0} )
AADD(aCampos,{"T_EIS","","EIS","@!"})

AADD(aStru  ,{"T_FINALIZ","C" ,1, 0} )  // Este campo e apenas para corrigir
AADD(aCampos,{"T_FINALIZ","","",""})    // o ultimo item do acols para nao ficar com um
// espaco enorme.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Trb Vazio                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqB1   := CriaTrab(aStru,.T.)
_cArqPRO := CriaTrab(,.F.)
DbUseArea(.T.,, _cArqB1, "TRBC02", .F., .F.)
IndRegua("TRBC02",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
dbGotop()



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 7,16
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD


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
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{020,50,105,135,180,200,255,290}} )
nGetLin := aPosObj[3,1]


DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel
//DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM 106,65 TO 552,835  OF oMainWnd pixel
bSetKey4  := SetKey(VK_F4  ,{|| U_consprodu(oMark2,TRBC02->B1_COD,cFABRI,lInverte)})
bSetKey12 := SetKey(VK_F12 ,nil)
bSetKey8  := SetKey(VK_F8  ,{|| lF8:=IF(lF8,.F.,.T.),GeraMarkB(aListB[oListB:nAt][X_SIMIL],@aStru,@oMark2,M->cRefe,M->cSufix,M->cMarc,oListB)})

//@ 015,005   TO 040,380 OF oDlgProd PIXEL
@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlgProd PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlgProd PIXEL


nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1]
nGetLin := nGetLin - 3
@ nGetLin,aPosGet[1,1]   SAY "Referencia" size 100,8 OF oDlgProd PIXEL //FONT oFntFecha5
@ nGetLin,aPosGet[1,3]   SAY "Quantidade" size 100,8 OF oDlgProd PIXEL //FONT oFntFecha5

@  nGetLin,aPosGet[1,2]    MSGET oRefe  VAR cRefe  Picture "@!" F3 "Z31"   Size 50,8 OF oDlgProd PIXEL  When .T. Valid .T.
@  nGetLin,aPosGet[1,4]    MSGET oQuan  VAR nQuan  Picture "@E  9999.99"  Size 20,8 OF oDlgProd PIXEL  When .T. Valid ExistRefe(@aListB,@oListB,@oMark2,@aStru,@M->cRefe,@M->cSufix,@M->cMarc,@oRefe,@oQuan,@oSufix)


@ aPosObj[2,1],05 LISTBOX oListB FIELDS ;
HEADER "      Simil" ;
SIZE 50,100;   //aPosObj[2,3]+55,aPosObj[2,4] ;  //50, 100 ;
COLSIZES 30 ;
OF oDlgProd PIXEL ;
ON CHANGE (GeraMarkB(aListB[oListB:nAt][X_SIMIL],@aStru,@oMark2,M->cRefe,M->cSufix,M->cMarc,oListB))
//ON DBLCLICK (GeraMarkB(aListB[oListB:nAt][X_SIMIL]))
oListB:SetArray(aListB)
oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}


oMark2:= MsSelect():New("TRBC02","T_OK","",aCampos,@lInverte,@cFABRI,{aPosObj[2,1],060,aPosObj[2,3],aPosObj[2,4]},,,,,)
oMark2:bMark := {| | MfatDisp(cFABRI,lInverte,@oMark2)}   // Atualiza outras telas quando dispara o
oMark2:oBrowse:lhasMark := .t.                             // evento click
oMark2:oBrowse:lCanAllmark := .t.
oMark2:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark2) } // Permite FABRIr um, inverter,
//oMark2:oBrowse:nFreeze  := 5  // congelando estas colunas ocorre um "flicker" na tela
//oMark2:oBrowse:nColPos := 1


nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 3
@ nGetLin,100   SAY  "< F4 > Consulta Estoque da Malha Logistica "+;
"    < F8 > Desabilita Filtro do Estoque"  of oDlgProd PIXEL  FONT oFntFecha5


@ nGetLin-2,aPosGet[1,7]    BUTTON "Enviar"    SIZE 50, 15 OF oDlgProd PIXEL ACTION  ( VldGrava(@cFABRI,@oMarc,@cRefe,@oRefe,@cSufix,@oSufix,@nQuan,@oQuan,@oDlgProd,@oListB,@aListB,aStru,oMark2,cMarc))


ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,;
{|| VldGrava(@cFABRI,@oMarc,@cRefe,@oRefe,@cSufix,@oSufix,@nQuan,@oQuan,@oDlgProd,@oListB,@aListB,aStru,oMark2,cMarc)},;
{|| oDlgProd:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F12,bSetKey12)
SetKey(VK_F8 ,bSetKey8)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura aRotina Original                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina:=aClone(aBackRot)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRBC02")
dbCloseArea()
If File(_cArqB1+".DTC")
	Ferase(_cArqB1+".DTC")
Endif

If File(_cArqPro+OrdBagExt())
	FErase(_cArqPro+OrdBagExt())
Endif
//FimEstrut2("TRBC02",_cArqB1) // Finaliza o uso do Temporario funcao dentro do sigacusb

If Select("TRBC02") <> 0
  TRBC02->(DbcloseArea())
Endif

RestArea(aGetArea)

If "MATA415" $ Upper(Funname())
	aHeader := aClone(aHeadAux)
	TMP1->(DbGoto(nNAux))
	oGetDad:oBrowse:GoTop() //(ao invés de: oGetDad:oBrowse:Refresh())
	ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento ou Contrato
Else
	oGetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento ou Contrato
Endif

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

aadd(aButtons,{"S4WB011N",{||U_consprodu(oMark2,TRBC02->B1_COD,cFABRI,lInverte)}, "<F4> - Consulta Estoque da Malha Logistica" })

Return (EnchoiceBar(oDlgProd,bOK,bcancel,,aButtons))



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatDisp  ³ Autor ³                       ³ Data ³ 07/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³MfatDisp													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MfatDisp(cFABRI,lInverte,oMark2)
Local nDecs


If IsMark("T_OK",cFABRI,lInverte)
	//nDecs := MsDecimais(E1_MOEDA)
	//If Subs(E1_TIPO,3,1) == "-"
	//	nValTit   -= Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
	//    aTotais[E1_MOEDA][1] -= Round(E1_VALOR,nDecs)
	//Else
	//	nValTit  += Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
	//    aTotais[E1_MOEDA][1] += Round(E1_VALOR,nDecs)
	//	EndIf
	//	nQuant++
Else
	//nDecs := MsDecimais(E1_MOEDA)
	//If Substr(E1_TIPO,3,1) == "-"
	//	nValTit  += Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
	//    aTotais[E1_MOEDA][1] += Round(E1_VALOR,nDecs)
	//Else
	//	nValTit  -= Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
	//    aTotais[E1_MOEDA][1] -= Round(E1_VALOR,nDecs)
	//EndIf
	//nQuant--
	//nQuant:= Iif(nQuant<0,0,nQuant)
Endif
//oValTit:Refresh()
//oQuant:Refresh()
//oQual:Refresh()


//oBX_X_REFER:Refresh()
//oBX_X_SUFIX:Refresh()
//oBX_X_MARCA:Refresh()

//oMark2:oBrowse:Refresh(.t.)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatInvS  ³ Autor ³                       ³ Data ³ 07/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte FABRIoes 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MfatInvS     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MfatInvS(cFABRI,oMark2)

Local nReg := TRBC02->(Recno())
dbSelectArea("TRBC02")
dbGoTop()
While !Eof()
	RecLock("TRBC02",.F.)
	IF  T_OK == cFABRI
		TRBC02->T_OK := "  "
	Else
		TRBC02->T_OK := cFABRI
	Endif
	MsUnlock()
	dbSkip()
Enddo
TRBC02->(dbGoto(nReg))

oMark2:oBrowse:Refresh(.t.)

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraListB³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monsta a Lista de Itens das Ultimas Compras com base no TMP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraListB(aListB,oListB,cRefe,cSufix,cMarc,oMark2,oRefe,aStru,oQuan)

Local cChave   := ""
Local aTrataEis := {}
Local aPrVenda  := {}
Local nCount    := 0
Local aSaldoEst := {}
Local lBucaUnid := .F.
Local _concSimil:= ""
Local lQuery    := .F.
Local lContinua := .T.
Local cAliasSB1 := "SB1"
Local aStruSB1  := {}

Local   _Recno    := 0
Local   aElem     := {}
Local   _uString   := _cParAlmox:= GETMV("MV_ALMCONS")

Local   nPos      := 0
Local  lContinue  := .T.

Local  _uString   := ""
Local  aProdTmp   := {}


aListB     := {}


If !Empty(cRefe)    // Se for digitada a Referencia
	
	
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
	
	
	#IFDEF TOP
		
		aStruSB1  := SB1->(dbStruct())
		lQuery    := .T.
		cAliasSB1 := "MFATC02SB1"
		
		
		//
		// Define todas as Similaridades Envolvidas
		//
		cQuery := ""
		cQuery := "SELECT B1_X_SIMIL "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1")+" SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		if lBucaUnid
			cQuery += "SB1.B1_X_MEDID ='"+SZ3->Z3_CODIGO +"' AND "
		Else
			cQuery += "SB1.B1_X_REFER ='"+cRefe+"' AND "
		Endif
		cQuery += "SB1.D_E_L_E_T_<>'*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

		DbSelectArea(cAliasSB1)
		
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
		
		
		If	lContinue
			
			//
			//  Contador de Registros
			//
			cQuery := ""
			cQuery := "SELECT COUNT(*) AS nCount "
			cQuery += "FROM "
			cQuery += RetSqlName("SB1")+" SB1 "
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
			cQuery := "SELECT B1_X_SIMIL,B1_COD,B1_X_REFER,B1_X_SUFIX,B1_X_MARCA,B1_ORIGEM, B1_X_PRODU, B1_UM,"
			cQuery += " B1_X_NC_IM,B1_X_ABC,B1_X_GIROQ,B1_X_LMN,B1_X_PQR,B1_X_NEOIL,B1_X_XYZ,B1_X_123,B1_X_ABC,B1_X_TMEA,B1_COD,"
			cQuery += " B1_X_SIMIL,B1_X_SBSIM "
			cQuery += "FROM "
			cQuery += RetSqlName("SB1")+" SB1 "
			cQuery += "WHERE "
			cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
			cQuery += "SB1.B1_X_SIMIL IN ("+_concSimil+") AND "
			cQuery += "SB1.D_E_L_E_T_=' ' "
 			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
			For nX := 1 To Len(aStruSB1)
				If ( aStruSB1[nX][2] <> "C" .and. alltrim(aStruSB1[nX][1])$cQuery )
					TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
				EndIf
			Next nX
			
			(cAliasSB1)->(DbGotop())
			
		Endif
		
	#ELSE
		
		If lBucaUnid
			
			DbSelectArea("SB1")
			DbGoTop()
			DbOrderNickname("B1UNMED")             //B1_X_REFER + B1_X_MEDID (NOVO INDICE
			
			nCount := 0
			If  Dbseek(xFilial("SB1") + SZ3->Z3_CODIGO )
				While !SB1->(Eof())  .and. SZ3->Z3_CODIGO = &cChave
					nCount++
					SB1->(DBSKIP())
				Enddo
			Endif
			
			Dbseek(xFilial("SB1") + SZ3->Z3_CODIGO  )
			
		Else
			
			DbSelectArea("SB1")
			DbGoTop()
			DbOrderNickname("B1REFER")             //B1_X_REFER + B1_X_SIMIL
			
			nCount := 0
			If  Dbseek(xFilial("SB1") + cRefe )
				While !SB1->(Eof())  .and. cRefe = &cChave
					nCount++
					SB1->(DBSKIP())
				Enddo
			Endif
			
			Dbseek(xFilial("SB1") + cRefe ) // Define todos os Similares
			
		Endif
		
	#ENDIF
	
	
	
	if lContinue
		
		DbSelectArea(cAliasSB1)
		
		ProcRegua(nCount)
		
		While !(cAliasSB1)->(Eof())
			
			If  !lQuery
				if  cRefe <> &cChave
					Exit
				Endif
			Endif
			
			IncProc()
			
			
			//
			// Define Separacao dos Itens por Similaridade
			//
			nPos := Ascan(aListB,{|x| x[1] == (cAliasSB1)->B1_X_SIMIL })
			If  nPos = 0 .and. alltrim(cRefe) <> ""
				AADD(aListB,{  (cAliasSB1)->B1_X_SIMIL } )
			Endif
			
			//
			// Define Codigo Eis
			//
			aTrataEis := U_TrataEIS((cAliasSB1)->B1_COD)       // (Mfatc03)
			
			//
			// Define Condicao de Pagamento a ser Utilizada
			//
			//_cGetCond:= IIF( "MATA415" $ Upper(Funname()) ,M->CJ_CONDPAG,M->CCONDPAG)
			
			//
			// Define Preco de Venda
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
			//³ Parametros                                                             ³
			//³ 1. < cGetCond > - Condicoes de Pagamento                               ³
			//³ 2 <._cProd    > - Produto Desejado                                     ³
			//³ 3.< NIL       > - I(Industria)/C(Comercio)                             ³
			//³                   Caso Nil a propria rotina define                     ³
			//³                   atraves da Origem.                                   ³
			//³  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  ³
			//³                   .F. Outras origens.                                  ³
			//³                   Motivo controle do custo que vem do acols.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aPrVenda  := U_PrVenda(_cGetCond,(cAliasSB1)->B1_COD,_cIndComer,.F.,_nFrete)
			
			//
			// Define Saldos em estoque
			//
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
			//³[05]     DEPOSITO FECHADO                                                                       ³
			//³[05][01] SaldoSb2()                       // DISPONIVEL                                         ³
			//³[05][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
			//³[05][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
			//³[05][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
			//³[05][05] B2_RESERVA                       // RESERVADO                                          ³
			//³[05][06] B2_QEMP                          // EMPENHADO                                          ³
			//³[05][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
			//³[05][08] B2_QPEDVEN                       // A FATURAR                                          ³
			//³[05][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
			//³[05][10] SB2->B2_QATU                     // FISICO                                             ³
			//³[05][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
			//³[05][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
			//³                                                                                                |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			aSaldoEst := U_SaldoSb2((cAliasSB1)->B1_COD)  // MFATC12.PRW
			
			
			// A  Multitek criou um cara chamado Desconto Slow logo nao posso aplicar isto a formula inicial
			// caso contrario a cada chamada seria efetuado desconto sobre desconto, desta forma optei em deixar
			// somente
			
			// Preco de Venda com desconto Slow.
			// aPrVenda[02,03]  := aPrVenda[02,03] - (aPrVenda[02,03]*(SB1->B1_X_CSLOW/100))
			
			DbSelectArea("TRBC02")  // Alterado - Almeida 21/05/2014
			Reclock("TRBC02",.T.)
			
			TRBC02->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
			TRBC02->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
			TRBC02->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA+" - "+(cAliasSB1)->B1_ORIGEM+" - "+IF((cAliasSB1)->B1_X_PRODU="1",SPACE(3),"MTK")
			//TRBC02->B1_ORIGEM   :=  (cAliasSB1)->B1_ORIGEM
			TRBC02->B1_UM       :=  (cAliasSB1)->B1_UM
			TRBC02->CK_PRCVEN   :=  aPrVenda[02,03]    // Preco de Venda
			TRBC02->CK_X_MARGE  :=  aPrVenda[06,03]    //  % Rentabilidade
			TRBC02->CK_X_MARGV  :=  aPrVenda[03,03]    //  $  Rentabilidade
			TRBC02->CK_X_MARGA  :=  aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
			TRBC02->B1_X_NC_IM  :=  (cAliasSB1)->B1_X_NC_IM
			
			TRBC02->T_SMALHA    :=  aSaldoEst[01][11]+aSaldoEst[04][11] // FISICO + TRANSITO         (Saldo Malha)
			TRBC02->T_SDISPO    :=  aSaldoEst[01][12]+aSaldoEst[04][12] // FISICO - R - E - FATURAR  (Saldo Malha Disp)
			//TRBC02->T_SMATRIZ :=   aSaldoEst[02][12] //alterado Nasser 09/02/07
			//TRBC02->T_SFILIAL :=   aSaldoEst[03][12] //alterado Nasser 09/02/07
			TRBC02->T_SMATRIZ   :=  aSaldoEst[02][12]+aSaldoEst[05][12] // Disponivel (Filiais+Deposito)
			TRBC02->T_SFILIAL   :=  aSaldoEst[03][12]-aSaldoEst[05][12] // Filiais - Deposito Fechado
			TRBC02->T_SCONSIG   :=  aSaldoEst[04][12]    // CONSIGNADO (SALDO MALHA)
			TRBC02->T_RESERVA   :=  aSaldoEst[01][05]    // RESERVA
			TRBC02->T_STRANSI   :=  aSaldoEst[01][07]    // TRANSITO
			TRBC02->T_SEMPENH   :=  aSaldoEst[01][06]    // EMPENHO
			TRBC02->T_FATURAR   :=  aSaldoEst[01][08]    // A FATURAR
			TRBC02->T_CLASSIF   :=  aSaldoEst[01][09]    // A CLASSIFICAR
			
			TRBC02->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			TRBC02->B1_X_GIROQ  :=  (cAliasSB1)->B1_X_GIROQ
			TRBC02->B1_X_LMN    :=  (cAliasSB1)->B1_X_LMN
			TRBC02->B1_X_PQR    :=  (cAliasSB1)->B1_X_PQR
			TRBC02->B1_X_NEOIL  :=  (cAliasSB1)->B1_X_NEOIL
			TRBC02->B1_X_XYZ    :=  (cAliasSB1)->B1_X_XYZ
			TRBC02->B1_X_123    :=  (cAliasSB1)->B1_X_123
			TRBC02->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			//TRBC02->T_SAPANHE   :=  0                    // ???
			TRBC02->B1_X_TMEA   :=  (cAliasSB1)->B1_X_TMEA
			TRBC02->B1_COD      :=  (cAliasSB1)->B1_COD
			TRBC02->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
			TRBC02->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
			TRBC02->T_EIS       :=  aTrataEis[1,3]
			
			MsUnlock()
			
			
			DbSelectArea(cAliasSB1)
			(cAliasSB1)->(DBSKIP())
			
		Enddo
		
		DbSelectArea("TRBC02")
		DbGoTop()
		
		If lQuery
			dbSelectArea(cAliasSB1)
			dbCloseArea()
		EndIf
		
	Endif
	
Endif



if  len(aListB)=0
	
	Aviso('Atencao','Nenhum item foi encontrado para a Referencia.'+chr(13)+chr(13)+;
	'Esta sendo informado como sugestao o produto Generico.',{'Ok'})
	
	lF8        := .F. // Desabilita o Filtro.
	
	//
	// Separa as contas de Email para Envio Personalizado
	//
	_uString := GeTMv("MV_PRODTMP")
	While Len(_uString) > 0
		AADD(aProdTmp,ParseSep(@_uString))
	End
	
	
	
	For nY:= 1 to len(aProdTmp)
		
		DbSelectArea("SB1")
		DbGoTop()
		DbSetOrder(1)
		If  Dbseek(xFilial("SB1") + aProdTmp[nY] )
			
			
			cAliasSB1 := "SB1"
			//
			// Define Codigo Eis
			//
			aTrataEis := U_TrataEIS((cAliasSB1)->B1_COD)       // (Mfatc03)
			
			
			
			aPrVenda  := U_PrVenda(_cGetCond,(cAliasSB1)->B1_COD,_cIndComer,.F.,_nFrete)
			
			
			//
			// Define Separacao dos Itens por Similaridade
			//
			nPos := Ascan(aListB,{|x| x[1] == (cAliasSB1)->B1_X_SIMIL })
			If  nPos = 0 .and. alltrim(cRefe) <> ""
				AADD(aListB,{  (cAliasSB1)->B1_X_SIMIL } )
			Endif
			
			
			DbSelectArea("TRBC02")  // Alterado - Almeida 21/05/2014
			Reclock("TRBC02",.T.)
			
			TRBC02->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
			TRBC02->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
			TRBC02->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA+" - "+(cAliasSB1)->B1_ORIGEM+" - "+IF((cAliasSB1)->B1_X_PRODU="1",SPACE(3),"MTK")
			//TRBC02->B1_ORIGEM   :=  (cAliasSB1)->B1_ORIGEM
			TRBC02->B1_UM       :=  (cAliasSB1)->B1_UM
			TRBC02->CK_PRCVEN   :=  aPrVenda[02,03]    //  Preco de Venda
			TRBC02->CK_X_MARGE  :=  aPrVenda[06,03]    //  % Rentabilidade
			TRBC02->CK_X_MARGV  :=  aPrVenda[03,03]    //  $  Rentabilidade
			TRBC02->CK_X_MARGA  :=  aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
			TRBC02->B1_X_NC_IM  :=  (cAliasSB1)->B1_X_NC_IM
			
			
			TRBC02->T_SMALHA    :=  0
			
			//aSaldoEst[1][11]+; // Malha     = Fisico           (Malha) +
			//aSaldoEst[4][11]+; //              Fisico           (Consignado) +
			//aSaldoEst[1][7]+;  //              Transito         (Malha) +
			//aSaldoEst[4][7]    //               Transito         (Consignado)
			//aSaldoEst[1][9]+;  //              Classificar      (Malha) +
			//aSaldoEst[4][9]+;  //              Classificar      (Consignado) +
			
			TRBC02->T_SDISPO    :=  0 //aSaldoEst[1][1]   // Malha      = Saldo Disponivel  (Malha)
			TRBC02->T_SMATRIZ   :=  0 //aSaldoEst[2][1]   // Matriz     = Saldo Disponivel  (Matriz)
			TRBC02->T_SFILIAL   :=  0 //aSaldoEst[3][1]   // Filial     = Saldo Disponivel  (Filial)
			TRBC02->T_SCONSIG   :=  0 //aSaldoEst[4][1]   // Consignado = Saldo Disponivel  (Consignado)
			TRBC02->T_RESERVA   :=  0 //aSaldoEst[1][5]   // Reserva    = Saldo Reserva     (Malha)
			TRBC02->T_STRANSI   :=  0 //aSaldoEst[1][7]   // Malha      = B2_SALPEDI Previsto para Entrar - ( a Classificar na Malha +
			//  ( aSaldoEst[1][9] + aSaldoEst[4][9])//              a Classificar no Consignado)
			TRBC02->T_SEMPENH   :=  0 //aSaldoEst[1][6]   // Malha      = B2_QEMP Quantidade Empenhada
			TRBC02->T_FATURAR   :=  0                     // Malha      = A FATURAR
			TRBC02->T_CLASSIF   :=  0 //aSaldoEst[1][9]   // Malha      = B2_CLASS Quantidade a Classificar
			
			TRBC02->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			TRBC02->B1_X_GIROQ  :=  (cAliasSB1)->B1_X_GIROQ
			TRBC02->B1_X_LMN    :=  (cAliasSB1)->B1_X_LMN
			TRBC02->B1_X_PQR    :=  (cAliasSB1)->B1_X_PQR
			TRBC02->B1_X_NEOIL  :=  (cAliasSB1)->B1_X_NEOIL
			TRBC02->B1_X_XYZ    :=  (cAliasSB1)->B1_X_XYZ
			TRBC02->B1_X_123    :=  (cAliasSB1)->B1_X_123
			TRBC02->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			//TRBC02->T_SAPANHE   :=  0                    // ???
			TRBC02->B1_X_TMEA   :=  (cAliasSB1)->B1_X_TMEA
			TRBC02->B1_COD      :=  (cAliasSB1)->B1_COD
			TRBC02->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
			TRBC02->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
			TRBC02->T_EIS       :=  aTrataEis[1,3]
			
			MsUnlock()
			
		Endif
		
	Next
	
Endif



if  len(aListB)=0
	
	aListB:={{""}}
	
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
	oListB:Refresh()
	
	cRefe := CriaVar("B1_X_REFER")
	oRefe :Refresh()
	SetFocus(oRefe:hWnd)
	
	
	Aviso('Atencao','Nenhum item foi encontrado para a Referencia.',{'Ok'})
	
	
Else
	
	
	// Orderno os Similares
	aSort( aListB, , , { |x,y| y[1] > x[1] } )
	
	// Sem estas tres linhas o reflesh nao ocorre de maneira correta.
	oListB:SetArray(aListB)
	oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
	oListB:nAt   := 1    // Posiciona no Primeiro Item
	oListB:Refresh()
	
	// Foco no ListBox
	//oListB:SetFocus()
	//SetFocus(oQuan:hWnd)
	
Endif


Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraMarkB³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera dados no Trb conf. solitado no filtro para MarkBrowse ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraMarkB(cSimil,aStru,oMark2,cRefe,cSufix,cMarc,oListB)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Trb de acordo com a Similaridade                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRBC02") <> 0 .and. !EmptY(cSimil)
	dbSelectArea("TRBC02")
	If !lF8
		Set FIlter to TRBC02->B1_X_SIMIL = cSimil
	Else
		Set FIlter to TRBC02->B1_X_SIMIL = cSimil .and.;
		(TRBC02->T_SMATRIZ <> 0 .or.;
		TRBC02->T_SFILIAL  <> 0 .or.;
		TRBC02->T_SMALHA   <> 0 .or.;
		TRBC02->T_SCONSIG  <> 0 .or.;
		TRBC02->T_RESERVA  <> 0 .or.;
		TRBC02->T_STRANSI  <> 0 .or.;
		TRBC02->T_SEMPENH  <> 0 .or.;
		TRBC02->T_FATURAR  <> 0 .or.;
		TRBC02->T_CLASSIF  <> 0)
		
		
	Endif
	IndRegua("TRBC02",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
	DbGotop()
Endif

oMark2:oBrowse:Refresh(.t.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldGrava ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Produtos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldGrava(cFABRI,oMarc,cRefe,oRefe,cSufix,oSufix,nQuan,oQuan,oDlgProd,oListB,aListB,aStru,oMark2,cMarc)
Local nMarcou := 0
Local ii      := 0
Local cFiltro := ""
Local lRet    := .T.
LOcal aGetArea:= {}


// Controla o semafaro para ativacao da tecla enviar somente e possivel quando tela esta construida devido
// na versao Protheus10 ter apresentado erro quando era ativada durante o processo de construcao de tela ou seja
// a tela ficava travada.
IF !lSemafaro
	Return .t.
Endif


DbSelectArea("TRBC02")

aGetArea:= GetArea()
cFiltro := Dbfilter()

DbGotop()


If  nQuan = 0
	
	Aviso('Atencao','Favor Informar a Quantidade desejada para poder prosseguir...',{'Ok'})
	SetFocus(oQuan:hWnd)
	lRet    := .F.
	
Else
	
	While !TRBC02->(EOF())
		If TRBC02->T_OK == cFABRI
			nMarcou:=nMarcou+1
		Endif
		TRBC02->(DBSKIP())
	Enddo
	
	If nMarcou = 0
		
		Aviso('Atencao','Nenhum item foi enviado pois nenhuma SKU foi selecionada...',{'Ok'})
		DbSelectArea("TRBC02")
		DbGotop()
		lRet    := .F.
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ A rotina abaixo apenas verifica na pilha de chamda se estamos          ³
		//³ utilizando o "MFATC05" pois neste rotina devolvemos apenas             ³
		//³ um codigo do produto.                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cProcName $ "U_MFATC05"
			
			if  nMarcou # 1
				
				Aviso('Atencao','Somente e possivel escolher um Item',{'Ok'})
				DbSelectArea("TRBC02")
				DbGotop()
				lRet    := .F.
				
			Else
				
				// Posiciona no Item Escolhido para posterior envio.
				DbSelectArea("TRBC02")
				DbGotop()
				While !TRBC02->(EOF())
					If TRBC02->T_OK == cFABRI
						Exit
					Endif
					TRBC02->(DBSKIP())
				Enddo
				
			Endif
			
		Endif
		
	Endif
	
Endif


if !lRet
	GeraMarkB(aListB[oListB:nAt][X_SIMIL],@aStru,@oMark2,M->cRefe,M->cSufix,M->cMarc,oListB)
	RestArea(aGetArea)
	Return(.f.)
Endif

Processa({|| Gravar(cFABRI,oRefe,oSufix,oMarc,oDlgProd,oListB,aListB,aStru,oMark2,nQuan,oQuan,;
cRefe,cSufix,cMarc)},"Enviando Itens para Orcamento")


ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento.

If cProcName $ "U_MFATC05"
	oDlgProd:END()
	Return
Endif


cRefe     :=CriaVar("B1_X_REFER")
cSufix    :=CriaVar("B1_X_SUFIX")
cMarc     :=CriaVar("B1_X_MARCA")
nQuan     :=0

M->cRefe  :=cRefe
M->cSufix :=cSufix
M->cMarc  :=cMarc
M->nQuan  :=0


oRefe:Refresh()
//oSufix:Refresh()
//oMarc:Refresh()
oQuan:Refresh()

/*
Processa({|| GeraListB(aListB,oListB,M->cRefe,M->cSufix,M->cMarc,oMark2,oRefe,_cArqB1,aStru)},"Filtrando Simil")
GeraMarkB(aListB[1][1],_cArqB1,@aStru,@oMark2,M->cRefe,M->cSufix,M->cMarc,oListB)
*/



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
dbSelectArea("TRBC02")
dbCloseArea()

If File(_cArqB1+".DTC")
Ferase(_cArqB1+".DTC")
Endif
*/

//FimEstrut2("TRBC02",_cArqB1) // Finaliza o uso do Temporario funcao dentro do sigacusb
If Select("TRBC02") <> 0
  TRBC02->(DbcloseArea())
Endif

_cArqB1   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, _cArqB1, "TRBC02", .F., .F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limpa a coluna de Similares                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aListB     := {{""}}
oListB:SetArray(aListB)
oListB:bLine := { || {xPadC(Transform(aListB[oListB:nAt,X_SIMIL],""),40)}}
oListB:Refresh()

cRefe := CriaVar("B1_X_REFER")
oRefe :Refresh()
SetFocus(oRefe:hWnd)

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gravar    ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Produtos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Gravar(cFABRI,oRefe,oSufix,oMarc,oDlgProd,oListB,aListB,aStru,oMark2,nQuan,oQuan,cRefe,cSufix,cMarc)
Local cItem     := ""
Local nRecno    := 0
Local _cTes     := ""
Local nPRODUTO  := 0
Local nQTDVEN   := 0
Local nPRCVEN   := 0
Local nCtStd    := 0
Local nCtFOB    := 0
Local nQTDFIM   := 0
Local nTES      := 0
Local nCLASFIS  := 0
Local nPRUNIT   := 0
Local nVALOR    := 0
Local nUM       := 0
Local nLOCAL    := 0
Local nProdCli  := 0
Local nB1_ORIGEM:= 0
Local nB1_X_NC_IM:=0
Local nX_REFER  := 0
Local nX_Sufix  := 0
Local nX_FABRI  := 0
Local nStatus   := 0
Local nDtElabo  := 0
Local nDtValid  := 0
Local nDtEncer  := 0
Local nCTPAD    := 0

Local nS_REFER  := 0
Local nS_SUFIX  := 0
Local nS_FABRI  := 0
Local nS_QTDVEN := 0
Local nS_PRODUTO:= 0

Local nMARGE    := 0
Local nMARGV    := 0
Local nMARGA    := 0
Local nCstForn  := 0                    

Local nObserva  := 0

Local aPrVenda  := 0

Local _X_ICM    := 0
Local _X_IPI    := 0

Private nPis         := 0
Private nCofins      := 0
Private nCpmf        := 0
Private nICM         := 0
Private nIPI	      := 0
Private nDescri      := 0

Private _n_Mv_TxPis  := GetMv("MV_TXPIS")         //  Pis            (Padrao)
Private _n_Mv_Cofins1:= GeTMv("MV_TXCOFIN")       //  Confins        (Padrao)
Private _n_Mv_Cpmf   := GeTMV("MV_CPMF")          //  Cpmf           (Especifico)
Private _n_Mv_IcmPad := ""
Private _n_Mv_Comical:= GetMV("MV_COMICAL")       //  Comicao

Private nReser       := 0
Private nItem0       := 0
Private nDtEnt       := 0



If "MATA415" $ Upper(Funname())
	
	DbSelectArea("TMP1")
	nItemAnt := TMP1->(RecNo())       // Item Posicionado antes de Adicionar Novos Itens
	DbGoTop()
	If  Empty(TMP1->CK_PRODUTO)
		cItem := "00"                   // Ultimo Item
	Else
		TMP1->(dbGoBottom())
		cItem := TMP1->CK_ITEM       // Ultimo Item
		TMP1->(dbGoto(nItemAnt))     // Retorna para Item que estava posicionado
	Endif
	
	DbSelectArea("TRBC02")
	
	SET FILTER TO
	
	ProcRegua(TRBC02->(RECCOUNT()) )
	
	DbGotop()
	
	While !TRBC02->(EOF())
		
		IncProc()
		
		If TRBC02->T_OK == cFABRI
			
			DbSelectArea("SB1")
			DbSetORder(1)
			Dbseek(xFilial("SB1")+TRBC02->B1_COD)
			
			
			//
			// Define a TES a ser utilizada por este produto.
			//
			_cTes:=U_TESDEF(_cIndComer)
			
			//
			// Com base na Tes acima Define o Icms.
			//
			// Cliente de Entrega
			DbSelectArea("SA1")
			DbSetorder(1)
			Dbseek(xFilial("SA1")+_cClient+_cLojaEnt)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o item no Cadastro de Clientes                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_X_ICM      := U_IcmsAliq(_cClient,_cLojaEnt,TRBC02->B1_COD,_cTes)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ipi utilizado no Calculo                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_X_Ipi      := U_IpiAliq(_cClient,_cLojaEnt,TRBC02->B1_COD,_cTes)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cofins Utilizado no Calculo                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_X_Cofins   := U_CofinsAliq(_cClient,_cLojaEnt,TRBC02->B1_COD,_cTes)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pis  Utilizado no Calculo                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_X_Pis      := U_PisAliq(_cClient,_cLojaEnt,TRBC02->B1_COD,_cTes)
			
			// Cliente de Faturamento
			DbSelectArea("SA1")
			DbSetorder(1)
			Dbseek(xFilial("SA1")+_cCliente+_cLoja)
			
			//
			// Garante o posicionamento da Tes apos sair da Funcao acima.
			//
			SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+_cTes))
			
			
			//
			// Define Preco de Venda
			// Necessitei colocar novamente este campo aqui devido ao Mauricio nao
			// desejar ver o campo Preco Preco Sugerido Sem Slow.
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
			//³ Parametros                                                             ³
			//³ 1. < cGetCond > - Condicoes de Pagamento                               ³
			//³ 2 <._cProd    > - Produto Desejado                                     ³
			//³ 3.< NIL       > - I(Industria)/C(Comercio)                             ³
			//³                   Caso Nil a propria rotina define                     ³
			//³                   atraves da Origem.                                   ³
			//³  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  ³
			//³                   .F. Outras origens.                                  ³
			//³                   Motivo controle do custo que vem do acols.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//aPrVenda  := U_PrVenda(_cGetCond,SB1->B1_COD,_cIndComer,.F.,_nFrete)

            
            //            
			// Custo Informado pelo Fornecedor
            // 
            nCstForn:= RetCusto(_cCliente,TRBC02->B1_COD)			
			
			cItem := Soma1(cItem) // Novo Item
			
            DbSelectARea("TMP1") // Alterado - Almeida 21/05/2014
			Reclock("TMP1",.T.)
			TMP1->CK_ITEM   := cItem
			TMP1->CK_PRODUTO:= TRBC02->B1_COD
			TMP1->CK_DESCRI := SB1->B1_DESC
			TMP1->CK_X_REFER:= TRBC02->B1_X_REFER
			TMP1->CK_X_SUFIX:= TRBC02->B1_X_SUFIX
			TMP1->CK_UM     := TRBC02->B1_UM
			TMP1->CK_X_MARCA:= TRBC02->B1_X_MARCA // + TRBC02->B1_ORIGEM + TRBC02->B1_X_PRODU
			TMP1->CK_QTDVEN := nQuan
			TMP1->CK_X_CTPAD:= SB1->B1_X_CTSTD                               // Custo a ser guardado apenas como visual.
			TMP1->CK_X_CTSTD:= Iif(nCstForn<>0,nCstForn,SB1->B1_X_CTSTD )    // Custo alteravel.
			TMP1->CK_X_FOB  := SB1->B1_X_CTFOB
			TMP1->CK_PRCVEN := TRBC02->CK_PRCVEN
			TMP1->CK_X_PRUN := TRBC02->CK_PRCVEN      // Preco de Tabela
			TMP1->CK_PRUNIT := TRBC02->CK_PRCVEN   // Preco de Tabela
			TMP1->CK_VALOR  := nQuan * TRBC02->CK_PRCVEN
			TMP1->CK_X_MARGE:= TRBC02->CK_X_MARGE
			TMP1->CK_X_MARGV:= TRBC02->CK_X_MARGV
			TMP1->CK_X_MARGA:= TRBC02->CK_X_MARGA
			TMP1->CK_X_DTLIB:= CTOD("")             //Deve ser enviado como branco caso contrario o
			// sistema preenche com data de hoje.
			TMP1->CK_LOCAL  := IIf(alltrim(GetMv("MV_MODFIL")) = "03","  ","01") //IIF(SM0->M0_CODFIL="01","01","  ") // Opcao 01 - HandHeld On-Line
			TMP1->CK_LOCNOME:= GetAdvFval("NNR","NNR_DESCRI",xFilial("NNR")+CK_LOCAL, 1)
			TMP1->CK_TES    := _cTes
			TMP1->CK_CLASFIS:= SB1->B1_ORIGEM+SF4->F4_SITTRIB
			TMP1->CK_FILVEN := M->CJ_FILVEN
			TMP1->CK_FILENT := M->CJ_FILENT
			TMP1->CK_X_CPMF := _n_Mv_Cpmf     // Cpmf
			TMP1->CK_X_PIS  := _X_Pis         // Pis      Obs. O frete e condicao de pagamento vem do
			TMP1->CK_X_COFIN:= _X_Cofins      // Cofins        Cabecalho.
			TMP1->CK_X_ICM  := _X_ICM         // Icm
			TMP1->CK_X_IPI  := _X_Ipi         // Ipi SB1->B1_IPI
			TMP1->CK_X_ENTRE:= M->CJ_X_DTPRE // Data de Entrega
			TMP1->CK_X_PRCLI:= "" //U_CodCliente(SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,CriaVar("Z6_PRODCLI"),.F.)
			TMP1->CK_X_PRODU:= SB1->B1_X_PRODU //MTK
			TMP1->CK_X_CTSA5:= nCstForn
			MsUnlock()
			
			nRecno:=0
			
		Endif
		
		TRBC02->(DBSKIP())
		
		// Este comando estabiliza o acols devido quando o controle volta para o acols e
		// qualquer linha e alterada o acols estava se perdendo.
		ogetdad:ncount:= tmp1->(reccount())
		
		
	Enddo
	
	//
	// Esta linha impede que o sistema perca a primeira linha
	//
	TMP1->(dbGoTop())
	
	oGetDad:oBrowse:GoTop() //(ao invés de: oGetDad:oBrowse:Refresh())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³No momento que e adicionado um novo item a media Geral e ³
	//³Calculada.Este procedimento ocorre tambem quando n       ³
	//³utilizando o Simulador                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_MediaRent(NIL,NIL,"O")
	
	
	
ElseIf Upper(Funname())="#MFATC04" .and. !(cProcName $ "U_MFATC05")
	
	
	nITEM     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_ITEM"})
	nPRODUTO  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
	nQTDVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
	nQTDFIM   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDFIM"})
	nPRCVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
	nCTPAD    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CTPAD"})
	nCtStd    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CTSTD"})
	nCtFOB    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_FOB"})
	nTES      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_TES"})
	nCLASFIS  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CLASFIS"})
	nPRUNIT   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
	nVALOR    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
	nUM       := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_UM"})
	nLOCAL    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCAL"})
	nStatus   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_STATUS"})
	nDtElabo  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_DTELABO"})
	nDtValid  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_DTVALID"})
	//nDtEncer  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_DTENCER"})
	nProdCli  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODCLI"})
	nX_REFER  :=aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_REFER"})
	nX_Sufix  :=aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_SUFIX"})
	nX_FABRI  :=aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARCA"})
	nMARGE    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	nMARGV    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	nMARGA    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	nPis      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_PIS"})
	nCofins   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_COFIN"})
	nCpmf     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CPMF"})
	nICM      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_ICM"})
	nIPI	    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_IPI"})
	nDescri	 := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_DESCRI"})
	nObserva  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_OBSERVA"})
	
	nReser    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_RESER"})
	nItem0    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_ITEM0"})
	nDtEnt    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_DTENT"})
	
	
	If LEN(Acols) = 1 .and. EmptY(aCols[1][nPRODUTO])
		cItem     := "00"
	Else
		cItem     := aCols[LEN(aCols)][nITEM]
	Endif
	
	
	DbSelectArea("TRBC02")
	
	SET FILTER TO
	
	ProcRegua(TRBC02->(RECCOUNT()) )
	
	DbGotop()
	
	While !TRBC02->(EOF())
		
		IncProc()
		
		If TRBC02->T_OK == cFABRI
			
			DbSelectArea("SB1")
			DbSetORder(1)
			Dbseek(xFilial("SB1")+TRBC02->B1_COD)
			
			//
			// Define a TES a ser utilizada por este produto.
			//
			_cTes:=U_TESDEF(_cIndComer)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona o item no Cadastro de Clientes                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Cliente de Entrega
			DbSelectArea("SA1")
			DbSetorder(1)
			Dbseek(xFilial("SA1")+_cClient+_cLojaEnt)
			
			_n_Mv_IcmPad := U_IcmsAliq(_cClient,_cLojaEnt,TRBC02->B1_COD,_cTes)
			
			// Cliente de Faturamento
			DbSelectArea("SA1")
			DbSetorder(1)
			Dbseek(xFilial("SA1")+_cCliente+_cLoja)
			
			
			cItem := Soma1(cItem) // Novo Item
			
			if  cItem  = "01"
				nLin := 1
			Else
				AADD(aCols,Array(Len(aHeader)+1))
				nLin := Len(aCols)
			Endif
			
			/*
			//
			// Posiciona o Tes
			//
			If  CFILANT $ "10|12|16"     // ALBRAS / ALUMAR  / MRM
			_cTes   := "574"
			Else
			_cTes   := IIF(SA1->A1_EST="AM","   ",IIf(_cIndComer="C","536","537"))
			Endif
			SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+_cTes))
			*/
			
			aCols[nLin][Len(aHeader)+1]:=.F.
			aCols[nLin][nITEM]      := cItem
			aCols[nLin][nPRODUTO]   := TRBC02->B1_COD
			aCols[nLin][nUM]        := TRBC02->B1_UM
			aCols[nLin][nX_REFER]   := TRBC02->B1_X_REFER
			aCols[nLin][nX_Sufix]   := TRBC02->B1_X_SUFIX
			aCols[nLin][nX_FABRI]   := TRBC02->B1_X_MARCA //+ TRBC02->B1_ORIGEM + TRBC02->B1_X_PRODU //TRBC02->B1_X_MARCA + TRBC02->B1_X_PRODU
			aCols[nLin][nQTDVEN]    := nQuan
			aCols[nLin][nCTPAD]     := SB1->B1_X_CTSTD          // Preco Stander
			aCols[nLin][nCTSTD]     := SB1->B1_X_CTSTD          // Preco Stander
			aCols[nLin][nPRCVEN]    := TRBC02->CK_PRCVEN           // Preco Sugerido
			aCols[nLin][nPRUNIT]    := TRBC02->CK_PRCVEN           // Preco de Venda
			aCols[nLin][nVALOR]     := NOROUND(nQuan * TRBC02->CK_PRCVEN,2)
			aCols[nLin][nDTELABO]   := If(Empty(dDtElabo),dDataBase,dDtElabo)  // Privites do Mfatc04
			aCols[nLin][nDTVALID]   := if(EmptY(dDtValid),dDataBase,dDtValid)
			//aCols[nLin][nDtEncer]   := CTOD("")
			aCols[nLin][nStatus]    := "N"
			aCols[nLin][nTES]       := _cTes  //SB1->B1_TS
			aCols[nLin][nLOCAL]     := "01"   //SB1->B1_TS
			aCols[nLin][nCLASFIS]   := SB1->B1_ORIGEM+SF4->F4_SITTRIB //" "+GetAdvFval("SF4","F4_SITTRIB",xFilial("SF4") + aCols[nLin][nTES] , 1)
			aCols[nLin][nQTDFIM]    := 0
			// Retorna o produto do cliente com base no SA7
			aCols[nLin][nProdCli]   := CriaVar("Z6_PRODCLI")   //U_CodCliente(SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,CriaVar("Z6_PRODCLI"),.F.)
			
			aCols[nLin][nMARGE]     := TRBC02->CK_X_MARGE
			aCols[nLin][nMARGV]     := TRBC02->CK_X_MARGV
			aCols[nLin][nMARGA]     := TRBC02->CK_X_MARGA
			
			aCols[nLin][nPis]       := _n_Mv_TxPis   // Pis       Obs. O frete e condicao de pagamento vem do
			aCols[nLin][nCofins]    := _n_Mv_Cofins1 // Cofins         Cabecalho.
			aCols[nLin][nCpmf]      := _n_Mv_Cpmf    // Cpmf
			aCols[nLin][nIcm]       := _n_Mv_IcmPad  // Icm
			aCols[nLin][nIpi]       := SB1->B1_IPI   // Ipi
			
			aCols[nLin][nDescri]    := SB1->B1_DESC
			aCols[nLin][nObserva]   := CriaVar("Z6_OBSERVA")
			aCols[nLin][nReser]     := CriaVar("Z6_X_RESER")
			aCols[nLin][nItem0]     := CriaVar("Z6_X_ITEM0")
			
			aCols[nLin][nDtEnt]     := CTOD("")
			aCols[nLin][nCtFOB]     := SB1->B1_X_CTFOB
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alimentacao dos campos Virtuais³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			U_B1VIRTUAL(aCols,aHeader,nLin)
			
			nRecno:=0
			
		Endif
		
		TRBC02->(DBSKIP())
		
	Enddo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³No momento que e adicionado um novo item a media Geral e ³
	//³Calculada.Este procedimento ocorre tambem quando n       ³
	//³utilizando o Simulador                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_MediaRent(NIL,NIL,"C")
	
	
ElseIf cProcName $ "U_MFATC05"        // Produto de Substituicao no Pedido
	
	
	
	nS_REFER  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_REFER"})
	nS_SUFIX  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SUFIX"})
	nS_FABRI  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_MARCA"})
	nS_QTDVEN := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"})
	nS_PRODUTO:= aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SKU"})
	nCTPAD    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CTPAD"})
	nCtStd    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CTSTD"})
	nPRCVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
	nVALOR    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
	
	
	DbSelectArea("TRBC02")
	
	SET FILTER TO
	
	ProcRegua(TRBC02->(RECCOUNT()) )
	
	DbGotop()
	
	While !TRBC02->(EOF())
		
		IncProc()
		
		If TRBC02->T_OK == cFABRI
			
			
			aCols[n][nS_PRODUTO]:= TRBC02->B1_COD
			aCols[n][nS_REFER]  := TRBC02->B1_X_REFER
			aCols[n][nS_SUFIX]  := TRBC02->B1_X_SUFIX
			aCols[n][nS_FABRI]  := TRBC02->B1_X_MARCA //+ TRBC02->B1_ORIGEM + TRBC02->B1_X_PRODU //TRBC02->B1_X_MARCA
			aCols[n][nS_QTDVEN] := nQuan
			aCols[n][nCTPAD]    := SB1->B1_X_CTSTD          // Preco Padrao
			aCols[n][nCTSTD]    := SB1->B1_X_CTSTD          // Preco Stander
			//aCols[n][nPRCVEN]   := TRBC02->CK_PRCVEN            //Nao pode ser alterado devo manter o preco contratado
			//aCols[n][nVALOR]    := nQuan * aCols[n][nPRCVEN]
			
		Endif
		
		TRBC02->(DBSKIP())
		
	Enddo
	
	
	//1. Calcula nova Rentabilidade durante a substituicao
	//   do item de contrato
	U_CalcSim2(n,.F.,.T.,"U_MFATC05")
	
	//2. Atualiza a media no Cabecalho
	U_MediaRent(NIL,NIL,"C")
	
Endif


Return






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ExistRefe ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Refencia                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExistRefe(aListB,oListB,oMark2,aStru,cRefe,cSufix,cMarc,oRefe,oQuan,oSufix)

if EmptY(cRefe)
	Return(.f.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
dbSelectArea("TRBC02")
dbCloseArea()

If File(_cArqB1+".DTC")
Ferase(_cArqB1+".DTC")
Endif
*/

// Controla o semafaro para ativacao da tecla enviar somente e possivel quando tela esta construida devido
// na versao Protheus10 ter apresentado erro quando era ativada durante o processo de construcao de tela ou seja
// a tela ficava travada.
lSemafaro:=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRBC02")
dbCloseArea()
If File(_cArqB1+".DTC")
	Ferase(_cArqB1+".DTC")
Endif

If File(_cArqPro+OrdBagExt())
	FErase(_cArqPro+OrdBagExt())
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria um novo Temporario mas com o mesmo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqB1  :=   CriaTrab(aStru,.T.)
DbUseArea(.T.,, _cArqB1, "TRBC02", .F., .F.)



Processa({|| GeraListB(aListB,oListB,cRefe,cSufix,cMarc,oMark2,oRefe,aStru,oQuan),"Aguarde...Buscando Simil"})


GeraMarkB(aListB[1][1],@aStru,@oMark2,cRefe,cSufix,cMarc,oListB)

//oQuan:Refresh()
//SetFocus(oQuan:hWnd)

// Controla o semafaro para ativacao da tecla enviar somente e possivel quando tela esta construida devido
// na versao Protheus10 ter apresentado erro quando era ativada durante o processo de construcao de tela ou seja
// a tela ficava travada.
lSemafaro:=.T.

Return(.t.)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcSim2  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua todos os calculos necessarios para determinar:       º±±
±±º          ³a) Atualiza o Custo do Produto.                             º±±
±±º          ³b) Determina a Rentabilidade do Item em %                   º±±
±±º          ³c) Determina a Rentabilidade do Item em R$                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcSim2(nLin,lValid,lPrecoAlt,cOrigem)

Local cAreaAtu    := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O conteudo das variaveis abaixo tem como origem o acols.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nQtdven    := 0
Local _nPreunit   := 0
Local _nPrcven    := 0
Local _nValor     := 0
Local _nMargV     := 0
Local _nMargA     := 0
Local _nMargE     := 0
Local _nDescont   := 0
Local _nIpi       := 0
Local _nIcm       := 0
Local _nPis       := 0
Local _nCofins    := 0
Local _nCpmf      := 0
Local _nCtStd     := 0




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis necessarias para execucao dos Calculos pela Funcao ExecCalc  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _X_Custo    := 0
Local _X_Margem   := 0
Local _X_Ipi      := 0
Local _X_Comissao := 0
Local _X_Pis      := 0
Local _X_Cofins   := 0
Local _X_Cpmf     := 0
Local _X_Icms     := 0
Local _X_Frete    := 0
Local _X_TxFinan  := 0
Local _X_PrazoVe  := 0
Local _X_DescLin  := 0
Local _x_DescAll  := 0
Local nY          := 0
Local _uString               // Retorna o numero de dias para a cond.de Pagto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicao do acols do Contrato apos executado o filtro doos itens a serem³
//³ reajustados.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nZItem     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_ITEM"})
Local nZProduto  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SKU"})
Local nZQtdven   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
Local nZTes      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_TES"})
Local nZClasfis  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CLASFIS"})
Local nZLocal    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCAL"})
Local nZLocNome  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCNOME"})
Local nZCtStd    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CTSTD"})
Local nZPrunit   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
Local nZValor    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
Local nZUm       := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_UM"})
Local nZRefer    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_REFER"})
Local nZSufix    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SUFIX"})
Local nZFABRI    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_MARCA"})
Local nZMargE    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
Local nZMargV    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
Local nZMargA    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})

Local nZPis      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_PIS"})
Local nZCofins   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_COFIN"})
Local nZCpmf     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CPMF"})
Local nZICM      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_ICM"})
Local nZIPI	     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_IPI"})

Local nZProdCli  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODCLI"})
Local nZPrcven   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})

Local nXProduto  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})


// Alterado devido durante a geracao do pedido no contrato o usuario porder alterar o preco
Local nPrcVen    := IIF(lValid .AND. TYPE("M->Z6_PRCVEN")  <>"U",&("M->Z6_PRCVEN")   , aCols[nLin][nZPrcven] )


// Caso esteja geracao de pedido estou trabalhando
// com o produto subtitutivo.
// Neste momento definir qual e o produto e importante
// pois precisamos definir o custo deste produto.
Local nPosProd   := IIF("U_MFATC05" $ cOrigem , nZProduto , nXProduto )



Private lCancelar := .F.
Private _n_Mv_Jurmes := GetMV("MV_JURMES")          //  Juros no Mes   (Especifico)
Private _n_Mv_Comical:= GetMV("MV_COMICAL")



DEFAULT lValid    := .F.


//Estou considerando apenas no momento do calculo mostrar em tela
//pois um item pode ser deletado e neste momento esta rotina deve ser
//chamada
if aCols[nLin][Len(aHeader)+1]  // Item deletado do Acols no Simulador
	Return                         // Nao e necessario calcular
Endif

//_nQtdven  := aCols[nLin][nZQtdven]
_nCtStd   := SB1->B1_X_CTSTD
_nPrcven  := nPrcVen
_nValor   := aCols[nLin][nZValor]
_nMarge   := aCols[nLin][nZMargE]
_nMargV   := aCols[nLin][nZMargV]
_nMargA   := aCols[nLin][nZMargA]
_nDescont := 0
_nIpi     := aCols[nLin][nZIpi]
_nIcm     := aCols[nLin][nZIcm]
_nPis     := aCols[nLin][nZPis]
_nCofins  := aCols[nLin][nZCofins]
_nCpmf    := aCols[nLin][nZCpmf]




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o  Cadastro de Clientes / Cadastro de Produtos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DbSelectArea("SA1")  Teoricamente ja esta posicionado.
//DbSetorder(1)        Neste momento nao e possivel posicionar pois nao a informacao
//Dbseek(xFilial("SA1")+SA1->(A1_COD+A1_LOJA))  nao esta na tela e nao esta no acols.

DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+aCols[nLin][nPosProd])
	Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo :"+aCols[nLin][nPosProd]+;
	" nao Cadastrado.",{"&Ok"})
	Return(.f.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Custo do Produto                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_X_Custo  := U_AjudCalc("CUSTO",SB1->B1_COD,0,"",@lCancelar,.T.)
//_X_Custo    := _nCtStd

_X_Custo             := SB1->B1_X_CTSTD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Margem do Produto                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Margem   := U_AjudCalc("MARGEM",SB1->B1_COD,_nMarge,"",@lCancelar,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comissao do Item                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Comissao := U_AjudCalc("COMISSAO",SB1->B1_COD,0,"",@lCancelar,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Condicoes de Pagamento                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_uString    := U_AjudCalc("PGTO",SB1->B1_COD,0,cCondpag,@lCancelar,.T.)


If lCancelar
	Return({})
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         Inicio dos Calculos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Rotina 2		Simulação de preços dos produtos através de alteracoes |
//|                 de dados pré-definidos (margem de contribuição,        |
//|                 comissão de vendas, fretes, prazo)				   	   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Margem     :=  _nMarge  // Margem digitada.
_X_Ipi        :=  _nIpi
_X_Pis        :=  _nPis
_X_Cofins     :=  _nCofins
_X_Cpmf       :=  _nCpmf
_X_Icms       :=  _nIcm
_X_Frete      :=  nFrete
_X_TxFinan    :=  _n_Mv_Jurmes
_X_PrazoVe    :=  _uString
_X_DescLin    :=  _nDescont
_x_DescAll    :=  0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a alteracao partiu do preco de venda, caso, ³
//³afirmativo executa o calculo de novo maneira            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//lPrecoAlt :=.T.


aPrVenda := {}
aPrVenda := U_ExecCalc(_X_Custo ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,lPrecoAlt,_nPrcven,nLin,CJ_X_ST_CI)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Resultado da Rotina 3 - Efetua Atualizacoes de Tela                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Praticamente todas as clamadas da funcao calcsim2 estao ocorrendo com
// o parametro lPrecoAlt  = .T. ou seja considera o preco como alterado
// nao dando novo preco para a mercadoria e abaixo apenas gravamos as margens e
// o novo custo do produto.
// 1) Atualiza o Preco de Venda do Produto(Preco SImulado)
//aCols[nLin][nZPrcven] := aPrVenda[02,03]
// 2) Atualiza o Preco Total
//aCols[nLin][nZValor]  := aCols[nLin][nZPrcven] * _nQtdven


If lPrecoAlt  // .t. preco foi alterado
	
	If nZCtStd <> 0
		// 1) Atualiza o acols com o Custo que foi utilizado
		aCols[nLin][nZCtStd] :=  SB1->B1_X_CTSTD
	Endif
	// 2) Atualiza a Rentabilidade em termos de Valor($)
	aCols[nLin][nZMargV]  := aPrVenda[03,03]
	// 3) Atualiza a Rentabilidade em termos de Percentuais(%)
	aCols[nLin][nZMargE]  := aPrVenda[04,03]
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Este parametro permite que o calculo apos efetuado pela rotina  4   ³
	//³rotina que trata desconto seja refeito pela Rotina 1                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If GETMV("MV_TIPCAL")
		
		U_CalcSim(nLin,.F.)   // Chamo novamente para ajustar corretamente com base na Rotina 1
		
	Endif
	
Endif

aCols[nLin][nZMargA]  :=  U_AvalMarg(aCols[nLin][nZMargE])

RestArea(cAreaAtu)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcSim3  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua todos os calculos necessarios para determinar:       º±±
±±º          ³a) Atualiza o Custo do Produto.                             º±±
±±º          ³b) Determina a Rentabilidade do Item em %                   º±±
±±º          ³c) Determina a Rentabilidade do Item em R$                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CalcSim3(nLin,lValid,lPrecoAlt,cOrigem)

Local cAreaAtu    := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O conteudo das variaveis abaixo tem como origem o acols.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nQtdven    := 0
Local _nPreunit   := 0
Local _nPrcven    := 0
Local _nValor     := 0
Local _nMargV     := 0
Local _nMargA     := 0
Local _nMargE     := 0
Local _nDescont   := 0
Local _nIpi       := 0
Local _nIcm       := 0
Local _nPis       := 0
Local _nCofins    := 0
Local _nCpmf      := 0
Local _nCtStd     := 0




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis necessarias para execucao dos Calculos pela Funcao ExecCalc  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _X_Custo    := 0
Local _X_Margem   := 0
Local _X_Ipi      := 0
Local _X_Comissao := 0
Local _X_Pis      := 0
Local _X_Cofins   := 0
Local _X_Cpmf     := 0
Local _X_Icms     := 0
Local _X_Frete    := 0
Local _X_TxFinan  := 0
Local _X_PrazoVe  := 0
Local _X_DescLin  := 0
Local _x_DescAll  := 0
Local nY          := 0
Local _uString               // Retorna o numero de dias para a cond.de Pagto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicao do acols do Contrato apos executado o filtro doos itens a serem³
//³ reajustados.                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lCancelar := .F.
Private _n_Mv_Jurmes := GetMV("MV_JURMES")          //  Juros no Mes   (Especifico)
Private _n_Mv_Comical:= GetMV("MV_COMICAL")

DEFAULT lValid    := .F.


_nCtStd   := aCols[nLin][nZCtStd]
_nPrcven  := TRBC02->Z6_PRCVEN
_nValor   := aCols[nLin][nZValor]
_nMarge   := aCols[nLin][nZMargE]
_nMargV   := aCols[nLin][nZMargV]
_nMargA   := aCols[nLin][nZMargA]
_nDescont := 0
_nIpi     := aCols[nLin][nZIpi]
_nIcm     := aCols[nLin][nZIcm]
_nPis     := aCols[nLin][nZPis]
_nCofins  := aCols[nLin][nZCofins]
_nCpmf    := aCols[nLin][nZCpmf]




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o  Cadastro de Clientes / Cadastro de Produtos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DbSelectArea("SA1")  Teoricamente ja esta posicionado.
//DbSetorder(1)        Neste momento nao e possivel posicionar pois nao a informacao
//Dbseek(xFilial("SA1")+SA1->(A1_COD+A1_LOJA))  nao esta na tela e nao esta no acols.

DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+aCols[nLin][nPosProd])
	Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo :"+aCols[nLin][nPosProd]+;
	" nao Cadastrado.",{"&Ok"})
	Return(.f.)
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Custo do Produto                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//_X_Custo  := U_AjudCalc("CUSTO",SB1->B1_COD,0,"",@lCancelar,.T.)
//_X_Custo    := _nCtStd

_X_Custo             := SB1->B1_X_CTSTD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Margem do Produto                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Margem   := U_AjudCalc("MARGEM",SB1->B1_COD,_nMarge,"",@lCancelar,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Comissao do Item                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Comissao := U_AjudCalc("COMISSAO",SB1->B1_COD,0,"",@lCancelar,.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Condicoes de Pagamento                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_uString    := U_AjudCalc("PGTO",SB1->B1_COD,0,cCondpag,@lCancelar,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o item no Cadastro de Clientes                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_ICM      := U_IcmsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ipi utilizado no Calculo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Ipi      := U_IpiAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cofins Utilizado no Calculo                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Cofins   := U_CofinsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pis  Utilizado no Calculo                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Pis      := U_PisAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)


If lCancelar  
    RestArea(cAreaAtu) 
	Return({})
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         Inicio dos Calculos                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³	Rotina 2		Simulação de preços dos produtos através de alteracoes |
//|                 de dados pré-definidos (margem de contribuição,        |
//|                 comissão de vendas, fretes, prazo)				   	   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_Margem     :=  _nMarge  // Margem digitada.
//_X_Ipi        :=  _nIpi
//_X_Pis        :=  _nPis
//_X_Cofins     :=  _nCofins
_X_Cpmf       :=  _nCpmf
//_X_Icms       :=  _nIcm
_X_Frete      :=  nFrete
_X_TxFinan    :=  _n_Mv_Jurmes
_X_PrazoVe    :=  _uString
_X_DescLin    :=  _nDescont
_x_DescAll    :=  0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a alteracao partiu do preco de venda, caso, ³
//³afirmativo executa o calculo de novo maneira            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//lPrecoAlt :=.T.


aPrVenda := {}
aPrVenda := U_ExecCalc(_X_Custo ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,lPrecoAlt,_nPrcven,nLin,CJ_X_ST_CI)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Resultado da Rotina 3 - Efetua Atualizacoes de Tela                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Praticamente todas as clamadas da funcao calcsim2 estao ocorrendo com
// o parametro lPrecoAlt  = .T. ou seja considera o preco como alterado
// nao dando novo preco para a mercadoria e abaixo apenas gravamos as margens e
// o novo custo do produto.
// 1) Atualiza o Preco de Venda do Produto(Preco SImulado)
//aCols[nLin][nZPrcven] := aPrVenda[02,03]
// 2) Atualiza o Preco Total
//aCols[nLin][nZValor]  := aCols[nLin][nZPrcven] * _nQtdven


If lPrecoAlt  // .t. preco foi alterado



	
	If nZCtStd <> 0
		// 1) Atualiza o acols com o Custo que foi utilizado
		aCols[nLin][nZCtStd] :=  SB1->B1_X_CTSTD
	Endif
	// 2) Atualiza a Rentabilidade em termos de Valor($)
	aCols[nLin][nZMargV]  := aPrVenda[03,03]
	// 3) Atualiza a Rentabilidade em termos de Percentuais(%)
	aCols[nLin][nZMargE]  := aPrVenda[04,03]
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Este parametro permite que o calculo apos efetuado pela rotina  4   ³
	//³rotina que trata desconto seja refeito pela Rotina 1                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If GETMV("MV_TIPCAL")
		
		U_CalcSim(nLin,.F.)   // Chamo novamente para ajustar corretamente com base na Rotina 1
		
	Endif
	
Endif

aCols[nLin][nZMargA]  :=  U_AvalMarg(aCols[nLin][nZMargE])

RestArea(cAreaAtu)

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CodCliente³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Esta funcao retorna o Codigo do Produto no Cliente         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CodCliente(cCliente,cLoja,cProduto,cCodCli,lGrava)

Local   _aArea  := GetArea()
Default cCodCli := CriaVar("Z6_PRODCLI")


DbselectArea("SA7")
DbsetORder(1)
if  lGrava
	
	If EmptY(cCodCli) .or. alltrim(cCodCli)='.'
		cCodCli := GetMV("MV_CODCLIE")
	Endif
	
	If Dbseek(xFilial("SA7")+cCliente+cLoja+cProduto)
		Reclock("SA7",.F.)
	Else
		Reclock("SA7",.T.)
	Endif
	
	SA7->A7_FILIAL := xFilial("SA7")
	SA7->A7_CLIENTE:= cCliente
	SA7->A7_LOJA   := cLoja
	SA7->A7_PRODUTO:= cProduto
	SA7->A7_CODCLI := cCodCli
	
Else
	
	If Dbseek(xFilial("SA7")+cCliente+cLoja+cProduto)
		cCodCli := SA7->A7_CODCLI
	Else
		cCodCli := GetMV("MV_CODCLIE")
	Endif
	
Endif

RestArea(_aArea)

Return(cCodCli)




User Function consprodu(oMark2,cProduto,cFABRI,lInverte)
Private aRot := aClone( aRotina )

U_MFATC03(cProduto)

aRotina := aClone( aRot )

/* NAO FUNCIONOU TENTATIVA DE DAR UM REFRASH NO OBJETIVO DEVIDO
TRAVAMENTO COM A CONSULTA PRODUTOS DA EXPORTACAO.
oMark2:oBrowse:Enable()
oMark2:bMark := {| | MfatDisp(cFABRI,lInverte,@oMark2)}   // Atualiza outras telas quando dispara o
oMark2:oBrowse:lhasMark := .t.                             // evento click
oMark2:oBrowse:lCanAllmark := .t.
oMark2:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark2) } // Permite FABRIr um, inverter,
oMark2:oBrowse:nFreeze  := 5  // congelando estas colunas ocorre um "flicker" na tela
//oMark2:oBrowse:lDisablePaint := .T.
oMark2:oBrowse:Refresh(.t.)
*/

Return
                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Parse      ³ autor ³                     ³ Data ³ 23/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tratamento utilizado para separar os Email para envio      ´±±
±±³          ³ personalizado.                                             ´±±
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Parametro ³                                                            ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ParseSep(_uString)
Local nPos
Local xRet
Local cVar
Local cExecuta := ""

iF  AT(";",_uString) = 0
	cExecuta := _uString ///	substr(alltrim(_uString),1,2)
	_uString := ""
Else
	iF  AT(";",_uString) > 0
		nPos := AT(";",_uString)
		If  nPos > 0
			cExecuta := SubStr(_uString,1,nPos-1)
			_uString := If(Len(_uString)>nPos,SubStr(_uString,nPos+1,Len(_uString)-nPos),"")
		EndIf
	Else
		cExecuta := _uString
		_uString := ""
	Endif
Endif
Return(cExecuta)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RetCusto   ³ autor ³                     ³ Data ³ 23/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o custo enviado pelo fornecedor no SA5             ´±±
±±³          ³ personalizado.                                             ´±±
±±³ÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³±±
±±³Parametro ³                                                            ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetCusto(_cCliente,_cProduto) 
Local nCstPadrao := 0
Local _aArea     := GetArea()

DbSelectArea("SA5")                
DbOrderNickname("CLIFOR01") //A5_FILIAL+A5_XCLIMTK+A5_PRODUTO   
If DbSeek(xFilial("SA5")+_cCliente+_cProduto)
   nCstPadrao := SA5->A5_XPREMTK 
Else
   nCstPadrao := 0   
Endif

RestArea(_aArea)
Return(nCstPadrao)

