/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CON01530 ºAutor  ³Edelcio Cano        º Data ³  10/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica a Natureza e define a Conta Contabil              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          

User Function CON01530()

Local _aAreaAt  :=	GetArea()
Local _cConta   := ""    
Local _cPref    := SE2->E2_PREFIXO 
Local _cNum	    := SE2->E2_NUM
Local _cTitOrig	:= SE2->E2_X_TITOR //Parcela+Tipo+Fornece+Loja

dbSelectArea("SE2")
_aAreaE2	:= GetArea()
dbSetOrder(1)          
dbGotop()

//
// CUIDADO QUANDO INCLUIR UMA NOVA NATUREZA NESTA LINHA DEVE SER INCLUIDA NO PROGRAMA VLR01530
//

If dbSeek(xFilial("SE2")+_cPref+_cNum+_cTitOrig)
	If Alltrim(SE2->E2_NATUREZ)$"02106/02078/02082/02077/02075/02097/02098/02123/02124/02125/02090/02094/02079/02112/02138"
	     RestArea(_aAreaE2)
		_cConta   := "213030003"
	ElseIf Alltrim(SE2->E2_NATUREZ) $ "02005/02042"
	     RestArea(_aAreaE2)
		 _cConta   := "213030004"
	Endif
Else
	 RestArea(_aAreaE2)                    
	_cConta    := "Definir Conta"
Endif                          

RestArea(_aAreaAt)	

Return(_cConta)