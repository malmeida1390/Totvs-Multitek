#include "rwmake.ch"

// * Função para mostrar tela de conferencia de frete * 
// Rodolfo - 05/05/08


User Function bgCnFret()

	Local oDlg
	Private cGetCid:= Space(6), nGetVal := 0, nGetPeso := 0
	Private aTransp := {}, oLbx

	DEFINE MSDIALOG oDlg TITLE 'Tela para conferência de frete' Of oMainWnd PIXEL From 0,0 To 300,520

	@ 10,05 SAY "Cidade"
	@ 20,05 GET cGetCid PICTURE "@!" F3 "SZZ" SIZE 40,8 VALID AtuLista()

	@ 10,70 SAY "Peso"
	@ 20,70 GET nGetPeso PICTURE "@E 999,999,999.99" SIZE 40,8 VALID AtuLista()

	@ 10,135 SAY "Valor"
	@ 20,135 GET nGetVal PICTURE "@E 999,999,999.99" SIZE 45,8 VALID AtuLista()

	@ 35,05 SAY "Transportadoras"
	@ 45,05 LISTBOX oLbx FIELDS HEADER "Cod", "Descricao", "Valor Frete", "Prazo de", "Prazo ate" SIZE 250,90 OF oDlg PIXEL

	AtuLista()

	ACTIVATE MSDIALOG oDlg CENTER

Static function AtuLista()

	aTransp := U_bgFrete(cGetCid, nGetPeso, nGetVal)
	oLbx:SetArray(aTransp)

	If Len(aTransp) > 0
		oLbx:bLine:={ || {aTransp[oLbx:nAt,1],aTransp[oLbx:nAt,6],Transform(aTransp[oLbx:nAt,4], "@E 9,999,999.99"),aTransp[oLbx:nAt,2],aTransp[oLbx:nAt,3]}}
	Else
		oLbx:bLine:={ || {,,,,}}
	EndIf

	oLbx:Refresh()