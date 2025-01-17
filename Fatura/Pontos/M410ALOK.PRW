#INCLUDE "Rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ALOK  �Autor  �                    � Data �  30/04/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta Ponto travar a Alteracao do Pedido de Venda gerados   ���
���          � pelo Orcamento ou pelo Contrato.                           ���
���          � Este Procedimento se tornou necessario em funcao de        ���
���          � apos gerado o Pedido de Venda nao ser possivel efetuar a   ���
���          � alteracao do Mesmo. Visando manter a integridade da        ���
���          � Analise de Rentabilidade.                                  ���
���          �                                                            ���
���          � Importante este ponto de entrada e chamado no inicio das   ���
���          � rotinas de Alteracao/Inclusao/Exclusao..etc.               ���
���          �                                                            ���
���          � Ver Solicitacao de Desenvolvimento D-00001                 ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410ALOK()
Local lRet       := .T.
Local II         := 0
Local cProcName  := FunName()
Local cArmaFech    := GetMv("MV_ARMFECH")


//������������������������������������������������������������������������Ŀ
//�Definie se o Usuario pode Efetuar Alteracao ou Copia do Pedido.         �
//��������������������������������������������������������������������������
//DbSelectArea("SZC")
//DbSetOrder(2)
	
	
If SC5->C5_X_ORIGM $ "S|C"

	//������������������������������������������������������������������������Ŀ
	//� A rotina abaixo apenas verifica na pilha de chamda se estamos          �
	//� utilizando o "MFATC08" pois esta rotina e utilizada para               �
	//� reajuste de Precos logo onde lemos Z6_PRCVEN passamo para Z6_PRCREA    �
	//� isto tem como objetivo fazermos simulacoes sobre o preco simulado.     �
	//��������������������������������������������������������������������������
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
