#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MK_AF001  �Autor  �Edelcio Cano        � Data �  03/12/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define Conta Contabil conforme Grupo de Contabilizacao p/  ���
���          � Calculo de Depreciacao                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function MTKATF01()

_aAreaAt	:=	GetArea()

_cConCalDepr	:= ""

If SN1->N1_GRUPO == "0001" 
	_cConCalDepr	:=	"132020001"
ElseIf	SN1->N1_GRUPO == "0002"
    _cConCalDepr	:=	"132020002"
ElseIf	SN1->N1_GRUPO	==	"0003"
	_cConCalDepr	:=	"132020003"
Endif                    

RestArea(_aAreaAt)

Return(_cConCalDepr)