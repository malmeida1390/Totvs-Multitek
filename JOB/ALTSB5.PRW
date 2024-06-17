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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  RJOB01  ºAutor  ³                    º Data ³  06/11/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job de integracao entre os sistemas RMS e AP6. Verificar   º±±
±±º          ³ detalhamento do processo para processo de importacao e     º±±
±±º          ³ regras de validacao sistemica.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Lopes Supermercados                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALTSB5()

Local   _lRet, _nI, _cQuery, _aCampos
Local   _lErro      := .F.
Local   _cErroArq   := ""
Local   _mvJOBsp    := ""
Local   _cOperAlias := ""
Local   _cKeyBus    := ""
Local   _cHoraIni   := ""
Local   _cHoraFim   := ""
Local   _cExecBlock := ""
Local   _cEmpAux    := ""
Local   _cNomAux    := ""
Local   _cPesquisa  := ""
Local   _cCodOper   := ""
Local   _cAtuFilial := ""
//Local   _cFiltroPZ2 := "&( PZ2->PZ2_CDEXEC ) == .T. . AND.  &( PZ2->PZ2_NOW ) == N "
Local   _nProcessado:= 0
Local   _nNaoimport := 0
Local   _nImport    := 0
Local   _nTotalproc := 0
Local   _xAvalia    := NIL
Local   _aArea      := {}
local   _nIdxBus    := 0


Local  cAuxAlias    := ""
Local  cArqSx2      := ""
Local  cArqInd      := ""

Private _cEmp       := "01"
Private _cFil       := "01"
Private _aTabOrd    := {} // Ordem a ser importada
Private _aComp      := {} // Tabela de Arquivos Compartilhados
Private _cObs       := ""
Private _cAlterChave:= ""
Private _nAlterOrd  := ""
Private _lAlterInc  := .F.
Private _cProcesso  := ""
Private _lInc       := _lExc := .F.
Private cDriver     := "DBFCDX"
Private cAlias	    := "",cArquivo := ""
Private lSIX 	    := .F.
Private K           := 0
Private cEmpImp     := "01", cFilImp := "01"
Private lRet        := .T.
Private _AreaPar    := {}
Private _DDataBase  := ctod("")

Private _cNomeArq := ""
Private _cCaminho := "\CARGA\"
Private _cAlias   := ""


//*******************************************************//
//                                                       //
//       Iniciando o Laço de Filiais                     //
//                                                       //
//*******************************************************//
ConOut("****************************************")
ConOut("**         Preparando ambiente        **")
ConOut("****************************************")

PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp TABLES "SF1","SF2","SD1",;
		"SD2","SF4","SE2","SE1","SEF","SL1","SE5","SE3","SD3","SG1","SF5","SFC",;
		"SA3","SA6","SLF","SC1","SC7","SC9","SC6","SC5","SF4","SE4",;
		"SB2","SB1","SM0","PZ1","PZ2","PZ3","PZ4","PZ5","SFB",;
		"SZ2","SZ3","SBM","SZ5","Z01","Z02","Z03","Z04","Z05","Z06","Z07",;
		"Z08","Z09","Z10","SZA","SZH","SZ9","SB5","SYD"
		

DbSelectArea("SB1")
DbGotop()

While !SB1->(Eof())
                 
 	  Reclock("SB1",.F.)
      SB1->B1_DESC:=Alltrim(SB1->B1_X_REFER) + Alltrim(SB1->B1_X_SUFIX)+" "+Alltrim(SB1->B1_X_MARCA)     
      SB1->B1_CSLL:="1"
      SB1->B1_COFINS:="1"
      SB1->B1_PIS:="1"
	  MsUnLock()
                     
      DbSelectArea("SB5")                  
      DbSetOrder(1)
	  If DbSeek(xFilial("SB5")+SB1->B1_COD)
	 	 Reclock("SB5",.F.)
		 SB5->B5_CEME :=  SB1->B1_DESC
		 MsUnLock()
	  Endif
      
      DbSelectArea("SB1")
      SB1->(DBSKIP())

Enddo



RESET ENVIRONMENT

ConOut("****************************************")
ConOut("**Banco em Uso-Import.Dados p/Microsiga*")
ConOut("****************************************")

conOut("****************************************")
ConOut("**               Fim                  **")
ConOut("****************************************")

Return
