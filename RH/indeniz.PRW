#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INDENIZ   ºAutor  ³ Marcos Silva       º Data ³  23/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera verba de Indenizacao por tempo de Servico, sendo 1 dia º±±
±±º          ³de Salario por Ano trabalhado. Se Comissionado, acrescenta  º±±
±±º          ³media de Comissoes e DSR dos 3 ultimos meses	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Indeniz()

Private w_cVerba := w_cMes := w_cAno := ""
Private w_nValor := w_nCont := w_nQtde := w_nVTotal := 0


If SRA->RA_SINDICA = "01" .or. SRA->RA_SINDICA = "02" //Se Sindicato 01 ou 02
	
	w_cMes := substr(DTOS(ddatadem),5,2)
	w_cAno := substr(DTOS(ddatadem),1,4)
	
	//Se Comissionado, busca verbas de Comissao e DSR no acumulado (3 meses)
	If SRA->RA_X_COMIS = "S"
		
		dbSelectArea("SRD")
		dbSetOrder(1)
		
		//Procura verba "COMISSAO"
		w_nCont := 1
		For w_nCont := 1 to 3
			If w_cMes == "01"
				w_cMes := "12"
				w_cAno := strzero((val(w_cAno)-1),4)
			Else
				w_cMes := strzero((val(w_cMes)-1),2)
			EndIf
			w_cVerba := "027"
			If dbSeek(xFilial("SRD")+SRA->RA_MAT+w_cAno+w_cMes+w_cVerba)
				w_nValor := w_nValor + SRD->RD_VALOR
			EndIf
		Next
		
		//Procura verba "DSR COMISSAO"
		w_cMes := substr(DTOS(ddatadem),5,2)
 		w_cAno := substr(DTOS(ddatadem),1,4)

		w_nCont := 1
		For w_nCont := 1 to 3
			If w_cMes == "01"
				w_cMes := "12"
				w_cAno := strzero((val(w_cAno)-1),4)
			Else
				w_cMes := strzero((val(w_cMes)-1),2)
			EndIf
			w_cVerba := "028"
			If dbSeek(xFilial("SRD")+SRA->RA_MAT+w_cAno+w_cMes+w_cVerba)
				w_nValor := w_nValor + SRD->RD_VALOR
			EndIf
		Next
		
	EndIf
	
	w_nQtde := Calc_Tempo(ddatadem,SRA->RA_ADMISSA)
	w_nVTotal := ((SALARIO/30) + ((w_nValor/3)/30)) * int(w_nQtde)
	If w_nVTotal > 0
		FGeraVerba("227",w_nVTotal,int(w_nQtde))
	EndIf
	
EndIf

Return (nil)


//**********************************************
// Funcao para calculo de tempo entre duas datas
//**********************************************
Static Function CALC_TEMPO(w_dFinal,w_dInicial)

Local Diaa := Diab := Mesa := Mesb := w_nTempo := 0

w_nTempo := Year(w_dFinal) - Year(w_dInicial)

If w_nTempo < 0
	Return(0)
Endif

Diaa := Day(w_dInicial)
Diab := Day(w_dFinal)
Mesa := Month(w_dInicial)
Mesb := Month(w_dFinal)

If Mesb < Mesa
	w_nTempo -= 1
ElseIf Mesb = Mesa
	If Diab < Diaa
		w_nTempo -= 1
	EndIf
Else
	w_nTempo += ((Mesb-Mesa)/10)
Endif

Return w_nTempo
