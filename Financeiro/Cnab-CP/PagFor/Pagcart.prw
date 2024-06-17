#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagcart()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


////  PROGRAMA PARA ESPECIFICAR A CARTEIRA DO PAGFOR BRADESCO
////  PAGFOR POSICAO ( 136 - 138 )


_cALIAS  :=  GetArea()
_RETCART := "000"

DBSELECTAREA("SEA")
DBSETORDER(2)
DBSEEK(XFILIAL("SEA")+SE2->E2_NUMBOR+"P",.F.)

_cModelo := Substr(SEA->EA_Modelo,1,2)


IF _cMODELO == "31"
   IF SUBSTR(SE2->E2_X_CODBA,1,3) == "237"
      
       _RETCART := "0" + SUBSTR(SE2->E2_X_CODBA,24,2)
      
           
   ELSE
   
      _RETCART := "000"
   
   ENDIF   
ENDIF



_RETCART := "000"
 
                                                                                       
RestArea(_cAlias)

                        // Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_Agencia)
Return(_RETCART)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00