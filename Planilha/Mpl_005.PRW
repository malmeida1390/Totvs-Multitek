#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_005  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 18/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que verifica a inclusao, alteracao e exclusao do     ³±±
±±³          ³ Cadastro de EIS                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MPL_005(cOperacao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Public oDlg,oEIS01,oEIS02,oEIS03,oEIS04,oEIS05,oEIS06,oEIS07,oEIS08,oEIS09,oEIS10
Public oDesc01,oDesc02,oDesc03,oDesc04,oDesc05,oDesc06,oDesc07,oDesc08,oDesc09,oDesc10

DbSelectArea("Z10") // Escolhendo a area do browser utiliado na rotina que chamou este programa

If BOF() .or. EOF() .OR.  cOperacao  = "I"

	Public _cEIS01 := Space(2)
	Public _cEIS02 := Space(2)
	Public _cEIS03 := Space(2)
	Public _cEIS04 := Space(2)
	Public _cEIS05 := Space(2)
	Public _cEIS06 := Space(2)
	Public _cEIS07 := Space(2)
	Public _cEIS08 := Space(2)
	Public _cEIS09 := Space(2)
	Public _cEIS10 := Space(2)
	
	Public _cDesc01 := Space(60)
	Public _cDesc02 := Space(60)
	Public _cDesc03 := Space(60)
	Public _cDesc04 := Space(60)
	Public _cDesc05 := Space(60)
	Public _cDesc06 := Space(60)
	Public _cDesc07 := Space(60)
	Public _cDesc08 := Space(60)
	Public _cDesc09 := Space(60)
	Public _cDesc10 := Space(60)

Else

	Public _cEIS01 := Z10->Z10_COD01
	Public _cEIS02 := Z10->Z10_COD02
	Public _cEIS03 := Z10->Z10_COD03
	Public _cEIS04 := Z10->Z10_COD04
	Public _cEIS05 := Z10->Z10_COD05
	Public _cEIS06 := Z10->Z10_COD06
	Public _cEIS07 := Z10->Z10_COD07
	Public _cEIS08 := Z10->Z10_COD08
	Public _cEIS09 := Z10->Z10_COD09
	Public _cEIS10 := Z10->Z10_COD10
	
	// Efetuando Seek em cada Nivel para obter a descricao apropriada para consulta
	
	DbSelectArea("Z01")
	DbSeek(xFilial("Z01")+_cEIS01)
	Public _cDesc01 := Z01->Z01_DESC01

	DbSelectArea("Z02")
	DbSeek(xFilial("Z02")+_cEIS01+_cEIS02)
	Public _cDesc02 := Z02->Z02_DESC02

	DbSelectArea("Z03")
	DbSeek(xFilial("Z03")+_cEIS01+_cEIS02+_cEIS03)
	Public _cDesc03 := Z03->Z03_DESC03

	DbSelectArea("Z04")
	DbSeek(xFilial("Z04")+_cEIS01+_cEIS02+_cEIS03+_cEIS04)
	Public _cDesc04 := Z04->Z04_DESC04

	DbSelectArea("Z05")
	DbSeek(xFilial("Z05")+_cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05)
	Public _cDesc05 := Z05->Z05_DESC05

	DbSelectArea("Z06")
	DbSeek(xFilial("Z06")+_cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06)
	Public _cDesc06 := Z06->Z06_DESC06

	DbSelectArea("Z07")
	DbSeek(xFilial("Z07")+_cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07)
	Public _cDesc07 := Z07->Z07_DESC07

	DbSelectArea("Z08")
	DbSeek(xFilial("Z08")+_cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07+_cEIS08)
	Public _cDesc08 := Z08->Z08_DESC08

	DbSelectArea("Z09")
	DbSeek(xFilial("Z09")+_cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07+_cEIS08+_cEIS09)
	Public _cDesc09 := Z09->Z09_DESC09

	DbSelectArea("Z10") // Nao precisa de seek pois ja estou posicionado no arquivo (browser da tela anterior)
	Public _cDesc10 := Z10->Z10_DESC10
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 136,68 To 564,784 Dialog oDlg Title OemToAnsi("Manutencao do codigo EIS")

@ 005,120 Say OemToAnsi("M A N U T E N C A O     D O     C O D I G O     E I S") Size 130,8

@ 030,010 Say OemToAnsi("Codigo da Familia") Size 70,8
@ 045,010 Say OemToAnsi("Divisao da Familia") Size 70,8
@ 060,010 Say OemToAnsi("Tipo da Familia") Size 70,8
@ 075,010 Say OemToAnsi("Divisao Construtiva") Size 70,8
@ 090,010 Say OemToAnsi("1a. Caracteristica") Size 70,8
@ 105,010 Say OemToAnsi("2a. Caracteristica") Size 70,8
@ 120,010 Say OemToAnsi("3a. Caracteristica") Size 70,8
@ 135,010 Say OemToAnsi("4a. Caracteristica") Size 70,8
@ 150,010 Say OemToAnsi("5a. Caracteristica") Size 70,8
@ 165,010 Say OemToAnsi("6a. Caracteristica") Size 70,8

@ 030,075 Get _cEIS01 Size 17,10 When .F. oBject oEIS01
@ 045,075 Get _cEIS02 Size 17,10 When .F. oBject oEIS02
@ 060,075 Get _cEIS03 Size 17,10 When .F. oBject oEIS03
@ 075,075 Get _cEIS04 Size 17,10 When .F. oBject oEIS04
@ 090,075 Get _cEIS05 Size 17,10 When .F. oBject oEIS05
@ 105,075 Get _cEIS06 Size 17,10 When .F. oBject oEIS06
@ 120,075 Get _cEIS07 Size 17,10 When .F. oBject oEIS07
@ 135,075 Get _cEIS08 Size 17,10 When .F. oBject oEIS08
@ 150,075 Get _cEIS09 Size 17,10 When .F. oBject oEIS09
@ 165,075 Get _cEIS10 Size 17,10 When .F. oBject oEIS10

@ 030,100 Get _cDesc01 Size 201,10 When .F. oBject oDesc01
@ 045,100 Get _cDesc02 Size 201,10 When .F. oBject oDesc02
@ 060,100 Get _cDesc03 Size 201,10 When .F. oBject oDesc03
@ 075,100 Get _cDesc04 Size 201,10 When .F. oBject oDesc04
@ 090,100 Get _cDesc05 Size 201,10 When .F. oBject oDesc05
@ 105,100 Get _cDesc06 Size 201,10 When .F. oBject oDesc06
@ 120,100 Get _cDesc07 Size 201,10 When .F. oBject oDesc07
@ 135,100 Get _cDesc08 Size 201,10 When .F. oBject oDesc08
@ 150,100 Get _cDesc09 Size 201,10 When .F. oBject oDesc09
@ 165,100 Get _cDesc10 Size 201,10 When .F. oBject oDesc10

@ 029,310 BMPButton Type 11 Action U_MPL_006("1" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 044,310 BMPButton Type 11 Action U_MPL_006("2" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 059,310 BMPButton Type 11 Action U_MPL_006("3" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 074,310 BMPButton Type 11 Action U_MPL_006("4" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 089,310 BMPButton Type 11 Action U_MPL_006("5" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 104,310 BMPButton Type 11 Action U_MPL_006("6" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 119,310 BMPButton Type 11 Action U_MPL_006("7" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 134,310 BMPButton Type 11 Action U_MPL_006("8" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 149,310 BMPButton Type 11 Action U_MPL_006("9" ,_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)
@ 164,310 BMPButton Type 11 Action U_MPL_006("10",_cEIS01,_cEIS02,_cEIS03,_cEIS04,_cEIS05,_cEIS06,_cEIS07,_cEIS08,_cEIS09,_cEIS10)

@ 195, 280 BMPButton Type 11 Action  ( U_LmpGets() )
@ 195, 310 BMPButton Type 01 Action  ( Close(oDlg) )

Activate Dialog oDlg Centered

Return


/*
Static Function Gravar(cOperacao) 
Local nRecno := Z10->(RECNO())   
Local cEis   := _cEIS01+_cEIS02+_cEIS03+_cEIS04+_cEIS05+_cEIS06+_cEIS07+_cEIS08+_cEIS09+_cEIS10
Local lRet   := .T.     


If EmptY(_cEIS01) .or. EmptY(_cEIS02) .or. EmptY(_cEIS03) .or. Empty(_cEIS04).or. Empty(_cEIS05) .or.;
   EmptY(_cEIS06) .or. EmptY(_cEIS07) .or. EmptY(_cEIS08) .or. Empty(_cEIS09).or. Empty(_cEIS10)
   Aviso("ATENCAO", "Operacao nao pode continuar pois existe codigo EIS em branco... , verifique !",{"&Ok"})
   lRet := .f.

Else
	
	DbSelectArea("Z10")
	DbSetorder(1)
	
	if cOperacao = "A"      // Alteracao
		DbSelectArea("Z10")  // Nao precisa de seek pois ja estou posicionado no arquivo (browser da tela anterior)
		DbSetorder(1)
		If Dbseek(xFilial("Z10")+ cEis )
			If Z10->(RECNO()) <> nRecno
				Aviso("ATENCAO", "Operacao de Alteracao do codigo nao permitida pois o EIS ja se encontra cadastrado... , verifique !",{"&Ok"})
				lRet := .f.
			Endif
		Endif
		
		DbGoto(nRecno)
		
	Else
		DbSelectArea("Z10") // Nao precisa de seek pois ja estou posicionado no arquivo (browser da tela anterior)
		DbSetorder(1)
		If Dbseek(xFilial("Z10")+ cEis )
			Aviso( "ATENCAO" ,  "Operacao de Inclusao do codigo nao permitida pois o EIS ja se encontra cadastrado... , verifique !",{"&Ok"})
			lRet := .f.
		Endif
	Endif
	
Endif
   


if lRet
   if cOperacao = "A" 
      Reclock("Z10",.F.)
   Else
      Reclock("Z10",.T.)
   Endif
   Z10->Z10_FILIAL := xFilial("Z10")
   Z10->Z10_COD01  := _cEIS01
   Z10->Z10_COD02  := _cEIS02
   Z10->Z10_COD03  := _cEIS03
   Z10->Z10_COD04  := _cEIS04
   Z10->Z10_COD05  := _cEIS05
   Z10->Z10_COD06  := _cEIS06
   Z10->Z10_COD07  := _cEIS07
   Z10->Z10_COD08  := _cEIS08
   Z10->Z10_COD09  := _cEIS09
   Z10->Z10_COD10  := _cEIS10
   Z10->Z10_DESC10 := ""
   MsUnlock()
Endif                

DbGoto(nRecno)

Return(lRet)
*/

