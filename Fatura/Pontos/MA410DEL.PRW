#INCLUDE "Rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410DEL  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta Ponto permite durante o estorno do Pedido de Venda    ���
���          � Liberar o Orcamento Novamento, mas os precos voltam para   ��� 
���          � ROTINA 1.                                                  ���
���          � Para isto foi necessario o uso da variavel _cNumOrc        ���
���          � Esta Variavel e Publica e foi declarada no ponto de Entrada���
���          � M410ALOK.PRW                                               ���
���          �                                                            ���
���          � Ver Solicitacao de Desenvolvimento D-00001                 ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410DEL() 

Local aGetArea := GetArea()
Local aPrVenda := {}                
Local _cNumOrc := SC5->C5_X_NUM  // Numero do Orcamento.
Local _nMarge   := 0
Local _nMargV   := 0
Local _cMargA   := "L"
Local _nElem    := 0

Local _nGetRent  := 0
Local _nGetRenVr := 0
Local _cStatus   := "L"

If !EmptY(_cNumOrc)


   // Nao e necessario analisar o novo Status devido estarmos
   // voltando tudo para a rotina 1 estado inicial. 
   DbselectArea("SCJ") 
   DbSetOrder(1)
   If Dbseek(xFilial("SCJ")+_cNumOrc)
      DbSelectArea("SCJ")
      SCJ->(RecLock("SCJ",.F.))     
      SCJ->CJ_STATUS  := "A"     
      SCJ->CJ_X_NUMPV := CRIAVAR("CJ_X_NUMPV")
      SCJ->(MsUnlock())
   Endif

   DbselectArea("SCK") 
   DbSetOrder(1)
   If Dbseek(xFilial("SCK")+_cNumOrc)
      While !SCK->(EOF()) .and. xFilial("SCK")+_cNumOrc = SCK->(CK_FILIAL+CK_NUM)
            DbSelectArea("SCK")
    	    SCK->(RecLock("SCK",.F.))     
     	    SCK->CK_NUMPV  := CRIAVAR("CK_NUMPV")    
	        SCK->(MsUnlock())  
	        SCK->(DbSkip())
	  Enddo      
   Endif


   /*                     
   // Conforme solicitacao do Sr. Mauricio o mesmo deseja que a 
   // o Orcamento apenas seje novamente Liberado mas que nao seja
   // alterado nenhum dado do Orcamento. Almeida - 28/07
   DbselectArea("SCK")
   DbSetOrder(1)
   DbSeek(xFilial("SCK")+_cNumOrc)
   
   While !SCK->(EOF()) .and.  SCK->CK_NUM  = _cNumOrc
    
        //�������������������������������������������������������������������������T�
        //� Parametros                                                             �
        //� 1. < cGetCond > - Condicoes de Pagamento                               �
        //� 2 <._cProd    > - Produto Desejado                                     �
        //� 3.< NIL       > - I(Industria)/C(Comercio)                             �
        //�                   Caso Nil a propria rotina define                     �
        //�                   atraves da Origem.                                   �
        //�  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  �
        //�                   .F. Outras origens.                                  �
        //�                   Motivo controle do custo que vem do acols.           �
        //��������������������������������������������������������������������������
		aPrVenda  := U_PrVenda(SCJ->CJ_CONDPAG,SCK->CK_PRODUTO,SCJ->CJ_X_ST_CI,.F.)  // Cond.de Pagto,Produto, (I-"INDUSTRIA";C-"CONSUMO")(MfatC01)
		
		Reclock("SCK",.F.)
        SCK->CK_X_USER   :=  ""
        SCK->CK_X_DTLIB  :=  CTOD("")
        SCK->CK_X_CTSTD  :=  SB1->B1_X_CTSTD
		SCK->CK_X_PRUN   :=  aPrVenda[02,03]    // Preco de Venda
		SCK->CK_PRCVEN   :=  aPrVenda[02,03]    // Preco Sugerido
		SCK->CK_VALOR    :=  SCK->CK_QTDVEN * aPrVenda[02,03]

		SCK->CK_X_MARGE  :=  aPrVenda[04,03]    //  % Rentabilidade
		SCK->CK_X_MARGV  :=  aPrVenda[03,03]    //  $  Rentabilidade
		SCK->CK_X_MARGA  :=  aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
        MsUnlock()
                                                 
                
        //������������������������������������������������������������������������Ŀ
        //� Executa somatoria das Margens para poder gravar a nova Media           �
        //��������������������������������������������������������������������������
     	_nElem    :=_nElem + 1
		_nMargE   :=SCK->CK_X_MARGE
		_nMargV   :=SCK->CK_X_MARGV
		_cMargA   :=SCK->CK_X_MARGA
		_nGetRent := _nGetRent  + _nMargE
		_nGetRenVr:= _nGetRenVr + _nMargV
		If _cMargA = "B"
			_cStatus   := "B"
		Endif
     
          
        SCK->(DBSKIP())

   Enddo     
     

   _nGetRent   := _nGetRent  / _nElem
   _nGetRenVr  := _nGetRenVr / _nElem


   DbselectArea("SCJ")
   DbSetOrder(1)
   If DbSeek(xFilial("SCJ")+_cNumOrc)
      Reclock("SCJ",.F.)
      SCJ->CJ_X_MARGE := _nGetRent
      SCJ->CJ_X_MARGV := _nGetRenVr
      SCJ->CJ_X_MARGA := _cStatus
      SCJ->CJ_X_NUM   := SPACE(6)
      MsUnlock()
   Endif
   */
   
   
   Aviso("ATENCAO", "Sr. Usuario durante este operacao o Orcamento N."+_cNumOrc+;
                    " foi Liberado caso haja interesse em efetuar manutecao",{"&Ok"})
   
Endif

RestArea(aGetArea)


Return

