#include "rwmake.ch"

User Function MPL_014()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MPL_014  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 31/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Lista Classificacao de Apanhes                              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBSERV:   ³ ESTE PROBRAMA DEPENDE DE PROGRAMA MPL_014_1, QUE IRA RODAR  ³±±
±±³          ³ GATILHOS NOS CAMPOS ZS_COD1 E ZS_COD2 E TAMBEM DE CONSULTAS ³±±
±±³          ³ ESPECIFICAS SZN E SZM NO ARQUIVO SXB                        ³±±
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
dbSeek("SZS")

nUsado:=0

aHeader:={}

While !Eof() .And. (x3_arquivo == "SZS")
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

Public _nCod1		:= aScan(aHeader,{|x| x[2]=="ZS_COD1"})
Public _nDescr1		:= aScan(aHeader,{|x| x[2]=="ZS_DESCR1"})
Public _nCod2		:= aScan(aHeader,{|x| x[2]=="ZS_COD2"})
Public _nDescr2		:= aScan(aHeader,{|x| x[2]=="ZS_DESCR2"})
Public _nFxIni		:= aScan(aHeader,{|x| x[2]=="ZS_FXINI"})
Public _nFxFim		:= aScan(aHeader,{|x| x[2]=="ZS_FXFIM"})


//+-----------------------------------------------+
//¦ Montando aCols                                ¦
//+-----------------------------------------------+

aCols := {}

Public aAltr := {} 	// Este vetor contera o mesmo numero de itens do aCols e em cada item contera o codigo chave para a pesquisa no arquivo
// Isto eh necessario, pois se o usuario estiver alterando o codigo e o mesmo ja estiver no arquivo eu NAO DEIXO e a partir dele retorno o codigo antigo

dbSelectArea("SZS")
dbSetOrder(1)
dbGoTop()

If !EOF()
	
	While !Eof() .And. xFilial("SZS") == SZS->ZS_FILIAL
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	EndDo

	// Colocando aCols na Ordem da Faixa Inicial
	aSort(aCols,,,{|x,y|x[_nFxIni]<y[_nFxIni]})

	// Abastecendo array auxiliar com ao codigo (Esta array verifica, em uma alteracao, se usuario tentar trocar um codigo existente)
    aAltr :={}
	For _i := 1 to Len(aCols)
		AADD(aAltr,aCols[_i,_nCod1]+aCols[_i,_nCod2])	// Abastecendo array auxiliar com ao codigo
	Next


	
Else
	
	aCols:=Array(1,nUsado+1)
	aAltr:=Array(1)
		
	dbSelectArea("SX3")
	dbSeek("SZS")
	
	nUsado:=0
	
	While !Eof() .And. (x3_arquivo == "SZS")
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

cTitulo:="LISTA CLASSIFICACAO DE APANHES"

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

cLinhaOk := "U_LIN_014()"
cTudoOk  := "U_ALL_014()"

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
±±³Fun‡„o    ³ LIN_014  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 29/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao da digitacao da Linha                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LIN_014()

// Verficamos se a informacao digitada ja existe no aCols

_cCod1  := aCols[n,_nCod1]
_cDescr1:= aCols[n,_nDescr1]
_cCod2  := aCols[n,_nCod2]
_cDescr2:= aCols[n,_nDescr2]
_cFxIni		:= aCols[n,_nFxIni]
_cFxFim		:= aCols[n,_nFxFim]
_lRetorno := .T.

// Aqui irei verificar se no conteudo retornado do arquivoo usuario tentou alterar o codigo (baseado no array ALTR)

If n <= Len(aAltr)  // Somento as linhas retornadas quando o usuario entrou, sem contar com as inclusoes ou exclusoes
	
	If !Empty(aAltr[1])
		If _cCod1+_cCod2 <> aAltr[n]
			MsgBox("Voce NAO PODE alterar um codigo ja cadastrado, verifique !","ALERT")
			aCols[n,_nCod1] := Substr(aAltr[n],1,1)
			aCols[n,_nCod2] := Substr(aAltr[n],2,1)
            aCols[n,_nDescr1] := Posicione("SZM",1,xFilial("SZM")+Substr(aAltr[n],1,1),"ZM_DESCR")
            aCols[n,_nDescr2] := Posicione("SZN",1,xFilial("SZN")+Substr(aAltr[n],2,1),"ZN_DESCR")
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			Return(.F.)
		EndIF
	Else   // Isto quer dizer que o estamos incluindo pela primeira vez e NAO VEIO dados da tabela
		
	EndIF
EndIF

If aCols[n,nUsado+1] <> .T. .and. (Empty(_cCod1) .or. Empty(_cCod2))
	MsgBox("Codigo(s) vazio(s), verifique !","ALERT")
	Return(.F.)
EndIf




If n > 1

	If aCols[n,nUsado+1] <> .T. .and. (Empty(_cCod1) .or. Empty(_cCod2) .or. Empty(_cFxIni) .or. Empty(_cFxFim))
		MsgBox("Codigo de Popularidade, Demanda, Faixa Inicio ou Faixa Fim vazio, verifique !","ALERT")
		Return(.F.)	
	EndIf

	_nPosAnt := n - 1

	If n == Len(aCols)
		_nPosPro := 0
	Else
		_nPosPro := n + 1
	EndIf

	_nVlrFIni := aCols[n,_nFxIni]
	_nVlrFFim := aCols[n,_nFxFim]
	/* 
    If !aCols[n,Len(aHeader)+1] .and. !aCols[_nPosAnt,Len(aHeader)+1]; 
       .and. ((_nVlrFIni <= aCols[_nPosAnt,_nFxIni]) .or. (_nVlrFIni <= aCols[_nPosAnt,_nFxFim]) .or. (_nVlrFIni <> aCols[_nPosAnt,_nFxFim] + 0.01 ))
		MsgBox("Inconsistencias encontradas com os dados da linha anterior, verifique !","ALERT")
		Return(.F.)	
	EndIf

	If _nPosPro <> 0 // Quer dizer que ja existe um proximo registro
		If  !aCols[n,Len(aHeader)+1] .and. !aCols[_nPosPro,Len(aHeader)+1]; 
		    .and. ((_nVlrFIni >= aCols[_nPosPro,_nFxIni]) .or. (_nVlrFFim <> aCols[_nPosPro,_nFxIni] - 0.01 ))
			MsgBox("Inconsistencias encontradas com os dados da linha posterior, verifique !","ALERT")
			Return(.F.)	
		EndIf
    EndIf
    */
Else

	If aCols[n,nUsado+1] <> .T. .and. ((Empty(_cCod1) .or. Empty(_cCod2)))
		MsgBox("Codigo da Popularidade ou Demanda vazio, verifique !","ALERT")
		Return(.F.)	
	EndIf
	
EndIf







For _i := 1 to Len(aCols)
	
	If aCols[_i,nUsado+1] == .F. // So validamos as linhas que NAO estao deletadas

		If _cCod1+_cCod2 == aCols[_i,_nCod1]+aCols[_i,_nCod2] .and. n <> _i .and. aCols[n,nUsado+1] == .F.
			MsgBox("Voce ja cadastrou este codigo, verifique ","ALERT")
			aCols[n,_nCod1] := Space(1)  
			aCols[n,_nCod2] := Space(1)
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
±±³Fun‡„o    ³ ALL_014  ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 29/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do TODO, incluse onde efetuamos a gravacao        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MULTI-TEK                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ALL_014()

// Efetuaremos AQUI a gravacao dos dados no arquivo

DbSelectArea("SZS")
DbSetOrder(1)

For _i := 1 to Len(aCols)

	If aCols[_i,nUsado+1] == .T. // Deletou a Linha
	
		DbSelectArea("SZS")
		DbSetORder(1)
		If DbSeek(xFilial("SZS")+aCols[_i,_nCod1]+aCols[_i,_nCod2])
			RecLock("SZS",.F.)
				DbDelete()
			MsUnLock()
	     EndIF

	Else // Linha NAO deletada
	
		DbSelectArea("SZS")
		DbSetORder(1)
		If DbSeek(xFilial("SZS")+aCols[_i,_nCod1]+aCols[_i,_nCod2]) // Encontrou o registro, entao soh alteraremos o conteudo
			RecLock("SZS",.F.)
				SZS->ZS_COD1  := aCols[_i,_nCod1]
				SZS->ZS_DESCR1:= aCols[_i,_nDescr1]
				SZS->ZS_COD2  := aCols[_i,_nCod2]
				SZS->ZS_DESCR2:= aCols[_i,_nDescr2]
				SZS->ZS_FXINI := aCols[_i,_nFxIni]
				SZS->ZS_FXFIM := aCols[_i,_nFxFim] //(Correcao para Protheus10)
			MsUnLock()
	     Else
			RecLock("SZS",.T.) // Nao encontrou o registro, entao incluiremos
                SZS->ZS_FILIAL:= xFilial("SZS")
				SZS->ZS_COD1  := aCols[_i,_nCod1]
				SZS->ZS_DESCR1:= aCols[_i,_nDescr1]
				SZS->ZS_COD2  := aCols[_i,_nCod2]
				SZS->ZS_DESCR2:= aCols[_i,_nDescr2]
				SZS->ZS_FXINI := aCols[_i,_nFxIni]
				SZS->ZS_FXFIM := aCols[_i,_nFxFim]  //(Correcao para Protheus10)
			MsUnLock()
	     EndIF
	     
	EndIf

Next

Return(.T.)