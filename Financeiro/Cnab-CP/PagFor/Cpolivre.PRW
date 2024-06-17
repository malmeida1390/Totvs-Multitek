#include "rwmake.ch"      

User Function Cpolivre()        

// Pegar o campo livre do codigo de barras
// CNAB - REMESSA PARA O BRADESCO

_cAlias	:= GetArea()

_CLIVRE:= " "

IF SE2->E2_X_LEITO =="S"

	_CLIVRE:= SUBS(SE2->E2_X_CODBA,20,25)    

ELSE

	_CLIVRE:=SUBS(SE2->E2_X_CODBA,5,5)+SUBS(SE2->E2_X_CODBA,11,10)+SUBS(SE2->E2_X_CODBA,22,10)
                     
ENDIF

RestArea(_cAlias)

Return(_CLIVRE)