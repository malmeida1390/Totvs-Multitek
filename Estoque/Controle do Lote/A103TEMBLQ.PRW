#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � A103TEMBLQ � Autor �                       � Data �14.05.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Retornar as quantidades utilizadas no Pedido de Venda       ���
���          �durante a DEVOLUCAO para o arquivo SZV.                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A103TEMBLQ()

		     
Local cArmaFech    := GetMv("MV_ARMFECH")

//�������������������������������������������Ŀ
//�Pega posicoes  dos itens do Acols          �
//���������������������������������������������
LOCAL _C6_ITEM    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    }) // Codigo do Produto
LOCAL _C6_PRODUTO := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" }) // Codigo do Produto
LOCAL _C6_DESCRI  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"  }) // Descri��o do Produto
LOCAL _C6_UM      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"      }) // Unidade de medida
LOCAL _C6_QTDVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  }) // Quantidade Vendida
LOCAL _C6_TES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     }) // Tipo de Saida do Item (TES Inteligente)
LOCAL _C6_CF      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"      }) // Codigo Fiscal da Opera��o
LOCAL _C6_DESCONT := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT" }) // % Total dos Descontos
LOCAL _C6_VALDESC := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC" }) // Valor Total dos Descontos
LOCAL _C6_PRCVEN  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  }) // Preco Unitario Liquido
LOCAL _C6_VALOR   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   }) // Valor Total do Item
LOCAL _C6_ENTREG  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"  }) // Data da Entrega
LOCAL _C6_LOCAL   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"   }) // Almoxarifado
LOCAL _C6_PRUNIT  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"  }) // Pre�o Unit�rio de Tabela
LOCAL _C6_CLI     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLI"     }) // C�digo do Cliente
LOCAL _C6_LOJA    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOJA"    }) // Loja do Cliente
LOCAL _C6_NUM     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUM"     }) // Numero do Pedido
Local _C6_X_CHAVE := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_CHAVE" })


Local nX          := 0            
Local cChave      := "" 
         
Local cProcName   := FunName()             
Local II          := 0
Local lDelecao    := .F.     

         
//������������������������������������������������������������������������Ŀ
//� Analiso a pilha de chama para verificar se isto e uma Delecao.         �
//��������������������������������������������������������������������������
While !Empty(cProcName)
	If ("A410DELETA" $ UPPER(cProcName)) 
	   lDelecao:=.T.
	Endif
	ii++
	cProcName := UPPER(AllTrim(ProcName(ii)))
EndDo

         
If lDelecao .and. cFilAnt $ cArmaFech   

   For nX := 1 To len(Acols)

       cChave:=aCols[nX][_C6_X_CHAVE]
       DbSelectArea("SZV")
       dbSetOrder(1) // ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_COD + ZV_ITEM
       If dbSeek(cChave)
  	      Reclock("SZV",.F.)
	      ZV_QTD_DEV := ZV_QTD_DEV + aCols[nX][_C6_QTDVEN]
	      ZV_UPEDVEN := Space(6)
	      MsUnlock()
       Endif

   Next nX    

Endif

Return(.F.)



