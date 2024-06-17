#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/00

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT010INC  ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava a Descricao em Portugues/Ingles para Average           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT010ALT()

If SB1->B1_IMPORT = "S"

   // Esta funcao esta no programa matxfunb e pelo tratamento apresentado
   // nao permite alteracao logo tenho que excluir e incluir novamente.

    DbSelectArea("SB1")
	If SB1->(RecLock("SB1",.F.))
	   // Exclui 
  		SB1->(MSMM(SB1->B1_DESC_P ,36,,SB1->B1_DESC,2,,,"SB1","B1_DESC_P" ))  // Descr. Português
      SB1->(MSMM(SB1->B1_DESC_GI,48,,SB1->B1_DESC,2,,,"SB1","B1_DESC_GI"))  // Descr. LI
 	   SB1->(MSMM(SB1->B1_DESC_I ,48,,SB1->B1_DESC,2,,,"SB1","B1_DESC_I" ))  // Descr. Inglês
   
      // Incluir
     	SB1->(MSMM(SB1->B1_DESC_P ,36,,SB1->B1_DESC,1,,,"SB1","B1_DESC_P" ))  // Descr. Português
      SB1->(MSMM(SB1->B1_DESC_GI,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_GI"))  // Descr. LI
 	   SB1->(MSMM(SB1->B1_DESC_I ,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_I" ))  // Descr. Inglês
     	SB1->(MsUnlock())        
	Endif 

Endif		

Return
       