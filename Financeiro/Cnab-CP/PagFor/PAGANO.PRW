#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

User Function Pagano()        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETANO,")

////  PROGRAMA PARA SELECIONAR O ANO DO NOSSO NUMERO DO NUMERO CNAB QUANDO NAO
////  NAO TIVER TEM QUE SER COLOCADO "00"

DBSELECTAREA("SEA")
DBSETORDER(2)
DBSEEK(XFILIAL("SEA")+SE2->E2_NUMBOR+"P",.F.)

_cMODELO := SUBS(SEA->EA_MODELO,1,2)

/*/ TRAVADO EM 12/09/2001 HENRY E MICHELLE
IF _cMODELO == "31"     
  IF SUBS(SE2->E2_X_CODBA,1,3) == "237"
     _RETANO := "0" + SUBS(SE2->E2_X_CODBA,26,11)
  ENDIF
ELSE
  _RETANO := "000000000000"
ENDIF 
/*/
 
_RETANO := "000000000000"

                        // Substituido pelo assistente de conversao do AP5 IDE em 06/11/00 ==> __return(_RETANO)
Return(_RETANO)        // incluido pelo assistente de conversao do AP5 IDE em 06/11/00