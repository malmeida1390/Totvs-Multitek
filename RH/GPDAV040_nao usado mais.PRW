#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPDAV040  ºAutor  ³ Marcos Silva       º Data ³  03/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera os dias de Aviso Previo (nDiasAv)                    º±±
±±º          ³													          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GPDAV040()
Local nxDias	:= 0
Local lAv1oano	:= .F.

M_CIND15D := "N"

// Se Dispensa sem Justa Causa e Aviso Previo Indenizado
If cTIPRES = "01"
	
	//************
	//SP ou Santos
	//************
	If 	SRA->RA_SINDICA = "01" .or. SRA->RA_SINDICA = "02" .or. SRA->RA_SINDICA = "03"
		If Calc_Tempo(ddatadem,SRA->RA_NASC) >= 45 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) >= 5
			If 	nDiasAv < 45
				nDiasAv := 45
			EndIf
		EndIf
	EndIf
	
	//************
	//Lajes-SC
	//************
	If	SRA->RA_SINDICA = "06"
		If Calc_Tempo(ddatadem,SRA->RA_ADMISSA) >= 5
			If 	nDiasAv < 60
				nDiasAv := 60
			EndIf
		EndIf
	EndIf
	
	//****************
	//Ponta Grossa-PR
	//****************
	If	SRA->RA_SINDICA = "07"
		If Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 5 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) <= 10
			If 	nDiasAv < 45
				nDiasAv := 45
			EndIf
		ElseIf	Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 10 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) <= 15
			If 	nDiasAv < 60
				nDiasAv := 60
			EndIf
		ElseIf	Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 15 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) <= 20
			If 	nDiasAv < 75
				nDiasAv := 75
			EndIf
		ElseIf	Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 20 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) <= 25
			If 	nDiasAv < 90
				nDiasAv := 90
			EndIf
		ElseIf	Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 25 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) <= 30
			If 	nDiasAv < 105
				nDiasAv := 105
			EndIf
		ElseIf	Calc_Tempo(ddatadem,SRA->RA_ADMISSA) > 30
			If 	nDiasAv < 120
				nDiasAv := 120
			EndIf
		EndIf
	EndIf
EndIf

// Se Dispensa sem Justa Causa e Aviso Trabalhado
If cTIPRES = "02"
	
	//************
	//SP ou Santos
	//************
	If 	SRA->RA_SINDICA = "01" .or. SRA->RA_SINDICA = "02" .or. SRA->RA_SINDICA = "03"
		If Calc_Tempo(ddatadem,SRA->RA_NASC) >= 45 .and. Calc_Tempo(ddatadem,SRA->RA_ADMISSA) >= 5
			M_cIND15D := "S"
		EndIf
	EndIf
	If cCompl # "S" //.and. !lRecRes
		//-- Aviso Prévio Trabalhado com geração de GRRF e pagamento de Saldo de Salário
		If cTipRes == "02" .And. aIncRes[2] == "I" .And. aIncRes[6] == "S" .And. aIncRes[15] == "S" .And. !(aIncRes[12]=="S" .Or. aIncRes[13]=="S")
			IF	nAnosCasa > 1 .And. ( dDatadem1 >= stod('20111013') )
				nDiasAv:= Max(0,nDiasAv-30)
				If nDiasAv > 60
					nDiasAv := 60
				Endif
			else
				nDiasAV := 0
			Endif        
		Endif
	Endif
	
	
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
