#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "APWEBEX.CH"
#INCLUDE "rwmake.ch"
#Include "RPTDEF.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MTKRCOTA  ∫Autor  ≥Microsiga           ∫ Data ≥  2/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Envio de Orcamento                                          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function MTKRCOTA()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Declaracao das variaveis                                      ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//Local nX     := 0
Local aCores := {	{ 'SCJ->CJ_STATUS=="A"' , 'ENABLE' },; 	//Orcamento em Aberto
	{ 'SCJ->CJ_STATUS=="B"' , 'DISABLE'},;						//Orcamento Baixado
	{ 'SCJ->CJ_STATUS=="C"' , 'BR_PRETO'},;						//Orcamento Cancelado
	{ 'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'},;					//Orcamento nao Orcado
	{ 'SCJ->CJ_STATUS=="E"' , 'BR_AZUL' }}	      				//Orcamento aprovado
//Local bBlock
//Local nPos := 0

Private cCadastro	:= OemtoAnsi("Oráamentos de Venda")
Private aAutoCab	:={}
Private aAutoItens	:={}
Private aRotina		:= { {"Pesquisar","AxPesqui"  , 0 , 1 },; 	//"Pesquisar"
	{"Visualizar","A415Visual", 0 , 2 },; 							//"Visualizar"
	{"Enviar Email","U_EnviaEmail()", 0 , 3 }}


mBrowse( 6, 1,22,75,"SCJ",,,,,,aCores)


Return(.T.)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥EnviaEmail∫Autor  ≥Microsiga           ∫ Data ≥  23/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Rotina de Envio de Email.                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function EnviaEmail()
//Local  _lFalha    := .f.          

//Local cDir 		  := ""
//Local cDrive      := "" 
//Local nRet        := 0 
//Local cFileName   := GetTempPath() + "cHtml.txt"
Local nY          := 0

Private _cFilial  := xFilial("SD2")
Private _cNum     := SCJ->CJ_NUM
Private lDetalhe  := .F.
Private lObs	   := .F.
Private cPerg     := "MTKRCO"


Private cPassword := GETMV("MV_RELPSW")   // negocio    (NAO ESTA LEVANDO EM CONSIDERACAO)
Private cAccount  := GETMV("MV_RELACNT")  //"comercial@multitek.com.br" //U_FuncUser()         ///  GETMV("MV_RELACNT")  // erpmultitek@multitek.com.br
Private cServer   := GETMV("MV_RELSERV")  // 10.0.0.2 // (12/05/2009) 10.0.0.140
Private _cPara    := SPACE(250)
Private cCC       := "" //:= GetMV("MV_WFSMTP")
Private _cIndComer:= ""    
         
Private cSubject  := ""
               
Private lSmtpAuth :=.t.
Private _nAliqIcm := 0
Private _nValIpi  := 0
Private _nValIcm  := 0
Private _nTotMerc := 0
Private _nTotIpi  := 0
Private _nTotIcm  := 0
Private _nTotVlUnit := 0   //alterado NASSER 28/08/07
Private _nIndUlt   := 0     //alterado NASSER 28/08/07
Private _nTotImp  := 0
Private aViewSCK  := {}
Private cHtml     := ""
Private cObserv   := space(100)

Private  cMensagem   := ''
Private  aLista      := {}                           
Private  cMSG := ""

Private  _cContato := ""
Private  _uString  := ""

//
// Informacoes para geracao do Html
//       
if !Dialogo()
   Return
Endif   

//
// Informacoes para geracao do Html
//       
IF !DadosSCK(aViewSCK)
   Return
Endif

cServer  := alltrim(cServer)
cAccount := alltrim(cAccount)
_cPara   := alltrim(_cPara)
cCC      := alltrim(cCC)
_cContato:= alltrim(_cContato)
if cEmpAnt = '01' //"MULTITEK" $ upper(alltrim(_cPara))
   cSubject := "Orcamento Multitek numero. "+_cNum + " ( "+alltrim(SA1->A1_NREDUZ)+" ) "
else
   cSubject := "Orcamento Ubc numero. "+_cNum + " ( "+alltrim(SA1->A1_NREDUZ)+" ) "
Endif	
aLista   := {} 
_uString := ALLTRIM(_cPara) 


//
// Separa as contas de Email para Envio Personalizado
// 
While Len(_uString) > 0                
	AADD(aLista,ParseSep(@_uString))  
End


//
// Atualizacao do Cadastro de Clientes
// 
If Empty(SA1->A1_X_EMAIL) .or. Empty(SA1->A1_CONTATO)
   DbSelectArea("SA1")
   Reclock("SA1",.F.)  
   If Empty(SA1->A1_X_EMAIL)
      SA1->A1_X_EMAIL:=aLista[1]
   Endif
   If Empty(SA1->A1_CONTATO)
      SA1->A1_CONTATO:=alltrim(_cContato)
   Endif
   MsUnlock()
Endif


For nY:=1 to len(aLista)
     
    cTo     :=aLista[NY]
	lView   :=.t.
	_cAtch  :=""
    _cFrom  :=AllTrim(SuperGetMV("MV_RELFROM" ,.F., ""))
	if cEmpAnt = '01' //"MULTITEK" $ upper(alltrim(_cPara))
       CBODY	:= HtmlMTK(cTo)
    Else
       CBODY	:= HtmlUBC(cTo)
    Endif
  
	u_SendMail(cTo, cCC, cSubject, cBody, lView, _cAtch, _cFrom)

Next

Return



/*/{Protheus.doc} SendMail
FunÁ„o para envio de e-mail.
@type function
@version 1.0
@author Paulo Felipe
@since 7/9/2020
@param cTo, character, destinat·rio.
@param cCC, character, cÛpia.
@param cSubject, character, assunto.
@param cBody, character, mensagem.
@param lView, logical, se visualiza mensagens.
@return logical, se conseguiu enviar o e-mail.
/*/
User Function SendMail(cTo, cCC, cSubject, cBody, lView, _cAtch, cFrom)

	Local aAttach		:= {}
	Local cAccount 		:= AllTrim(SuperGetMV("MV_RELACNT" ,.F., ""))
	//Local cFrom			:= AllTrim(SuperGetMV("MV_RELFROM" ,.F., ""))
	Local cPassword 	:= AllTrim(SuperGetMV("MV_RELPSW", .F., ""))
	Local cSMTP			:= AllTrim(SuperGetMV("MV_RELSERV", .F., ""))
	Local cUser 		:= AllTrim(SuperGetMV("MV_RELAUSR", .F., ""))
	Local nTimeOut 		:= SuperGetMV("MV_RELTIME", .F., 30)
	Local lOk     		:= .T.
	Local lAuth			:= SuperGetMV("MV_RELAUTH", .F., .F.)
	Local lSSL			:= SuperGetMV("MV_RELSSL", .F., .F.)
	Local lTLS			:= SuperGetMV("MV_RELTLS", .F., .F.)
	Local nPort 		:= SuperGetMV("MV_PORSMTP", .F., 25)
	Local nError		:= 0
	Local oMessage		:= Nil
	Local oSMTP			:= Nil

	//Default cCC			:= ""
	//Default cSubject	:= "E-mail enviado via TOTVS Protheus"
	//LOcal lView		:= .T.
	//Default _cAtch		:= ""
	//Default _cFrom		:= ""

	if !Empty(_cFrom)
		cFrom:= _cFrom
	endif 

	if !Empty(_cAtch)
		AADD(aAttach,_cAtch)
	endif

	oSMTP := TMailManager():New()

	// Quando for informado a porta, separa do endereÁo.
	If At(':', cSMTP) > 0
		nPort := Val(SubStr(cSMTP, At(':', cSMTP) + 1))
		cSMTP := SubStr(cSMTP, 1, At(':', cSMTP) - 1)
	EndIf

	If nPort == 465 .And. lSSL == .F.
		lSSL := .T.
	ElseIf nPort == 587 .And. lTLS == .F.
		lTLS := .T.
	EndIf

    nPort:=0
	lSSL :=.t.
	lTLS :=.t.

	oSMTP:SetUseSSL(lSSL)
	oSMTP:SetUseTLS(lTLS)

	//If (nPosAt := At('@', cAccount)) > 0
	//	cAccount := SubStr(cAccount, 1, nPosAt - 1)
	//Endif

	Begin Sequence
		// Configura dados para conex„o.
		If (nError := oSMTP:Init("", cSMTP, cAccount, cPassword, 0, nPort)) != 0
			Break
		EndIf

		// Seta o TimeOut(em segundos) para conexao baseado no parametro MV_RELTIME.
		oSMTP:SetSMTPTimeOut(nTimeOut)

		// Conecta ao servidor SMTP.
		If (nError := oSMTP:SMTPConnect()) != 0
			Break
		EndIf

		// Autentica se houver a necessidade.
		If lAuth .And. (nError := oSMTP:SMTPAuth(cUser, cPassword)) != 0
			Break
		EndIf

		// Inicia objeto de mensagem de e-mail.
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom := cFrom
		oMessage:cTo := cTo
		oMessage:cCc := cCC
		oMessage:cSubject := cSubject
		oMessage:cBody := cBody

		// Verifica se h· anexos e os informa na mensagem.
		If !Empty(aAttach)
			AEval(aAttach, {|x| oMessage:AttachFile(x)})
		EndIf

		// Realiza o envio da mensagem.
		If (nError := oMessage:Send(oSMTP)) != 0
			Break
		EndIf

		If lView
			ShowHelpDlg("AtenÁ„o", {"InformaÁıes sobre o envio do e-mail: ", oSMTP:GetErrorString(nError)}, 2, {""}, 1)
		EndIf
		lOk := .F.

	End Sequence

	oSMTP:SMTPDisconnect()

	FreeObj(oSMTP)
	FreeObj(oMessage)

Return lOk





/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥HtmlMTK ∫Autor  ≥Microsiga           ∫ Data ≥  23/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Monta o Html a ser enviado no Email                         ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function HtmlMTK(cTo)

Local nInd    :=0
Local nLenSCK := LEN(aViewSCK)
          
cHtml :="" 
cHtml += '<html>' //+ CRLF
cHtml += '<head>' //+ CRLF


cHtml += '<style type="text/css">'
cHtml += '<!--                    '
cHtml += '.style2 {color: #F3F3F3} '
cHtml += 'body {                    '
cHtml += '	margin-left: 10px;       '
cHtml += '	margin-top: 0px;          '
cHtml += '	margin-right: 10px;        '
cHtml += '	margin-bottom: 10px;        '
cHtml += '}                             '
cHtml += '-->                            '
cHtml += '.style4 {color: #000000}'


cHtml += '</style>                        '
cHtml += '<table border="0" width="100%">  '
cHtml += '<tr>                              '
cHtml += '  <tr> 

/*                            '
if "MULTITEK" $ upper(alltrim(_cPara))
   //cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="ttp://server-bi/image/logo_mtk-70x98.jpg" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
   cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="F:\Logos\logo_mtk-70x98.jpg" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
Else
   cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="http://www.multitek.com.br/image/logo_mtk-70x98.jpg" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
Endif 
*/
if cEmpAnt = '01' //"MULTITEK" $ upper(alltrim(_cPara))
   //cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="ttp://server-bi/image/logo_mtk-70x98.jpg" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
   cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="http://www.multitek.com.br/images/logo.png" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
Else
   cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="https://ubc-rolamentosdobrasil.com.br/logo" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
Endif 


cHtml += '    <td width="69%" align="left"><h5 class="style3">'+SM0->M0_NOMECOM+'<br>                                                                                                               '
cHtml += '     '+SM0->M0_ENDCOB
cHtml += '     CEP: '+TRANSFORM(alltrim(SM0->M0_CEPCOB),"@R 99999-999")+' - '+SM0->M0_CIDCOB+' - '+SM0->M0_ESTCOB+'<br>'
cHtml += '     Tel. '+SM0->M0_TEL   +'Fax: '+SM0->M0_FAX+'<br>                                                                                                                                    '
cHtml += '     CNPJ : '+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") + ' IE:'+TRANSFORM(alltrim(SM0->M0_INSC),"@R 999.999.999.999")+'</h5>                                                                                                  '
cHtml += '    </td> '
/*
If "MULTITEK" $ upper(alltrim(_cPara))
    cHtml += '    <td width="22%"><div align="center"><a href="http://server-bi">Acesse o nosso site</a></div></td>'
Else
    cHtml += '    <td width="22%"><div align="center"><a href="www.multitek.com.br">Acesse o nosso site</a></div></td>'
Endif
*/
If  cEmpAnt = '01'
    cHtml += '    <td width="22%"><div align="center"><a href="www.multitek.com.br">Acesse o nosso site</a></div></td>'
Else
    cHtml += '    <td width="22%"><div align="center"><a href="https://ubc-rolamentosdobrasil.com.br">Acesse o nosso site</a></div></td>'
Endif


cHtml += '  </tr><h4>&nbsp;</h4>'
cHtml += '</table>'


//
//  orcamento
//

If  cEmpAnt = '01'
	cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#333333">'
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#336699"><div align="center"><strong> '
	cHtml += 'Orcamento'
	cHtml += '<b></b>'
	cHtml += '</strong></div></td>'	
	cHtml += '</tr>'	
	cHtml += '</table>'
else
	cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#f51d0a">'
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#f51d0a"><div align="center"><strong> '
	cHtml += 'Orcamento'
	cHtml += '<b></b>'
	cHtml += '</strong></div></td>'
	cHtml += '</tr>'
	cHtml += '</table>'
Endif	



cHtml += '<table border="0" width="100%" bgcolor="#E6E6E6">                                                                                                                                                '
cHtml += '<tr>                                                                                                                                                                                              '
cHtml += '<td width="100%" colspan="3">                                                                                                                                                                      '
cHtml += '<table width="100%" border="0" bordercolor="#000000"><!--DWLayoutTable-->                                                                                                                           '
cHtml += '<tr>                                                

//#000080  - Azul Fonte
//#F3F3F3  - Cinza Claro
//#f51d0a  - Vermelho
//#000000  - Preto 
//#ffffff  - Branco
//#E6E6E6  - Cinza Claro
                                                                                                                                                 '
cHtml += '<td width="20%"><b><font color="#000080">N do Orcamento</font></b></td>                                                                                                                               '
cHtml += '<td width="30%">'+SCJ->CJ_NUM+'  REAL </td> '
cHtml += '<td width="20%"><b><font color="#000080">Data do Orcamento</font></b></td>                                                                                                                              '
cHtml += '<td width="30%">'+DTOC(SCJ->CJ_EMISSAO)+'</td>                                                                                                                                                         '
cHtml += '</tr>                                                                                                                                                                                                   '
cHtml += '<tr>                                                                                                                                                                                                     '
cHtml += '<td width="20%"><b><font color="#000080">Cliente</font></b></td>                                                                                                                                          '
cHtml += '<td width="30%">'+SA1->A1_COD+'/'+SA1->A1_LOJA+' -  '+SA1->A1_NREDUZ+'</td>                                                                                                                                                   '
cHtml += '<td width="20%"><b><font color="#000080">CNPJ/CPF</font></b></td>                                                                                                                                           '
cHtml += '<td width="30%">'+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")+'</td>                                                                                                                                     '
cHtml += '</tr>'	 
cHtml += '<tr>'		 
cHtml += '<td width="20%"><b><font color="#000080">Telefone</font></b></td>                                                                                                                                              '
cHtml += '<td width="30%">'+  SA1->A1_TEL +'</td>                                                                                                                                                                        '
cHtml += '<td width="20%"><b><font color="#000080">Contato</font></b></td>                                                                                                                                                '
cHtml += '<td width="30%">'+_cContato+'</td>                                                                                                                                                                        '
cHtml += '</tr>                                                                                                                                                                                                            '
cHtml += '<tr>                                                                                                                                                                                                              '
cHtml += '<td width="20%" height="31"><b><font color="#000080">E-Mail</font></b></td>                                                                                                                                        '
cHtml += '<td width="30%">'+cTo+'</td>                                                                                                                                                                             '
cHtml += '<td width="20%" height="27"><b><font color="#000080">I.E: </font></b></td>                                                                                                                                          '
cHtml += '<td width="30%">'+SA1->A1_INSCR+'</td>                                                                                                                                                                              '
cHtml += '</tr>                                                                                                                                                                                                                '
cHtml += '<tr>                                                                                                                                                                                                                  '
cHtml += '<td width="20%" height="27"><b><font color="#000080">Municipio</font></b></td>                                                                                                                                         '
cHtml += '<td width="30%">'+SA1->A1_MUN+'</td>                                                                                                                                                                                   '
cHtml += '<td width="20%"><b><font color="#000080">Fax </font></b></td>                                                                                                                                                           '
cHtml += '<td width="30%"><p>'+SA1->A1_FAX+'</p>  </td>                                                                                                                                                                           '
cHtml += '</tr>                                                                                                                                                                                                                    '
cHtml += '<tr>                                                                                                                                                                                                                      '
cHtml += '<td width="20%"><p><br>                                                                           '
cHtml += '  <b><font color="#000080">Vendedor</font></b></p>  </td>                                         '
cHtml += '<td width="30%"><p><br>                                                                            '
cHtml += SA3->A3_COD+' -  '+SA3->A3_NOME+'</p>  </td>'  
cHtml += '<td width="20%"><b><font color="#000080"><br>                                                      '
cHtml += '  E-mail Vendedor</font></b></td>                                                                   '
cHtml += '<td width="30%"><p><br>                                                                              '
cHtml += '  '+SA3->A3_EMAIL+'</p>  </td>' 
cHtml += '</tr>                                                                                                 '
cHtml += '<tr>                                                                                                   '
cHtml += '<tr bordercolor="#0000FF">                                                                              '
cHtml += '<td width="20%" height="49" bordercolor="#FF0000"><p><b><font color="#000080"><br>                       '
cHtml += '        <br>                                                                                              '
cHtml += '        Cond. de Pagamento</font></b></p>                                                                  '
cHtml += '  </td>                                                                                                     '
cHtml += '<td width="30%"><p>&nbsp;</p>                                                                                '
cHtml += '  <p>'+SE4->E4_CODIGO+' - '+SE4->E4_DESCRI+'</p></td>                                                        '
cHtml += '<td width="20%"><p>&nbsp;</p>                                                                                  '
cHtml += '  <p><b><font color="#000080">Tipo de Frete</font></b></p></td>                                                       '
cHtml += '<td width="30%"><p>&nbsp;</p>                                                                                    '
cHtml += '  <p>'+IF(SCJ->CJ_X_TPFRT="C","CIF","FOB")+'</p></td>                                                                           '
//cHtml += '  <p><b><font color="#000080">% Icms </font></b></p></td>                                                       '
//cHtml += '<td width="30%"><p>&nbsp;</p>                                                                                    '
//cHtml += '  <p>'+STRZERO(_nAliqIcm,2)+'</p></td>                                                                           '
cHtml += '</tr>                                                                                                             '
//cHtml += '<tr>                                                                                                               '
//cHtml += '<td width="20%"><b><font color="#000080"></font></b></td>                                                           '
//cHtml += '<td width="30%">                                  </td>                                                              '
//cHtml += '<td width="20%"><b><font color="#000080">Tipo de Frete</font></b></td>                                                '
//cHtml += '<td width="30%">'+IF(SCJ->CJ_X_TPFRT="C","CIF","FOB")+'</td>                                                         '
//cHtml += '</tr>                                                                                                                '
cHtml += '</table>'

//
// Observacao
//
// O if abaixo somente altera a cor de fundo
If  cEmpAnt = '01'
    cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#333333">' //333333
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#336699"><div align="center"><strong> '
	cHtml += 'Observacao'
	cHtml += '<b></b>'
	cHtml += '</strong></div></td>'
    cHtml += '</tr>'
    cHtml += '</table>'
ELSE 
    cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6">' //333333
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#E6E6E6"><div align="center"><strong> '
	cHtml += 'Observacao'
	cHtml += '<b></b>'
	cHtml += '</strong></div></td>'
	cHtml += '</tr>'
	cHtml += '</table>'
ENDIF


If !Empty(SCJ->CJ_X_COTCL)
	cHtml += '<table width="100%"  border="0" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
	cHtml += '<tr valign="top">'
	cHtml += '<td><p><br>'
	cHtml += '    <p><strong>Cotacao do Cliente Numero:  '+SCJ->CJ_X_COTCL       ///SCJ->CJ_X_COTCLI
	cHtml += '    <br>'
	cHtml += '    <br>'
	cHtml += '  </strong></p>'
	cHtml += '  </td>  '
	cHtml += '</tr>    '
	cHtml += '</table>'
Endif


cHtml += '<table width="100%"  border="0" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
cHtml += '<tr valign="top">'
cHtml += '<td><p><br>'
cHtml += '    <p><strong>'+cObserv
cHtml += '    <br>'
cHtml += '    <br>'
cHtml += '  </strong></p>'
cHtml += '  </td>  '
cHtml += '</tr>    '
cHtml += '</table>'



//
// Itens
//
// O if abaixo somente altera a cor de fundo
If  cEmpAnt = '01'
	cHtml += '<table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#333333">'
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#336699">
	cHtml += '<tr>                                                                                                                                        '
	cHtml += '<td width="3%" bgcolor="##336699"><div align="center"><span class="style4"><b>Item</b></span></div></td>
	cHtml += '<td width="20%" bgcolor="#336699" class="style2"><div align="center"><span class="style4"><b>Descricao</b></span></div></td>
	cHtml += '<td width="20%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Codigo Cliente</b></div></td>
	cHtml += '<td width="5%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Un</b></div></td>
	cHtml += '<td width="10%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Qtde</b></div></td>
	cHtml += '<td width="14%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Vl Unitario</b></div></td>
	cHtml += '<td width="5%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>% IPI</b></div></td>
	cHtml += '<td width="5%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>% ICMS</b></div></td>
	cHtml += '<td width="5%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Prazo de Entrega</b></div></td>	
	cHtml += '<td width="6%" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Class. Fiscal</b></div></td>
	cHtml += '<td width="20" bgcolor="#336699" class="style2"><div align="center" class="style4"><b>Observacao</b></div></td>
else
	cHtml += '<table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#E6E6E6">'
	cHtml += '<tr valign="top"> '
	cHtml += '<td bgcolor="#E6E6E6">
	cHtml += '<tr>                                                                                                                                        '
	cHtml += '<td width="3%" bgcolor="#E6E6E6"><div align="center"><span class="style4"><b>Item</b></span></div></td>
	cHtml += '<td width="20%" bgcolor="#E6E6E6" class="style2"><div align="center"><span class="style4"><b>Descricao</b></span></div></td>
	cHtml += '<td width="20%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Codigo Cliente</b></div></td>
	cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Un</b></div></td>
	cHtml += '<td width="10%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Qtde</b></div></td>
	cHtml += '<td width="14%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Vl Unitario</b></div></td>
	cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>% IPI</b></div></td>
	cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>% ICMS</b></div></td>
	cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Prazo de Entrega</b></div></td>
	cHtml += '<td width="6%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Class. Fiscal</b></div></td>
	cHtml += '<td width="20" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Observacao</b></div></td>
Endif	

For nInd := 1 to nLenSCK 
	cHtml += '<tr>  '
	cHtml += '<td width="03%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][1] + '</div></td> ' 
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][2] + '</td>'
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][3] + '</td> '
	cHtml += '<td width="05%" bgcolor="#E6E6E6">' + aViewSCK[nInd][4] + '</td>  '                                                                                        
	cHtml += '<td width="10%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[nInd][5] + '</div></td>'
	cHtml += '<td width="14%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[nInd][6] + '</div></td> ' //valor unitario
	cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][7] + '</div></td> '
	cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + strzero(aViewSCK[nInd][12],2) + '</div></td> '
	cHtml += '<td width="5%" bgcolor="#E6E6E6">' + aViewSCK[nInd][8] + '</td> '   
	cHtml += '<td width="6%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][9] + '</div></td>'
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][10] + '</td>'
	cHtml += '</tr>    '                               
	_nIndUlt := nInd //alterado NASSER 24/08/07
Next                                                                                                                                                                      

//
// Total
//
//
cHtml += '<tr>  '
cHtml += '<td width="03%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td> ' 
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + '.' + '</td>'
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + 'TOTAL SEM IPI' + '</td> '
cHtml += '<td width="05%" bgcolor="#E6E6E6">' + '.' + '</td>  '                                                                                        
cHtml += '<td width="10%" bgcolor="#E6E6E6"><div align="right">' + '.' + '</div></td>'
cHtml += '<td width="14%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[_nIndUlt][11] + '</div></td> ' //valor unitario
cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td> '
cHtml += '<td width="5%" bgcolor="#E6E6E6">' + '.' + '</td> '   
cHtml += '<td width="5%" bgcolor="#E6E6E6">' + '.' + '</td> '   
cHtml += '<td width="6%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td>'
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + '.' + '</td>'
cHtml += '</tr>    '                               






cHtml += '</table>                                                                                                                                                          '
cHtml += '<table width="100%"  border="0" cellpadding="0" cellspacing="0" bordercolor="#333333">'
cHtml += '<tr valign="top">'
cHtml += '<td width="0" height="0" bordercolor="#000000"><p align="left" class="style8"><br>'
cHtml += '<b></b>'
cHtml += '</strong></div></td>'
cHtml += '</tr>'
cHtml += '</table>'

// Observacao
//       
cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
cHtml += '<tr valign="top">'
cHtml += '<td width="0" height="0" bordercolor="#000000"><p align="left" class="style8"><br>'
cHtml += '    <strong>Condicoes Gerais do Orcamento: </strong></p>'
cHtml += '    <p align="left" class="style8"><strong>'
cHtml += '    a) Faturamento parcial Permitido.<br>'
cHtml += '    b) Nao ha precos fixos e Irreajustaveis para qualquer produto Importado ou Nacional.<br>'
cHtml += '    c) Os Prazos passarao a ter validade a partir da confirmacao formal do Pedido.<br>'
cHtml += '    d) Todos os produtos desse orcamento estao sujeitos a venda previa.<br>'
cHtml += '    e) Validade do Orcamento : '+GETMV("MV_DTPROPO")+'.<br>' 
cHtml += '    f) Produto destinado para uso ou aplicacao exclusivamente industrial.<br>'
cHtml += '    g) Os Precos serao reajustados ate a data do faturamento efetiva conforme variacao Cambial e ou Tabela do Fabricante.<br>'
cHtml += '       Dolar Base = Us$ '+ Transform(SM2->M2_MOEDA2,"@E 9,999.99")  +' de '+ dtoc(SM2->M2_DATA)+' <br>'
cHtml += '    <br>'
cHtml += '  </strong></p>'
cHtml += '  </td>'
cHtml += '</tr>'
cHtml += '</table>'
cHtml += '<p align="left"></p>'



return(cHtml)




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥DadosSCK   ∫Autor  ≥Microsiga          ∫ Data ≥  23/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function DadosSCK(aViewSCK)

Local lRet:=.T.
Local _lPrimeira := .T.

Private _cCliente := SCJ->CJ_CLIENTE
Private _cLoja    := SCJ->CJ_LOJA   
Private _cClient  := SCJ->CJ_CLIENT  
Private _cLojaEnt := SCJ->CJ_LOJAENT

//
// Posicionar Tabelas
//
SCJ->(DbSetOrder(1),DbSeek(xFilial("SCJ")+_cNum,.T.))
SA1->(DbSetOrder(1),DbSeek(xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA),.T.))
SA3->(DbSetOrder(1),DbSeek(xFilial("SA3")+SCJ->CJ_X_VEND1,.T.))
SE4->(DbSetOrder(1),DbSeek(xFilial("SE4")+SCJ->CJ_CONDPAG,.T.))
dInicioMes := Ctod("01/"+STRZERO(Month(SCJ->CJ_EMISSAO),2)+"/"+STR(Year(SCJ->CJ_EMISSAO),4))

DbSelectArea("SM2")
DbSetOrder(1)
SET SOFTSEEK ON
DbSeek(DTOS(dInicioMes),.T.)
SET SOFTSEEK OFF


DbSelectArea("SM2")          // Nao utilizei eof pois pode nao ter cadastrado a Moeda ainda.
While !SM2->(BOF()) .and. SM2->M2_MOEDA2 = 0
	SM2->(Dbskip(-1))
Enddo

DbSelectArea("SCJ")
DbSetOrder(1)
If DbSeek(xFilial("SCJ")+_cNum)

    _cIndComer:= SCJ->CJ_X_ST_CI

	_lPrimeira:= .t.
	
	DbSelectArea("SCK")
	DbSetOrder(1)
	If DbSeek(xFilial("SCK")+_cNum)
		               
		While !SCK->(Eof()) .and. xFilial("SCK")+_cNum = SCK->(CK_FILIAL+CK_NUM)


	        //
    	    // Pega o valor do Icms com base no Primeiro produto.
   	   	    //
            If  _lPrimeira

				DbSelectArea("SF4")
				DbSetorder(1)
				Dbseek(xFilial("SF4")+ALLTRIM(SCK->CK_TES))
              
	   			//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//≥Posiciona o item no Cadastro de Clientes                                 ≥
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
 			    // Cliente de Entrega
				DbSelectArea("SA1")
				DbSetorder(1)
				Dbseek(xFilial("SA1")+_cClient+_cLojaEnt)


				// Cliente de Faturamento
				DbSelectArea("SA1")
				DbSetorder(1)
				Dbseek(xFilial("SA1")+_cCliente+_cLoja)
           	    
           	    _lPrimeira:=.f.

        	Endif   
			_nAliqIcm := U_IcmsAliq(_cClient,_cLojaEnt,SCK->(CK_PRODUTO),SF4->F4_CODIGO)

			SB1->(DbSetOrder(1),DbSeek(xFilial("SB1")+SCK->(CK_PRODUTO),.T.))

			_nTotVlUnit += SCK->CK_PRCVEN * SCK->CK_QTDVEN  //alterado NASSER 18/09/2007

			AADD(aViewSCK,{SCK->CK_ITEM,;
			               SCK->CK_DESCRI,;
			               IF(Empty(SCK->CK_X_PRCLI) .OR. UPPER(ALLTRIM(GetMV("MV_CODCLIE"))) $ UPPER(ALLTRIM(SCK->CK_X_PRCLI)) ,".",SCK->CK_X_PRCLI),;
			               SCK->CK_UM,;
			               TRANSFORM(SCK->CK_QTDVEN,'@E 999,999.999'),;
			               TRANSFORM(SCK->CK_PRCVEN,'@E 999,999.99'),;
			               TRANSFORM(SCK->CK_X_IPI,'@E 999.99'),;
			               DTOC(SCK->CK_X_ENTRE),;
			               SB1->B1_POSIPI,;
			               IF(Empty(SCK->CK_OBS),".",SCK->CK_OBS),;
			               TRANSFORM(_nTotVlUnit,'@E 999,999.99'),; 
			               _nAliqIcm}) //alterado NASSER 24/08/07

         If Empty(SCK->CK_X_ENTRE) .and. lRet
         	Aviso("ATENCAO", "Existem itens neste orcamento com o campo Prazo de Entraga em branco."+chr(13)+chr(13)+;
         	"E-mail nao foi enviado...",{"&Ok"})
            lRet:=.F.
         Endif   


			_nValIpi  := SCK->CK_VALOR * (SB1->B1_IPI  / 100)
			_nValIcm  := SCK->CK_VALOR * ( _nAliqIcm   / 100)
			_nTotMerc += SCK->CK_VALOR                                                          // Valor da Mercadoria
			_nTotIpi  += _nValIpi                                                               // Valor de Ipi
			_nTotIcm  += _nValIcm                                                               // Valor de Icm
			_nTotImp  += SCK->CK_VALOR + _nValIpi // ou SCK->CK_VALOR * (1+ (SB1->B1_IPI  / 100 ))// Total com Impostos
			
			
			SCK->(DbSkip())
			
		Enddo
		
	Endif
	
Endif




Return(lRet)





/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥Dialogo   ∫Autor  ≥Microsiga           ∫ Data ≥  23/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Tela utilizada no Envio de Email.                           ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function Dialogo()
Local lRet := .f.

SA1->(DbSetOrder(1),DbSeek(xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA),.T.))

_cPara:=Alltrim(SA1->A1_X_EMAIL)+space(250) 
_cContato:=Alltrim(SA1->A1_CONTATO)+space(250)

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Declaracao de Variaveis                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Criacao da Interface                                                ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
@ 106,74 To 346+200,606+10 Dialog oDialog Title OemToAnsi("Envio de Email")
@ 9,12 To 80,196 Title OemToAnsi("Dados para Envio de Email - REMETENTE") Object Quadro

@ 25,24 Say OemToAnsi("Num. do Orcamento") Size 100,8
@ 25,78 Get _cNum Size 30,10 when .f.

@ 38,25 Say OemToAnsi("Enviar Para:") Size 34,8
@ 38,78 Get _cPara Size 115,10

@ 51,25 Say OemToAnsi("Contato") Size 34,8
@ 51,78 Get _cContato Size 115,10

@ 64,26 Say OemToAnsi("Observacao")   Size 42,8
@ 64,78 Get cObserv Size 115,10 picture "@S40"

NL=95
@ NL,26 Say "Observaoes para uso desta rotina:"   
NL+=10
NL+=10
@ NL,26 Say "1) Todos os enderecos devem ser separados por ponto  e virgula;" 
NL+=10
@ NL,26 Say "2) O Email enviado e Persolalizado desta forma nao e indentificado para quem  foi  copias;"
NL+=10
@ NL,26 Say "3) Caso o cliente nao tenha E-mail cadastrado sempre informar o primeiro Email"
NL+=10
@ NL,26 Say "   como sendo o do cliente, pois o sistema atualizara o cadastro  automaticamente."   
NL+=10
@ NL,26 Say "   O mesmo processo de atualizacao automatica ocorre com o Contato;"
NL+=10
@ NL,26 Say "4) O Email pode ser digitado Maisculo ou Minusculo."
NL+=10
@ NL,26 Say "5) O campo Observacao utilizado acima nao e gravado/armazenado.   Sera  apenas "
NL+=10
@ NL,26 Say "   agregado ao corpo do E-mail."


@ 13,207 Button OemToAnsi("_Confirma") Size 36,16 Action (lRet:=.t.,If(valNum(_cNum,_cPara),Close(oDialog),))
@ 33,207 Button OemToAnsi("_Cancela") Size 36,16 Action (lRet:=.f.,Close(oDialog))

Activate Dialog oDialog center

Return(lRet)


Static Function valNum(_cNum,_cPara)
Local lRet:=.t.


If EmptY(_cNum)
	Aviso("ATENCAO", "Favor informar o numero do orcamento que deseja imprimir...",{"&Ok"})
	lRet:=.f.
Else
	DbSelectArea("SCJ")
	DbSetOrder(1)
	IF !Dbseek(xFilial("SCJ")+_cNum)
		Aviso("ATENCAO", "Orcamento nao cadastrado...",{"&Ok"})
		lRet:=.f.
	Endif
               
   IF !(SCJ->CJ_STATUS $ "A|D")
		Aviso("ATENCAO", "Somente e permitido envio de Email de Orcamentos em Aberto.",{"&Ok"})
		lRet:=.f.
	Endif

Endif

if EmptY(_cPara)
	Aviso("ATENCAO", "Favor informar o E-mail do destinatario...",{"&Ok"})
	lRet:=.f.
Else
	If AT(",",_cPara) <> 0
		Aviso("ATENCAO", "Probido o uso de ',' virgula para separar as contas use somente ';'...",{"&Ok"})
		lRet:=.f.
	Endif
Endif

//SA1->(DbSetOrder(1),DbSeek(xFilial("SA1")+SCJ->(CJ_CLIENTE+CJ_LOJA),.T.))
//_cPara:=SA1->A1_X_EMAIL

Return(lRet)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ Parse      ≥ autor ≥                     ≥ Data ≥ 23/06/06 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Tratamento utilizado para separar os Email para envio      ¥±±
±±≥          ≥ personalizado.                                             ¥±±
±±≥ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≥±±
±±≥Parametro ≥                                                            ¥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function ParseSep(_uString)
Local nPos
Local cExecuta := ""

iF  AT(";",_uString) = 0
	cExecuta := _uString ///	substr(alltrim(_uString),1,2)
	_uString := ""
Else
	iF  AT(";",_uString) > 0
		nPos := AT(";",_uString)
		If  nPos > 0
			cExecuta := SubStr(_uString,1,nPos-1)
			_uString := If(Len(_uString)>nPos,SubStr(_uString,nPos+1,Len(_uString)-nPos),"")
		EndIf
	Else
		cExecuta := _uString
		_uString := ""
	Endif
Endif
Return(cExecuta)


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa  ≥ FuncUser ≥ Autora≥   Marcia S. S. Tokura ≥ Data ≥ 27/10/99 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Rotina para verificar os grupos a que o usu†rio pertence   ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso       ≥ VERS«O 2.07/4.07                                           ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

/*				
PswOrder(nOrder): seta a ordem de pesquisa
nOrder -> 1: ID;
               2: nome;
               3: senha;
               4: e-mail 
 
PswSeek(cSeek,lUser): faz pesquisa (retorna .T./.F. se achar)
cSeek -> string a ser procurada.
lUser -> .T.: pesquisa usu·rios (padr„o);
            .F.: pesquisa grupos.
 
PswRet(nReg): retorna vetor com informaÁıes do usu·rio/grupo
nReg -> n˙mero do registro conforme planilha anexada;
             NIL: todos os registros
                1: 1∫ registro
                2: 2∫ registro
                3: 3∫ registro

// Abaixo posicoes do Vetor


Vetor com configuraÁıes do administrador				
	Elemento		Tipo	Tamanho
1	senha mestra		C	6
2	numero de erros		N	1
3	numero de senhas a guardar		N	2
4	uso do nome para verificaÁ„o da senha		L	1
5	tamanho da senha		N	1
6	bloqueio		L	1
				
Vetor com configuraÁıes dos grupos				
1				
	1	ID	C	6
	2	nome	C	20
	3	vetor com hor·rios de acesso	A	
	4	data de validade	D	8
	5	quantas vezes para expirar	N	4
	6	autorizado a alterar a senha	L	1
	7	idioma	N	1
	8	diretÛrio	C	100
	9	impressora	C	
	10	acessos	C	512
	11	vetor com empresas	A	
	12	data da ˙ltima alteraÁ„o	D	8
	13	tipo de impress„o	N	1
	14	formato	N	1
	15	ambiente	N	1
	16	opÁ„o de impress„o	C	
2				
	modulo+nÌvel+menu		C	
				
Vetor com configuraÁıes dos usu·rios				
1				
	1	ID	C	6
	2	nome	C	15
	3	senha	C	6
	4	nome completo	C	30
	5	vetor com n ˙ltimas senhas	A	
	6	data de validade	D	8
	7	quantas vezes para expirar	N	4
	8	autorizado a alterar a senha	L	1
	9	alterar senha no prÛximo logon	L	1
	10	vetor com os grupos	A	
	11	ID do superior	C	6
	12	departamento	C	30
	13	cargo	C	30
	14	e-mail	C	30
	15	n˙mero de acessos simult‚neos	N	4
	16	data da ˙ltima alteraÁ„o	D	8
	17	usu·rio bloqueado	L	1
	18	numero de digitos para o ano	N	1
2				
	1	vetor com hor·rios de acesso	A	
	2	idioma	N	1
	3	diretÛrio	C	100
	4	impressora	C	
	5	acessos	C	512
	6	vetor com empresas	A	
	7	ponto de entrada	C	10
	8	tipo de impress„o	N	1
	9	formato	N	1
	10	ambiente	N	1
	11	prioridade p/ config. do grupo	L	1
	12	opÁ„o de impress„o	C	
3				
	modulo+nÌvel+menu		C	


*/
User Function FuncUser()
//Local _daduser:=_grupo:={}
//Local _nomeuser:=substr(cusuario,7,15)
Local _nomeuser:=substr(cusuario,7,15)

//__cUserId  Vari·vel Publica com o ID do Usu·rio Logado
_nomeuser := Alltrim(UsrRetName(__cUserId))

psworder(2)

if pswseek(_nomeuser,.t.)
        _daduser:=pswret(1)
        //
        // Caso necessite informaoes do Grupo
        //
        //_grupo:=Array(len(_daduser[1,10]))
        // psworder(1)
        //for i:=1 to len(_daduser[1,10])
        //    if pswseek(_daduser[1,10,i],.f.)
        //       _grupo[i]:=pswret(NIL) 
        //       //alert(_grupo[i,1,1])
        //      //alert(_grupo[i,1,2])
        //    endif
        //next
endif

return( alltrim(_daduser[1,14]) ) 




/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MontaUBC  ∫Autor  ≥Microsiga           ∫ Data ≥  23/03/06   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Monta o Html da UBC ser enviado no Email                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
//#000080  - Azul Forte
//#F3F3F3  - Cinza Claro
//#f51d0a  - Vermelho
//#000000  - Preto 
//#ffffff  - Branco
//#E6E6E6  - Cinza Claro
*/
Static Function HtmlUBC(cTo)

Local nInd    := 0          
Local nLenSCK := LEN(aViewSCK)

cHtml :="" 
cHtml += '<html>' //+ CRLF
cHtml += '<head>' //+ CRLF


cHtml += '<style type="text/css">'
cHtml += '<!--                    '
cHtml += '.style2 {color: #F3F3F3} '
cHtml += 'body {                    '
cHtml += '	margin-left: 10px;       '
cHtml += '	margin-top: 0px;          '
cHtml += '	margin-right: 10px;        '
cHtml += '	margin-bottom: 10px;        '
cHtml += '}                             '
cHtml += '-->                            '
cHtml += '.style4 {color: #000000}'


cHtml += '</style>                        '
cHtml += '<table border="0" width="100%">  '
cHtml += '<tr>                              '
cHtml += '  <tr> 
cHtml += '    <td width="9%" height="72" align="left" valign="middle"><h3><img src="https://ubc-rolamentosdobrasil.com.br/logo" width="70" height="70" hspace="0" vspace="0" border="1"></h3></td>'
cHtml += '    <td width="69%" align="left"><h5 class="style3">'+SM0->M0_NOMECOM+'<br>                                                                                                               '
cHtml += '     '+SM0->M0_ENDCOB
cHtml += '     CEP: '+TRANSFORM(alltrim(SM0->M0_CEPCOB),"@R 99999-999")+' - '+SM0->M0_CIDCOB+' - '+SM0->M0_ESTCOB+'<br>'
cHtml += '     Tel. '+SM0->M0_TEL   +'Fax: '+SM0->M0_FAX+'<br>                                                                                                                                    '
cHtml += '     CNPJ : '+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99") + ' IE:'+TRANSFORM(alltrim(SM0->M0_INSC),"@R 999.999.999.999")+'</h5>                                                                                                  '
cHtml += '    </td> '
cHtml += '    <td width="22%"><div align="center"><a href="https://ubc-rolamentosdobrasil.com.br">Acesse o nosso site</a></div></td>'
cHtml += '  </tr><h4>&nbsp;</h4>'
cHtml += '</table>'

//
//  orcamento
//
//cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#f51d0a">'
//cHtml += '<tr valign="top"> '
//cHtml += '<td bgcolor="#f51d0a"><div align="center"><strong> '
//cHtml += '<b><font color="#ffffff">Orcamento</font></b></td>
//cHtml += '<b></b>'
//cHtml += '</strong></div></td>'
//cHtml += '</tr>'
//cHtml += '</table>'

cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#f51d0a">'
cHtml += '<tr valign="top"> '
cHtml += '<td bgcolor="#f51d0a"><div align="center"><strong> '
cHtml += 'Orcamento'
cHtml += '<b></b>'
cHtml += '</strong></div></td>'
cHtml += '</tr>'
cHtml += '</table>'


cHtml += '<table border="0" width="100%" bgcolor="#E6E6E6">                                                                                                                                                '
cHtml += '<tr>                                                                                                                                                                                              '
cHtml += '<td width="100%" colspan="3">                                                                                                                                                                      '
cHtml += '<table width="100%" border="0" bordercolor="#000000"><!--DWLayoutTable-->                                                                                                                           '
cHtml += '<tr>                                                

//cHtml += '<td width="20%"><b><font color="#000000">N do Orcamento</font></b></td>                                                                                                                               '
//cHtml += '<table border="0" width="100%" bgcolor="#E6E6E6">                                                                                                                                                '
//cHtml += '<tr>                                                                                                                                                                                              '
//cHtml += '<td width="100%" colspan="3">                                                                                                                                                                      '
//cHtml += '<table width="100%" border="0" bordercolor="#000000"><!--DWLayoutTable-->                                                                                                                           '
//cHtml += '<tr>                                                
                                                                                                                                                 '
cHtml += '<td width="20%"><b><font color="#000000">N do Orcamento</font></b></td>                                                                                                                               '
cHtml += '<td width="30%">'+SCJ->CJ_NUM+'  REAL </td> '
cHtml += '<td width="20%"><b><font color="#000000">Data do Orcamento</font></b></td>                                                                                                                              '
cHtml += '<td width="30%">'+DTOC(SCJ->CJ_EMISSAO)+'</td>                                                                                                                                                         '
cHtml += '</tr>                                                                                                                                                                                                   '
cHtml += '<tr>                                                                                                                                                                                                     '
cHtml += '<td width="20%"><b><font color="#000000">Cliente</font></b></td>                                                                                                                                          '
cHtml += '<td width="30%">'+SA1->A1_COD+'/'+SA1->A1_LOJA+' -  '+SA1->A1_NREDUZ+'</td>                                                                                                                                                   '
cHtml += '<td width="20%"><b><font color="#000000">CNPJ/CPF</font></b></td>                                                                                                                                           '
cHtml += '<td width="30%">'+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")+'</td>                                                                                                                                     '
cHtml += '</tr>'	 
cHtml += '<tr>'		 
cHtml += '<td width="20%"><b><font color="#000000">Telefone</font></b></td>                                                                                                                                              '
cHtml += '<td width="30%">'+  SA1->A1_TEL +'</td>                                                                                                                                                                        '
cHtml += '<td width="20%"><b><font color="#000000">Contato</font></b></td>                                                                                                                                                '
cHtml += '<td width="30%">'+_cContato+'</td>                                                                                                                                                                        '
cHtml += '</tr>                                                                                                                                                                                                            '
cHtml += '<tr>                                                                                                                                                                                                              '
cHtml += '<td width="20%" height="31"><b><font color="#000000">E-Mail</font></b></td>                                                                                                                                        '
cHtml += '<td width="30%">'+cTo+'</td>                                                                                                                                                                             '
cHtml += '<td width="20%" height="27"><b><font color="#000000">I.E: </font></b></td>                                                                                                                                          '
cHtml += '<td width="30%">'+SA1->A1_INSCR+'</td>                                                                                                                                                                              '
cHtml += '</tr>                                                                                                                                                                                                                '
cHtml += '<tr>                                                                                                                                                                                                                  '
cHtml += '<td width="20%" height="27"><b><font color="#000000">Municipio</font></b></td>                                                                                                                                         '
cHtml += '<td width="30%">'+SA1->A1_MUN+'</td>                                                                                                                                                                                   '
cHtml += '<td width="20%"><b><font color="#000000">Fax </font></b></td>                                                                                                                                                           '
cHtml += '<td width="30%"><p>'+SA1->A1_FAX+'</p>  </td>                                                                                                                                                                           '
cHtml += '</tr>                                                                                                                                                                                                                    '
cHtml += '<tr>                                                                                                                                                                                                                      '
cHtml += '<td width="20%"><p><br>                                                                           '
cHtml += '  <b><font color="#000000">Vendedor</font></b></p>  </td>                                         '
cHtml += '<td width="30%"><p><br>                                                                            '
cHtml += SA3->A3_COD+' -  '+SA3->A3_NOME+'</p>  </td>'  
cHtml += '<td width="20%"><b><font color="#000000"><br>                                                      '
cHtml += '  E-mail Vendedor</font></b></td>                                                                   '

_cEmail:='vendas@ubc-rolamentosdobrasil.com.br'

cHtml += '<td width="30%"><p>'+_cEmail+'</p>  </td>                                                                                                                                                                           '

//cHtml += '<td width="30%"><p><br>                                                                              '
//cHtml += '  '+/*SA3->A3_EMAIL*/+'</p>  </td>' 
cHtml += '</tr>                                                                                                 '
cHtml += '<tr>                                                                                                   '
cHtml += '<tr bordercolor="#0000FF">                                                                              '
cHtml += '<td width="20%" height="49" bordercolor="#FF0000"><p><b><font color="#000000"><br>                       '
cHtml += '        <br>                                                                                              '
cHtml += '        Cond. de Pagamento</font></b></p>                                                                  '
cHtml += '  </td>                                                                                                     '
cHtml += '<td width="30%"><p>&nbsp;</p>                                                                                '
cHtml += '  <p>'+SE4->E4_CODIGO+' - '+SE4->E4_DESCRI+'</p></td>                                                        '
cHtml += '<td width="20%"><p>&nbsp;</p>                                                                                  '
cHtml += '  <p><b><font color="#000000">Tipo de Frete</font></b></p></td>                                                       '
cHtml += '<td width="30%"><p>&nbsp;</p>                                                                                    '
cHtml += '  <p>'+IF(SCJ->CJ_X_TPFRT="C","CIF","FOB")+'</p></td>                                                                           '
cHtml += '</tr>                                                                                                             '
cHtml += '</table>'

//
// Observacao
//
cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6">' //333333
cHtml += '<tr valign="top"> '
cHtml += '<td bgcolor="#E6E6E6"><div align="center"><strong> '
cHtml += 'Observacao'
cHtml += '<b></b>'
cHtml += '</strong></div></td>'
cHtml += '</tr>'
cHtml += '</table>'


If !Empty(SCJ->CJ_X_COTCL)
	cHtml += '<table width="100%"  border="0" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
	cHtml += '<tr valign="top">'
	cHtml += '<td><p><br>'
	cHtml += '    <p><strong>Cotacao do Cliente Numero:  '+SCJ->CJ_X_COTCL       ///SCJ->CJ_X_COTCLI
	cHtml += '    <br>'
	cHtml += '    <br>'
	cHtml += '  </strong></p>'
	cHtml += '  </td>  '
	cHtml += '</tr>    '
	cHtml += '</table>'
Endif

cHtml += '<table width="100%"  border="0" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
cHtml += '<tr valign="top">'
cHtml += '<td><p><br>'
cHtml += '    <p><strong>'+cObserv
cHtml += '    <br>'
cHtml += '    <br>'
cHtml += '  </strong></p>'
cHtml += '  </td>  '
cHtml += '</tr>    '
cHtml += '</table>'

//
// Itens
//
cHtml += '<table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#E6E6E6">'
cHtml += '<tr valign="top"> '
cHtml += '<td bgcolor="#E6E6E6">
	
cHtml += '<tr>                                                                                                                                        '
cHtml += '<td width="3%" bgcolor="#E6E6E6"><div align="center"><span class="style4"><b>Item</b></span></div></td>
cHtml += '<td width="20%" bgcolor="#E6E6E6" class="style2"><div align="center"><span class="style4"><b>Descricao</b></span></div></td>
cHtml += '<td width="20%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Codigo Cliente</b></div></td>
cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Un</b></div></td>
cHtml += '<td width="10%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Qtde</b></div></td>
cHtml += '<td width="14%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Vl Unitario</b></div></td>
cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>% IPI</b></div></td>
cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>% ICMS</b></div></td>
cHtml += '<td width="5%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Prazo de Entrega</b></div></td>
cHtml += '<td width="6%" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Class. Fiscal</b></div></td>
cHtml += '<td width="20" bgcolor="#E6E6E6" class="style2"><div align="center" class="style4"><b>Observacao</b></div></td>

For nInd := 1 to nLenSCK 
	cHtml += '<tr>  '
	cHtml += '<td width="03%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][1] + '</div></td> ' 
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][2] + '</td>'
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][3] + '</td> '
	cHtml += '<td width="05%" bgcolor="#E6E6E6">' + aViewSCK[nInd][4] + '</td>  '                                                                                        
	cHtml += '<td width="10%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[nInd][5] + '</div></td>'
	cHtml += '<td width="14%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[nInd][6] + '</div></td> ' //valor unitario
	cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][7] + '</div></td> '
	cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + strzero(aViewSCK[nInd][12],2) + '</div></td> '
	cHtml += '<td width="5%" bgcolor="#E6E6E6">' + aViewSCK[nInd][8] + '</td> '   
	cHtml += '<td width="6%" bgcolor="#E6E6E6"><div align="center">' + aViewSCK[nInd][9] + '</div></td>'
	cHtml += '<td width="20%" bgcolor="#E6E6E6">' + aViewSCK[nInd][10] + '</td>'
	cHtml += '</tr>    '                               
	_nIndUlt := nInd //alterado NASSER 24/08/07
Next                                                                                                                                                                      

//
// Total
//
cHtml += '<tr>  '
cHtml += '<td width="03%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td> ' 
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + '.' + '</td>'
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + 'TOTAL SEM IPI' + '</td> '
cHtml += '<td width="05%" bgcolor="#E6E6E6">' + '.' + '</td>  '                                                                                        
cHtml += '<td width="10%" bgcolor="#E6E6E6"><div align="right">' + '.' + '</div></td>'
cHtml += '<td width="14%" bgcolor="#E6E6E6"><div align="right">' + aViewSCK[_nIndUlt][11] + '</div></td> ' //valor unitario
cHtml += '<td width="5%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td> '
cHtml += '<td width="5%" bgcolor="#E6E6E6">' + '.' + '</td> '   
cHtml += '<td width="5%" bgcolor="#E6E6E6">' + '.' + '</td> '   
cHtml += '<td width="6%" bgcolor="#E6E6E6"><div align="center">' + '.' + '</div></td>'
cHtml += '<td width="20%" bgcolor="#E6E6E6">' + '.' + '</td>'
cHtml += '</tr>    '                               


cHtml += '</table>                                                                                                                                                          '
cHtml += '<table width="100%"  border="0" cellpadding="0" cellspacing="0" bordercolor="#333333">'
cHtml += '<tr valign="top">'
cHtml += '<td width="0" height="0" bordercolor="#000000"><p align="left" class="style8"><br>'
cHtml += '<b></b>'
cHtml += '</strong></div></td>'
cHtml += '</tr>'
cHtml += '</table>'

// Observacao
//       
cHtml += '<table width="100%"  border="1" cellpadding="1" cellspacing="0" bordercolor="#E6E6E6" bgcolor="#E6E6E6">'
cHtml += '<tr valign="top">'
cHtml += '<td width="0" height="0" bordercolor="#000000"><p align="left" class="style8"><br>'
cHtml += '    <strong>Condicoes Gerais do Orcamento: </strong></p>'
cHtml += '    <p align="left" class="style8"><strong>'
cHtml += '    a) Faturamento parcial Permitido.<br>'
cHtml += '    b) Nao ha precos fixos e Irreajustaveis para qualquer produto Importado ou Nacional.<br>'
cHtml += '    c) Os Prazos passarao a ter validade a partir da confirmacao formal do Pedido.<br>'
cHtml += '    d) Todos os produtos desse orcamento estao sujeitos a venda previa.<br>'
cHtml += '    e) Validade do Orcamento : '+GETMV("MV_DTPROPO")+'.<br>' 
cHtml += '    f) Produto destinado para uso ou aplicacao exclusivamente industrial.<br>'
cHtml += '    g) Os Precos serao reajustados ate a data do faturamento efetiva conforme variacao Cambial e ou Tabela do Fabricante.<br>'
cHtml += '       Dolar Base = Us$ '+ Transform(SM2->M2_MOEDA2,"@E 9,999.99")  +' de '+ dtoc(SM2->M2_DATA)+' <br>'
cHtml += '    <br>'
cHtml += '  </strong></p>'
cHtml += '  </td>'
cHtml += '</tr>'
cHtml += '</table>'
cHtml += '<p align="left"></p>'

return(cHtml)
