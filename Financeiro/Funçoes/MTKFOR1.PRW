#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKFOR1   �Autor  �Edelcio Cano        � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera COdigo de Fornec., verifica parametro e chama funcao  ���
���          � Padrao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                       

User Function MTKFOR1()

_aAreaM	    := GetArea()
_lMvForn	:=	GetMv("MV_INCFORN")

If _lMvForn == .F.
	//�������������������������������������������������������������������Ŀ
	//� Altera parametro que consiste somente 01 usuaria Incluido Forneced�
	//���������������������������������������������������������������������
	_lMvForn	:=	GetMv("MV_INCFORN")
	Reclock("SX6",.F.) 
		SX6->X6_CONTEUD := ".T." 
	MsUnlock()
	//�����������������������������������������������Ŀ
	//�Chamada da Funcao Padrao, Cadastro de Forneced.�
	//�������������������������������������������������
    A020Inclui("SA2")
	//�������������������������������������������������������������������Ŀ
	//� LIBERA parametro que consiste somente 01 usuaria Incluido Forneced�
	//���������������������������������������������������������������������
	_lMvForn	:=	GetMv("MV_INCFORN")
	Reclock("SX6",.F.) 
		SX6->X6_CONTEUD := ".F."
	MsUnlock()
	
Else
	MsgBox("Impossivel acesso simultaneo ao Cadastro de Fornecedores por mais de 01 usuario","ALERT")
Endif
                                               

RestArea(_aAreaM) 

Return