#INCLUDE "Rwmake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AVALCOT   �Autor  � Edelcio Cano       � Data �  18/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava o Nome do Comprador no PC, na Aprovacao da Cotacao    ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AVALCOT() 

Local _aAreaAt  := GetArea() 
Local _nOpc     := ParamIxb[1]

If _nOpc = 4

    SC1->(DbSelectArea("SC1"),DbSetorder(1),DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC))
    SY1->(DbSelectArea("SY1"),DbSetorder(1),DbSeek(xFilial("SY1")+SC1->C1_CODCOMP))

	Reclock("SC7",.F.)
	SC7->C7_X_NOMCP := SY1->Y1_NOME 
	SC7->C7_X_NOMSL := SC1->C1_SOLICIT
	MsUnlock()         

Endif

RestArea(_aAreaAt)

Return

