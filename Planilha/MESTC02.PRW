#INCLUDE  "FIVEWIN.CH"
#include  "topconn.ch"
#include  "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MESTC02   ºAutor  ³                    º Data ³  05/07/04   º±±
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
Private lGravaGiro := GetMv("MV_GRGIRO") // Libera a Gracacao do Giro
// Este paramentro foi criado em funcao da Multitek
// nao ter Historico anterior do giro.
// Logo o Giro permanecera o Mesmo para todos os
// meses ate a virada do parametro.
Private cGravaGiro := IIf(lGravaGiro,"Sim","Nao")
Private aDatFecha:= {}
Private _aLog    := {}
Private _aAud    := {}
Private _ChaveAud:= ""



If !lGravaGiro
	nPgmGiro := 0
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o SX1 -                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()


//#IFDEF TOP               ??? Como isto funciona pode ser util
//	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
//#ENDIF


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³          ³                                                            ³±±
±±³Retorna   ³ Matriz com duas datas validas para processamento           ³±±
±±³          ³                                                            ³±±
±±³          ³ [1]   Esta posicao e exclusiva para as datas do Reprocessam³±±
±±³          ³       (Reprocessamento ultimo Mes)                         ³±±
±±³          ³ [1][1]Data Final do Reprocessamento;                       ³±±
±±³          ³ [1][2]Data Inicio do Mes para Fechamento.                  ³±±
±±³          ³ [1][3]Data Inicio do Historico para Fechamento.            ³±±
±±³          ³ [1][4]Data Inicio consulta do Giro com base na             ³±±
±±³          ³       data de Reprocessamento;                             ³±±
±±³          ³                                                            ³±±
±±³          ³ [2]   Esta posicao e exclusiva para as datas do Fechamento ³±±
±±³          ³       (Novo Fechamento)                                    ³±±
±±³          ³ [2][1]Data Final do Fechamento;                            ³±±
±±³          ³ [2][2]Data Inicio do Mes para Fechamento.                  ³±±
±±³          ³ [2][3]Data Inicio do Historico para Fechamento.            ³±±
±±³          ³ [2][4]Data Inicio consulta do Giro com base na             ³±±
±±³          ³       data de Fechamento;                                  ³±±
±±³          ³                                                            ³±±
±±³          ³ [3]   Datas Informativas                                   ³±±
±±³          ³ [3][1]Data do Ultimo Fechamento   (Dia/Mes/Ano)            ³±±
±±³          ³ [3][2]Data novo Fechamento        (Dia/Mes/Ano)+Reprocess. ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
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


DEFINE MSDIALOG oDlg FROM  96,4 TO 475+60,625 TITLE "GERACAO DA PGMM - Planilha de Gestao de Materiais Multi-Tek"  PIXEL

@ 018, 09 TO 198, 300 LABEL "" OF oDlg  PIXEL
@ 028, 15 Say " => ESTE PROGRAMA TEM COMO OBJETIVO:                                                   " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 038, 15 Say " GERACAO DA PGMM (Planillha de Gestao de Materiais Multitek) que consiste na geracao dos arquivos  " SIZE 275, 10 OF oDlg PIXEL
@ 048, 15 Say " (SZ7 e SZ8) para Manutencao da Planilha com base nos ultimos historicos + estoques atuais.        " SIZE 275, 10 OF oDlg PIXEL
@ 058, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL
@ 068, 15 Say " = > PARAMETROS ENVOLVIDOS:                                                            " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 078, 15 Say " MV_PGMPERI - Periodo do parametro para analise do Historico e dos ultimos: "+strzero(nPgmPeri,2)+" meses.      " SIZE 275, 10 OF oDlg PIXEL
@ 088, 15 Say " MV_PGMGIRO - Periodo do parametro para analise do Giro e dos ultimos: "+strzero(nPgmGiro,2)+" meses.           " SIZE 275, 10 OF oDlg PIXEL
@ 098, 15 Say " MV_TMPREPR - Periodo para Reprocessamento: "+STR(GETMV("MV_TMPREPR"))+" dias."            SIZE 275, 10 OF oDlg PIXEL
@ 108, 15 Say " MV_ALMFECH - Almoxarifados Nao Considerados na PGMM: "+GetMV("MV_ALMFECH")                         SIZE 275, 20 OF oDlg PIXEL

@ 128, 15 Say " MV_GRGIRO  - Efetua Calculo do Giro  : "+cGravaGiro                                   SIZE 275, 10 OF oDlg PIXEL
@ 138, 15 Say "                                                                                    " SIZE 275, 10 OF oDlg PIXEL
@ 148, 15 Say " = > PERIODO VALIDO (COM BASE NO SZ9 ULTIMO FECHAMENTO):                            " SIZE 275, 10 OF oDlg PIXEL FONT oFntFecha2
@ 158, 15 Say dtoc(aDatFecha[3,1])+" - Data do ultima Geracao da Planilha " SIZE 275, 10 OF oDlg PIXEL
@ 168, 15 Say dtoc(aDatFecha[3,2])+" - Data prevista para nova Geracao da Planilha" SIZE 275, 10 OF oDlg PIXEL
@ 178, 15 Say "                                                                                       " SIZE 275, 10 OF oDlg PIXEL
@ 188, 15 Say "Atencao, Ao realizar este Processamento os Dados relativos a Manutencao da da Planilha serao atualizados. " SIZE 275, 10 OF oDlg PIXEL COLOR CLR_RED

DEFINE SBUTTON FROM 208,209 TYPE 5 ACTION Pergunte("PLANI2",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 208,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 208,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER



// Neste caso somente iremos tratar a geracao do SZ7 e SZ8 com base no ultimo
// reprocessamento.

If nOpca == 1
	
	pergunte("PLANI2"+SPACE(4),.F.) // Sempre Le a ultima solicitacao com base no SX1
	
	// Data final para processamento do Fechamento do Mes do Historio e do Giro
	dFimProc :=         aDatFecha[1,1]
	// Data inicial para processamento do Mes.
	dIniMes  :=         aDatFecha[1,2]
	// Data Inicial para processamento dos Historicos
	dIniHis  :=         aDatFecha[1,3]
	// Data Inicial para processamento do Giro do Estoque
	dIniGir  :=         aDatFecha[1,4]
	
	_ChaveAud := ALLTRIM(MV_PAR01) + ALLTRIM(MV_PAR02)
	
	If  !EmptY(_ChaveAud)
		DbSelectArea("SB1")
		DbOrderNickname("B1SIMIL")         // Filial+Simil+Eis
		If  !DbSeek(xFilial("SB1")+_ChaveAud)
			
			Aviso("ATENCAO", "Nao foi encontrada nenhuma chave Simil+Eis no Cadastro de Produtos p/ processo de Analise."+;
			" Voce pode Informar uma chave correta ou deixar os"+;
			"dos campos em branco simil + eis para que nao seja efetuada nenhuma analise "+;
			"especifica",{"&Ok"})
			
			Return
		Endif
		
	Endif
	
	
	// O parametro abaixo e tratado pelos programas:
	// a) REGRAVAEIS.PRW  - Trava  a Geracao da Planilha "MESTC02"
	//                      Devido altera o Eis ou adiciona um novo EIS        PutMv('MV_LIBPGMM',.T.)
	// b) MESTC01.PRW     - Libera a Geracao da Planilha "MESTC02"
	//                      Apos Reprocessamento ou Fechamento da Planilha     PutMv('MV_LIBPGMM',.F.)
	// c) MESTC02.PRW     - Analiza se esta permitido a Geracao da Planilha    GETMV('MV_LIBPGMM)
	//
	If SUBSTR(GetMV('MV_LIBPGMM'),1,1) = "T"
		Aviso("ATENCAO", "Ocorreu alteracao do Simil + Eis de algum produto. Para a nova Geracao "+;
		"da PGMM sera necessario antes efetuar o Reprocessamento do Fechamento ou  novo Fechamento. "+;
		"Este fato se torna necessario devido tanto as classificacoes como o consumo medio "+;
		"do Simil + Eis para uso da PGMM tem sua origem no Cadastro de Produto que e atualizado durante o processo de "+;
		"Fechamento. Logo quando  executo a Geracao da PGMM apenas busco as classificacoes "+;
		"do produto.",{"&Ok"})
		Return()
	Endif
	
	
	processa({|lend| U_MESTPROC()},"Processamento da Planilha","Efetuando Processamento da Planilha",.F.)
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Alice Y Yamamoto    ³Data³ 22.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aPerg := {}
Local cPerg := "PLANI2"+SPACE(4), nI, nPerg


//aadd(aPerg,{"01","Mes            ?","Mes            ?","Mes            ?","mv_ch1","N",2,0,0,"G","U_VALMES(MV_PAR01)","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aPerg,{"02","Ano            ?","Ano            ?","Ano            ?","mv_ch2","N",4,0,0,"G","U_VALANO(MV_PAR02)","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aPerg,{"01","Analisar Simil ?","Processar      ?","Processar      ?","mv_ch1","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"02","Analisar Eis   ?","Processar      ?","Processar      ?","mv_ch2","C",20,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

nPerg := Len(aPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao exista a Pergunta a mesma sera criada.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX1")
dbSetOrder(1)
For nI := 1 To nPerg
	If ! dbSeek(cPerg+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_DECIMAL  With aPerg[nI,08]
		Replace X1_PRESEL   With aPerg[nI,09]
		Replace X1_GSC		With aPerg[nI,10]
		Replace X1_VALID    With aPerg[nI,11]
		Replace X1_VAR01	With aPerg[nI,12]
		Replace X1_DEF01	With aPerg[nI,13]
		Replace X1_DEFSPA1	With aPerg[nI,14]
		Replace X1_DEFENG1	With aPerg[nI,15]
		Replace X1_CNT01	With aPerg[nI,16]
		Replace X1_DEF02	With aPerg[nI,17]
		Replace X1_DEFSPA2	With aPerg[nI,18]
		Replace X1_DEFENG2	With aPerg[nI,19]
		MsUnlock()
	EndIf
Next
