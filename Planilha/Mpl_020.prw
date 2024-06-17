#include "rwmake.ch"

User Function MPL_020()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_020  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 24/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ TABELA DE FAIXAS DO GIRO DE ESTOQUES                        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBSERV:   ³ ESTE PROGRAMA DEPENDE DE PROGRAMA MPL_020_1, QUE IRA RODAR  ³±±
±±³          ³ GATILHOS PARA EFETUAR VALIDACOES NAS DIGITACOES DOS USUARIOS³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//+-----------------------------------------------+
//¦ Opcao de acesso para o Modelo 2               ¦
//+-----------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx:=3

//+-----------------------------------------------+
//¦ Montando aHeader                              ¦
//+-----------------------------------------------+

dbSelectArea("SX3")

dbSetOrder(1)
dbSeek("SZ1")

nUsado:=0

aHeader:={}

While !Eof() .And. (x3_arquivo == "SZ1")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo),Alltrim(x3_campo),;
		x3_picture,x3_tamanho,x3_decimal,,x3_usado,;
		x3_tipo, x3_arquivo, x3_context } )
		//           "ExecBlock('Md2valid',.f.,.f.)",x3_usado,;  // Perceba que passei o x3_usado para linha de cima e antes coloquei duas virgulas onde iria ter a validacao de cada campo digitado na getdados
	Endif
		
	dbSkip()

End 


// Pegamos aqui as Posicoes dos campos (Colunas) do array para uso futuro

Public _nCodigo		:= aScan(aHeader,{|x| x[2]=="Z1_CODIGO"})
Public _nDesc		:= aScan(aHeader,{|x| x[2]=="Z1_DESC"})
Public _nFini		:= aScan(aHeader,{|x| x[2]=="Z1_F_X_INI"})
Public _nFfim		:= aScan(aHeader,{|x| x[2]=="Z1_F_X_FIM"})

//+-----------------------------------------------+
//¦ Montando aCols                                ¦
//+-----------------------------------------------+

aCols := {}

Public aAltr := {} 	// Este vetor contera o mesmo numero de itens do aCols e em cada item contera o codigo chave para a pesquisa no arquivo
// Isto eh necessario, pois se o usuario estiver alterando o codigo e o mesmo ja estiver no arquivo eu NAO DEIXO e a partir dele retorno o codigo antigo

dbSelectArea("SZ1")
dbSetOrder(2) //Utilizamos AQUI a ordem 2 para que o ACOLS fique ordenado pela Faixa INICIAL  (Ver se em ORACLE funcionara este indice corretamente)
dbGoTop()

If !EOF()
	
	While !Eof() .And. xFilial("SZ1") == SZ1->Z1_FILIAL
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		AADD(aAltr,aCols[Len(aCols),_nCodigo])	// Abastecendo array auxiliar com ao codigo
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo
	
Else
	
	aCols:=Array(1,nUsado+1)
	aAltr:=Array(1)
		
	dbSelectArea("SX3")
	dbSeek("SZ1")
	
	nUsado:=0
	
	While !Eof() .And. (x3_arquivo == "SZ1")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado:=nUsado+1
			IF nOpcx == 3
				IF x3_tipo == "C"
					aCOLS[1][nUsado] := SPACE(x3_tamanho)
				Elseif x3_tipo == "N"
					aCOLS[1][nUsado] := 0
				Elseif x3_tipo == "D"
					aCOLS[1][nUsado] := dDataBase
				Elseif x3_tipo == "M"
					aCOLS[1][nUsado] := ""
				Else
					aCOLS[1][nUsado] := .F.
				Endif
			Endif
		Endif
		dbSkip()
	End
	
	aCOLS[1][nUsado+1] 	:= .F.
	aAltr[1]				:= SPACE(1)
		
EndIf


//+----------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2           ¦
//+----------------------------------------------+

//cCliente:=Space(6)
//cLoja   :=Space(2)
//dData   :=Date()

//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+

nLinGetD:=0

//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+

cTitulo:="CLASSIFICACAO DE FAIXAS DO GIRO DE ESTOQUES"

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em
//           Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

// AADD(aC,{"cCliente" ,{15,10} ,"Cod. do Cliente","@!",,"SA1",})
// AADD(aC,{"cLoja"    ,{15,200},"Loja","@!",,,})
// AADD(aC,{"dData"    ,{27,10} ,"Data de Emissao",,,,})

//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+

aR:={}

// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em
//           Windows estao em PIXEL
// aR[n,3] = Titulo do Campo

// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

// AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados","@E 999",,,.F.})

//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+

//aCGD:={44,5,118,315}
aCGD:={15,5,135,315}

//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+

cLinhaOk := "U_LIN_020()"
cTudoOk  := "U_ALL_020()"

//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+

// lRet = .t. se confirmou
// lRet = .f. se cancelou

lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

// No Windows existe a funcao de apoio CallMOd2Obj() que
// retorna o objeto Getdados Corrente

Return()



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LIN_020  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 24/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da digitacao da Linha                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIN_020()

// Verficamos se a informacao digitada ja existe no aCols

_cCodigo	:= aCols[n,_nCodigo]
_cDescr		:= aCols[n,_nDesc]
_cFxIni		:= aCols[n,_nFini]
_cFxFim		:= aCols[n,_nFfim]
_lRetorno	:= .T.

// Aqui irei verificar se no conteudo retornado do arquivoo usuario tentou alterar o codigo (baseado no array ALTR)

If n <= Len(aAltr)  // Somento as linhas retornadas quando o usuario entrou, sem contar com as inclusoes ou exclusoes
	
	If !Empty(aAltr[1])
		If _cCodigo <> aAltr[n]
			MsgBox("Voce NAO PODE alterar um codigo ja cadastrado, verifique !","ALERT")
			aCols[n,_nCodigo] := aAltr[n]
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			Return(.F.)
		EndIF
	Else   // Isto quer dizer que o estamos incluindo pela primeira vez e NAO VEIO dados da tabela
		
	EndIF
EndIF

If aCols[n,nUsado+1] <> .T. .and. ((aCols[n,_nFIni] >= aCols[n,_nFFim]) .or. (aCols[n,_nFIni] >= 100) .or. (aCols[n,_nFFim] > 100) .or. (aCols[n,_nFIni] == aCols[n,_nFFim]))
	MsgBox("Inconsistencias encontradas com os dados, verifique !","ALERT")
	Return(.F.)	
EndIf

If n > 1

	If aCols[n,nUsado+1] <> .T. .and. ((Empty(_cCodigo) .or. Empty(_cDescr) .or. Empty(_cFxIni) .or. Empty(_cFxFim)))
		MsgBox("Codigo, Descricao, Faixa Inicio ou Faixa Fim vazio, verifique !","ALERT")
		Return(.F.)	
	EndIf

	_nPosAnt := n - 1

	If n == Len(aCols)
		_nPosPro := 0
	Else
		_nPosPro := n + 1
	EndIf

	_nVlrFIni := aCols[n,_nFIni]
	_nVlrFFim := aCols[n,_nFFim]
	
	If aCols[n,nUsado+1] <> .T. .and. ((_nVlrFIni <= aCols[_nPosAnt,_nFIni]) .or. (_nVlrFIni <= aCols[_nPosAnt,_nFFim]))
		MsgBox("Inconsistencias encontradas com os dados da linha anterior, verifique !","ALERT")
		Return(.F.)	
	EndIf

	If _nPosPro <> 0 // Quer dizer que ja existe um proximo registro
		If aCols[n,nUsado+1] <> .T. .and. ((_nVlrFIni >= aCols[_nPosPro,_nFIni]))
			MsgBox("Inconsistencias encontradas com os dados da linha posterior, verifique !","ALERT")
			Return(.F.)	
		EndIf
    EndIf

Else

	If aCols[n,nUsado+1] <> .T. .and. ((Empty(_cCodigo) .or. Empty(_cDescr) .or. Empty(_cFxFim)))
		MsgBox("Codigo, Descricao ou Faixa Fim vazio, verifique !","ALERT")
		Return(.F.)	
	EndIf
	
EndIf

For _i := 1 to Len(aCols)
	
	If aCols[_i,nUsado+1] == .F. // So validamos as linhas que NAO estao deletadas

		If _cCodigo == aCols[_i,_nCodigo] .and. n <> _i .and. aCols[n,nUsado+1] == .F.
			MsgBox("Voce ja cadastrou este codigo, verifique ","ALERT")
			aCols[n,_nCodigo] := Space(1)
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			_lRetorno := .F.
		EndIf

	EndIf

Next

Return(_lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ALL_020  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 24/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do TODO, incluse onde efetuamos a gravacao        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ALL_020()

// Efetuaremos AQUI a gravacao dos dados no arquivo

DbSelectArea("SZ1")
DbSetOrder(1)

For _i := 1 to Len(aCols)

	If aCols[_i,nUsado+1] == .T. // Deletou a Linha
	
		DbSelectArea("SZ1")
		DbSetORder(1)
		If DbSeek(xFilial("SZ1")+aCols[_i,_nCodigo])
			RecLock("SZ1",.F.)
				DbDelete()
			MsUnLock()
	     EndIF

	Else // Linha NAO deletada
	
		DbSelectArea("SZ1")
		DbSetORder(1)
		If DbSeek(xFilial("SZ1")+aCols[_i,_nCodigo]) // Encontrou o registro, entao soh alteraremos o conteudo
			RecLock("SZ1",.F.)
				SZ1->Z1_CODIGO	:= aCols[_i,_nCodigo]
				SZ1->Z1_DESC	:= aCols[_i,_nDesc]
				SZ1->Z1_F_X_INI	:= aCols[_i,_nFini]
				SZ1->Z1_F_X_FIM	:= aCols[_i,_nFfim]
			MsUnLock()
	     Else
			RecLock("SZ1",.T.) // Nao encontrou o registro, entao incluiremos
				SZ1->Z1_CODIGO	:= aCols[_i,_nCodigo]
				SZ1->Z1_DESC	:= aCols[_i,_nDesc]
				SZ1->Z1_F_X_INI	:= aCols[_i,_nFini]
				SZ1->Z1_F_X_FIM	:= aCols[_i,_nFfim]
			MsUnLock()
	     EndIF
	     
	EndIf

Next

Return(.T.)
