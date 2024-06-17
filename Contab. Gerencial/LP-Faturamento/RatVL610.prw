/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RatVL610 �Autor  �Edelcio Cano        � Data �  09/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula Rateio Ref a Devol. da NFE, pesquisando a Nota Ori ���
���          � na Tabela SDE-Rateio NFE, capturando o Percentual do item  ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function RATVL610()

Local _aAreaAt  := GetArea()
Local _cDocOri  := SD2->D2_NFORI
Local _cSeriOri := SD2->D2_SERIORI
Local _cForn    := SD2->D2_CLIENTE
Local _cLoja    := SD2->D2_LOJA
Local _cItemOri	:= SD2->D2_ITEMORI
Local _nPerc    := 0
Local _nValor   := 0

dbSelectArea("SDE")
_aAreaDE	:= GetArea()
dbSetOrder(1)          
dbGotop()

If dbSeek(xFilial("SDE")+_cDocOri+_cSeriOri+_cForn+_cLoja+_cItemOri)
	
	_nPerc  := SDE->DE_PERC
	_nValor := _nPerc *(SD2->D2_TOTAL+SD2->D2_VALIPI)/100                                                                                                                                                         
	
Endif

RestArea(_aAreaDE)
RestArea(_aAreaAt)	

Return(_nValor)