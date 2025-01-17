#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKOFF01  �Autor  �Anderson            � Data � 19/07/2005  ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao a ser colocada no Campo C6_PRODUTO via X3         ���
�������������������������������������������������������������������������͹��
���Uso       �Multi-Tek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
