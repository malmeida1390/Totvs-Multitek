#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagagen()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_AGENCIA,")

_cALIAS  :=  GetArea()
_Agencia := "00000"


	IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"
	
	  	IF SE2->E2_X_LEITO == "S"
		
			_Agencia := STRZERO(VAL(SUBSTR(SE2->E2_X_CODBA,20,4)),5,0)
	
      Else 
	
         _Agencia  := STRZERO(VAL(SUBSTR(SE2->E2_X_CODBA,5,4)),5,0)
         
      Endif   
	
	Else
	
         _Agencia  := STRZERO(VAL(SA2->A2_AGENCIA),5,0)
        
    ENDIF

RestArea(_cAlias)

Return(_Agencia) 