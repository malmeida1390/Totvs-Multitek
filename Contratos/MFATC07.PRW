#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC07   ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera uma Matriz contendo todos os clientes que deveram ser  º±±
±±º          ³atendidos durante a Geracao do Contrato                     º±±
±±º          ³Chamado no MFATC05. (Geracao de Pedidos atraves de Contrato)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC07(cCliente,cGrpVen)                 
            
Local aGetArea    := GetArea()
Local cCadastro   := "Clientes para geracao de Pedidos"
Local aSizeAut    := MsAdvSize(,.F.)

Local bSetKey4
Local bSetKey12  

Local nOpcA       := 0
Local nY          := 0
Local nLin        := 0 
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local _nItem      := 0
Local nRecno      := 0

Local lInverte    := .f.
Local aBackRot    := aClone(aRotina)
Local aStru       := {}
Local aCampos     := {}
Local cFABRI      := GetMark()
Local nUsado      := 0
Local cArqLoja    := ""
Local cArqGrupo   := ""

Local oMarkLoja,oMarkGrupo  
Local cCampo := ""
Local cVal   := ""
Local nPos   := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera Estrutura do TRBLOJA - Mark Browse - LOJA       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aStru  ,{"T_OK","C", 2 , 0} )
AADD(aCampos,{"T_OK",""," "," "})
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("A1_COD")
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )
DbSeek("A1_LOJA")
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )
DbSeek("A1_NREDUZ")
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )
DbSeek("A1_CGC") 
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )
DbSeek("A1_MUN") 
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )
DbSeek("A1_EST") 
AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o TRBLOJA                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqLoja   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArqLoja, "TRBLOJA", .F., .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o TRBGRUPO                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqGrupo   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArqGrupo, "TRBGRUPO", .F., .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona registros ao TRBLOJA e TRBGRUPO             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraMarkB("TRBLOJA",aStru)

GeraMarkB("TRBGRUPO",aStru)

AAdd( aObjects, { 0,     10, .T., .F. } )  // 80 Indica o Tamaho dos Objetos 
AAdd( aObjects, { 0,     80, .T., .F. } )  // 80 Indica o Tamaho dos Objetos 
AAdd( aObjects, { 0,     10, .T., .F. } )
AAdd( aObjects, { 0,     80,  .T., .F. } )	
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
//aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,80,115,145,180,200},{10,35,80,115,180,200}})

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey4 :=SetKey(VK_F4,{|| U_MFATC03(TRBLOJA->Z6_PRODUTO)})
bSetKey12:=SetKey(VK_F12,nil)

@ aPosObj[1,1],aPosObj[1,2] SAY "Filtro por Loja" of oDlg PIXEL SIZE 200,10 

oMarkLoja := MsSelect():New("TRBLOJA","T_OK",,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})
oMarkLoja:bMark := {| | MfatDisp(cFABRI,lInverte,@oMarkLoja,@oMarkGrupo,"oMarkLoja")}   // Atualiza outras telas quando dispara o 
oMarkLoja:oBrowse:lhasMark = .t.                              // evento click
oMarkLoja:oBrowse:lCanAllmark := .t.
oMarkLoja:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMarkLoja,@oMarkGrupo,"oMarkLoja") } // Permite FABRIr um, inverter,

@ aPosObj[3,1],aPosObj[3,2] SAY "Filtro por Grupo de Clientes" of oDlg PIXEL SIZE 200,10 

oMarkGrupo := MsSelect():New("TRBGRUPO","T_OK",,aCampos,@lInverte,@cFABRI,{aPosObj[4,1],aPosObj[4,2],aPosObj[4,3],aPosObj[4,4]})
oMarkGrupo:bMark := {| | MfatDisp(cFABRI,lInverte,@oMarkLoja,@oMarkGrupo,"oMarkGrupo")}   // Atualiza outras telas quando dispara o 
oMarkGrupo:oBrowse:lhasMark = .t.                              // evento click
oMarkGrupo:oBrowse:lCanAllmark := .t.
oMarkGrupo:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMarkGrupo,@oMarkGrupo,"oMarkGrupo") } // Permite FABRIr um, inverter,


ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1 ,If(U_VALMARK(cFABRI), oDlg:End(),nOpcA := 0)},{||oDlg:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F12,bSetKey12)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cArqLoja+".DTC")
	dbSelectArea("TRBLOJA")
	dbCloseArea()
	Ferase(cArqLoja+".DTC")
	//Ferase(cIndTmp+OrdBagExt())
Endif

If File(cArqGrupo+".DTC")
	dbSelectArea("TRBGRUPO")
	dbCloseArea()
	Ferase(cArqGrupo+".DTC")
	//Ferase(cIndTmp+OrdBagExt())
Endif

RestArea(aGetArea)

Return



User Function VALMARK(cFABRI)
Local lRet := .t.

aCliente  := {}
dbSelectArea("TRBLOJA")
dbGoTop()
While !Eof()
	IF  T_OK == cFABRI
		AADD(aCliente,{TRBLOJA->A1_COD,TRBLOJA->A1_LOJA})
	Endif
	dbSkip()
Enddo


dbSelectArea("TRBGRUPO")
dbGoTop()
While !Eof()
	IF  T_OK == cFABRI
		AADD(aCliente,{TRBGRUPO->A1_COD,TRBGRUPO->A1_LOJA})
	Endif
	dbSkip()
Enddo


If Len(aCLiente) > 1
   Aviso("ATENCAO", "Somente e permitido escolher um cliente.",{"&Ok"})
   lRet := .f.
Endif                  

dbSelectArea("TRBLOJA")
dbGoTop()
dbSelectArea("TRBGRUPO")
dbGoTop()

Return(lRet)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatInvS  ³ Autor ³                       ³ Data ³ 07/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte FABRIcoes 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MfatInvS     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MfatInvS(cFABRI,oMarkLoja,oMarkGrupo,cObjeto)

Local nReg := 0


if cObjeto $ "oMarkLoja"
	
	nReg:= TRBLOJA->(Recno())
	
	dbSelectArea("TRBLOJA")
	dbGoTop()
	While !Eof()
		RecLock("TRBLOJA",.F.)
		IF  T_OK == cFABRI
			TRBLOJA->T_OK := "  "
		Else
			TRBLOJA->T_OK := cFABRI
		Endif
		MsUnlock()
		dbSkip()
	Enddo
	TRBLOJA->(dbGoto(nReg))
	
	oMarkLoja:oBrowse:Refresh(.t.)

Else

	nReg:= TRBGRUPO->(Recno())
	
	dbSelectArea("TRBGRUPO")
	dbGoTop()
	While !Eof()
		RecLock("TRBGRUPO",.F.)
		IF  T_OK == cFABRI
			TRBGRUPO->T_OK := "  "
		Else
			TRBGRUPO->T_OK := cFABRI
		Endif
		MsUnlock()
		dbSkip()
	Enddo
	TRBGRUPO->(dbGoto(nReg))
	
	oMarkGrupo:oBrowse:Refresh(.t.)

Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraMarkB³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera dados no TRBLOJA conf. solitado no filtro para MarkBrowse ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraMarkB(cArq,aStru)

Local aArSZ6 := {}
Local cChave := ""
Local nY     := 0   
Local cCampo := ""
Local cVal   := ""
Local nPos   := 0
          
dbSelectArea("SA1")
aArSZ6 := GetArea()


if Upper(cArq) $ "TRBLOJA"
	
	DbSetOrder(1)                   // Cliente + Loja
	DbGoTop()
	
	cChave := xFilial("SA1") + cCliente
	
	If Dbseek(cChave)
		
		While !SZ6->(EOF()) .and. cChave  =  xFilial("SA1") + SA1->A1_COD
			
			Reclock("TRBLOJA",.T.)
			For nY:= 1 to len(aStru)
				DbSelectArea("SA1")
				cCampo := aStru[nY][1]
				nPos   := FieldPos(cCampo)                                //FieldName(nCont)// Nome do Campo
				if nPos # 0
					cVal   := FieldGet(nPos)                                // Conteudo
					DbSelectArea("TRBLOJA")
					nPos   := FieldPos(cCampo)                              // Busca posicao Campo no TRBLOJA
					if nPos # 0 .and. cCampo # "T_OK"                       //Execao esta na aheder do SZ6
						FieldPut(nPos,cVal)                                   // Grava Conteudo
					Endif
				Endif
			Next
			MsUnLock()
			
			SA1->(DBSKIP())
		Enddo
	Endif

	
ElseIF Upper(cArq) $ "TRBGRUPO"
	
	DbSetOrder(6)                  // Grupo de Clientes
	DbGoTop()
	
	//cChave := xFilial("SA1") + cCliente    //Alterado NASSER 02/07/07
	cChave := xFilial("SA1") + cGrpVen      //+ SA1->A1_GRPVEN
	
	If Dbseek(cChave)
		
		//While !SZ6->(EOF()) .and. cChave  =  xFilial("SA1") + SA1->A1_COD  //Alterado NASSER 02/07/07
		While !SZ6->(EOF()) .and. cChave  =  xFilial("SA1") + SA1->A1_GRPVEN
			
			Reclock("TRBGRUPO",.T.)
			For nY:= 1 to len(aStru)
				DbSelectArea("SA1")
				cCampo := aStru[nY][1]
				nPos   := FieldPos(cCampo)                                //FieldName(nCont)// Nome do Campo
				if nPos # 0
					cVal   := FieldGet(nPos)                                // Conteudo
					DbSelectArea("TRBGRUPO")
					nPos   := FieldPos(cCampo)                              // Busca posicao Campo no TRBLOJA
					if nPos # 0 .and. cCampo # "T_OK"                       //Execao esta na aheder do SZ6
						FieldPut(nPos,cVal)                                   // Grava Conteudo
					Endif
				Endif
			Next
			MsUnLock()
			
			SA1->(DBSKIP())
			
		Enddo
	Endif

Endif


RestArea(aArSZ6) 


DBSELECTAREA("TRBLOJA")
DbGotop()                        
DBSELECTAREA("TRBGRUPO")
DbGotop()                        

//oMarkLoja:oBrowse:Refresh(.t.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do MFatc04 atraves deste pego       ³±±
±±³          ³ todas as funcionalidades do ponto de entreda MA415BUT      ³±±
±±³          ³ utilizado pelo Orcamento.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RfatBar(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


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
Static Function MfatDisp(cFABRI,lInverte,oMarkLoja,oMarkGrupo,cObjeto)
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

if cObjeto $ "oMarkLoja"
   oMarkLoja:oBrowse:Refresh(.t.)
Else
   oMarkGrupo:oBrowse:Refresh(.t.)
Endif

Return
