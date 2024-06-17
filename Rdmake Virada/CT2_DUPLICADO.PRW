#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION CT2_DUPLICADO
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
		
		DbSelectArea("CT2")
		Dbsetorder(1)
		
		While !CT2->(Eof())
			
			cChave:=CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQIDX)
			
			_nRecnoIni:=CT2->(RECNO())  // Sempre vouta para o registro que originou a duplicidade ate nao haver nenhum mais repetido
			// pois podem haver mais de 2 repeticoes.
			CT2->(DBSKIP())
			
			_nRecno:=CT2->(RECNO())
			
			If cChave = CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC+CT2_SEQIDX)
				
				cBloco1 :=CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC)
				cBloco2 :="00001"
				
				
				DbSelectArea("CT2")
				DbSetOrder(1)
				If dbSeek( cBloco1 )
					While !CT2->(EOF()) .AND. cBloco1 = CT2->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC)
						If cBloco2 = CT2_SEQIDX
							cBloco2 := Soma1(cBloco2)
						Endif
						CT2->(DBSKIP())
					Enddo
				Endif
				
				//While  (dbSeek( cBloco1 ))
				//    	cBloco2 := Soma1(cBloco2)
				//EndDo
				
				DbGoto(_nRecno)
				
				Reclock("CT2",.F.)
				CT2->CT2_SEQIDX := cBloco2
				MsUnlock()
				
				DbGoto(_nRecnoIni)
				
			Endif
			
		Enddo
		
	Endif
	
Endif

Return

