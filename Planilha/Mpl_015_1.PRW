#include "rwmake.ch"

User Function MPL_015_1(_cOpcao)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MPL_015_1� Autor � Anderson Kurtinaitis   � Data � 01/04/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Gatilho para validacoes no SZT                              ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
��������������������������������������������������������������������������Ĵ��
���OBSERV:   � ESTE PROGRAMA DEPENDE DE GATILHOS NO ZT_CODIGO E ZT_ORIG    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

_aArea := GetArea()
DbSelectArea("SZT")
_aAreaSZT := GetArea()
DbSelectArea("SZR")
_aAreaSZR := GetArea()

If _cOpcao == "1" // Quando estiver no campo Codigo

	DbSelectArea("SZR")
	DbSetOrder(1)
	If DbSeek(xFilial("SZR")+M->ZT_CODIGO)
		_cRetorno		:= M->ZT_CODIGO
		aCols[n,_nDescr]	:= SZR->ZR_DESCR
		If !Empty(aCols[n,_nOrig])
	   		aCols[n,_nCodAux] := M->ZT_CODIGO + aCols[n,_nOrig]
   		EndIf
	Else
	    MsgBox("Codigo de Classificacao ABC nao encontrado, verifique !","ALERT")
		_cRetorno 		:= Space(1)
		aCols[n,_nDescr] 	:= Space(60)
		aCols[n,_nCodAux]  := Space(2)
	EndIf

Else // Quando estiver no campo Origem
     
	_cRetorno := M->ZT_ORIG 
	
	If !Empty(aCols[n,_nCodigo])
		aCols[n,_nCodAux] := aCols[n,_nCodigo] + M->ZT_ORIG
	EndIf

EndIf

RestArea(_aAreaSZR)
RestArea(_aAreaSZT)
RestArea(_aArea)

_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima

Return(_cRetorno)
