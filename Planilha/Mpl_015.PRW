#include "rwmake.ch"

User Function MPL_015()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_015  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 01/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ TABELA DE FREQUENCIA PRATICA                                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBSERV:   ³ ESTE PROBRAMA DEPENDE DE PROGRAMA MPL_015_1, QUE IRA RODAR  ³±±
±±³          ³ GATILHOS NOS CAMPOS ZT_COD1 E TAMBEM DE CONSULTA ESPECIFICA ³±±
±±³          ³ SZR NO ARQUIVO SXB                                          ³±±
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
dbSeek("SZT")

nUsado:=0

aHeader:={}

While !Eof() .And. (x3_arquivo == "SZT")
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

Public _nCodigo		:= aScan(aHeader,{|x| x[2]=="ZT_CODIGO"})
Public _nDescr		:= aScan(aHeader,{|x| x[2]=="ZT_DESCR"})
Public _nOrig		:= aScan(aHeader,{|x| x[2]=="ZT_ORIG"})
Public _nCodAux		:= aScan(aHeader,{|x| x[2]=="ZT_CODAUX"})
Public _nFrqPra		:= aScan(aHeader,{|x| x[2]=="ZT_FRQPRA"})



//+-----------------------------------------------+
//¦ Montando aCols                                ¦
//+-----------------------------------------------+

aCols := {}

Public aAltr := {} 	// Este vetor contera o mesmo numero de itens do aCols e em cada item contera o codigo chave para a pesquisa no arquivo
// Isto eh necessario, pois se o usuario estiver alterando o codigo e o mesmo ja estiver no arquivo eu NAO DEIXO e a partir dele retorno o codigo antigo

dbSelectArea("SZT")
dbSetOrder(1)
dbGoTop()

If !EOF()
	
	While !Eof() .And. xFilial("SZT") == SZT->ZT_FILIAL
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		AADD(aAltr,aCols[Len(aCols),_nCodigo]+aCols[Len(aCols),_nOrig])	// Abastecendo array auxiliar com ao codigo
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo
	
Else
	
	aCols:=Array(1,nUsado+1)
	aAltr:=Array(1)
		
	dbSelectArea("SX3")
	dbSeek("SZT")
	
	nUsado:=0
	
	While !Eof() .And. (x3_arquivo == "SZT")
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
	aAltr[1]				:= SPACE(2)
		
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

cTitulo:="TABELA DE FREQUENCIA PRATICA"

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

cLinhaOk := "U_LIN_015()"
cTudoOk  := "U_ALL_015()"

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
±±³Fun‡„o    ³ LIN_015  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 29/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da digitacao da Linha                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIN_015()

// Verficamos se a informacao digitada ja existe no aCols

_cCodigo	:= aCols[n,_nCodigo]
_cOrig		:= aCols[n,_nOrig]
_cDescr		:= aCols[n,_nDescr]
_cFrqPra	:= aCols[n,_nFrqPra]
_lRetorno	:= .T.

// Aqui irei verificar se no conteudo retornado do arquivoo usuario tentou alterar o codigo (baseado no array ALTR)

If n <= Len(aAltr)  // Somento as linhas retornadas quando o usuario entrou, sem contar com as inclusoes ou exclusoes
	
	If !Empty(aAltr[1])
		If _cCodigo+_cOrig <> aAltr[n]
			MsgBox("Voce NAO PODE alterar um codigo ja cadastrado, verifique !","ALERT")
			aCols[n,_nCodigo] := Substr(aAltr[n],1,1)
			aCols[n,_nOrig]   := Substr(aAltr[n],2,1) 
			aCols[n,_nCodAux] := aAltr[n]
            aCols[n,_nDescr]  := Posicione("SZR",1,xFilial("SZR")+Substr(aAltr[n],1,1),"ZR_DESCR")
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			Return(.F.)
		EndIF
	Else   // Isto quer dizer que o estamos incluindo pela primeira vez e NAO VEIO dados da tabela
		
	EndIF
EndIF

If aCols[n,nUsado+1] <> .T. .and. (Empty(_cCodigo) .or. Empty(_cOrig).or. Empty(_cFrqPra))
	MsgBox("Codigo Classificacao ABC, Origem ou Frequencia Pratica vazio, verifique !","ALERT")
	Return(.F.)
EndIf

For _i := 1 to Len(aCols)
	
	If aCols[_i,nUsado+1] == .F. // So validamos as linhas que NAO estao deletadas

		If _cCodigo+_cOrig == aCols[_i,_nCodigo]+aCols[_i,_nOrig] .and. n <> _i .and. aCols[n,nUsado+1] == .F.
			MsgBox("Voce ja cadastrou este codigo+origem, verifique ","ALERT")
			aCols[n,_nCodigo] := Space(1)  
			aCols[n,_nOrig]   := Space(1)
			aCols[n,_nDescr]  := Space(60)
			aCols[n,_nCodAux] := Space(2)
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
±±³Fun‡„o    ³ ALL_015  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 29/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do TODO, incluse onde efetuamos a gravacao        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ALL_015()

// Efetuaremos AQUI a gravacao dos dados no arquivo

DbSelectArea("SZT")
DbSetOrder(1)

For _i := 1 to Len(aCols)

	If aCols[_i,nUsado+1] == .T. // Deletou a Linha
	
		DbSelectArea("SZT")
		DbSetORder(1)
		If DbSeek(xFilial("SZT")+aCols[_i,_nCodigo]+aCols[_i,_nOrig])
			RecLock("SZT",.F.)
				DbDelete()
			MsUnLock()
	     EndIF

	Else // Linha NAO deletada
	
		DbSelectArea("SZT")
		DbSetORder(1)
		If DbSeek(xFilial("SZT")+aCols[_i,_nCodigo]+aCols[_i,_nOrig]) // Encontrou o registro, entao soh alteraremos o conteudo
			RecLock("SZT",.F.)
				SZT->ZT_CODIGO	:= aCols[_i,_nCodigo]
				SZT->ZT_DESCR	:= aCols[_i,_nDescr]
				SZT->ZT_ORIG	:= aCols[_i,_nOrig]
				SZT->ZT_CODAUX	:= aCols[_i,_nCodigo]+aCols[_i,_nOrig]
				SZT->ZT_FRQPRA	:= aCols[_i,_nFrqPra]
			MsUnLock()
	     Else
			RecLock("SZT",.T.) // Nao encontrou o registro, entao incluiremos
                SZ1->ZT_FILIAL  := xFilial("SZT")
				SZT->ZT_CODIGO	:= aCols[_i,_nCodigo]
				SZT->ZT_DESCR	:= aCols[_i,_nDescr]
				SZT->ZT_ORIG	:= aCols[_i,_nOrig]
				SZT->ZT_CODAUX	:= aCols[_i,_nCodigo]+aCols[_i,_nOrig]
				SZT->ZT_FRQPRA	:= aCols[_i,_nFrqPra]
			MsUnLock()
	     EndIF
	     
	EndIf

Next

Return(.T.)
