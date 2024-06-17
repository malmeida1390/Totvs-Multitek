#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³De PAra Ativo ³ Autor ³ JULIO             ³ Data ³ 04-02-2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ De Para Ativo - SN3, SN4, SN5                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DePaATIV()

Aviso("De Para - Troca de contas do Ativo","Atencao!",{"Ok"})


Processa({||A001Import()},"Trocando contas do ATIVO. Aguarde...")


Return



Static Function A001Import()

Local nx := 0

PmsIncProc(.T.)
		
DbSelectArea("SN3")
DBGOTOP()
Do while !SN3->(EOF()) 

	DbSelectArea("SN1")
	DbSetOrder(1)	
	If  Dbseek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)
	
		DbSelectArea("SNG")
		DbSetOrder(1)	
		If Dbseek(xFilial("SNG")+SN1->N1_GRUPO)
	        Do 	CASE
	        	Case SN1->N1_GRUPO == "0001"
	        		cCCONTAB := "123010001"
	        		cCDEPREC := "123070002"
	        		cCCDEPR  := "434100001"
	         	Case SN1->N1_GRUPO == "0002"
	        		cCCONTAB := "123030001"
	        		cCDEPREC := "123070003"
	        		cCCDEPR  := "434100001"
	         	Case SN1->N1_GRUPO == "0003"
	        		cCCONTAB := "123040001"
	        		cCDEPREC := "123070004"
	        		cCCDEPR  := "434100001"
	         	Case SN1->N1_GRUPO == "0004"
	        		cCCONTAB := "123050001"
	        		cCDEPREC := "123070005"
	        		cCCDEPR  := "434100001"
	         	Case SN1->N1_GRUPO == "0005"
	        		cCCONTAB := "124010001"
	        		cCDEPREC := "124030001"
	        		cCCDEPR  := "434100002"
	         	Case SN1->N1_GRUPO == "0008"
	        		cCCONTAB := "124020001"
	        		cCDEPREC := "124030002"
	        		cCCDEPR  := "434100002"
	         	Case SN1->N1_GRUPO == "0009"
	        		cCCONTAB := "123050001"
	        		cCDEPREC := "123070005"
	        		cCCDEPR  := "434100001"
	        EndCASE
	        
    		Reclock("SN3",.F.)      
       			SN3->N3_CCONTAB := cCCONTAB
       			SN3->N3_CDEPREC := cCDEPREC
       			SN3->N3_CCDEPR  := cCCDEPR
 			MSUNLOCK()
 		Endif
    EndIF
	SN3->(DBSKIP())
	
EndDo

Return


