#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 03/04/00
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SF1100E   ³ Autor ³                              ³ 12/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exclusao da NF de Entrada ira gerar estorno no controle de  ³±±
±±³          ³Lotes.                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Multitek                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SF1100E()

Local aAreaDados := GetArea()
Local cChave     := SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
Local lAppend    := .T.          
Local cArmaFech  := GetMv("MV_ARMFECH")
Local cNumNF     := SF1->F1_DOC  	//Nr. da NF 
Local cSerie     := SF1->F1_SERIE	//Serie da NF
Local _aAreaCB0               
      
// Neste momento o SD1 ja foi excluido estou com o SF1 locado ao sair deste ponto
// o SF1 sera excluido.

IF  cFilAnt $ cArmaFech

	dbSelectArea("SZV")
	dbSetOrder(1) // ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_COD + ZV_ITEM
	If dbSeek(xFilial("SZV")+cChave)
		
		While !SZV->(EOF()) .and. cChave = SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			Reclock("SZV",.F.)
			DbDelete()
			MsUnlock()
			SZV->(DBSKIP())
		Enddo
		
	Endif

Endif

    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arq. de conferencia de NF ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Z20")
dbSetOrder(1)
If MsSeek(xFilial("Z20")+cNumNF+cSerie)
	
	dbSelectArea("Z21")
	dbSetOrder(1)
	MsSeek(xFilial("Z21")+cNumNF+cSerie)
	
	While !Z21->(Eof()) .AND. Z21->Z21_FILIAL == xFilial("Z21") .AND. ;
				Z21->Z21_DOC == cNumNF .AND. Z21->Z21_SERIE == cSerie
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui os itens de conferencia da NF ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("Z21",.F.,.T.)
		dbDelete()
		MsUnlock()		 
			
		Z21->(dbSkip())	
	Enddo

	RecLock("Z20",.F.,.T.)
	dbDelete()
	MsUnlock()		 	
    
	Alert("NF " + cNumNF + " de conferencia Handheld excluida com sucesso!")

Endif

// Criado pelo MA para limpar conteudo das etiquetas quando a NF for excluida pela rotina que classificou na NF

DbSelectArea("CB0")
_aAreaCB0 = GetArea()
DbSetorder(6)
If Dbseek(xFilial("CB0")+cChave)

   While CB0->(EOF()) .AND. CB0->CB0_FILIAL == xFilial("CBO") .AND. CB0->(CB0_NFENT+CB0_SERIEE+CB0_FORNEC+CB0_LOJAFO) == cChave  

	      Reclock("CB0",.F.)
		   CB0->CB0_NFENT 	:= ""
  		   CB0->CB0_SERIEE	:= ""
		   MsUnlock()
  		    
  		   CB0->(DBSKIP()) 
  		   
  	Enddo	   

Endif
  
RestArea(_aAreaCB0)

Return()