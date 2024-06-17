#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

User Function Pdtdes()        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_DTDES,")

// PROGRAMA PARA VERIFICAR SE  DESCONTO NO TITULO, CASO AFIRMATIVO RETORNA A
// DATA DO DESCONTO, CASO CONTRARIO ZEROS  CNAB - REMESSA PARA O BRADESCO
// FERNANDO - 09/03/98


_DTDES  := "      "
_NVALOR := 0

IF SUBSTR(SE2->E2_X_CODBA,6,14) == "00000000000000" .AND. SUBSTR(SE2->E2_X_CODBA,1,3) #"   "

    _DTDES := "00000000"

Else

//    _DTDES := IF((SE2->E2_VALOR-SE2->E2_SALDO+SE2->E2_DESCONT) = 0,"00000000",DTOS(SE2->E2_VENCREA))
//	   _DTDES := IF((SE2->E2_DECRESC) = 0,"00000000",DTOS(SE2->E2_VENCREA))
	                                                                                                           
	   IF (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL) = 0 
	   
			_DTDES := IF((SE2->E2_DECRESC + (SE2->E2_VALOR - SE2->E2_SALDO))= 0,"00000000",DTOS(SE2->E2_VENCREA))
      Else
         
			_NVALOR	:= SE2->E2_VALOR - (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
			
	      _DTDES := IF((SE2->E2_DECRESC + (_NVALOR - SE2->E2_SALDO))= 0,"00000000",DTOS(SE2->E2_VENCREA))
	   ENDIF   


ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> __RETURN(_DTDES)
Return(_DTDES)        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00