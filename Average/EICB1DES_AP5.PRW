#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "FWPrintSetup.ch"


User Function EICB1DES()        // incluido pelo assistente de conversao do AP5 IDE em 06/04/01

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ EICB1DES ³ Autor ³ AVERAGE - R.A.D.      ³ Data ³ 08/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ RDMake para incluir descricao da Comercial Vander          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

If MsgYesNo("Confirma a execucao do arquivo de descricoes ?")
   Processa({||GrvDescr()},"Processando Arquivos de Itens")
   Dbselectarea("SX3")
Endif   
// Substituido pelo assistente de conversao do AP5 IDE em 06/04/01 ==> __Return()    
Return()            // incluido pelo assistente de conversao do AP5 IDE em 06/04/01

//********------------------*
Static FUNCTION GrvDescr()
//********------------------*

ProcRegua(SB1->(LASTREC()))
SB1->(DBGOTOP())
DO WHILE !SB1->(EOF()) 
   If SB1->(RecLock("SB1",.F.))
      SB1->(MSMM(SB1->B1_DESC_P ,36,,SB1->B1_DESC,1,,,"SB1","B1_DESC_P" ))
      SB1->(MSMM(SB1->B1_DESC_GI,48,,SB1->B1_DESC,1,,,"SB1","B1_DESC_GI"))
      SB1->(MsUnlock())        
      IncProc("Processado Item : "+ SB1->B1_DESC+ " " + SB1->B1_COD)
    Endif 
    SB1->(DBSKIP())                                                       
ENDDO
RETURN
