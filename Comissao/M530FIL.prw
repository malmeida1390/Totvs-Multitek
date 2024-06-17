/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���P.E       �M530FIL   �Autor  �Edelcio Cano        � Data �  10/21/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtra somente os Vendedores Externos para rotina Padrao,   ���
���          �pois os Interno a com iss�o eh gerada por rotina especifica ���
���          �integrada com SRC- Folha de Pagamento.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Multi-Tek                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                

User Function M530FIL()

Return("U_TPVEND()")  


User Function TpVend()
       
Local _aAreaAt	:= GetArea()
Local _lRet	:= .T.

dbSelectArea("SA3")
_aAreaA3 := GetArea()
dbSetOrder(1)
dbGotop()

If dbSeek(xFilial("SA3")+SE3->E3_VEND)
	If !SA3->A3_TIPO == "E"
   		_lRet	:= .F.
    Endif                             
Else
	  Aviso('Atencao','Vendedor nao encontrado no SA3-Cad.Vendedores',{'Ok'})
Endif  

RestArea(_aAreaA3)
RestArea(_aAreaAt)

Return(_lRet)