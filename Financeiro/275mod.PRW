#include "rwmake.ch"       
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � 275mod   � Autor � Edelcio               � Data � 02/06/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Este Rdmake consiste os abatimentos para a geracao do arq. ���
���          � CNAB de cobranca.                                          ���
���          � Calcula o valor do abatimento do titulo                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para a MULTITEK                                 ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function 275mod()     

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.094-094(ABN-REAL)

_aModel := "   "

If SEA->EA_PORTADO == "275"

   If Substr(SEA->EA_MODELO,1,2) == "01"
      _aModel := "2"
   Elseif Substr(SEA->EA_MODELO,1,2) == "02"   
      _aModel := "1"
   Elseif Substr(SEA->EA_MODELO,1,2) == "03"   
      _aModel := "4"
   Elseif Substr(SEA->EA_MODELO,1,2) == "31"   
      _aModel := "2"
   Endif

Endif   
     
Return(_aModel)  