#INCLUDE "Acda100.ch"
#include "FiveWin.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACD166VL  ³ Autor ³                       ³ Data ³ 29/10/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trava Exclusao da Orgem de Separacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD166VL()

Local lhabilita := .T.  // Bloqueia a Ordem por Ordem de Separacao
Local aAreaSC9 := GetArea("SC9")


DbSelectArea("SC9")
DbSetOrder(1)

If SC9->(DbSeek(xFilial("SC9")+CB7->CB7_PEDIDO))

   While !SC9->(EOF()) .and.  xFilial("SC9")+CB7->CB7_PEDIDO = SC9->(C9_FILIAL+C9_PEDIDO)
                                                              
         // VERIFICO SE A ORDEM DE SEPARACAO ESTA VINCULADA A ALGUMA NOTA EMITIDA
         //
         If !Empty(SC9->C9_NFISCAL) .and.  CB7->CB7_ORDSEP = SC9->C9_ORDSEP
     			lhabilita := .F.
			Endif
         SC9->(DBSKIP())

	Enddo			

EndIf


If ! lhabilita
	VTAlert("Nota fiscal ja emitida. Para ser alterado deve ser excluido a Nota Fiscal.")
Else
   DbSelectArea("SC9")
	DbOrderNickname("SC9ORDSEP")                //B1_X_REFER + B1_X_SIMIL
   If DbSeek(xFilial("SC9")+CB7->CB7_ORDSEP)
      While !SC9->(EOF()) .and.  xFilial("SC9")+CB7->CB7_ORDSEP = SC9->(C9_FILIAL+C9_ORDSEP)
      		SC9->(RECLOCK("SC9",.F.))
	      	SC9->C9_X_STATU := "9"
	         SC9->(MSUNLOCK())
            SC9->(DBSKIP())
      Enddo       
   Endif
Endif

RestArea(aAreaSC9)

Return lhabilita
