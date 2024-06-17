#INCLUDE "RWMAKE.CH"
#include "colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DLG_01   � Autor � GERARDO MARTINEZ   � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Permite a Digitacao de Dados Complementares das Notas      ���
���          � Fiscais.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Alteracao da Mensagem da Nota Fiscal.                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MSGNFTRI()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
LOCAL cNumNf	:= "      "
LOCAL cSerie	:= "  "
Local cVar1		:= SPACE(120)
Local cVar2		:= SPACE(120)
Local cVar3		:= SPACE(120)
Local _cStringSF:= ""
cTipoNF			:= "       "
aTipoNF			:= {"ENTRADA","SAIDA"}

@ 200,140 To 430,660 Dialog mkwdlg2 Title OemToAnsi("Dados da Nota")
@ 033,015 To 110,190 Title OemToAnsi("Dados Referentes a NF Triangular")

@ 045,025 Say OemToAnsi("N�mero da NF:") 	Size 50,10 color CLR_HBLUE
@ 057,025 Say OemToAnsi("S�rie da NF :") 	Size 50,10 color CLR_HBLUE
@ 070,025 Say OemToAnsi("Tipo NF     :") 	Size 50,10 color CLR_HBLUE

@ 045,080 Get cNumNF    		Size 55,10                                                                    
@ 057,080 Get cSerie    		Size 55,10                                                                    
@ 070,080 COMBOBOX cTipoNF 		ITEMS aTipoNF 		Size 55,10                                                                    

@ 080,215 BmpButton Type 1 Action DLG01(cNumNF,cSerie,cTipoNF)
@ 095,215 BmpButton Type 2 Action Close(mkwdlg2)
Activate Dialog mkwdlg2


Return



//���������������������������������������������������������������������Ŀ
//� Sewgunda Tela                                                       �
//�����������������������������������������������������������������������
Static Function DLG01(cNumNF,cSerie,cTipoNF)

Close(mkwdlg2)

//���������������������������������������������������������������������Ŀ
//� Criacao da Interface                                                �
//�����������������������������������������������������������������������
_cCabVar 	:=	iif(SUBSTR(cTipoNF,1,1)=="E","Fornecedor","Cliente")
_cStringSF	:=	iif(SUBSTR(cTipoNF,1,1)=="E","SF1","SF2")
_cStringSA	:=	iif(SUBSTR(cTipoNF,1,1)=="E","SA2","SA1")

DbSelectArea(_cStringSF)
DbSetOrder(1)
DbSeek(xfilial()+cNumNF+cSerie)

IF FOUND()
	cCliente	:=	iif(SUBSTR(cTipoNF,1,1)=="E",SF1->F1_FORNECE,SF2->F2_CLIENTE)
	cLoja		:=	iif(SUBSTR(cTipoNF,1,1)=="E",SF1->F1_LOJA,SF2->F2_LOJA)
	
	cVar1		:=	iif(SUBSTR(cTipoNF,1,1)=="E",SUBSTR(SF1->F1_LINHA1,1,120),SUBSTR(SF2->F2_LINHA1,1,120))
	cVar2		:=	iif(SUBSTR(cTipoNF,1,1)=="E",SUBSTR(SF1->F1_LINHA2,1,120),SUBSTR(SF2->F2_LINHA2,1,120))
	cVar3		:=	iif(SUBSTR(cTipoNF,1,1)=="E",SUBSTR(SF1->F1_LINHA3,1,120),SUBSTR(SF2->F2_LINHA3,1,120))
	
	DbSelectArea(_cStringSA)
	DbSetOrder(1)
	DbSeek(xfilial()+cCliente+cLoja)
	
	cRazao		:=	iif(SUBSTR(cTipoNF,1,1)=="E",SA2-A2_NOME,SA1->A1_NOME)
	
	
	
	@ 200,140 To 430,660 Dialog mkwdlg Title OemToAnsi("Altera��o de Mensagem")
	@ 033,015 To 110,190 Title OemToAnsi("Dados Referentes a NF Triangular")
	@ 010,015 Say OemToAnsi("Nota Fiscal")	Size 32,10 color CLR_HBLUE
	@ 010,060 Say OemToAnsi(_cCabVar) 		Size 32,10 color CLR_HBLUE
	@ 045,025 Say OemToAnsi("Msg Linha1") 	Size 32,10 color CLR_HBLUE
	@ 057,025 Say OemToAnsi("Msg Linha2") 	Size 32,10 color CLR_HBLUE
	@ 070,025 Say OemToAnsi("Msg Linha3") 	Size 32,10 color CLR_HBLUE
	
	@ 017,015 Say cNumNF+"/"+cSerie 		Size 40,10 color CLR_HRED
	@ 017,060 Say cCliente+"/"+cLoja+" - "+cRazao Size 170,10 color CLR_HRED
	@ 045,060 Get cVar1    		Size 125,10                                                                    
	@ 057,060 Get cVar2    		Size 125,10                                                                    
	@ 070,060 Get cVar3   		Size 125,10                                                                    
	
	@ 080,215 BmpButton Type 1 Action Grava1()
	@ 095,215 BmpButton Type 2 Action Close(mkwdlg)
	Activate Dialog mkwdlg

ELSE
	ALERT("NOTA FISCAL DE NUMERO: "+cNumNF+" E SERIE :"+cSerie+" NAO FOI LOCALIZADA, VERIFIQUE!!!")
ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Grava    � Autor � Wagner Gomes       � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Grava os Dados Complementares da Nota da Fiscal            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Grava1()

Close(mkwdlg)

DbSelectArea(_cStringSF)
RecLock(_cStringSF,.F.)
If SUBSTR(_cStringSF,1,1) == "E"
	SF1->F1_LINHA1	:= cVar1
	SF1->F1_LINHA2	:= cVar2
	SF1->F1_LINHA3	:= cVar3
Else
	SF2->F2_LINHA1	:= cVar1
	SF2->F2_LINHA2	:= cVar2
	SF2->F2_LINHA3	:= cVar3	
EndIf  
MsUnLock()                                      

Return

