#INCLUDE "Protheus.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsGrafMail³ Autor ³ Edson Maricate       ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta uma tela com solicitando os emails dos usuarios.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSC100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                

//
// A Customizacao desta funcao se deu necessaria em funcao do email de origem 
// ser do usuario nao um Emails foi necessario o uso da funcao  
//
// LOGO TODA A CUSTOMIZACAO E EM FUNCAO DA ALTERACAO DESTA LINHA
//
// Local cMailConta	:=GETMV("MV_EMCONTA")
//       para
// Local cMailConta	:=&(GETMV("MV_EMCONTA")) // dentro temos U_FUNCUSER() que trara
//                                               o nome do usuario que esta enviando o 
//                                               arquivo.                                                                                 

User Function PmsGrafMail(oGraphic,cAssunto,aTexto,aTabela,nEspacos)

Local cTO	:= SPACE(200)
Local cCC	:= SPACE(200)
Local oDlg  

DEFINE MSDIALOG oDlg FROM 102 ,43  TO 260,611 TITLE "Enviar Grafico por e-Mail" Of oMainWnd PIXEL //"Enviar Grafico por e-Mail"
	@ 0, 0 BITMAP oBmp RESNAME "TOOLBAR" oF oDlg SIZE 600,20  NOBORDER WHEN .F. PIXEL
	@ 21 ,4   SAY "Para :"   Of oDlg PIXEL SIZE 27 ,9 //"Para :"
	@ 37 ,4   SAY "Cco :"    Of oDlg PIXEL SIZE 23 ,9 //"Cco :"
	@ 54 ,4   SAY "Assunto:" Of oDlg PIXEL SIZE 23 ,9 //"Assunto:"
	@ 19 ,27  MSGET cTO Picture "@" OF oDlg PIXEL SIZE 250,9
	@ 36 ,27  MSGET cCC Picture "@" OF oDlg PIXEL SIZE 250,9
	@ 53 ,27  MSGET cAssunto Picture "@" OF oDlg PIXEL SIZE 250,9	
   @ 2  ,4   BUTTON "Enviar" SIZE 35 ,11  FONT oDlg:oFont ACTION (If(U_PmsEnvGraf(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos),oDlg:End(),))  OF oDlg PIXEL //"Enviar"

ACTIVATE MSDIALOG oDlg


Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsEnvGraf³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de envio do grafico por email.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSC100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PmsEnvGraf(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)
Local lRet

Processa({||lRet := U_PmsEnv(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)},"Enviando e-mail. Aguarde...") //"Enviando e-mail. Aguarde..."

Return lRet






/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PmsEnv    ³ Autor ³ Edson Maricate        ³ Data ³ 09-02-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de envio do grafico por email.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³PMSC100                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PmsEnv(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

Local cMailConta	:=&(GETMV("MV_EMCONTA"))
Local cMailServer	:=GETMV("MV_RELSERV")
Local cMailSenha	:=GETMV("MV_EMSENHA")
Local lOk			:= .F.
Local cMensagem
Local nx			:= 0
Local lBmp := !( oGraphic == NIL )
Local cBmpName, nWidth := 0
Local cError

DEFAULT aTexto  	:= {}
Default aTabela 	:= {}
Default nEspacos  := 10

If lBmp
	cBmpName := CriaTrab(,.F.)+".BMP"
Endif
   
cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
cMensagem += '<HTML><HEAD>'
cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
cMensagem += 'vLink=#551a8b><B>'

cMensagem += "<br>" + "Enviado por " + UsrFullName(RetCodUsr()) + "</br>" 
cMensagem += '<BR>&nbsp;</BR>'
cMensagem += "<CENTER>"
   

For nx := 1 To Len(aTexto)
	cMensagem += aTexto[nx]
Next
	
nX:= Len(aTexto)
If (nX > 0) .And. (Len(aTabela) > 0)
	For x := 1 to Len(aTabela[nX])
		nWidth += Len(aTabela[nX,x]) + nEspacos
	Next
EndIf

If Len(aTabela) > 1
	cMensagem += '<table border="0" width="' + Str(nWidth, 3) + '%"><tr>'
	For x := 1 to Len(aTabela[nx])
		cMensagem += '<td width="'+ Str(100 / Len(aTabela[nx]),3 ) + '%" bgcolor="#CEE7F7">'
		cMensagem += '<b><h><CENTER>' + aTabela[1,x] + '</CENTER></h></b> </td>'
	Next
	cMensagem += '</tr></table>'
EndIf

For nx := 2 to Len(aTabela)
	cMensagem += '<table border="0" width="' + Str(nWidth, 3) + '%"><tr>'
	
	For x := 1 to Len(aTabela[nx])
		cMensagem += '<td width="'+ Str(100 / Len(aTabela[nx]),3 ) + '%" bgcolor="' + If( Mod(nx,2)==0, '#CEE7F7','#FFFFFF') +  '" >'
		cMensagem += If(x == 1,"<CENTER>",'<p align="right">')+'<h>' + aTabela[nx,x] + '</h>'+If(x == 1,"</CENTER>","")+' </td>'
	Next
	cMensagem += '</tr></table>'
Next
cMensagem += '</B>'
cMensagem += '<BR>&nbsp;</BR>'
If lBmp
	cMensagem += '<p><IMG src="' + cBmpName + '"></p>'
EndIf
cMensagem += "</CENTER>"
cMensagem += '</body>'

ProcRegua(8)
If lBmp
	oGraphic:SaveToBMP( cBmpName, "\" )
EndIf

IncProc()
IncProc("Conectando servidor...") 

// Envia e-mail com os dados necessarios
If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
// Conecta uma vez com o servidor de e-mails
	If !lOk
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		IncProc()		
		IncProc()
      IncProc("Enviando e-mail...")  
	EndIf
	If lOk
		If lBmp
			SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  ATTACHMENT "\" + cBmpName RESULT lSendOk
		Else
			SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  RESULT lSendOk
		EndIf
		IncProc()		
		IncProc()
                IncProc("Desconectando...")   
		If !lSendOk
		//Erro no Envio do e-mail
			GET MAIL ERROR cError
                        Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)   
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
                Aviso("Erro no envio do e-Mail",cError,{"Fechar"},2)   
	EndIf
EndIf
If lOk
	DISCONNECT SMTP SERVER
	IncProc()	
	IncProc()	
	IncProc()		
EndIf

If lBmp .and. File("\" + cBmpName) 
	Ferase("\" + cBmpName)
EndIf

Return lOk
