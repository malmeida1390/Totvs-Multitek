#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MATA416A ³ Autor ³                       ³ Data ³ 11/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Gravar informacoes do Orcamento no Pedido durante a Lib.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mata416A()        // incluido pelo assistente de conversao do AP5 IDE em 20/12/01
Local aArea:= GetArea()

if Type("aPedProc") = "U"
	
	Public aPedProc  := {}  // Variavel especifica Multitek para controle de todos
	// os pedidos que estao sendo gerados dentro da rotina
	// automatica.
	// Esta variavel esta sendo alimentada dentro do ponto
	// de entrada MTA416PV.
	// E sera tratada no ultimo ponto de entrada MTA416FIM.
	
Endif


DbSelectArea("SX1")
DbSetorder(1)

If DbSeek("MT416A"+SPACE(4)+"01")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=""
	MsUnlock()
Endif

IF DbSeek("MT416A"+SPACE(4)+"02")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=""
	MsUnlock()
Endif

If DbSeek("MT416A"+SPACE(4)+"03")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=dtoc(dDataBase)
	MsUnlock()
Endif

If DbSeek("MT416A"+SPACE(4)+"04")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=dtoc(dDaTabase)
	MsUnlock()
Endif

RestArea(aArea)

Return
