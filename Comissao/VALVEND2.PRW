#INCLUDE "MATA530.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VALVEND2 ³ Autor ³                       ³ Data ³ 03/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campos de Vendedor.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VALVEND2(cVendedor,cCampo)
Local lRet:=.T.


If cCampo = 'A1_VEND'
	If !Empty(cVendedor)
 		If !(cVendedor $ '001001/001002')
			lRet:=.F.
		Endif     
	Endif
ElseIf cCampo = 'A1_X_VEND2'
	If !Empty(cVendedor)
		if !(cVendedor >= '003000' .AND. cVendedor<= '004999')
			lRet:=.F.
		Endif
	Endif
ElseIf cCampo = 'A1_X_VEND3'
	If !Empty(cVendedor)
		if !(cVendedor >= '005000' .AND. cVendedor<= '005999')
			lRet:=.F.
		Endif
	Endif
ElseIf cCampo = 'A1_X_VEND4'
	If !Empty(cVendedor)
		if !(cVendedor >= '006000' .AND. cVendedor<= '006999')
			lRet:=.F.
		Endif
	Endif
ElseIf cCampo = 'A1_X_VEND5'  // Tem que ser branco esta Bloqueado.
	//if !Empty(cVendedor)
	//lRet:=.F.
	//Endif
Endif

If !lRet
	Aviso("ATENCAO", "Nao e permitido a utilizacao deste vendedor neste campo.",{"&Ok"})
Else
	If  !Empty(cVendedor)
		DbSelectArea("SA3")
		DbSetorder(1)
		If !DbSeek(xFilial("SA3")+cVendedor)
			Aviso("ATENCAO", "Vendedor Informado nao Cadastrado.",{"&Ok"})
			lRet:=.F.
		Endif
	Endif
Endif


Return(lRet)
