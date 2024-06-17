/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ MTA650I    ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pto. de Entrada apos a inclusao de uma OP, onde entao vamos³±±
±±³          ³ chamar a rotina de inclusao de empenhos automaticamente.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650I

DbSelectArea("SD4")
_aAreaSD4	:= GetArea()

While .T.
	
	Alert("Efetue AGORA a manutencao dos empenhos para a OP: " + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
	// Chamando rotina de ajuste de empenhos
	MATA380()
	
	// Aqui teremos rotina para verificar se o usuario incluir algum empenho para a OP que estamos posicionados
	DbSelectArea("SD4")
	DbSetOrder(2)
	If !DbSeek(xFilial("SD4") + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD)
		Alert("Voce NAO INCLUIU nenhum empenho para OP: "+ SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN)
		If MsgYesNo("Sai sem incluir empenhos para a OP mencionada ?")
			exit
		Else
			Loop
		EndIf
	Else
		exit
	EndIf
	
EndDo

RestArea(_aAreaSD4)
Return()
