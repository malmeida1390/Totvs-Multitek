/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CON30530 �Autor  �Edelcio Cano        � Data �  12/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica o Codigo do Fornec e define a Conta Contabil      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function CON30530()

Local _aAreaAt  :=	GetArea()
Local _cConta   := ""    
Local _cFornec	 := SE2->E2_FORNECE              
Local _cLoja    := SE2->E2_LOJA
//Local _cPref    := SE2->E2_PREFIXO 
//Local _cNum	    := SE2->E2_NUM
//Local _cTitOrig := SE2->E2_X_TITOR //Parcela+Tipo+Fornece+Loja

//dbSelectArea("SE2")
//_aAreaE2	:= GetArea()
//dbSetOrder(1)          
//dbGotop()

//If dbSeek(xFilial("SE2")+_cPref+_cNum+_cTitOrig)
//	_cFornec	:= SE2->E2_FORNECEC
//	_cLoja	:= SE2->E2_LOJA
dbSelectArea("SA2")
_aAreaA2	:= GetArea()
dbSetOrder(1)          
dbGotop()
If dbSeek(xFilial("SA2")+_cFornec+_cLoja)
  _cConta   := SA2->A2_CONTA
Else
	_cConta    := "Definir Conta
Endif

RestArea(_aAreaA2)
RestArea(_aAreaAt)	

Return(_cConta)