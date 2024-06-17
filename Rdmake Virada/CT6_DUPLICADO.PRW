#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION CT6_DUPLICADO
Local cParcela := "1"
Local _nRecno  := 0
Local _nRecnoIni:= 0
Local cBloco1  := ""
Local cBloco2  := ""


//
// Estas tabelas deverao ser  importadas
//
IF MsgBox( "O deseja continuar." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
	
	
	IF MsgBox( "Tem certeza disto"+"Deseja continuar?", "Limpar", "YESNO" )
		
		DbSelectArea("CT6")
		Dbsetorder(1)
		DbGotop()
		
		While !CT6->(Eof())
			
			cChave  := CT6->(CT6_FILIAL+DTOS(CT6_DATA)+CT6_LOTE+CT6_SBLOTE+CT6_MOEDA+CT6_TPSALD)
			
			nDebito :=CT6->CT6_DEBITO
			nCredit :=CT6->CT6_CREDIT
			//nDig    :=CT6->CT6_DIG
			
			
			_nRecnoIni:=CT6->(RECNO())  // Sempre vouta para o registro que originou a duplicidade ate nao haver nenhum mais repetido
			// pois podem haver mais de 2 repeticoes.
			CT6->(DBSKIP())
			
			If CT6->(Eof())
			   Exit
			Endif   
			
			If  cChave = CT6->(CT6_FILIAL+DTOS(CT6_DATA)+CT6_LOTE+CT6_SBLOTE+CT6_MOEDA+CT6_TPSALD)
				// .and.;
				//(CT6->CT6_DEBITO <> 0 .AND. CT6->CT6_CREDIT <> 0 .AND. CT6->CT6_DIG <> 0)
				
				nDebito := nDebito + CT6->CT6_DEBITO
				nCredit := nCredit + CT6->CT6_CREDIT
				nDig    := nDebito                                   //nDig    + CT6->CT6_DIG
				
				/*
				Reclock("CT6",.F.)
				CT6->CT6_DEBITO := 0
				CT6->CT6_CREDIT := 0
				CT6->CT6_DIG    := 0
				MsUnlock()
				*/
				
				Reclock("CT6",.F.)
				DbDelete()
				MsUnlock()
				
				DbGoto(_nRecnoIni)
				
				Reclock("CT6",.F.)
				CT6->CT6_DEBITO := nDebito
				CT6->CT6_CREDIT := nCredit
				CT6->CT6_DIG    := nDig
				MsUnlock()
				
				
			Endif
			
		Enddo
		
		
	Endif
	
Endif

Return




