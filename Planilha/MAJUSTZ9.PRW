#INCLUDE  "FIVEWIN.CH"
#include  "topconn.ch"
#include  "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAJUSTZ9  ºAutor  ³                    º Data ³  05/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gestao de Materiais Multi-Tek - PGMM (Planilha de Gestao    º±±
±±º          ³Materiais Multi-Tek)                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MAJUSTZ9()

Local	cSku    := ""
Local	cSimil  := ""
Local	cEis    := ""
Local	lRet    := .T.
Local lProcBloc:= .T.

Private _aLog    := {}
Private _aAud    := {}
Private _ChaveAud:= ""

Processa({|| U_LIMPASZA(),"Aguarde...Limpeza SZA."})

Processa({|| U_LIMPASZ9(),"Aguarde...Limpeza SZ9."})

Return  

Processa({|| U_AJUSTASZ9(),"Aguarde...Processando SZA e gerando SZ9."})




User Function AJUSTASZ9()
Local _nRecno := 0
Local nPosSimil:=0

Private cSku    := ""
Private cSimil  := ""
Private cEis    := ""



DbSelectArea("SB1")
DbSetorder(0)

ProcRegua(SB1->(RECCOUNT()) )

DbGotop()

While !SB1->(EOF())
	
	IncProc()
   Incproc("Lendo Registro "+str(SB1->(RECNO()))+" da TABELA SB1.")   //1

	_nRecno:=SB1->(RECNO())

	U_RegravaEIS(.T.)
        
	DbSelectArea("SB1")
	DbGoto(_nRecno)
	SB1->(DBSKIP())
	
Enddo


_Imprime()

Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ _Imprime ³ Autor ³ Edelcio Cano          ³ Data ³ 10/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do LOG de ocorrencias na importacao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Multi-Tek                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _Imprime()

Private titulo    := ""
Private cDesc1    := ""
Private cDesc2    := ""
Private cDesc3    := PADC("                                       ",74)
Private tamanho   := Iif ( EmptY(_ChaveAud),"P","G")
Private limite    := 80
Private cString   := "SZ9"
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog  := "I_SZ9"
Private nLastKey  := 0
//            0       10       20       30       40       50       60       70
//            .12345679.12345679.12345679.12345679.12345679.12345679.12345679.123456789.
Private cabec1    := ""
Private cabec2    := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao dos Cabecalhos e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt   := Space(10)
Private cbcont  := 00
Private li      := 80
Private m_pag   := 01

Private wnrel := "I_SZ9"

titulo    := " Ocorrencias durante a Nova Geracao SZ9."
cabec1    := " "
cDesc1    := " "
cDesc2    := " "

wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

PROCESSA({|| _ImpNow()},"Processando o relatorio")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ _ImpNow  ³ Autor ³ Edelcio Cano          ³ Data ³ 10/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inicio da Impressao (Para funcionamento da REUGA)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Multi-Tek                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _ImpNow()

nTipo     := IF(aReturn[4]==1,15,18)

procregua(Len(_aLog)+Len(_aAud))

For _i := 1 to Len(_aLog)
	
	IncProc("Imprimindo, aguarde ...")
	
	If li > 59
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := prow() + 1
	EndIf
	
	@ li, 000 PSAY _aLog[_i]
	
	li := li + 1
Next

eject

For _i := 1 to Len(_aAud)
	
	IncProc("Imprimindo, aguarde ...")
	
	If li > 59
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := prow() + 1
	EndIf
	
	@ li, 000 PSAY _aAud[_i]
	
	li := li + 1
Next


Roda(0,"","P")

Set device to Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Ms_Flush()

Return




//
// LIMPEZA NO SZA
//
User Function LIMPASZA()
Local cSimil := ""
Local cEis   := ""

DbSelectArea("SZA")
DbSetOrder(1)

ProcRegua(SZA->(RECCOUNT()) )

DbGotop()

While !SZA->(EOF())

		cSimil := SZA->ZA_SIMIL
		cEis   := SZA->(ZA_EIS01+ZA_EIS02+ZA_EIS03+ZA_EIS04+ZA_EIS05+ZA_EIS06+ZA_EIS07+ZA_EIS08+ZA_EIS09+ZA_EIS10)
	
		IncProc()

		DbSelectArea("SB1")
		DbOrderNickname("B1SIMIL")
		DbGotop()
      If ! DbSeek(xFilial("SZA")+cSimil+cEis)
       	DbSelectArea("SZA")
			RECLOCK("SZA",.F.)
			DbDelete()
			MsUnlock()
      Else
    
    	   //
     		// Tudo que a chave principal QUE nao tenha relacao DEVE SER  deletada
     	 	//
     	 	If ! SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbGotop(),Dbseek(xFilial("SB1")+SZA->ZA_SKU))
         	DbSelectArea("SZA")
        	   Reclock("SZA",.F.)
        	   DbDelete()
            MsUnlock()
         Endif
    
      Endif
    
      DbSelectArea("SZA") 
      SZA->(DBSKIP())

Enddo      

Return




//
// LIMPEZA NO SZ9
//
User Function LIMPASZ9()
Local cSimil := ""
Local cEis   := ""

DbSelectArea("SZ9")
DbSetOrder(1)

ProcRegua(SZ9->(RECCOUNT()) )

DbGotop()

While !SZ9->(EOF())

		cSimil := SZ9->Z9_SIMIL
		cEis   := SZ9->(Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10)
 
		IncProc()

		DbSelectArea("SB1")
		DbOrderNickname("B1SIMIL")
		DbGotop()
      If !DbSeek(xFilial("SB1")+cSimil+cEis) 
         DbSelectArea("SZ9") 
			RECLOCK("SZ9",.F.)
			DbDelete()
			MsUnlock()
      Endif

      DbSelectArea("SZ9") 
      SZ9->(DBSKIP())

Enddo      


Return


