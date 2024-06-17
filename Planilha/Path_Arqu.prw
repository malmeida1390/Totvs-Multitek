#include "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � Path_Arqu� Autor � Almeida               � Data � 03.12.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para solicitacao do nome do Arquivo a ser gerado.   ���
���          � Sendo User pode ser chamada por qualquer programa.         ���
���Retorna   � O caminho completo com o nome do arquivo a ser gerado      ���
���          � ou Vazio caso nao deseje escolher nenhum arquivo.          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Path_Arqu()
Local nX 		 := 0
Local aSize      := {}
Local aPosGet    := {}
Local nOpca      := 0
Local bSetKey4           

Private cNomeArq := SPACE(10)
Private cTipo    := "XLS"
Private aTipo    := {"XLS","TXT"}
Private cPath	 := AllTrim(GetTempPath())

Private oDlgNew,oPath,oTipo,oNomeArq,oInfome   

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
aSize := MsAdvSize()                           //315 - Tam. Janela Vertical

aPosGet := MsObjGetPos(aSize[3]-aSize[1],50,;
{{01,10},{01,10},{01,10},{15,20}} )

//DEFINE MSDIALOG oDlgNew TITLE "Geracao de Arquivos da Planilha" From aSize[7],0 to aSize[6]-210,aSize[5]-230 of oMainWnd PIXEL
DEFINE MSDIALOG oDlgNew TITLE "Geracao de Arquivos da Planilha" From 0,0 to 230,700 of oMainWnd PIXEL
bSetKey4 :=SetKey(VK_F4 , nil ) // Ativando F4
 
@ 10,aPosGet[2,1] SAY oNomeArq PROMPT "Informe o nome do Arquivo: " SIZE 060,20 PIXEL OF oDlgNew
@ 10,aPosGet[2,2] MSGET oNomeArq Var cNomeArq  Picture "@!"  Of oDlgNew PIXEL Size 40,8 valid (ValNome(cNomeArq))
@ 10,aPosGet[2,2]+50 SAY oInfome  PROMPT "(Nao e necessario Extencao do Arquivo)" SIZE 100,20 PIXEL OF oDlgNew
   
@ 35,aPosGet[2,1] SAY oTipo    PROMPT "Tipo do Arquivo: " SIZE 80,8 OF oDlgNew PIXEL  
@ 35,aPosGet[2,2] MSCOMBOBOX oTipo VAR cTipo ITEMS aTipo  SIZE 30,8 OF oDlgNew PIXEL;
ON CHANGE ( VALTIPO(cTipo) )

@ 60,aPosGet[2,1] SAY oNomeDir PROMPT "Diretorio: "  	   SIZE  120,08 PIXEL OF oDlgNew
@ 60,aPosGet[2,2] MSGET oPath  VAR cPath            Of oDlgNew  PIXEL Size 140,8 Valid FGETPATH(1) WHEN .F.
@ 60,aPosGet[2,2]+150 BUTTON "&Diretorio"	  SIZE  33, 11  OF oDlgNew PIXEL ACTION  ( FGETPATH(2) )

DEFINE SBUTTON FROM 80,aPosGet[4,1]  TYPE 1 ACTION (nOpca:=1,oDlgNew:End()) ENABLE OF oDlgNew
DEFINE SBUTTON FROM 80,aPosGet[4,2]  TYPE 2 ACTION (nOpca:=0,oDlgNew:End()) ENABLE OF oDlgNew

ACTIVATE MSDIALOG oDlgNew Centered
SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior da Tecla

If  nOpca = 1 
    Return(cPath)
Endif
Return("")


/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    �Validacoes � Autor � Almeida              � Data � 06-05-2004 ���
���������������������������������������������������������������������������Ĵ��
���Descri�ao �Valida o Tipo do Arquivo e o Nome do Arquivo                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �FINC021                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function ValNome(cNomeArq)
If EmptY(cNomeArq)
   Aviso("ATENCAO", "Favor informar o nome do arquivo a ser gerado para poder continuar..",{"&Ok"})
   Return(.F.)
ElseIF at(".",cNomeArq) <> 0
   Aviso("ATENCAO", "Nao e necessario informar a Extensao...",{"&Ok"})
   Return(.F.)
ElseIF at(" ",alltrim(cNomeArq)) <> 0
   Aviso("ATENCAO", "Nao e Permitido espacos em branco no nome do Arquivo...",{"&Ok"})
   Return(.F.)
Endif
cPath:=substr(cPath,1,Rat("\",cPath)) + alltrim(cNomeArq) + "." + cTipo
oPath:Refresh()
Return(.T.)


Static Function VALTIPO(cTipo)
cPath:=substr(cPath,1,Rat("\",cPath)) + alltrim(cNomeArq) + "." + cTipo
oPath:Refresh()
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FGETPATH � Autor � Kleber Dias Gomes     � Data � 26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite que o usuario decida onde sera criado o arquivo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � EXPCIGNA													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function FGETPATH(Opc)
Local _mvRet  :=Alltrim(ReadVar())
Local _cPath  := cPath

_oWnd := GetWndDefault()

//While .T.
	If Empty(_cPath) .or. opc = 2
        // Caso deseje ver somente a arvore do ap7 uso da forma abaixo
		//_cPath := cGetFile( "Arquivos de Exportacao | ",OemToAnsi("Selecione Diretorio"),,"",.F.,GETF_RETDIRECTORY)
        // Tambem posso passar zero em um dos parametros para ligar para salvar
        // desta forma vejo todos os servidores.
        //_cPath := cGetFile(  "Arquivos de Exportacao | "+alltrim(cNomeArq)+"."+cTipo ,OemToAnsi("Selecione Diretorio") )  
        _cPath := cGetFile(  "Arquivos de Exportacao | "+alltrim(cNomeArq)+"."+cTipo ,OemToAnsi("Selecione Diretorio") )  
 	EndIf
	
	If Empty(_cPath)
		Return .F.
	EndIf
    cPath:=substr(_cPath,1,Rat("\",_cPath)) + alltrim(cNomeArq) + "." + cTipo
//	Exit
//EndDo

//If _oWnd != Nil
//	GetdRefresh()
//EndIf

Return .T.

