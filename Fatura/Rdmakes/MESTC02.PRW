#INCLUDE  "FIVEWIN.CH"
#include  "topconn.ch"
#include  "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTC02   ºAutor  ³ Almeida            º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gestao de Materiais Multi-Tek - PGMM (Planilha de Gestao    º±±
±±º          ³Materiais Multi-Tek)                                        º±±
±±º          ³                                                            º±±
±±º          ³Desenvolvimento conf. Documento PGMM0001                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MESTC02()

Local oDlg,nOpca:=0
Local cPeriodo1 := ""
Local cPeriodo2 := ""
Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5 

Private nPgmPeri := GETMV("MV_PGMPERI") // Pediodo de Fechamento p/ Leitura dos Historicos.
Private nPgmGiro := GETMV("MV_PGMGIRO") // Pediodo de Fechamento p/ Leitura dos Historicos.
Private dIniMes  := Ctod("")            // Data inicial para processamento do Mes.
Private dIniGir  := Ctod("")            // Data Inicial para processamento do Giro do Estoque
Private dIniHis  := Ctod("")            // Data Inicial para processamento dos Historicos
Private dFimProc := Ctod("")            // Data final para processamento do Fechamento do Mes
                                        //  do Historio e do Giro

Private aDatFecha:= {}  

//#IFDEF TOP               ??? Como isto funciona pode ser util
//	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
//#ENDIF


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aDatFecha[1] Data valida para Final de todos os Processamentos³
//³              (Mes, Historico e Giro)                          ³
//³ aDatFecha[2] Data valida para Inicio do Mes                   ³
//³ aDatFecha[3] Data valida para Inicio do Historico             ³
//³ aDatFecha[4] Data valida para Inicio do Giro                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDatFecha := U_DataFecha()


//Caso deseje travar o acesso
//If Substr(cAcesso,19,1) == " "
//	Help ( " ", 1, "SEMPERM" )
//	Return .F.
//EndIf  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 6,10 BOLD
DEFINE FONT oFntFecha2 NAME "Ms Sans Serif"   SIZE 6,10 BOLD
DEFINE FONT oFntFecha3 NAME "Mono As"         SIZE 6,10 BOLD
DEFINE FONT oFntFecha4 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD

                     
DEFINE MSDIALOG oDlg FROM  96,4 TO 475,625 TITLE "GERACAO DA PGMM - Planilha de Gestao de Materiais Multi-Tek"  PIXEL

@ 018, 09 TO 158, 300 LABEL "" OF oDlg  PIXEL
@ 028, 15 Say " => ESTE PROGRAMA TEM COMO OBJETIVO:                                                   " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 038, 15 Say " GERACAO DA PGMM (Planillha de Gestao de Materiais Multitek) que consiste na geracao dos arquivos  " SIZE 275, 10 OF oDlg PIXEL                                     
@ 048, 15 Say " (SZ7 e SZ8) para Manutencao da Planilha com base nos ultimos historicos + estoques atuais.        " SIZE 275, 10 OF oDlg PIXEL
@ 058, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL                   
@ 068, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL  
@ 078, 15 Say " = > PARAMETROS ENVOLVIDOS:                                                            " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 088, 15 Say " MV_PGMPERI - Periodo do parametro para analise do Historico e dos ultimos "+strzero(nPgmPeri,2)+" meses.      " SIZE 275, 10 OF oDlg PIXEL
@ 098, 15 Say " MV_PGMGIRO - Periodo do parametro para analise do Giro e dos ultimos "+strzero(nPgmGiro,2)+" meses.           " SIZE 275, 10 OF oDlg PIXEL
@ 108, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL  
@ 118, 15 Say " = > PERIODO VALIDO (COM BASE NO SZ9 ULTIMO FECHAMENTO):                            " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 128, 15 Say strzero(month(aDatFecha[1,1]),2)+" / " + str(year(aDatFecha[1,1]),4)+" - Data do ultimo Fechamento  " SIZE 275, 10 OF oDlg PIXEL 
@ 138, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL  
@ 148, 15 Say "Atencao, Ao realizar este Processamento os Dados relativos a Manutencao da da Planilha serao atualizados. " SIZE 275, 10 OF oDlg PIXEL COLOR CLR_RED

//DEFINE SBUTTON FROM 168,209 TYPE 5 ACTION Pergunte("PLANI1",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 168,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 168,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER



// Neste caso somente iremos tratar a geracao do SZ7 e SZ8 com base no ultimo
// reprocessamento.

If nOpca == 1
   //pergunte("PLANI1",.F.) // Sempre Le a ultima solicitacao com base no SX1

//   If MV_PAR01 = 1          // Reprocesamento Ultimo Fechamento
                              

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Fechamento do novo Mes                                          ³
      //³                                                                 ³
      //³ aDatFecha[2,1] Data valida para Final de todos os Processamentos³
      //³                (Mes, Historico e Giro)                          ³
      //³ aDatFecha[2,2] Data valida para Inicio do Mes                   ³
      //³ aDatFecha[2,3] Data valida para Inicio do Historico             ³
      //³ aDatFecha[2,4] Data valida para Inicio do Giro                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      // Data final para processamento do Fechamento do Mes do Historio e do Giro
      dFimProc :=         aDatFecha[2,1]
      // Data inicial para processamento do Mes.
      dIniMes  :=         aDatFecha[2,2]
      // Data Inicial para processamento dos Historicos
      dIniHis  :=         aDatFecha[2,3]
      // Data Inicial para processamento do Giro do Estoque
      dIniGir  :=         aDatFecha[2,4]

/*      
    Else 

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Reprocessamento do Mes                                          ³
      //³                                                                 ³
      //³ aDatFecha[1,1] Data valida para Final de todos os Processamentos³
      //³                (Mes, Historico e Giro)                          ³
      //³ aDatFecha[1,2] Data valida para Inicio do Mes                   ³
      //³ aDatFecha[1,3] Data valida para Inicio do Historico             ³
      //³ aDatFecha[1,4] Data valida para Inicio do Giro                  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      // Data final para processamento do Fechamento do Mes do Historio e do Giro
      dFimProc :=         aDatFecha[1,1]
      // Data inicial para processamento do Mes.
      dIniMes  :=         aDatFecha[1,2]
      // Data Inicial para processamento dos Historicos
      dIniHis  :=         aDatFecha[1,3]
      // Data Inicial para processamento do Giro do Estoque
      dIniGir  :=         aDatFecha[1,4]

   Endif
*/
   
   processa({|lend| U_MESTPROC()},"Processamento da Planilha","Efetuando Processamento da Planilha",.F.)
   

EndIf 
Return


