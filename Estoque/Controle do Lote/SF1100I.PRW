/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Anderson            º Data ³  24/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para efetuar o enderecamento automatico da º±±
±±º          ³conferencia da Pre-Nota (Utilizado aos a Classif. da NFE)   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I
Local _nTeste    := 0
Local aCb0Recno  := {}
Local nEtiquetas := 0
Local nY         := 0
Local _cEstoque  := ""
Local cChave     := ""

Local nTotImp    := 0
Local _aTit      := {}

Private lMsHelpAuto := .t.
Private lMsErroAuto := .f.

_aArea		:= GetArea()
DbSelectArea("SD1")
_aAreaSD1	:= GetArea()
DbSelectArea("SF1")
_aAreaSF1	:= GetArea()
DbSelectArea("SDA")
_aAreaSDA	:= GetArea()
DbSelectArea("CB0")
_aAreaCB0	:= GetArea()
DbSelectArea("CBE")
_aAreaCBE	:= GetArea()
DbSelectArea("CBG")
_aAreaCBG	:= GetArea()
DbSelectArea("SB1")
_aAreaSB1	:= GetArea()

_cDoc		:= SF1->F1_DOC
_cSerie		:= SF1->F1_SERIE
_cFornece	:= SF1->F1_FORNECE
_cLoja		:= SF1->F1_LOJA
_cTipo      := SF1->F1_TIPO

// So pode ser executado se estivermos na Filial 01 (Matriz)
//If SM0->M0_CODFIL == "01" // Matriz
//If  ("MATA140" $ FunName())    // Somente permite a entrada quando for efetuada pela Pre-Nota.


// na 12.1.25 enderecamento  via acd sosmente por rotina propria do acd
//If Empty(SF1->F1_HAWB)
//	Return
//Endif


IF !("MATA460" $ FunName())
	
	If alltrim(GetMv("MV_MODFIL")) $ "01|03"  // Opcao 01 - HandHeld On-Line
		// Opcao 02 - HandHeld nao utilizanda HandHeld.
		// Opcao 03 - HandHeld Off-Line
		fEntra_Fil()//  Gera Etiqueta + Enderecamento
	Else
		fEntra_NFil()// Somente Enderecamento nao trabalha com hand
	Endif
	
Endif



//
// Sem esta informacao o Peso nao Impresso na NFe.
// Atencao Notas de Importacao sao preenchidas o Volume no programa  MTKACD02.PRW
RestArea(_aAreaSF1)
If  SF1->F1_FORMUL="S" .and. EMPTY(SF1->F1_HAWB)
	Reclock("SF1",.F.)
	SF1->F1_ESPECI1:='VOLUME' 
	MsUnlock()
Endif		

//
//
// TRATAMENTO PARA DEVOLUCOES PETROBRAS - DEVERA GERAR UMA NCC PARA O CLIENTE.
//
If _cTipo = "D"
	
	DbSelectArea("SD1")
	DbSetOrder(1) //Doc,Serie,Fornece,Loja,Cod,Item
	If DbSeek(xFilial("SD1")+_cDoc+_cSerie+_cFornece+_cLoja)
		
		While !Eof() .and. SD1->D1_DOC == _cDoc .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cFornece .and. SD1->D1_LOJA == _cLoja
			
			IF (TRIM(SD1->D1_CF)$"1202/2202/2204" .AND.  SD1->D1_TIPO="D" .AND. SD1->D1_RATEIO<>"1")
				nTotImp += SD1->D1_VALCOF+SD1->D1_VALPIS+SD1->D1_VALCSLL+SD1->D1_VALIRR
			Endif
			
			SD1->(DbSkip())
			
		EndDo
		
	EndIf
	
	If nTotImp <> 0
		
		
		/*
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
		
		_aTit  := { {"E1_FILIAL" ,xFilial("SE1")   ,NIL},;
		{"E1_NUM"    ,_cDoc           ,NIL},;
		{"E1_PREFIXO",_cSerie         ,NIL},;
		{"E1_SERIE"  ,_cSerie         ,NIL},;
		{"E1_PARCELA",'2'             ,NIL},;
		{"E1_TIPO"   ,'NDC'           ,NIL},;
		{"E1_NATUREZ",'01005'         ,NIL},;
		{"E1_CLIENTE",SA1->A1_COD     ,NIL},;
		{"E1_LOJA"   ,SA1->A1_LOJA    ,NIL},;
		{"E1_EMISSAO",dDatabase       ,NIL},;
		{"E1_VENCTO" ,dDatabase       ,NIL},;
		{"E1_VENCREA",dDatabase       ,NIL},;
		{"E1_VALOR"  ,nTotImp         ,NIL},;
		{"E1_HIST"   ,''               ,NIL},;
		{"E1_SITUACA",'1'             ,NIL},;
		{"E1_VALJUR" ,0               ,NIL},;
		{"E1_PORCJUR",0               ,NIL},;
		{"E1_MOEDA"  ,1               ,NIL},;
		{"E1_FLUXO"  ,'S'             ,NIL},;
		{"E1_LA"     ,'S'             ,NIL}}
		
		MSExecAuto({|x, y| FINA040(x, y)}, _aTit, 3 )
		
		If lMsErroAuto
			MostraErro()
		Endif
		*/

        DbSelectArea("SE1")
        DbSetOrder(2)    // E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM 
        IF Dbseek(xFilial("SE1")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC))
           While !SE1->(EOF()) .and. (xFilial("SE1")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)) =;
				 SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) 
				 If SE1->E1_TIPO = 'NCC' 
				    Reclock("SE1",.F.)
				    SE1->E1_DECRESC := nTotImp
				    SE1->E1_SDDECRE := nTotImp
				    MsUnlock() 
				 Endif
				 SE1->(DBSKIP()) 
		   Enddo		             
		Endif

	Endif
	
Endif


//Restaurando Areas
RestArea(_aAreaSB1)
RestArea(_aAreaCBG)
RestArea(_aAreaCBE)
RestArea(_aAreaCB0)
RestArea(_aAreaSF1)
RestArea(_aAreaSD1)
RestArea(_aAreaSDA)
RestArea(_aArea)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEntra_FilºAutor  ³                    º Data ³  24/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Entrada de Materias atraves da Matriz                       º±±
±±º          ³conferencia da Pre-Nota (Utilizado aos a Classif. da NFE)   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fEntra_Fil()
//Salvando areas
Local _nRecnoCB0 := 0

_cDoc		:= SF1->F1_DOC
_cSerie		:= SF1->F1_SERIE
_cFornece	:= SF1->F1_FORNECE
_cLoja		:= SF1->F1_LOJA
_cTipo      := SF1->F1_TIPO



DbSelectArea("SD1")
DbSetOrder(1) //Doc,Serie,Fornece,Loja,Cod,Item
If DbSeek(xFilial("SD1")+_cDoc+_cSerie+_cFornece+_cLoja)
	
	While !Eof() .and. SD1->D1_DOC == _cDoc .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cFornece .and. SD1->D1_LOJA == _cLoja
		
		//
		// Caso a tes utilizada nao atualize o estoque o que ocorre geralmente nos casos:
		// a) complemento de Ipi
		// b) complemento de Icm
		// c) complemento de Preco
		// d) Forncedores de servico PS
		// e) Retorno beneficiamento
		/*
		//_cEstoque:=POSICIONE("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE")
		//If _cEstoque <> "S"
		//Reclock("SF1",.F.)
		//SF1->F1_STATCON:='1' // Nota Fiscal conferida (nao ira aparecer no handHeld para conferencia)
		//MsUnlock()
		//Endif
		*/
		// Relativo ao processo n. 063 foi definido pelo Mauricio que caso nao for encontrado nenhma
		// etiqueta para o item sera dada como deletada.
		
		cChave     := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		DbSelectArea("CB0")
		DbSetorder(6)
		If !Dbseek(xFilial("CB0")+cChave)
			Reclock("SF1",.F.)
			SF1->F1_STATCON:='1' // Nota Fiscal conferida (nao ira aparecer no handHeld para conferencia)
			MsUnlock()
		Endif


		DbSelectArea("SDA")
		DBSetOrder(1)
		If DbSeek(xFilial("SDA")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_NUMSEQ+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			
			_aTEnd		:= TamSx3("DB_LOCALIZ")                      // Tamanho e Tipo de um campo Qualquer de endereco no ERP Protheus
			_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas (Porem NAO o usamos pois pego da NFE, mas consta no parametro)
			_cLocalOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),3,50))
			_nTOK		   := _aTEnd[1] - Len(_cLocalOK)               //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
			_cLocalOK	:= _cLocalOK + Space(_nTOK)
			
			
			//
			//  Atendimento a  Solicitacao de Suporte 064
			//
			//  Onde foi solicitado pelo o usuario a gravacao de um novo almoxarifado para divergencia
			//  quando se tratar de Nota Fiscal de Importacao. Com o objetivo de eliminar a possibilidade
			//  de duplicar compras e otimizar a consulta para area de vendas, por ter duvidas quanto a
			//  disponibilidade dos produtos no almox. de divergencia.
			//
			If Empty(SF1->F1_HAWB)
				_cArmazDV	:= Alltrim(Substr(GETMV("MV_ALMX02"),1,2))  // Armazem Divergente
				_cLocalDV	:= Alltrim(Substr(GETMV("MV_ALMX02"),3,50))
			Else
				_cArmazDV	:= Alltrim(Substr(GETMV("MV_ALMX03"),1,2))  // Armazem Divergente especifico para Produtos Importados.
				_cLocalDV	:= Alltrim(Substr(GETMV("MV_ALMX03"),3,50))
			Endif
			
			_nTDV	    	:= _aTEnd[1] - Len(_cLocalDV) //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
			_cLocalDV	:= _cLocalDV + Space(_nTDV)
			
			// CRIANDO AQUI REGISTRO NO SB2 PARA CADA PRODUTO PROCESSADO (EM AMBOS OS ARMAZENS QUE IREMOS UTILIZAR - PRODUTOS OK E PRODUTOS DIVERGENTES)
			DbSelectArea("SB2")
			//Anderson 21/03/2005
			_aASB2 := GetArea()
			//Fim
			DbSetOrder(1) // Produto + Local
			If !DbSeek(XFilial("SB2")+SD1->D1_COD+_cArmazOK)
				CriaSB2(SD1->D1_COD,_cArmazOK)
			EndIf
			DbSelectArea("SB2")
			DbSetOrder(1) // Produto + Local
			If !DbSeek(XFilial("SB2")+SD1->D1_COD+_cArmazDV)
				CriaSB2(SD1->D1_COD,_cArmazDV)
			EndIf
			// Fim
			
			aCab := {}
			aItem:= {}
			
			aCAB  :={{"DA_PRODUTO",SD1->D1_COD  , nil},;
			{"DA_LOCAL"  ,SD1->D1_LOCAL         , nil},;
			{"DA_NUMSEQ" ,SD1->D1_NUMSEQ        , nil},; //relacionado ao campo D1_NUMSEQ
			{"DA_DOC"    ,SD1->D1_DOC           , nil}} //Relacionado ao campo F1_DOC ou D1_DOC
			
			// Verificando se ha divergencias
			// OK - VERIFICADO - VERIFICAR SE FOR GRANEL, CASO AFIRMATIVO NAO PODERA SER TRATADA A DIVERGENCIA POIS O GRANEL SO POSSUI UMA ETIQUETA COM A SUA QUANTIDADE E NAO PODEMOS SEPARAR AS QUANTIDADE AGORA
			// OK - VERIFICADO - TALVEZ DEVA VERIFICAR NA ROTINA QUE FIZ PARA LIBERAR A CONFERENCIA (LA VERIFICO SE NAO EXISTEM ITENS DIVERGENTES A GRANEL E NAO DEIXO LIBERAR)
			If SD1->D1_QUANT <> SD1->D1_QTDCONF // NAO EXISTEM DIFERENCAS A MAIOR, DEVIDO AS ETIQUETAS SEREM IMPRESSAS CONFERME A QUANTIDADE DA NF, SOMENTE EXISTE A MENOR
				
				_nDif	:= SD1->D1_QUANT - SD1->D1_QTDCONF
				
				If _nDif == SD1->D1_QUANT // Quer dizer que NAO foi conferido (ANOT TEM) nenhum item deste produto
					
					// AVEREGE SEMPRE ENTRA AQUI
					AADD(aItem,{{"DB_ITEM"   ,"0001"         , nil},;
					{"DB_LOCALIZ",_cLocalDV      , nil},;
					{"DB_QUANT"  ,_nDif		     , nil},;
					{"DB_DATA"   ,dDATABASE     , nil}})
					
				Else
					
					AADD(aItem,{{"DB_ITEM"   ,"0001"         , nil},;   //Tem que ser diferente: 002, 003... caso enderecemos o item para mais de um endereco
					{"DB_LOCALIZ",_cLocalOK      , nil},;
					{"DB_QUANT"  ,SD1->D1_QTDCONF   , nil},;
					{"DB_DATA"   ,dDATABASE     , nil}})
					
					AADD(aItem,{{"DB_ITEM"   ,"0002"         , nil},;   //Tem que ser diferente: 002, 003... caso enderecemos o item para mais de um endereco
					{"DB_LOCALIZ",_cLocalDV      , nil},;
					{"DB_QUANT"  ,_nDif		     , nil},;
					{"DB_DATA"   ,dDATABASE     , nil}})
					
				EndIf
				
			Else
				
				AADD(aItem,{{"DB_ITEM"   ,"0001"         , nil},;   //Tem que ser diferente: 002, 003... caso enderecemos o item para mais de um endereco
				{"DB_LOCALIZ",_cLocalOK      , nil},;
				{"DB_QUANT"  ,SDA->DA_SALDO   , nil},;
				{"DB_DATA"   ,dDATABASE     , nil}})
				
			EndIF
			
			//Anderson 21/03/2005
			DbSelectArea("SD1")
			_aASD1 := GetArea()
			DbSelectArea("SDA")
			_aASDA := GetArea()
			//Fim
			
			lMSHelpAuto := .T.
			lMSErroAuto := .F.
			
			msExecAuto({|x,y,z| u_xmata265(x,y,z)},aCab,aItem,3)                           // ENDERECAMENTO
			
			If lMSErroAuto
				
				ALERT("Falha no processo de enderecamento via SIGAAUTO, verifique !")
				Mostraerro()
				
				// Anderson 21/03/2005
				RestArea(_aASB2)
				RestArea(_aASDA)
				RestArea(_aASD1)
				// Fim
				
			Else
				
				// Anderson 21/03/2005
				RestArea(_aASB2)
				RestArea(_aASDA)
				RestArea(_aASD1)
				// Fim
				
				
				// Posicionando na Etiqueta do CB0, atualizando a mesma e o Log (CBG)
				// *** EH IMPORTANTE LEMBRAR QUE A PESQUISA NO CB0 NAO ESTA TRATANDO ITEM NO PADRAO, ISTO IMPLICA EM UMA PESQUISA ERRADA EM NFE COM ITENS COM O MESMO CODIGO, COMUNICAR AO SANDRO ****
				// Foi criado um novo indice com um novo campo no final cb0_X_ok para controlar etiquetas
				// que ja foram utilizadas no processo. Este controle foi necessario quanto a temos o produto
				// em duplicitada na Entrada da nota ou seja produtos com o mesmo codigo.
				// No final do while o CB0  e corrigido.
				
				DbSelectArea("CB0")
				DbOrderNickname("ETIQUTIL") // Filial+doc+serie+fornecedor+loja+documento+utilizada
				
				If Dbseek(xFilial("CB0")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+"    ")
					
					aCb0Recno  := {}
					nEtiquetas := 0
					
					While !EOF() .and. xFilial("CB0") == CB0->CB0_FILIAL .and. SD1->D1_DOC == CB0->CB0_NFENT .and. SD1->D1_SERIE == CB0->CB0_SERIEE .and. SD1->D1_FORNECE == CB0->CB0_FORNEC .and. SD1->D1_LOJA == CB0->CB0_LOJAFO .and. SD1->D1_COD == CB0->CB0_CODPRO
						
						//Verifica se o produto nao eh Granel
						If !CBProdUnit(SD1->D1_COD)
							
							if nEtiquetas = 1
								Exit
							Endif
							
						Else
							// Somente serao utilizadas etiquetas para o produto em que estou posicionado
							if nEtiquetas = SD1->D1_QUANT
								Exit
							Endif
						Endif
						
						nEtiquetas += 1
						
						// Gravo as Etiquetas que estao sendo utilizadas
						AADD(aCb0Recno,CB0->(Recno()))
						
						// Verificando quais etiquetas foram conferidas (lidas) ou nao no recebimento (CBE)
						DbSelectArea("CBE")
						DbSetOrder(1)
						
						
						// No SOMENTE FICAM OS REGISTROS DAS CONFERENCIAS EFETUADAS
						If !DbSeek(xFilial("CBE")+CB0->CB0_CODETI)
							
							// Deve ser colocada AQUI rotina para gerar o LOG (CBG)
							CBLog("05",{SD1->D1_COD,CB0->CB0_QTDE,NIL,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,NIL,CB0->CB0_CODETI,"SF1100I - Conferencia Automatica dos Itens NAO LIDOS (Divergentes)"}) //Conferencia
							// Deve ser colocada AQUI rotina para gerar o registro do CBE (Etiq. lidas no recebimento), o qual NAO foi gerado para as etiquetas que NAO foram conferidas por causa da divergencia.
							DbSelectArea("CBE")
							DbSetOrder(1)
							RecLock("CBE",.T.)
							CBE->CBE_FILIAL := xFilial("CBE")
							CBE->CBE_NOTA   := SD1->D1_DOC
							CBE->CBE_SERIE  := SD1->D1_SERIE
							CBE->CBE_FORNEC := SD1->D1_FORNECE
							CBE->CBE_LOJA   := SD1->D1_LOJA
							CBE->CBE_CODPRO := SD1->D1_COD
							CBE->CBE_QTDE   := CB0->CB0_QTDE
							//CBE->CBE_CODUSR := // Vamos criar AQUI um usuario para ser registrado quando tivermos DIVERGENCIAS
							CBE->CBE_DTVLD  := CB0->CB0_DTVLD
							CBE->CBE_CODETI := CB0->CB0_CODETI
							MsUnLock()
							
							_cLocalXX	:= _cLocalDV
							
							// ABAIXO rotina para efetuar a transferencia do armazem de vendas/original para o armazem/endereco de divergencia
							
							lMsErroAuto := .F.
							lMsHelpAuto := .T.
							aTransf := Array(2)
							aTransf[1] := {"",dDataBase}
							
							DbSelectArea("SB1")
							DbSetOrder(1)
							DBSeek(xFilial("SB1")+SD1->D1_COD)
							
							aTransf[2] := {SD1->D1_COD,;
							SB1->B1_DESC,;
							SB1->B1_UM,;
							_cArmazOK,; //Armazem Original
							_cLocalDV,; //Endereco de Divergencia no Aramazem Original
							SD1->D1_COD,;
							SB1->B1_DESC,;
							SB1->B1_UM,;
							_cArmazDV,; //Armazem Destino
							_cLocalDV,; //Endereco de Divergencia no Armazem de Divergencias (Devido ao parametro que criamos ser um so, o endereco deve ter o mesmo nome em ambos os armazens - ORIGINAL E DIVERGENCIA)
							space(20),;   //numserie
							space(10),;   //lote
							space(6),;   //sublote
							CTOD("//"),; // Dt.Validade
							criavar("D3_POTENCI"),;
							CB0->CB0_QTDE,; //Quantidade
							criavar("D3_QTSEGUM"),;
							criavar("D3_ESTORNO"),;
							criavar("D3_NUMSEQ"),;
							criavar("D3_LOTECTL"),;
							CTOD("//"),;
							criavar("D3_ITEMGRD")}
							
							// Anderson 21/03/2005
							//DbSelectArea("CB0")
							//_aACB0 := GetArea()
							//DbSelectArea("CBE")
							//_aACBE := GetArea()
							//DbSelectArea("SB1")
							//_aASB1 := GetArea()
							// Fim
							
							MSExecAuto({|x| MATA261(x)},aTransf)                        // TRANSFERENCIA
							
							If lMSErroAuto
								
								ALERT("Falha no processo de transferencia entre armazens via SIGAAUTO, verifique !")
								Mostraerro()
								
							EndIf
							
							_lTeveDiv	:= .T.
							
						Else
							
							_cLocalXX	:= _cLocalOK
							_lTeveDiv	:= .F.
							
						EndIF
						
						
						DbSelectArea("CB0")
						_nRecnoCB0:=CB0->(RECNO())
						DbSetorder(6)
						
						// Atualizando etiqueta e historico quanto ao enderecamento
						// Dica sempre que tiver o ultimo parametro indica que a etiqueta sera atualizada
						CBGrvEti("01",{NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,_cLocalXX,SD1->D1_LOCAL,,SD1->D1_NUMSEQ},CB0->CB0_CODETI)
						CBLog("01",{SD1->D1_COD,CB0->CB0_QTDE,NIL,NIL,SD1->D1_LOCAL,_cLocalXX,SD1->D1_NUMSEQ,SD1->D1_DOC,CB0->CB0_CODETI,"SF1100I - Enderecamento Automatico"})
						
						
						// Caso tenha existido transferencia de divergencia para esta etiqueta
						If _lTeveDiv == .T.
							// Atualizacao etiqueta e historico quanto a transferencia dos divergentes, utilizando funcoes do proprio ACD
							CBGrvEti("01",{NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,_cLocalDV,_cArmazDV,,SD3->D3_NUMSEQ,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"SD3"},CB0->CB0_CODETI)
							CBLog("02",{CB0->CB0_CODPRO,CB0->CB0_QTDE,CB0->CB0_LOTE,CB0->CB0_SLOTE,_cArmazOK,_cLocalDV,_cArmazDV,_cLocalDV,CB0->CB0_CODETI,"SF1100I - Transferencia Automatica"})
						EndIF
						
						
						DbSelectArea("CB0")
						DbOrderNickname("ETIQUTIL")  
						DbGoto(_nRecnoCB0)						
						DbSkip()
						
					EndDo
					
					
					//Verifica se o produto nao eh Granel
					If !CBProdUnit(SD1->D1_COD)
						
						If nEtiquetas <> 1
							
							ALERT("Falha no processo de enderecamento Faltam Etiquetas para o Produto"+chr(13)+;
							"Produto  a Granel : " +SD1->D1_COD+chr(13)+;
							"Numero de Etiquetas encontradas "+str(nEtiquetas)+chr(13)+;
							"Quantidade no Produto            1 , verifique !")
							
						Endif
						
					Else
						
						If nEtiquetas <> SD1->D1_QUANT
							
							ALERT("Falha no processo de enderecamento Faltam Etiquetas para o Produto"+chr(13)+;
							"Produto  : "+SD1->D1_COD+chr(13)+;
							"Numero de Etiquetas encontradas "+str(nEtiquetas)    +"  "+chr(13)+;
							"Quantidade no Produto           "+str(SD1->D1_QUANT) +"   , verifique !")
							
						Endif
						
					Endif
					
					
					DbSelectArea("CB0")
					DbSetOrder(0)
					For nY:= 1 to Len(aCb0Recno)
						DbGoTo(aCb0Recno[nY])
						RecLock("CB0",.F.)
						CB0->CB0_DTVLD	   := dDataBase
						CB0->CB0_X_ITEM	   := SD1->D1_ITEM   // Etiqueta Ja Lida
						MsUnlock()
					Next nY
					
				EndIF
				
				// Anderson 21/03/2005
				RestArea(_aASB2)
				RestArea(_aASDA)
				RestArea(_aASD1)
				// Fim
				
			EndIf
			
		EndIf
		
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSkip()
		
	EndDo
	
EndIf



Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEntra_NFilºAutor ³                    º Data ³  24/02/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Entrada de Materias atraves de Outras Filiais               º±±
±±º          ³conferencia da Pre-Nota (Utilizado aos a Classif. da NFE)   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fEntra_NFil()


_cDoc		:= SF1->F1_DOC
_cSerie		:= SF1->F1_SERIE
_cFornece	:= SF1->F1_FORNECE
_cLoja		:= SF1->F1_LOJA



DbSelectArea("SD1")
DbSetOrder(1) //Doc,Serie,Fornece,Loja,Cod,Item
If DbSeek(xFilial("SD1")+_cDoc+_cSerie+_cFornece+_cLoja)
	
	While !Eof() .and. SD1->D1_DOC == _cDoc .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cFornece .and. SD1->D1_LOJA == _cLoja
		
		//
		// 1) Tudo entra com Estados conferido
		//
		Reclock("SF1",.F.)
		SF1->F1_STATCON:='1' // Nota Fiscal conferida (nao ira aparecer no handHeld para conferencia)
		MsUnlock()
		
		//
		// 2) Tudo ja entrada enderecado no Almoxaridado correto (Nao ha divergencias) logo nao ha necessidade
		//    de executar enderecamento em um lugar seguido de transferencia.
		//
		DbSelectArea("SDA")
		DBSetOrder(1)
		If DbSeek(xFilial("SDA")+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_NUMSEQ+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			
			_aTEnd		:= TamSx3("DB_LOCALIZ")                      // Tamanho e Tipo de um campo Qualquer de endereco no ERP Protheus
			_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas (Porem NAO o usamos pois pego da NFE, mas consta no parametro)
			_cLocalOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),3,50))
			_nTOK		   := _aTEnd[1] - Len(_cLocalOK)               //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
			_cLocalOK	:= _cLocalOK + Space(_nTOK)
			
			
			// CRIANDO AQUI REGISTRO NO SB2 PARA CADA PRODUTO PROCESSADO (EM AMBOS OS ARMAZENS QUE IREMOS UTILIZAR - PRODUTOS OK E PRODUTOS DIVERGENTES)
			DbSelectArea("SB2")
			//Anderson 21/03/2005
			_aASB2 := GetArea()
			//Fim
			DbSetOrder(1) // Produto + Local
			If !DbSeek(XFilial("SB2")+SD1->D1_COD+_cArmazOK)
				CriaSB2(SD1->D1_COD,_cArmazOK)
			EndIf
			
			
			aCab := {}
			aItem:= {}
			
			aCAB  :={{"DA_PRODUTO",SD1->D1_COD  , nil},;
			{"DA_LOCAL"  ,_cArmazOK             , nil},;
			{"DA_NUMSEQ" ,SD1->D1_NUMSEQ        , nil},; //relacionado ao campo D1_NUMSEQ
			{"DA_DOC"    ,SD1->D1_DOC           , nil}} //Relacionado ao campo F1_DOC ou D1_DOC
			
			AADD(aItem,{{"DB_ITEM"   ,"0001"     , nil},;   //Tem que ser diferente: 002, 003... caso enderecemos o item para mais de um endereco
			{"DB_LOCALIZ",_cLocalOK             , nil},;
			{"DB_QUANT"  ,SD1->D1_QUANT         , nil},;
			{"DB_DATA"   ,dDATABASE             , nil}})
			
			
			//Anderson 21/03/2005
			DbSelectArea("SD1")
			_aASD1 := GetArea()
			DbSelectArea("SDA")
			_aASDA := GetArea()
			//Fim
			
			lMSHelpAuto := .T.
			lMSErroAuto := .F.
			
			msExecAuto({|x,y,z| u_xmata265(x,y,z)},aCab,aItem,3)                           // ENDERECAMENTO
			
			If lMSErroAuto
				
				ALERT("Falha no processo de enderecamento via SIGAAUTO, verifique !")
				Mostraerro()
				
			EndIf
			
			RestArea(_aASB2)
			RestArea(_aASDA)
			RestArea(_aASD1)
			
		EndIf
		
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSkip()
		
	EndDo
	
EndIf

Return
