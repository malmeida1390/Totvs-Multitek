#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MT416FIM  ³Autor  ³                       ³ Data ³13.09.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Esta funcao permite efetuar ajustes no SC5 e no SC6          ³±±
±±³          ³com base  na matriz aPedProc que contem                      ³±±
±±³          ³todos os pedidos que foram processados.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User  Function MT416FIM()
Local _aArea := GetArea()
// Armazena as areas no inicio do ponto de entrada ( bloco inserido por Jorge Gomes em 22/02/02
Local _cAreaSCJ:=SCJ->(GetArea())
Local _cAreaSC6:=SC6->(GetArea())
Local _cAreaSC5:=SC5->(GetArea())
Local _cAreaSA1:=SA1->(GetArea())
Local _cAreaSA3:=SA3->(GetArea())
Local _cAreaSB1:=SB1->(GetArea())
Local _cAreaSCK:=SCK->(GetArea())

Local nY      := 0
Local aRecno  := {}
Local nZ      := 0
Local aResult := {}
Local lPrVenda:= .t.
Local dDatPre := ctod("")

Local lGerouSC6:=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta matriz com os Orcamentos selecionados.         ³
//³Esta matriz foi declarada no Inicio mata416pv.       ³
//³Esta matriz e alimentada no MT416PV.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta matriz possui a seguinte estrutura:              ³
//³                                                      ³
//³[1] Numero do Pedido                                  ³
//³[2] Numero do Orcamento Correspondente                ³
//³[3] Durante a geracao do pedido foram deletados itens ³
//³     portando a numeracao do mesmo deve ser corrigida.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O processamento da comissao nao foi efetuada no ponto  ³
//³de entrada MTA416PV devido ser necessario que os       ³
//³campos de comissao estejam no acols mas o cliente      ³
//³nao deseja ver os % de comissao durante o processamento³
//³do Pedido.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³-  No decorrer do processo abaixo cada pedido tera seu % de³
//³comissao gravado no SC6.                                   ³
//³- Os vendedores contemplados seram gravados no SC5.        ³
//³- Sera refeita a ordem do Item caso tenha sido deletado    ³
//³  algum item (Produto Temporario durante a Geracao do      ³
//³   Pedido.                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


For nY:= 1 to LEN(aPedProc)
	
	
	DbSelectArea("SCJ")
	DbSetOrder(1)
	Dbseek(xFilial("SCJ")+aPedProc[nY][2])  // Posiciona o Orcamento
	
	
	dDatPre := SCJ->CJ_X_DTPRE
	
	//
	// NO CABECALHO DO ORCAMENTO - ATUALIZO O CAMPO CJ_X_DTPRE
	//
	DbSelectArea("SCJ")
	RECLOCK("SCJ",.F.)
	If SCJ->CJ_X_DTPRE < dDataBase
		dDatPre := dDataBase
		SCJ->CJ_X_DTPRE := dDatPre
	Endif
	SCJ->CJ_X_NUMPV := aPedProc[nY][1]
	SCJ->(MsUnlock())

	
	//
	// NOS ITENS DO PEDIDO - ATUALIZO O NUMERO DO PEDIDO GERADO
	//
	DbSelectArea("SC6")
	DbSetOrder(1)
	if Dbseek(xFilial("SC6")+aPedProc[nY][1])
		
		aVend:=U_Comissao(aPedProc[nY][2]) // Retorna Vendedores e % de Comissao.
		
		while !SC6->(EOF()) .and. SC6->C6_FILIAL = xFilial("SC6") .and. SC6->C6_NUM = aPedProc[nY][1]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analiza se o item tera direito a comissao em funcao  ³
			//³da rentabilidade obtida com base na Arvore de Encam. ³
			//³caso contrario continuara ZERADA a comissao.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if U_AnaliRet(SC6->C6_PRODUTO,SC6->C6_X_MARGE)
			    DbSelectArea("SC6")
				Reclock("SC6",.F.)
				SC6->C6_COMIS1 := aVend[1][2]
				SC6->C6_COMIS2 := aVend[2][2]
				SC6->C6_COMIS3 := aVend[3][2]
				SC6->C6_COMIS4 := aVend[4][2]
				SC6->C6_COMIS5 := aVend[5][2]
			Else
				Reclock("SC6",.F.)
				SC6->C6_COMIS1 := 0
				SC6->C6_COMIS2 := 0
				SC6->C6_COMIS3 := 0
				SC6->C6_COMIS4 := 0
				SC6->C6_COMIS5 := 0
			Endif
			
			//
			// Posiciona no Cliente de Entrega apenas para gravar o CF corretamente.
			//
			//DbSelectArea("SA1")
			//DbSetORder(1)
			//Dbseek(xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJAENT)  // Posiciona o Orcamento
			
			IF !(SUBSTR(SC6->C6_CF,1,1) = "7") .AND. SM0->M0_CODFIL='01'    // Exportacao nao tem problema somente filial sao paulo.
				SC6->C6_CF := IF(SA1->A1_EST = "SP","5","6")+SUBSTR(SC6->C6_CF,2,3)
			Endif
			MsUnlock()
			   
			//
			// Apoveitar o campo C6_NUMORC para posicionar o SCK e preecher o campo CK_NUMPV
			//
			DbSelectArea("SCK")
			DbSetOrder(1)
			If Dbseek(xFilial("SCK")+SC6->C6_NUMORC)
				Reclock("SCK",.F.)
				SCK->CK_NUMPV := SC6->C6_NUM
				MsUnlock()
			Endif
			
		    DbSelectArea("SC6")
			SC6->(DbSkip())
		Enddo
	Endif
	
	
	DbSelectArea("SC5")
	DbSetOrder(1)
	if Dbseek(xFilial("SC5")+aPedProc[nY][1])
		Reclock("SC5",.F.)
		SC5->C5_VEND1    := aVend[1][1]
		SC5->C5_VEND2    := aVend[2][1]
		SC5->C5_VEND3    := aVend[3][1]
		SC5->C5_VEND4    := aVend[4][1]
		SC5->C5_VEND5    := aVend[5][1]
		
		// COMISSAO POR ITEM LOGO ZERO O C5_COMIS1..5
		SC5->C5_COMIS1   := 0
		SC5->C5_COMIS2   := 0
		SC5->C5_COMIS3   := 0
		SC5->C5_COMIS4   := 0
		SC5->C5_COMIS5   := 0
		
		SC5->C5_X_DTPRE  := dDatPre
		MsUnlock()
	Endif
	
	
Next nY


//
// 01/02/2003 - RELATIVO AO PROCESSO 31 - Solicitacao Sr. Joao
//              Limpar a geracao do Pedido Sempre
//
DbSelectArea("SX1")
DbSetOrder(1)
IF Dbseek("MT416A"+SPACE(4)+"01")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=""
	MsUnlock()
Endif

If Dbseek("MT416A"+SPACE(4)+"02")
	Reclock("SX1",.F.)
	SX1->X1_CNT01:=""
	MsUnlock()
Endif


//
// 01/02/2003 - RELATIVO AO PROCESSO 31 - Solicitacao Sr. Joao
//              Aparecer o numerodo Pedido / Trazer em Branco o Numero do Orcamento
//

// AutoGrLog("       Relacao de Pedidos Gerados      ")
// AutoGrLog("       --------------------------      ")
// AutoGrLog("Numero do Pedido             Orcamento ")

For nY:= 1 to LEN(aPedProc)
	
	//AutoGrLog(aPedProc[nY][1]+SPACE(23)+SUBSTR(aPedProc[nY][2],1,6))
	Aviso("ATENCAO", "Gerado o Pedido:"+aPedProc[nY][1]+"      "+CHR(13)+"Ref.Orcamento:"+SUBSTR(aPedProc[nY][2],1,6),{"&Ok"})
	
Next Ny

//MostraErro()

aPedProc := {}

SCJ->(RestArea(_cAreaSCJ))
SC6->(RestArea(_cAreaSC6))
SC5->(RestArea(_cAreaSC5))
SA1->(RestArea(_cAreaSA1))
SA3->(RestArea(_cAreaSA3))
SB1->(RestArea(_cAreaSB1))
SCK->(RestArea(_cAreaSCK))

RestArea(_aArea)

Return



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Comissao  ³Autor  ³                       ³ Data ³13.09.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Gera uma matriz com os vendedores que compoem o Pedido e     ³±±
±±³          ³com a comissao para cada um dos vendedores.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Numero do Orcamento                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Vetor aVend [1] Vendedor                                     ³±±
±±³          ³            [2] Comissao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Comissao(nOrcam)

Local aVend  := {}
Local _nCont := 0
Local lOrigem:= IIF( "MATA" $ UPPER(Funname()) ,.T.,.F.)  // Gerada pelo Contrato ou Orcamento
Local _aArea  := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no Orcamento           ³
//³Para pegar o cliente e loja +    ³
//³o Vendedor Interno               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lOrigem
	
	DbSelectArea("SCJ")
	DbSetOrder(1)
	If Dbseek(xFilial("SCJ")+nOrcam)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona o Clinete              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA1")
		DbSetOrder(1)
		Dbseek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta matriz com os comissionados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		AADD(aVend,{SCJ->CJ_X_VEND1,0})         // Vendedor Interno.
		
	Endif
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o Clinete              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA1")
	DbSetOrder(1)
	If Dbseek(xFilial("SA1")+M->cCliente+M->cLoja)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta matriz com os comissionados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aVend,{M->cVend1,0})         // Vendedor Interno.
		
	Endif
	
Endif


AADD(aVend,{SA1->A1_X_VEND2,0})
AADD(aVend,{SA1->A1_X_VEND3,0})
AADD(aVend,{SA1->A1_X_VEND4,0})
AADD(aVend,{SA1->A1_X_VEND5,0})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define o % de comissao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA3")
DbSetorder(1)
For _nCont := 1 to len(aVend)
	If !EmptY(aVend[_nCont][1])
		If Dbseek(xFilial("SA3")+aVend[_nCont][1])
			///if lOrigem:= IIF(Funname()$ "MATA415",.T.,.F.)
			// A3_COMIS   % de comissao para venda Spot
			// A3_X_COMIS % de comissao para venda Contrato
			
			// 29.03.06 - Definido atraves da Solicitacao de Suporte 084
			//            que caso o vendedor for 2 e o campo A1_COMIS estiver preechido
			//            o valor da comisso vira do mesmo. alterado tambem MFATC01.PRW calculo simulador
			
			//if _nCont = 2 .and. SA1->A1_COMIS <> 0
			//   aVend[_nCont][2]:=IIf(lOrigem , SA1->A1_COMIS , SA1->A1_COMIS)
			//Else
			//   aVend[_nCont][2]:=IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
			//Endif
			
			If  SCJ->CJ_X_TPVEN = "2"  // 1 = Spot; 2 = Contrato
				
				if  _nCont = 1 //.and. SA1->A1_X_COMII <> 0
					
					aVend[_nCont][2]:=IIf(lOrigem , SA1->A1_X_COMII ,SA3->A3_X_COMIS)
					
				Elseif _nCont = 2 //.and. SA1->A1_COMIS <> 0
					
					aVend[_nCont][2]:=IIf(lOrigem , SA1->A1_COMIS ,SA1->A1_COMIS)
					
				Elseif  _nCont = 3 //.and. SA1->A1_X_COMIE <> 0
					
					aVend[_nCont][2]:=IIf(lOrigem , SA1->A1_X_COMIE    ,SA1->A1_COMIS)
					
				Elseif  _nCont = 4 //.and. SA1->A1_X_COMIG <> 0
					
					aVend[_nCont][2]:=IIf(lOrigem , SA1->A1_X_COMIG ,SA1->A1_COMIS)
					
				else
					
					aVend[_nCont][2]:=IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
					
				Endif
				
			else            
				
				aVend[_nCont][2]:=IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
				
			Endif
			
			
			
		Endif
	Endif
Next _nCont

RestArea(_aArea)

Return(aVend)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AnaliRet  ³Autor  ³                       ³ Data ³13.09.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Analisa se os vendedores teram direito a Comissao.           ³±±
±±³          ³Esta funcao sera util quando Liberado Manualmente.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Produto e Margem Gerada durante a Simulacao.                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T. - Tera direito a comissao.                               ³±±
±±³          ³.F. - Nao tera direiro a comissao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AnaliRet(cProduto,nMargem)
Local lRet        := .T.
Local _aArea      := GetArea()
Local _nMV_MCCOMIS:= GETMV("MV_MCCOMIS")     // % Minimo para receber Comissao.


/*
Foi constatado que existe um bug no processo.
Durante a venda caso nao fosse encontrado a arvore de encaminhamento o sistema
forca 30%  mas no momento de pagar a comissao nao existia esta logica ou seja nao estava
sendo chegada a arvore de encaminhamento e a comissao estava sendo liberada independe
de ter alcancado a Margem de Venda.

Desta forma optamos em criar um paramemtro MV_MCCOMMIS  Percentual de Margem de contribuicao 
minima para margem de contribuicao com o objetivo de mudar a forma de analise no momento de pagamento da comissao.
Deixando de ocorrer atraves da arvore para ocorrer atraves do parametro indicado.

Foi efetuada as seguintes alteracoes:

Programas:

MFATC09.PRW  - Responsavel pela manutencao dos Parametros;
MT416FIM.PRW - Responsavel pela Avaliacao de Comissao ou seja indica se ira pagar ou nao comissao;

Criado Parametro:  MV_MCCOMMIS - Percentual de Margem de Contribuicao Minima p/ Comissao.

*/

//DbSelectArea("SB1")
//DbSetOrder(1)
//DbSeek(xFilial("SB1")+cProduto)

//DbSelectArea("SZH")
//DbSetOrder(2)
//If DbSeek(xFilial("SZH")+SB1->(B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC+B1_X_LMN))
//	if nMargem < SZH->ZH_MCMIN
//		lRet := .F.
//	Endif
//Endif


if nMargem < _nMV_MCCOMIS
	lRet := .F.
Endif


RestArea(_aArea)

Return(lRet)
