#include "rwmake.ch"

User Function MPL_007(_cOpcao,_cChvEIS,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_007  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 17/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que ira efetuar a INCLUSAO, ALTERACAO OU EXCLUSAO nos³±±
±±³          ³ niveis do EIS                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Nome do Arquivo Conforme Campo a ser visualizado
_cArea		:= "Z"+Strzero(Val(_cNivel),2)
_cAreaSup	:= "Z"+Strzero(Val(_cNivel)+1,2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("MTZX")

If _cOpcao <> "1" .and. !EOF()
	_cC1 	:= "MTZX->Z"+Strzero(Val(_cNivel),2)+"_COD"+Strzero(Val(_cNivel),2)
	_cC2 	:= "MTZX->Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2)
	_cEIS := &_cC1
	_cDes := &_cC2
	_cTitulo := If(_cOpcao=="2","ALTERACAO","DELECAO")
Else
	_cEIS := Space(02)
	_cDes := Space(60)
	_cTitulo := "INCLUSAO"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 122,039 To 194,526 Dialog oDlg03 Title OemToAnsi(_cTitulo)
@ 015,005 Say OemToAnsi("Codigo:") Size 25,8
@ 015,050 Say OemToAnsi("Descricao:") Size 25,8
If _cOpcao == "1"
	@ 015,025 Get _cEIS Picture "99" Size 020,10
	@ 015,080 Get _cDes Picture "@!" Size 130,10
ElseIf _cOpcao == "2"
	@ 015,025 Get _cEIS Picture "99" Size 020,10 When .F.
	@ 015,080 Get _cDes Picture "@!" Size 130,10
ElseIf _cOpcao == "3"
	@ 015,025 Get _cEIS Picture "99" Size 020,10 When .F.
	@ 015,080 Get _cDes Picture "@!" Size 130,10 When .F.
EndIf
If _cOpcao <> "3"
	@ 015,215 Button OemToAnsi("_OK") Size 20,10 Action MPL_007_1(_cArea,_cAreaSup,_cOpcao,_aZXEstrut,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
Else
	@ 015,215 Button OemToAnsi("_Del") Size 20,10 Action MPL_007_1(_cArea,_cAreaSup,_cOpcao,_aZXEstrut,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
EndIf

Activate Dialog oDlg03 Centered

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_007_1³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 17/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina AUXILIAR chamada pelo botao OK, a qual efetuara a atu³±±
±±³          ³ alizacao das tabelas necessarias.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MPL_007_1(_cArea,_cAreaSup,_cOpcao,_aZXEstrut,_cNivel,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)

If _cOpcao == "1" // Inclusao
	
	If Empty(_cEIS) .or. Empty(_cDes)
		MsgBox("Nao devem existir campos vazios em uma inclusao, verifique !","ALERT")
		Return()
	EndIf
	If Len(Alltrim(_cEIS)) < 2
		MsgBox("O Codigo de cada nivel de EIS deve ser formado por 2 digitos, verifique !","ALERT")
		Return()
	EndIf
	// Verificando se o campo existe
	DbSelectArea(_cArea)
	DbSetOrder(1)
	
	If _cChvEIS <> "N"
		
		DbSeek(xFilial(_cArea)+_cChvEIS+_cEIS)
		
	Else
		
		DbSeek(xFilial(_cArea)+_cEIS)
		
	EndIf
	
	If Found()
		
		MsgBox("Este codigo JA EXISTE, verifique!","ALERT")
		Return()
		
	Else
		
		_aCmpGrv := {} // Array que contera os strings para a gravacao no loop abaixo, as strings sao completas para serem usadas como macro
		
		DbSelectArea(_cArea)
		
		For _i := 1 to Val(_cNivel)
			
			aadd(_aCmpGrv,{_cArea+"->"+_cArea+"_COD"+Strzero(_i,2),"_cEIS"+Strzero(_i,2)}) // Codigos do Nivel (qtd. varia conforme o nivel)
			
		Next
		
		aadd(_aCmpGrv,{_cArea+"->"+_cArea+"_DESC"+Strzero(Val(_cNivel),2),""}) // Descricao (so uma por nivel)
		
		RecLock(_cArea,.T.)
		
		For _j := 1 to Val(_cNivel)
			
			_cCampo1 := Alltrim(_aCmpGrv[_j,1])
			_cCampo2 := Alltrim(_aCmpGrv[_j,2])
			
			If Val(_cNivel) <> _j
				&_cCampo1 := &_cCampo2
			Else
				&_cCampo1 := _cEIS
			EndIf
			
		Next
		
		_cCampo1 := Alltrim(_aCmpGrv[_j,1])
		&_cCampo1 := _cDes
		
		MsUnlock()
		
		Close(oDlg03)
		
		//Gravando informacoes no Browser (Arquivo Temporario)
		DbSelectArea("MTZX")
		
		_cCm1 	:= "MTZX->Z"+Strzero(Val(_cNivel),2)+"_COD"+Strzero(Val(_cNivel),2)
		_cCm2 	:= "MTZX->Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2)
		
		RecLock("MTZX",.T.)
		&_cCm1 := _cEIS
		&_cCm2 := _cDes
		MsUnlock()
		
		// Refresh na Tela Anterior
		DlgRefresh(_oDlg02)
		
	EndIf
	
ElseIf _cOpcao == "2" // Alteracao
	
	If Empty(_cEIS) .and. Empty(_cDes)
		MsgBox("Nao existe registro para alterar, verifique !","ALERT")
		Close(oDlg03)
		Return()
	EndIf
	
	If Empty(_cDes)
		MsgBox("Voce NAO PODE deixar a descricao em branco, verifique !","ALERT")
		Close(oDlg03)
		Return()
	EndIf
	
	// Verificando se o campo existe
	DbSelectArea(_cArea)
	DbSetOrder(1)
	
	If _cChvEIS <> "N"
		
		DbSeek(xFilial(_cArea)+_cChvEIS+_cEIS)
		
	Else
		
		DbSeek(xFilial(_cArea)+_cEIS)
		
	EndIf
	
	If Found()
		
		DbSelectArea(_cArea)
		
		_cCmpDes 	:= _cArea+"->"+"Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2)
		
		RecLock(_cArea,.F.)
		&_cCmpDes := _cDes
		MsUnlock()
		
		Close(oDlg03)
		
		//Gravando informacoes no Browser (Arquivo Temporario)
		DbSelectArea("MTZX")
		
		_cCmp2 	:= "MTZX->Z"+Strzero(Val(_cNivel),2)+"_DESC"+Strzero(Val(_cNivel),2)
		
		RecLock("MTZX",.F.)
		&_cCmp2 := _cDes
		MsUnlock()
		
		// Refresh na Tela Anterior
		DlgRefresh(_oDlg02)
		
		
	EndIf
	
ElseIf _cOpcao == "3" // Exclusao
	
	// NESTA FUNCAO, EXCLUSAO, FAZEMOS UMA BUSCA NO NIVEL RESPECTIVAMENTE ACIMA ATE O CODIGO DO EIS O QUAL SE ESTA TENTANDO APAGAR,
	// CASO SEJA ENCONTRADO, AVISAMOS O USUARIO PARA ELIMINAR OS NIVEIS SUPERIORES ATE PODER ELIMINAR O ITEM ATUAL
	
	// O B S:  DEVEMOS LEMBRAR QUE DEVEREMOS COLOCAR AQUI NO FUTURO (ASSIM QUE EXISTIR BASE DE DADOS UTILIZANDO O CODIGO DO EIS,
	//  =====   UMA CONSISTENCIA PARA VERIFICAR SE EXISTE O EIS NA BASE DE DADOS ANTES DE APAGAR QUALQUER NIVEL !!!
	
	// D I C A:  PODEMOS VALIDAR SOMENTE ATRAVES DO SB1, POIS SE O EIS ESTIVER AMARRADO NO SB1, O RESTO O PROTHEUS FARA !!! VALIDANDO A EXCLUSAO DO PRODUTO .....
	
	If Empty(_cEIS) .and. Empty(_cDes)
		MsgBox("Nao existe registro para deletar, verifique !","ALERT")
		Close(oDlg03)
		Return()
	EndIf

	If _cNivel <> "10"
		
		// AQUI A AREA DEVE SER A RESPECTIVAMENTE ACIMA DA QUE ESTAMOS TRABALHANDO, POIS EH NESTE NIVEL QUE DEVEREMOS VER SE EXISTEM DADOS, IMPEDINDO ASSIM A DELECAO.
		
		DbSelectArea(_cAreaSup)
		DbSetOrder(1)
		
		If _cChvEIS <> "N"
			
			DbSeek(xFilial(_cAreaSup)+_cChvEIS+_cEIS)
			
		Else
			
			DbSeek(xFilial(_cAreaSup)+_cEIS)
			
		EndIf
		
		If Found()
			
			MsgBox("Impossivel DELETAR, existem informacoes referentes a este registro nos niveis superiores","ALERT")
			Close(oDlg03)
			Return()
			
		Else
			

		   If MsgYesNo("ATENCAO: Confirma delecao ?")
		      nOpc := 1        
		   Else
		      nOpc := 2
		   Endif

			If nOpc == 1
				
				DbSelectArea(_cArea)
				If _cChvEIS <> "N"
					
					DbSeek(xFilial(_cAreaSup)+_cChvEIS+_cEIS)
					
				Else
					
					DbSeek(xFilial(_cAreaSup)+_cEIS)
					
				EndIf
				
				If Found()
					
					RecLock(_cArea,.F.)
					DbDelete()
					MsUnlock()
					
					//MsgBox("Registro Deletado !","ALERT")
					
				EndIf
				
				Close(oDlg03)
				
				//Gravando informacoes no Browser (Arquivo Temporario)
				DbSelectArea("MTZX")
				
				RecLock("MTZX",.F.)
				DbDelete()
				MsUnlock()
				
				DbGoTop() // Posiciono no INICIO do arquivo temporario, pois o registro ATUAL deixou de existir e confunde o BROWSER.
				
				// Refresh na Tela Anterior
				DlgRefresh(_oDlg02)
				
			EndIf
			
			Close(oDlg03)
			
		EndIf 
		
	Else // Quando for o decimo nivel
		

        nOpc := 1        

	    DbSelectArea("SB1")           
	    DbOrderNickname("B1SIMIL")  // FILIAL + EIS 
	    	
		IF DbSeek(xFilial("SB1")+_cChvEIS+_cEIS )
			
   			Aviso("ATENCAO", "Eis nao pode ser deletado pois esta associado a produto.",{"&Ok"})
			
		Else

		   If MsgYesNo("ATENCAO: Confirma delecao ?")
		      nOpc := 1        
		   Else
		      nOpc := 2
		   Endif

		Endif
			
		
		If nOpc == 1
			
			DbSelectArea(_cArea)
			
			If DbSeek(xFilial(_cArea)+_cChvEIS+_cEIS)
			
				RecLock(_cArea,.F.)
				DbDelete()
				MsUnlock()
			
				Close(oDlg03)
			
				//Gravando informacoes no Browser (Arquivo Temporario)
				DbSelectArea("MTZX")
			
				RecLock("MTZX",.F.)
				DbDelete()
				MsUnlock()

				DbGoTop() // Posiciono no INICIO do arquivo temporario, pois o registro ATUAL deixou de existir e confunde o BROWSER.			
			
				// Refresh na Tela Anterior
				DlgRefresh(_oDlg02)
			
			EndIf
			
		EndIf
		
		Close(oDlg03)

	EndIf
	
EndIf

Return()
