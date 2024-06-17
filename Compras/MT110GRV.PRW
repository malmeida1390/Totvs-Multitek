#INCLUDE "Rwmake.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT150GRV  ºAutor  ³ Edelcio Cano       º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava na Solicitacao Nome do Fornecedor e Comprador        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110GRV() 
Local _aAreaAt := GetArea() 

Local cFornece := SC1->C1_FORNECE
Local cLoja    := SC1->C1_LOJA

//
// Posicona no Comprador
// 
SY1->(DbSelectArea("SY1"),DbSetorder(1),DbSeek(xFilial("SY1")+SC1->C1_CODCOMP))


/*
If Empty(cFornece)

	//
	//
	//
	SB1->(DbSelectArea("SB1"),DbSetorder(1),DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))

   cFornece := SB1->B1_X_FORN
   cLoja    := SB1->B1_X_LOJA
  
Endif
*/
 

//
// Posiciona na Fornecedor
//
SA2->(DbSelectArea("SA2"),DbSetorder(1),DbSeek(xFilial("SA2")+cFornece+cLoja))



If Altera .or. Inclui
                      
    DbSelectArea("SC1")
	If Reclock("SC1",.F.)
		SC1->C1_X_NOMFO := SA2->A2_NREDUZ // Nome do Fornecedor
		SC1->C1_X_NOMCP := SY1->Y1_NOME   // Nome do Comprador
		SC1->(MsUnlock())
	EndIf

Endif

RestArea(_aAreaAt)

Return