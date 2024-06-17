#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagdes()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETDES,")

// PROGRAMA PARA CALCULAR O VALOR DO DESCONTO DO TITULO
// CNAB - REMESSA PARA O BRADESCO
// FERNANDO - 09/03/98

_RETDES  := "               "

IF SUBSTR(SE2->E2_X_CODBA,6,14) == "00000000000000" .AND. SUBSTR(SE2->E2_X_CODBA,1,3) #"   "

    _RETDES := "000000000000000"

Else

    _RETDES := STRZERO((SE2->E2_VALOR-SE2->E2_SALDO+SE2->E2_DESCONT)*100,15)

END

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __RETURN(_RETDES)
Return(_RETDES)