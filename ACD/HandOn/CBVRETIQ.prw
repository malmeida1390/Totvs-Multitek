/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CBVRETIQ   � Autor � Desenv.    ACD      � Data � 04/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pto. de Entrada para validar se etiqueta esta bloquada	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MULTITEK           	    						          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CBVRETIQ

_lRetorno	:= .T.

If CB0->CB0_X_STAT == "D"	// Etiqueta ja utilizada na Desmontagem de Produtos (Especifico MULTITEK)
	_lRetorno	:= .F.		// Retornando .F. o array de etiquetas estara vazio, entao a funcao que valida 
							//a etiqueta retornara que a etiqueta eh uma etiqueta invalida para leitura
EndIf

Return(_lRetorno)