#include "rwmake.ch"

User Function MPL_006(_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_006  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 10/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que ira efetuar a visualizacao e manutencao de cada  ³±±
±±³          ³ Nivel do EIS                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Public _oDlg02

// Nome do Arquivo Conforme Campo a ser visualizado
_cArea := "Z"+Strzero(Val(_cNivel),2)

// Verificando se usuario preencheu algum Nivel do EIS sem preencher algum anterior ao que ele esta
If _cNivel == "1"
	If !Empty(_cEIS02) .or. !Empty(_cEIS03) .or. !Empty(_cEIS04) .or. !Empty(_cEIS05) .or.	!Empty(_cEIS06);
	.or. !Empty(_cEIS07) .or. !Empty(_cEIS08) .or. !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta no Nivel Familia (01) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
	    _cNomNiv := "Codigo da Familia"
        _cChvEIS := "N"
        _cLooEIS := "N"
	EndIf
ElseIf _cNivel == "2"
	If !Empty(_cEIS03) .or. !Empty(_cEIS04) .or. !Empty(_cEIS05) .or. !Empty(_cEIS06) .or.;
	!Empty(_cEIS07) .or. !Empty(_cEIS08) .or. !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta no Nivel Divisao Familia (02) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01)
			MsgBox("O nivel anterior DEVE estar preenchido, verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Divisao Familia"
	        _cChvEIS := _cEIS01
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01"
		EndIF
	EndIf	
ElseIf _cNivel == "3"
	If !Empty(_cEIS04) .or. !Empty(_cEIS05) .or. !Empty(_cEIS06) .or. !Empty(_cEIS07) .or.;
	!Empty(_cEIS08) .or. !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta no Tipo Familia (03) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Tipo Familia"
	        _cChvEIS := _cEIS01+_cEIS02            
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02"
		EndIF
	EndIf	
ElseIf _cNivel == "4"
	If !Empty(_cEIS05) .or. !Empty(_cEIS06) .or. !Empty(_cEIS07) .or. !Empty(_cEIS08) .or.;
	!Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta no Divisao Construtiva (04) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Divisao Construtiva"
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03                                 
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03"
		EndIf
	EndIf	
ElseIf _cNivel == "5"
	If !Empty(_cEIS06) .or. !Empty(_cEIS07) .or. !Empty(_cEIS08) .or. !Empty(_cEIS09) .or.;
	!Empty(_cEIS10)
		MsgBox("Voce esta na 1a. Caracteristica (05) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
	    	_cNomNiv := "1a. Caracteristica"
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04"
		EndIf
	EndIf	
ElseIf _cNivel == "6"
	If !Empty(_cEIS07) .or. !Empty(_cEIS08) .or. !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta na 2a. Caracteristica (06) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04) .or. Empty(_cEis05)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
	    	_cNomNiv := "2a. Caracteristica"           
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05"
		EndIf
	EndIf	
ElseIf _cNivel == "7"
	If !Empty(_cEIS08) .or. !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta na 3a. Caracteristica (07) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04) .or. Empty(_cEis05) .or.;
		Empty(_cEIS06)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
		    _cNomNiv := "3a. Caracteristica"
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06"
		EndIf
	EndIf	
ElseIf _cNivel == "8"
	If !Empty(_cEIS09) .or. !Empty(_cEIS10)
		MsgBox("Voce esta na 4a. Caracteristica (08) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04) .or. Empty(_cEis05) .or.;
		Empty(_cEis06) .or. Empty(_cEis07)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
		    _cNomNiv := "4a. Caracteristica"
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07"
		EndIf
	EndIf	
ElseIf _cNivel == "9"
	If !Empty(_cEIS10)
		MsgBox("Voce esta na 5a. Caracteristica (09) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        U_LmpGets()
        Return()
    Else
		If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04) .or. Empty(_cEis05) .or.;
		Empty(_cEis06) .or. Empty(_cEis07) .or. Empty(_cEis08)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			U_LmpGets()
			Return()
		Else
		    _cNomNiv := "5a. Caracteristica"
	        _cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07+_cEIS08
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07 + "+_cArea+"->"+_cArea+"_COD08"
		EndIf
	EndIf	
ElseIf _cNivel == "10"
	If Empty(_cEIS01) .or. Empty(_cEIS02) .or. Empty(_cEis03) .or. Empty(_cEis04) .or. Empty(_cEis05) .or.;
	Empty(_cEis06) .or. Empty(_cEis07) .or. Empty(_cEis08) .or. Empty(_cEis09)
		MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
		U_LmpGets()
		Return()
	Else
	    _cNomNiv := "6a. Caracteristica"
		_cChvEIS := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07+_cEIS08+_cEIS09
		_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07 + "+_cArea+"->"+_cArea+"_COD08 + "+_cArea+"->"+_cArea+"_COD09"
	EndiF
EndIf	


@ 125,001 TO 424,631 DIALOG _oDlg02 TITLE OemToAnsi(_cNomNiv)
@ 000,002 TO 050,315

@ 005,006 SAY "EIS Nivel:" 
@ 020,006 SAY "Descricao:"

@ 005,050 GET Strzero(Val(_cNivel),2)	Size  010,1  When .F.
@ 020,050 GET _cNomNiv					Size  200,1  When .F.

// Arquivo Temporario que contera os campos a serem mostrados no browser
// O mesmo sera criado atraves de um algoritimo conforme o campo que o usuario estiver

_aZXEstrut := {} 
_aZXCampos := {}

AADD(_aZXEstrut,{"Z"+Strzero(Val(_cNivel),2)+"_COD"+Strzero(Val(_cNivel),2),"C",02,0})
AADD(_aZXEstrut,{"Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2),"C",60,0})     

AADD(_aZXCampos,{"Z"+Strzero(Val(_cNivel),2)+"_COD"+Strzero(Val(_cNivel),2),_cNomNiv,""})
AADD(_aZXCampos,{"Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2),"Descricao",""})

_cZXArq  := Criatrab(_aZXEstrut,.T.)
Dbusearea(.T.,,_cZXArq,"MTZX")

Dbselectarea(_cArea)
Dbsetorder(1)
If _cChvEIS <> "N"
	DbSeek(xFilial(_cArea)+_cChvEIS)
Else
	DbGoTop()
EndIf

_cVLoop := _cArea+"->"+_cArea+"_FILIAL"
_cCmp01 := _cArea+"->"+_aZXEstrut[1,1]
_cCmp02 := _cArea+"->"+_aZXEstrut[2,1] 
_cTmp01 := "MTZX->"+_aZXEstrut[1,1]
_cTmp02 := "MTZX->"+_aZXEstrut[2,1]

Do While !Eof() .And. If( _cNivel=="1",&_cVLoop  == xFILIAL(_cArea),&_cVLoop  == xFILIAL(_cArea) .and. _cChvEIS == &_cLooEIS )


	Dbselectarea("MTZX")
	Reclock("MTZX",.T.)
	&_cTmp01 := &_cCmp01
	&_cTmp02 := &_cCmp02
	Msunlock()
	
	Dbselectarea(_cArea)
	Dbskip()

Enddo

Dbselectarea("MTZX")
Dbgotop()

@ 055,002 TO 148,315 Browse "MTZX" Fields _aZXCampos

@ 035,160 BUTTON "_Incluir"		SIZE 30,12 ACTION U_MPL_007("1",_cChvEIS,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 035,200 BUTTON "_Alterar"		SIZE 30,12 ACTION U_MPL_007("2",_cChvEIS,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 035,240 BUTTON "_Deletar"		SIZE 30,12 ACTION U_MPL_007("3",_cChvEIS,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 035,280 BUTTON "_Escolher"	SIZE 30,12 ACTION MPL_006_1(_cNivel,_cCmp01,_cCmp02)

Activate Dialog _oDLG02 Centered

Dbselectarea("MTZX")
Dbclosearea()

Ferase(_cZXArq+".DTC")
                      
Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MPL_006_1 ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que atualiza os campos da tela anterior conforme o   ³±±
±±³          ³ campo que o usuario estiver no momento                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MPL_006_1(_cNivel,_cCmp01,_cCmp02)

// Abastecendo as variaveis da tela anterior conforme escolha no arquivo temporario
If _cNivel == "1"
	DbSelectArea("MTZX")
	_cEIS01  := &_cTmp01
    _cDESC01 := &_cTmp02
ElseIf _cNivel == "2"
	DbSelectArea("MTZX")
	_cEIS02  := &_cTmp01
    _cDESC02 := &_cTmp02
ElseIf _cNivel == "3"
	DbSelectArea("MTZX")
	_cEIS03  := &_cTmp01
    _cDESC03 := &_cTmp02
ElseIf _cNivel == "4"
	DbSelectArea("MTZX")
	_cEIS04  := &_cTmp01
    _cDESC04 := &_cTmp02
ElseIf _cNivel == "5"
	DbSelectArea("MTZX")
	_cEIS05  := &_cTmp01
    _cDESC05 := &_cTmp02
ElseIf _cNivel == "6"
	DbSelectArea("MTZX")
	_cEIS06  := &_cTmp01
    _cDESC06 := &_cTmp02
ElseIf _cNivel == "7"
	DbSelectArea("MTZX")
	_cEIS07  := &_cTmp01
    _cDESC07 := &_cTmp02
ElseIf _cNivel == "8"
	DbSelectArea("MTZX")
	_cEIS08  := &_cTmp01
    _cDESC08 := &_cTmp02
ElseIf _cNivel == "9"
	DbSelectArea("MTZX")
	_cEIS09  := &_cTmp01
    _cDESC09 := &_cTmp02
ElseIf _cNivel == "10"
	DbSelectArea("MTZX")
	_cEIS10  := &_cTmp01
    _cDESC10 := &_cTmp02
EndIf

Close(_oDlg02)

// Refresh Tela Anterior
DlgRefresh(oDlg)

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LmpGets   ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que LIMPA todos os campos da tela anterior quando for³±±
±±³          ³ necessario (ex: usuario preencheu campos fora de ordem)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LmpGets()

_cEIS01  := Space(2)
_cDESC01 := Space(60)
_cEIS02  := Space(2)
_cDESC02 := Space(60)
_cEIS03  := Space(2)
_cDESC03 := Space(60)
_cEIS04  := Space(2)
_cDESC04 := Space(60)
_cEIS05  := Space(2)
_cDESC05 := Space(60)
_cEIS06  := Space(2)
_cDESC06 := Space(60)
_cEIS07  := Space(2)
_cDESC07 := Space(60)
_cEIS08  := Space(2)
_cDESC08 := Space(60)
_cEIS09  := Space(2)
_cDESC09 := Space(60)
_cEIS10  := Space(2)
_cDESC10 := Space(60)

// Refresh na Tela Anterior
DlgRefresh(oDlg)

Return()