#include "rwmake.ch"      

User Function PAGVENVAL()        

// Pegar o campo fator de vencimento e valor do codigo de barras
// CNAB - PAGAR para ITAU

_cAlias	:= GetArea()

_PAGVENVAL:= " "

IF SE2->E2_X_LEITO =="S"

	_PAGVENVAL:= SUBS(SE2->E2_X_CODBA,6,4) + SUBS(SE2->E2_X_CODBA,10,10)    

ELSE

	_PAGVENVAL:= SUBS(SE2->E2_X_CODBA,34,4) + SUBS(SE2->E2_X_CODBA,38,10)   
                     
ENDIF

RestArea(_cAlias)

Return(_PAGVENVAL)