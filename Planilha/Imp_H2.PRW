#include "rwmake.ch

User Function Imp_H2()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CNOMEARQ,_CCAMINHO,_CDIRETORIO")
SetPrvt("_CARQUIVO,_NCODCLI,_NNROCOM,A1_NROCOM")
SetPrvt("A1_DTULCHQ,A1_BAIRROE,A1_CEPE,A1_MUNE,A1_ESTE,_ACAMPOS")
SetPrvt("_CARQTMP,_CNUMCGC,_NTAMANHO,_CDVC,_CCGC,_CDIG")
SetPrvt("J,_NCNT,_NSUM,I,_NDIG,_LRET1")
SetPrvt("_LRET2,_CCPF,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿔MP_H2    � Autor � Anderson              � Data � 26/11/03 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Importar historico SKU   	 							  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico Multi-Tek                                       낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�                                                                       낢�
굇쿢pDate.....: 														  낢�
굇쿌utor..... :        				                    			      낢�
굇쿞olicitante:						 									  낢�
굇쿑uncao.....:                                                           낢�
굇�                                                                       낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Guarda Ambiente 														  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Desenha a tela de apresentacao da rotina								  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
_cNomeArq := "        "
_cCaminho := "\SIGAADV\CARGA\            "
@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Interface : TXT -> SQL"
@ 08,010 TO 084,222
@ 91,168 BMPBUTTON TYPE 1 ACTION GERARSQL()
@ 91,196 BMPBUTTON TYPE 2 ACTION Fim1()
@ 24,014 SAY "Esta rotina tem como objetivo gerar a tabela SZA a partir de um arquivo TXT."
@ 39,014 SAY "Digite o nome do arquivo a importar : "
@ 39,105 GET _cNomeArq Picture "@!" Valid !(Empty(_cNomeArq))
@ 54,014 SAY "Digite o caminho : "
@ 54,060 GET _cCaminho Picture "@!" Valid !(Empty(_cCaminho))
@ 69,014 SAY "* MULTI-TEK *"
ACTIVATE DIALOG oDlg1 Center

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Retorna Ambiente														  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Return()


****************
Static FUNCTION Fim1()
****************


dbSelectArea(_cAlias)
dbSetOrder(_nOrdem)
dbGoto(_nRecno)

Close(oDlg1)

Return()


*******************
Static FUNCTION GERARSQL()
*******************

_cDiretorio := AllTrim(_cCaminho)
_cArquivo   := AllTrim(_cNomeArq)+".TXT"

If EMPTY(_cNomeArq) .or. EMPTY(_cDiretorio)
	Return
Else
	If !File(_cDiretorio+_cArquivo)
		Close(oDlg1)
		MsgBox("Rotina CANCELADA - Verifique o nome do arquivo digitado...","ERRO")
		RETURN
	EndIf
EndIf

CRIA_TRB()	  // Cria arquivo temporario de trabalho, sua estrutura deve ser identica ao LAY-OUT do arquivo TXT.

dbSelectArea("TRB")
APPEND FROM &(_cDiretorio+_cArquivo) DELIMITED WITH ","  // Importa os dados do arquivo TXT para o temporario.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Carrega Regua de Processamento											  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Processa({|| PROC_TMP()})// Substituido pelo assistente de conversao do AP5 IDE em 07/06/00 ==> Processa({|| Execute(PROC_TMP)})

dbSelectarea("TRB")
dbCloseArea()

Ferase(_cArqTmp+".DBF")
Ferase(_cArqTmp+OrdBagExt())

Fim1()

Return()


*****************
Static FUNCTION PROC_TMP()
*****************

/*
If TCCanOpen(RETSQLNAME("SA1"))
TCSQLEXEC("TRUNCATE TABLE "+RETSQLNAME("SA1"))
EndIf
*/

dbSelectArea("TRB")
dbGoTop()
ProcRegua(RECCOUNT())

While !EOF()
	
	IncProc(OEMtoAnsi("Atualizando arquivo..."))
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Atualiza em SA1. 											 �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	
	DbSelectArea("SZA")
	RecLock("SZA",.T.)
	SZA->ZA_FILIAL		:= xFilial("SZA")
	SZA->ZA_ANO			:= Alltrim(TRB->ANOCOD)
	SZA->ZA_MES			:= Strzero(Val(Alltrim(TRB->MESCOD)),2)
	SZA->ZA_SIMIL		:= Alltrim(TRB->SMLCOD)
	SZA->ZA_EIS01		:= Alltrim(TRB->RS1COD)
	SZA->ZA_EIS02		:= Alltrim(TRB->RS2COD)
	SZA->ZA_EIS03		:= Alltrim(TRB->RS3COD)
	SZA->ZA_EIS04		:= Alltrim(TRB->RS4COD)
	SZA->ZA_EIS05		:= Alltrim(TRB->RS5COD)
	SZA->ZA_EIS06		:= Alltrim(TRB->RS6COD)
	SZA->ZA_EIS07		:= Alltrim(TRB->RS7COD)
	SZA->ZA_EIS08		:= Alltrim(TRB->RS8COD)
	SZA->ZA_EIS09		:= Alltrim(TRB->RS9COD)
	SZA->ZA_EIS10		:= Alltrim(TRB->RS0COD) 
	SZA->ZA_SKU			:= Alltrim(TRB->SKUCOD)
	SZA->ZA_QTDSAI		:= Val(TRB->QTDCNS)
	SZA->ZA_QTD_SKU		:= Val(TRB->QTDSKU)
	SZA->ZA_SD_MALH		:= Val(TRB->QTDDIS)
	SZA->ZA_QTDAPA		:= Val(TRB->QTDAPA)
	SZA->ZA_CODREF		:= Alltrim(TRB->REFCOD)
	SZA->ZA_SUFIXO		:= Alltrim(TRB->SUFCOD)
	SZA->ZA_MARCA		:= Alltrim(TRB->MCACOD)
	SZA->ZA_VLRCM		:= Val(TRB->CSTMEDTOT)
	SZA->ZA_ABC			:= Alltrim(TRB->ABCCOD)
	SZA->ZA_PQR			:= Alltrim(TRB->POPCOD)
	SZA->ZA_ORIGEM		:= Alltrim(TRB->ORGCOD)
	SZA->ZA_XYZ			:= Alltrim(TRB->CRTCOD)
	SZA->ZA_123			:= Alltrim(TRB->AQSCOD)
	SZA->ZA_NEOIL		:= Alltrim(TRB->TDMCOD)
	SZA->ZA_LEAD		:= Val(TRB->LDTCOD) 
	SZA->ZA_METDIM		:= Alltrim(TRB->MDECOD) 
	SZA->ZA_POS_EST		:= Alltrim(TRB->IEQCOD) 
	SZA->ZA_SIST_TR		:= Alltrim(TRB->STRCOD) 

	//SZA->ZA_SLDPD3		:= 0 // Por enquanto ZERADO
	//SZA->ZA_SLD3EM		:= 0 // Por enquanto ZERADO
	//SZA->ZA_SLDFIL		:= 0 // Por enquanto ZERADO
	//SZA->ZA_SLDMTZ		:= 0 // Por enquanto ZERADO
	MsUnLock()
	
	DbSelectArea("TRB")
	DbSkip()
	
EndDo

Return(Nil)


******************
Static FUNCTION CRIA_TRB()
******************
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria Arquivo de Trabalho									 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_aCampos := {}

AADD(_aCampos,{"ANOCOD"	,"C",04,0})
AADD(_aCampos,{"MESCOD"	,"C",02,0})
AADD(_aCampos,{"SMLCOD"	,"C",06,0})
AADD(_aCampos,{"RS1COD"	,"C",02,0})
AADD(_aCampos,{"RS2COD"	,"C",02,0})
AADD(_aCampos,{"RS3COD"	,"C",02,0})
AADD(_aCampos,{"RS4COD"	,"C",02,0})
AADD(_aCampos,{"RS5COD"	,"C",02,0})
AADD(_aCampos,{"RS6COD"	,"C",02,0})
AADD(_aCampos,{"RS7COD"	,"C",02,0})
AADD(_aCampos,{"RS8COD"	,"C",02,0})
AADD(_aCampos,{"RS9COD"	,"C",02,0})
AADD(_aCampos,{"RS0COD"	,"C",02,0})
AADD(_aCampos,{"SKUCOD"	,"C",06,0})
AADD(_aCampos,{"QTDCNS"	,"C",14,4})
AADD(_aCampos,{"QTDSKU"	,"C",06,0})
AADD(_aCampos,{"QTDDIS"	,"C",14,4})
AADD(_aCampos,{"QTDAPA"	,"C",08,2}) 
AADD(_aCampos,{"REFCOD"	,"C",17,0}) 
AADD(_aCampos,{"SUFCOD"	,"C",09,0}) 
AADD(_aCampos,{"MCACOD"	,"C",03,0}) 
AADD(_aCampos,{"CSTMEDTOT","C",14,2})
AADD(_aCampos,{"ABCCOD"	,"C",01,0})
AADD(_aCampos,{"POPCOD"	,"C",01,0})
AADD(_aCampos,{"ORGCOD"	,"C",01,0})
AADD(_aCampos,{"CRTCOD"	,"C",01,0})
AADD(_aCampos,{"AQSCOD"	,"C",01,0})
AADD(_aCampos,{"TDMCOD"	,"C",01,0})
AADD(_aCampos,{"LDTCOD"	,"C",05,0})
AADD(_aCampos,{"MDECOD"	,"C",01,0})
AADD(_aCampos,{"IEQCOD"	,"C",01,0})
AADD(_aCampos,{"STRCOD"	,"C",01,0})

_cArqTmp := CriaTrab( _aCampos )
dbUseArea( .T.,, _cArqTmp, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )

Return()
