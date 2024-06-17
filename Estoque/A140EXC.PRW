#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/04/00
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A140EXC   ³ Autor ³                              ³ 29/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exclusao da NF de Pre NF de Entrada ajustando arquivo CB0   ³±±
±±³          ³ajustando  etqs. (elimina cod fornecedor).                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Multitek                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function A140EXC()

Local aAreaDados := GetArea()
Local cChave     := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
Local _aAreaCB0	



DbSelectArea("CB0")
_aAreaCB0 = GetArea()
DbSetorder(6)
If Dbseek(xFilial("CB0")+cChave)

   While CB0->(EOF()) .AND. CB0->CB0_FILIAL == xFilial("CBO") .AND. CB0->(CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO) == cChave  
                                    
         // Apesar da Exclusao ser efetuada pelo Template do Acd.
         // Foi necessario a criacao deste ponto de entrada devido a exclusao
         // solicitada pelo AVERAGE.
         
         // Foi definido que deletar e a melhor opcao devido deixando 
         // em branco o usuario pode garar nota / emitir etiqueta / colar etiqueta/
         // depois trazer para nos dizendo que o CB0_LOCALIZ esta em branco.
         
	      //Reclock("CB0",.F.)
		   //CB0->CB0_NFENT 	:= ""
  		   //CB0->CB0_SERIEE	:= ""
		   //MsUnlock()

			RecLock("CB0",.F.)
			DbDelete()
			MsUnlock()

  		   CB0->(DBSKIP()) 
  		   
  	Enddo	   

Endif

  
RestArea(_aAreaCB0)
RestArea(aAreaDados)

Return(.T.)