#include "rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �Mpl_ENTREGA Autor � Almeida                � Data � 07/04/05 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho para alteracao do campo CK_X_ENTRE                  ���
���          �                                                             |��
���          � Caso seje alterada a data de Entrega do orcamento sera      |��
���          � alterada em todos os itens do Orcamento.                    |��
���          � Deve ser incluida no Valide dos seguintes campos            |��
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function Mpl_ENTREGA()
Local _area:= GetArea()

DbSelectArea("TMP1")
DbGotop()

While !TMP1->(EOF())
	
	Reclock("TMP1",.f.)
	TMP1->CK_X_ENTRE:= M->CJ_X_DTPRE // Data de Entrega
	MsUnlock()
	
	TMP1->(DBSKIP())
	
Enddo

DbGotop()

RestArea(_area)
        
ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento ou Contrato

Return(M->CJ_X_DTPRE)

                                                 
User Function VAL_ENTREGA()

Local lRet := .T.

IF M->CJ_X_DTPRE > M->CJ_VALIDA
   Aviso("ATENCAO" , "Data Invalida. A data validade do orcamento deve ser maior que a data prevista para entrega.",{"&Ok"})
   lRet := .f.
Endif
   
Return(lRet)
   

