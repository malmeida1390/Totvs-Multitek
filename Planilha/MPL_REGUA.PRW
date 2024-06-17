#INCLUDE "FIVEWIN.CH"

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Statics da ProcGpe                                           |
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static oMeter
Static nAtual
Static nBmp
Static oNome

/*
здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
Ё Proc2BaR		                                           |
юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Static oGauge1
Static oGauge2
Static oProcG1
Static oProcG2
Static nCurrentG1
Static nCurrentG2
Static nSetDifG1
Static nSetDifG2
Static nTmIncG1Proc
Static nTmCntG1Proc
Static nTmLstG1Proc
Static nTmLstG1Cnt
Static nTmIncG2Proc
Static nTmCntG2Proc
Static nTmLstG2Proc
Static nTmLstG2Cnt
       
/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁProcGpe		  ЁAutorЁ Equipe Advanced RH  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁProcessa com Calculadora                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function ProcGpe( bAction, cTitle ,cMsg,lAbort)

Local oDlg, oText, oTimer
Local lEnd := .f.
Local nVal := 0

DEFAULT lAbort := .f.

DEFAULT bAction := { || nil }, cMsg := "Processando...", cTitle := "Aguarde"

#IFDEF PROTHEUS
#ELSE
	DEFINE TIMER oTimer INTERVAL 200 ACTION GPChgBmp(++nBmp,oBmp) OF oMainWnd
#ENDIF

DEFINE MSDIALOG oDlg FROM 0,0 TO 150, 323 TITLE OemToAnsi(cTitle) STYLE DS_MODALFRAME STATUS PIXEL

#IFDEF PROTHEUS
#ELSE
	@  .3,  .5  BITMAP oBmp RESOURCE "CALC01" OF oDlg NOBORDER SIZE 16,10 WHEN .F.
#ENDIF

@ 06, 21 SAY oNome VAR OemToAnsi(cMsg) SIZE 140, 10 OF oDlg FONT oDlg:oFont PIXEL
@ 20,05 TO 45,155 OF oDlg PIXEL
@ 29,10  METER oMeter VAR nVal TOTAL 10 SIZE 140, 10 OF oDlg BARCOLOR GetSysColor(13),GetSysColor() PIXEL
IF lAbort
	DEFINE SBUTTON FROM 50,122 TYPE 2 ACTION (lAbortPrint := .t.,lEnd := .t.) ENABLE OF oDlg
Else
	DEFINE SBUTTON FROM 50,122 TYPE 2 OF oDlg
Endif
oDlg:bStart = { || Eval( bAction, @lEnd ),lEnd := .t., oDlg:End() }

#IFDEF PROTHEUS
	ACTIVATE DIALOG oDlg VALID lEnd CENTERED
#ELSE
	nBmp := 1
	ACTIVATE DIALOG oDlg ON INIT oTimer:Activate() VALID lEnd CENTERED
	oTimer:End()
#ENDIF

oMeter:= Nil
oText := Nil

Return nil

#IFDEF PROTHEUS
#ELSE
Static Function GPChgBmp(nBmp,oBmp)
Local nResto := if(nBmp%3==0,3,nBmp%3)
Local cBmp := "CALC"+StrZero(nResto,2,0)
oBmp:cResName := cBmp
oBmp:SetBmp()
oBmp:Display()
Return
#ENDIF

User Function GpProcR(nTotal)
oMeter:nTotal := nTotal
nAtual := 0
Return nil

User Function GPIncProc(cMsg)
oMeter:Set(++nAtual)
oNome :SetText(OemToAnsi(cMsg))
SysRefresh()

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁProc2BaR ЁAutorЁ Marinaldo de Jesus  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁProcessa com 2 Barras de Gauge                              Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function Proc2BaR( bAction , cTitle , cMsg1 , cMsg2 , lAbort )

Local lEnd		:= .F.
Local nGauge1	:= 0.00
Local nGauge2	:= 0.00
Local oDlg		:= NIL
Local oTitle	:= NIL
Local oFont		:= NIL

DEFAULT bAction := { || NIL }
DEFAULT cTitle	:= "Aguarde"
DEFAULT cMsg1	:= "Processando..."
DEFAULT cMsg2	:= ""
DEFAULT lAbort	:= .F.

DEFAULT nCurrentG1		:= 0.00
DEFAULT nCurrentG2		:= 0.00
DEFAULT nSetDifG1		:= 1.00
DEFAULT nSetDifG2		:= 1.00
DEFAULT nTmIncG1Proc	:= 0.00
DEFAULT nTmCntG1Proc	:= 0.00
DEFAULT nTmLstG1Proc	:= 0.00
DEFAULT nTmLstG1Cnt		:= 0.00
DEFAULT nTmIncG2Proc    := 0.00
DEFAULT nTmCntG2Proc	:= 0.00
DEFAULT nTmLstG2Proc	:= 0.00
DEFAULT nTmLstG2Cnt		:= 0.00

IF ( Type( "lAbortPrint" ) == "U" )
	_SetOwnerPrvt( "lAbortPrint" , .F. )
EndIF

DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg FROM 196,042 TO 415,755 TITLE OemToAnsi( cTitle ) STYLE DS_MODALFRAME STATUS PIXEL

	@ 005.0,03 SAY oProcG1		VAR OemToAnsi( cMsg1 )	SIZE 345,010 OF oDlg FONT oFont PIXEL
	@ 011.5,03 TO 041.5,355 OF oDlg PIXEL 
	@ 021.5,05 METER oGauge1	VAR nGauge1 TOTAL 10	SIZE 345,010 OF oDlg BARCOLOR GetSysColor(13),GetSysColor() PIXEL
		
	@ 048.5,03 SAY oProcG2		VAR OemToAnsi( cMsg2 )	SIZE 345,010 OF oDlg FONT oFont PIXEL
	@ 055.0,03 TO 085,355 OF oDlg PIXEL
	@ 065.0,05 METER oGauge2	VAR nGauge2 TOTAL 10	SIZE 345,010 OF oDlg BARCOLOR GetSysColor(13),GetSysColor() PIXEL
		
	IF ( lAbort )
		DEFINE SBUTTON FROM 090,325 TYPE 2 ACTION ( lEnd := lAbortPrint := .T. ) ENABLE OF oDlg PIXEL
	Else
		DEFINE SBUTTON FROM 090,325 TYPE 2 OF oDlg PIXEL
	EndIF
		
	oDlg:bStart := { || Eval( bAction ) , lEnd := .T. , oDlg:End() }
		
ACTIVATE DIALOG oDlg VALID lEnd CENTERED

oGauge1			:= NIL
oGauge2			:= NIL
nCurrentG1		:= NIL
nCurrentG2		:= NIL
nSetDifG1		:= NIL
nSetDifG2		:= NIL
nTmIncG1Proc	:= NIL
nTmCntG1Proc	:= NIL
nTmLstG1Proc	:= NIL
nTmLstG1Cnt		:= NIL
nTmIncG2Proc    := NIL
nTmCntG2Proc	:= NIL
nTmLstG2Proc	:= NIL
nTmLstG2Cnt		:= NIL

Return( lEnd )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁBarG1Set  ЁAutorЁ Marinaldo de Jesus  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁSeta o Totalizador da Gauge1                          		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function BarG1Set( nProcRegua )

nCurrentG1		:= 0.00
IF ( nProcRegua <= 100 )
	oGauge1:nTotal	:= nProcRegua
Else
	oGauge1:nTotal	:= 25
	nSetDifG1		:= ( 25 / nProcRegua )
EndIF

Return( NIL )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁBarG2Set  ЁAutorЁ Marinaldo de Jesus  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁSeta o Totalizador da Gauge2                          		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function BarG2Set( nProcRegua )

nCurrentG2		:= 0.00
IF ( nProcRegua <= 100 )
	oGauge2:nTotal	:= nProcRegua
Else
	oGauge2:nTotal	:= 25
	nSetDifG2		:= ( 25 / nProcRegua )
EndIF

Return( NIL )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁIncProG1	  ЁAutorЁ Marinaldo de Jesus  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁIncrementa o Totalizador da Gauge1                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function IncProG1( cMsg , lIncProG1 )

Local lIsMsgChar	:= ( ValType( cMsg ) == "C" )

DEFAULT lIncProG1 := .T.
         
IF ( lIncProG1 )
	++nCurrentG1
	oGauge1:Set( ( nCurrentG1 * nSetDifG1 ) )
	IF ( lIsMsgChar )
		oProcG1:SetText( cMsg )
	EndIF
Else
	IF ( lIsMsgChar )
		oProcG1:SetText( cMsg )
	EndIF
EndIF

Return( SysRefresh() )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁIncProG2	  ЁAutorЁ Marinaldo de Jesus  Ё Data Ё23/12/2002Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁIncrementa o Totalizador da Gauge2                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function IncProG2( cMsg , lIncProG2 )

Local lIsMsgChar	:= ( ValType( cMsg ) == "C" )

DEFAULT lIncProG2 := .T.

nTmCntG1Proc	:= 0
         
IF ( lIncProG2 )
	++nCurrentG2
	oGauge2:Set( ( nCurrentG2 * nSetDifG2 ) )
	IF ( lIsMsgChar )
		oProcG2:SetText( cMsg )
	EndIF
Else
	IF ( lIsMsgChar )
		oProcG2:SetText( cMsg )
	EndIF
EndIF

Return( SysRefresh() )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁIncPG1T       ЁAutorЁ Marinaldo de Jesus  Ё Data Ё19/03/2003Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁChamada a IncProG1() com calculo de Tempo de Processamento Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function IncPG1T(	cMsgIncProc		,;	//01 -> Inicio da Mensagem
						nLastRec		,;	//02 -> Numero de Registros a Serem Processados
						cTimeIni		,;	//03 -> Tempo Inicial
						lOnlyOneProc	,;	//04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
						nCountTime		,;	//05 -> Contador de Processos
						nPercent	 	 ;	//06 -> Percentual para Incremento
					)
         
Local cMsg1 	:= "Inicio"
Local cMsg2 	:= "Decorridos"
Local cMsg3 	:= ""   //"Total:"
Local cMsg4 	:= "Parcial:"
Local cMsg5 	:= "Final estimado"
Local cMsgProc	:= ""
Local nSeconds	:= 0.00
Local nPercInc	:= 0.00

DEFAULT cMsgIncProc 	:= "Procesando..."
DEFAULT nLastRec		:= 0.00
DEFAULT cTimeIni		:= Time()
DEFAULT lOnlyOneProc	:= .T.
DEFAULT nCountTime		:= 0.00	
DEFAULT nPercent		:= 5.00	

IF !( nTmLstG1Cnt == nCountTime )
	nTmLstG1Cnt		:= nCountTime
	nTmCntG1Proc	:= 0.00
	nTmLstG1Proc	:= 0.00
EndIF

nPercInc := ( ( ++nTmCntG1Proc ) / nLastRec )
nPercInc *= 100
nPercInc := Int( nPercInc )

IF ( nTmCntG1Proc == 1 )
	IF ( lOnlyOneProc )
		RemainingTime( cTimeIni , nCountTime , .F. )
	Else
		RemainingTime( cTimeIni , 0 , .F. )
		RemainingTime( NIL , nCountTime , .F. )
	EndIF
EndIF

IF ( ( nPercInc % nPercent ) == 0.00 )
	IF !( nTmLstG1Proc == nPercInc )
		nTmLstG1Proc	:= nPercInc
		cMsgProc		+= cMsgIncProc
		IF !( SubStr( cMsgProc , -1 ) == " " )
			cMsgProc += " "
		EndIF	
		cMsgProc		+= StrZero( nPercInc , 03 ) + "% - "
		cMsgProc		+= "(" + AllTrim( Str( nTmCntG1Proc ) ) + "/" + AllTrim( Str( nLastRec ) ) + ") - "
		cMsgProc		+= cMsg1
		cMsgProc		+= "( "
		cMsgProc		+= cTimeIni
		cMsgProc		+= " ) "
		cMsgProc		+= cMsG2
		cMsgProc		+= "( "
		IF ( lOnlyOneProc )
			cMsgProc	+= cMsg3
			cMsgProc	+= RemainingTime( cTimeIni , nCountTime , .T. , @nSeconds )
		Else
			cMsgProc	+= cMsg3
			cMsgProc	+= RemainingTime( cTimeIni , 0 , .F. )
			cMsgProc	+= " / "
			cMsgProc	+= cMsg4
			cMsgProc	+= RemainingTime( NIL , nCountTime , .T. , @nSeconds )
		EndIF 
		cMsgProc		+= " ) "
		/*
		cMsgProc		+= cMsg5
		cMsgProc		+= "( "
		cMsgProc		+= RetTimeEndProc( nTmCntG1Proc , nLastRec , nSeconds )
		cMsgProc		+= " ) " 
		*/
		U_IncProG1( cMsgProc )
	Else
		U_IncProG1()
	EndIF
Else
	U_IncProG1()
EndIF

Return( NIL )

/*
зддддддддддбддддддддддддддбдддддбдддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤┘o	   ЁIncPG2T       ЁAutorЁ Marinaldo de Jesus  Ё Data Ё13/03/2003Ё
цддддддддддеддддддддддддддадддддадддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤┘o ЁChamada a IncProG2() com calculo de Tempo de Processamento Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<Vide Parametros Formais> 									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso	   ЁGenerico      												Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
User Function IncPG2T (	cMsgIncProc		,;	//01 -> Inicio da Mensagem
						nLastRec		,;	//02 -> Numero de Registros a Serem Processados
						cTimeIni		,;	//03 -> Tempo Inicial
						lOnlyOneProc	,;	//04 -> Defina se eh um processo unico ou nao ( DEFAULT .T. )
						nCountTime		,;	//05 -> Contador de Processos
						nPercent	 	 ;	//06 -> Percentual para Incremento
					)
         
Local cMsg1 	:= "Inicio"
Local cMsg2 	:= "Decorridos"
Local cMsg3 	:= ""  // "Total:"
Local cMsg4 	:= "Parcial:"
Local cMsg5 	:= "Final estimado"
Local cMsgProc	:= ""
Local nSeconds	:= 0.00
Local nPercInc	:= 0.00

DEFAULT cMsgIncProc 	:= "Procesando..."
DEFAULT nLastRec		:= 0.00
DEFAULT cTimeIni		:= Time()
DEFAULT lOnlyOneProc	:= .T.
DEFAULT nCountTime		:= 0.00	
DEFAULT nPercent		:= 5.00	

IF !( nTmLstG2Cnt == nCountTime )
	nTmLstG2Cnt		:= nCountTime
	nTmCntG2Proc	:= 0.00
	nTmLstG2Proc	:= 0.00
EndIF

nPercInc := ( ( ++nTmCntG2Proc ) / nLastRec )
nPercInc *= 100
nPercInc := Int( nPercInc )

IF ( nTmCntG2Proc == 1 )
	IF ( lOnlyOneProc )
		RemainingTime( cTimeIni , nCountTime , .F. )
	Else
		RemainingTime( cTimeIni , 0 , .F. )
		RemainingTime( NIL , nCountTime , .F. )
	EndIF
EndIF

IF ( ( nPercInc % nPercent ) == 0.00 )
	IF !( nTmLstG2Proc == nPercInc )
		nTmLstG2Proc	:= nPercInc
		cMsgProc		+= cMsgIncProc
		IF !( SubStr( cMsgProc , -1 ) == " " )
			cMsgProc	+= " "
		EndIF	
		cMsgProc		+= StrZero( nPercInc , 03 ) + "% - "
		cMsgProc		+= "(" + AllTrim( Str( nTmCntG2Proc ) ) + "/" + AllTrim( Str( nLastRec ) ) + ") - "
		cMsgProc		+= cMsg1
		cMsgProc		+= "( "
		cMsgProc		+= cTimeIni
		cMsgProc		+= " ) "
		cMsgProc		+= cMsg2
		cMsgProc		+= "( "
		IF ( lOnlyOneProc )
			cMsgProc	+= cMsg3
			cMsgProc	+= RemainingTime( cTimeIni , nCountTime , .T. , @nSeconds )
		Else
			cMsgProc	+= cMsg3
			cMsgProc	+= RemainingTime( cTimeIni , 0 , .F. )
			cMsgProc	+= " / "
			cMsgProc	+= cMsg4
			cMsgProc	+= RemainingTime( NIL , nCountTime , .T. , @nSeconds )
		EndIF
		cMsgProc		+= " ) "
		/*
		cMsgProc		+= cMsg5
		cMsgProc		+= "( "
		cMsgProc		+= RetTimeEndProc( nTmCntG2Proc , nLastRec , nSeconds )
		cMsgProc		+= " ) "  
		*/
		U_IncProG2( cMsgProc )
	Else
		U_IncProG2()
	EndIF
Else
	U_IncProG2()
EndIF

Return( NIL )