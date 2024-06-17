/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CON05597 ºAutor  ³Edelcio Cano        º Data ³  01/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica o Codigo do Fornec e define a Conta Contabil      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          

User Function CON05597()

Local _aAreaAt  :=	GetArea()
Local _cConta   := ""    
Local _cFornec	 := ""               
Local _cLoja    := ""
Local _cPref    := SE2->E2_PREFIXO 
Local _cNum	    := SE2->E2_NUM
Local _cTitOrig := SE2->E2_X_TITOR //Parcela+Tipo+Fornece+Loja

dbSelectArea("SE2")
_aAreaE2	:= GetArea()
dbSetOrder(1)          
dbGotop()

If dbSeek(xFilial("SE2")+_cPref+_cNum+_cTitOrig)
	_cFornec	:= SE2->E2_FORNECEC
	_cLoja	:= SE2->E2_LOJA
	dbSelectArea("SA2")
	_aAreaA2	:= GetArea()
	dbSetOrder(1)          
	dbGotop()
	If dbSeek(xFilial("SA2")+_cFornec+_cLoja)
	   _cConta   := SA2->A2_CONTA
	   RestArea(_aAreaA2)
	Else
		_cConta    := "Definir Conta
	   RestArea(_aAreaA2)
	Endif
Else
	_cConta    := "Definir Conta
	RestArea(_aAreaE2)
Endif

RestArea(_aAreaAt)	

Return(_cConta)