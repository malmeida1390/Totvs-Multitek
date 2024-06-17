#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION CTC_DUPLICADO
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
		
		DbSelectArea("CTC")
		Dbsetorder(1)
		//DbGoto(25676)
		DbGoto()
		
		While !CTC->(Eof())
			
			cChave  :=CTC->(CTC_FILIAL+DTOS(CTC_DATA)+CTC_LOTE+CTC_SBLOTE+CTC_DOC+CTC_MOEDA+CTC_TPSALD)
			
			nDebito :=CTC->CTC_DEBITO
			nCredit :=CTC->CTC_CREDIT
			//nDig    :=CTC->CTC_DIG
			
			
			_nRecnoIni:=CTC->(RECNO())  // Sempre vouta para o registro que originou a duplicidade ate nao haver nenhum mais repetido
			// pois podem haver mais de 2 repeticoes.
			CTC->(DBSKIP())
			
			If CTC->(Eof())
				Exit
			Endif
			
			If  cChave = CTC->(CTC_FILIAL+DTOS(CTC_DATA)+CTC_LOTE+CTC_SBLOTE+CTC_DOC+CTC_MOEDA+CTC_TPSALD)
				
				nDebito := nDebito + CTC->CTC_DEBITO
				nCredit := nCredit + CTC->CTC_CREDIT
				nDig    := nDebito + nCredit                        //nDig    + CTC->CTC_DIG
				
				/*
				Reclock("CTC",.F.)
				CTC->CTC_DEBITO := 0
				CTC->CTC_CREDIT := 0
				CTC->CTC_DIG    := 0
				MsUnlock()
				*/
				
				Reclock("CTC",.F.)
				DbDelete()
				MsUnlock()
				
				DbGoto(_nRecnoIni)
				
				Reclock("CTC",.F.)
				CTC->CTC_DEBITO := nDebito
				CTC->CTC_CREDIT := nCredit
				CTC->CTC_DIG    := nDig
				MsUnlock()
				
			Endif
			
		Enddo
		
		
	Endif
	
Endif

Return




