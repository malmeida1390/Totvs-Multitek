/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RatCt610 �Autor  �Edelcio Cano        � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Captura a C.Contabil na Devol. de uma NFE com Rateio       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function RATCT610()

Local _aAreaAt  := GetArea()
Local _cDocOri  := SD2->D2_NFORI
Local _cSeriOri := SD2->D2_SERIORI
Local _cForn    := SD2->D2_CLIENTE
Local _cLoja    := SD2->D2_LOJA
Local _cItemOri	:= SD2->D2_ITEMORI		 
Local _cConta   := ""    

dbSelectArea("SDE")
_aAreaDE	:= GetArea()
dbSetOrder(1)          
dbGotop()

If dbSeek(xFilial("SDE")+_cDocOri+_cSeriOri+_cForn+_cLoja+_cItemOri)
	
	_cConta :=	SDE->DE_CONTA
	
Endif

RestArea(_aAreaDE)
RestArea(_aAreaAt)	

Return(_cConta)