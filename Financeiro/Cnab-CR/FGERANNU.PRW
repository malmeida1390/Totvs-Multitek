#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#Include "RPTDEF.ch"

#DEFINE CLR_HGRAY  12632256

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SANTANDER ³ Autor ³                       ³ Data ³ 05/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO diversis bancos                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Atualização:								                              ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//
// FGERANNU - Esta funcao esta como user devido poder ser chamada 
//            pelo cnab , permitido enviar para o banco e emitir depois.
//            uso cnab - SUBSTR(U_FGERANNU('109'),1,8) 
//      SUBSTR(U_FGERANNU('109'),1,8)                                
User  Function FGERANNU(_cCart)
Local nNNumAtual := 0  // Numero 
Local nNNDigito  := 0  // Digito
Local cNossoNum  := ''

//-------- Definicao do NOSSO NUMERO
// Busca o nosso numero no SEE, sequencia de 8 digit
If Empty(SE1->E1_NUMBCO)

   nNNumAtual :=(VAL(SEE->EE_FAXATU)+1)  // No itau sao 8 Digitos
   cNNumAtual :=Strzero(nNNumAtual,7)
 	 
   DbSelectArea("SEE")
   DbSetOrder(1) 
   IF DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA))
      RecLock("SEE",.F.)
	  SEE->EE_FAXATU := cNNumAtual 
	  MsUnlock()  
   EndIF    
   
   
   //cNNumAtual:='0000463' //7      
       
   //-----------------------------
   // Definicao do NOSSO NUMERO
   // ----------------------------
   //nDVNNum		:= AllTrim( Str (Modulo10( SE1->E1_AGEDEP  + SE1->E1_CONTA + Alltrim(SEE->EE_CODCART) + cNNumAtual)))
   //nDVNNum		:= AllTrim(  Modulo10( alltrim(SE1->E1_AGEDEP)  + alltrim(SE1->E1_CONTA) + Alltrim(SEE->EE_CODCART) + alltrim(cNNumAtual)))

   nDVNNum		:= AllTrim(  Modulo11( alltrim(cNNumAtual) ) )
  

   DbSelectArea("SE1")
   RecLock("SE1",.F.)
   //SE1->E1_NUMBCO:=cNossoNum 
   SE1->E1_NUMBCO:=cNNumAtual + nDVNNum
   MsUnlock()  

Endif

cNossoNum := SE1->E1_NUMBCO

Return(cNossoNum)

