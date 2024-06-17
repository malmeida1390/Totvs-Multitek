#include "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"

// Definicao do indicador de tabela
#define  __LOGID "01"

// Definicao das constantes na matriz de tabelas a importar
#define  __CPDESTINO 1
#define  __CPORIGEM  2

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  RJOB01  �Autor  �                    � Data �  06/11/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cancelamento de Orcamentos Vencidos.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RJOB01()


Private cEmpImp     := "01", cFilImp := "01"

//*******************************************************//
//                                                       //
//       Iniciando o La�o de Filiais                     //
//                                                       //
//*******************************************************//
ConOut("**********************************************************")
ConOut("**                  Preparando Ambiente                 **")
ConOut("**********************************************************")

PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp TABLES "SX6","SCJ","SCK","SB2","SB9","SD1","SD2","SD3","SX2","SC9","CB7","SX1"

ConOut("**********************************************************")
ConOut("**Iniciando Processo **                                   ")
ConOut("**********************************************************")

U_GERAEMAIL(.f.,'01','01')

ConOut("**********************************************************")
ConOut("**Finalizando Processo**                                  ")
ConOut("**********************************************************")

RESET ENVIRONMENT

Return


