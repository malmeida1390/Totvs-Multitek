#INCLUDE "Rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA416BX  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada valida quais os Orcamentos estao      ���
���          �impedidos de Virar Pedido de Venda em funcao da             ��� 
���          �Rentabilidade do Orcamento.                                 ��� 
���          �Ver Solicitacao de Desenvolvimento D-00001                  ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA416BX() 
Local cAlias := ParamIxb[1]
Local lRet   := .T.


If (cAlias)->CJ_X_MARGA $ "B|D"             

   lRet := .F.

Endif



If EMPTY((cAlias)->CJ_COTCLI) 


	Aviso("ATENCAO", "Favor informar o numero do Pedido do cliente no Orcamento "+(cAlias)->CJ_NUM,{"&Ok"})
 
   lRet := .F.

Endif

If VAL(MV_PAR01) - VAL(MV_PAR02) <> 0 

   MV_PAR02:= STRZERO(VAL(MV_PAR01)+1,6)
   
	Aviso("ATENCAO", "Somente e permitido gerar um pedido de cada vez, rever os parametros.", {"&Ok"})
 
   lRet := .F.

Endif            



Return(lRet)

