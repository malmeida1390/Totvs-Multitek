#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagdgag()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4,_MULT")
SetPrvt("_RESUL,_RESTO,_DIGITO,")

////  PROGRAMA PARA CALCULO DO DIGITO DE CONTROLE DA AGENCIA BRADESCO
////  PAGFOR POSICAO ( 104 - 104 )

_RETDIG  := "0"

IF SE2->E2_X_LEITO == "S"
	
	IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"
		
		_RETDIG := " "
		_DIG1   := SUBSTR(SE2->E2_X_CODBA,20,1)
		_DIG2   := SUBSTR(SE2->E2_X_CODBA,21,1)
		_DIG3   := SUBSTR(SE2->E2_X_CODBA,22,1)
		_DIG4   := SUBSTR(SE2->E2_X_CODBA,23,1)
		
		_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := 11 - _RESTO
		
		_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",_DIGITO))
	 ELSE
	 	 _RETDIG := "0"	
	ENDIF
ELSE
	
	IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"
		
		_RETDIG := " "
		_DIG1   := SUBSTR(SE2->E2_X_CODBA,05,1)
		_DIG2   := SUBSTR(SE2->E2_X_CODBA,06,1)
		_DIG3   := SUBSTR(SE2->E2_X_CODBA,07,1)
		_DIG4   := SUBSTR(SE2->E2_X_CODBA,08,1)
		
		_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := 11 - _RESTO
		
		_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",_DIGITO))
		
	ELSE
			_RETDIG := "0"
			
	ENDIF

ENDIF

Return(_RETDIG)