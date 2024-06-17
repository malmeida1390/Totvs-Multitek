#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Anderson            º Data ³  18/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para gravar o numero da NFS nas etiquetas  º±±
±±º          ³que estao sendo encaminhadas para uma das FILIAIS MULTI-TEK º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()

Local  _cEstoque  := ""
Local  _cOrdemSep := ""

Local  _lEnvio    := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a area corrente                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _aArea		:= GetArea()
DbSelectArea("SC9")
Private _aAreaC9	:= GetArea()
DbSelectArea("SC6")
Private _aAreaC6	:= GetArea()
DbSelectArea("SA1")
Private _aAreaA1	:= GetArea()
DbSelectArea("SF2")
Private _aAreaF2	:= GetArea()
DbSelectArea("SD2")
Private _aAreaD2	:= GetArea()
DbSelectArea("CB0")
Private _aAreaCB0	:= GetArea()
DbSelectArea("CB9")
Private _aAreaCB9	:= GetArea()
DbSelectArea("SF4")
Private _aAreaSF4	:= GetArea()
Private cFilter   := ""
Private _aPedido	:= {}
Private _nLaco		:= 0
Private _cFil     := ""
Private _cArqPRO  := ""


DbSelectArea("SF2")
_cNota		:= SF2->F2_DOC
_cSerie		:= SF2->F2_SERIE
_cCliente	:= SF2->F2_CLIENTE
_cLoja		:= SF2->F2_LOJA

DbSelectArea("SC9")
cFilter:=RetIndex()
DbClearFilter()


DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja)
	
	_cOrdemSep := POSICIONE("SC9",1,xFilial("SC9")+SD2->D2_PEDIDO+SD2->D2_ITEMPV,"C9_ORDSEP")
	
	//
	// Observamos que no parcial o padrao template acd nao esta gravando o D2_ORDSEP.
	//
	// If SC9->(C9_NFISCAL+C9_SERIENF) = SD2->(D2_DOC+D2_SERIE) .and. Empty(SD2->D2_ORDSEP)
	If Empty(SD2->D2_ORDSEP)
		SD2->(RECLOCK("SD2",.F.))
		SD2->D2_ORDSEP:= _cOrdemSep
		SD2->(MSUNLOCK())
	Endif
	
	
	DbSelectArea("CB7")
	DbSetOrder(1)
	
	If DbSeek(xFilial("CB7")+_cOrdemSep)
		
		RecLock("CB7",.F.)
		CB7->CB7_NOTA := SF2->F2_DOC
		CB7->CB7_SERIE:= SF2->F2_SERIE
		MsUnlock()
		
	Endif
	
	
	While !SD2->(Eof()) .and. xFilial("SD2") == SD2->D2_FILIAL .and. SD2->D2_DOC == _cNOta .and. SD2->D2_SERIE == _cSerie
		
		_cEstoque   := POSICIONE("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ESTOQUE")
		if _cEstoque <> "S"      // TES Utilizada nao esta controlando estoque
			_lEnvio := .f.
		Endif
		
		
		DbSelectArea("SC9")
		DbSetOrder(1)
		
		If Dbseek(xFilial("SC9") + SD2->D2_PEDIDO + SD2->D2_ITEMPV)
			
			while  !SC9->(EOF())  .AND.;
				xFilial("SD2") + SD2->D2_PEDIDO + SD2->D2_ITEMPV = xFilial("SC9") + SC9->C9_PEDIDO+SC9->C9_ITEM
				
				_cProdSC9	:= SC9->C9_PRODUTO
				
				DbSelectArea("CB9")
				DBSetOrder(1)
				
				If  DbSeek(xFilial("CB9")+SC9->C9_ORDSEP)
					
					While !CB9->(EOF()) .and. CB9->CB9_ORDSEP == SC9->C9_ORDSEP
						
						If CB9->CB9_PROD == _cProdSC9
							
							DbSelectArea("CB0") // Atualizando Etiqueta com o NUMERO DA NOTA DE SAIDA
							DbSetOrder(1)
							If DBSeek(xFilial("CB0")+CB9->CB9_CODETI)
								
								RecLock("CB0",.F.)
								CB0->CB0_NFSAI	:= SF2->F2_DOC
								CB0->CB0_SERIES:= SF2->F2_SERIE
								CB0->CB0_CLI   := SF2->F2_CLIENTE
								CB0->CB0_LOJACL:= SF2->F2_LOJA
								CB0->CB0_TRANSP:= SF2->F2_TRANSP
								CB0->CB0_VOLUME:= STR(SF2->F2_VOLUME1)
								MsUnlock()
								
								//
								// Deve ser colocada AQUI rotina para gerar o LOG (CBG)
								//CBLog("05",{CB9->CB9_PROD,1,NIL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,NIL,CB0->CB0_CODETI,"M460FIM - Material enviado ao Cliente (Faturamento) "})
								//
								DbSelectArea("CBG")
								DbSetOrder(0)
								Reclock("CBG",.T.)
								CBG_FILIAL:= xFilial("CBG")
								CBG_DATA  := dDataBase
								CBG_HORA  := TIME()
								CBG_EVENTO:= "09"
								CBG_USUARI:= __cUserID
								CBG_CODPRO:= CB9->CB9_PROD
								CBG_ARM   := CB0->CB0_LOCAL
								CBG_END   := CB0->CB0_LOCALI
								CBG_QTDE  := 1
								CBG_OBS   := "M460FIM-Material enviado ao Cliente(Faturamento)"
								CBG_NOTAS := SF2->F2_DOC
								CBG_SERIES:= SF2->F2_SERIE
								CBG_CLI   := SF2->F2_CLIENTE
								CBG_LOJCLI:= SF2->F2_LOJA
								CBG_ORDSEP:= CB9->CB9_ORDSEP
								CBG_CODETI:= CB9->CB9_CODETI
								MsUnlock()
								
							EndIf
							
						EndIf
						
						DbSelectArea("CB9")
						DbSkip()
						
					EndDo
					
				EndIf
				
				DbSelectArea("SC9")
				SC9->(DbSkip())
				
			Enddo
			
		Endif
		
		DbSelectArea("SD2")
		SD2->(DbSkip())
		
	EndDo
	
EndIf


// Somente quando a NF for para uma FILIAL MULTI-TEK
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+_cCliente+_cLoja)
	If !Empty(SA1->A1_X_ALMOX)
		
		//
		// Analiza o Metodo que que a filial que ira receber a transferencia trabalha.
		//
		
		DbSelectArea("SX6")
		DbSetORder(1)
		If Dbseek(SA1->A1_X_ALMOX+"MV_MODFIL")
			cMetodo :=  alltrim(SX6->X6_CONTEUDO)   // Opcao 01 - HandHeld On-Line
			// Opcao 02 - HandHeld nao utilizanda HandHeld.
			// Opcao 03 - HandHeld Off-Line
		Else
			Aviso("ATENCAO", "Parametro MV_MODFIL nao cadastrado para a FILIAL DESTINO :"+SA1->A1_X_ALMOX)
		Endif
		
		If cMetodo = "03"                            // Motodo 3 - HandOff-Line
			
			if _lEnvio                                //             Envio para OUTRAS Filial  COM CONTROLE DE ETIQUETA / _LENVIO tes deve atualizar estoque.
				//U_MtkOff02()                           //
			Else                                      //             Nao envia para a Filial devido Tes nao atualizar estoque
				Aviso("ATENCAO", "FILIAL NAO FOI ATUALIZADA."+chr(13)+"Devido toda a movimentacao de envio de materiais para as filiais requer que o TES atualize o Estoque",{"&Ok"})
			Endif
			
			
		ElseIf cMetodo = "02"                        // Motodo 2 - Nao utiliza etiquetas nenhum tipo de etiqueta
			
			if  _lEnvio                                //             Envio para OUTRAS Filial  COM CONTROLE DE ETIQUETA / _LENVIO tes deve atualizar estoque.
			    //U_MTKENTRADA()                        //            desta forma o usuario a filial deve digitar a nota de entrada
			Else                                      //             Nao envia para a Filial devido Tes nao atualizar estoque
				Aviso("ATENCAO", "FILIAL NAO FOI ATUALIZADA."+chr(13)+"Devido toda a movimentacao de envio de materiais para as filiais requer que o TES atualize o Estoque",{"&Ok"})
			Endif
			
			//            Este metodo nao esta gerando nenhum tipo de entrada na filial
			//            exemplo  FILIAL ESPIRITO SANTO e COSIPA.
			//            Mas a pre-nota entra com status conferida pois nao trabalha com handheld
			//            aguardando apenas a classificacao com a nota fiscal em maos.
			
			
		ElseIf cMetodo = "01"                        // Motodo 1 - Gera CB0  nas Filiais pois a Filial trabalha Hand On_Line
			
			//            Ate o momento nao existem filiais trabalhando com com Hand On_Line
			//            somente a matriz desta forma nao foi dado continuidade no processo
			//            de geracao de etiquetas para as filiais ou ate mesmo envio das
			//            etiquetas da Matriz para a Filial.
			// Nao esta sendo utilizado neste momento
			//U_MtkOff03()
			
		Endif
		
	Endif
EndIf


DbSelectArea("SC9")
Eval(bFiltrabrw)

RestArea(_aAreaC9)
RestArea(_aAreaC6)
RestArea(_aAreaA1)
RestArea(_aAreaF2)
RestArea(_aAreaD2)
RestArea(_aAreaCB9)
RestArea(_aAreaCB0)
RestArea(_aAreaSF4)
RestArea(_aArea)

Return(.T.)




Static function AlmoxFech(cFilAlmox,cNumNF,cSerie,cFornecPad)

Local aAreaDados := GetArea()
Local lAppend    := .T.
Local cArmaFech  := GetMv("MV_ARMFECH")
cSerie           := cSerie+SPACE(3-LEN(cSerie))

If  cFilAlmox $ cArmaFech
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	
	If dbSeek(cFilAlmox+cNumNF+cSerie+cFornecPad)
		
		While !SD1->(EOF()) .and.;
			cFilAlmox+cNumNF+cSerie+cFornecPad = SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A tratariva abaixo ocorre apenas por seguranca.³
			//³Nao indica que o fato ira ocorrer              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SZV")
			dbSetOrder(1) // ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_COD + ZV_ITEM
			If dbSeek(cFilAlmox+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM))
				lAppend := .F.
			Else
				lAppend := .T.
			Endif
			
			Reclock("SZV",lAppend)
			ZV_FILIAL  := SD1->D1_FILIAL
			ZV_DOC     := SD1->D1_DOC
			ZV_SERIE   := SD1->D1_SERIE
			ZV_FORNECE := SD1->D1_FORNECE
			ZV_LOJA    := SD1->D1_LOJA
			ZV_COD     := SD1->D1_COD
			ZV_ITEM    := SD1->D1_ITEM
			ZV_UM      := SD1->D1_UM
			ZV_QUANT   := SD1->D1_QUANT
			ZV_EMISSAO := SD1->D1_EMISSAO
			ZV_DATACUS := SD1->D1_DATACUS
			ZV_QTD_DEV := SD1->D1_QUANT
			ZV_UPEDVEN := SPACE(6)
			ZV_CUSFF1  := SD1->D1_CUSFF1
			ZV_CUSTO   := SD1->D1_CUSTO
			ZV_VUNIT   := SD1->D1_VUNIT
			MsUnlock()
			
			SD1->(DBSKIP())
			
		Enddo
		
	Endif
	
Endif

RestArea(aAreaDados)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKENTRADAºAutor  ³                    º Data ³  15/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este PE efetuara a geracao da NF de Entrada na Filial (depo-º±±
±±º          ³sito fechado) apos a gravacao da NF de Saida de material da º±±
±±º          ³Matriz e tambem atualizara a tabela SZn com dados a serem   º±±
±±º          ³enviados apos a sincronizacao do Handheld 			           º±±
±±º          ³                                            	              º±±
±±ºAlteracao ³Esta rotina trabalha com  Motodo 2 - Nao utiliza etiquetas  º±±
±±º          ³nenhum tipo de etiqueta-  Motodo 3 - HandOff-Line           º±±
±±º          ³                                            	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek (Projeto Handheld)                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTKEntrada()

Local cNumNF 	  := ""  // Nr. da proxima NF (sequencial SXE)
Local cNumSer	  := ""  // Serie da NF
Local aCab		  := {}
Local aLinha	  := {}
Local aItens	  := {}
Local aEtiquetas := {}
Local nItens 	  := 0
Local cFilOrig	  := ""
Local nPosDoc	  := 0
Local cNovoItem  := "00"
Local cFornecPad := ""
Local lConfirmSX8:= .f.
Local _cCFOP     := ""
Local nValUnit   := 0
Local nAliqIcm   := 0
Local nAliqIPI   := 0
Local aArea		  := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSM0	  := SM0->(GetArea())
Local nValMer    := 0
Local cCFO       := ""

Local cMetodo    := ""

PRIVATE lMsErroAuto  := .F.
Private lMsHelpAuto	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a NF esta sendo gerada para um cliente    ³
//³que seja deposito fechado. Caso positivo, sera gerada ³
//³a NF de Entrada nesta filial com as respectivas etiq. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX)
			cFilAlmox := SA1->A1_X_ALMOX
		Else
			RestArea(aArea)
			return
		Endif
	Else
		ConOut("Atencao -  Criar o campo A1_X_ALMOX caracter de dois via Configurador.")
		RestArea(aArea)
		return
	Endif
Endif


cNumNF      := SF2->F2_DOC
cNumSer		:= SF2->F2_SERIE  //  GetMv("MV_SERIPAD",,"UNI")
cFornecPad	:= GetMv("MV_FORNPAD",,"00000101")

dbSelectArea("SA2")
dbSetOrder(1)
If !SA2->(MsSeek(xFilial("SA2")+Substr(cFornecPad,1,6)+Right(cFornecPad,2)))
	Aviso('Atencao','Fornecedor para geracao da Nota Fiscal de Entrada na Filial nao foi encontrado',{'Ok'})
EndIf


//Adiciona no array os dados do cabecalho da NF
AAdd( aCab, { "F1_TIPO"    , "N"  	                  , Nil })	// Tipo da NF   : Obrigatorio
AAdd( aCab, { "F1_FORMUL"  , "N"                 		, Nil })  // Formulario
AAdd( aCab, { "F1_DOC"     , cNumNF						   , Nil })	// Numero da NF : Obrigatorio
AAdd( aCab, { "F1_SERIE"   , cNumSer						, Nil })	// Serie da NF  : Obrigatorio
AAdd( aCab, { "F1_EMISSAO" , dDataBase           		, Nil })	// Emissao da NF        : Obrigatorio
aadd( aCab, { "F1_DESPESA" , 0                       , Nil }) //despesa - teste
AAdd( aCab, { "F1_FORNECE" , Substr(cFornecPad,1,6)	, Nil })	// Codigo do Fornecedor : Obrigatorio
AAdd( aCab, { "F1_LOJA"    , Right(cFornecPad,2)     , Nil })	// Loja do Fornecedor   : Obrigatorio
AAdd( aCab, { "F1_ESPECIE" , "NFE"                    ,Nil })  // Especie
AAdd( aCab, { "F1_COND"    , SF2->F2_COND    	 		,Nil })	// Condicao do Fornecedor
Aadd( aCab, { "F1_VALMERC" , SF2->F2_VALMERC         , NIL } )
Aadd( aCab, { "F1_VALBRUT" , SF2->F2_VALBRUT         , NIL } )
Aadd( aCab, { "F1_BASEICM" , SF2->F2_BASEICM         , NIL } )
Aadd( aCab, { "F1_EST"     , SA2->A2_EST             , NIL } )


//Posiciona nos itens da NF de Saida
DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja)
	
	
	While !Eof() .And. SD2->D2_FILIAL == xFilial("SD2") .And.;
		SD2->D2_DOC == SF2->F2_DOC .And.;
		SD2->D2_SERIE == SF2->F2_SERIE .And.;
		SD2->D2_CLIENTE == SF2->F2_CLIENTE .And.;
		SD2->D2_LOJA == SF2->F2_LOJA
		
		//
		// Definicao do Tes a ser utilizada na Entrada da Filial
		//
		
		//
		// NAO ESTA UTILIZANDO A TES DEVIDO PRE-NOTA FISCAL MATA140
		//
		
		if  cFilAlmox $ "03|10"
			
			If  cFilAlmox = "03"  // Deposito Fechado
				_cTes  :=  IIF(SD2->D2_TES = "516" ,"054" ,"043" )
			Elseif  cFilAlmox $ "10|12"  // ALBRAS - ALUMAR
				_cTes  :=  "084"
			Endif
			
		Else
			
			_cTes  :=  IF(SD2->D2_IPI = 0 ,"053","052")
			
		Endif
		


		
		// Necessario posicionar no Tes para retirar informacoes relativas ao CFO
		SF4->(DBSETORDER(1))
		SF4->(DBSEEK(xFilial("SF4")+_cTes))
		
		_cCFO  :=  IF( D2_EST $ 'SP' , '1' , '2' )  +    SUBSTR(SF4->F4_CF,2,3)
		
		
		// Define Valor Unitario e Aliquota de Icms
		nAliqIcm  := Val(substr(GetMv("MV_EST2ICM"),at(D2_EST,GetMv("MV_EST2ICM"))+2,2))
		nAliqIcm  := IIf(SF4->F4_ICM == "S",nAliqIcm,0)
		// Define Valor Unitario e Aliquota de IPI
		nAliqIPI  := SD2->D2_IPI 
		nAliqIPI  := IIf(SF4->F4_IPI == "S",nAliqIPI,0)
		
		
		aLinha := {}
		                                      
		
		AAdd( aLinha, { "D1_COD"    , SD2->D2_COD                ,Nil } )
		AAdd( aLinha, { "D1_QUANT"  , SD2->D2_QUANT	             ,Nil } )
		AAdd( aLinha, { "D1_VUNIT"  , SD2->D2_TOTAL/SD2->D2_QUANT,Nil })
		AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
		AAdd( aLinha, { "D1_UM"     , SD2->D2_UM 	    	          ,Nil } )
		//AAdd( aLinha, { "D1_TES" 	  , _cTes            			 ,Nil } ) //TES de Entrada
		//AAdd( aLinha, { "D1_CF"     , _cCFO                   	 ,Nil } )
		AAdd( aLinha, { "D1_PICM"   , nAliqIcm                   ,Nil })
		AAdd( aLinha, { "D1_VALDESC", 0                          ,Nil } )
		AAdd( aLinha, { "D1_IPI"    , nAliqIPI       	          ,Nil } )
		AAdd( aLinha, { "D1_LOCAL"  , "01"           	          ,Nil } )
		//AAdd( aLinha, { "D1_VALDESC", 0                         ,Nil } )
		//AAdd( aLinha, { "D1_SEGURO" , 0                         ,NIL })
		//AAdd( aLinha, { "D1_VALFRE" , 0                         ,NIL })
		//AAdd( aLinha, { "D1_DESPESA", 0                         ,NIL })
		AAdd( aLinha, { "AUTDELETA" ,"N"                         ,Nil })
		AAdd( aLinha, { "D1_ICMSRET", 0                          ,Nil } )
		IF nAliqIcm = 0
			AAdd( aLinha, { "D1_BASEICM", 0                       ,Nil } )
		Endif
		AAdd( aItens, aLinha)
		
		
		dbSelectArea("SD2")
		dbSkip()
		
	Enddo
	
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a MATA103 para criar a NF de Entrada  ³
//³ na respectiva filial                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCab) > 0 .And. Len(aItens) > 0
	
	// 1) Define a Filial Correta.
	cFilOrig:= cFilAnt
	cFilAnt := cFilAlmox
	
	
	// 2) Posicina na Empresa Correta
	dbSelectArea("SM0")
	DbgoTOp()
	While !Eof()
		IF SM0->M0_CODIGO == '01' .and. SM0->M0_CODFIL=cFilAnt
			EXIT
		Endif
		SM0->(dbSkip())
	EndDo
	
	
	SD2->(DbSelectArea("SD2"),	DbSetOrder(3),DbSeek(xFilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja))
	SB1->(dbSelectArea("SB1"),	dbSetOrder(1),	DbSeek(xFilial("SB1")+SD2->D2_COD))
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	If !SA2->(MsSeek(xFilial("SA2")+Substr(cFornecPad,1,6)+Right(cFornecPad,2)))
		Aviso('Atencao','Fornecedor para geracao da Nota Fiscal de Entrada na Filial nao foi encontrado',{'Ok'})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Executa a MsExecAuto da NF de Entrada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MATA140(aCab, aItens)
	
	// ESTA SENDO ALTERADO ESTE CAMPO POIS NESTE PROCESSO NAO SERA NECESSARIO A CONFERENCIA DA
	// NOTA FISCAL DE ENTRADA NAO TRABALHA COM HANDHELD
	
	DbSelectArea("SF1")
	DbSetORder(1)
	IF Dbseek(cFilAlmox+  cNumNF + cNumSer  + Substr(cFornecPad,1,6) + Right(cFornecPad,2))
		Reclock("SF1",.F.)
		SF1->F1_STATCON := "1"
		SF1->(MsUnlock())
	Endif
	
	
	//
	// Especifico para tratar o tes 084 "Albras" onde a Base de Icm gerada e igual a 0 mas o livro insiste em gravar
	// base de icms diferente de 0
	// Ainda nao tratei caso Ipi pois nao tivemos necessidade ate o momento.
	//
	DbSelectArea("SF3")
	DbSetORder(4)
	If Dbseek(cFilAlmox+ Substr(cFornecPad,1,6) + Right(cFornecPad,2)+ cNumNF + cNumSer)
		While !SF3->(EOF()) .AND. (cFilAlmox+ Substr(cFornecPad,1,6) + Right(cFornecPad,2)+ cNumNF + cNumSer)  = ;
			SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE)
			
			// Necessario posicionar no Tes para retirar informacoes relativas ao CFO
			SF4->(DBSETORDER(1))
			SF4->(DBSEEK(xFilial("SF4")+_cTes))
			
			if SF4->F4_ICM == "N"
				Reclock("SF3",.F.)
				SF3->F3_BASEICM := 0
				SF3->(MsUnlock())
			Endif
			
			SF3->(DBSKIP())
			
		Enddo
	Endif
	
	                       
	
	//
	// Alimentara o custo de Entrada no Conta Corrente.
	//
	AlmoxFech(cFilAlmox,cNumNF,cNumSer,cFornecPad)

	
	
	If !lMsErroAuto
		
		Alert("NF de Entrada incluida com sucesso " + SF1->F1_DOC)
		
	Else
		
		MostraErro()
		
	EndIf
	
Else
	
	Alert("SF2460I: Não foram gerados dados para a NF de Entrada")
	
Endif


//Restaura a variavel da Filial do Sistema e o Ambiente
cFilAnt := cFilOrig

RestArea(aAreaSM0)
RestArea(aAreaSA2)
RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKOFF02  ºAutor  ³Cleber M.           º Data ³  15/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este PE efetuara a geracao da NF de Entrada na Filial (depo-º±±
±±º          ³sito fechado) apos a gravacao da NF de Saida de material da º±±
±±º          ³Matriz e tambem atualizara a tabela SZn com dados a serem   º±±
±±º          ³enviados apos a sincronizacao do Handheld 			           º±±
±±º          ³                                            	              º±±
±±ºAlteracao ³Esta rotina trabalha com  -  Motodo 3 - HandOff-Line        º±±
±±º          ³                                            	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek (Projeto Handheld)                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MtkOff02()

Local cNumNF 	  := ""  // Nr. da proxima NF (sequencial SXE)
Local cNumSer	  := ""  // Serie da NF
Local aCab		  := {}
Local aLinha	  := {}
Local aItens	  := {}
Local aEtiquetas := {}
Local nItens 	  := 0
Local cFilOrig	  := ""
Local nPosDoc	  := 0
Local cNovoItem  := "00"
Local cFornecPad := ""
Local lConfirmSX8:= .f.
Local _cCFOP     := ""
Local nValUnit   := 0
Local nAliqIcm   := 0
Local nAliqIPI   := 0
Local aArea		  := GetArea()
Local aAreaSA2   := SA2->(GetArea())
Local aAreaSM0	  := SM0->(GetArea())
Local nValMer    := 0
Local cCFO       := ""
Local nCusto     := 0
Local cMetodo    := ""

PRIVATE lMsErroAuto  := .F.
Private lMsHelpAuto	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a NF esta sendo gerada para um cliente    ³
//³que seja deposito fechado. Caso positivo, sera gerada ³
//³a NF de Entrada nesta filial com as respectivas etiq. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX)
			cFilAlmox := SA1->A1_X_ALMOX
		Else
			RestArea(aArea)
			return
		Endif
	Else
		ConOut("Atenção: Criar o campo A1_X_ALMOX (C,2) via Configurador.")
		RestArea(aArea)
		return
	Endif
Endif


cNumNF      := SF2->F2_DOC
cNumSer		:= SF2->F2_SERIE  //  GetMv("MV_SERIPAD",,"UNI")
cFornecPad	:= GetMv("MV_FORNPAD",,"00000101")




//dbSelectArea("SA2")
//dbSetOrder(1)
//If !SA2->(MsSeek(xFilial("SA2")+Substr(cFornecPad,1,6)+Right(cFornecPad,2)))
//	Aviso('Atencao','Fornecedor para geracao da Nota Fiscal de Entrada na Filial nao foi encontrado',{'Ok'})
//EndIf


//Adiciona no array os dados do cabecalho da NF
AAdd( aCab, { "F1_TIPO"    , "N"  	                  , Nil } )	// Tipo da NF   : Obrigatorio
AAdd( aCab, { "F1_FORMUL"  , "N"                 		, Nil } )  // Formulario
AAdd( aCab, { "F1_DOC"     , cNumNF					     	, Nil } )	// Numero da NF : Obrigatorio
AAdd( aCab, { "F1_SERIE"   , cNumSer						, Nil } )	// Serie da NF  : Obrigatorio
AAdd( aCab, { "F1_EMISSAO" , dDataBase           		, Nil } )	// Emissao da NF        : Obrigatorio
aadd( aCab, { "F1_DESPESA" , 0                       , Nil } ) //despesa - teste
AAdd( aCab, { "F1_FORNECE" , Substr(cFornecPad,1,6)	, Nil } )	// Codigo do Fornecedor : Obrigatorio
AAdd( aCab, { "F1_LOJA"    , Right(cFornecPad,2)     , Nil } )	// Loja do Fornecedor   : Obrigatorio
AAdd( aCab, { "F1_ESPECIE" , "NFE"                   , Nil } )  // Especie
AAdd( aCab, { "F1_COND"    , SF2->F2_COND    	  		, Nil } )	// Condicao do Fornecedor
Aadd( aCab, { "F1_VALMERC" , SF2->F2_VALMERC         , NIL } )
Aadd( aCab, { "F1_VALBRUT" , SF2->F2_VALBRUT         , NIL } )
Aadd( aCab, { "F1_BASEICM" , SF2->F2_BASEICM         , NIL } )
//Aadd( aCab, { "F1_EST"     , SA2->A2_EST             , NIL } )


//Posiciona nos itens da NF de Saida
DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+_cNota+_cSerie+_cCliente+_cLoja)
	
	
	While !Eof() .And. SD2->D2_FILIAL == xFilial("SD2") .And.;
		SD2->D2_DOC == SF2->F2_DOC .And.;
		SD2->D2_SERIE == SF2->F2_SERIE .And.;
		SD2->D2_CLIENTE == SF2->F2_CLIENTE .And.;
		SD2->D2_LOJA == SF2->F2_LOJA
		
		//
		// Definicao do Tes a ser utilizada na Entrada da Filial
		//
		if   cFilAlmox $ "03"    // Deposito Fechado
			_cTes  :=  "054"
		Elseif  cFilAlmox $ "10|12"  // ALBRAS / ALUMAR
			_cTes  :=  "084"
		Else
			_cTes  :=  IF(SD2->D2_IPI = 0 ,"053","052")
		Endif
		
		
		// Necessario posicionar no Tes para retirar informacoes relativas ao CFO
		SF4->(DBSETORDER(1))
		SF4->(DBSEEK(xFilial("SF4")+_cTes))
		
		_cCFO  :=  IF( D2_EST $ 'SP' , '1' , '2' )  +    SUBSTR(SF4->F4_CF,2,3)
		
		
		// Define Valor Unitario e Aliquota de Icms
		nAliqIcm  := Val(substr(GetMv("MV_EST2ICM"),at(D2_EST,GetMv("MV_EST2ICM"))+2,2))
		nAliqIcm  := IIf(SF4->F4_ICM == "S",nAliqIcm,0)
		// Define Valor Unitario e Aliquota de IPI
		nAliqIPI  := SD2->D2_IPI
		nAliqIPI  := IIf(SF4->F4_IPI == "S",nAliqIPI,0)
		
		
		aLinha := {}
		
		AAdd( aLinha, { "D1_COD"    , SD2->D2_COD                , Nil } )
		AAdd( aLinha, { "D1_QUANT"  , SD2->D2_QUANT	             , Nil } )
		AAdd( aLinha, { "D1_VUNIT"  , SD2->D2_TOTAL/SD2->D2_QUANT, Nil })
		AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
		AAdd( aLinha, { "D1_VALIPI" , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL") * (nAliqIPI/100),Nil } )
		AAdd( aLinha, { "D1_TES" 	  , _cTes    			 , Nil } ) //TES de Entrada
		AAdd( aLinha, { "D1_CF"     , _cCFO          	 , Nil } )
		AAdd( aLinha, { "D1_UM"     , SD2->D2_UM 	    	 , Nil } )
		AAdd( aLinha, { "D1_LOCAL"  , "01"           	 , Nil } )
		AAdd( aLinha, { "D1_IPI"    , nAliqIPI       	 , Nil } )
		AAdd( aLinha, { "D1_PICM"   , nAliqIcm           , Nil })
		AAdd( aLinha, { "D1_VALDESC", 0                  ,Nil } )
		//AAdd( aLinha, { "D1_VALDESC", 0                 ,Nil } )
		//AAdd( aLinha, { "D1_SEGURO" , 0                 , NIL })
		//AAdd( aLinha, { "D1_VALFRE" , 0                 , NIL })
		//AAdd( aLinha, { "D1_DESPESA", 0                 , NIL })
		AAdd( aLinha, { "AUTDELETA" ,"N"                 , Nil })
		AAdd( aLinha, { "D1_ICMSRET", 0                  , Nil } )
		IF nAliqIcm = 0
			AAdd( aLinha, { "D1_BASEICM", 0                , Nil } )
		Endif
		
		
		//IF nAliqIPI = 0
		//   AAdd( aLinha, { "D1_BASEIPI", 0                , Nil } )
		//Endif
		
		
		/* FUNCIONOU
		AAdd( aLinha, { "D1_COD"    , SD2->D2_COD    , Nil } )
		AAdd( aLinha, { "D1_QUANT"  , SD2->D2_QUANT	  , Nil } )
		AAdd( aLinha, { "D1_VUNIT"  , (SD2->D2_TOTAL+SD2->D2_DESCON+SD2->D2_DESCZFR)/SD2->D2_QUANT, Nil })
		
		AAdd( aLinha, { "D1_TOTAL"  , A410Arred(aLinha[2][2]*aLinha[3][2],"D1_TOTAL"),Nil } )
		AAdd( aLinha, { "D1_VALDESC"  , A410Arred(SD2->D2_DESCON/SD2->D2_QUANT*aLinha[2][2],"D1_VALDESC"),Nil } )
		
		AAdd( aLinha, { "D1_IPI"    , SD2->D2_IPI    	, Nil } )
		AAdd( aLinha, { "D1_LOCAL"  , SD2->D2_LOCAL  	, Nil } )
		AAdd( aLinha, { "D1_TES" 	  , _cTes    			, Nil } ) //TES de Entrada
		AAdd( aLinha, { "D1_UM"     , SD2->D2_UM 		, Nil } )
		//If Rastro(SD2->D2_COD)
		//	AAdd( aLinha, { "D1_LOTECTL", "", ".T." } )
		//	AAdd( aLinha, { "D1_NUMLOTE", "", ".T." } )
		//	AAdd( aLinha, { "D1_DTVALID", dDataBase , ".T." } )
		//	AAdd( aLinha, { "D1_POTENCI", 0    , ".T." } )
		//EndIf
		AAdd( aLinha, { "D1_NFORI"  , ""     , Nil } )
		AAdd( aLinha, { "D1_SERIORI", ""     , Nil } )
		AAdd( aLinha, { "D1_ITEMORI", ""     , Nil } )
		AAdd( aLinha, { "D1_ICMSRET", 0      , Nil } )
		*/
		
		AAdd( aItens, aLinha)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca as etiquetas no CB0   	  	   ³
		//³ referentes a este item da NF de Saida  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CB0")
		dbSetOrder(9)
		//Pesquisa usando o indice por NF Saida+SerieNF+Produto
		IF DbSeek(xFilial("CB0") + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_COD)
			
			While !CB0->(Eof()) .And. CB0->CB0_FILIAL == xFilial("CB0") .AND. ;
				SD2->D2_DOC == CB0->CB0_NFSAI .AND. SD2->D2_SERIE == CB0->CB0_SERIES ;
				.AND. SD2->D2_COD == CB0->CB0_CODPRO
				
				If CB0->CB0_CODPRO == SD2->D2_COD
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Estrutura do array aEtiquetas³
					//³ 1 - Cod. Etiqueta            ³
					//³ 2 - NF Saida                 ³
					//³ 3 - Serie NF                 ³
					//³ 4 - Cod. Prod.               ³
					//³ 5 - Qtde                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aAdd(aEtiquetas, {CB0->CB0_CODETI ,CB0->CB0_NFSAI,CB0->CB0_SERIES,;
					CB0->CB0_CODPRO,CB0->CB0_QTDE} )
					
					nItens++
				Endif
				CB0->(dbSkip())
				
			Enddo
			
		Endif
		
		dbSelectArea("SD2")
		dbSkip()
	Enddo
	
Endif



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a MATA103 para criar a NF de Entrada  ³
//³ na respectiva filial                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCab) > 0 .And. Len(aItens) > 0
	
	// 1) Define a Filial Correta.
	cFilOrig:= cFilAnt
	cFilAnt := cFilAlmox
	
	
	// 2) Posicina na Empresa Correta
	dbSelectArea("SM0")
	DbgoTOp()
	While !Eof()
		IF SM0->M0_CODIGO == '01' .and. SM0->M0_CODFIL=cFilAnt
			EXIT
		Endif
		SM0->(dbSkip())
	EndDo
	
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	If !SA2->(MsSeek(xFilial("SA2")+Substr(cFornecPad,1,6)+Right(cFornecPad,2)))
		Aviso('Atencao','Fornecedor para geracao da Nota Fiscal de Entrada na Filial nao foi encontrado',{'Ok'})
	EndIf
	//
	// Adiciona no Cabecalho o Estado do Fornecedor para a nota de Entrada
	//
	Aadd( aCab, { "F1_EST"     , SA2->A2_EST             , NIL } )
	
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	If !SF4->(MsSeek(xFilial("SF4")+_cTes))
		Aviso('Atencao','Cadastrar a TES '+_cTes,{'Ok'})
	EndIf
	
	dbSelectArea("SE4")
	dbSetOrder(1)
	If !SE4->(MsSeek(xFilial("SE4")+SF2->F2_COND))
		Aviso('Atencao','Cadastrar a Condicao de Pagamento '+SF2->F2_COND,{'Ok'})
	EndIf
	
	
	dbSelectArea("SF1")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Executa a MsExecAuto da NF de Entrada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MATA103(aCab, aItens)
	
	
	//
	// Especifico para tratar o tes 084 "Albras" onde a Base de Icm gerada e igual a 0 mas o livro insiste em gravar
	// base de icms diferente de 0
	// Ainda nao tratei caso Ipi pois nao tivemos necessidade ate o momento.
	//
	DbSelectArea("SF3")
	DbSetORder(4)
	If Dbseek(cFilAlmox+ Substr(cFornecPad,1,6) + Right(cFornecPad,2)+ cNumNF + cNumSer)
		While !SF3->(EOF()) .AND. (cFilAlmox+ Substr(cFornecPad,1,6) + Right(cFornecPad,2)+ cNumNF + cNumSer)  = ;
			SF3->(F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE)
			
			// Necessario posicionar no Tes para retirar informacoes relativas ao CFO
			SF4->(DBSETORDER(1))
			SF4->(DBSEEK(xFilial("SF4")+_cTes))
			
			If SF4->F4_ICM == "N"
				Reclock("SF3",.F.)
				SF3->F3_BASEICM := 0
				SF3->(MsUnlock())
			Endif
			
			SF3->(DBSKIP())
			
		Enddo
	Endif
	
	//
	// O sigaAuto nao esta alimentando o campo D1_CUSTO CORRETAMENTE foram efetuados varios
	// testes mas nao consegui indentificar o motivo tomei como decisao apos o mata103
	// efetuar o recalculo do Custo de Entrada da Mercadoria.
	//
	// Estou recalculando atraves de rotina da microsiga MATA190 gera GERACUSTO NOVAMENTE
	//
	DbSelectArea("SF1")
	DbSetORder(1)
	IF Dbseek(cFilAlmox+  cNumNF + cNumSer + Substr(cFornecPad,1,6) + Right(cFornecPad,2))
		CRecalc()
	Endif
	
	/*
	DbSelectArea("SD1")
	DbSetORder(1)
	If Dbseek(cFilAlmox+  cNumNF + cNumSer + Substr(cFornecPad,1,6) + Right(cFornecPad,2))
	While !SD1->(EOF()) .AND. (cFilAlmox+  cNumNF + cNumSer + Substr(cFornecPad,1,6) + Right(cFornecPad,2)) = ;
	SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
	
	// Necessario posicionar no Tes para retirar informacoes relativas ao CFO
	SF4->(DBSETORDER(1))
	SF4->(DBSEEK(xFilial("SF4")+SD1->D1_TES))
	
	nCusto := SD1->D1_TOTAL  +  SD1->D1_VALICM  +  SD1->D1_VALIPI
	nCusto := If (SF4->F4_CREDICM = "S", nCusto - SD1->D1_VALICM , nCusto )
	nCusto := If (SF4->F4_CREDIPI = "S", nCusto - SD1->D1_VALIPI , nCusto )
	
	Reclock("SD1",.F.)
	SD1->D1_CUSTO := nCusto
	MsUnlock()
	
	SD1->(DBSKIP())
	
	Enddo
	Endif
	*/
	
	If !lMsErroAuto
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravar os dados da NF e das etiquetas nas tabelas SZ³
		//³	Usar o array aEtiquetas 							³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IF LEN(aEtiquetas) > 0
			
			dbSelectArea("Z20")
			dbSetOrder(1)
			If !MsSeek( xFilial("Z20") + SF1->F1_DOC + SF1->F1_SERIE )
				
				
				RecLock("Z20",.T.)
				Z20->Z20_FILIAL		:= xFilial("Z20")
				Z20->Z20_DOC   		:= SF1->F1_DOC
				Z20->Z20_SERIE		:= SF1->F1_SERIE
				Z20->Z20_EMISSA		:= SF1->F1_EMISSAO
				Z20->Z20_FORNEC 	:= SF1->F1_FORNECE
				Z20->Z20_LOJA		:= SF1->F1_LOJA
				Z20->Z20_QTDIT		:= nItens
				Z20->Z20_STATUS		:= "A"
				
				For nI:=1 to Len(aEtiquetas)
					
					cNovoItem := SomaIt(cNovoItem)
					SB1->(dbSetOrder(1))
					SB1->( MsSeek(xFilial("SB1")+aEtiquetas[nI][4]) )
					
					SB5->(dbSetOrder(1))
					SB5->( MsSeek(xFilial("SB5")+aEtiquetas[nI][4]) )
					
					dbSelectArea("Z21")
					RecLock("Z21",.T.)
					Z21->Z21_FILIAL	:= xFilial("Z21")
					Z21->Z21_ITEM	   := cNovoItem
					Z21->Z21_ETIQ	   := aEtiquetas[nI][1]
					Z21->Z21_CODPRO	:= aEtiquetas[nI][4]
					Z21->Z21_DESCRI	:= SB1->B1_DESC
					Z21->Z21_QTDE	   := aEtiquetas[nI][5]
					Z21->Z21_DOC	   := Z20->Z20_DOC
					Z21->Z21_SERIE	   := Z20->Z20_SERIE
					//Indicador granel (B5_TIPUNIT 0=Nao;1=Sim)
					Z21->Z21_GRANEL	:= IIf(SB5->B5_TIPUNIT=="0", "S", "N")
					Z21->Z21_STATUS	:= "A"
					Z21->(MsUnLock())
					
				Next
				
				Z20->(MsUnLock())
				
			Endif
			
		Endif
		
		// Controla o Saldo
		AlmoxFech(cFilAlmox,cNumNF,cNumSer,cFornecPad)
		
		Alert("NF de Entrada incluida com sucesso " + SF1->F1_DOC)
		
	Else
		
		MostraErro()
		
	EndIf
	
Else
	
	Alert("SF2460I: Não foram gerados dados para a NF de Entrada")
	
Endif


//Restaura a variavel da Filial do Sistema e o Ambiente
cFilAnt := cFilOrig

RestArea(aAreaSM0)
RestArea(aAreaSA2)
RestArea(aArea)

Return





Static function AlmoxFech2(cFilAlmox,cNumNF,cSerie,cFornecPad)

Local aAreaDados := GetArea()
Local lAppend    := .T.
Local cArmaFech  := GetMv("MV_ARMFECH")
cSerie           := cSerie+SPACE(3-LEN(cSerie))

If  cFilAlmox $ cArmaFech
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	
	If dbSeek(cFilAlmox+cNumNF+cSerie+cFornecPad)
		
		While !SD1->(EOF()) .and.;
			cFilAlmox+cNumNF+cSerie+cFornecPad = SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³A tratariva abaixo ocorre apenas por seguranca.³
			//³Nao indica que o fato ira ocorrer              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SZV")
			dbSetOrder(1) // ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_COD + ZV_ITEM
			If dbSeek(cFilAlmox+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM))
				lAppend := .F.
			Else
				lAppend := .T.
			Endif
			
			Reclock("SZV",lAppend)
			ZV_FILIAL  := SD1->D1_FILIAL
			ZV_DOC     := SD1->D1_DOC
			ZV_SERIE   := SD1->D1_SERIE
			ZV_FORNECE := SD1->D1_FORNECE
			ZV_LOJA    := SD1->D1_LOJA
			ZV_COD     := SD1->D1_COD
			ZV_ITEM    := SD1->D1_ITEM
			ZV_UM      := SD1->D1_UM
			ZV_QUANT   := SD1->D1_QUANT
			ZV_EMISSAO := SD1->D1_EMISSAO
			ZV_DATACUS := SD1->D1_DATACUS
			ZV_QTD_DEV := SD1->D1_QUANT
			ZV_UPEDVEN := SPACE(6)
			ZV_CUSFF1  := SD1->D1_CUSFF1
			ZV_CUSTO   := SD1->D1_CUSTO
			ZV_VUNIT   := SD1->D1_VUNIT
			MsUnlock()
			
			SD1->(DBSKIP())
			
		Enddo
		
	Endif
	
Endif

RestArea(aAreaDados)

Return




//
// A ROTINA MATA103.PRX NAO ESTA CALCULANDO CORRETAMENTE O CUSTO MEDIO DESTA FORMA FOMOS OBRIGADO
// A FORCAR NOVAMENTE O CALCULO.
//



Static Function CRecalc()
LOCAL lIntegratms:=IntTMS()
LOCAL cSeek,nReg,i
LOCAL aCustoEnt:={},lEofSD3,dDtMAx := GETMV("MV_ULMES"),aCM:={}

LOCAL cChaveAnt  := ""	// Chave da NF original da Desp.Importacao
LOCAL cSeekD7    := ""
LOCAL aCustoComp[05],aValDesp[05],aCusto:={}		// Arrays utilizados p/guardar custos
LOCAL nItems	 := 0
LOCAL nTotCompra := 0
LOCAL nValCompra := 0
LOCAL nFator	 := 0
LOCAL aSavD1     := Array(2)		// Salva estado do SD1
Local aCustoCM   := Array(5)
Local aArea

Local aAreaSD1   := {}
Local aAreaSD3   := {}
Local aTotCompra := {0,0,0,0,0}
Local aCustoOri  := {0,0,0,0,0}
Local aCustoSD3  := {0,0,0,0,0}
Local lGravaDif  := .F.
Local aDecCusD3  := {TamSX3('D3_CUSTO1')[2], TamSX3('D3_CUSTO2')[2], TamSX3('D3_CUSTO3')[2], TamSX3('D3_CUSTO4')[2], TamSX3('D3_CUSTO5')[2]}
Local cNumCQ     := ''
Local cProduto   := ''
Local cNFAtu     := ''
Local cNFOri     := ''
Local cSerOri    := ''
Local cSerAtu    := ''
Local cFornece   := ''
Local cLoja      := ''
Local cNumSeqSD1 := ''
Local cNumSeqSD3 := ''
Local cSeekAgreg := ''
Local nItens     := 0
Local nQtdMovCQ  := 0
Local nTargRec   := 0
Local nQuantOri  := 0
Local lMta190D1  := Existblock("MTA190D1")
Local aCustoNew
Local nX, nZ
Local lCustPad   := .T.
Local cLibera    := " "
Local aRelImp    := MaFisRelImp("MT100",{ "SD1" })

//dbSelectArea("SD1")
//dbSetOrder(1)

dbSelectArea("SF1")
cSeek := xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

dbSelectArea("SD1")
dbSetOrder(1)
dbSeek(cSeek)
nReg:=Recno()

PRIVATE LBAT:=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o arquivo de TES ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF4->(dbSelectArea("SF4"))
SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))


If SF1->F1_IMPORT <> "S"
	
	If !Empty(nReg)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Nao considerar o custo de uma entrada por devolucao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Sergio Fuzinaka - 10.06.02 ÄÙ
		If SD1->D1_TIPO == "D" .And. SF4->F4_DEVZERO == "2"
			aCustoEnt := {{0,0,0,0,0}}
		Else
			aCustoEnt := GeraCusto(cSeek,aRelImp)
		Endif
		
		
		dbSelectArea("SD1")
		dbGoTo(nReg)
		For i:=1 To Len(aCustoEnt)
			RecLock("SD1",.F.)
			SD1->D1_CUSTO  := aCustoEnt[i][1]
			SD1->D1_CUSTO2 := aCustoEnt[i][2]
			SD1->D1_CUSTO3 := aCustoEnt[i][3]
			SD1->D1_CUSTO4 := aCustoEnt[i][4]
			SD1->D1_CUSTO5 := aCustoEnt[i][5]
			MsUnlock()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava Custo Vinculado a Nota Fiscal na RE5 (Custo direto na Op)³
			//³ Procura RE5 Vinculado a Nota Fiscal (Custo direto na Op)       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SD3")
			dbSetOrder(4)
			dbSeek(xFilial()+SD1->D1_NUMSEQ)
			While !Eof() .And. SD3->D3_CF # "RE5" .And. SD3->D3_NUMSEQ == SD1->D1_NUMSEQ .And. SD3->D3_COD != SD1->D1_COD .And. SD3->D3_OP != SD1->D1_OP
				dbSkip()
			End
			
			lEofSD3 := IIF(SD1->D1_OP # SD3->D3_OP .Or. SD1->D1_NUMSEQ # SD3->D3_NUMSEQ .Or. SD3->(EOF()),.T.,.F.)
			If !lEofSD3
				RecLock("SD3",.F.)
				SD3->D3_CUSTO1 := aCustoEnt[i][1]
				SD3->D3_CUSTO2 := aCustoEnt[i][2]
				SD3->D3_CUSTO3 := aCustoEnt[i][3]
				SD3->D3_CUSTO4 := aCustoEnt[i][4]
				SD3->D3_CUSTO5 := aCustoEnt[i][5]
				MsUnlock()
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Custeio de NF de Controle de Qualidade - CQ.                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SD1->D1_NUMCQ)
				cSeekD7:=SD1->D1_NUMCQ+SD1->D1_COD+SD1->D1_LOCAL
				
				If !(SD1->D1_TIPO=='C') .And. QtdComp(SD1->D1_QUANT)>QtdComp(0)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nota fiscal de entrada.          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aCM := PegaCMD1()
					
					dbSelectArea("SD7")
					dbSetOrder(1)
					dbSeek(xFilial()+cSeekD7,.F.)
					While !Eof() .And. xFilial()+cSeekD7==D7_FILIAL+D7_NUMERO+D7_PRODUTO+D7_LOCAL
						If D7_TIPO != 0
							dbSelectArea("SD3")
							dbSetOrder(2)
							dbSeek(xFilial()+SD7->D7_NUMERO+SD7->D7_PRODUTO)
							While !Eof() .And. xFilial()+SD7->D7_NUMERO+SD7->D7_PRODUTO == ;
								D3_FILIAL+D3_DOC+D3_COD
								If (D3_NUMSEQ == SD7->D7_NUMSEQ) .And. QtdComp(SD3->D3_QUANT) # QtdComp(0)
									RecLock("SD3",.F.)
									SD3->D3_CUSTO1 := aCM[1] * SD3->D3_QUANT
									SD3->D3_CUSTO2 := aCM[2] * SD3->D3_QUANT
									SD3->D3_CUSTO3 := aCM[3] * SD3->D3_QUANT
									SD3->D3_CUSTO4 := aCM[4] * SD3->D3_QUANT
									SD3->D3_CUSTO5 := aCM[5] * SD3->D3_QUANT
									MsUnLock()
								EndIf
								dbSkip()
							End
						EndIf
						
						dbSelectArea("SD7")
						dbSkip()
					EndDo
					
				ElseIf SD1->D1_TIPO=='C' .And. QtdComp(SD1->D1_QUANT)==QtdComp(0)
					aAreaSD1   := SD1->(GetArea())
					aAreaSD3   := {}
					aCusto     := {0,0,0,0,0}
					aCustoOri  := {0,0,0,0,0}
					aValDesp   := {0,0,0,0,0}
					aTotCompra := {0,0,0,0,0}
					cNumCQ     := SD1->D1_NUMCQ
					cProduto   := SD1->D1_COD
					cNFAtu     := SD1->D1_DOC
					cNFOri     := SD1->D1_NFORI
					cSerOri    := SD1->D1_SERIORI
					cSerAtu    := SD1->D1_SERIE
					cFornece   := SD1->D1_FORNECE
					cLoja      := SD1->D1_LOJA
					cNumSeqSD1 := SD1->D1_NUMSEQ
					cNumSeqSD3 := ''
					cSeekAgreg := ''
					nQtdMovCQ  := 0
					nQuantOri  := 0
					
					//-- Obtem Dados da Movimenta‡Æo Original no CQ
					SD7->(dbSetOrder(1))
					If SD7->(dbSeek(xFilial('SD7')+cNumCQ+cProduto+GetMV('MV_CQ')+'001', .F.))
						If Empty(cNFOri+cSerOri)
							cNFOri  := SD7->D7_DOC
							cSerOri := SD7->D7_SERIE
						EndIf
						nQuantOri := SD7->D7_SALDO
						cLibera := SD7->D7_LIBERA
					EndIf
					
					//-- Pega o Custo Total do Produto na NF de Despesa Agregada
					aValDesp   := {0,0,0,0,0}
					dbSelectArea('SD1')
					cSeekAgreg := xFilial('SD1')+cProduto+cNFAtu+cSerAtu+cFornece+cLoja
					dbSetOrder(2)
					If dbSeek(cSeekAgreg, .F.)
						Do While !Eof() .And. cSeekAgreg==D1_FILIAL+D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
							#IFDEF SHELL
								If SD1->D1_CANCEL == "S"
									dbSkip()
									loop
								Endif
							#ENDIF
							If cNumCQ == D1_NUMCQ
								aValDesp[1] += D1_CUSTO
								aValDesp[2] += D1_CUSTO2
								aValDesp[3] += D1_CUSTO3
								aValDesp[4] += D1_CUSTO4
								aValDesp[5] += D1_CUSTO5
							EndIf
							dbSkip()
						EndDo
					EndIf
					
					//-- Pega o Custo Total do Produto na NF de Compra
					aTotCompra := {0,0,0,0,0}
					nItens     := 0
					cSeekAgreg := xFilial('SD1')+cProduto+cNFOri+cSerOri+cFornece+cLoja
					If dbSeek(cSeekAgreg, .F.)
						nTargRec := Recno()
						Do While !Eof() .And. cSeekAgreg == D1_FILIAL+D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
							#IFDEF SHELL
								If SD1->D1_CANCEL == "S"
									dbSkip()
									loop
								Endif
							#ENDIF
							If cNumCQ == D1_NUMCQ
								nItens ++
								aTotCompra[1] += D1_CUSTO
								aTotCompra[2] += D1_CUSTO2
								aTotCompra[3] += D1_CUSTO3
								aTotCompra[4] += D1_CUSTO4
								aTotCompra[5] += D1_CUSTO5
							EndIf
							dbSkip()
						EndDo
					EndIf
					
					//-- Obtem o Custo Individual do Item
					aCusto[1] := aValDesp[1]
					aCusto[2] := aValDesp[2]
					aCusto[3] := aValDesp[3]
					aCusto[4] := aValDesp[4]
					aCusto[5] := aValDesp[5]
					If nItens > 1
						dbGoto(nTargRec)
						Do While !Eof() .And. cSeekAgreg == D1_FILIAL+D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
							#IFDEF SHELL
								If SD1->D1_CANCEL == "S"
									dbSkip()
									loop
								Endif
							#ENDIF
							If cNumCQ == D1_NUMCQ
								aCusto[1] := Round(aValDesp[1]*D1_CUSTO /aTotCompra[1], aDecCusD3[1])
								aCusto[2] := Round(aValDesp[2]*D1_CUSTO2/aTotCompra[2], aDecCusD3[2])
								aCusto[3] := Round(aValDesp[3]*D1_CUSTO3/aTotCompra[3], aDecCusD3[3])
								aCusto[4] := Round(aValDesp[4]*D1_CUSTO4/aTotCompra[4], aDecCusD3[4])
								aCusto[5] := Round(aValDesp[5]*D1_CUSTO5/aTotCompra[5], aDecCusD3[5])
								Exit
							EndIf
							dbSkip()
						EndDo
					EndIf
					RestArea(aAreaSD1)
					
					aCustoOri := aClone(aCusto)
					
					//-- Processa o Arquivo de Movimenta‡äes Internas
					dbSelectArea('SD3')
					dbSetOrder(2)
					If dbSeek(cSeekAgreg:=xFilial('SD3')+cNumCQ+cProduto, .F.)
						cNumSeqSD3 := Replicate('ú', Len(D3_NUMSEQ))
						nQtdMovCQ  := 0
						aCustoSD3  := {0,0,0,0,0}
						Do While !Eof() .And. cSeekAgreg == D3_FILIAL+D3_DOC+D3_COD
							//-- Somente Mov. geradas pela NF de Despesa Agregada
							If cNumSeqSD1==D3_IDENT .And. QtdComp(D3_QUANT)==QtdComp(0) .And. Empty(D3_ESTORNO)
								//-- Pesquisa a Quantidade do Movimento Original
								aAreaSD3   := GetArea()
								If !(D3_NUMSEQ==cNumSeqSD3)
									aAreaSD3   := GetArea()
									cNumSeqSD3 := D3_NUMSEQ
									nQtdMovCQ  := 0
									dbSetOrder(4)
									If dbSeek(xFilial('SD3')+cNumSeqSD3+'E0'+cProduto, .F.)
										Do While !Eof() .And. xFilial('SD3')+cNumSeqSD3+cProduto==D3_FILIAL+D3_NUMSEQ+D3_COD
											If QtdComp(D3_QUANT)>QtdComp(0) .And. Empty(D3_ESTORNO)
												nQtdMovCQ := D3_QUANT
												Exit
											EndIf
											dbSkip()
										EndDo
									EndIf
									RestArea(aAreaSD3)
								EndIf
								If Substr(D3_CF,1,2) == "RE"	.And. cLibera == "S"
									dbSkip(2)
									If cSeekAgreg != D3_FILIAL+D3_DOC+D3_COD
										lGravaDif := .T.
									EndIf
								EndIf
								RestArea(aAreaSD3)
								//-- Obtem o Custo Percentual … Quantidade Total
								If Substr(D3_CF,1,2) == "RE"
									If !lGravaDif
										aCusto[1] := Round(aCustoOri[1]*(nQtdMovCQ/nQuantOri), aDecCusD3[1])
										aCusto[2] := Round(aCustoOri[2]*(nQtdMovCQ/nQuantOri), aDecCusD3[2])
										aCusto[3] := Round(aCustoOri[3]*(nQtdMovCQ/nQuantOri), aDecCusD3[3])
										aCusto[4] := Round(aCustoOri[4]*(nQtdMovCQ/nQuantOri), aDecCusD3[4])
										aCusto[5] := Round(aCustoOri[5]*(nQtdMovCQ/nQuantOri), aDecCusD3[5])
									Else
										// Gravar no Ultimo Apontamento a Diferenca entre o Custo Original e a Somatoria dos Custos Anteriores
										// Isto foi feito por problemas com arredondamento
										aCusto[1] := aCustoOri[1]-aCustoSD3[1]
									EndIf
								EndIf
								GravaCusD3(aCusto,.T.)
								lGravaDif := .F.
								If Substr(D3_CF,1,2) = "RE"
									aCustoSD3[1] += SD3->D3_CUSTO1
									aCustoSD3[2] += SD3->D3_CUSTO2
									aCustoSD3[3] += SD3->D3_CUSTO3
									aCustoSD3[4] += SD3->D3_CUSTO4
									aCustoSD3[5] += SD3->D3_CUSTO5
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				Endif
			Endif
			//-> Inicio Ajuste p/ Atualizacao de Ultima Compra e Ultimo Preco
			If (MV_PAR01 == 1) .And. (SF1->F1_TIPO == "N")
				dbSelectArea("SB1")
				If ((SB1->B1_COD==SD1->D1_COD).Or.dbSeek(xFilial()+SD1->D1_COD,.F.))
					If (SD1->D1_EMISSAO >= SB1->B1_UCOM)
						dbSelectArea("SF4")
						If ((SF4->F4_CODIGO == SD1->D1_TES) .Or. ;
							dbSeek(xFilial()+SD1->D1_TES,.F.))
							If (SF4->F4_UPRC $ "S ")
								RecLock( "SB1",.F. )
								SB1->B1_UCOM := SD1->D1_EMISSAO
								SB1->B1_UPRC := SD1->D1_VUNIT
								#IFDEF SHELL
									SB1->B1_UPRC := SD1->D1_UPRC
								#ENDIF
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			//-> Fim do Ajuste p/ Atualizacao Ultima Compra e Ultimo Preco
			MsUnLockAll()
			
			If IsRemito(1,"SF1->F1_TIPODOC")
				aCusto     := {0,0,0,0,0}
				aCusto[1] := GetCM(SD1->D1_COD,SD1->D1_LOCAL,SD1->D1_EMISSAO,SD1->D1_PEDIDO,SD1->D1_ITEM)
				If SF1->F1_MOEDA > 1
					aCusto[1] := xMoeda(aCusto[1],SF1->F1_MOEDA,1,,msDecimais(SF1->F1_MOEDA)+1,SF1->F1_TXMOEDA)
				EndIf
			ElseIf !Empty(SD1->D1_REMITO)
				aCusto	:=	{SD1->D1_CUSTO/SD1->D1_QUANT,SD1->D1_CUSTO2/SD1->D1_QUANT,SD1->D1_CUSTO3/SD1->D1_QUANT,SD1->D1_CUSTO4/SD1->D1_QUANT,SD1->D1_CUSTO5/SD1->D1_QUANT}
				aAreaI	:=	SD1->(GetArea())
				nQuant	:=	SD1->D1_QUANT
				SD1->(DbSetOrder(1))
				If SD1->(MSSeek(xFilial("SD1")+SD1->D1_REMITO+SD1->D1_SERIREM+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMREM))
					AtuDifCusREM(aCusto,nQuant,1)
				EndIf
				RestArea(aAreaI)
				
			Endif
			dbSelectArea("SD1")
			dbSkip()
		Next
		
	Endif
	
Endif

dbSelectArea("SF1")
RetIndex("SF1")
Set Filter to
dbSetOrder(1)

Return


