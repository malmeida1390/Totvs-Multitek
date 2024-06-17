#include "rwmake.ch

User Function Import_H1()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis utilizadas no programa atraves da funcao    Ё
//Ё SetPrvt, que criara somente as variaveis definidas pelo usuario,    Ё
//Ё identificando as variaveis publicas do sistema utilizadas no codigo Ё
//Ё Incluido pelo assistente de conversao do AP5 IDE                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

SetPrvt("_CALIAS,_NRECNO,_NORDEM,_CNOMEARQ,_CCAMINHO,_CDIRETORIO")
SetPrvt("_CARQUIVO,_NCODCLI,_NNROCOM,A1_NROCOM")
SetPrvt("A1_DTULCHQ,A1_BAIRROE,A1_CEPE,A1_MUNE,A1_ESTE,_ACAMPOS")
SetPrvt("_CARQTMP,_CNUMCGC,_NTAMANHO,_CDVC,_CCGC,_CDIG")
SetPrvt("J,_NCNT,_NSUM,I,_NDIG,_LRET1")
SetPrvt("_LRET2,_CCPF,")

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁIMPORT_H1 Ё Autor Ё Anderson              Ё Data Ё 26/11/03 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao Ё Importar historico SIM + EIS	 							  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё Especifico Multi-Tek                                       Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё                                                                       Ё╠╠
╠╠ЁUpDate.....: 														  Ё╠╠
╠╠ЁAutor..... :        				                    			      Ё╠╠
╠╠ЁSolicitante:						 									  Ё╠╠
╠╠ЁFuncao.....:                                                           Ё╠╠
╠╠Ё                                                                       Ё╠╠
╠╠юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Guarda Ambiente 														  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
_cAlias := ALIAS()
_nRecno := RECNO()
_nOrdem := INDEXORD()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Desenha a tela de apresentacao da rotina								  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
_cNomeArq := "        "
_cCaminho := "\SIGAADV\CARGA\            "
@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Interface : TXT -> SQL"
@ 08,010 TO 084,222
@ 91,168 BMPBUTTON TYPE 1 ACTION GERARSQL()
@ 91,196 BMPBUTTON TYPE 2 ACTION Fim1()
@ 24,014 SAY "Esta rotina tem como objetivo gerar a tabela SZ9 a partir de um arquivo TXT."
@ 39,014 SAY "Digite o nome do arquivo a importar : "
@ 39,105 GET _cNomeArq Picture "@!" Valid !(Empty(_cNomeArq))
@ 54,014 SAY "Digite o caminho : "
@ 54,060 GET _cCaminho Picture "@!" Valid !(Empty(_cCaminho))
@ 69,014 SAY "* MULTI-TEK *"
ACTIVATE DIALOG oDlg1 Center

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Retorna Ambiente														  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

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

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Carrega Regua de Processamento											  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
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
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza em SZ9. 			     			   		          Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
	DbSelectArea("SZ9")
	RecLock("SZ9",.T.)
	SZ9->Z9_FILIAL		:= xFilial("SZ9")
	SZ9->Z9_ANO			:= Alltrim(TRB->ANOCOD)
	SZ9->Z9_MES			:= Strzero(Val(Alltrim(TRB->MESCOD)),2)
	SZ9->Z9_SIMIL		:= Alltrim(TRB->SMLCOD)
	SZ9->Z9_EIS01		:= Alltrim(TRB->RS1COD)
	SZ9->Z9_EIS02		:= Alltrim(TRB->RS2COD)
	SZ9->Z9_EIS03		:= Alltrim(TRB->RS3COD)
	SZ9->Z9_EIS04		:= Alltrim(TRB->RS4COD)
	SZ9->Z9_EIS05		:= Alltrim(TRB->RS5COD)
	SZ9->Z9_EIS06		:= Alltrim(TRB->RS6COD)
	SZ9->Z9_EIS07		:= Alltrim(TRB->RS7COD)
	SZ9->Z9_EIS08		:= Alltrim(TRB->RS8COD)
	SZ9->Z9_EIS09		:= Alltrim(TRB->RS9COD)
	SZ9->Z9_EIS10		:= Alltrim(TRB->RS0COD)
	SZ9->Z9_SLDMALH		:= Val(TRB->QTDDIS)
	SZ9->Z9_QTDSAI		:= Val(TRB->QTDCNS)
	SZ9->Z9_QTDAPA		:= Val(TRB->QTDAPA)
	SZ9->Z9_GRP_EIS		:= Val(TRB->QTDEIS)
	SZ9->Z9_VLRCM		:= Val(TRB->CSTTOT)
	SZ9->Z9_ABC			:= Alltrim(TRB->ABCCOD)
	SZ9->Z9_PQR			:= Alltrim(TRB->POPCOD)
    SZ9->Z9_ORIGEM		:= Alltrim(TRB->ORGCOD)
	SZ9->Z9_XYZ			:= Alltrim(TRB->CRTCOD)
	SZ9->Z9_123			:= Alltrim(TRB->AQSCOD)
	SZ9->Z9_NEOIL		:= Alltrim(TRB->TDMCOD)
	SZ9->Z9_LEAD		:= Val(TRB->LDTCOD)
	SZ9->Z9_METDIM		:= Alltrim(TRB->MDECOD)
	SZ9->Z9_POS_EST		:= Alltrim(TRB->IEQCOD)
	SZ9->Z9_SIST_TR		:= Alltrim(TRB->STRCOD)
	//SZ9->Z9_SLDPD3		:= 0 // Por enquanto ZERADO
	//SZ9->Z9_SLD3EM		:= 0 // Por enquanto ZERADO
	//SZ9->Z9_SLDFIL		:= 0 // Por enquanto ZERADO
	//SZ9->Z9_SLDMTZ		:= 0 // Por enquanto ZERADO
	MsUnLock()
	
	DbSelectArea("TRB")
	DbSkip()
	
EndDo

Return(Nil)


******************
Static FUNCTION CRIA_TRB()
******************
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria Arquivo de Trabalho									 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

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
AADD(_aCampos,{"QTDDIS","C",14,4})
AADD(_aCampos,{"QTDCNS"	,"C",14,4})
AADD(_aCampos,{"QTDAPA"	,"C",08,2})
AADD(_aCampos,{"QTDEIS","C",06,0})
AADD(_aCampos,{"CSTTOT"	,"C",14,2})
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
