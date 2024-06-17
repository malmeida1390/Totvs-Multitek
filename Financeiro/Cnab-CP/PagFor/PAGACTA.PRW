#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagacta()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_CTACED,")

/////  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA PARA O PORGRAMA DO
///// PAGFOR - POSICOES ( 105 - 117 )

_cALIAS  :=  GetArea()

_CTACED := "0000000000000"
   
IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"  

	IF SE2->E2_X_LEITO == "S"
    
    //_Ctaced  := SUBSTR(SE2->E2_X_CODBA,37,7)    
    _Ctaced  := STRZERO(VAL(SUBSTR(SE2->E2_X_CODBA,37,7)),13,0)
    ELSE
    
    _CTACED := STRZERO(VAL(SUBSTR(SE2->E2_X_CODBAR,24,7)),13,0)
 
    ENDIF

Else

     _Ctaced  := STRZERO(Val(SA2->A2_NUMCON),13,0)

EndIf
               

RestArea(_cAlias)

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_Ctaced)
Return(_Ctaced)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00