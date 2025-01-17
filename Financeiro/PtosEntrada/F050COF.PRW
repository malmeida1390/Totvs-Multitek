#include "rwmake.ch" 
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � F050COF  � Autor � Edelcio Cano            � Data � 12/12/2005 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao �Grava o Tipo+Fornec+Loja do Titulo de Origem no Titulo de COFINS���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                       ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function F050COF()

Local _aArea
Local _nRecSE2
Local _cTitOrig
      
//----> SALVANDO A AREA PARA GARANTIR A INTEGRIDADE
_aArea	:= GetArea()

DbSelectArea("SE2")
_nRecSE2:=	Recno()

//----> POSICIONO NO REGISTRO DO TITULO ORIGINAL PARA BUSCAR A CHAVE A SER GRAVADO NO TITULO TX DE IRRF
DbGoTo(PARAMIXB)

IF Empty(SE2->E2_PARCELA)
	_cParcela := " "
	_cTitOrig 	:=	_cParcela+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
Else
	_cTitOrig 	:=	SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA	
Endif

//----> POSICIONO NO REGISTRO ATUAL
DbGoTo(_nRecSE2)


RecLock("SE2",.f.)
SE2->E2_X_TITOR :=	_cTitOrig
MsUnLock()

RestArea(_aArea)