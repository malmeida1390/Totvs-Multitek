#include "rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Mpl_GDESC | Autor � Almeida                � Data � 16/09/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Concatena REFERENCIA+SUFIXO+MARCA+ORIGEM  GATILHO           ���
���          �                                                             |��
���          � Funcao chamada do Cadastro de Produtos (SB1)                |��
���          �                                                             |��
���          � Deve ser incluida no Valide dos seguintes campos            |��
���          � B1_X_REFER / B1_X_SUFIX / B1_X_MARCA / B1_ORIGEM            |��
���          � Gatilho Cadastro de Produtos                                |��
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function MPL_GDESC()

Local cConc    := ""
Local aGetArea := GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
Dbseek(xFilial("SB1")+M->B1_COD)

cConc:=  Alltrim(M->B1_X_REFER) + Alltrim(M->B1_X_SUFIX)+" "+Alltrim(M->B1_X_MARCA) 
//+ Alltrim(M->B1_ORIGEM)  
                      
              
              
RestArea(aGetArea)   

Return(cConc)

