#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � FLAGFIN  � Autor � Cleber Neves          � Data � 09/08/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retira os flags de contabilizacao do modulo Financeiro.    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Redimix e Pedreira                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas no programa                             �
//����������������������������������������������������������������
USER FUNCTION FLAGFIN()
STATIC oBUTTON1
STATIC oBUTTON2
STATIC oBUTTON3
STATIC oSAY1
STATIC oSAY2
STATIC oSAY3
//ValidPerg()
cPerg:= "FLAGCO"

DEFINE MSDIALOG oDlg TITLE "Retira Flag de Contabilizacao-FINANCEIRO"  FROM 200,1 TO 380,380  COLORS 0, 16777215 PIXEL 
@ 16,018 Say oSay1 PROMPT " Este programa tem o objetivo de remover os flags de contabili- " SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL
@ 24,018 Say oSay2 PROMPT " zacao do modulo FINANCEIRO.Os registros com os flags removidos" SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL
@ 32,018 Say oSay3 PROMPT " estarao aptos para nova contabilizacao.                        " SIZE 160,7 OF oDlg COLORS 0, 1677721 PIXEL

@ 40, 18 BUTTON oButton1 PROMPT "Perguntas" SIZE 37,12 of oDLG ACTION Pergunte(cPerg,.T.) PIXEL
@ 40, 55 BUTTON oButton2 PROMPT "Executa" SIZE 37,12 of oDLG ACTION u_PROCFIN() PIXEL
@ 40, 90 BUTTON oButton3 PROMPT "Sair" SIZE 37,12 of oDLG ACTION Close(oDlg) PIXEL

Activate MSDialog oDlg Centered


Return()

USER Function ProcFin
Processa({|| u_ExecE() })
Return()

USER Function ExecE
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("FLAGCO",.T.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        // Da Data                                   �
//� mv_par02        // Ate a Data                                �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Processa arquivo de Titulos a Receber.                       �
//����������������������������������������������������������������

//����������������������������������������������������������������Ŀ
//� Cria Index Condicional para o SF1.                             �
//������������������������������������������������������������������
dbSelectArea("SE1")
cIndSE1 := CriaTrab(Nil,.f.)
cCond   := "E1_EMISSAO >= Mv_Par01 .And. E1_EMISSAO <= Mv_Par02"
cChave  := "E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA"
IndRegua("SE1",cIndSE1,cChave,,cCond,"Titulos a Receber ...")
DbGoTop()
ProcRegua(RecCount())

While ! Eof()

      IncProc()

      RecLock("SE1")
      SE1->E1_LA:= ""        
      MsUnLock()

      dbSkip()

End

RetIndex("SE1")

//��������������������������������������������������������������Ŀ
//� Processa arquivo de Titulos a Pagar.                         �
//����������������������������������������������������������������

//����������������������������������������������������������������Ŀ
//� Cria Index Condicional para o SE2.                             �
//������������������������������������������������������������������
dbSelectArea("SE2")
cIndSE2 := CriaTrab(Nil,.f.)
cCond   := "E2_EMISSAO >= Mv_Par01 .And. E2_EMISSAO <= Mv_Par02 .And. Subs(E2_ORIGEM,1,4)$'FINA'"
cChave  := "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA"
IndRegua("SE2",cIndSE2,cChave,,cCond,"Titulos a Pagar ...")
DbGoTop()
ProcRegua(RecCount())

While ! Eof() 

      IncProc()

      RecLock("SE2")
      SE2->E2_LA:= ""                
      MsUnLock()

      dbSkip()

End

RetIndex("SE2")

//��������������������������������������������������������������Ŀ
//� Processa arquivo de Movimentacao Bancaria.                   �
//����������������������������������������������������������������

//����������������������������������������������������������������Ŀ
//� Cria Index Condicional para o SE5.                             �
//������������������������������������������������������������������
dbSelectArea("SE5")
cIndSE5 := CriaTrab(Nil,.f.)
cCond   := "E5_DATA >= Mv_Par01 .And. E5_DATA <= Mv_Par02"
cChave  := "E5_PREFIXO+E5_NUMERO+E5_PARCELA"
IndRegua("SE5",cIndSE5,cChave,,cCond,"Mov. Bancaria ...")
DbGoTop()
ProcRegua(RecCount())

While ! Eof() 

      IncProc()

      RecLock("SE5")
      SE5->E5_LA:= ""                
      MsUnLock()

      dbSkip()

End

RetIndex("SE5")

//��������������������������������������������������������������Ŀ
//� Processa arquivo de Cheques.                                 �
//����������������������������������������������������������������

//����������������������������������������������������������������Ŀ
//� Cria Index Condicional para o SEF.                             �
//������������������������������������������������������������������
dbSelectArea("SEF")
cIndSEF := CriaTrab(Nil,.f.)
cCond   := "EF_DATA >= Mv_Par01 .And. EF_DATA <= Mv_Par02"
cChave  := "EF_FILIAL+EF_NUM"
IndRegua("SEF",cIndSEF,cChave,,cCond,"Cheques ...")
DbGoTop()
ProcRegua(RecCount())

While ! Eof() 

      IncProc()

//      IF Alltrim(SEF->EF_ORIGEM) == "FINA190"
         RecLock("SEF")
         SEF->EF_LA    := ""
         MsUnLock()
//      EndIF

      dbSkip()

End

RetIndex("SEF")

//��������������������������������������������������������������Ŀ
//� Retorna condicao original.                                   �
//����������������������������������������������������������������
FErase(cIndSE1+"*.*")
FErase(cIndSE2+"*.*")
FErase(cIndSE5+"*.*")
FErase(cIndSEF+"*.*")

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

STATIC Function ValidPerg
_sAlias := Alias()																		
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("FLAGCO",10)
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
