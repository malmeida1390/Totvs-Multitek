/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor  ³Anderson            º Data ³  18/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validar os itens marcados na hora de  º±±
±±º          ³gerar a NF                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460MARK()

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
DbSelectArea("CB7")
Private _aAreaCB7	:= GetArea()
Private _lContinua:= .T.


If cEmpAnt <> '01'  // somente multitek utiliza os processos abaixo.
   Return(_lContinua)
Endif


If SM0->M0_CODFIL == "01"               // alltrim(GetMv("MV_MODFIL")) <> "03"  // Opcao 01 - HandHeld On-Line                                     //        
	Processa({||_lContinua:=VerSC9()})   // Opcao 02 - HandHeld nao utilizanda HandHeld.
Endif                                    // Opcao 03 - HandHeld Off-Line


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a area corrente                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC9")
RestArea(_aAreaC9)
RestArea(_aAreaC6)
RestArea(_aAreaA1)
RestArea(_aAreaCB7)
RestArea(_aArea)

Return(_lContinua)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ VerSC9   ³ Autor ³ Jeremias Luna         ³    23.10.2001   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de processamento e regua                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VerSC9()

Local _cTES      :=""
Local _cEstoque  :=""
Local _aPedido   := {}
Local _cNumOrca  := ""
Local _i         := 0
Local _cTipo     := ""

// Verificando se o usuario marcou TODOS os registros disponiveis clicando

/*
// Na realidade este if na funcionou mas o objetivo e que nao traca 
// os itens da nota ja marcado caso contrario nao conseguimos pegar o _aPedido
// quando ja marcados os itens SC9->C9_OK == PARAMIXB[1] ficam diferentes.
// pos isto deve se marcar manualmente, esta questao de sair marcado e um 
// parametro quando entra na tela documento de entrada
//
If PARAMIXB[2] == .T.
	
	Alert("Devido a personalizacoes, voce DEVE marcar item a item para a geracao da NF, Verifique !")
	_lContinua	:= .F.
	Return(_lContinua)
	
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre o SC9 inteiro                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC9")
ProcRegua(RecCount())
DbGoTop()

While !Eof()
	
	If  SC9->C9_OK == PARAMIXB[1]
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
			
			SC5->(DbSetorder(1))
			_cNumOrca:=IIF(SC5->(DbSeek(xFilial("SC5")+SC6->C6_NUM)),SC5->C5_X_NUM,"")
			
			Aadd(_aPedido,{SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_PRODUTO,SC9->C9_ORDSEP,SC9->C9_QTDLIB,SC6->C6_QTDVEN,_cNumOrca})
			
		EndIf
		
	EndIf
	
	IncProc()
	
	DbSelectArea("SC9")
	DbSkip()
	
EndDo

// Valida se array nao esta vazio
If Empty(_aPedido)
	Alert("Nao conseguiu localizar os pedidos correspondentes, Verifique !")
	_lContinua:= .F.
	Return(_lContinua)
EndIf

// Verificando integridade dos itens

_lFilial   	:= .F.
_lNFilial	:= .F.
_cPedido	   := _aPedido[1][1]
_cOrdSep	   := _aPedido[1][6]
_cCliente	:= _aPedido[1][3]+_aPedido[1][4]

// Verificando se pelo menos um dos clientes marcados indica ser uma filial da Multi-Tek
For _x := 1 to Len(_aPedido)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+_aPedido[_x][3]+_aPedido[_x][4])
		// Quer dizer que EH uma filial da Multi-Tek
		If !Empty(SA1->A1_X_ALMOX)
			_lFilial	:= .T.
		Else
			_lNFilial	:= .T.
		EndIf
	EndIF
	
Next


If _lFilial == .T. .and. _lNFilial == .T. // QUER DIZER QUE ESTA MISTURANDO NF PARA FILIAL COM OUTROS CLIENTES NA ROTINA DE GERAR A NF
	
	Alert("Voce selecionou itens de uma FILIAL MULTI-TEK com itens de outro cliente !, Verifique !")
	_lContinua	:= .F.
	
ElseIf _lFilial == .T. .and. _lNFilial == .F. // SOMENTE FILIAL (CORRETO)
	
	// Verificando se existe Ordem de Separacao
	If !Empty(_cOrdSep)
		
		DbSelectArea("CB7")
		DbSetORder(1)
		If DbSeek(xFilial("CB7")+_cOrdSep)
			
			If CB7->CB7_STATUS <> "9" // Finalizada
				Alert("A Ordem de Separacao " + _cOrdSep + " nao foi finalizada pelo Coletor, verifique !")
				_lContinua	:= .F.
				
			Else
				
				_lContinua	:= .T.
				
			EndIf
			
		EndIf
		
	Else
		
		If alltrim(GetMv("MV_MODFIL")) $ "01|03"  // Opcao 01 - HandHeld On-Line
																 // Opcao 02 - HandHeld nao utilizanda HandHeld.
																 // Opcao 03 - HandHeld Off-Line
			
			Alert("Voce marcou itens para uma FILIAL MULTI-TEK, porem o mesmo NAO TEM Ordem de Separacao."+;
			"Pode ser que uma ordem ate exista, mas pode ter havido uma exclusao de NF a qual desvincula o Pedido da Ordem!"+;
			"Pelo Coletor, digite o codigo da Ordem de Separacao, estorne-a. Pelo Protheus faca o mesmo e depois crie uma nova, verifique !")
			_lContinua 	:= .F.
			
		Endif
		
		
	EndIf
	
	
	//
	// Analise especifica para o caso de ser material para filial.
	//
	If _lContinua	== .T. // Aqui verificamos simplesmente se o primeiro item marcado (do array) nao difere dos demais para poder liberar o faturamento
		
		
		For _i := 1 to Len(_aPedido)
			
			If _cPedido <> _aPedido[_i][1]
				Alert("Voce esta gerando uma NF para uma FILIAL MULTI-TEK, somente UM pedido por vez pode ser processado, verifique !")
				_lContinua	:= .F.
			EndIf
			
			If _aPedido[_i][7] <>  _aPedido[_i][8] // Quantidade no C6 com a do C9
				Alert("Nos itens marcados existem liberacoes parcias, as quais NAO SAO possiveis quando a NF for para uma FILIAL MULTI-TEK, verifique !")
				_lContinua	:= .F.
			EndIf
			
			// JA FOI VALIDADO ACIMA ESTA COM A SEGUINTE MENSAGEM
			// Alert("Nos itens marcados existem liberacoes parcias, as quais NAO SAO possiveis quando a NF for para uma FILIAL MULTI-TEK, verifique !")
			// If _cOrdSep	<> _aPedido[_i][6]
			//	Alert("Voce esta gerando uma NF para uma FILIAL MULTI-TEK, somente UMA Ordem de Separacao por PEDIDO eh permitada, verifique !")
			//	_lContinua	:= .F.
			// EndIF
			
			// JA FOI VALIDADO ACIMA ESTA COM A SEGUINTE MENSAGEM
			// Alert("Voce selecionou itens de uma FILIAL MULTI-TEK com itens de outro cliente !, Verifique !")
			// If _cCliente  <> _aPedido[_i][3]+_aPedido[_i][4]
			//	Alert("Voce esta gerando uma NF para uma FILIAL MULTI-TEK, somente UM CLIENTE pode ser marcado, verifique !")
			//	_lContinua	:= .F.
			// EndIF
			
			
		Next _i
		
	EndIf
	
EndIf



if _lContinua
	
	//
	// Analisa se ha algum problema relativo a Ordem Separacao
	//
	For _i := 1 to Len(_aPedido)
		
		If !Empty(_aPedido[_i][6]) .or. !Empty(_aPedido[_i][9])   // Caso a Nota Fiscal tenha uma Ordem de Separacao Atrelada a Mesma deve estar encerrada
			
			DbSelectArea("CB7")
			DbSetORder(1)
			If DbSeek(xFilial("CB7")+_aPedido[_i][6])
				
				If CB7->CB7_STATUS <> "9" // Finalizada
					Alert("A Ordem de Separacao " + _aPedido[_i][6] + " nao foi finalizada pelo Coletor, verifique !")
					_lContinua	:= .F.
					Exit
				Else
					_lContinua	:= .T.
				EndIf
				
			Else
				
				//
				// Antes de dar a mensagem deve ser analizado se o TES do pedido gera estoque.
				// Pois existem situacoes como poder de terceiros que pode gerar uma nota fiscal
				// sem necessariamente ter Ordem de separacao.
				//
				
				_cTipo   :=POSICIONE("SC5",1,xFilial("SC5")+_aPedido[_i][1],"C5_TIPO")
				_cTES    :=POSICIONE("SC6",1,xFilial("SC6")+_aPedido[_i][1]+_aPedido[_i][2],"C6_TES")
				_cEstoque:=POSICIONE("SF4",1,xFilial("SF4")+_cTes,"F4_ESTOQUE")
				
				If _cEstoque = "S" .and. _cTipo $ ("N/B/D")
					Alert("Ordem de Separacao para o pedido " + _aPedido[_i][1] + " nao foi gerada, verifique !")
					_lContinua	:= .F.
					Exit
				Endif
				
				
			EndIf
			
		Endif
		
	Next
	
Endif



// Caso haja inconsistencias os itens sao desmarcados no browser, impedindo a geracao da(s) NF(s)
If _lContinua = .F.
	
	DbSelectArea("SC9")
	ProcRegua(RecCount())
	DbGoTop()
	
	While !Eof()
		If SC9->C9_OK == PARAMIXB[1]
			RecLock("SC9",.F.)
			SC9->C9_OK := Space(4)
			MsUnLock()
		EndIf
		
		IncProc()
		
		DbSelectArea("SC9")
		DbSkip()
		
	EndDo
	
EndIf

Return(_lContinua)
