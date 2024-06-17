#INCLUDE "rwmake.ch"
User Function SANTFOL()     
	Local cUltDsk

   		SEE->(DBSETORDER(1))   // - Atualiza a Sequencial na tabela SEE
   		If SEE->(DBSEEK(xFilial()+"033"+"0143 "+"08012869  "+"002")) 
			   
			   cULTDSK := SEE->EE_ULTDSK
			   cUltDSK   := soma1(cUltDSK)
      			SEE->(RecLock("SEE",.F.))
      				SEE->EE_ULTDSK:= cUltDsk
      			SEE->(MsUnlock()) 
      	ENDIF		
      			
Return(SEE->EE_ULTDSK)      	 		