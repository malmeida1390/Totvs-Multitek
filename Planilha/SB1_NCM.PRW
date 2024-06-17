#include "rwmake.ch"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±
±³ PROGRAMA   ³ SB1_NCM   ³ AUTOR ³ Anderson Kurtinaitis  ³ DATA ³ 18/02/04  ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Fun‡ao     ³ Gera Tela no padrao SIGA (com aROTINA) para manutencao da    ³±
±³            ³ do cadastro de EIS.                                          ³±
±³            ³ Usamos aRotina pois cliente tem intensao de efetuar algumas  ³±
±³            ³ validacoes,informacoes apos a inclusao/alteracao/exclusao.   ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³ Uso        ³ Especifico - Multi-Tek                                       ³±
±ÃÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³UpDate.....:                                                               ³±
±³Autor..... :                                                               ³±
±³Solicitante:                                                               ³±
±³Fun‡„o.....:                                                               ³±
±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function SB1_NCM()

aRotina := {{"Pesquisa"	       ,'AxVisual'	    , 0 , 1},;
{"Visualizar"      ,'AxVisual'      , 0 , 2},;
{"Incluir","AxInclui", 0 , 3},;  
{ "Alterar","AxAltera", 0 , 4},;  //"Alterar"
{ "Excluir","AxDeleta", 0 , 5},;  //"Excluir"
{"Manutencao"      ,'U_SB1_AJUSTE'	, 0 , 1}} // Deve ficar como visualizacao


DbSelectArea("Z10")
DbSetOrder(1)

cCADASTRO:= "Cadastro de N.C.M"

MBrowse( 6,1,22,75,"SYD",,,,,,)

Return()



User Function SB1_AJUSTE
Local nYD_PER_IPI := SYD->YD_PER_IPI
Local cYD_X_CLFIS := SYD->YD_X_CLFIS
Local cYD_TEC     := SYD->YD_TEC
LOcal bOk:={||(nOpcao:=1,oDlg:End())}
Local bCancel:={||(lLoop:=.F.,oDlg:End())}
LOCAL oDLG
LOCAL nOpcao:=0
Local cQuery := ""

DEFINE MSDIALOG oDlg TITLE "Cadastro de N.C.M"  From 8,5 To 25,62 OF oMainWnd

@ 010+40 , 010 SAY "Percentual de Ipi " SIZE 203,80
@ 025+40 , 010 SAY "Classif. Fiscal  "  SIZE 203,80

@ 010+40 , 100  GET nYD_PER_IPI  SIZE 80,80 picture '99.99'
@ 025+40 , 100  GET cYD_X_CLFIS  SIZE 40,80

@ 0100,030 BUTTON "OK"      SIZE 60,15 ACTION(EVAL(bOK))
@ 0100,110 BUTTON "Cancela" SIZE 60,15 ACTION(EVAL(bCancel))

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) CENTERED

IF nOPCAO == 1
	
	IF  !(Alltrim(SYD->YD_MSBLQL)='1')
		
		DbSelectARea("SYD")
		Reclock("SYD",.F.)
		SYD->YD_PER_IPI:=nYD_PER_IPI
		SYD->YD_X_CLFIS:=cYD_X_CLFIS
		MsUnlock()
		
		DbselectArea("SB1")
		DbOrderNickname("B1NCM")
		If DbSeek(xFilial("SB1")+SYD->YD_TEC)
			While !SB1->(EOF()) .and. xFilial("SB1")=SB1->B1_FILIAL .and. SB1->B1_POSIPI=SYD->YD_TEC
				Reclock("SB1",.F.)
				SB1->B1_IPI     := SYD->YD_PER_IPI
				SB1->B1_X_CLFIS := SYD->YD_X_CLFIS
				MsUnlock()
				SB1->(DBSKIP())
			Enddo
		Endif
		
	Else
		
		Aviso("ATENCAO", "NCM Bloqueado, alteracao nao permitida." ,{"&Ok"})
		
	Endif

Endif
    
    	
	//#IFDEF TOP
	//	If  TCCanOpen(RETSQLNAME("SB1"))
	//		cQuery := "UPDATE "+RETSQLNAME("SB1")+" SB1"
	//		cQuery += " SET  B1_IPI   = "+ALLTRIM(STR(nYD_PER_IPI))+","
	//		cQuery += "  	 B1_X_CLFIS = '"+cYD_X_CLFIS+"' "
	//		cQuery += " WHERE "
	//		cQuery += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND"
	//		cQuery += " SB1.B1_POSIPI = '"+alltrim(cYD_TEC)+"' AND"
	//		cQuery += " SB1.D_E_L_E_T_ <> '*'
    //        Aviso("ATENCAO", cQuery ,{"&Ok"})
	//		TCSQLEXEC(cQuery)
	//	EndIf
	//#EndIf
	


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SB1_NCM   ºAutor  ³                    º Data ³  10/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Chamada do Cadastro de Grupo de Similaridade                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function SB1_NCM()

Local aGetArea  := GetArea()
Local cCadastro := "Cadastro de N.C.M"


DbSelectArea("SYD")
DbSetOrder(1)

AxCadastro("SYD",cCadastro,"U_SYDExclui()","U_SYDValida()")


RetIndex("SYD")

RestArea(aGetArea)

Return






*----------------------*
User Function SYDExclui()
*----------------------*
Local _aArea:= GetArea()
Local _lRet :=.T.

Local nCount    := 0
Local cQuery    := ""
Local cAliasSB1 := "QUERYSB1"

cQuery := ""
cQuery := " SELECT COUNT(*) AS nCount "
cQuery += " FROM "
cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1 "
cQuery += " WHERE "
cQuery += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND"
cQuery += " SB1.B1_POSIPI = '"+SYD->YD_TEC+"' AND"
cQuery += " SB1.D_E_L_E_T_=' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
nCount := (cAliasSB1)->nCount
(cAliasSB1)->(DbcloseArea())

If nCount > 0
Aviso("ATENCAO", "Ncm nao podera ser excluido pois esta associada a Produto(s)...",{"&Ok"})
_lRet:=.F.
Endif




RestArea(_aArea)

RETURN _lRet



*----------------------*
User Function SYDValida()
*----------------------*
Local _aArea := GetArea()
Local _lRet   :=.T.
Local cQuery := ""

IF !Empty(M->YD_X_CLFIS)

M->YD_X_CLFIS := STRZERO(VAL(M->YD_X_CLFIS),3)


DbSelectArea("SYD")
DbOrderNickname("CLASSYD")
If Dbseek(xFilial("SYD")+M->YD_X_CLFIS)

IF M->YD_TEC <> SYD->YD_TEC
Aviso("ATENCAO", "Esta classificacao ja esta sendo utilizada no TEC "+SYD->YD_TEC,{"&Ok"})
_lRet:=.f.
Endif

Endif


Endif


IF _lRet

//If M->YD_PER_IPI <> SYD->YD_PER_IPI .OR. M->YD_X_CLFIS <> SYD->YD_X_CLFIS

#IFDEF TOP
If  TCCanOpen(RETSQLNAME("SB1"))
cQuery := "UPDATE "+RETSQLNAME("SB1")+" (NOLOCK) SB1"
cQuery += " SET B1_IPI = "+ALLTRIM(STR(M->YD_PER_IPI))+","
cQuery += "  	 B1_X_CLFIS = '"+M->YD_X_CLFIS+"' "
cQuery += " WHERE "
cQuery += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND"
cQuery += " SB1.B1_POSIPI = '"+M->YD_TEC+"' AND"
cQuery += " SB1.D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)
EndIf
#EndIf

//Endif

Endif

RestArea(_aArea)

Return(_lRet)







