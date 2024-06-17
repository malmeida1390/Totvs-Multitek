/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP597002 ºAutor  ³                    º Data ³  01/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retornar o valor de decrescimo do titulo                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                          

User Function LP596004(cDoc,cDoc1)
Local _aAreaAt  :=	GetArea()   
Local cAlias	:= getNextAlias()  
Local nRet		:= 0
Local nPref		:= TamSX3("E5_PREFIXO")[1]
Local nNumer	:= TamSX3("E5_NUMERO")[1]
Local nParc		:= TamSX3("E5_PARCELA")[1]
Local nTipo		:= TamSX3("E5_TIPO")[1]
Local cPref		:= substr(cDoc,1,nPref)
Local cNumero	:= substr(cDoc,nPref+1,nNumer)
Local cParc		:= substr(cDoc,nPref+1+nNumer,nParc)
Local cTipo		:= substr(cDoc,nPref+1+nNumer+nParc,nTipo)

Local cQry := "SELECT E5_VLDESCO FROM " + RetSqlName("SE5") 
cQry += " WHERE E5_FILIAL='"+xFilial("SE5") + "' AND E5_TIPO='"+cTIPO+"' AND D_E_L_E_T_ = ''"
cQry += " AND E5_PREFIXO='"+cPref+"'"
cQry += " AND E5_NUMERO='"+cNumero+"'"
cQry += " AND E5_PARCELA='"+cParc+"'"
cQry += " AND E5_DOCUMEN='"+cDoc1+"'"
cQry := ChangeQuery(cQry)    
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)
If !(cAlias)->(Eof())
	nRet := (cAlias)->E5_VLDESCO
EndIf
dbCloseArea(cAlias)
RestArea(_aAreaAt)	
Return(nRet)