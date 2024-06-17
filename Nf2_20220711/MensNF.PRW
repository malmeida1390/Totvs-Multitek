#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"                      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MensNF    ³ Autor ³ Marcelo (Imfoc)       ³ Data ³04.03.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Geracao de Mensagen para a Nota Fiscal Eletronica           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³String da Mensagem                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Tipo da NF                                           ³±±         
±±³          ³       [0] Entrada                                          ³±±
±±³          ³       [1] Saida                                            ³±±
±±³          ³ExpC2: Serie da NF                                          ³±±
±±³          ³ExpC3: Numero da nota fiscal                                ³±±
±±³          ³ExpC4: Codigo do cliente ou fornecedor                      ³±±
±±³          ³ExpC5: Loja do cliente ou fornecedor                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function MensNF()

Local xFLAG_MTK  := .f.
Local aPedido    := {}
Local xMENSAGEM  := ""
Local _xMENS_INI := "" 
Local _xMENS_FIM := "" 
Local xNUM_NFDV  := {}	// NF ORIGINAL
Local xPREF_DV   := {} 	// Serie Original
Local nPos       := 0
Local aMensagem  := {}

Local cVar1	   	 :=""
Local cVar2	   	 :=""
Local cVar3	   	 :=""

Local cTipo      := PARAMIXB[1]
Local cSerie     := PARAMIXB[2]
Local cNota      := PARAMIXB[3]
Local cClieFor   := PARAMIXB[4]
Local cLoja      := PARAMIXB[5]

Local xPedido    := ""
Local xVendedor  := ""
Local _aMPAD     := {}

Local xREC_CLI   := ""
Local xBRE_CLI   := ""
Local xMNE_CLI   := ""
Local xUFE_CLI   := ""

Local cEntrega   := ""
Local cPedido    := ""

Local _cNumDI    := ""

IF  cTipo = "1"
	
	
	IF !(SF2->F2_TIPO $ "B|D")
		
		IF !EMPTY(SA1->A1_X_MPAD1)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD1)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD2)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD2)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD3)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD3)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD4)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD4)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD5)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD5)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD6)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD6)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD7)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD7)))
		ENDIF
		IF !EMPTY(SA1->A1_X_MPAD8)
			AADD(_aMPAD,SA1->(Formula(A1_X_MPAD8)))
		ENDIF
		
	ENDIF
	
	AreaSM4	:= 7 //(Delimita a qde de linhas a serem impressas = cadastro SA1).
	I:=1
	
	
	While AreaSM4 <> 0 .and. Len(_aMPAD) > 0 .AND. I <= Len(_aMPAD)
		
		aadd(aMensagem,_aMPAD[i])
		
		I++                                       
		AreaSM4--
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa itens de nota                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD2")
	dbSetOrder(3)
	#IFDEF TOP
		lQuery  := .T.
		cSD2 := GetNextAlias()
		BeginSql Alias cSD2
			SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
			D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
			D2_CLASFIS,D2_PRCVEN,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_LOTECTL,D2_DTVALID,D2_BRICMS,D2_ICMSRET  //D2_LOTECTL,D2_DTVALID sao adaptacoes POLITEC
			FROM %Table:SD2% SD2
			WHERE
			SD2.D2_FILIAL = %xFilial:SD2% AND
			SD2.D2_SERIE = %Exp:SF2->F2_SERIE% AND
			SD2.D2_DOC = %Exp:SF2->F2_DOC% AND
			SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND
			SD2.D2_LOJA = %Exp:SF2->F2_LOJA% AND
			SD2.%NotDel%
			ORDER BY %Order:SD2%
		EndSql
		
	#ELSE
		MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	#ENDIF
	
	While !(cSD2)->(Eof()) .And. xFilial("SD2") == (cSD2)->D2_FILIAL .And.;
		SF2->F2_SERIE == (cSD2)->D2_SERIE .And.;
		SF2->F2_DOC == (cSD2)->D2_DOC
		
		//
		// Se a nota possuir dois itens do mesmo pedido nao pode repetir a mensagem.
		//
		IF aScan(aPedido, (cSD2)->D2_PEDIDO ) = 0
			
			aadd(aPedido, (cSD2)->D2_PEDIDO)
			
			DbSelectArea("SC5")
			DbSetOrder(1)
			If DbSeek( xFilial("SC5") + (cSD2)->D2_PEDIDO )
				
				xFLAG_MTK	:= IF(!EMPTY(SC5->C5_ESPECI4),.T.,xFLAG_MTK)
				xPedido     := (cSD2)->D2_PEDIDO
				
				DbSelectArea("SCJ")
				DbSetOrder(1)
				If DbSeek(xfilial("SCJ")+SC5->C5_X_NUM)
					
					xFLAG_MTK	:= IF(SCJ->CJ_X_NFTRI	== "S",.T.,xFLAG_MTK)
					xVendedor   := SCJ->CJ_X_VEND1
					cPedido     := SCJ->CJ_COTCLI	// IMPRESSAO DO NUMERO DO PEDIDO DO CLIENTE (SCJ)
					
					
					If !EMPTY(SCJ->CJ_X_ENDEN)
						xREC_CLI :=SUBSTR(SCJ->CJ_X_ENDEN,1,30)        // Endereco de Entrega
						xBRE_CLI :=SCJ->CJ_X_BAREN 	                    // Bairro de Entrega
						xMNE_CLI :=SUBSTR(SCJ->CJ_X_CIDEN,1,20)        // Municipio de Entrega
						xUFE_CLI :=SCJ->CJ_X_UFEN		                // Estado de Entrega
						//			xCPE_CLI :=SA1->A1_CEPE             // CEP de Entrega
					ELSE
						xREC_CLI :=SUBSTR(SA1->A1_ENDENT,1,30)         // Endereco de Entrega
						xBRE_CLI :=SA1->A1_BAIRROE		                // Bairro de Entrega
						xMNE_CLI :=SUBSTR(SA1->A1_MUNE,1,20)		    // Municipio de Entrega
						xUFE_CLI :=SA1->A1_ESTE			                // Estado de Entrega
						//			xCPE_CLI :=SA1->A1_CEPE             // CEP de Entrega
					ENDIF
					
					cEntrega := Alltrim(xREC_CLI)+" - "+Alltrim(xBRE_CLI)+"/"+Alltrim(xMNE_CLI)+" UF:"+Alltrim(xUFE_CLI)
					
				Endif
				
			Endif
			
		Endif
		
		
		DbSelectArea(cSD2)
		(cSD2)->(DbSkip())
		
	EndDo
	
	//If xFlag_MTK    //.and. EMPTY(cVar1) .and. EMPTY(cVar2) .and. EMPTY(cVar3)
	//   U_DLG_01(cTipo)
	//ndIF

	cVar1	   	:=SUBSTR(SF2->F2_LINHA1,1,122)
	cVar2	   	:=SUBSTR(SF2->F2_LINHA2,1,122)
	cVar3	   	:=SUBSTR(SF2->F2_LINHA3,1,122)

	//
	// A mensagem da Colocada no SD2 somente e impressa se flag
	//
	IF Len(cVar1) > 0 .and. xFlag_MTK
		aadd(aMensagem,Alltrim(cVar1)) // Origem Cabecalho da Nota Fiscal quando nf for triangular
	EndIF
	
	IF Len(cVar2) > 0 .and. xFlag_MTK
		aadd(aMensagem,Alltrim(cVar2))
	EndIF
	
	IF Len(cVar3) > 0 .and. xFlag_MTK
		aadd(aMensagem,Alltrim(cVar3))
	EndIF
	
	
	//
	//Mensagens com origem no SC5->C5_MENNOTA mas este campo ja sera adicionado atraves da NfeSefaz
	//
	//If !EMPTY(xMensagem1)
	//	xMENSAGEM:=IIF(Len(xMensagem1)>122,SubStr(xMensagem1,1,122),Alltrim(xMensagem1))
	//	aadd(aMensagem,xMENSAGEM)
	//ELSE
	//	xMENSAGEM:=IIF(Len(xMensagem2)>122,SubStr(xMensagem2,1,122),Alltrim(xMensagem2))
	//	aadd(aMensagem,xMENSAGEM)
	//EndIF
	
	If !(SF2->F2_TIPO $ "B|D")
		xMENSAGEM:="Produto Comercializado de acordo com o CDC - LEI 8078/90 - Art.31."
		aadd(aMensagem,xMENSAGEM)
		xMENSAGEM:="Produto destinado para uso ou aplicacao exclusivamente industrial DECRETO 53040/08 E PROTOCOLO ICMS 49/08."
		aadd(aMensagem,xMENSAGEM)
	Endif
	

ELSE
	
	
	dbSelectArea("SD1")
	dbSetOrder(3)
	
	
	lQuery  := .T.
	cSD1 := GetNextAlias()
	BeginSql Alias cSD1
		SELECT D1_FILIAL,D1_SERIE,D1_DOC,D1_FORNECE,D1_LOJA,D1_COD,D1_TES,D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_TIPO,D1_ITEM,D1_CF,
		D1_QUANT,D1_TOTAL,D1_VALFRE,D1_SEGURO,D1_PEDIDO,D1_ITEMPV,D1_DESPESA,D1_VALISS,
		D1_CLASFIS,D1_CODISS,D1_BRICMS,D1_ICMSRET  //D1_LOTECTL,D1_DTVALID sao adaptacoes POLITEC
		FROM %Table:SD1% SD1
		WHERE
		SD1.D1_FILIAL = %xFilial:SD1% AND
		SD1.D1_SERIE = %Exp:SF1->F1_SERIE% AND
		SD1.D1_DOC = %Exp:SF1->F1_DOC% AND
		SD1.D1_FORNECE = %Exp:SF1->F1_FORNECE% AND
		SD1.D1_LOJA = %Exp:SF1->F1_LOJA% AND
		SD1.%NotDel%
		ORDER BY %Order:SD1%
	EndSql
	
	
	While !(cSD1)->(Eof()) .And. xFilial("SD1") == (cSD1)->D1_FILIAL .And.;
		SF1->F1_SERIE == (cSD1)->D1_SERIE .And.;
		SF1->F1_DOC == (cSD1)->D1_DOC
		
		
		IF SF1->F1_TIPO == "D"
			
			nPos := Ascan(xNUM_NFDV,(cSD1)->D1_NFORI)// {|x| x[1] == SD1->D1_NFORI })
			
			IF nPos == 0
				AADD(xNUM_NFDV ,(cSD1)->D1_NFORI  )		// NF ORIGINAL
				AADD(xPREF_DV  ,(cSD1)->D1_SERIORI)		// Serie Original
			Endif
			
		ENDIF
		
		DbSelectArea(cSD1)
		(cSD1)->(DbSkip())
		
	Enddo
	
	
	IF !EMPTY(SF1->F1_HAWB)// NUMERO DA HAWB
		
		_cNumDI := Getadvfval("SW6","W6_DI_NUM",xFILIAL("SW6")+SF1->F1_HAWB,1," ")

		xMENSAGEM :="DADOS REFERENTES A IMPORTACAO:"  
		aadd(aMensagem,xMENSAGEM)
		
		xMENSAGEM:="NUMERO DO PROCESSO: "+SF1->F1_HAWB
		aadd(aMensagem,xMENSAGEM)
		xMENSAGEM:="NUMERO DA DI: "+Alltrim(_cNumDI)
		aadd(aMensagem,xMENSAGEM)


		If  SF1->F1_TIPO <> "C"
			xMENSAGEM :="VALOR II : " + alltrim(TRANSFORM(SF1->F1_II,"@E 999,999,999.99"))
			aadd(aMensagem,xMENSAGEM)
			xMENSAGEM :="VALOR COFINS: "  + alltrim(TRANSFORM(SF1->F1_VALIMP5,"@E 999,999,999.99")) 
			aadd(aMensagem,xMENSAGEM)
			xMENSAGEM :="VALOR PIS: " + alltrim(TRANSFORM(SF1->F1_VALIMP6,"@E 999,999,999.99")) 
			aadd(aMensagem,xMENSAGEM)
		Else
			xMENSAGEM :="VALOR II : " + alltrim(TRANSFORM(0,"@E 999,999,999.99"))
			aadd(aMensagem,xMENSAGEM)
			xMENSAGEM :="VALOR COFINS: "  + alltrim(TRANSFORM(0,"@E 999,999,999.99")) 
			aadd(aMensagem,xMENSAGEM)
			xMENSAGEM :="VALOR PIS: " + alltrim(TRANSFORM(0,"@E 999,999,999.99")) 
			aadd(aMensagem,xMENSAGEM)
		Endif
		
	ELSEIF SF1->F1_TIPO == "D"
		
		xMENSAGEM:="Nota fiscal de entrada, referente a(S) NFF, de numero e serie, abairo relacionadas: "
		aadd(aMensagem,xMENSAGEM)
		
		If Len(xNum_NFDV) > 8
			_nTamDup := 8
		Else
			_nTamDup := Len(xNum_NFDV)
		EndIf
		
		
		For BB:= 1 to _nTamDup
			
			xMENSAGEM:= xNUM_NFDV[BB]+"/"+xPREF_DV[BB]
			aadd(aMensagem,xMENSAGEM)
			
		Next BB
		
	ENDIF
	
ENDIF

//
// Mensagens Iniciais
//
_xMENS_INI :=""
IF  cTipo = "1"
	_xMENS_INI:="Ped.Cliente: "+cPedido+" "
	_xMENS_INI+="Ped.Interno: "+xPedido+" "
	_xMENS_INI+="VI: "+xVendedor+" "
	_xMENS_INI+="Lc Entrega:"+cEntrega+" "
Else
	_xMENS_INI:=""
Endif         

//
// Mensagens Finais.
//
_xMENS_FIM :=""
For ny:=1 to len(aMensagem)
	_xMENS_FIM +=aMENSAGEM[nY]+";"
Next


Return(_xMENS_INI+_xMENS_FIM)


