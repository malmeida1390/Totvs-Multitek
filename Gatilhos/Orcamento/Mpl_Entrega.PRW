#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Mpl_ENTREGA Autor ³ Almeida                ³ Data ³ 07/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gatilho para alteracao do campo CK_X_ENTRE                  ³±±
±±³          ³                                                             |±±
±±³          ³ Caso seje alterada a data de Entrega do orcamento sera      |±±
±±³          ³ alterada em todos os itens do Orcamento.                    |±±
±±³          ³ Deve ser incluida no Valide dos seguintes campos            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
   

