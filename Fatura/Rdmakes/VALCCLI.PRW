#INCLUDE "FIVEWIN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALCLIENTE�Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ativa Filtro no SXB (Industria ou Comercio) para o TES      ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALCCLI(cCliente)                                                      
Local lRet  := .t.
Local cLoja := ""

if Inclui

	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+cCliente)
		While !SA1->(EOF()) .and. xFilial("SA1")+cCliente = SA1->(A1_FILIAL+A1_COD)
			cLoja:=SA1->A1_LOJA
			SA1->(dbSkip())
		Enddo
		M->A1_LOJA:=STRZERO(  VAL(cLoja)+1 , 2  )
	Else
		M->A1_LOJA:="01"
	Endif

Endif

Return(lRet)

