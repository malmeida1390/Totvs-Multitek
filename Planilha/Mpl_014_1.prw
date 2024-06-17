#include "rwmake.ch"

User Function MPL_014_1(_cOpcao)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_014_1³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 31/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gatilho para validacoes no SZS                              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBSERV:   ³ ESTE PROGRAMA DEPENDE DE GATILHOS NO ZS_COD1 E ZS_COD2      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

_aArea := GetArea()
DbSelectArea("SZS")
_aAreaSZS := GetArea()
DbSelectArea("SZM")
_aAreaSZM := GetArea()
DbSelectArea("SZN")
_aAreaSZN := GetArea()

If _cOpcao == "1"

	DbSelectArea("SZM")
	DbSetOrder(1)
	If DbSeek(xFilial("SZM")+M->ZS_COD1)
		_cRetorno		:= M->ZS_COD1
		aCols[n,_nDescr1]	:= SZM->ZM_DESCR
	Else
	    MsgBox("Codigo de Popularidade NAO encontrado, verifique !","ALERT")
		_cRetorno 		:= Space(1)
		aCols[n,_nDescr1] 	:= Space(60)
	EndIf

	If !Empty(aCols[n,_nCod2])
	
		If M->ZS_COD1 <> "R" .and. aCols[n,_nCod2]$"NEO"
			MsgBox("O Codigo da Demanda (N),(E) ou (O) so podem ser utilizados com o Codigo de Popularidade (R)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr1] 	:= Space(60)
	    ElseIf M->ZS_COD1 <> "Q" .and. aCols[n,_nCOd2] == "I"
	    	MsgBox("O Codigo da Demanda (I) so pode ser utilizado com o Codigo de Popularidade (Q)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr1] 	:= Space(60)
	    ElseIf M->ZS_COD1 <> "P" .and. aCols[n,_nCOd2] == "L"
		    MsgBox("O Codigo da Demanda (L) so pode ser utilizado com o Codigo de Popularidade (P)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr1] 	:= Space(60)
	    EndIf
	    
	EndIf

Else
     
	DbSelectArea("SZN")
	DbSetOrder(1)
	If DbSeek(xFilial("SZN")+M->ZS_COD2)
		_cRetorno		:= M->ZS_COD2
		aCols[n,_nDescr2] 	:= SZN->ZN_DESCR
	Else
	    MsgBox("Codigo de Demanda NAO encontrado, verifique !","ALERT")
		_cRetorno 		:= Space(1)
		aCols[n,_nDescr2] 	:= Space(60)
	EndIf

	If !Empty(aCols[n,_nCod1])
	
		If M->ZS_COD2$"NEO" .and. aCols[n,_nCod1] <> "R"
			MsgBox("O Codigo da Demanda (N),(E) ou (O) so podem ser utilizados com o Codigo de Popularidade (R)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr2] 	:= Space(60)
	    ElseIf M->ZS_COD2 == "I" .and. aCols[n,_nCod1] <> "Q"
	    	MsgBox("O Codigo da Demanda (I) so pode ser utilizado com o Codigo de Popularidade (Q)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr2] 	:= Space(60)
	    ElseIf M->ZS_COD2 == "L" .and. aCols[n,_nCod1] <> "P"
		    MsgBox("O Codigo da Demanda (L) so pode ser utilizado com o Codigo de Popularidade (P)","ALERT")				 
			_cRetorno 		:= Space(1)
			aCols[n,_nDescr2] 	:= Space(60)
	    EndIf
	
	EndIf

EndIf

RestArea(_aAreaSZN)
RestArea(_aAreaSZM)
RestArea(_aAreaSZS)
RestArea(_aArea)

_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima

Return(_cRetorno)
