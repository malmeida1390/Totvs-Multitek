/*
*/

#include "rwmake.ch"        

*-----------------------*
User Function GrvSB1Ing()
*-----------------------*     

If MsgYesNo("Confirma a execucao do arquivo de descricoes ?")
   Processa({||GrvDescr()},"Processando Arquivos de Itens")
   Dbselectarea("SX3")
Endif   

Return 




*------------------------*
Static FUNCTION GrvDescr()
*------------------------*

ProcRegua(SB1->(LASTREC()))

SB1->(DBGOTOP())
DO WHILE !SB1->(EOF())            
	If SB1->B1_IMPORT = "S" .AND. EMPTY(SB1->B1_DESC_P)  
	    DbSelectArea("SB1")
		If SB1->(RecLock("SB1",.F.))
   		SB1->(MSMM(SB1->B1_DESC_P ,36,,SB1->B1_DESC,1,,,"SB1","B1_DESC_P" ))  // Descr. Português
	      SB1->(MSMM(SB1->B1_DESC_GI,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_GI"))  // Descr. LI
   	   SB1->(MSMM(SB1->B1_DESC_I ,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_I" ))  // Descr. Inglês
      	SB1->(MsUnlock())        
	      IncProc("Item gravado: " + SB1->B1_COD + " - " + SB1->B1_DESC)
		Endif 
	Endif		
   SB1->(DBSKIP())                                                       
ENDDO

Return