#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagcpo()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CALIAS,_CPO,")

/////  PROGRAMA PARA SEPARAR DO CAMPO LIVRE A POSISAO (44 - 44) QDO NAO FOR
/////  TITULOS DO BRADESCO E VOLTAR braco QUANDO nao

_cALIAS  :=  GetArea()
_CPO := " "
///IF SE2->E2_BCOPAG #"237"

    _CPO  :=  SUBSTR(SE2->E2_X_CODBA,44,1)

///EndIf            


RestArea(_cAlias)

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_CPO)
Return(_CPO)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00


