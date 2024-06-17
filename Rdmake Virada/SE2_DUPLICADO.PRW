#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION SE2_DUPLICADO
Local cParcela := "1"
Local _nRecno  := 0
Local _nRecnoIni:= 0


//
// Estas tabelas deverao ser  importadas
//
IF MsgBox( "O deseja continuar." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
	
	
	IF MsgBox( "Tem certeza disto"+"Deseja continuar?", "Limpar", "YESNO" )
		
		
		DbSelectArea("SE2")
		Dbsetorder(1)
		
		While !SE2->(Eof())
			
			cChave:=(SE2->E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
			
			_nRecnoIni:=SE2->(RECNO())  // Sempre vouta para o registro que originou a duplicidade ate nao haver nenhum mais repetido
			// pois podem haver mais de 2 repeticoes.
			
			SE2->(DBSKIP())
			
			_nRecno:=SE2->(RECNO())
			
			If cChave = SE2->E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
				
				cFilial :=SE2->E2_FILIAL
				cPrefixo:=SE2->E2_PREFIXO
				cNum    :=SE2->E2_NUM
				cParcela:=SE2->E2_PARCELA
				cTipo   :=SE2->E2_TIPO
				cFornece:=SE2->E2_FORNECE
				cLoja   :=SE2->E2_LOJA
				cpParcela:=SE2->E2_PARCELA
				
				
				DbSelectArea("SE2")
				DbSetOrder(1)
				While  (dbSeek( cFilial + cPrefixo + cNum + cParcela + cTipo + cFornece + cLoja ))
					cParcela := Soma1(cParcela)
				EndDo
				
				
				DbGoto(_nRecno)
				
				Reclock("SE2",.F.)
				SE2->E2_PARCELA:=cParcela
				MsUnlock()
				
				dbSelectArea("SE5")
				dbSetOrder(7)
				If dbSeek(xFilial("SE5")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
					While !Eof() .and. xFilial("SE5") == SE5->E5_FILIAL .and. ;
						SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE+E5_LOJA) == ;
						SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
						nAtuRec := SE5->(RECNO())
						dbSkip()
						nProxRec := SE5->(Recno())
						dbGoto(nAtuRec)
						RecLock("SE5")
						SE5->E5_PARCELA:=cParcela
						FKCOMMIT()
						dbGoto(nProxRec)
					Enddo
				Endif
				
				
				dbSelectArea("SEF")
				dbSetOrder(7)
				If dbSeek(xFilial("SEF")+"P"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO))
					While !Eof() .and. xFilial("SEF") == SEF->EF_FILIAL .and. ;
						SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO) == ;
						SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
						
						nAtuRec := SEF->(RECNO())
						dbSkip()
						nProxRec := SEF->(Recno())
						dbGoto(nAtuRec)
						
						If  SEF->(EF_FORNECE+EF_LOJA) == SE2->(E2_FORNECE+E2_LOJA)
							RecLock("SEF")
							SEF->EF_PARCELA:=cParcela
							MsUnlock()
							FKCOMMIT()
						Endif
						dbGoto(nProxRec)
					Enddo
				Endif
				
				
				dbSelectArea("SEA")
				dbSetOrder(1)
				If dbSeek(xFilial("SEA")+SE2->(E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO))
					While !Eof() .and. xFilial("SEA") == SEA->EA_FILIAL .and. ;
						SEA->(EA_NUMBOR+EA_PREFIXO+EA_TITULO+EA_PARCELA+EA_TIPO) == ;
						SE2->(E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
						
						nAtuRec := SEA->(RECNO())
						dbSkip()
						nProxRec := SEA->(Recno())
						dbGoto(nAtuRec)
						
						If SEA->(EA_FORNECE+EA_LOJA) == SE2->(E2_FORNECE+E2_LOJA)
							RecLock("SEA")
							SEA->EA_PARCELA:=cParcela
							MsUnlock()
							FKCOMMIT()
						Endif
						dbGoto(nProxRec)
					Enddo
				Endif
				
				
				DbSelectArea("SE2")
				DbGoto(_nRecnoIni)
				
				
			Endif
			
		Enddo
		
	Endif
	
Endif


Return

