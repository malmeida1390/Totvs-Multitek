#include "protheus.ch"
/*/
Rotina para calculo de frete - Rodolfo - 06/2007
/*/

User Function bgFrtSA1(cCodSA1, nPeso, nValNota, cTransp)
	Local aTransp := {}
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCodSA1)
	
	If Empty(A1_BGREDES)
		cCodMun := A1_BGCODMU
	Else
		If Empty(A1_BGMNRDC)
			cCodMun := "009668" // São Paulo
		Else
			cCodMun := A1_BGMNRDC
		Endif
	Endif
	
Return u_bgFrete(cCodMun, nPeso, nValNota, cTransp)
        

User Function bgFrete(cCodMun, nPeso, nValNota, cTransp)
	
	Local aTransp := {}
	Local cCodReg := ""
	Local cCodTransp
	Local cDescTransp := ""
	Local nADM
	Local nADV
	Local nCont
	Local nGRIS
	Local nOutros
	Local nPedagio
	Local nTRT
	Local nPreco
	Local nPrecoFrete
	Local nTAS
	Local nTaxa
	Local nPorcNota
	Local nTotali
	Local nVMFRETE
	Local nPMFRETE
	Local nPrazoDe
	Local nPrazoAte
	Local nRecNo
	DEFAULT cTransp := ""                           
	
	nPeso := Round(nPeso, 2) + 0.01

	If nPeso <> 0 .And. nValNota <> 0

		dbSelectArea("SZD") // Município por região
		dbSetOrder(2)
		
		dbSelectArea("SZO") // Regiões
		If cTransp == ""
			dbSetOrder(1)
		Else
			dbSetOrder(3)
		EndIf

		dbSelectArea("SZN") // Taxas e Preços
		dbSetOrder(1)
		
		dbSelectArea("SZJ") // Faixas de Peso
		dbSetOrder(1)
		
		// Acha em quais regiões o município se encontra
		SZD->(dbSeek(xFilial("SZD")+cCodMun))
		While SZD->(!Eof() .And. ZD_MUN == cCodMun)
			
			cCodReg := SZD->ZD_REGIAO
			If SZO->(dbSeek(xFilial()+cTransp+cCodReg)) .And. SZN->(dbSeek(xFilial()+cCodReg))
				cCodTransp := SZO->ZO_TRANSP
				
				SZJ->(dbSeek(xFilial()+cCodReg+Str(nPeso,9,2), .T.)) //SoftSeek
				
				If SZJ->(!Eof() .And. cCodReg == ZJ_REGIAO .And. nPeso > ZJ_PESODE .And. nPeso <= ZJ_PESOATE)
					nPreco := SZJ->ZJ_VALOR                                                                  

					/*murilo - 20/07/2011 - ticket 436*/
					If nPreco = 0  //se preco é zero é pq valor fixo da faixa é zero portanto deve-se multiplicar todo o peso pelo valor por kilo
						nPreco = SZJ->ZJ_VALOREX * nPeso
					Else //senao, soma-se ao valor fixo a multiplicacao do peso excedente pelo valor por kilo
						nPreco += SZJ->ZJ_VALOREX * (nPeso - SZJ->ZJ_PESODE)
					Endif
					/*fim - 20/07/2011 - ticket 436*/						

					If SZJ->ZJ_GRIS > 0
						nGRIS := SZJ->ZJ_GRIS * (nValNota/100)
					Else
						nGRIS := SZN->ZN_GRIS * (nValNota/100)
					EndIf

					If nGRIS < SZN->ZN_GRISMIN
						nGRIS := SZN->ZN_GRISMIN
					Endif
					
					If SZJ->ZJ_ADV > 0
						nADV := SZJ->ZJ_ADV * (nValNota/100)
					Else
						nADV := SZN->ZN_ADV * (nValNota/100)
					EndIf
					
					nTaxa := SZN->ZN_TAXA
					nOutros := SZN->ZN_OUTROS * (nValNota/100)
					If SZN->ZN_PESOPED > 0
							nPedagio := SZN->ZN_PEDAGIO * (Int(nPeso / SZN->ZN_PESOPED)+1)
					Else
						nPedagio := SZN->ZN_PEDAGIO
					Endif
					nADM := SZN->ZN_ADM
					nTAS := SZN->ZN_TAS
					nVMFRETE := SZN->ZN_VMFRETE
					nPMFRETE := SZN->ZN_PMFRETE
					If SZD->ZD_PRAZDE > 0
						nPrazoDe  := SZD->ZD_PRAZDE
					Else
						nPrazoDe  := SZN->ZN_PRAZDE
					EndIf
					If SZD->ZD_PRAZATE > 0
						nPrazoAte  := SZD->ZD_PRAZATE
					Else
						nPrazoAte := SZN->ZN_PRAZATE
					EndIf

					nTotali := (nTaxa + nADV + nGRIS + nOutros + nPedagio + nTAS)
					
					If nPreco < (nPMFRETE * (nValNota/100))
						nPreco := (nPMFRETE * (nValNota/100))
					Endif

					nPrecoFrete := (nTotali + nPreco)
					nADM := nADM * (nPrecoFrete/100)
					
					nPrecoFrete := Round((nPreco + nTotali + nADM),2)
									
					if nPrecoFrete < nVMFRETE
						nPrecoFrete := nVMFRETE
					Endif
					
					nTRT := SZN->ZN_TRT * (nPrecoFrete/100)
					If nTRT < SZN->ZN_TRTMIN 
						nTRT := SZN->ZN_TRTMIN
					Endif 
					
					nPrecoFrete += nTRT
					
					nPorcNota := Round(((nPrecoFrete * 100)/nValNota),2)
					
					cDescTransp := Posicione("SA4",1,xFilial("SA4")+cCodTransp,"A4_NREDUZ")
					Aadd(aTransp, {cCodTransp, nPrazoDe, nPrazoAte, nPrecoFrete, nPorcNota, cDescTransp})
				EndIf
			EndIf
			SZD->(dbSkip())
		Enddo
		
		aSort(aTransp,,, { |x, y| IIf(x[3] <> y[3], x[3] < y[3], x[4] < y[4]) })
	EndIf
	
	Return aTransp
