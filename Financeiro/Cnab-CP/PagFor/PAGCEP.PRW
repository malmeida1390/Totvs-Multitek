#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagcep()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_cCEP,")

///// PROGRAMA PARA ZERAR O SUFIXO DO CEP QUANDO ESTE ESTIVER EM BRANCO
///// PAGFOR - POSICOES ( 88 - 95 )

_cALIAS  :=  GetArea()

_cCEP  :=  STRZERO(VAL(SUBSTR(SA2->A2_CEP,1,5)),5)+STRZERO(VAL(SUBSTR(SA2->A2_CEP,6,3)),5)
                     

RestArea(_cAlias)

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_CEP)
Return(_cCEP)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00