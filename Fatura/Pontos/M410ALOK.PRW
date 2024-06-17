#INCLUDE "Rwmake.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410ALOK  ºAutor  ³                    º Data ³  30/04/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta Ponto travar a Alteracao do Pedido de Venda gerados   º±±
±±º          ³ pelo Orcamento ou pelo Contrato.                           º±±
±±º          ³ Este Procedimento se tornou necessario em funcao de        º±±
±±º          ³ apos gerado o Pedido de Venda nao ser possivel efetuar a   º±±
±±º          ³ alteracao do Mesmo. Visando manter a integridade da        º±±
±±º          ³ Analise de Rentabilidade.                                  º±±
±±º          ³                                                            º±±
±±º          ³ Importante este ponto de entrada e chamado no inicio das   º±±
±±º          ³ rotinas de Alteracao/Inclusao/Exclusao..etc.               º±±
±±º          ³                                                            º±±
±±º          ³ Ver Solicitacao de Desenvolvimento D-00001                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410ALOK()
Local lRet       := .T.
Local II         := 0
Local cProcName  := FunName()
Local cArmaFech    := GetMv("MV_ARMFECH")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definie se o Usuario pode Efetuar Alteracao ou Copia do Pedido.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DbSelectArea("SZC")
//DbSetOrder(2)
	
	
If SC5->C5_X_ORIGM $ "S|C"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A rotina abaixo apenas verifica na pilha de chamda se estamos          ³
	//³ utilizando o "MFATC08" pois esta rotina e utilizada para               ³
	//³ reajuste de Precos logo onde lemos Z6_PRCVEN passamo para Z6_PRCREA    ³
	//³ isto tem como objetivo fazermos simulacoes sobre o preco simulado.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Empty(cProcName)
		If  cProcName $ "A410ALTERA"   // Geracao Pedido atraves do Contrato ou Orcamento
			lRet:=.F.
		Endif
		If  cProcName $ "A410COPIA"     // Geracao Pedido atraves do Contrato ou Orcamento
			lRet:=.F.
		Endif
		ii++
		cProcName := UPPER(AllTrim(ProcName(ii)))
	EndDo
	
	
	If !lRet
		
		If SC5->C5_X_ORIGM $ "S|C"
			Aviso("ATENCAO", "A alteracao de Pedidos de Venda que tem como Origem "+;
			"Contrato de Venda  ou  Orcamento  nao e  possivel em "+;
			"funcao do Controle de Rentabilidade" ,{"&Ok"})
		Else
			lRet:=.T.
		Endif
		
		If  lRet 
		
			if  cFilAnt $ cArmaFech
				Aviso("ATENCAO", "A alteracao/copia de Pedidos dos Almoxarifados Fechados contido no Parametro "+;
				"MV_ARMFECH nao e permitida em nenhuma situacao visto perdermos o controle do SZV (Custo FIFO).",{"&Ok"})
			Else
				lRet:=.T.
			Endif
			
		Endif
		
	Endif
	                   

   
   If lRet
      
      DbSelectArea("CB7")
      DbSetOrder(2)            // Filial+Pedido+local+Status+cliente+loja
  		If DbSeek(xFilial("CB7")+SC5->C5_NUM)

			Aviso("ATENCAO", "Nao e possivel alterar este pedido pois o mesmo ja possui Ordem de Separacao"+chr(13)+;
			      "Caso deseje alterar favor excluir a Ordem de Separacao",{"&Ok"})
   
         lRet := .f.
            
	   Endif
	
	Endif


Else

   //
   // SOMENTE PODE ALTERAR SE TODAS AS ORDENS DE SEPARACAO ORIGINADAS DESTE PEDIDO ESTIVEREM 
   // COM A NOTA FISCAL IMPRESSA
   //
   DbSelectArea("SC9")
   DbSetOrder(1)               // Filial+Pedido+local+Status+cliente+loja 
   
   If DbSeek(xFilial("SC9")+SC5->C5_NUM)  
         
      While  xFilial("SC9")+SC5->C5_NUM = SC9->(C9_FILIAL+C9_PEDIDO)
             
             If !Empty(SC9->C9_ORDSEP) .and. EMPTY(SC9->C9_NFISCAL)
                lRet:=.F.
             Endif

              SC9->(DBSKIP()) 
      Enddo 


      If !lRet
      
			Aviso("ATENCAO", "Alteracao nao Permitida. Existe alguma Ordem de Separacao em andamento "+; 
			      "cuja a nota fiscal ainda nao foi emitida. Para continuar favor deletar a "+;
			      "ordem de separacao que ainda nao foi concluida ou seja nao foi gerado Nota Fiscal.",{"&Ok"})
         
      Endif
            
	Endif
	
Endif


Return(lRet)
