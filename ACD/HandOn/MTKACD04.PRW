#include "protheus.ch"
#INCLUDE 'APVT100.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKACD04  �Autor  �Anderson            � Data �  13/04/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para mostrar ao usuario as instrucoes de producao  ���
���          �de uma determinada OP.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Multi-Tek                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTKACD04

Private nLinha		:= 0
Private bkey01		:= VTSetKey(01,{|| _Ajuda()})		// CTRL+A - Tela de Ajuda

Private cTitulo     := "Instr. de Montagem"

VTClear()
Private aInstruc	:= {}
Private cOP			:= Space(13)
	
@ 0,0 VTSay cTitulo
	
If Empty(cOP)
	@ ++nLinha,0 VTSay "Qual a OP:"
	@ ++nLinha,0 VTGet cOP Picture "@!" Valid _VALOP() F3 "SC2" when Empty(cOP)
	VTRead
	If VTLastKey() == 27
		VtSetkey(01,bkey01)
		//Exit              //(Correcao para Protheus10)
	EndIf
EndIf

VtClear()

DbSelectArea("SC2") // ja posicionado pela funcao que valida a digitacao da OP

If Empty(SC2->C2_X_INST1)
	VTBeep(2)
	VTALERT("Nao existem instrucoes!","Verifique",.T.,2000)
	Vtsetkey(01,bkey01)
	Return()
Else
	For _a := 1 to 200 step 18
		If !Empty(Substr(SC2->C2_X_INST1,_a,18))
			AADD(aInstruc,{Substr(SC2->C2_X_INST1,_a,18)})
		EndIf
	Next
	If !Empty(SC2->C2_X_INST2)
		For _b := 1 to 200 step 18
			If !Empty(Substr(SC2->C2_X_INST2,_b,18))
		   		AADD(aInstruc,{Substr(SC2->C2_X_INST2,_b,18)})
			EndIf
		Next
		If !Empty(SC2->C2_X_INST3)
			For _c := 1 to 200 step 18
				If !Empty(Substr(SC2->C2_X_INST3,_c,18))
					AADD(aInstruc,{Substr(SC2->C2_X_INST3,_c,18)})
				EndIf
			Next
		EndIf
	EndIf
EndIf

// Mostrando tela com as instrucoes
VTClear()

Private aCab
Private aSize

aCab  := {"OP: "+cOP}
aSize := {18}
VTaBrowse(0,0,7,19,aCab,aInstruc,aSize)

// Desligando CTRL + A 
VtSetkey(01,bkey01)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � _VALOP     � Autor � Desenv.    ACD      � Data � 13/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica integridade no codigo da OP bipada                ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MULTITEK           	    						          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _VALOP()

// Nao bipou, deu ENTER
If Empty(cOP)
	Return .f.
EndIf

DbSelectArea("SC2")
DbSetOrder(1)
If !DbSeek(xFilial("SC2")+cOP)
	VTBeep(2)
	VTALERT("OP nao existe!","Verifique",.T.,2000)
	Return .f.
EndIf

Return .t.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � _AJUDA     � Autor � Desenv.    ACD      � Data � 04/04/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FUNCAO PARA AJUDA - QUANDO USUARIO USA O CTRL + A		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MULTITEK           	    						          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function _Ajuda()

VTBeep(2)
VTALERT("Programa usado    para consultar   instrucoes OP    ","Ajuda")

Return()
