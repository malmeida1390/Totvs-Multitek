#include "rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MPL_SYD   | Autor �                        � Data � 16/09/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a tabela SYD durante chamada no campo B1_CLASFIS     ���
���          � Gatilho Cadastro de Produtos                                |��
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function MPL_GNMC()
  
Local aArea   := GetArea()


DbSelectArea("SYD")
DbSetOrder(1)

If DbSeek(xFilial("SYD")+M->B1_POSIPI)
   M->B1_IPI     := SYD->YD_PER_IPI
   M->B1_X_CLFIS := SYD->YD_X_CLFIS
   lRet := .t.
Else
   Aviso("ATENCAO", "Posicao do Ipi nao Cadastrada.",{"&Ok"})
   lRet := .f.
Endif
  
IF SYD->YD_MSBLQL = '1'
   Aviso("ATENCAO", "NCM Bloqueado",{"&Ok"})
   lRet := .f.
Endif

RestArea(aArea)

Return(lRet)

User Function AtuIPI()
Local aArea   := GetArea()

DbSelectArea("SYD")
DbSetOrder(1)

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
While !SB1->(Eof())
	If !Empty(SB1->B1_POSIPI)
		If SYD->(DbSeek(xFilial("SYD")+SB1->B1_POSIPI))
		   RecLock("SB1",.F.)
		   SB1->B1_IPI     := SYD->YD_PER_IPI
		   SB1->B1_X_CLFIS := SYD->YD_X_CLFIS
		   SB1->(msUnlock())
		Else
		   Aviso("ATENCAO", "Posicao do Ipi nao Cadastrada.",{"&Ok"})
		   lRet := .f.
		Endif
	EndIf
	SB1->(dbSkip())
EndDo	
RestArea(aArea)



Return .T.
