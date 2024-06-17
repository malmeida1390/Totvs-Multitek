/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CON35650 ºAutor  ³Edelcio Cano        º Data ³  19/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Captura Conta Contabil da Natureza                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CON650FR()

Local _aAreaAt	:=	GetArea()
Local _nValor   := 0
Local _cNaturez := ""
Local _cConta   := ""


dbSelectArea("SE2")
_aAreaE2	:= GetArea()
DbOrderNickname("E2_13PREFI")    //22/07/2008_Virada_         //B1_X_SIMIL + EIS
//dbSetOrder(13)
dbGotop()

If dbSeek(xFilial("SE2")+SD1->D1_SERIE+SD1->D1_DOC+"NF "+SD1->D1_FORNECE+SD1->D1_LOJA)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Capatura Natureza ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cNaturez	:= SE2->E2_NATUREZ
	
	If Alltrim(_cNaturez) == "02029"
		_cConta	:= "115010005"
	ElseIf Alltrim(_cNaturez) == "02030"
		_cConta	:= "452010001"
	Else
		dbSelectArea("SED")
		_aAreaEB	:= GetArea()
		dbSetOrder(1)
		dbGoTop()
		
		If dbSeek(xFilial("SED")+_cNaturez)
			
			_cConta	:= SED->ED_CONTA
			
		Endif
	
	   	RestArea(_aAreaEB)
	EndIf
Endif

RestArea(_aAreaE2)
RestArea(_aAreaAt)

Return(_cConta)
	