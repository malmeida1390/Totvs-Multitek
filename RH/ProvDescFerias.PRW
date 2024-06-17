/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PROVDESCFERIAS º Autor ³ Marcos Silva  º Data ³  26/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ No calculo de Ferias, gera verba de desconto a titulo de   º±±
±±º          ³ Provisao Desconto, procurando na movimentacao no SRD do mesº±±
±±º          ³ anterior, os codigos das verbas de Assist.Medica e Seguro  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Provdescferias()

If M->RH_DFERIAS >= 30

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	Private w_cString := w_cChave := w_cMes := w_cAno := ""
	Private w_nValor := w_nCont := 0
	
	w_cString := "564565"            //Coloque aqui as verbas que irao compor a provisao. Ex: "001002003"
	w_cMes := substr(dtos(ddatacomp),5,2)
	w_cAno := substr(dtos(ddatacomp),1,4)
	
	If w_cMes == "01"
		w_cMes := "12"
		w_cAno := strzero((val(w_cAno)-1),4)
	Else
 		w_cMes := strzero((val(w_cMes)-1),2)
	EndIf
	
	If val(w_cString) > 0
		dbSelectArea("SRD")
		dbSetOrder(1)
		w_nCont := 1
		For w_nCont := 1 to len(w_cString)
			w_cVerba := substr(w_cString,w_nCont,3)
			If val(w_cVerba) > 0
				w_cChave := xFilial("SRD")+SRA->RA_MAT+w_cAno+w_cMes+w_cVerba
				If dbSeek(w_cChave)
					While !EOF() .and. w_cChave == SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_DATARQ+SRD->RD_PD
						w_nValor := w_nValor + SRD->RD_VALOR
						dbSkip()
					EndDo
				EndIf
			EndIf
			w_nCont := w_nCont + 2
		Next (w_nCont)
		If w_nValor > 0
			Fgeraverba("568",w_nValor)
		EndIf
	EndIf

EndIf

Return


