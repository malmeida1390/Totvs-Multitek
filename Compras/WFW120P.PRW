#INCLUDE "Rwmake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFW120P   �Autor  � Edelcio Cano       � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava o Nome do Comprador apos a Gravacao do PC, quando PC  ���
���          �for Digitado diretamente.                                   ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WFW120P()

Local _aAreaAt := GetArea()
Local _cNum 	:= SC7->C7_NUM
Local _cNumSc   := SC7->C7_NUMSC
Local _cSolicit := " "

           
DbSelectArea("SC7")
DbSetOrder(1)                  
DbGoTop()  // Forca pegar o primeiro visto poder haver varios itens no pedido
If dbSeek(xFilial("SC7")+_cNum)
	
	While !SC7->(Eof()) .and. xFilial("SC7")+_cNum == SC7->C7_FILIAL+SC7->C7_NUM
	
		//SY1->(DbSelectArea("SY1"),DbSetorder(1),DbSeek(xFilial("SY1")+SC1->C1_CODCOMP))
		DbSelectArea("SC1")
		DbSetorder(1)
		If DbSeek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC) 
           _cSolicit := SC1->C1_SOLICIT
		Endif

		
		// Caso de pedidos manuais sem SC, o campo permite o usuario preencher na hora do pedido.
		// Logo mantem o numero.
		If !Empty(SC7->C7_X_NOMSL)
           _cSolicit := SC7->C7_X_NOMSL
       	Endif
		       
		
		DbSelectArea("SC7")
		Reclock("SC7",.F.)
		SC7->C7_X_NOMCP	:= UPPER(UsrRetName(SC7->C7_USER))   //SY1->Y1_NOME
	    SC7->C7_X_NOMSL	:= UPPER(_cSolicit)
		MsUnlock()
		
		SC7->(dbSkip())
		
	Enddo                             
	
Endif

RestArea(_aAreaAt)

Return


User function AtuaSC7()

Local _aAreaAt := GetArea()
Local _cNum 	:= SC7->C7_NUM
Local _cNumSc   := SC7->C7_NUMSC
Local _cSolicit := " "



DbSelectArea("SC7")
DbSetOrder(1)
DbGotop()

While !SC7->(Eof())
	
		//SY1->(DbSelectArea("SY1"),DbSetorder(1),DbSeek(xFilial("SY1")+SC1->C1_CODCOMP))
		
		DbSelectArea("SC1")
		DbSetorder(1)
		If DbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC) 
           _cSolicit := SC1->C1_SOLICIT
		Endif

		// Caso de pedidos manuais sem SC, o campo permite o usuario preencher na hora do pedido.
		// Logo mantem o numero.
		If !Empty(SC7->C7_X_NOMSL)
           _cSolicit := SC7->C7_X_NOMSL
       	Endif
		
		Reclock("SC7",.F.)
		SC7->C7_X_NOMCP	:= UsrRetName(SC7->C7_USER)   //SY1->Y1_NOME
		SC7->C7_X_NOMSL	:= _cSolicit
		MsUnlock()
		
		SC7->(dbSkip())
		
Enddo                             
	
RestArea(_aAreaAt)

Return
