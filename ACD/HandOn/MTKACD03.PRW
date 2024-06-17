#include "protheus.ch"
#INCLUDE 'APVT100.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTKACD03  ºAutor  ³Anderson            º Data ³  31/03/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa principal para Desmontagem de produtos via RF      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multi-Tek                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTKACD03

Private nLinha		:= 0
Private bkey09		:= VTSetKey(09,{|| _Informa("1")})		// CTRL+I - Informa quais as etiquetas ja foram lidas
Private bkey01		:= VTSetKey(01,{|| _Ajuda("1")})		// CTRL+A - Tela de Ajuda
Private bkey24		:= VTSetKey(24,{|| _Estorna()})		// CTRL+X - Estorna Etiquetas Lidas
Private cEti
Private aEtiqueta   := {}
Private aLista 	  := {}
Private aGrupLista 	:= {}
Private nQE
Private lMSErroAuto := .F.
Private nQtdEtiq    := 1
Private cArmazem
Private cEndereco
Private cLote 		:= Space(10)
Private cSLote		:= Space(6)
Private dValid		:= ctod('')
Private cNumSerie 	:= Space(TamSX3("BF_NUMSERI")[1])


Private cTitulo     := "Desmontagem"

While .T.
	
	VTClear()
	dValid:= ctod('')
	nQtdEtiq  := 1
	nQE       := 1
	nLinha    := 0
	aEtiqueta := {}
	cArmazem  := Space(2)
	cEti      := If(UsaCB0("01"),Space(TamSX3("CB0_CODET2")[1]),Space(48))
	cEndereco := If(UsaCB0("02"),Space(20),Space(15))
	
	@ 0,0 VTSay cTitulo
	
	If Empty(cEti)
		@ ++nLinha,0 VTSay "Quais Produtos"
		@ ++nLinha,0 VTGet cEti Picture "@!" Valid _VALPROD() when Empty(cEti)
		VTRead       

		If VTLastKey() == 27
			If !Empty(aLista)
				If VtYesNo("Confirma Produtos?","Atencao",.t.)
					Vtsetkey(24,bkey24)
					VtSetkey(09,bkey09)
					VtSetkey(01,bkey01)
					Exit
				Else
					If VtYesNo("Abandona Desmontagem?","Atencao",.t.)
						Vtsetkey(24,bkey24)
						VtSetkey(09,bkey09)
						VtSetkey(01,bkey01)
						Return()
					Else
						Loop
					EndIf
				EndIf
			Else
				Exit
			EndIf
		EndIf
		Loop
	Else
		_VALPROD()
	EndIf
	
EndDo

// Agora iremos verificar se o array aLista possui produtos, caso afirmativo
// Perguntaremos como sera o rateio para os produtos que serao produzidos
// Perguntaremos quais os produtos serao produzidos e faremos
// Imprimir e gerar as etiquetas dos novos produtos
// Fazer as movimentacoes necessarias dentro do Protheus

VtClear()

// Operador NAO digitou nenhum produto a desmontar
if Empty(aLista)
	Return()
EndIf

// Perguntar se rateio sera por valor ou percentual
If VtYesNo("Rateio por Valor? S-VALOR N-PERCENTUAL","Pergunta",.t.)
	_cRateio	:= "V"
Else
	_cRateio	:= "P"
EndIf

// Montando tela para perguntar quais os produtos a serem produzidos e o rateio
aProdutos	:= {}
_lConfirma	:= .F.
While .t.
	
	VtClear()
	Private bkey09	:= VTSetKey(09,{|| _Informa("2")}) // CTRL+I 		// Consulta Produtos ja escolhidos, os quais serao produzidos
	Private bkey24	:= VTSetKey(24,{|| _EstorPRO()})	// CTRL+X		// Estorno dos produtos a produzir
	Private bkey16	:= VtSetKey(16,{|| _AlterPRO()})	// CTRL+P		// Alterar as informacoes de um determinado produto
	Private bkey01	:= VTSetKey(01,{|| _Ajuda("2")})	// CTRL+A       // Tela de Ajuda
	Private cPro 	:= Space(TamSX3("B1_COD")[1])
	Private nQtd	:= 0
	Private nRat	:= 0
	
	@ 0,0 VTSay cTitulo
	@ 1,0 VTSay "Produto a Produzir"
	@ 2,0 VTGet cPro Picture "@!" Valid _VPRODUTO() F3 "SB1" when Empty(cPro)
	@ 3,0 VTSay "Quantidade"
	@ 4,0 VTGet nQtd Picture "@E 999.99" Valid _VALQTD() when Empty(nQtd)
	If _cRateio == "V"
		@ 5,0 VtSay "Valor Rateio"
		@ 6,0 VtGet nRat Picture "@E 999,999.9999" Valid _VALRAT() when Empty(nRat)
	Else
		@ 5,0 VtSay "Perc. Rateio"
		@ 6,0 VtGet nRat Picture "@E 999.99" Valid _VALRAT() when Empty(nRat)
	EndIf
	VTRead
	
	If VTLastKey() == 27
		If !Empty(aProdutos)
			If VtYesNo("Confirma Desmontagem?","Atencao",.t.)
				// Chama rotina que valida se tudo esta OK para a desmontagem
				If _ValProduz() == .T.
					_lConfirma	:= .T.
					Vtsetkey(24,bkey24)
					Vtsetkey(09,bkey09)
					
					VTMSG("Aguarde...")
					
					// 0
					// AQUI DEVEREMOS EFETUAR AS MOVIMENTACOES NECESSARIAS, IMPRESSAO DAS ETIQUETAS, ETC...
					// JA QUE OS RATEIOS INFORMADOS FORAM VALIDADOS E ESTAO OK
					// VAMOS UTILIZAR OS PARAMETROS MV_TMDS  E  MV_TMDE (TIPO DE MOVIMENTACAO PARA OS DESMONTADOS E PARA OS PRODUZIDOS COM A DESMONTAGEM)
					
					// 1
					// ATRAVES DA LEITURA DO ARRAY ALISTA (CONTEM AS ETIQUETAS A SEREM DESMONTADAS) VAMOS EFETUAR SUA RETIRADA
					// DOS ESTOQUES UTILIZANDO MOVIMENTACOES INTERNAS NAO VALORIZADAS (O PROTHEUS AQUI UTILIZARA O CUSTO MEDIO).
					// O ARMAZEM E LOCALIZACAO UTILIZADO NO MOVIMENTO EH O MESMO CONSTANTO EM CADA ETIQUETA BIPADA, INCLUSIVE
					// EXISTIRA UMA MOVIMENTACAO DE SAIDA PARA CADA ETIQUETA (MANTENDO ASSIM A INTEGRACAO COM O TEMPLATE ACD)
					
					// Movimentos de Saida
					For _t := 1 to Len(aLista)
						
						if (_MovSaida(_t)) // Passando a Posicao do array neste momento 
						                    // Gerando LOG da Etiqueta Movimentada
						   CBLog("06",{aLista[_t][2],aLista[_t][3],NIL,NIL,aLista[_t][5],aLista[_t][4],NIL,NIL,GetMV("MV_TMDS"),aLista[_t][1],"MTKACD03 - Requisitado pela rotina de Desmontagem"})

							DbSelectArea("CB0")
							DbSetOrder(1)
							If DbSeek(xFilial("CB0")+aLista[_t][1]) // Etiqueta
								RecLock("CB0",.F.)
								CB0->CB0_X_STAT		:=	"D"
								MsUnlock()
							EndIf

						Else                                             
						

							VTAlert("Processo Erro Rotina _MovSaida(_T) !","Mensagem",.T.,2000)

                     /*
							VTAlert("Processo Erro Rotina _MovSaida(_T) ,"+;
							"Etiqueta  "+aLista[_t][1]+CHR(13)+;
							"Produto   "+aLista[_t][2]+CHR(13)+;
							"Quantidade"+aLista[_t][3]+CHR(13)+;
							"Local     "+aLista[_t][5]+CHR(13)+;
							"Localiz   "+aLista[_t][4]+CHR(13)+;                             
							"!","Mensagem",.T.,2000)						
                     */
                     
						Endif
						
					Next

					
					// ATRAVES DA LEITURA DO ARRAY APRODUTOS VAMOS FAZER AS MOVIMENTACOES INTERNAS DE DEVOLUCAO VALORIZADAS
					// CONFORME O RATEIO INFORMADO (ESTEJA ELE JA COM VALOR OU EM PERCENTUAL RELATIVO A VARIAVAL _NCUSTOT)
					// VAMOS TAMBEM GERAR AS IMPRESSOES (CRIACAO) DAS ETIQUETAS PARA OS PRODUTOS NOVOS (OS QUAIS FORAM DESMONTADOS) E
					// POR ULTIMO VAMOS ENDERECA-LAS PARA O ENDERECO CONSTANT NO PARAMETRO MV_ALX01 (ARMAZEM E ENDERECO DE VENDA)
					
					// Movimentos de Entrada, enderecamento destes movimentos e impressao/geracao das etiquetas
					For _a := 1 to Len(aProdutos)
						
						 if (_MovEntra(_a)) // Passando a Posicao do array neste momento      // Movimentacao
					       if (_EndEntra(_a)) // Passando a Posicao do array neste momento    // Endereca Produto
							    _ImpEntra(_a) // Passando a Posicao do array neste momento    // Imprime Etiqueta
                      Else
   					       VTAlert("Processo Erro Rotina _EndEntra(_a) !","Mensagem",.T.,2000)
                      Endif 
                   Else   
					       VTAlert("Processo Erro Rotina _MovEntra(_a) !","Mensagem",.T.,2000)
                   Endif   

					Next
					
					// AQUI estaremos varrendo pela ultima vez o array aLista (o qual contem as etiquetas dos produtos que serao desmontados)
					// e entao os marcaremos com finalizado pela desmontagem (Campo: CB0_X_STAT == "D")
					//For _i	:= 1 to Len(aLista)
					//	DbSelectArea("CB0")
					//	DbSetOrder(1)
					 //	If DbSeek(xFilial("CB0")+aLista[_i][1]) // Etiqueta
					//		RecLock("CB0",.F.)
					//		CB0->CB0_X_STAT		:=	"D"
					//		MsUnlock()
					//	EndIf
					//Next
					
					VTBeep(2)
					VTAlert("Processo Finalizado com Sucesso!","Mensagem",.T.,2000)
					
					Exit
					
				Else
					VTBeep(2)
					VTAlert("Existem inconsistencias, ajuste-as efetuando a alteracao CTRL-P","Atencao",.T.,2000)
					VTKeyBoard(chr(20))
					If VtYesNo("Abandona Todo o Processo?","Atencao",.t.)
						Exit
					Else
						Loop
					EndIf
				EndIf
			Else
				If VtYesNo("Abandona Desmontagem?","Atencao",.t.)
					Exit
				Else
					Loop
				EndIf
			EndIf
		Else
			If VtYesNo("Abandona Desmontagem?","Atencao",.t.)
				Exit
			Else
				Loop
			EndIf
		EndIf
	EndIf
	
	Loop
	
EndDo

Vtsetkey(09,bkey09)
Vtsetkey(01,bkey01)
Vtsetkey(16,bkey01)
Vtsetkey(24,bkey24)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VALPROD   ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica integridade no codigo da etiqueta bipada          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VALPROD()
Local nQtdeT  := 0
Local nTotItem:= 0
Local nY      := 0


// Nao bipou, deu ENTER
If Empty(cEti)
	Return .f.
EndIf

// Obtendo informacoes sobre a etiqueta bipada
aEtiqueta := CBRetEti(cEti,"01",,)

nPos := aScan(aLista,{|x| x[1] == cEti})
If !Empty(nPos)
	VTBeep(2)
	VTAlert("Etiqueta ja Lida","Aviso",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If Empty(aEtiqueta) // Caso a Funcao acima, CBRetEti NAO retorne etiqueta alguma
	VTBeep(2)
	VTAlert("Etiqueta invalida","Aviso",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If Empty(CB0->CB0_LOCALI)
	VTBeep(2)
	VTALERT("Etiqueta ainda NAO foi enderecada!","AVISO",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If !Empty(CB0->CB0_PALLET)
	VTBeep(2)
	VTALERT("Etiqueta invalida, Produto pertence a um Pallet","AVISO",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

If Empty(aEtiqueta[2])
	aEtiqueta[2] := 1
Endif

nQtdEtiq := 1
cArmazem := aEtiqueta[10]
cEndereco:= aEtiqueta[9]
cLote    := aEtiqueta[16]
cSLote   := aEtiqueta[17]
dValid   := aEtiqueta[18]
cNumSerie:= CB0->CB0_NUMSER   


// Posicionando no PRODUTO da Etiqueta
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+aEtiqueta[1]) // Produto
// Posicionando no SALDO DE ESTOQUES da Etiqueta para PEGAR o CUSTO
DbSelectArea("SB2")
DbSetOrder(1)
DbSeek(xFilial("SB2")+aEtiqueta[1]+aEtiqueta[10]) // Produto + local

dValid := dDataBase+SB1->B1_PRVALID
nQE:= 1

// Verifica se Produto esta sendo inventariado
If BlqInvent(aEtiqueta[1],aEtiqueta[10]) // Produto, Local
	VTBeep(2)
	VTALERT("Produto esta bloqueado para inventario!","AVISO",.T.,2000)
	Return .f.
EndIf

// Verifica se o produto e unitario ou granel
If !CBProdUnit(aEtiqueta[1])
	
	aSaveG   := VTSAVE()
	VTClear()
	@ 1,0 VTSay "Produto a granel!"
	@ 3,0 VtSay "Quantidade"
	@ 4,0 VtGet nQE picture "@E 9999.99" valid nQE > 0
	VTREAD
	VtRestore(,,,,aSaveG)
	If VTLastKey() == 27
		VTBeep(2)
		VTAlert("Quantidade Invalida","Aviso",.t.,2000)
		nQE := 0
	EndIf
	aEtiqueta[2]	:= nQE

EndIf

// Se quantidade for ZERO entao NAO DEVE incluir no array de etiquetas e voltar a questionar o usuario
If  nQe	< 0
	Return .f.
EndIF
    

// Soma a quantidade de etiquetas do mesmo produto ja bipadas.
nTotItem:=1
For nY := 1 to Len(aLista)
    If SB1->B1_COD = aLista[nY][2]  
       nTotItem++
    Endif
Next    


// Verificando se Estoques dos produtos a sair atendem as quantidades bipadas (Nao deveria, mas podem existir problemas na base)
If  (GetMV("MV_ESTNEG") == "N" .Or. Localiza(aEtiqueta[1]) .Or. Rastro(aEtiqueta[1])) .And. SubStr(aEtiqueta[1],1,3) != "MOD" .and. !Empty(aEtiqueta[2])
	If (SaldoSB2() - nTotItem) < 0
		VTBeep(2)
		VTAlert("Quantidade em Estoques Invalida. Favor analisar se nao existem reservas !","Aviso",.t.,2000)
		Return .F.
	EndIf
	If !Empty(cEndereco) .And. Localiza(aEtiqueta[1]) .And. SaldoSBF(cArmazem,cEndereco,aEtiqueta[1],,,) < aEtiqueta[2]
		VTBeep(2)
		VTAlert("Quantidade no Endereco Invalida!","Aviso",.t.,2000)
		Return .F.
	EndIf
EndIf


If SB2->B2_CM1 = 0
	VTBeep(2)
	VTAlert("Produto nao possui custo desta forma nao sera possivel continuar!","Aviso",.t.,2000)
	Return .F.
Endif


If len(aLista) >= 20
	VTBeep(2)
	VTALERT("A desmostagem somente e possivel a cada 20 produtos."+chr(13)+;
	"Caso contrario existe o risco de travamento do Handheld.","AVISO",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf


// Dando manutencao no array aList, o qual contem os dados dos produtos a serem desmontados
nPos := aScan(aLista,{|x| x[1] == cEti})
If Empty(nPos)
	 //Etiqueta, Produto, Qtd, Local, Armazem, Custo Unitario
	aadd(aLista,{cEti,aEtiqueta[1],aEtiqueta[2],aEtiqueta[9],aEtiqueta[10],SB2->B2_CM1})
EndIf



/*
//
// Analisa o Saldo de um dado produto dentro de um mesmo endereco.
//
nQtdeT :=0 
For nY := 1 to Len(aLista)
    //                   1        2            3             4           5           6     
 	 //             Etiqueta , Produto     ,Qtd         , Local        , Armazem     , Custo Unitario
	 //aadd(aLista,{cEti     , aEtiqueta[1],aEtiqueta[2], aEtiqueta[9] , aEtiqueta[10],SB2->B2_CM1}) 
	 //                                                 Produto      Local         Armazem       
    If aLista[nY,2]+aLista[nY,4]+aLista[nY,5]  =  aEtiqueta[1]+aEtiqueta[10]+aEtiqueta[9]
       nQtdeT := nQtdeT +aLista[nY,3] 
    Endif
Next nY

// Verificando se Estoques dos produtos a sair atendem as quantidades bipadas (Nao deveria, mas podem existir problemas na base)
If (GetMV("MV_ESTNEG") == "N" .Or. Localiza(aEtiqueta[1]) .Or. Rastro(aEtiqueta[1])) .And. SubStr(aEtiqueta[1],1,3) != "MOD" .and. !Empty(aEtiqueta[2])
	If (SaldoSB2() - nQtdeT) < 0
		VTBeep(2)
		VTAlert("Quantidade em Estoques Invalida!","Aviso",.t.,2000)
		Return .F.
	EndIf
	If !Empty(cEndereco) .And. Localiza(aEtiqueta[1]) .And. SaldoSBF(cArmazem,cEndereco,aEtiqueta[1],,,) < nQtdeT
		VTBeep(2)
		VTAlert("Quantidade no Endereco Invalida!","Aviso",.t.,2000)
		Return .F.
	EndIf
EndIf
*/


Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _AJUDA     ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA AJUDA - QUANDO USUARIO USA O CTRL + A		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _Ajuda(_cQual)

If _cQual == "1"
	VTBeep(2)
	VTALERT("CTRL+I Informacao CTRL+X Estorna   CTRL+A Ajuda     ","Ajuda")
Elseif _cQual == "2"
	VTBeep(2)
	VTALERT("CTRL+I Informacao CTRL+X Estorna   CTRL+A Ajuda     CTRL+P Altera    ","Ajuda")
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _ESTORNA   ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA ESTORNAR AS ETIQUETAS LIDAS					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _Estorna()

Local aTela
Local cEtiqueta

aTela := VTSave()
VTClear()
cEtiqueta := Space(20)

@ 00,00 VtSay Padc("Estorno de Leitura",VTMaxCol())
@ 02,00 VtSay "Etiqueta:"
@ 03,00 VtGet cEtiqueta picture "@!" Valid _VldEstorno(cEtiqueta) when Empty(cEtiqueta)
VtRead

vtRestore(,,,,aTela)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VLDESTORNO³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA VALIDAR A ETIQUETA BIPADA NO ESTORNO			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VldEstorno(cEtiqueta)

nPos := aScan(aLista,{|x| x[1] == cEtiqueta})
If Empty(nPos)
	VTBeep(2)
	VTALERT("Etiqueta NAO foi lida","Verifique",.T.,2000)
Else
	VTBeep(2)
	VTALERT("Etiqueta "+cEtiqueta+" foi estornada das leituras","AVISO",.T.,2000)
	aDel(aLista,nPos)
	aSize(aLista,len(aLista)-1)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _ESTORPRO  ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA ESTORNAR OS PRODUTOS QUE DEVERAO SER CRIADOS	  ³±±
±±³          ³ COM A DESMONTAGEM										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _EstorPRO()

Local aTela
Local cProduto

aTela := VTSave()
VTClear()
cProduto := Space(15)

@ 00,00 VtSay Padc("Estorno de Produtos",VTMaxCol())
@ 02,00 VtSay "Produto:"
@ 03,00 VtGet cProduto picture "@!" Valid _VldEstPRO(cProduto) F3 "SB1" when Empty(cProduto)
VtRead

vtRestore(,,,,aTela)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VLDESTPRO ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA VALIDAR O PRODUTO INFORMADO NO ESTORNO	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VldEstPRO(cProduto)

nPos := aScan(aProdutos,{|x| x[1] == cProduto})
If Empty(nPos)
	VTBeep(2)
	VTALERT("Este Produto NAO foi lancado","Verifique",.T.,2000)
Else
	VTBeep(2)
	VTALERT("Produto "+cProduto+" foi estornado dos produtos a produzir","AVISO",.T.,2000)
	aDel(aProdutos,nPos)
	aSize(aProdutos,len(aProdutos)-1)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VPRODUTO  ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica integridade no codigo do Produto digitado         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VPRODUTO()

// Nao digitou, deu ENTER
If Empty(cPro)
	Return .f.
EndIf   

// Verificando se produto a produzir com a desmontagem nao eh o mesmo do que um do(s) que foram desmontado(s) no processo
// 23/05/2005
nPos := aScan(aLista,{|x| x[2] == cPro})
If !Empty(nPos)
	VTBeep(2)
	VTAlert("Item a desmontar NAO pode ser produzido!","Aviso",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

// Posicionando no PRODUTO da Etiqueta
DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+cPro)
	VTBeep(2)
	VTAlert("Produto NAO existe!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

//Verificando se o produto ja nao esta na lista a ser produzida
nPos := aScan(aProdutos,{|x| x[1] == cPro})
If !Empty(nPos)
	VTBeep(2)
	VTAlert("Produto JA inserido!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas

// Verifica se Produto esta sendo inventariado
If BlqInvent(cPro,_cArmazOK) // Produto, Local
	VTBeep(2)
	VTALERT("Produto esta bloqueado para inventario!","AVISO",.T.,2000)
	Return .f.
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VPRODUTOA ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica integridade no codigo do Produto na alteracao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VPRODUTOA()

// Nao digitou, deu ENTER
If Empty(cProA)
	Return .f.
EndIf

// Posicionando no PRODUTO da Etiqueta
DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+cProA)
	VTBeep(2)
	VTAlert("Produto NAO existe!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

//Verificando se o produto ja nao esta na lista a ser produzida
nPos := aScan(aProdutos,{|x| x[1] == cProA})
If Empty(nPos)
	VTBeep(2)
	VTAlert("Produto NAO foi lancado!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
EndIf

_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas

// Verifica se Produto esta sendo inventariado
If BlqInvent(cProA,_cArmazOK) // Produto, Local
	VTBeep(2)
	VTALERT("Produto esta bloqueado para inventario!","AVISO",.T.,2000)
	Return .f.
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VALQTD    ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica integridade no valor informado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VALQTD()

If Empty(nQtd)
	VTBeep(2)
	VTAlert("Erro: Quantidade ZERO!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
Endif

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VALRAT    ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica integridade no rateio informado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VALRAT()

If Empty(nRat)
	VTBeep(2)
	VTAlert("Erro: Rateio ZERO!","Verifique",.T.,2000)
	VTKeyBoard(chr(20))
	Return .f.
Endif

nPos := aScan(aProdutos,{|x| x[1] == cPro})
If Empty(nPos)
	aadd(aProdutos,{cPro,nQtd,nRat}) //Produto, Quantidade, Rateio
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _VALPRODUZ ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica as consistencias gerais antes de Desmontar        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _VALPRODUZ()

// Aqui teremos as validacaoes gerais antes de desmontar e produzir
_lRetorno	:= .F.

// Verificando as etiquetas bipadas e somando o CUSTO TOTAL em uma variavel para podermos verificar
// se o rateio informado esta correto em relacao ao CUSTO TOTAL

Public _nCusTot	:= 0	// Cotem a soma de CUSTO de TODOS os itens a serem desmontados

For _i := 1 to Len(aLista)
	
	_nCusTot	:= _nCusTot + (aLista[_i][3] * aLista[_i][6])
	
Next

// Comparando AGORA os Produtos informados para serem criados com a desmontagem se o RATEIO entre eles esta OK

_nRateio	:= 0

For _n := 1 to Len(aProdutos)
	
	_nRateio := _nRateio + aProdutos[_n][3]
	
Next

If _cRateio == "P" // Por Percentual
	
	If _nRateio <> 100
		VTBeep(2)
		VTAlert("Percentuais de Rateio invalidos!","Verifique",.T.,2000)
		_lRetorno := .F.
	Else
		_lRetorno := .T.
	EndIF
	
Elseif _cRateio == "V" // Por Valor
	
	If _nRateio <> _nCusTot
		VTBeep(2)
		VTAlert("Valores de Rateio invalidos!","Verifique",.T.,2000)
		_lRetorno := .F.
	Else
		_lRetorno := .T.
	EndIF
	
EndIf


Return _lRetorno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _ALTERPRO  ³ Autor ³ Desenv.    ACD      ³ Data ³ 31/03/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetua ajustes nas informacoes dos produtos a produzir     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTITEK           	    						          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _ALTERPRO()

Local aSave := VTSAVE()
Private cProA := Space(TamSX3("B1_COD")[1])
Private nQtdA	:= 0
Private nRatA	:= 0

VtClear()
@ 0,0 VTSay "ALTERANDO"
@ 1,0 VTSay "Produto a Alterar"
@ 2,0 VTGet cProA Picture "@!" Valid _VPRODUTOA() F3 "SB1" when Empty(cProA)
@ 3,0 VTSay "Quantidade"
@ 4,0 VTGet nQtdA Picture "@E 999.99" when Empty(nQtdA)
If _cRateio == "V"
	@ 5,0 VtSay "Valor Rateio"
	@ 6,0 VtGet nRatA Picture "@E 999,999.9999" when Empty(nRatA)
Else
	@ 5,0 VtSay "Perc. Rateio"
	@ 6,0 VtGet nRatA Picture "@E 999.99" when Empty(nRatA)
EndIf
VTRead

If VTLastKey() == 27
	VtRestore(,,,,aSave)
	Return
Else
	If !Empty(cProA) .and. !EMpty(nQtdA) .and. !Empty(nRatA)
		If VtYesNo("Confirma Alteracao?","Atencao",.t.)
			nPos := aScan(aProdutos,{|x| x[1] == cProA})
			If !Empty(nPos)
				aProdutos [nPos][2]		:= nQtdA
				aProdutos [nPos][3]		:= nRatA
			EndIf
			VTBeep(2)
			VTAlert("Produto ALTERADO!","Mensagem",.T.,2000)
		Else
			VTBeep(2)
			VTAlert("Produto NAO alterado!","Mensagem",.T.,2000)
		EndIF
	Else
		VTBeep(2)
		VTAlert("Produto NAO alterado!","Campo Vazio",.T.,2000)
	EndIf
	
EndIf

VtRestore(,,,,aSave)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _INFORMA   ³ Autor ³ Eduardo Motta       ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra produtos que ja foram lidos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MULTI-TEK		   								          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _Informa(_cQual)

Local aCab,aSize,aSave := VTSAVE()

VTClear()

If _cQual == "1"
	aCab  := {"Etiqueta","Produto","Quant.","Endereco","Armazem","Custo Unit."}
	aSize := {10,15,10,15,2,10}
	VTaBrowse(0,0,7,19,aCab,aLista,aSize)
Elseif _cQual == "2"
	aCab  := {"Produto","Quant.","Rateio"}
	aSize := {15,10,10}
	VTaBrowse(0,0,7,19,aCab,aProdutos,aSize)
EndIf

VtRestore(,,,,aSave)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _MovEntra  ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera movimentacao interna de Entrada (Produzidos com a     ³±±
±±³          ³ desmontagem)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MultiTek		    								          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _MovEntra(_nP)

// Armazem e Local de Vendas
_aTEnd		:= TamSx3("DB_LOCALIZ") // Tamanho e Tipo de um campo Qualquer de endereco no ERP Protheus (Preciso saber o tamanho porcausa do MSESXECAUTO)
_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas
_cLocalOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),3,50)) // Localizacao de Vendas no Armazem de Vendas
_nTOK		:= _aTEnd[1] - Len(_cLocalOK) //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
_cLocalOK	:= _cLocalOK + Space(_nTOK)
_lRet       := .T.


DbSelectArea("SB2")
_aASB2 := GetArea()
DbSetOrder(1) // Produto + Local
If !DbSeek(XFilial("SB2")+aProdutos[_nP][1]+_cArmazOK)
	CriaSB2(aProdutos[_nP][1],_cArmazOK)
EndIf


aMata := {{"D3_TM"		,GetMV("MV_TMDE")	,nil},;
{"D3_COD"		,aProdutos[_nP][1]	,nil},;
{"D3_QUANT"		,aProdutos[_nP][2]	,nil},;
{"D3_LOCAL"		,_cArmazOK			,nil},;
{"D3_LOCALIZ"	,_cLocalOK			,nil},;
{"D3_EMISSAO"	,dDataBase			,nil}}

//{"D3_DOC"		,"DESMON"			,nil},;

If _cRateio == "V"
	AADD(aMata,{"D3_CUSTO1"	,aProdutos[_nP][3]	,nil})
Else
	_nVlrCst	:= _nCusTot * (aProdutos[_nP][3] / 100)
	AADD(aMata,{"D3_CUSTO1"	,_nVlrCst			,nil})
EndIF

Private nModulo := 4

lMSErroAuto := .F.
lMSHelpAuto := .T.

MSEXECAUTO({|x|MATA240(x)},aMata)

lMSHelpAuto := .F.

If lMSErroAuto
	VTBeep(2)
	VTAlert("Falha na gravacao da movimentacao - Entrada ","ERRO",.T.,2000)
EndIf

Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _MovSaida  ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera movimentacao interna de Saida dos Produtos que foram  ³±±
±±³          ³ desmontados.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MultiTek		    								          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _MovSaida(_nP)
Local lRet := .T.

aMata := {{"D3_TM"		,GetMV("MV_TMDS")	,nil},;
{"D3_COD"		,aLista[_nP][2]		,nil},;
{"D3_QUANT"		,aLista[_nP][3]		,nil},;
{"D3_LOCAL"		,aLista[_nP][5]		,nil},;
{"D3_LOCALIZ"	,aLista[_nP][4]		,nil},;
{"D3_EMISSAO"	,dDataBase		 	   ,nil}}

//{"D3_DOC"		,"DESMON"			,nil},;

Private nModulo := 4

lMSErroAuto := .F.
lMSHelpAuto := .T.

MSEXECAUTO({|x|MATA240(x)},aMata)

lMSHelpAuto := .F.

If lMSErroAuto
	VTBeep(2)
	VTAlert("Falha na gravacao da movimentacao","ERRO",.T.,2000)
   lRet := .f.
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _EndEntra  ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Endereca os Produtos Novos que entraram nos estoques       ³±±
±±³          ³ atraves da desmontagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MultiTek		    								          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _EndEntra(_nP)

// Variaveis importantes
_aTEnd		:= TamSx3("DB_LOCALIZ") // Tamanho e Tipo de um campo Qualquer de endereco no ERP Protheus
_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas (Porem NAO o usamos pois pego da NFE, mas consta no parametro)
_cLocalOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),3,50))
_nTOK		:= _aTEnd[1] - Len(_cLocalOK) //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
_cLocalOK	:= _cLocalOK + Space(_nTOK)
_lRet       := .T.


DbSelectArea("SDA")
DBSetOrder(1)
If DbSeek(xFilial("SDA")+ aProdutos[_nP][1] + _cArmazOK + SD3->D3_NUMSEQ + SD3->D3_DOC )
	
	
	// CRIANDO AQUI REGISTRO NO SB2 PARA CADA PRODUTO PROCESSADO
	DbSelectArea("SB2")
	_aASB2 := GetArea()
	DbSetOrder(1) // Produto + Local
	If !DbSeek(XFilial("SB2")+aProdutos[_nP][1]+_cArmazOK)
		CriaSB2(aProdutos[_nP][1],_cArmazOK)
	EndIf
	
	aC := {}
	aI := {}
	
	aC  :=	{{"DA_PRODUTO",aProdutos[_nP][1]	, nil},;
	{"DA_LOCAL"  ,_cArmazOK						, nil},;
	{"DA_NUMSEQ" ,SD3->D3_NUMSEQ				, nil},;
	{"DA_DOC"    ,SD3->D3_DOC           		, nil}}
	
	AADD(aI,{{"DB_ITEM"   ,"0001"				, nil},;
	{"DB_LOCALIZ",_cLocalOK						, nil},;
	{"DB_QUANT"  ,aProdutos[_nP][2]				, nil},;
	{"DB_DATA"   ,dDATABASE						, nil}})
	
	nModuloOld  := nModulo
	nModulo     := 4
	lMSHelpAuto := .T.
	lMSErroAuto := .F.
	
	SX3->(DbSetOrder(1))
	
	msExecAuto({|x,y,z| u_xmata265(x,y,z)},aC,aI,3) 
     
    //Estava dando erro 
	//msExecAuto({|x,y,z| u_mata265(x,y,z)},aC,aI,3) // Este AQUI FUNCIONA no PONTO DE ENTRADA SF1100I, MAS AQUI NAO
	//msExecAuto({|x,y|mata265(x,y)},aC,aI)
	nModulo := nModuloOld
	
	If lMSErroAuto

		_lRet := .f.
		VTBeep(2)
		VTAlert("Falha no processo de enderecamento via SIGAAUTO","Verifique",.T.,2000)
		
	EndIf
	
EndIf

Return(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ _ImpEntra  ³ Autor ³ Desenv.    ACD      ³ Data ³ 04/04/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime e Gera Etiquetas dso Produtos Novos que entraram   ³±±
±±³          ³ nos estoques atraves da desmontagem                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MultiTek		    								          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _ImpEntra(_nP)

// Variaveis importantes
_aTEnd		:= TamSx3("DB_LOCALIZ") // Tamanho e Tipo de um campo Qualquer de endereco no ERP Protheus
_cArmazOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),1,2))  // Armazem de Vendas
_cLocalOK	:= Alltrim(Substr(GETMV("MV_ALMX01"),3,50))
_nTOK		:= _aTEnd[1] - Len(_cLocalOK) //Quinze eh o tamanho do Campo de Endereco. Tem que ficar com quinze pois senao falha no enderecamento via MSEXECAUTO
_cLocalOK	:= _cLocalOK + Space(_nTOK)


// Codigo do Operador
_cCodSep	:= CBRetOpe()

//Posicionando no SB1
DbSelectArea("SB1")
DBSeek(xFilial("SB1")+aProdutos[_nP][1])

// Chamando o programa de impressao de etiquetas (Ele mesmo gera a etiqueta caso a mesma, ID, nao exista !)
If ExistBlock('IMG01')
	
	// Setando Local de Impressao
	CB5SetImp(CBRLocImp("MV_IACD04"),IsTelNet())
	
	//Se o produto for a Granel
	If !CBProdUnit(aProdutos[_nP][1])
		//Gera somente uma etiqueta do produto a granel com a quantidade movimentada.
		ExecBlock('IMG01',,,{aProdutos[_nP][2],_cCodSep,,1,,,,,_cArmazOk,,SD3->D3_NUMSEQ,,,,,,,,"SD3",_cLocalOk,,0})
		CBLog("01",{aProdutos[_nP][1],aProdutos[_nP][2],NIL,NIL,_cArmazOk,_cLocalOk,SD3->D3_NUMSEQ,,CB0->CB0_CODETI,"MTKACD03 - Produto gerado na Desmontagem"})
	Else
		//Gera a quantidade de etiquetas necessarias
		ExecBlock('IMG01',,,{1,_cCodSep,,aProdutos[_nP][2],,,,,_cArmazOk,,SD3->D3_NUMSEQ,,,,,,,,"SD3",_cLocalOk,,0})
		For _n := 1 to aProdutos[_nP][2] // Quantidade de Etiquetas
			CBLog("01",{aProdutos[_nP][1],1,NIL,NIL,_cArmazOk,_cLocalOk,SD3->D3_NUMSEQ,,CB0->CB0_CODETI,"MTKACD03 - Produto gerado na Desmontagem"})
			DBSelectArea("CB0")
			DbSkip(-1)
		Next

	EndIf
	
	MSCBCLOSEPRINTER()
		
EndIf

Return
