
#include "rwmake.ch"      

User Function Pagdgcod()        

// Este programa tem como objetivo pegar o digito do codigo de barras


_CDIGCOD:= " "

IF SE2->E2_X_LEITO =="S"

	_CDIGCOD:= SUBS(SE2->E2_X_CODBA,5,1)    

ELSE

	_CDIGCOD:= SUBS(SE2->E2_X_CODBA,33,1)    

ENDIF

Return(_CDIGCOD)