#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � FLAGEST  � Autor � Cleber Neves          � Data � 09/08/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retira os flags de contabilizacao do modulo Faturamento	  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Redimix e Pedreira                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FLAGFAT
STATIC oBUTTON1
STATIC oBUTTON2
STATIC oBUTTON3
STATIC oSAY1
STATIC oSAY2
STATIC oSAY3

ValidPerg()
cPerg:= "FLAGCO"


//DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM 106,65 TO 700,835  OF oMainWnd pixel
DEFINE MSDIALOG oDlg TITLE "Retira Flag de Contabilizacao-FATURAMENTO"  FROM 200,1 TO 380,380  COLORS 0, 16777215 PIXEL 
@ 16,018 Say oSay1 PROMPT " Este programa tem o objetivo de remover os flags de contabili- " SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL
@ 24,018 Say oSay2 PROMPT " zacao do modulo FATURAMENTO.Os registros com os flags removidos" SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL
@ 32,018 Say oSay3 PROMPT " estarao aptos para nova contabilizacao.                        " SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL

@ 40, 18 BUTTON oButton1 PROMPT "Perguntas" SIZE 37,12 of oDLG ACTION Pergunte(cPerg,.T.) PIXEL
@ 40, 50 BUTTON oButton2 PROMPT "Executa" SIZE 37,12 of oDLG ACTION u_PROCFAT() PIXEL
@ 40, 80 BUTTON oButton3 PROMPT "Sair" SIZE 37,12 of oDLG ACTION Close(oDlg) PIXEL

//DEFINE BMPBUTTON FROM 75,128 TYPE 01 ACTION ProcFat() ENABLE OF oDlg
//DEFINE BMPBUTTON FROM 75,158 TYPE 02 ACTION Close(oDlg) ENABLE OF oDlg

Activate MSDialog oDlg Centered

Return()
//@ 02,05 TO 070,185 OF oDlg PIXEL

USER Function ProcFat
Processa({|| u_ProcF2() })
Return()

User Function ProcF2

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//ValidPerg()
//Pergunte("FLAGCO",.T.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        // Da Data                                   �
//� mv_par02        // Ate a Data                                �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Processa arquivo de Notas Fiscais de Entrada.                �
//����������������������������������������������������������������

//����������������������������������������������������������������Ŀ
//� Cria Index Condicional para o SF2.				   �
//������������������������������������������������������������������
dbSelectArea("SF2")
cIndSF2 := CriaTrab(Nil,.f.)
cCond	:= "F2_EMISSAO >= Mv_Par01 .And. F2_EMISSAO <= Mv_Par02"
cChave  := "F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA"
IndRegua("SF2",cIndSF2,cChave,,cCond,"Notas de Saida....")
DbGoTop()
ProcRegua(RecCount())

While ! Eof()

      IncProc()

      RecLock("SF2")
      SF2->F2_DTLANC:= Ctod("")
      MsUnLock()

      dbSkip()

End


//��������������������������������������������������������������Ŀ
//� Retorna condicao original.                                   �
//����������������������������������������������������������������
FErase(cIndSF2+"*.*")
Return

//*****************************************************************************
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor � Cleber Neves          � Data � 02/03/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC Function ValidPerg()
_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("FLAGCO",10)
//cPerg :="FLAGCO"
aRegs :={}
aAdd(aRegs,{cPerg,"01","Da Data                 ?","","","mv_cha","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aAdd(aRegs,{cPerg,"02","Ate a Data              ?","","","mv_chb","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)
Return