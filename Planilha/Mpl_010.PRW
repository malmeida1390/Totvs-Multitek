#include "rwmake.ch"

User Function MPL_010()

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MPL_010  � Autor � Anderson Kurtinaitis   � Data � 29/03/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro XYZ (Criticidade)  SZP                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

//+-----------------------------------------------+
//� Opcao de acesso para o Modelo 2               �
//+-----------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx:=3

//+-----------------------------------------------+
//� Montando aHeader                              �
//+-----------------------------------------------+

dbSelectArea("SX3")

dbSetOrder(1)
dbSeek("SZP")

nUsado:=0

aHeader:={}

While !Eof() .And. (x3_arquivo == "SZP")
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

Public _nTipo		:= aScan(aHeader,{|x| x[2]=="ZP_TIPO"})
Public _nDescr		:= aScan(aHeader,{|x| x[2]=="ZP_DESCR"})

//+-----------------------------------------------+
//� Montando aCols                                �
//+-----------------------------------------------+

aCols := {}

Public aAltr := {} 	// Este vetor contera o mesmo numero de itens do aCols e em cada item contera o codigo chave para a pesquisa no arquivo
// Isto eh necessario, pois se o usuario estiver alterando o codigo e o mesmo ja estiver no arquivo eu NAO DEIXO e a partir dele retorno o codigo antigo

dbSelectArea("SZP")
dbSetOrder(1)
dbGoTop()

If !EOF()
	
	While !Eof() .And. xFilial("SZP") == SZP->ZP_FILIAL
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next
		AADD(aAltr,aCols[Len(aCols),_nTipo])	// Abastecendo array auxiliar com ao codigo
		aCols[Len(aCols),nUsado+1]:=.F.
		
		dbSkip()
	EndDo
	
Else
	
	aCols:=Array(1,nUsado+1)
	aAltr:=Array(1)
	
	dbSelectArea("SX3")
	dbSeek("SZP")
	
	nUsado:=0
	
	While !Eof() .And. (x3_arquivo == "SZP")
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
	
	aCOLS[1][nUsado+1]	:= .F.
	aAltr[1]				:= SPACE(1)
	
EndIf

//+----------------------------------------------+
//� Variaveis do Cabecalho do Modelo 2           �
//+----------------------------------------------+

//cCliente:=Space(6)
//cLoja   :=Space(2)
//dData   :=Date()

//+----------------------------------------------+
//� Variaveis do Rodape do Modelo 2
//+----------------------------------------------+

nLinGetD:=0

//+----------------------------------------------+
//� Titulo da Janela                             �
//+----------------------------------------------+

cTitulo:="CADASTRO DOS TIPOS DE CRITICIDADE"

//+----------------------------------------------+
//� Array com descricao dos campos do Cabecalho  �
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
//� Array com descricao dos campos do Rodape        �
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
//� Array com coordenadas da GetDados no modelo2   �
//+------------------------------------------------+

//aCGD:={44,5,118,315}
aCGD:={15,5,135,315}

//+----------------------------------------------+
//� Validacoes na GetDados da Modelo 2           �
//+----------------------------------------------+

cLinhaOk := "U_LIN_010()"
cTudoOk  := "U_ALL_010()"

//+----------------------------------------------+
//� Chamada da Modelo2                           �
//+----------------------------------------------+

// lRet = .t. se confirmou
// lRet = .f. se cancelou

lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

// No Windows existe a funcao de apoio CallMOd2Obj() que
// retorna o objeto Getdados Corrente

Return()



/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � LIN_010  � Autor � Anderson Kurtinaitis   � Data � 29/03/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao da digitacao da Linha                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function LIN_010()

// Verficamos se a informacao digitada ja existe no aCols

_cTipo := aCols[n,_nTipo]
_cDescr:= aCols[n,_nDescr]
_lRetorno := .T.

// Aqui irei verificar se no conteudo retornado do arquivoo usuario tentou alterar o codigo (baseado no array ALTR)

If n <= Len(aAltr)  // Somento as linhas retornadas quando o usuario entrou, sem contar com as inclusoes ou exclusoes
	
	If !Empty(aAltr[1])
		If _cTipo <> aAltr[n]
			MsgBox("Voce NAO PODE alterar um codigo ja cadastrado, verifique !","ALERT")
			aCols[n,_nTipo] := aAltr[n]
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			Return(.F.)
		EndIF
	Else   // Isto quer dizer que o estamos incluindo pela primeira vez e NAO VEIO dados da tabela
		
	EndIF
EndIF


If aCols[n,nUsado+1] <> .T. .and. (Empty(_cTipo) .or. Empty(_cDescr))
	MsgBox("Codigo ou Descricao vazios, verifique !","ALERT")
	Return(.F.)
EndIf

For _i := 1 to Len(aCols)
	
	If aCols[_i,nUsado+1] == .F. // So validamos as linhas que NAO estao deletadas
		
		If _cTipo == aCols[_i,_nTipo] .and. n <> _i .and. aCols[n,nUsado+1] == .F.
			MsgBox("Voce ja cadastrou este codigo, verifique ","ALERT")
			aCols[n,_nTipo] := Space(1)
			_oModelo2 := CallMod2Obj()			// Aqui obtenho o nome do objeto gerado pelo modelo2
			_oModelo2:oBrowse:Refresh()		// Aqui efetuo o refresh no objeto conseguido na linha acima
			_lRetorno := .F.
		EndIf
		
	EndIf
	
Next

Return(_lRetorno)



/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � ALL_010  � Autor � Anderson Kurtinaitis   � Data � 29/03/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do TODO, incluse onde efetuamos a gravacao        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Uso       � MULTI-TEK                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function ALL_010()

// Efetuaremos AQUI a gravacao dos dados no arquivo

DbSelectArea("SZP")
DbSetOrder(1)

For _i := 1 to Len(aCols)
	
	If aCols[_i,nUsado+1] == .T. // Deletou a Linha
	
		//���������������������������������������������������������������Ŀ
		//�Valida se o conteudo pode ser excluido da Tabela.              �
		//�Caso esteja sendo utilizado pela Arvore de Dimencionamento(SZH)�
		//�nao podera ser excluido.                                       �
		//| SZM - PQR   -  POPULARIDADE                                   �
		//| SZN - NEOIL -  DEMANDA                                        �
		//| SZP - XYZ   -  CRITICIDADE                                    �
		//| SZO - 123   -  AQUISICAO                                      �
		//| SZR - ABC   -  CURVA ABC                                      �
		//| SZ1 - HLM   -  GIRO                                           �
		//�����������������������������������������������������������������
		If  U_Val_SZHDel("XYZ",aCols[_i,_nTipo]) // cClass $ "PQR|NEOIL|XYZ|123|ABC|HLM"
			
			DbSelectArea("SZP")
			DbSetORder(1)
			If DbSeek(xFilial("SZP")+aCols[_i,_nTipo])
				RecLock("SZP",.F.)
				DbDelete()
				MsUnLock()
			EndIF
			
		Endif
		
	Else // Linha NAO deletada
		
		DbSelectArea("SZP")
		DbSetORder(1)
		If DbSeek(xFilial("SZP")+aCols[_i,_nTipo]) // Encontrou o registro, entao soh alteraremos o conteudo
			RecLock("SZP",.F.)
			SZP->ZP_DESCR := aCols[_i,_nDescr]
			MsUnLock()
		Else
			RecLock("SZP",.T.) // Nao encontrou o registro, entao incluiremos
			SZP->ZP_TIPO  := aCols[_i,_nTipo]
			SZP->ZP_DESCR := aCols[_i,_nDescr]
			MsUnLock()
		EndIF
		
	EndIf
	
Next

Return(.T.)
