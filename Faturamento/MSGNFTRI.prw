#INCLUDE "RWMAKE.CH"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLG_01   º Autor ³ GERARDO MARTINEZ   º Data ³  19/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Permite a Digitacao de Dados Complementares das Notas      º±±
±±º          ³ Fiscais.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Alteracao da Mensagem da Nota Fiscal.                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSGNFTRI()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

@ 045,025 Say OemToAnsi("Número da NF:") 	Size 50,10 color CLR_HBLUE
@ 057,025 Say OemToAnsi("Série da NF :") 	Size 50,10 color CLR_HBLUE
@ 070,025 Say OemToAnsi("Tipo NF     :") 	Size 50,10 color CLR_HBLUE

@ 045,080 Get cNumNF    		Size 55,10                                                                    
@ 057,080 Get cSerie    		Size 55,10                                                                    
@ 070,080 COMBOBOX cTipoNF 		ITEMS aTipoNF 		Size 55,10                                                                    

@ 080,215 BmpButton Type 1 Action DLG01(cNumNF,cSerie,cTipoNF)
@ 095,215 BmpButton Type 2 Action Close(mkwdlg2)
Activate Dialog mkwdlg2


Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sewgunda Tela                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function DLG01(cNumNF,cSerie,cTipoNF)

Close(mkwdlg2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	
	
	@ 200,140 To 430,660 Dialog mkwdlg Title OemToAnsi("Alteração de Mensagem")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Grava    º Autor ³ Wagner Gomes       º Data ³  19/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Grava os Dados Complementares da Nota da Fiscal            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

