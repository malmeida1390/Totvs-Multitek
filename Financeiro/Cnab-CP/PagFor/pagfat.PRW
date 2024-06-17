#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 31/05/00

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFAT    ºAutor  ³Microsiga           º Data ³  11/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao do programa para tratamento das retencoes de     º±±
±±º          ³ PIS/Cofins/Csll, Decrescimo e Acrescimo - Edelcio Cano     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Pagfat()    

SetPrvt("_FATOR,")   

_FATOR    :="00000000000000"
_nValDoc  := 0
_nValDesc := 0

//_nValDesc := SE2->E2_VALOR - SE2->E2_SALDO

If SE2->E2_X_LEITO == "S"
	
	//Usa Leitor
	If Val(SubStr(SE2->E2_X_CODBA,10,10)) <> 0//Boletos s/ valor definido
		
		_nValDoc := SE2->E2_VALOR - (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
		_Fator   := StrZero(Val(SubStr(SE2->E2_X_CODBA,06,4)),4)+ StrZero(_nValDoc*100,10)
		
	Endif
Else
	//Digitado
	If Val(SubStr(SE2->E2_X_CODBA,38,10)) <> 0 //Boletos s/ valor definido
   	
   	_nValDoc   := SE2->E2_VALOR - (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
	   _Fator     := StrZero(Val(SubStr(SE2->E2_X_CODBA,34,4)),4)+ StrZero(_nValDoc*100,10)
	    
	Endif
Endif    
     
Return(_FATOR)   