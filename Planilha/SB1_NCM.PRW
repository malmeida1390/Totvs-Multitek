#include "rwmake.ch"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
壁哪哪哪哪哪哪履哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目�
背 PROGRAMA   � SB1_NCM   � AUTOR � Anderson Kurtinaitis  � DATA � 18/02/04  潮
泵哪哪哪哪哪哪拍哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇�
背 Fun嘺o     � Gera Tela no padrao SIGA (com aROTINA) para manutencao da    潮
背            � do cadastro de EIS.                                          潮
背            � Usamos aRotina pois cliente tem intensao de efetuar algumas  潮
背            � validacoes,informacoes apos a inclusao/alteracao/exclusao.   潮
泵哪哪哪哪哪哪拍哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背 Uso        � Especifico - Multi-Tek                                       潮
泵哪哪哪哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇�
背UpDate.....:                                                               潮
背Autor..... :                                                               潮
背Solicitante:                                                               潮
背Fun噭o.....:                                                               潮
崩哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  砈B1_NCM   篈utor  �                    � Data �  10/09/04   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     矯hamada do Cadastro de Grupo de Similaridade                罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Multitek                                                   罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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







