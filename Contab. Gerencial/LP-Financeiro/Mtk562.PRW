
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F530CON  �Autor  �Edelcio Cano        � Data �  10/12/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica a Natureza e define a Conta Contabil              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function F530CON()

Local _aAreaAt	:=	GetArea()
Local _cConta   := ""    
Local _cPref	:= SE2->E2_PREFIXO
Local _cNum		:= SE2->E2_NUM
Local _cParc	:= SE2->E2_PARCIR
Local _cForn	:= SE2->E2_FORNECE
Local _cLoja	:= SE2->E2_LOJA

//������������������������������Ŀ
//�Define Conta Contabil         �
//��������������������������������
dbSelectArea("SE2")
_aAreaE2	:= GetArea()
dbSetOrder(12)          
dbSetOrder()

If dbSeek(xFilial("SE2")+_cPref+_cNum+_cPar+_cForn+_cLoja)
	If Alltrim(SED->ED_NATUREZ)$"02106/02078/02082/02077/02075/02098"
		_cConta   := "213030003"
	ElseIf Alltrim(SED->ED_NATUREZ) == "02005"
		_cConta   := "213030004"
	Endif
Else
	_cConta    := "Definir Conta"
Endif	
	
RestArea(_aAreaE2)
RestArea(_aAreaAt)

Return(_cConta)