#include "rwmake.ch"        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � SABAT    � Autor � Edelcio               � Data � 09/02/04 ���
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

User Function SABAT()        


_nValSoM  := 0
_cPrefixo := SE1->E1_PREFIXO
_cNumero  := SE1->E1_NUM
_cParcela := SE1->E1_PARCELA
_nMoeda   := SE1->E1_MOEDA
_dData    := SE1->E1_VENCREA
_cFornCli := SE1->E1_CLIENTE
_cLoja	 :=  SE1->E1_LOJA
_cFilAbat := SE1->E1_FILIAL

  
_nValSom := SomaAbat(_cPrefixo,_cNumero,_cParcela,"R",_nMoeda,_dData,_cFornCli,_cLoja)

_nValSom :=  STRZERO((_nValSom*100),13)                           

Return(_nValSom)