#include "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"

// Definicao do indicador de tabela
#define  __LOGID "01"

// Definicao das constantes na matriz de tabelas a importar
#define  __CPDESTINO 1
#define  __CPORIGEM  2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  RJOB01  บAutor  ณ                    บ Data ณ  06/11/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancelamento de Orcamentos Vencidos.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJOB01()


Private cEmpImp     := "01", cFilImp := "01"

//*******************************************************//
//                                                       //
//       Iniciando o La็o de Filiais                     //
//                                                       //
//*******************************************************//
ConOut("**********************************************************")
ConOut("**                  Preparando Ambiente                 **")
ConOut("**********************************************************")

//PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp TABLES "SX6","SCJ","SCK"
PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp TABLES "SX6","SCJ","SCK","SB2","SB9","SD1","SD2","SD3","SX2","SC9","CB7"

/*
		"SD2","SF4","SE2","SE1","SEF","SL1","SE5","SE3","SD3","SG1","SF5","SFC",;
		"SA3","SA6","SLF","SC1","SC7","SC9","SC6","SC5","SF4","SE4",;
		"SB2","SB1","SM0","PZ1","PZ2","PZ3","PZ4","PZ5","SFB",;
		"SZ2","SZ3","SBM","SZ5","Z01","Z02","Z03","Z04","Z05","Z06","Z07",;
		"Z08","Z09","Z10","SZA","SZH","SZ9"
*/		
ConOut("**********************************************************")
ConOut("**Iniciando Processo Limpeza Deletados**                  ")
ConOut("**********************************************************")

U_LimpDelet()

ConOut("**********************************************************")
ConOut("**Iniciando Processo Limpeza Deletados**                  ")
ConOut("**********************************************************")

U_AJUSTACB7()

RESET ENVIRONMENT

Return



