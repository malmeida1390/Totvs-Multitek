#include "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ATU_SX3  � Autor � Edelcio Cano          � Data � 05/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza Custo STD atraves da Lista de preco especifica da ���
��� 		 � Multi-Tek.                                             	  ���
��� 		 �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Multi-Tek                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/

User Function ATU_SX3()

//���������������������������������������������������������������������������Ŀ
//� Guarda Ambiente 														                  �
//�����������������������������������������������������������������������������
Private _cArquivo	:= ""
Private _cPasta   := "\ATU_SX3\"
Private _aLog 	   := {}
Private _aAreaAtu := GetArea()
Private _cPerg    := "ATUSX3"
Private _lRetorno := .T.
Private _nRegLista:= 0

dbSelectArea("SB1")
_aAreaB1	:=	GetArea()

//������������������������������������Ŀ
//�          Perguntas                 �
//�mv_par01    -  Arquivo de Entrada   �
//��������������������������������������
Validperg()

pergunte(_cPerg,.F.) // Sempre Le a ultima solicitacao com base no SX1


cArquivo1 := _cPasta + AllTrim(mv_par01) + ".DTC"

cArquivo2 := _cPasta + AllTrim(mv_par02) + ".DTC"



//���������������������������������������������������������������������������Ŀ
//� Desenha a tela de apresentacao da rotina								  �
//�����������������������������������������������������������������������������
@ 96,042 TO 333,510 DIALOG oDlg1 TITLE "Compatibilizador SX3 - Virada                       "
@ 08,010 TO 084,222
@ 91,138 BMPBUTTON TYPE 5 ACTION PergList()
@ 91,168 BMPBUTTON TYPE 1 ACTION (CustList(),oDlg1:End())
@ 91,196 BMPBUTTON TYPE 2 ACTION Fim1()
@ 24,014 SAY "o Campo SF3 esta com as consultas incorretas e necessario colocar as consultas "
@ 34,014 SAY "que estavamos utilizando anteriormente antes da virada, ou seja o compatibilizador"
@ 44,014 SAY "da Microsiga sobrepoem os X3_F3 que foram  customizados                         "
@ 54,014 SAY "adicionar somente os registros novos a estrutura que no caso e do AP 12        "
@ 74,014 SAY "Nao sobrepondo como ocorre com o compatibilizador da Microsiga.                "
ACTIVATE DIALOG oDlg1 Center

//���������������������������������������������������������������������������Ŀ
//� Retorna Ambiente														  �
//�����������������������������������������������������������������������������

RETURN

**************
Static FUNCTION Fim1()
**************

RestArea(_aAreaAtu)
Close(oDlg1)

Return

Static Function PergList()

Do While .T.
	
	_lRetorno := Pergunte(_cPerg)
	
	cArquivo1 := _cPasta + AllTrim(mv_par01) + ".DTC"
	
	cArquivo2 := _cPasta + AllTrim(mv_par02) + ".DTC"
	
	
	If !_lRetorno
		Exit
	Endif
	
	If EMPTY(cArquivo1)
		MsgBox("Rotina CANCELADA - Nome do arquivo1 em branco...","ERRO")
		_lRetorno := .F.
	Else
		If !File(cArquivo1)
			MsgBox("Rotina CANCELADA - Verifique o nome do arquivo1 digitado...","ERRO")
			_lRetorno := .F.
		EndIf
	EndIf
	
	If EMPTY(cArquivo2)
		MsgBox("Rotina CANCELADA - Nome do arquivo2 em branco...","ERRO")
		_lRetorno := .F.
	Else
		If !File(cArquivo2)
			MsgBox("Rotina CANCELADA - Verifique o nome do arquivo2 digitado...","ERRO")
			_lRetorno := .F.
		EndIf
	EndIf
	
	
	IF  _lRetorno
		Exit
	Endif
	
Enddo

Return


Static Function CustList()

//���������������������������������������������������������������������������Ŀ
//� Carrega Regua de Processamento											  �
//�����������������������������������������������������������������������������
Processa({|| PROC_TMP()},"Processando")

Return


**********************
Static Function PROC_TMP()
**********************

_aLog 	    := {} //Vetor do Log de erro
aTabelas    := {}

Use &cArquivo1 Alias _cArquivo1 NEW
dbgotop()

Use &cArquivo2 Alias _cArquivo2 NEW
dbgotop()


//
// Adiciona a um Vetor Campos e SF3 utilizados.
//
DbSelectArea("_cArquivo2")
procregua(Reccount())

DbgoTop()
While !_cArquivo2->(EOF())

		IncProc()
	
	nPos := Ascan(aTabelas , { |X| X[1] = ALLTRIM(_cArquivo2->X3_CAMPO) } )
	
	IF nPos == 0
		AADD(aTabelas, { ALLTRIM(_cArquivo2->X3_CAMPO) ,  _cArquivo2->X3_F3 }  )
	Endif

	DbSelectArea("_cArquivo2")
	_cArquivo2->(DbSkip())
	
Enddo


//
// Atualiza o X3_F3 da producao com as consultas Corretas.
//
DbSelectArea("_cArquivo1")
procregua(Reccount())
DbgoTop()

While !_cArquivo1->(EOF())

	IncProc()
	
	nPos := Ascan(aTabelas , { |X| X[1] = ALLTRIM(_cArquivo1->X3_CAMPO) } )
	
	IF nPos <> 0
		
		If !Empty(aTabelas[nPos][2])
			
			IF ALLTRIM(_cArquivo1->X3_F3) <> ALLTRIM(aTabelas[nPos][2])
				Reclock("_cArquivo1",.F.)
				_cArquivo1->X3_F3 := aTabelas[nPos][2]
				MsUnlock()
			Endif
			
		Endif
		
	Endif
	
	DbSelectArea("_cArquivo1")
	_cArquivo1->(DbSkip())
	
Enddo


Return


dbSelectarea("_cArquivo1")
dbclosearea()

dbSelectarea("_cArquivo2")
dbclosearea()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraLog  � Autor � Edelcio Cano          � Data � 16/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que efetuara a gravacao do arquivo de LOG           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraLog(_cString1)

AADD(_aLog,_cString1)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � _Imprime � Autor � Edelcio Cano          � Data � 16/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do LOG de ocorrencias na importacao              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _Imprime()

titulo    := "Ocorrencias na importacao diaria"
cDesc1    := PADC("Emiss�o do relatorio com as ocorrencias",74)
cDesc2    := PADC("do Calculo do Custo Std a partir da ",74)
cDesc3    := PADC("Lista de Precos - Especifico Multi-Tek",74)
tamanho   := "P"
limite    := 80
cString   := "SE2"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "MTKLISTPR"
nLastKey  := 0
//            0       10       20       30       40       50       60       70
//            .12345679.12345679.12345679.12345679.12345679.12345679.12345679.123456789.
cabec1    := " Ocorrencias do Calculo de Custo Std"
cabec2    := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao dos Cabecalhos e Rodape  �
//����������������������������������������������������������������
cbtxt   := Space(10)
cbcont  := 00
li      := 80
m_pag   := 01

wnrel := "MTKLISTPR"
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � _ImpNow  � Autor � Edelcio Cano          � Data � 16/07/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicio da Impressao (Para funcionamento da REGUA)          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _ImpNow()

nTipo     := IF(aReturn[4]==1,15,18)

procregua(Len(_aLog))

For _i := 1 to Len(_aLog)
	
	IncProc("Imprimindo, aguarde ...")
	
	If li > 59
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := prow() + 1
	EndIf
	
	@ li, 000 PSAY _aLog[_i]
	
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �_CRIASX1  � Autor �Edelcio Cano        � Data �  05/07/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar que valida ou cria perguntas no SX1        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg()

Local aRegs     := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,6)+space(4)

//X1_GRUPO/X1_ORDEM/X1_PERGUNT/X1_PERSPA/X1_PERENG/X1_VARIAVL/X1_TIPO/X1_TAMANHO/X1_DECIMAL/X1_PRESEL/X1_GSC/X1_VALID/X1_VAR01/X1_DEF01/X1_DEFSPA1/X1_DEFENG1/X1_CNT01/X1_VAR02/X1_DEF02/X1_DEFSPA2/X1_DEFENG2/X1_CNT02/X1_VAR03/X1_DEF03/X1_DEFSPA3/X1_DEFENG3/X1_CNT03/X1_VAR04/X1_DEF04/X1_DEFSPA4/X1_DEFENG4/X1_CNT04/X1_VAR05/X1_DEF05/X1_DEFSPA5/X1_DEFENG5/X1_CNT05/X1_F3/X1_GRPSXG
//Grupo   /Ordem   /Pergunta  /         /            /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01   /Def01   /          /          /Cnt01   /Var02   /Def02   /          /          /Cnt02   /Var03   /Def03   /          /          /Cnt03   /Var04   /Def04   /          /          /Cnt04   /Var05   /Def05   /          /          /Cnt05   /F3   /Grupo SXG
aAdd(aRegs,{_cPerg,"01","SX3 Ap10 R3 Atual    ?","","","mv_ch1","C",12,0,0,"G","","mv_par01",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{_cPerg,"02","SX3 AP10 OLD      ?","","","mv_ch2","C",12,0,0,"G","","mv_par02",""             ,"","","","",""           ,"","","","",""     ,"","","","","","","","","","","","","","   ",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return
