/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLR02510 �Autor  �Edelcio Cano        � Data �  27/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consiste Naturezas de Servi�os, retorna valor              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function VLR02510()

Local _aAreaAt	:=	GetArea()
Local _nValor   := 0        

//����������������������Ŀ
//�Calcula Valor         �
//������������������������
If Alltrim(SE2->E2_NATUREZ)$"02010/02030/02053/02054/02074/02075/02076/02078/02079/02081/02082/02083/02087/02090/02091/02092/02093/02094/02080/02098/02106/02086/02113/02114/02124/02125/02112/02129/02128/02148";
                              .AND. Alltrim(SE2->E2_TIPO)<>"NDF"                                 
                           
	_nValor	:= SE2->E2_VALOR+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS
	
Endif
                              
RestArea(_aAreaAt)

Return(_nValor)