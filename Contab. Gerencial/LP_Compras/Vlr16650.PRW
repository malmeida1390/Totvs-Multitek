/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLR16650 �Autor  �Edelcio Cano        � Data �  19/07/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consiste Naturezas de Frete Compras, Frete Carreto Fatur   ���
���          � e captura valor ICMS                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLR16650()

Local _aAreaAt	:=	GetArea()
Local _nVlr     := 0
Local _nValor	:= 0 

dbSelectArea("SE2")
_aAreaE2	:= GetArea()
DbOrderNickname("E2_13PREFI")    //22/07/2008_Virada_         //B1_X_SIMIL + EIS
//dbSetOrder(13)
dbGotop()

If dbSeek(xFilial("SE2")+SD1->D1_SERIE+SD1->D1_DOC+"NF "+SD1->D1_FORNECE+SD1->D1_LOJA)
	
	//���������������Ŀ
	//�Captura Valor  �
	//�����������������
	If Alltrim(SE2->E2_NATUREZ)$"02029/02030"
		
		_nValor	:= SD1->D1_VALICM
		
	Endif

Else	
   // situacao em que a tes nao gerou financeiro.
	_nValor	:= SD1->D1_VALICM
	
Endif

RestArea(_aAreaE2)
RestArea(_aAreaAt)

Return(_nValor)