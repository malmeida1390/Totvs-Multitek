#include "rwmake.ch"
#INCLUDE "VKEY.CH"


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MT340D3  � Autor �                        � Data � 24/03/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para liberacao do Endereco apos            ���
���          � acerto de Inventario originado do Mestre de Inventario      ���
���          � ONLINE.                                                     ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function MT340D3()

Local _aAreaBE
Local lOrigem      := IIF( "ACDA030" $ Upper(Funname()),.T.,.F.)


DbSelectArea("SBE")
_aAreaBE	:= GetArea()
                                 
if lOrigem

	DbSelectArea("SBE")
	DbSetORder(1)
	If DbSeek(xFilial("SBE") + SD3->D3_LOCAL + SD3->D3_LOCALIZ)
		RecLock("SBE",.F.)
		SBE->BE_DTINV	:=		CTOD("  /  /  ")
		MsUNlock()
	EndIF

Endif

RestArea(_aAreaBE)

Return

