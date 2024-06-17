#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagdgct()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("E2_X_CODBA,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO,_CCFOR,")

/////////E2_X_CODBA := "2370000000000000000000000000000000000001084"
///////////   1234567890123456789212345678931234567894123

_cAlias := GetArea()

_RETDIG :="00"

IF SE2->E2_X_LEITO == "S"
	
	
	IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"
		
		_RETDIG := " "
		_DIG1   := SUBSTR(SE2->E2_X_CODBA,37,1)
		_DIG2   := SUBSTR(SE2->E2_X_CODBA,38,1)
		_DIG3   := SUBSTR(SE2->E2_X_CODBA,39,1)
		_DIG4   := SUBSTR(SE2->E2_X_CODBA,40,1)
		_DIG5   := SUBSTR(SE2->E2_X_CODBA,41,1)
		_DIG6   := SUBSTR(SE2->E2_X_CODBA,42,1)
		_DIG7   := SUBSTR(SE2->E2_X_CODBA,43,1)
		
		_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := STRZERO((11 - _RESTO),1)
		
		_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))

	Endif

ELSE

	IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"

		//_CCFOR  := STRZERO(VAL(SE2->E2_X_CCFOR),7)
        _CCFOR  := STRZERO(VAL(SUBSTR(SE2->E2_X_CODBAR,24,7)),7,0)

		_RETDIG := " "                     
		_DIG1   := SUBSTR(_CCFOR,1,1)
		_DIG2   := SUBSTR(_CCFOR,2,1)
		_DIG3   := SUBSTR(_CCFOR,3,1)
		_DIG4   := SUBSTR(_CCFOR,4,1)
		_DIG5   := SUBSTR(_CCFOR,5,1)
		_DIG6   := SUBSTR(_CCFOR,6,1)
		_DIG7   := SUBSTR(_CCFOR,7,1)
		
		_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := STRZERO((11 - _RESTO),1,0)
		
		_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
	Endif
	
Endif

RestArea(_cAlias)

Return(_RETDIG)