#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKCLI1   �Autor  �Edelcio Cano        � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera C�digo de Cliente, verifica parametro e chama funcao  ���
���          � Padrao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                       

User Function MTKCLI1()

_aAreaM	    := GetArea()
_lMvClie	:=	GetMv("MV_INCCLIE")

If _lMvClie == .F.
	//�������������������������������������������������������������������Ŀ
	//� Altera parametro que consiste somente 01 usuaria Incluido Clientes�
	//���������������������������������������������������������������������
	_lMvClie	:=	GetMv("MV_INCCLIE")
	Reclock("SX6",.F.) 
		SX6->X6_CONTEUD := ".T." 
	MsUnlock()
	//����������������������������������������������������������Ŀ
	//�Chamada da Funcao Padrao de Inclusao Cadastro de Clientes.�
	//������������������������������������������������������������
	  A030Inclui("SA1")

	//�������������������������������������������������������������������Ŀ
	//� LIBERA parametro que consiste somente 01 usuaria Incluido Clientes�
	//���������������������������������������������������������������������
	_lMvClie	:=	GetMv("MV_INCCLIE")
	Reclock("SX6",.F.) 
		SX6->X6_CONTEUD := ".F."
	MsUnlock()
	
Else
	MsgBox("Impossivel o acesso simultaneo ao Cadastro de clientes por mais de 01 usuario","ALERT")
Endif


RestArea(_aAreaM) 

Return
