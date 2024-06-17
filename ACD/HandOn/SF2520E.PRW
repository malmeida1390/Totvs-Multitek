/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³Anderson            º Data ³  20/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para efetuar a atualizacao da informacao daº±±
±±º          ³Nota Fiscal na Tabela CB0                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E

_aArea		:= GetArea()
DbSelectArea("SA1")
_aAreaSA1	:= GetArea()
DbSelectArea("CB0")
_aAreaCB0	:= GetArea()



		
DBSelectArea("CB0")
DbSetOrder(9)     // CB0_FILIAL+CB0_NFSAI+CB0_SERIES+CB_CODPRO
DbGoTop()
		
If DbSeek(xFilial("CB0")+SF2->F2_DOC+SF2->F2_SERIE)
	
	While	 !(CB0->(EOF())) .and. xFilial("CB0")+SF2->F2_DOC+SF2->F2_SERIE = CB0->(CB0_FILIAL+CB0_NFSAI+CB0_SERIES)
	
		
		//
		// Deve ser colocada AQUI rotina para gerar o LOG da Etiqueta antes de Altera-la(CBG)
		//CBLog("05",{CB9->CB9_PROD,1,NIL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,NIL,CB0->CB0_CODETI,"M460FIM - Material enviado ao Cliente (Faturamento) "})
		//
		DbSelectArea("CBG")
		DbSetOrder(0)
		Reclock("CBG",.T.)
		CBG_FILIAL:= xFilial("CBG")
		CBG_DATA  := dDataBase
		CBG_HORA  := TIME()
		CBG_EVENTO:= "09"
		CBG_USUARI:= __cUserID
		CBG_CODPRO:= CB0->CB0_CODPRO
		CBG_ARM   := CB0->CB0_LOCAL
		CBG_END   := CB0->CB0_LOCALIZ
		CBG_QTDE  := 1
		CBG_OBS   := "SF2520E - Exclusao Nota Fiscal"
		CBG_NOTAS := SF2->F2_DOC
		CBG_SERIES:= SF2->F2_SERIE
		CBG_CLI   := SF2->F2_CLIENTE
		CBG_LOJCLI:= SF2->F2_LOJA
		CBG_ORDSEP:= ""
		CBG_CODETI:= CB0->CB0_CODETI
		MsUnlock()
		
		
		RecLock("CB0",.F.)
		CB0->CB0_NFSAI	   := Space(6)
		CB0->CB0_SERIES	:= Space(3)
		CB0->CB0_CLI      := Space(6)
		CB0->CB0_LOJACL   := Space(2)
		CB0->CB0_TRANSP   := Space(6)
      CB0_VOLUME        := ""
 		MsUnlock()
		
		CB0->(DBSKIP()) 
		
	EndDo
	
Endif
	

//Restaurando Areas
RestArea(_aAreaSA1)
RestArea(_aAreaCB0)
RestArea(_aArea)

Return
