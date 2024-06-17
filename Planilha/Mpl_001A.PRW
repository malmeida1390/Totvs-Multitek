#include "rwmake.ch"
#INCLUDE "VKEY.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_001A ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 24/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que ira efetuar a consulta das EIS na tela de manut. ³±±
±±³          ³ da Planilha de Materiais.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MPL_001A(_cNivel,cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0)

Local bSetKey4       

// Nome do Arquivo Conforme Campo a ser visualizado
_cArea := "Z"+Strzero(Val(_cNivel),2)

// Verificando se usuario preencheu algum Nivel do EIS sem preencher algum anterior ao que ele esta
If _cNivel == "1"
	If !Empty(cEisCod2) .or. !Empty(cEisCod3) .or. !Empty(cEisCod4) .or. !Empty(cEisCod5) .or.	!Empty(cEisCod6);
	.or. !Empty(cEisCod7) .or. !Empty(cEisCod8) .or. !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta no Nivel Familia (01) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
	    _cNomNiv := "Codigo da Familia"
        _cChvEIS := "N"
        _cLooEIS := "N"
	EndIf
ElseIf _cNivel == "2"
	If !Empty(cEisCod3) .or. !Empty(cEisCod4) .or. !Empty(cEisCod5) .or. !Empty(cEisCod6) .or.;
	!Empty(cEisCod7) .or. !Empty(cEisCod8) .or. !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta no Nivel Divisao Familia (02) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1)
			MsgBox("O nivel anterior DEVE estar preenchido, verifique !","ALERT")
			_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Divisao Familia"
	        _cChvEIS := cEisCod1
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01"
		EndIF
	EndIf	
ElseIf _cNivel == "3"
	If !Empty(cEisCod4) .or. !Empty(cEisCod5) .or. !Empty(cEisCod6) .or. !Empty(cEisCod7) .or.;
	!Empty(cEisCod8) .or. !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta no Tipo Familia (03) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Tipo Familia"
	        _cChvEIS := cEisCod1+cEisCod2            
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02"
		EndIF
	EndIf	
ElseIf _cNivel == "4"
	If !Empty(cEisCod5) .or. !Empty(cEisCod6) .or. !Empty(cEisCod7) .or. !Empty(cEisCod8) .or.;
	!Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta no Divisao Construtiva (04) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
	    	_cNomNiv := "Divisao Construtiva"
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3                                 
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03"
		EndIf
	EndIf	
ElseIf _cNivel == "5"
	If !Empty(cEisCod6) .or. !Empty(cEisCod7) .or. !Empty(cEisCod8) .or. !Empty(cEisCod9) .or.;
	!Empty(cEisCod0)
		MsgBox("Voce esta na 1a. Caracteristica (05) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
	    	_cNomNiv := "1a. Caracteristica"
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4
	        _cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04"
		EndIf
	EndIf	
ElseIf _cNivel == "6"
	If !Empty(cEisCod7) .or. !Empty(cEisCod8) .or. !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta na 2a. Caracteristica (06) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4) .or. Empty(cEisCod5)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
	    	_cNomNiv := "2a. Caracteristica"           
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05"
		EndIf
	EndIf	
ElseIf _cNivel == "7"
	If !Empty(cEisCod8) .or. !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta na 3a. Caracteristica (07) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4) .or. Empty(cEisCod5) .or.;
		Empty(cEisCod6)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
		    _cNomNiv := "3a. Caracteristica"
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06"
		EndIf
	EndIf	
ElseIf _cNivel == "8"
	If !Empty(cEisCod9) .or. !Empty(cEisCod0)
		MsgBox("Voce esta na 4a. Caracteristica (08) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4) .or. Empty(cEisCod5) .or.;
		Empty(cEisCod6) .or. Empty(cEisCod7)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
		    _cNomNiv := "4a. Caracteristica"
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07"
		EndIf
	EndIf	
ElseIf _cNivel == "9"
	If !Empty(cEisCod0)
		MsgBox("Voce esta na 5a. Caracteristica (09) e NAO DEVE TER niveis acima dele preenchidos !","ALERT")
        _LmpGets()
        Return()
    Else
		If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4) .or. Empty(cEisCod5) .or.;
		Empty(cEisCod6) .or. Empty(cEisCod7) .or. Empty(cEisCod8)
			MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
			_LmpGets()
			Return()
		Else
		    _cNomNiv := "5a. Caracteristica"
	        _cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8
			_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07 + "+_cArea+"->"+_cArea+"_COD08"
		EndIf
	EndIf	
ElseIf _cNivel == "10"
	If Empty(cEisCod1) .or. Empty(cEisCod2) .or. Empty(cEisCod3) .or. Empty(cEisCod4) .or. Empty(cEisCod5) .or.;
	Empty(cEisCod6) .or. Empty(cEisCod7) .or. Empty(cEisCod8) .or. Empty(cEisCod9)
		MsgBox("O(s) nivel(is) anterior(es) DEVE(M) estar preenchido(s), verifique !","ALERT")
		_LmpGets()
		Return()
	Else
	    _cNomNiv := "6a. Caracteristica"
		_cChvEIS := cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8+cEisCod9
		_cLooEIS := _cArea+"->"+_cArea+"_COD01 + "+_cArea+"->"+_cArea+"_COD02 + "+_cArea+"->"+_cArea+"_COD03 + "+_cArea+"->"+_cArea+"_COD04 + "+_cArea+"->"+_cArea+"_COD05 + "+_cArea+"->"+_cArea+"_COD06 + "+_cArea+"->"+_cArea+"_COD07 + "+_cArea+"->"+_cArea+"_COD08 + "+_cArea+"->"+_cArea+"_COD09"
	EndiF
EndIf	
                            


@ 125,001 TO 424,631 DIALOG _oDlg02 TITLE OemToAnsi(_cNomNiv)
bSetKey4 :=SetKey(VK_F4 , nil ) // Ativando F4

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

@ 035,280 BUTTON "_Escolher"	SIZE 30,12 ACTION MPL_001_1(_cNivel,_cCmp01,_cCmp02)

Activate Dialog _oDLG02 Centered
SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior da Tecla
                

Dbselectarea("MTZX")
Dbclosearea()

Ferase(_cZXArq+".DTC")
                      
Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MPL_001_1 ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que atualiza os campos da tela anterior conforme o   ³±±
±±³          ³ campo que o usuario estiver no momento                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MPL_001_1(_cNivel,_cCmp01,_cCmp02)

// Abastecendo as variaveis da tela anterior conforme escolha no arquivo temporario
If _cNivel == "1"
	DbSelectArea("MTZX")
	cEisCod1  := &_cTmp01
ElseIf _cNivel == "2"
	DbSelectArea("MTZX")
	cEisCod2  := &_cTmp01
ElseIf _cNivel == "3"
	DbSelectArea("MTZX")
	cEisCod3  := &_cTmp01
ElseIf _cNivel == "4"
	DbSelectArea("MTZX")
	cEisCod4  := &_cTmp01
ElseIf _cNivel == "5"
	DbSelectArea("MTZX")
	cEisCod5  := &_cTmp01
ElseIf _cNivel == "6"
	DbSelectArea("MTZX")
	cEisCod6  := &_cTmp01
ElseIf _cNivel == "7"
	DbSelectArea("MTZX")
	cEisCod7  := &_cTmp01
ElseIf _cNivel == "8"
	DbSelectArea("MTZX")
	cEisCod8  := &_cTmp01
ElseIf _cNivel == "9"
	DbSelectArea("MTZX")
	cEisCod9  := &_cTmp01
ElseIf _cNivel == "10"
	DbSelectArea("MTZX")
	cEisCod0  := &_cTmp01
EndIf

Close(_oDlg02)

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³_LMPGETS  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que LIMPA todos os campos da tela anterior quando for³±±
±±³          ³ necessario (ex: usuario preencheu campos fora de ordem)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _LmpGets()

cEisCod1  := Space(2)
cEisCod2  := Space(2)
cEisCod3  := Space(2)
cEisCod4  := Space(2)
cEisCod5  := Space(2)
cEisCod6  := Space(2)
cEisCod7  := Space(2)
cEisCod8  := Space(2)
cEisCod9  := Space(2)
cEisCod0  := Space(2)

Return()