#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagdoc()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CALIAS,_DOC,")

/////  PROGRAMA GRAVAR AS POSICOES DE 374 A 397 COM O CODIGO DE BARRAS CASO NAO
/////  SEJA DOC OU COM O TIPO E ZEROS SE FOR DOC PAGFOR - POSICOES ( 105 - 117 )

_cALIAS  :=  GetArea()

_DOC  := "                        "

DBSELECTAREA("SEA")
DBSETORDER(2)
DBSEEK(XFILIAL("SEA")+SE2->E2_NUMBOR+"P",.F.)

IF SUBSTR(SEA->EA_MODELO,1,2) == "03"
    
    _DOC   :=  "C00000003               "

Else
    _Doc  :=  SUBSTR(SE2->E2_X_CODBA,20,24)

EndIf     

RestArea(_cAlias)

// Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_DOC)
Return(_DOC)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00


