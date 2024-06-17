#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MANUT_SWA º Autor ³                  º Data ³  30/06/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para controlar Numeracao de Notas Fiscais º±±
±±º          ³ Evitando duplicacao de Numeracao                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 IDE - AVERAGE                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ]ÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//O Ponto solicitado já existe e se chama "MANUT_SWA". Como se trata de uma rotina comum que tr
//Ata inclusão, alterção e estorno o Analista deve verificar o valor da variável "nPos_aRotina", que p
//ara inclusão = 3; alteração = 4 e estorno = 5.
*----------------------*
User Function EICAP100()
*----------------------*
  
Local _aArea    := GetArea()
Local cPAram

If Paramixb == "MANUT_SWA" .and. nPos_aRotina = 4
	

   DbSelectArea("SWB")
	DbSetORder(1)
	
	If Dbseek(xFilial("SWB")+SWA->WA_HAWB)
		
		DbSelectArea("SE2")
		DbSetORder(1)
		
		If Dbseek(xFilial("SE2")+SWB->(WB_PREFIXO+WB_NUMDUP+WB_PARCELA+WB_TIPOTIT+WB_FORN+WB_LOJA))
			
			if  SE2->E2_SALDO=0  .AND. SE2->E2_BAIXA <> dDatabase
				Aviso("ATENCAO", "Titulo ja foi baixado portanto somente podera entrar nesta rotina na data de baixa."+CHR(13)+;
				"Data da Baixa:    "+DTOC(SE2->E2_BAIXA),{"&Ok"})
				lSair     := .T.
			Endif
			
		Endif
		
	Endif
	

Endif


If Paramixb == "APOS GRAVAR SWB" 
   		SE2->(DBSETORDER(1))   // 19/03/2012 - Atualiza a valores na tabela SE2
   		If SE2->(DBSEEK(xFilial()+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+SWB->WB_FORN+SWB->WB_LOJA)) 
			   
      			SE2->(RecLock("SE2",.F.))
      				SE2->E2_JUROS := 0      
      				//FLAVIO 10/10/2012 -> comentei essa linha porque apos o estorno da liquidacao ele passa por
      				//aqui e zera o saldo de forma indevida, ja que se o titulo foi estornado o saldo deve voltar a ter o valor original
      				//SE2->E2_SALDO := 0  
      			SE2->(MsUnlock())
   		EndIf

   		SE5->(DBSETORDER(2))   // 19/03/2012 - Deleta movimento de juros na tabela SE5
   		If SE5->(DBSEEK(xFilial()+"JR"+SWB->WB_PREFIXO+SWB->WB_NUMDUP+SWB->WB_PARCELA+SWB->WB_TIPOTIT+Dtos(SWB->WB_DT_DESE)+SWB->WB_FORN+SWB->WB_LOJA)) 
			   
      			SE5->(RecLock("SE5",.F.))
						SE5->(DbDelete())
      			SE2->(MsUnlock())
   		EndIf

EndIf
 
  
RestArea(_aArea)
  
Return .T.



