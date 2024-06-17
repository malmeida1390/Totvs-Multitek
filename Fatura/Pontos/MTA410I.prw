#INCLUDE "Rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410I   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta Ponto permite a Gravacao de informacoes               ���
���          � que nao estao contidas nos itens do Orcamento no item do   ���                                          ���
���          � Pedido de Venda.                                           ���                                          ���
���          � Ver Solicitacao de Desenvolvimento D-00001                 ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA410I() 

Local aGetArea   := GetArea()

if Inclui .or. Altera      
                    
   If SC6->C6_X_MARGA $ "L|M"  // L=Liberacao Automatica / M=Liberacao Manual.        
      DbSelectArea("SC6")
      RecLock("SC6")     
      SC6->C6_QTDLIB := SC6->C6_QTDVEN     
      MsUnlock()
   Endif

Endif

//
// A CFOP estava saindo incorretamente em alguns casos pois o usuario efetua a troca do cliente no pedido mas
// nao da um enter na Tes. Por este motivo estamos forcando a validacao da Cfop
// 
//For nY
//cCf:=MaFisRet(1,"IT_CF")


RestArea(aGetArea)

Return

