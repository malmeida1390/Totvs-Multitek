#INCLUDE "Rwmake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT150GRV  �Autor  � Edelcio Cano       � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Na incl.Novo Partic. gravar Nome do Fornec na Atual.Cotacao ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT160PLN() 

Local _aAreaAt := GetArea() 
Local _aPlan     := ParamIxb[1]
Local _aAudi     := ParamIxb[2]

RestArea(_aAreaAt)

Return