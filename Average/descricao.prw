//------------------------------------------------------------------------------------//
//Empresa...: AVERAGE TECNOLOGIA
//Funcao....: U_PIS_COF()
//Autor.....: Leandro Delfino Rodrigues (LDR)
//Data......: 23 de Abril de 2004, 16:50
//Uso.......: SIGAEIC   
//Versao....: Protheus - 6.09    
//Descricao.: Carga Pis e Cofins.
//------------------------------------------------------------------------------------//
#INCLUDE "Rwmake.ch"

*-------------------------------*
USER FUNCTION DESCRICAO()
*-------------------------------*

LOCAL bOk:={||(nOpcao:=1,oDlg:End())}
LOCAL bCancel:={||(lLoop:=.F.,oDlg:End())}
LOCAL oDLG
lOCAL cCHAVE,cTEXTO
LOCAL nOpcao:=0, nCHAVE:=0
PRIVATE lApend:=.T.,lAtu_Base:=.F.,lLOOP:=.T.

SET DELETE OFF

//SYP->(DbSetOrder(1))
//SYP->(LASTREC())

DO WHILE lLoop

   DEFINE MSDIALOG oDlg TITLE "teste 1"  From 8,5 To 18,50 OF oMainWnd 

   NOPCAO:=0

	SYP->(dbSetOrder(1))
	SYP->(DBSEEK(xFilial("SYP")))
//	ProcRegua(SYP->(LastRec()))
	SYP->(DBGOBOTTOM())
	cCHAVE := SYP->YP_CHAVE
	cTEXTO := SYP->YP_TEXTO
	
   @ 040,010 SAY cCHAVE
   @ 050,010 SAY cTEXTO
   
   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) CENTERED  


   IF nOpcao == 1

	
	nCHAVE = VAL(cCHAVE)
	nCHAVE = nCHAVE + 1
	cCHAVE = STR(nCHAVE)
    MSGINFO(nCHAVE)

   ENDIF
   

ENDDO


   
Return

/*
*----------------------*
User Function QBG_SYP()
*----------------------*
Private aTabSyp    := {}
Private aTabSypDUP := {}
Private aTabOK := {}
Private aTabSDUP := {}
SYP->(dbSetOrder(1))

Processa({|| ApuraTab() })
Processa({|| ApuraTABS() })

FIMPRIME()

Processa({|| SYPATUALIZA() })

Return .T.

*-------------------------*
Static Function ApuraTab()
*-------------------------*
Local cTabAlias := ""

SYP->(DBSEEK(xFilial("SYP")))
ProcRegua(SYP->(LastRec()))
Do While SYP->(!EOF()) .AND. SYP->YP_FILIAL == xFilial("SYP")
	IncProc("Verificando Tabelas que Atualizam o SYP")
    IF EMPTY(SYP->YP_CAMPO)
       SYP->(DBSKIP())
       LOOP
    ENDIF   
	IF SUBSTRING(SYP->YP_CAMPO,3,1) == "_"
		cTabAlias := "S"+LEFT(SYP->YP_CAMPO,2)
	ELSEIF SUBSTRING(SYP->YP_CAMPO,4,1) == "_"
		cTabAlias := LEFT(SYP->YP_CAMPO,3)
	ENDIF
    IF LEFT(cTabAlias,2) == "SX" //ARQUIVOS DE DICIONARIO (NESTLÉ)
       SYP->(dbSKIP())
       LOOP
    ENDIF   
	IF aScan(aTabSyp,{|x| x[1]=cTabAlias .AND. x[2]=ALLTRIM(SYP->YP_CAMPO) }) == 0
		AADD(aTabSyp,{cTabAlias,ALLTRIM(SYP->YP_CAMPO)})
	ENDIF
	SYP->(dbSKIP())
EndDo
Return .T.

*-------------------------*
Static Function ApuraTABS()
*-------------------------*
LOCAL NI       :=0
LOCAL lPRIM    := .F.
LOCAL LINDI    := .T.
LOCAL cCHAVE   :=""
LOCAL cSEQ     :=""
LOCAL cCAMPO   :=""
LOCAL CALIAS   :=""
LOCAL CALIAS1  :=""
PRIVATE cFilTab:=""
PRIVATE nOrdInd  :=0
cNomeTemp := "INDTMP"
cNTempSEC := "ITMPSE"

ProcRegua(SYP->(LastRec()))
SYP->(DBSEEK(xFilial("SYP")))

cCHAVE :=SYP->YP_CHAVE
cSEQ   :=SYP->YP_SEQ
cCAMPO :=SYP->YP_CAMPO

Do While SYP->(!EOF()) .AND. SYP->YP_FILIAL == xFilial("SYP")

    IF EMPTY(SYP->YP_CAMPO)
       SYP->(DBSKIP())
       LOOP
    ENDIF   

    IF LEFT(SYP->YP_CAMPO,1) == "X" //ARQUIVOS DE DICIONARIO (NESTLÉ)
       SYP->(dbSKIP())
       LOOP
    ENDIF   

	cCHAVE :=SYP->YP_CHAVE
	cSEQ   :=SYP->YP_SEQ
	cCAMPO :=SYP->YP_CAMPO
	
	lPRIM   :=.F.
	nPOS    :=aScan(aTabSyp,{|x| x[2]=ALLTRIM(SYP->YP_CAMPO)})
	cALIAS1 :=aTabSyp[NPOS,1]
    IF LEFT(cALIAS1,1) == "S"
       cFilTab := cALIAS1+"->"+RIGHT(cALIAS1,2)+"_FILIAL"
    ELSE
       cFilTab := cALIAS1+"->"+cALIAS1+"_FILIAL"
    ENDIF
	IncProc("Verificando BASE "+cALIAS1+"->"+(SYP->YP_CAMPO))
	IF lINDI ==.T.
		&(cALIAS1)->(DBSELECTAREA(cALIAS1))
		nOrdInd:=&(cALIAS1)->(RetIndex(cALIAS1))
		&(cALIAS1)->(INDREGUA(cALIAS1,cNomeTemp,cFilTab+"+"+ALLTRIM(SYP->YP_CAMPO))) //INDREGUA
//		&(cALIAS1)->(dbSetOrder(nOrdInd + 1))
//		&(cALIAS1)->(DBSEEK(xFilial(cALIAS1)))
		&(cALIAS1)->(DBSEEK(xFilial(cALIAS1)+SYP->YP_CHAVE))//INDREGUA
		lINDI :=.F.
	ENDIF
	IF &(cALIAS1)->(FOUND())
		DO WHILE .NOT. &(cALIAS1)->(EOF()).AND. xFilial(cALIAS1)== &(cFilTab) .AND.;
		        &(CALIAS1+"->"+(SYP->YP_CAMPO))==SYP->YP_CHAVE //VERIFICA SE EXISTE NA TABELA PRINCIPAL
			if lPRIM==.F.
				lPRIM:=.T.
			else  // DUPLICADO
				IF aScan(aTabSDUP,{|x| x[1]=cALIAS1 .AND. x[2]=ALLTRIM(SYP->YP_CAMPO) .AND. x[3]=ALLTRIM(SYP->YP_CHAVE)}) == 0
					AADD(aTabSDUP,{cALIAS1,ALLTRIM(SYP->YP_CAMPO),ALLTRIM(SYP->YP_CHAVE),ALLTRIM(SYP->YP_SEQ),&(CALIAS1+"->"+"(RECNO())"),cALIAS1,ALLTRIM(SYP->YP_CAMPO)})
				ENDIF
			ENDIF
			&(cALIAS1)->(DBSKIP())
		ENDDO
	ENDIF
	
	FOR NI := 1 TO LEN(aTabSyp)
		IF ALLTRIM( aTabSyp[NI,2])==ALLTRIM(SYP->YP_CAMPO)
			//
		ELSE
			**************************
			cALIAS :=aTabSyp[NI,1]
            IF LEFT(cALIAS,1) == "S"
               cFilTab := cALIAS+"->"+RIGHT(cALIAS,2)+"_FILIAL"
            ELSE
               cFilTab := cALIAS+"->"+cALIAS+"_FILIAL"
            ENDIF
			&(cALIAS)->(DBSELECTAREA(cALIAS))
    		nOrdInd:=&(cALIAS)->(RetIndex(cALIAS))
			&(cALIAS)->(INDREGUA(cALIAS,cNTempSEC,cFilTab+"+"+aTabSyp[NI,2])) //INDREGUA
//	    	&(cALIAS)->(dbSetOrder(nOrdInd + 1))
//			&(cALIAS)->(DBSEEK(xFilial(cALIAS)))
			&(cALIAS)->(DBSEEK(xFilial(cALIAS)+SYP->YP_CHAVE))//INDREGUA
			IF &(cALIAS)->(FOUND())
				DO WHILE .NOT. &(cALIAS)->(EOF()) .AND. xFilial(cALIAS) == &(cFilTab) .AND.;
				         &(CALIAS+"->"+(aTabSyp[NI,2]))==SYP->YP_CHAVE //VERIFICA SE EXISTE NA TABELA PRINCIPAL
                   AADD(aTabSDUP,{cALIAS,ALLTRIM(aTabSyp[NI,2]),ALLTRIM(SYP->YP_CHAVE),ALLTRIM(SYP->YP_SEQ),&(CALIAS+"->"+"(RECNO())"),"ORG",ALLTRIM(SYP->YP_CAMPO)    })//,ALLTRIM(aTabSyp[NI,1],ALLTRIM(aTabSyp[NI,2])})
				   &(cALIAS)->(DBSKIP())
				ENDDO
			ENDIF
			**************INDREGUA
  			&(cALIAS)->(RetIndex(cALIAS))
			&(cALIAS)->(FErase(cNTempSEC+OrdBagExt()))
			**************
		ENDIF
	NEXT NI
	SYP->(DBSKIP())
	DO WHILE .NOT. SYP->(EOF()) .AND. xFILIAL("SYP") == SYP->YP_FILIAL .AND. cCHAVE ==SYP->YP_CHAVE .AND. cCAMPO ==SYP->YP_CAMPO .AND. cSEQ <>SYP->YP_SEQ
		SYP->(DBSKIP())
		IncProc("Verificando BASE "+(SYP->YP_CAMPO))
	ENDDO
	IF cCAMPO <> SYP->YP_CAMPO
		lINDI :=.T.
  		&(cALIAS1)->(RetIndex(cALIAS1))
		&(cALIAS1)->(FErase(cNomeTemp+OrdBagExt()))
		
	ENDIF
ENDDO //SYP

Return .T.


*-------------------------*
Static Function FIMPRIME()
*-------------------------*
cString:="SYP"
cDesc1:= OemToAnsi("")
cDesc2:= OemToAnsi("    ")
cDesc3:= ""
tamanho:="P"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RDTESTE"
aLinha  := { }
nLastKey := 0

titulo      :=""
cabec1      :=""
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0  //Variavel que acumula numero da pagina

wnrel:="RDTESTE"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|| (RptDetail2()) })
Return

*-------------------------*
STATIC Function RptDetail2()
*-------------------------*
LOCAL N1:=0
LOCAL N2:=0
LOCAL N3:=0
LOCAL cTabAlias := ""
PRIVATE NLIN :=8

SetRegua(50) //Ajusta numero de elementos da regua de relatorios
m_pag:=m_pag+1
NLIN:=Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho

/*
@ NLIN,1 PSAY " TABELA SYP DUPLICADA"
FOR N2 := 1 TO LEN(aTabSypDUP)
NLIN :=NLIN+1
CABIMP()
@ NLIN,01       PSAY aTabSypDUP[N2,1]
@ NLIN,PCOL()+2 PSAY aTabSypDUP[N2,2]
@ NLIN,PCOL()+2 PSAY aTabSypDUP[N2,3]
@ NLIN,PCOL()+2 PSAY aTabSypDUP[N2,4]
@ NLIN,PCOL()+2 PSAY aTabSypDUP[N2,5]
NEXT N2
*/


/*
NLIN:=NLIN+2
CABIMP()
@ NLIN,01 PSAY " TABELA DUPLICADA "
NLIN :=NLIN+1
@ NLIN,01 PSAY "TAB"
@ NLIN,07 PSAY "CAMPO"
@ NLIN,20 PSAY "CHAVE"
@ NLIN,30 PSAY "SEQ"
@ NLIN,35 PSAY "RECNO"
@ NLIN,42 PSAY "ORIG.TAB"
@ NLIN,54 PSAY "ORIG.CAMPO"

FOR N3 := 1 TO LEN(aTabSDUP)
	NLIN :=NLIN+1
	CABIMP()
	IF SUBSTRING(aTabSDUP[N3,7],3,1) == "_"
		cTabAlias := "S"+LEFT(aTabSDUP[N3,7],2)
	ELSEIF SUBSTRING(aTabSDUP[N3,7],4,1) == "_"
		cTabAlias := LEFT(aTabSDUP[N3,7],3)
	ENDIF
	@ NLIN,01       PSAY aTabSDUP[N3,1]
	@ NLIN,07       PSAY aTabSDUP[N3,2]
	@ NLIN,20       PSAY aTabSDUP[N3,3]
	@ NLIN,30       PSAY aTabSDUP[N3,4]
	@ NLIN,35       PSAY aTabSDUP[N3,5]
	@ NLIN,42       PSAY cTabAlias
	@ NLIN,54       PSAY aTabSDUP[N3,7]
NEXT N3

IncRegua()

Roda(0,"","P")
Set Filter To
If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

*-------------------------*
STATIC FUNCTION CABIMP()
*-------------------------*
IF NLIN >=48
	NLIN :=8
	NLIN:=Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
ENDIF
RETURN


*-------------------------*
Static Function SYPATUALIZA()
*-------------------------*
CPROC :=SPACE(17)
NOPCA :=1

@ 10,0 TO 095,300 DIALOG oDlg3 TITLE OemToAnsi("Atualiza Base")
@ 020,010 SAY OemToAnsi("Atualiza Base ")
ACTIVATE MSDIALOG oDlg3 ON INIT EnchoiceBar(oDlg3,{||oDlg3:End() },{||NOPCA:=2,oDlg3:End() }) CENTERED

IF nOPCA==1
	Processa({|| fatualiza() })
	//	fatualiza()
ENDIF

return


*-------------------------*
Static Function fatualiza()
*-------------------------*
local n3 :=0
IF SELECT("SXE")>0
//	SXE->(DBCLOSEAREA())
//	Ferase("SXE"+GetDBExtension())
   SXE->(DBGOTOP())
   DO WHILE SXE->(!EOF())
      IF ALLTRIM(SXE->XE_ALIAS) == "SYP"
         RECLOCK("SXE",.F.,.T.)
         SXE->(DBDELETE())
         SXE->(MSUNLOCK())
      ENDIF
      SXE->(DBSKIP())   
   ENDDO
ENDIF

IF SELECT("SXF")>0
//	SXF->(DBCLOSEAREA())
//	Ferase("SXF"+GetDBExtension())
   SXF->(DBGOTOP())
   DO WHILE SXF->(!EOF())
      IF ALLTRIM(SXF->XF_ALIAS) == "SYP"
         RECLOCK("SXF",.F.,.T.)
         SXF->(DBDELETE())
         SXF->(MSUNLOCK())
      ENDIF
      SXF->(DBSKIP())   
   ENDDO
ENDIF

ProcRegua(LEN(aTabSDUP))
FOR N3 := 1 TO LEN(aTabSDUP)
	IncProc("Atualizando Tabelas "+STR(N3)+"/"+STR(LEN(aTabSDUP)))
	//AADD(aTabSDUP,{cALIAS,ALLTRIM(SYP->YP_CAMPO),ALLTRIM(SYP->YP_CHAVE),ALLTRIM(SYP->YP_SEQ),&(CALIAS+"->"+"(RECNO())")})
	//                1                 2                    3                      4                   5
	cMENSAGEM:="Usuario favor atualizar a descricao"
	&(aTabSDUP[N3,1])->(dbselectarea(aTabSDUP[N3,1]))
	&(aTabSDUP[N3,1])->(DBGOTO(aTabSDUP[N3,5]))
	MSMM(ALLTRIM(aTabSDUP[N3,2]),60,,cMENSAGEM,1,,,aTabSDUP[n3,1],aTabSDUP[N3,2])
next n3

RETURN

*-----------------------------------------------------------------------------------------------------*
* Fim do programa QBG_SYP
*-----------------------------------------------------------------------------------------------------*

*/

