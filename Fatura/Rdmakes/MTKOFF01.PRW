#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKOFF01  ºAutor  ³Anderson            º Data ³ 19/07/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao a ser colocada no Campo C6_PRODUTO via X3         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multi-Tek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTKOFF01()
Local _i := 0
Local _nColPro	:= aScan(AHEADER,{|e|Trim(e[2])=="C6_PRODUTO"})
Local _lReturn	:= .T.

If !Empty(M->C5_CLIENTE) .and. !Empty(M->C5_LOJACLI)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
		
		IF !Empty(SA1->A1_X_ALMOX) // Somente se o cliente for uma FILIAL MULTI-TEK
	
			_cDigPro	:= M->C6_PRODUTO
		
			For _i := 1 to Len(aCols)
			
				If _cDigPro == aCols[_i][_nColPro] .and. _i <> n
					Alert("Voce NAO pode repetir produtos em um Pedido para uma FILIAL MULTI-TEK, verifique !")
					_lReturn	:= .F.
				EndIf
			
			Next
    
		EndIf
		
	EndIf
	
Else

	Alert("Antes de digitar os itens voce deve informar o Cliente e Loja, Verifique!")
	//aCols[n][_nColPro]		:= Space(15)
    _lReturn	:= .F.
    
EndIf

Return(_lReturn)
