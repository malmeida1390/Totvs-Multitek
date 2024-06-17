#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagban()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
              
//01 - Credito em C/c
//02 - Cheque OP
//03 - DOC
//30 - COBRANCA BRADESCO
//31 - COBRANCA TERCEIROS


SetPrvt("_CALIAS,_cBANCO,")

/////  PROGRAMA PARA SEPARAR O BANCO DO FORNECEDOR
//// PAGFOR - POSICOES ( 96 - 98 )

_cALIAS  :=  GetArea()

DBSELECTAREA("SEA")
DBSETORDER(2)
DBSEEK(XFILIAL("SEA")+SE2->E2_NUMBOR+"P",.F.)

_cModelo := SUBS(SEA->EA_MODELO,1,2)

IF _cModelo == "31"
	
	_cBANCO  :=  SUBSTR(SE2->E2_X_CODBA,1,3)
	
else
	
	If _cModelo == "03"
		
		_cBANCO := SA2->A2_BANCO
		//_cBANCO := SE2->E2_X_BCOPG
		
	else
		
		
		_cBANCO := "237"
		
	Endif
	
Endif

RestArea(_cAlias)

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_BANCO)
Return(_cBANCO)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00
