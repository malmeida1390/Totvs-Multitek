#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DiaComerc ºAutor  ³ Marcos Silva       º Data ³  23/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera verba de pagamento DIA DO COMERCIARIO, de acordo com   º±±
±±º          ³definicoes de Sindicatos.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracoes³26/11/04 - Sindicato 03 passou a pagar 1 dia para quem tem  º±±
±±º          ³           ate 180 dias de tempo de casa e 2 dias p/demais  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DiaComerc()

Private w_cVerba := w_cMes := w_cAno := w_cTipo := ""
Private w_nValor := 0

If val(DTOS(ddatadem)) > 0
	w_cMes 	:= substr(DTOS(ddatadem),5,2)
	w_cAno 	:= substr(DTOS(ddatadem),1,4)
	w_cTipo := "R"
Else
	w_cMes 	:= substr(DTOS(ddatabase),5,2)
	w_cAno 	:= substr(DTOS(ddatabase),1,4)
	w_cTipo	:= "M"
EndIf

//Se (Mes = 10) e (Sindicato = 01, 02 ou 03)
If w_cMes = "10" .and. (SRA->RA_SINDICA = "01" .or. SRA->RA_SINDICA = "02" .or. SRA->RA_SINDICA = "03")

	// verifica se eh rescisao
	If w_cTipo = "R"
		w_nDias := ddatadem - SRA->RA_ADMISSA
	Else
		w_nDias := ddatabase - SRA->RA_ADMISSA
	EndIf
	
	//Sindicato 01 ou 02
	If SRA->RA_SINDICA = "01" .or. SRA->RA_SINDICA = "02"  
		
		If 		w_nDias <= 90
			w_nDias := 0
		ElseIf  w_nDias <=180
			w_nDias := 1
		Else
			w_nDias := 2
		EndIf
	//Sindicato 03	
	Else  

		If  w_nDias <=180   //incluido em 26/11/04
			w_nDias := 1
		Else
			w_nDias := 2
		EndIf
	
	EndIf
	
	w_nValor := SALARIO
	
	//Se Comissionado, busca verbas de Comissao e DSR no SRC
	If SRA->RA_X_COMIS = "S"
		
		w_nValor := w_nValor + fBuscaPd("027,028")
	
	EndIf
*/	
	w_nValor := w_nValor/30 * w_nDias
	
	FGeraVerba("321",w_nValor,w_nDias)
	
EndIf

Return (nil)
