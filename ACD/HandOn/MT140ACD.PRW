/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � MT140ACD   � Autor � Desenv.    ACD      � Data � 04/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pto. de Entrada para gravar "0" no campo F1_STATCON        ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MULTITEK           	    						          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SD1140I()

Reclock("SF1",.F.)
	SF1->F1_STATCON := "0"
MsUnlock()

Return()
