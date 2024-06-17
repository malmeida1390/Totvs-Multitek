#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

User Function Cnabrem()        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

// PROGRAMA PARA CALCULAR O VALOR DE PAGAMENTO DO TITULO
// CNAB - REMESSA PARA O BRADESCO
// Mika - Wed  10-22-1997



// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> //////__Return(STRZERO(SE2->(E2_VALOR-E2_DESCONT+E2_CNABACR)*100,15))
Return(STRZERO(SE2->(E2_VALOR-E2_DESCONT)*100,15))        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00

// Substituido pelo assistente de conversao do AP5 IDE em 09/11/00 ==> __RETURN(STRZERO((SE2->E2_SALDO-SE2->E2_DESCONT)*100,15))
Return(STRZERO((SE2->E2_SALDO-SE2->E2_DESCONT)*100,15))        // incluido pelo assistente de conversao do AP5 IDE em 09/11/00


