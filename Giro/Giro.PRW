#INCLUDE "Fivewin.ch"

#Define _nD_AcmEntr           1
#Define _nD_AcmSaida          2
#Define _nD_Saldo             3
#Define _nD_AcmSld            4
#Define _nD_Acm_dDias         5
#Define _nD_Dias_AcmSld       6
#Define _nD_SaldoMedio        7
#Define _nD_Giro              8
#Define _nD_TamVetor          9
#Define _nD_ENTER         Chr(13)+Chr(10)
#Define _nPGMM_AcmEntr       50
#Define _nPGMM_AcmSaida      51
#Define _nPGMM_Saldo         52
#Define _nPGMM_AcmSld        53
#Define _nPGMM_Acm_dDias     54
#Define _nPGMM_Dias_AcmSld   55
#Define _nPGMM_SaldoMedio    56
#Define _nPGMM_Giro          57


*---------------------------------------------------------------------
User Function _fGiro(_cCodigo, _cIdent, _dDataIni, _dDataFim, lRegua, aSerieM,aSerieD,_lRetVetorG,aSimil,aSku)

//
// IMPORTANTE - O controle do apanhe somente fica nas Saidas
//              F4_X_APANH com relacao as entradas olho somente as que atualizam o estoque.
//


*---------------------------------------------------------------
//
//   Algoritmo para Calculo do Giro de Estoque de uma SKU
//
//   Recebe os seguintes Parametros
//
//   Codigo [Char ]        -> Codigo SKU (B1_COD) ou Codigo EIS + SIMIL
//   Ident [Pertence(S/E)] -> S indica SKU,   E indica EIS
//   DataIni [Date]        -> Data Inicial do Movimento
//   DataFim [Date]        -> Data Final do Movimento
//   lRegua [.t./.f.]      -> .t. para processamento com regua e .f. para sem regua
//   nSaldoIni             -> Saldo da Malha deste item
//
//   _lRetVetorG           -> Se .t., retorno o vetor inteiro. Se .f. (default), retorna o GIRO.
//
//   Retorna Valor do Giro ou -1 em caso de erro OU o vetor inteiro
//
*---------------------------------------------------------------

Local _dDataTmp    := CtoD("")
Local _nNroDias    := 0
Local _aVetor      := {}
Local _nI          := 0
Local _aSld        := {}
Local _aAreaGiro   := {}
Local _cAlmoxPGMM  := ""

//OBSERVACAO IMPORTANTE:
//em 20/06/05, ficou acordado considerar o conteudo de _cAlmoxPGMM (MV_ALMFECH) nos movimentos.
//Passara a ocorrer o filtro dos Almoxarifados que NAO PERTENCEM AOS ALMOXARIFADOS DO FECHAMENTO.

//
// Usadas somente quando se trata do Movigrama
//
//Local nSaida       := 0
//Local nEntrada     := 0
//Local nSaldo       := 0
//Local dData        := ctod("")

Local nPosSimil    := 0

Local nPosSku      := 0
Local _cErro       := ""   //-> Usada para retornar mensagens de erro e para Log de Auditoria (GeraAud)
Local _cDado       := ""   //-> Variavel Auxiliar na gravacao do dados pra Auditoria
Local _aDado       := {}   //-> Variavel Auxiliar na gravacao do dados pra Auditoria
Local _aDivDados   := {}   //-> Variavel Auxiliar na gravacao do dados pra Auditoria

If Type("_ChaveAud") = "U"   // Variaveis utilizadas durante Analise Fechamento Mensal Planilha
	Private _aLog    := {}
	Private _aAud    := {}
	Private _ChaveAud:= ""
Endif

Private cSimil_Eis   := Substr(_cCodigo,21,Len(_cCodigo)-20) + Substr(_cCodigo,1,20)


Default _cCodigo     := ""          // Codigo [Char 15]
Default _cIdent      := "S"         // Ident [Pertence(S/E)]
Default _dDataIni    := Date()      // DataIni [Date]
Default _dDataFim    := Date()      // DataFim [Date]
Default lRegua       := .T.         // Regua [.t./.f.]
Default aSerieM      := {}
Default aSerieD      := {}
Default _lRetVetorG  := .f.
Default aSimil       := {}
Default aSku         := {}



//-> Para efeito de testes...
//-> Se mudar o criterio, nao esquecer de alterar em Grafico2.prw tambem
_cAlmoxPGMM  := GetMV("MV_ALMFECH")


//---------------------------------> Inicio das Validacoes dos Parametros Recebidos


If  !Upper(_cIdent) $ "E|S"
	_cErro := "Ocorreu erro durante a utilizacao do funcao _fGiro o conteudo do parametro _cIdent esta diferente de S ou E"
	
	Aviso("ATENCAO", _cErro ,{"&Ok"})
	
	Return(_aVetor)
EndIf


If  _dDataIni > date()
	_cErro := "Ocorreu erro durante a utilizacao do funcao _fGiro a data inicial esta maior que a data atual"
	
	Aviso("ATENCAO", _cErro ,{"&Ok"})
	
	Return(_aVetor)
EndIf


If Empty(AllTrim(_cCodigo))
	_cErro := "Ocorreu erro durante a utilizacao do funcao _fGiro o conteudo do parametro _cCodigo esta vazio"
	
	Aviso("ATENCAO", _cErro	,{"&Ok"})
	
	Return(_aVetor)
EndIf

//---------------------------------> Fim das Validacoes dos Parametros Recebidos

// _ChaveAud == Simil+EIS

_aAreaGiro := GetArea()

_dDataTmp    := _dDataIni
_nNroDias    := 0
_aVetor      := {}


//-> Inicializando Vetor
For _nI := 1 To _nD_TamVetor
	Aadd(_aVetor,0)
Next _nI

If _cIdent == "S" //-> Por SKU
	
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		GeraAud("")
		GeraAud("ERRO DE PROCESSO - Teoricamente, esta mensagem nao pode aparecer dentro")
		GeraAud("                   do Log. O calculo do Giro dever ser feito para SIMIL+EIS")
		GeraAud("                   e, neste momento, o conteudo da variavel _cIdent (Parametro ")
		GeraAud("                   passado ao Giro) eh 'S' (de SKU).")
		GeraAud("")
	Endif
	
	/*---------------------------------------------------------------------------
	// Chamada de Funcao Externa
	// MFATC12.PRW - Marcelo Almeida
	//
	// User Function SaldoSb2(cProduto)
	// Return(aSaldo)
	//
	// Retorna VETOR com 3 linhas contendo os saldos de Malha, da Matriz e das Filiais
	//       Coluna 1 - Saldo do Estoque Disponivel
	//       Coluna 2 - Controla Estoque  - Qtde nossa em Poder de Terceiros
	//       Coluna 3 - Controla Estoque  - Qtde Terceiros em Nosso Poder
	//       Coluna 4 - Nao Controla Est. - Saldo em Poder de Terceiros
	//       Coluna 5 - Quantidade reservada - Pedido de Venda
	//       Coluna 6 - Quantidade Empenhada
	//       Coluna 7 - Prevista para entrar (via Compras ou OP)
	//       Coluna 8 - Em pedido de Vendas ainda nao liberado p/ Faturar
	//       Coluna 9 - Disponivel + Prevista para Entrar
	//
	// Se _lTFiliais == .f.
	//     Matriz (Linha 2) - Eh o que interessa!!!!!!!
	// Senao
	//     Matriz (Linha 2) + Filiais (Linha 3) - Eh o que interessa!!!!!!!
	---------------------------------------------------------------------------*/
	
	If  Len(aSku) = 0
		nPosSku   := 0
	Else
		nPosSku   := aScan( aSku , {|x| x[1]+x[2] == _cCodigo })
	Endif
	
	if  nPosSku   = 0
		
      //17.10.2006 - Considerar todos Armazens = _aSld := U_SaldoSb2(_cCodigo,_cAlmoxPGMM)
		//_aVetor[_nD_Saldo]  += _aSld[1,10]        
		_aSld := U_SaldoSb9(_cCodigo)
		_aVetor[_nD_Saldo]  += _aSld[1,1]        
		
		
	Else
		
		_aVetor[_nD_Saldo]  += aSKU[nPosSku][16]  // [16] Saldo Fisico do Fechamento com base no SB9
		
	Endif
	
Else //-> Por EIS
	
	If  Len(aSimil) = 0
		nPosSimil   := 0
	Else
		nPosSimil   := aScan( aSimil , {|x| x[1]+x[2] == cSimil_Eis })
	Endif
	
	if  nPosSimil = 0
		
		DbSelectArea("SB1")
		DbOrderNickName("B1SIMIL")   //-> Por Simil + EIS
		If DbSeek( xFilial("SB1") + cSimil_Eis )
			
			While SB1->( !Eof() ) .And. xFilial("SB1")==SB1->B1_FILIAL .And. ;
				SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+;
				B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)==Substr(_cCodigo,1,20) .And.;
				B1_X_SIMIL == Substr(_cCodigo,21,Len(_cCodigo)-20)
				
				DbSelectArea("SB1")
				_aArea     := GetArea()
				
				DbSelectArea("Z10")
				DbSetOrder(1)
				DbSeek( xFilial("Z10") + Substr(_cCodigo,1,20) )
				
				DbSelectArea("Z10")
				If !Found()
					SB1->( DbSkip() )
					Loop
				EndIf
				
				/*---------------------------------------------------------------------------
				// Chamada de Funcao Externa
				// MFATC12.PRW - Marcelo Almeida
				//
				// User Function SaldoSb2(cProduto)
				// Return(aSaldo)
				//
				// Retorna VETOR com 3 linhas contendo os saldos de Malha, da Matriz e das Filiais
				//       Coluna 1 - Saldo do Estoque Disponivel
				//       Coluna 2 - Controla Estoque  - Qtde nossa em Poder de Terceiros
				//       Coluna 3 - Controla Estoque  - Qtde Terceiros em Nosso Poder
				//       Coluna 4 - Nao Controla Est. - Saldo em Poder de Terceiros
				//       Coluna 5 - Quantidade reservada - Pedido de Venda
				//       Coluna 6 - Quantidade Empenhada
				//       Coluna 7 - Prevista para entrar (via Compras ou OP)
				//       Coluna 8 - Em pedido de Vendas ainda nao liberado p/ Faturar
				//       Coluna 9 - Disponivel + Prevista para Entrar
				//
				// Se _lTFiliais == .f.
				//     Matriz (Linha 2) - Eh o que interessa!!!!!!!
				// Senao
				//     Matriz (Linha 2) + Filiais (Linha 3) - Eh o que interessa!!!!!!!
				---------------------------------------------------------------------------*/
				
	         //17.10.2006 - Considerar todos Armazens			_aSld := U_SaldoSb2(SB1->B1_COD,_cAlmoxPGMM)
				//_aVetor[_nD_Saldo]  += _aSld[1,10]  // FISICO
				_aSld := U_SaldoSb9(SB1->B1_COD)
				_aVetor[_nD_Saldo]  += _aSld[1,1]  // FISICO
				
				
				DbSelectArea("SB1")
				RestArea(_aArea)
				
				SB1->( DbSkip() )
			EndDo
			
		Endif
		
	Else
		
		_aVetor[_nD_Saldo]  += aSimil[nPosSimil][58] // FISICO DO FECHAMENTO COM BASE NO SB9
		
	Endif
	
EndIf


If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	_aDado := {}
	Aadd(_aDado,{"Simil+EIS"          ,50, _ChaveAud })
	Aadd(_aDado,{"Pos Simil no Vetor" ,0 , nPosSimil })
	Aadd(_aDado,{"SaldoSB9"           ,15, _aVetor[_nD_Saldo] })
	
	_cDado := ""
	
	GeraAud("")
	
	/* Recebe vetor _aDado e cria cabecalho - Nao retorna nada!*/
	_CriaCabec(_aDado,_cDado)
	
	GeraAud("")
	
Endif

If lRegua
	Processa({|| _fLeMov(_cCodigo, _cIdent, @_aVetor , _dDataIni, _dDataFim, lRegua, aSerieM, aSerieD, _cAlmoxPGMM) })
Else
	_fLeMov(_cCodigo, _cIdent, @_aVetor , _dDataIni, _dDataFim, lRegua,aSerieM,aSerieD, _cAlmoxPGMM)
EndIf

RestArea(_aAreaGiro)

Return IIf(_lRetVetorG==.f.,_aVetor[_nD_Giro],_aVetor)




*---------------------------------------------------------------------------
Static Function _fLeMov( _cCodigo, _cIdent, _aVetor , _dDataIni, _dDataFim, lRegua, aSerieM, aSerieD, _cAlmoxPGMM )

//-> Selecao dos Dados que geraram apanhe
// Select SD1 Union               //-> Itens de Entrada
// Select SD2 Union               //-> Itens de Saida
// Select SD3                     //-> Itens de Mov Interna


/*
OBSERVACAO IMPORTANTE:
em 20/06/05, ficou acordado considerar o conteudo de _cAlmoxPGMM (MV_ALMFECH) nos movimentos.
Passara a ocorrer o filtro dos Almoxarifados que NAO PERTENCEM AOS ALMOXARIFADOS DO FECHAMENTO.
*/

Local _nTotReg    := 0
Local _cQuery     := ""
Local _cAlias     := "TRB"
Local _dDataAtual := CtoD("")


//
//  Apenas monta Count
//
If  lRegua
	If _cIdent == "S"     //-> SKU

		_cQuery := " SELECT COUNT(*) TOTAL "
		_cQuery += " FROM "
		_cQuery += RetSqlName("SD1")+" SD1, "
		_cQuery += RetSqlName("SF4")+" SF4 "
		_cQuery += " WHERE "
		_cQuery += " D1_FILIAL<>'  ' AND "
		_cQuery += " D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += " D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += " D1_COD = '"+_cCodigo+"' AND "
      //17.10.2006 - Considerar todos Armazens
		//_cQuery += " D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
		_cQuery += " D1_TES = F4_CODIGO AND "
      _cQuery += " F4_ESTOQUE = 'S' AND "
		_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
		_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
		_cQuery += " SD1.D_E_L_E_T_<>'*' "


		_cQuery += " UNION "

		_cQuery += " SELECT COUNT(*) TOTAL "
		_cQuery += " FROM "
		_cQuery += RetSqlName("SD2")+" SD2, "
		_cQuery += RetSqlName("SF4")+" SF4 "
		_cQuery += " WHERE "
		_cQuery += " D2_FILIAL<>'  ' AND "
		_cQuery += " D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += " D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += " D2_COD = '"+_cCodigo+"' AND "
      //17.10.2006 - Considerar todos Armazens
		//_cQuery += " D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
		_cQuery += " D2_TES = F4_CODIGO AND "
		//10.10.2006 _cQuery += " F4_X_APANH = 'S' AND "
      _cQuery += " F4_ESTOQUE = 'S' AND "
		_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
		_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
		_cQuery += " SD2.D_E_L_E_T_<>'*' "
		

		_cQuery += " UNION "

		_cQuery += " SELECT COUNT(*) TOTAL "
		_cQuery += " FROM "
		_cQuery += RetSqlName("SD3")+" SD3 "
		//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5 "
		_cQuery += " WHERE "
		_cQuery += " D3_FILIAL<>'  ' AND "
		_cQuery += " D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += " D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += " D3_COD = '"+_cCodigo+"' AND "
      //17.10.2006 - Considerar todos Armazens
      //_cQuery += " D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
      _cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
		//10.10.2006 _cQuery += " D3_TM = F5_CODIGO AND "
		//10.10.2006 _cQuery += " F5_X_APANH = 'S' AND "
		//10.10.2006 _cQuery += " F5_FILIAL = '"+xFilial("SF5")+"' AND "
		//10.10.2006 _cQuery += " SF5.D_E_L_E_T_<>'*' AND "
		_cQuery += " SD3.D_E_L_E_T_<>'*' "
		

	Else   //-> _cIdent == "E"  EIS
		

		_cQuery := " SELECT COUNT(*) TOTAL "
		_cQuery += _nD_ENTER+" FROM "
		_cQuery += _nD_ENTER+RetSqlName("SD1")+" SD1, "
		_cQuery += _nD_ENTER+RetSqlName("SB1")+" SB1, "
		_cQuery += _nD_ENTER+RetSqlName("SF4")+" SF4 "
		_cQuery += _nD_ENTER+" WHERE "
		_cQuery += _nD_ENTER+" D1_FILIAL<>'  ' AND "
		_cQuery += _nD_ENTER+" D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += _nD_ENTER+" D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += _nD_ENTER+" D1_COD = B1_COD AND "
		_cQuery += _nD_ENTER+" B1_X_EIS01='"+Substr(_cCodigo,1,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS02='"+Substr(_cCodigo,3,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS03='"+Substr(_cCodigo,5,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS04='"+Substr(_cCodigo,7,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS05='"+Substr(_cCodigo,9,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_SIMIL = '"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "
      //17.10.2006 - Considerar todos Armazens
      //_cQuery += _nD_ENTER+" D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
		_cQuery += _nD_ENTER+" D1_TES = F4_CODIGO AND "
      _cQuery += _nD_ENTER+" F4_ESTOQUE = 'S' AND "
		_cQuery += _nD_ENTER+" F4_FILIAL = '"+xFilial("SF4")+"' AND "
		_cQuery += _nD_ENTER+" B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQuery += _nD_ENTER+" SB1.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" SF4.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" SD1.D_E_L_E_T_<>'*' "
		
		_cQuery += _nD_ENTER+" UNION "

		_cQuery += _nD_ENTER+" SELECT COUNT(*) TOTAL "
		_cQuery += _nD_ENTER+" FROM "
		_cQuery += RetSqlName("SD2")+" SD2, "
		_cQuery += RetSqlName("SB1")+" SB1, "
		_cQuery += RetSqlName("SF4")+" SF4 "
		_cQuery += _nD_ENTER+" WHERE "
		_cQuery += _nD_ENTER+" D2_FILIAL<>'  ' AND "
		_cQuery += _nD_ENTER+" D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += _nD_ENTER+" D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += _nD_ENTER+" D2_COD = B1_COD AND "
		_cQuery += _nD_ENTER+" B1_X_EIS01='"+Substr(_cCodigo,1,2) +"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS02='"+Substr(_cCodigo,3,2) +"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS03='"+Substr(_cCodigo,5,2) +"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS04='"+Substr(_cCodigo,7,2) +"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS05='"+Substr(_cCodigo,9,2) +"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_SIMIL='"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "
      //17.10.2006 - Considerar todos Armazens
      //_cQuery += _nD_ENTER+" D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
		_cQuery += _nD_ENTER+" D2_TES = F4_CODIGO AND "
		//10.10.2006 _cQuery += _nD_ENTER+" F4_X_APANH = 'S' AND "
      _cQuery += _nD_ENTER+" F4_ESTOQUE = 'S' AND "
		_cQuery += _nD_ENTER+" F4_FILIAL = '"+xFilial("SF4")+"' AND "
		_cQuery += _nD_ENTER+" B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQuery += _nD_ENTER+" SB1.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" SF4.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" SD2.D_E_L_E_T_<>'*' "
		
		_cQuery += _nD_ENTER+" UNION "

		_cQuery += _nD_ENTER+" SELECT COUNT(*) TOTAL "
		_cQuery += _nD_ENTER+" FROM "
		_cQuery += RetSqlName("SD3")+" SD3, "
		_cQuery += RetSqlName("SB1")+" SB1  "
		//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5 "
		_cQuery += _nD_ENTER+" WHERE "
		_cQuery += _nD_ENTER+" D3_FILIAL<>'  ' AND "
		_cQuery += _nD_ENTER+" D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
		_cQuery += _nD_ENTER+" D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
		_cQuery += _nD_ENTER+" D3_COD = B1_COD AND "
		_cQuery += _nD_ENTER+" B1_X_EIS01='"+Substr(_cCodigo,1,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS02='"+Substr(_cCodigo,3,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS03='"+Substr(_cCodigo,5,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS04='"+Substr(_cCodigo,7,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS05='"+Substr(_cCodigo,9,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
		_cQuery += _nD_ENTER+" B1_X_SIMIL = '"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "
      //17.10.2006 - Considerar todos Armazens
      //_cQuery += _nD_ENTER+" D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
      _cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
		//10.10.2006 _cQuery += _nD_ENTER+" D3_TM = F5_CODIGO AND "
		//10.10.2006 _cQuery += _nD_ENTER+" F5_X_APANH = 'S' AND "
		//10.10.2006 _cQuery += _nD_ENTER+" F5_FILIAL = '"+xFilial("SF5")+"' AND "
		//10.10.2006 _cQuery += _nD_ENTER+" SF5.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQuery += _nD_ENTER+" SB1.D_E_L_E_T_<>'*' AND "
		_cQuery += _nD_ENTER+" SD3.D_E_L_E_T_<>'*' "

		
	EndIf
	
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		
		GeraAud("")
		GeraAud("Calculo do Giro - Contagem de Linhas")
		GeraAud("====================================")
		GeraAud("")
		GeraAud(_cQuery)
		GeraAud("")
	Endif
	
	
   MemoWrit("Giro001.Sql",_cQuery)   //   Apenas utilizado para validar a query.
	  
	
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)
	
	While (_cAlias)->(!Eof())
		_nTotReg:= _nTotReg + (_cAlias)->TOTAL
		(_cAlias)->( DbSkip() )
	EndDo
	
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		
		GeraAud("")
		GeraAud("Resultado da Query: " + PadL( _nTotReg,10," " ) )
		GeraAud("")
		GeraAud("")
		
	Endif
	
	ProcRegua( _nTotReg )
	
	DbSelectArea( _cAlias )
	DbCloseArea()
	
EndIf


If _cIdent == "S"     //-> SKU

	_cQuery := " SELECT D1_EMISSAO DATA, D1_QUANT QTD, 'E' ID, F4_CODIGO COD_INT, SD1.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD1")+" SD1, "+_nD_ENTER
	_cQuery += RetSqlName("SF4")+" SF4 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D1_FILIAL<>'  ' AND "
	_cQuery += " D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D1_COD = '"+_cCodigo+"' AND "+_nD_ENTER
   // 17.10.2006 - Considerar todos Armazens
   // _cQuery += " D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
	_cQuery += " D1_TES = F4_CODIGO AND "+_nD_ENTER
   _cQuery += " F4_ESTOQUE = 'S' AND "+_nD_ENTER
	_cQuery += " D1_FILIAL<>'  ' AND "+_nD_ENTER
	_cQuery += " SF4.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD1.D_E_L_E_T_<>'*' "+_nD_ENTER

	_cQuery += " UNION "+_nD_ENTER

	_cQuery += " SELECT D2_EMISSAO DATA, D2_QUANT QTD, 'S' ID, F4_CODIGO COD_INT, SD2.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD2")+" SD2, "+_nD_ENTER
	_cQuery += RetSqlName("SF4")+" SF4 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D2_FILIAL<>'  ' AND "
	_cQuery += " D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D2_COD = '"+_cCodigo+"' AND "+_nD_ENTER
   //17.10.2006 - Considerar todos Armazens
	//_cQuery += " D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
	_cQuery += " D2_TES = F4_CODIGO AND "+_nD_ENTER
	//10.10.2006 _cQuery += " F4_X_APANH = 'S' AND "+_nD_ENTER
   _cQuery += " F4_ESTOQUE = 'S' AND "+_nD_ENTER
	_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "+_nD_ENTER
	_cQuery += " SF4.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD2.D_E_L_E_T_<>'*' "+_nD_ENTER

	_cQuery += " UNION "+_nD_ENTER

	_cQuery += " SELECT D3_EMISSAO DATA, D3_QUANT QTD, 'M' ID,  D3_TM  COD_INT, SD3.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD3")+" SD3 "+_nD_ENTER
	//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D3_FILIAL<>'  ' AND "
	_cQuery += " D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D3_COD = '"+_cCodigo+"' AND "+_nD_ENTER
   //17.10.2006 - Considerar todos Armazens
   //_cQuery += " D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
   _cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
	//10.10.2006 _cQuery += " D3_TM = F5_CODIGO AND "+_nD_ENTER
	//10.10.2006 _cQuery += " F5_X_APANH = 'S' AND "+_nD_ENTER
	//10.10.2006 _cQuery += " F5_FILIAL = '"+xFilial("SF5")+"' AND "+_nD_ENTER
	//10.10.2006 _cQuery += " SF5.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD3.D_E_L_E_T_<>'*' "+_nD_ENTER
	_cQuery += " ORDER BY DATA DESC, ID, COD_INT "+_nD_ENTER
	
	
Else   //-> _cIdent == "E"  EIS
	
	_cQuery := " SELECT D1_EMISSAO DATA, D1_QUANT QTD, 'E' ID, F4_CODIGO COD_INT, SD1.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD1")+" SD1, "+_nD_ENTER
	_cQuery += RetSqlName("SB1")+" SB1, "+_nD_ENTER
	_cQuery += RetSqlName("SF4")+" SF4 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D1_FILIAL<>'  ' AND "
	_cQuery += " D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D1_COD = B1_COD AND "+_nD_ENTER
	_cQuery += " B1_X_EIS01='"+Substr(_cCodigo,1,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS02='"+Substr(_cCodigo,3,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS03='"+Substr(_cCodigo,5,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS04='"+Substr(_cCodigo,7,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS05='"+Substr(_cCodigo,9,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_SIMIL = '"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "+_nD_ENTER
   //17.10.2006 - Considerar todos Armazens
   //_cQuery += " D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
 	_cQuery += " D1_TES = F4_CODIGO AND "+_nD_ENTER
   _cQuery += " F4_ESTOQUE = 'S' AND "+_nD_ENTER
	_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "+_nD_ENTER
	_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "+_nD_ENTER
	_cQuery += " SB1.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SF4.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD1.D_E_L_E_T_<>'*' "+_nD_ENTER

	_cQuery += " UNION "+_nD_ENTER

	_cQuery += " SELECT D2_EMISSAO DATA, D2_QUANT QTD, 'S' ID, F4_CODIGO COD_INT, SD2.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD2")+" SD2, "+_nD_ENTER
	_cQuery += RetSqlName("SB1")+" SB1, "+_nD_ENTER
	_cQuery += RetSqlName("SF4")+" SF4 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D2_FILIAL<>'  ' AND "
	_cQuery += " D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D2_COD = B1_COD AND "+_nD_ENTER
	_cQuery += " B1_X_EIS01='"+Substr(_cCodigo,1,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS02='"+Substr(_cCodigo,3,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS03='"+Substr(_cCodigo,5,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS04='"+Substr(_cCodigo,7,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS05='"+Substr(_cCodigo,9,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_SIMIL = '"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "+_nD_ENTER
   //17.10.2006 - Considerar todos Armazens
   //_cQuery += " D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
	_cQuery += " D2_TES = F4_CODIGO AND "+_nD_ENTER
	//10.10.2006_cQuery += " F4_X_APANH = 'S' AND "+_nD_ENTER
   _cQuery += " F4_ESTOQUE = 'S' AND "+_nD_ENTER
	_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "+_nD_ENTER
	_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "+_nD_ENTER
	_cQuery += " SB1.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SF4.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD2.D_E_L_E_T_<>'*' "+_nD_ENTER
	
	_cQuery += " UNION "+_nD_ENTER

	_cQuery += " SELECT D3_EMISSAO DATA, D3_QUANT QTD, 'M' ID, D3_TM COD_INT, SD3.R_E_C_N_O_ "+_nD_ENTER
	_cQuery += " FROM "+_nD_ENTER
	_cQuery += RetSqlName("SD3")+" SD3, "+_nD_ENTER
	_cQuery += RetSqlName("SB1")+" SB1  "+_nD_ENTER
	//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5 "+_nD_ENTER
	_cQuery += " WHERE "+_nD_ENTER
	_cQuery += " D3_FILIAL<>'  ' AND "
	_cQuery += " D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "+_nD_ENTER
	_cQuery += " D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "+_nD_ENTER
	_cQuery += " D3_COD = B1_COD AND "+_nD_ENTER
	_cQuery += " B1_X_EIS01='"+Substr(_cCodigo,1,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS02='"+Substr(_cCodigo,3,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS03='"+Substr(_cCodigo,5,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS04='"+Substr(_cCodigo,7,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS05='"+Substr(_cCodigo,9,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS06='"+Substr(_cCodigo,11,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS07='"+Substr(_cCodigo,13,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS08='"+Substr(_cCodigo,15,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS09='"+Substr(_cCodigo,17,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_EIS10='"+Substr(_cCodigo,19,2)+"' AND "+_nD_ENTER
	_cQuery += " B1_X_SIMIL = '"+Substr(_cCodigo,21,Len(_cCodigo)-20)+"' AND "+_nD_ENTER 
   //17.10.2006 - Considerar todos Armazens
   //_cQuery += " D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
   _cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
	//10.10.2006 _cQuery += " D3_TM = F5_CODIGO AND "+_nD_ENTER
	//10.10.2006_cQuery += " F5_X_APANH = 'S' AND "+_nD_ENTER
	//10.10.2006 _cQuery += " F5_FILIAL = '"+xFilial("SF5")+"' AND "+_nD_ENTER
	//10.10.2006 _cQuery += " SF5.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "+_nD_ENTER
	_cQuery += " SB1.D_E_L_E_T_<>'*' AND "+_nD_ENTER
	_cQuery += " SD3.D_E_L_E_T_<>'*' "+_nD_ENTER
	_cQuery += " ORDER BY DATA DESC, ID, COD_INT "+_nD_ENTER
	
EndIf

MemoWrit("Giro002.Sql",_cQuery)

If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	
	if .f.
		GeraAud("Calculo do Giro - Massa de Dados")
		GeraAud("================================")
		GeraAud("")
		GeraAud(_cQuery)
		GeraAud("")
		GeraAud("Simil + EIS em analise: "+_ChaveAud)
	Else
		GeraAud("")
		GeraAud("Calculo do Giro - Massa de Dados")
		GeraAud("================================")
		GeraAud("")
		GeraAud("Caso necessario o  script utilizado para filtrar a massa de Dados foi gerado no arquivo")
		GeraAud("Giro001.Sql gravado dentro do diretorio SIGAADV.")
		GeraAud("")
		GeraAud("Simil + EIS em analise: "+_ChaveAud)
	EndIf
Endif

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)

TcSetField(_cAlias,"DATA","D",8,0)


_lPrimeiraVez := .t.

_dDataAnter := _dDataFim


/* Basicamente, o TEMP tem Data, Qtd, ID (E, S, M) e CodID (TES ou TM) */
/* Cabec:  Data        Qtd         ID  COD  */
/*         ==========  ==========  ==  ===  */

/* O Vetor que acumula os dados*/
/*
_nD_AcmEntr       1
_nD_AcmSaida      2
_nD_Saldo         3
_nD_AcmSld        4
_nD_Acm_dDias     5
_nD_Dias_AcmSld   6
_nD_SaldoMedio    7
_nD_Giro          8
_nD_TamVetor      9
*/

While (_cAlias)->( !Eof() )
	
	_dDataAtual := (_cAlias)->DATA
	
	_aSldMovigr := {0,0,Ctod("")}
	
	_aDivDados	:= {}
	
	While (_cAlias)->( !Eof() ) .And. (_cAlias)->DATA == _dDataAtual
		
		_aSldMovigr[3] := (_cAlias)->DATA
		
		Do Case
			
			Case (_cAlias)->ID == "E"
				
				_aVetor[_nD_Saldo]   :=  _aVetor[_nD_Saldo] - (_cAlias)->QTD
				_aVetor[_nD_AcmEntr] :=  _aVetor[_nD_AcmEntr] + (_cAlias)->QTD
				
				_aSldMovigr[1] := _aSldMovigr[1]+(_cAlias)->QTD
				
			Case (_cAlias)->ID == "S"
				
				_aVetor[_nD_Saldo]    :=  _aVetor[_nD_Saldo] + (_cAlias)->QTD
				_aVetor[_nD_AcmSaida] :=  _aVetor[_nD_AcmSaida] + (_cAlias)->QTD
				
				_aSldMovigr[2] := _aSldMovigr[2]+(_cAlias)->QTD
				
			Case (_cAlias)->ID == "M"
				
				If (_cAlias)->COD_INT < '500'
					_aVetor[_nD_Saldo] :=  _aVetor[_nD_Saldo] - (_cAlias)->QTD
					_aVetor[_nD_AcmEntr] :=  _aVetor[_nD_AcmEntr] + (_cAlias)->QTD
					
					_aSldMovigr[1] := _aSldMovigr[1]+(_cAlias)->QTD
					
				Else     //-> COD_INT > 500
					_aVetor[_nD_Saldo] :=  _aVetor[_nD_Saldo] + (_cAlias)->QTD
					_aVetor[_nD_AcmSaida] :=  _aVetor[_nD_AcmSaida] + (_cAlias)->QTD
					
					_aSldMovigr[2] := _aSldMovigr[2]+(_cAlias)->QTD
					
				EndIf
				
		Endcase
		
		//-> Acumula pra descarregar na Auditoria
		//-> DATA, QTD, ID, COD_INT
		Aadd(_aDivDados,{(_cAlias)->DATA, (_cAlias)->QTD, (_cAlias)->ID, (_cAlias)->COD_INT})
		
		(_cAlias)->( DbSkip() )
		
		If  lRegua
			IncProc()
		EndIf
		
	EndDo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³O trecho abaixo e ativado quando a funcao e chamada      ³
	//³apartir do Movigrama para tanto deve possuir as matrizes ³
	//³aSerieD e aSerieM ativas.                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if  Len(aSerieD) != 0 .and. Len(aSerieM) != 0
		
		//nSaida   := _aVetor[_nD_AcmSaida]
		nSaida   :=	_aSldMovigr[2]
		
		//nEntrada := _aVetor[_nD_AcmEntr]
		nEntrada := _aSldMovigr[1]
		
		nSaldo   := _aVetor[_nD_Saldo]
		//dData    := (_cAlias)->DATA
		
		dData    := _aSldMovigr[3]
		
		U_ProcVG(aSerieM,aSerieD,nSaldo,nEntrada,nSaida,dData)
		
	Endif
	
	//-> Mudou a Data - Grava dados pra Auditoria
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		
		GeraAud("")
		GeraAud("Massa de Dados de "+DtoC(_dDataAtual))
		/* Cabec:  Data        Qtd         ID          COD         */
		/*         ==========  ==========  ==========  ==========  */
		
		GeraAud("Data        Qtd         ID          COD       	")
		GeraAud("==========  ==========  ==========  ==========  ")
		
		For _nI := 1 To Len(_aDivDados)
			_cDado := ""
			For _nJ := 1 To Len(_aDivDados[_nI])
				_cDado := _cDado + PadL(_aDivDados[_nI,_nJ],10," ") + Space(2)
			Next _nJ
			GeraAud(_cDado)
		Next _nI
		
	EndIf
	
	If _dDataAnter > _dDataAtual
		
		_nNroDias   := _dDataAnter - _dDataAtual
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Acumuladores: Data Atual "+DtoC(_dDataAtual)+ " Data Anterior: "+DtoC(_dDataAnter)+ " Dif. Dias: "+PadL(_nNroDias,5," ") )
		EndIf
		
		_dDataAnter := _dDataAtual
		
		//-> Somatorio da Diferenca de Dias
		//-> (Dif entre a Dt da Ult Mov e esta Mov)
		_aVetor[_nD_Acm_dDias] :=  _aVetor[_nD_Acm_dDias] + _nNroDias
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Somatorio da Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Acm_dDias]) )
			GeraAud("Calculo ----> "+Str(_aVetor[_nD_Acm_dDias] - _nNroDias) + Space(1) + " + " +Str(_nNroDias) + Space(1) + " = " + Str(_aVetor[_nD_Acm_dDias]) )
		EndIf
		
		//-> Acumulado do _nD_Saldo * Diferenca de Dias
		//-> (Dif entre a Dt da Ult Mov e esta Mov)
		_aVetor[_nD_Dias_AcmSld] := _aVetor[_nD_Dias_AcmSld] + (_aVetor[_nD_Saldo]*_nNroDias)
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Acumulado do _nD_Saldo * Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Dias_AcmSld]) )
			GeraAud("Calculo ----> "+Str( _aVetor[_nD_Dias_AcmSld] - (_aVetor[_nD_Saldo]*_nNroDias) ) + Space(1) + " + (" +Str(_aVetor[_nD_Saldo]) + Space(1) + " * " + Str(_nNroDias) + ") = " + Str(_aVetor[_nD_Dias_AcmSld]) )
		EndIf
	Else
		
		_nNroDias := 0
		
	EndIf
	
	/*
	If _dDataAtual > _dDataAnter .And. !Eof()
	
	_nNroDias   := _dDataAtual - _dDataAnter
	_dDataAtual := (_cAlias)->DATA
	
	Else
	
	_nNroDias := 0
	
	EndIf
	
	//-> Somatorio da Diferenca de Dias
	//-> (Dif entre a Dt da Ult Mov e esta Mov)
	_aVetor[_nD_Acm_dDias] :=  _aVetor[_nD_Acm_dDias] + _nNroDias
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	GeraAud("")
	GeraAud("Somatorio da Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Acm_dDias]) )
	EndIf
	
	//-> Acumulado do _nD_Saldo * Diferenca de Dias
	//-> (Dif entre a Dt da Ult Mov e esta Mov)
	_aVetor[_nD_Dias_AcmSld]:= _aVetor[_nD_Dias_AcmSld] + (_aVetor[_nD_Saldo]*_nNroDias)
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	GeraAud("")
	GeraAud("Acumulado do _nD_Saldo * Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Dias_AcmSld]) )
	EndIf
	*/
	
	
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		
		GeraAud("")
		GeraAud("Dados do Vetor ate o momento:")
		/*
		_nD_AcmEntr       1
		_nD_AcmSaida      2
		_nD_Saldo         3
		_nD_AcmSld        4
		_nD_Acm_dDias     5
		_nD_Dias_AcmSld   6
		_nD_SaldoMedio    7
		_nD_Giro          8
		*/
		
		_aDado := {}
		Aadd(_aDado,{"AcmEntr"       ,10, _aVetor[_nD_AcmEntr]     })
		Aadd(_aDado,{"AcmSaida"      ,10, _aVetor[_nD_AcmSaida]    })
		Aadd(_aDado,{"Saldo"         ,10, _aVetor[_nD_Saldo]       })
		Aadd(_aDado,{"AcmSld"        ,10, _aVetor[_nD_AcmSld]      })
		Aadd(_aDado,{"Acm_dDias"     ,10, _aVetor[_nD_Acm_dDias]   })
		Aadd(_aDado,{"Dias_AcmSld"   ,11, _aVetor[_nD_Dias_AcmSld] })
		Aadd(_aDado,{"SaldoMedio"    ,10, _aVetor[_nD_SaldoMedio]  })
		Aadd(_aDado,{"Giro"          ,10, _aVetor[_nD_Giro]        })
		
		_cDado := ""
		
		GeraAud("")
		
		/* Recebe vetor _aDado e cria cabecalho - Nao retorna nada!*/
		_CriaCabec(_aDado,_cDado)
		
		//GeraAud("")
		
	EndIf
	
EndDo

DbSelectArea( _cAlias )
DbCloseArea()


/* Novo ajuste no Giro para compatbilizar diferenca entre o ultimo movimento e a data de inicio (_dDataIni e _dDataFim) */
If _dDataAtual > _dDataIni
	
	_nNroDias   := _dDataAtual - _dDataIni
	
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		GeraAud("")
		GeraAud("Solicitado GIRO entre os dias "+DtoC(_dDataIni)+" e "+DtoC(_dDataFim)+".")
		GeraAud("O ultimo Movimento ocorreu em "+DtoC(_dDataAtual) )
		GeraAud("")
		GeraAud("Acumuladores: Data Atual "+DtoC(_dDataAtual)+ " Data Anterior: "+DtoC(_dDataIni)+ " Dif. Dias: "+PadL(_nNroDias,5," ") )
	EndIf
	
	//-> Somatorio da Diferenca de Dias
	//-> (Dif entre a Dt da Ult Mov e esta Mov)
	_aVetor[_nD_Acm_dDias] :=  _aVetor[_nD_Acm_dDias] + _nNroDias
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		GeraAud("")
		GeraAud("Somatorio da Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Acm_dDias]) )
		GeraAud("Calculo ----> "+Str(_aVetor[_nD_Acm_dDias] - _nNroDias) + Space(1) + " + " +Str(_nNroDias) + Space(1) + " = " + Str(_aVetor[_nD_Acm_dDias]) )
	EndIf
	
	//-> Acumulado do _nD_Saldo * Diferenca de Dias
	//-> (Dif entre a Dt da Ult Mov e esta Mov)
	_aVetor[_nD_Dias_AcmSld]:= _aVetor[_nD_Dias_AcmSld] + (_aVetor[_nD_Saldo]*_nNroDias)
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		GeraAud("")
		GeraAud("Acumulado do _nD_Saldo * Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(_aVetor[_nD_Dias_AcmSld]) )
		GeraAud("Calculo ----> "+Str( _aVetor[_nD_Dias_AcmSld] - (_aVetor[_nD_Saldo]*_nNroDias) ) + Space(1) + " + (" +Str(_aVetor[_nD_Saldo]) + Space(1) + " * " + Str(_nNroDias) + ") = " + Str(_aVetor[_nD_Dias_AcmSld]) )
	EndIf
EndIf



//-> Saldo Medio
//-> Saldo x Dias / Acum_Dias
_aVetor[_nD_SaldoMedio]  :=  _aVetor[_nD_Dias_AcmSld] / _aVetor[_nD_Acm_dDias]
If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	GeraAud("")
	GeraAud("Saldo Medio = ( Saldo x Dias / Acum_Dias )" )
	GeraAud("      Saldo x Dias ----> "+Str(_aVetor[_nD_Dias_AcmSld]) )
	GeraAud("      Acm Dias     ----> "+Str(_aVetor[_nD_Acm_dDias  ]) )
	GeraAud("Saldo Medio        ----> "+Str(_aVetor[_nD_SaldoMedio ]) )
EndIf

//-> Giro
//-> Saidas / SaldoMedio
_aVetor[_nD_Giro] := _aVetor[_nD_AcmSaida] / _aVetor[_nD_SaldoMedio]
If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	GeraAud("")
	GeraAud("Giro = ( Saidas / SaldoMedio )" )
	GeraAud("      Saidas       ----> "+Str(_aVetor[_nD_AcmSaida   ]) )
	GeraAud("      SaldoMedio   ----> "+Str(_aVetor[_nD_SaldoMedio ]) )
	GeraAud("Giro               ----> "+Str(_aVetor[_nD_Giro       ]) )
EndIf


If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	
	GeraAud("")
	GeraAud("Posicao Final do Vetor:")
	/*
	_nD_AcmEntr       1
	_nD_AcmSaida      2
	_nD_Saldo         3
	_nD_AcmSld        4
	_nD_Acm_dDias     5
	_nD_Dias_AcmSld   6
	_nD_SaldoMedio    7
	_nD_Giro          8
	*/
	
	_aDado := {}
	Aadd(_aDado,{"AcmEntr"       ,10, _aVetor[_nD_AcmEntr]     })
	Aadd(_aDado,{"AcmSaida"      ,10, _aVetor[_nD_AcmSaida]    })
	Aadd(_aDado,{"Saldo"         ,10, _aVetor[_nD_Saldo]       })
	Aadd(_aDado,{"AcmSld"        ,10, _aVetor[_nD_AcmSld]      })
	Aadd(_aDado,{"Acm_dDias"     ,10, _aVetor[_nD_Acm_dDias]   })
	Aadd(_aDado,{"Dias_AcmSld"   ,11, _aVetor[_nD_Dias_AcmSld] })
	Aadd(_aDado,{"SaldoMedio"    ,10, _aVetor[_nD_SaldoMedio]  })
	Aadd(_aDado,{"Giro"          ,10, _aVetor[_nD_Giro]        })
	
	_cDado := ""
	
	GeraAud("")
	
	/* Recebe vetor _aDado e cria cabecalho - Nao retorna nada!*/
	_CriaCabec(_aDado,_cDado)
	
	GeraAud("")
	
EndIf

Return _aVetor



*-------------------
User Function TesteG()

Local _nI     := 0
Local _nJ     := 0
Local _cCod   := "01"+"01"+"01"+"01"+"01"+"01"+"01"+"01"+"03"+"01"
Local _aSimil := {"000199","000200","000456"}

If .F.
	U__MV_teste()
Else
	
	For _nJ := 51339 To 51344
		
		_nI := u__fGiro(PadL(_nJ,6,"0")+Replicate(" ",9), "S", CtoD("01/06/05"), CtoD("20/06/05"))
		
		MsgStop( PadL(_nJ,6,"0") + " ----> Giro: " + Str(_nI,10,5) )
		
	Next _nJ
	
	//-> Simil 000199
	MsgStop("Giro do EIS... "+_cCod+Chr(13)+Chr(10)+"Simil... "+_aSimil[1])
	
	_nI := u__fGiro(_cCod+_aSimil[1], "E", CtoD("01/06/05"), CtoD("20/06/05"))
	
	MsgStop( _cCod+" - "+_aSimil[1] + " ----> Giro: " + Str(_nI,10,5) )
	
	
	//-> Simil 000200
	MsgStop("Giro do EIS... "+_cCod+Chr(13)+Chr(10)+"Simil... "+_aSimil[2])
	
	_nI := u__fGiro(_cCod+_aSimil[2], "E", CtoD("01/06/05"), CtoD("20/06/05"))
	
	MsgStop( _cCod+" - "+_aSimil[2] + " ----> Giro: " + Str(_nI,10,5) )
	
	
	//-> Simil 000456
	MsgStop("Giro do EIS... "+_cCod+Chr(13)+Chr(10)+"Simil... "+_aSimil[3])
	
	_nI := u__fGiro(_cCod+_aSimil[3], "E", CtoD("01/06/05"), CtoD("20/06/05"))
	
	MsgStop( _cCod+" - "+_aSimil[3] + " ----> Giro: " + Str(_nI,10,5) )
EndIf

Return



*-------------------------------------------------
User Function _fGiroAcm(_cCodSimil, _cCodEis, _aPeriodo)
/* Retorna o Giro sem varrer os movimentos... */
//-> Somente para Simil+EIS...

/*
Parametros:
_cCodSimil - Codigo Simil
_cCodEis   - Codigo do EIS
_aPeriodo  - Contem AnoMes a ser calculado no Giro
*/

Local _nGiro         := 0
Local _nQtdDDias     := 0
Local _nSaldo_X_Dias := 0
Local _nQtdSaida     := 0
Local cSimil_Eis     := ""


cSimil_Eis     := AllTrim(_cCodSimil)+AllTrim(_cCodEis)

//-> Auditoria
If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	GeraAud("")
	GeraAud("Sub Processo do Giro - Chamada da funcao _fGiroAcm()")
	GeraAud("Parametros: _cCodSimil -> " + _cCodSimil + "  - _cCodEis -> " + _cCodEis )
	GeraAud("")
	GeraAud("Periodo - Acumuladores Saldo x Dia - Qtd de Dias no Mes - Total Saidas no Mes")
	GeraAud("=======   ========================   ==================   ===================")
	GeraAud("")
EndIf

DbSelectArea("SZ9")
DbSetOrder(2)  //Z9_FILIAL+Z9_ANO+Z9_MES+Z9_SIMIL+Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10

_aTmp := {}

For _nI := 1 To Len(_aPeriodo)
	
	SZ9->( DbSeek( xFilial("SZ9") + _aPeriodo[_nI] + _cCodSimil + _cCodEis ) )
	
	//-> Auditoria
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		Aadd(_aTmp,{_aPeriodo[_nI],0,0,0})
	EndIf
	If Found()
		_nSaldo_X_Dias += SZ9->Z9_AC_S_D  //-> Acumuladores Saldo x Dia
		_nQtdDDias     += SZ9->Z9_ACMDDIA //-> Qtd de Dias no Mes
		_nQtdSaida     += SZ9->Z9_QTDSAI
		
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			_aTmp[_nI,2] := SZ9->Z9_AC_S_D  //-> Acumuladores Saldo x Dia
			_aTmp[_nI,3] := SZ9->Z9_ACMDDIA //-> Qtd de Dias no Mes
			_aTmp[_nI,4] := SZ9->Z9_QTDSAI //-> Saidas
		EndIf
	EndIf
Next _nI

If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
	//GeraAud("Periodo - Acumuladores Saldo x Dia - Qtd de Dias no Mes - Total Saidas no Mes")
	//GeraAud("=======   ========================   ==================   ===================")
	For _nI:=1 To Len(_aTmp)
		_cDado := ""
		_cDado := PadL(_aTmp[_nI,1], 7," ")+Space(3)
		_cDado += PadL(_aTmp[_nI,2],24," ")+Space(3)
		_cDado += PadL(_aTmp[_nI,3],18," ")+Space(3)
		_cDado += PadL(_aTmp[_nI,4],19," ")+Space(3)
		
		GeraAud(_cDado)
	Next _nI
	
	GeraAud("")
	GeraAud("")
	
	GeraAud("Totais")
	GeraAud("          Acumuladores Saldo x Dia - Qtd de Dias no Mes - Total Saidas no Mes")
	GeraAud("          ========================   ==================   ===================")
	
	_cDado := ""
	_cDado := "          "+PadL(_nSaldo_X_Dias,24," ")+Space(3)
	_cDado += PadL(_nQtdDDias    ,18," ")+Space(3)
	_cDado += PadL(_nQtdSaida    ,19," ")+Space(3)
	
	GeraAud(_cDado)
	GeraAud("")
	GeraAud("")
	GeraAud("")
	GeraAud("Retorno da Funcao: (Total de Saidas) / (Acum Sld_Dias) / (Qtd Dias) ")
	GeraAud("Retorno da Funcao: (" + PadL(_nQtdSaida,15," ") + ") / (" + PadL(_nSaldo_X_Dias,13," ") + ") / (" + PadL(_nQtdDDias,8," ") + ")  ---->   " + PadL(_nQtdSaida / (_nSaldo_X_Dias/_nQtdDDias ),8," ")  )
	GeraAud("")
	GeraAud("")
EndIf


Return ( _nQtdSaida / (_nSaldo_X_Dias/_nQtdDDias ) )



*----------------------------------------------------
Static Function _CriaCabec(_aDado,_cDado)
/*Vetor varrido na vertical!!!!!*/

Local _nCol   := 0
Local _lErro  := .f.

//-> Trava de Seguranca - Nenhuma das linhas do vetor pode ter mais que 3 colunas
For _nI := 1 To Len(_aDado)
	If Len(_aDado[_nI])>3
		_cDado := "Trava de Seguranca - Nenhuma das linhas do vetor pode ter mais que 3 colunas"
		GeraAud(_cDado)
		
		_cDado := "ERRO: Linha "+PadL(_nI,3," ")+" do vetor _aDado (Especifico Giro) possui "+PadL(Len(_aDado[_nI]),6," ")+" colunas."
		GeraAud(_cDado)
		
		GeraAud("")
		GeraAud("")
		_lErro := .t.
	EndIf
Next _nI

If !_lErro
	_nCol  := 1
	_cDado := ""
	//GeraAud("")
	
	For _nI := 1 To Len(_aDado)
		For _nJ := 1 To Len(_aDado)
			/*Sao 3 colunas: Na primeira tem cabecalho,
			na segunda tem o replicate e na terceira o dado.*/
			If _nCol <> 2
				If _nCol <=3
					If _aDado[_nJ,2] == 0
						_cDado := _cDado + PadL(_aDado[_nJ,_nCol],Len(_aDado[_nJ,1])," ") + Space(2)
					Else
						_cDado := _cDado + PadL(_aDado[_nJ,_nCol],_aDado[_nJ,2]," ") + Space(2)
					EndIf
				EndIf
			Else
				If _aDado[_nJ,2] == 0
					_cDado := _cDado + Replicate("=",Len(_aDado[_nJ,1])) + Space(2)
				Else
					_cDado := _cDado + Replicate("=",_aDado[_nJ,2]) + Space(2)
				EndIf
			EndIf
		Next _nJ
		
		If !Empty(_cDado)
			GeraAud(_cDado)
		EndIf
		
		_cDado := ""
		_nCol ++
		
	Next _nI
	
	/*
	_cDado := "Observacao: "
	GeraAud(_cDado)
	
	_cDado := "o valor obtido de saldo resulta da soma das posicoes aSimil[nPosSimil][42] "
	GeraAud(_cDado)
	*/
	
	GeraAud( Replicate("-",Len(_cDado)) )
	//	GeraAud("")
	//	GeraAud("")
	
EndIf

Return



*----------------------------------
Static Function GeraAud(_cString1)

AADD(_aAud,_cString1)

Return





*-----------------------------------------------------------------------------------
User Function _fPGMMGiro(_dDataIni, _dDataFim, lRegua, aSerieM, aSerieD, _lRetVetorG, aSimil, aSku)

*---------------------------------------------------------------
//
//   Algoritmo para Calculo do Giro de Estoque de uma SKU
//
//   Recebe os seguintes Parametros
//
//   Codigo [Char ]        -> Codigo SKU (B1_COD) ou Codigo EIS + SIMIL
//   Ident [Pertence(S/E)] -> S indica SKU,   E indica EIS
//   DataIni [Date]        -> Data Inicial do Movimento
//   DataFim [Date]        -> Data Final do Movimento
//   lRegua [.t./.f.]      -> .t. para processamento com regua e .f. para sem regua
//   nSaldoIni             -> Saldo da Malha deste item
//
//   _lRetVetorG           -> Se .t., retorno o vetor inteiro. Se .f. (default), retorna o GIRO.
//
//   Retorna Valor do Giro ou -1 em caso de erro OU o vetor inteiro
//
*---------------------------------------------------------------

Local _dDataTmp    := CtoD("")
Local _nNroDias    := 0
Local _aVetor      := {}
Local _nI          := 0
Local _aSld        := {}
Local _aAreaGiro   := {}
Local _cAlmoxPGMM  := ""
/*
OBSERVACAO IMPORTANTE:
em 20/06/05, ficou acordado considerar o conteudo de _cAlmoxPGMM (MV_ALMFECH) nos movimentos.
Passara a ocorrer o filtro dos Almoxarifados que NAO PERTENCEM AOS ALMOXARIFADOS DO FECHAMENTO.
*/

//
// Usadas somente quando se trata do Movigrama
//
Local nSaida       := 0
Local nEntrada     := 0
Local nSaldo       := 0
Local dData        := ctod("")


Local nPosSku      := 0
Local _cErro       := ""   //-> Usada para retornar mensagens de erro e para Log de Auditoria (GeraAud)
Local _cDado       := ""   //-> Variavel Auxiliar na gravacao do dados pra Auditoria
Local _aDado       := {}   //-> Variavel Auxiliar na gravacao do dados pra Auditoria
Local _aDivDados   := {}   //-> Variavel Auxiliar na gravacao do dados pra Auditoria

If Type("_ChaveAud") = "U"   // Variaveis utilizadas durante Analise Fechamento Mensal Planilha
	Private _aLog    := {}
	Private _aAud    := {}
	Private _ChaveAud:= ""
Endif

Private cSimil_Eis   := ""
Private nPosSimil    := 0

Default _dDataIni    := Date()  // DataIni [Date]
Default _dDataFim    := Date()  // DataFim [Date]
Default lRegua       := .T.     // Regua [.t./.f.]
Default aSerieM      := {}
Default aSerieD      := {}
Default _lRetVetorG  := .f.
Default aSimil       := {}
Default aSku         := {}


//-> Para efeito de testes...
//-> Se mudar o criterio, nao esquecer de alterar em Grafico2.prw tambem
_cAlmoxPGMM  := GetMV("MV_ALMFECH")


//---------------------------------> Inicio das Validacoes dos Parametros Recebidos
/*
If  !Upper(_cIdent) $ "E|S"
_cErro := "Ocorreu erro durante a utilizacao do funcao _fGiro o conteudo do parametro _cIdent esta diferente de S ou E"

Aviso("ATENCAO", _cErro ,{"&Ok"})

Return(_aVetor)
EndIf
*/

If  _dDataIni > date()
	_cErro := "Ocorreu erro durante a utilizacao do funcao _fGiro a data inicial esta maior que a data atual"
	
	Aviso("ATENCAO", _cErro ,{"&Ok"})
	
	Return(_aVetor)
EndIf
//---------------------------------> Fim das Validacoes dos Parametros Recebidos


_aAreaGiro   := GetArea()

_dDataTmp    := _dDataIni
_nNroDias    := 0
_aVetor      := {}


//
// AVIGUAR POIS SOMENTE GRAVA A INFORMACAO DE UM CAMPO EM OUTRO CAMPO DO MESMO VETOR.
//
For _nK := 1 To Len(aSimil)
	/*
	#Define _nPGMM_AcmEntr       50
	#Define _nPGMM_AcmSaida      51
	#Define _nPGMM_Saldo         52
	#Define _nPGMM_AcmSld        53
	#Define _nPGMM_Acm_dDias     54
	#Define _nPGMM_Dias_AcmSld   55
	#Define _nPGMM_SaldoMedio    56
	#Define _nPGMM_Giro          57
	*/
	
	aSimil[_nK][_nPGMM_Saldo]  := aSimil[_nK][58]   // Saldo Fisico do Fechamento base SB9 
	
	
Next _nK

_fPGMMLeMov(@aSimil , _dDataIni, _dDataFim, lRegua,aSerieM,aSerieD, _cAlmoxPGMM)

RestArea(_aAreaGiro)

Return




*---------------------------------------------------------------------------
Static Function _fPGMMLeMov( aSimil , _dDataIni, _dDataFim, lRegua, aSerieM, aSerieD, _cAlmoxPGMM )

//-> Selecao dos Dados que geraram apanhe
// Select SD1 Union               //-> Itens de Entrada
// Select SD2 Union               //-> Itens de Saida
// Select SD3                     //-> Itens de Mov Interna

Local nCount      := 0
Local _cQuery     := ""
Local _cAlias     := "TRB"
Local _dDataAtual := CtoD("")
Local cTimeIni    := Time()


//
//  Apenas monta Count
//
_cQuery := " SELECT COUNT(*) TOTAL "
_cQuery += " FROM "
_cQuery += RetSqlName("SD1")+" SD1, "
_cQuery += RetSqlName("SB1")+" SB1, "
_cQuery += RetSqlName("SF4")+" SF4, " 
_cQuery += RetSqlName("SDB")+" SDB  "
_cQuery += " WHERE "
_cQuery += " D1_FILIAL <>'  ' AND "
_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "
_cQuery += " D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND " //Data do Ultimo Fechamento do Estoque
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D1_TES = F4_CODIGO AND "
_cQuery += " DB_FILIAL  =  D1_FILIAL AND"              // Utilizo o SDB para indentificar a data 
_cQuery += " DB_PRODUTO =  D1_COD  AND"                // em que o produto entrou no estoque
_cQuery += " DB_LOCAL   =  D1_LOCAL  AND"              // que deve ser sempre menor que a data 
_cQuery += " DB_NUMSEQ  =  D1_NUMSEQ  AND"             // do ultimo fechamento.
_cQuery += " DB_DOC     =  D1_DOC AND"
_cQuery += " DB_SERIE   =  D1_SERIE AND"
_cQuery += " DB_CLIFOR  =  D1_FORNECE AND"
_cQuery += " DB_LOJA    =  D1_LOJA AND"
_cQuery += " DB_DATA   <=  '"+DTOS(_dDataFim)+"' AND "
_cQuery += " F4_ESTOQUE =  'S' AND "
_cQuery += " D1_COD     =  B1_COD AND "
_cQuery += " SDB.D_E_L_E_T_<>'*' AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
_cQuery += " SD1.D_E_L_E_T_<>'*' "
// TESTE _cQuery += " AND B1_X_SIMIL||B1_X_EIS01||B1_X_EIS02||B1_X_EIS03||B1_X_EIS04||B1_X_EIS05||B1_X_EIS06||B1_X_EIS07||B1_X_EIS08||B1_X_EIS09||B1_X_EIS10='00424901010204010101070700'"


_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)
While (_cAlias)->(!Eof())
	nCount:= (_cAlias)->TOTAL
	(_cAlias)->( DbSkip() )
EndDo
DbSelectArea( _cAlias )
DbCloseArea()


_cQuery := " SELECT COUNT(*) TOTAL "
_cQuery += " FROM "
_cQuery += RetSqlName("SD2")+" SD2, "
_cQuery += RetSqlName("SB1")+" SB1, "
_cQuery += RetSqlName("SF4")+" SF4  "
_cQuery += " WHERE "
_cQuery += " D2_FILIAL<>'  ' AND "
_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "
_cQuery += " D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "// Dt Ultimo Fechamento de Estoque
_cQuery += " D2_COD = B1_COD AND "
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D2_TES = F4_CODIGO AND "
_cQuery += " F4_ESTOQUE = 'S' AND "
//10.10.2006 _cQuery += " F4_X_APANH = 'S' AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
_cQuery += " SD2.D_E_L_E_T_<>'*' "


_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)
While (_cAlias)->(!Eof())
	nCount:= nCount + (_cAlias)->TOTAL
	(_cAlias)->( DbSkip() )
EndDo
DbSelectArea( _cAlias )
DbCloseArea()

_cQuery := " SELECT COUNT(*) TOTAL "
_cQuery += " FROM "
_cQuery += RetSqlName("SD3")+" SD3, "
_cQuery += RetSqlName("SB1")+" SB1, "
//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5 "
_cQuery += " WHERE "
_cQuery += " D3_FILIAL <>'  ' AND "
//10.10.2006 _cQuery += " F5_FILIAL  = '"+xFilial("SF5")+"' AND "
_cQuery += " B1_FILIAL  = '"+xFilial("SB1")+"' AND "
_cQuery += " D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
_cQuery += " D3_COD = B1_COD AND "
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
//10.10.2006 _cQuery += " D3_TM = F5_CODIGO AND "
//10.10.2006_cQuery += " F5_X_APANH = 'S' AND "
//10.10.2006 _cQuery += " SF5.D_E_L_E_T_<>'*' AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SD3.D_E_L_E_T_<>'*' "

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)
While (_cAlias)->(!Eof())
	nCount:= nCount + (_cAlias)->TOTAL
	(_cAlias)->( DbSkip() )
EndDo
DbSelectArea( _cAlias )
DbCloseArea()



If !Empty(_ChaveAud)
	
	GeraAud("")
	GeraAud("Calculo do Giro - Contagem de Linhas")
	GeraAud("====================================")
	GeraAud("Referencias: Data Inicial: "+DTOC(_dDataIni))
	GeraAud("             Data Final:   "+DTOC(_dDataFim))
	GeraAud("             dDataBase:    "+DTOC(dDataBase))
	GeraAud("")
	GeraAud("")
	GeraAud("Resultado da Query: " + PadL( nCount,10," " ) )
	GeraAud("")
	GeraAud("")

	
Endif


_cQuery := " SELECT B1_X_SIMIL, B1_X_EIS01, B1_X_EIS02, B1_X_EIS03, B1_X_EIS04, B1_X_EIS05, "
_cQuery += " B1_X_EIS06, B1_X_EIS07, B1_X_EIS08, B1_X_EIS09, B1_X_EIS10, "
_cQuery += " DB_DATA DTEMISSAO, D1_QUANT QTD, 'E' ID, F4_CODIGO COD_INT , SD1.R_E_C_N_O_  RECNO "
_cQuery += " FROM "
_cQuery += RetSqlName("SD1")+" SD1, "
_cQuery += RetSqlName("SB1")+" SB1, "
_cQuery += RetSqlName("SF4")+" SF4, " 
_cQuery += RetSqlName("SDB")+" SDB  "
_cQuery += " WHERE "
_cQuery += " D1_FILIAL <>'  ' AND "
_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "     
_cQuery += " D1_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D1_EMISSAO <= '"+DTOS(_dDataFim)+"' AND " //Data do Ultimo Fechamento do Estoque
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D1_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D1_TES = F4_CODIGO AND "
_cQuery += " DB_FILIAL  =  D1_FILIAL AND"              // Utilizo o SDB para indentificar a data 
_cQuery += " DB_PRODUTO =  D1_COD  AND"                // em que o produto entrou no estoque
_cQuery += " DB_LOCAL   =  D1_LOCAL  AND"              // que deve ser sempre menor que a data 
_cQuery += " DB_NUMSEQ  =  D1_NUMSEQ  AND"             // do ultimo fechamento.
_cQuery += " DB_DOC     =  D1_DOC AND"
_cQuery += " DB_SERIE   =  D1_SERIE AND"
_cQuery += " DB_CLIFOR  =  D1_FORNECE AND"
_cQuery += " DB_LOJA    =  D1_LOJA AND"
_cQuery += " DB_DATA   <=  '"+DTOS(_dDataFim)+"' AND "
_cQuery += " F4_ESTOQUE =  'S' AND "
_cQuery += " D1_COD     =  B1_COD AND "
_cQuery += " SDB.D_E_L_E_T_<>'*' AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
_cQuery += " SD1.D_E_L_E_T_<>'*' "
//teste _cQuery += " AND B1_X_SIMIL||B1_X_EIS01||B1_X_EIS02||B1_X_EIS03||B1_X_EIS04||B1_X_EIS05||B1_X_EIS06||B1_X_EIS07||B1_X_EIS08||B1_X_EIS09||B1_X_EIS10='00525501010205030101010100'"


// Select SD2 Union               //-> Itens de Saida
_cQuery += " UNION "+_nD_ENTER

           
_cQuery += " SELECT B1_X_SIMIL, B1_X_EIS01, B1_X_EIS02, B1_X_EIS03, B1_X_EIS04, B1_X_EIS05, "
_cQuery += " B1_X_EIS06, B1_X_EIS07, B1_X_EIS08, B1_X_EIS09, B1_X_EIS10, "
_cQuery += " D2_EMISSAO DTEMISSAO, D2_QUANT QTD, 'S' ID, F4_CODIGO COD_INT , SD2.R_E_C_N_O_  RECNO "
_cQuery += " FROM "
_cQuery += RetSqlName("SD2")+" SD2, "
_cQuery += RetSqlName("SB1")+" SB1, "
_cQuery += RetSqlName("SF4")+" SF4  "
_cQuery += " WHERE "
_cQuery += " D2_FILIAL<>'  ' AND "
_cQuery += " F4_FILIAL = '"+xFilial("SF4")+"' AND "
_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "
_cQuery += " D2_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D2_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
_cQuery += " D2_COD = B1_COD AND "
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D2_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D2_TES = F4_CODIGO  AND "
_cQuery += " F4_ESTOQUE = 'S'    AND "
//10.10.2006_cQuery += " F4_X_APANH = 'S'    AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SF4.D_E_L_E_T_<>'*' AND "
_cQuery += " SD2.D_E_L_E_T_<>'*' "
// teste _cQuery += " AND B1_X_SIMIL||B1_X_EIS01||B1_X_EIS02||B1_X_EIS03||B1_X_EIS04||B1_X_EIS05||B1_X_EIS06||B1_X_EIS07||B1_X_EIS08||B1_X_EIS09||B1_X_EIS10='00525501010205030101010100'"
 

// Select SD3                                 //-> Itens de Mov Interna
_cQuery += " UNION "+_nD_ENTER


_cQuery += " SELECT B1_X_SIMIL, B1_X_EIS01, B1_X_EIS02, B1_X_EIS03, B1_X_EIS04, B1_X_EIS05, "
_cQuery += " B1_X_EIS06, B1_X_EIS07, B1_X_EIS08, B1_X_EIS09, B1_X_EIS10, "
_cQuery += " D3_EMISSAO DTEMISSAO, D3_QUANT QTD, 'M' ID, D3_TM  COD_INT , SD3.R_E_C_N_O_  RECNO"
_cQuery += " FROM "
_cQuery += RetSqlName("SD3")+"  (NOLOCK) SD3, "
_cQuery += RetSqlName("SB1")+"  (NOLOCK) SB1  "
//10.10.2006 _cQuery += RetSqlName("SF5")+" SF5  "
_cQuery += " WHERE "
_cQuery += " D3_FILIAL<>'  ' AND "
_cQuery += " B1_FILIAL = '"+xFilial("SB1")+"' AND "
_cQuery += " D3_EMISSAO >= '"+DTOS(_dDataIni)+"' AND "
_cQuery += " D3_EMISSAO <= '"+DTOS(_dDataFim)+"' AND "
_cQuery += " D3_COD  = B1_COD AND "
//17.10.2006 - Considerar todos Armazens
//_cQuery += " D3_LOCAL NOT IN '"+_cAlmoxPGMM+"' AND "
_cQuery += " D3_CF IN ('RE0','DE0','DE6','PRO') AND "  //10.10.2006 
//10.10.2006 _cQuery += " F5_FILIAL = '"+xFilial("SF5")+"' AND "
//10.10.2006 _cQuery += " D3_TM   = F5_CODIGO AND "
//10.10.2006 _cQuery += " F5_X_APANH = 'S' AND "
//10.10.2006 _cQuery += " SF5.D_E_L_E_T_<>'*' AND "
_cQuery += " SB1.D_E_L_E_T_<>'*' AND "
_cQuery += " SD3.D_E_L_E_T_<>'*' "
_cQuery += " ORDER BY B1_X_SIMIL, B1_X_EIS01, B1_X_EIS02, B1_X_EIS03, B1_X_EIS04, B1_X_EIS05, " 
_cQuery += " B1_X_EIS06, B1_X_EIS07, B1_X_EIS08, B1_X_EIS09, B1_X_EIS10, DTEMISSAO DESC, ID, COD_INT "

MemoWrit("Giro003.Sql",_cQuery)


If !Empty(_ChaveAud)    


	GeraAud("")
	GeraAud("Calculo do Giro - Massa de Dados")
	GeraAud("================================")
	GeraAud("")
	GeraAud("Caso necessario o  script utilizado para filtrar a massa de Dados foi gerado no arquivo")
	GeraAud("Giro001.Sql gravado dentro do diretorio SIGAADV.")
	GeraAud("")
	GeraAud("Simil + EIS em analise: "+_ChaveAud)

Endif

_cQuery := ChangeQuery(_cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.F.,.T.)

TcSetField(_cAlias,"DTEMISSAO","D",8,0)



/* Basicamente, o TEMP tem Data, Qtd, ID (E, S, M) e CodID (TES ou TM) */
/* Cabec:  Data        Qtd         ID  COD  */
/*         ==========  ==========  ==  ===  */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Start a Regua 1                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_BarG1Set( nCount )

While (_cAlias)->( !Eof() )
	
	cSimil_Eis   := ""
	nPosSimil    := 0
	
	_dDataAnter := _dDataFim
	
	cSimil_Eis   := (_cAlias)->( B1_X_SIMIL+B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10 )
	
	nPosSimil    := aScan( aSimil , {|x| x[1]+x[2] == cSimil_Eis })
	
	//nPosSimil    := AScan(aSimil,{|x,y| x[1]==(_cAlias)->(B1_X_SIMIL) .And. y[2]==(_cAlias)->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10) })
	
	If nPosSimil == 0
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Nao encontrou o conteudo de cSimil_Eis no vetor aSimil.")
			GeraAud("")
			GeraAud("nPosSimil := aScan( aSimil , {|x| x[1]+x[2] == cSimil_Eis })")
			GeraAud("")
			GeraAud("cSimil_Eis: "+cSimil_Eis)
			GeraAud("nPosSimil: "+Str(nPosSimil))
			GeraAud("")
		EndIf
		
		(_cAlias)->( DbSkip() )
		Loop
	EndIf
	
	//-> Auditoria
	If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
		_aDado := {}
		Aadd(_aDado,{"Simil+EIS"          ,50, _ChaveAud })
		Aadd(_aDado,{"Pos Simil no Vetor" ,0 , nPosSimil })
		Aadd(_aDado,{"SaldoSB9"           ,15, aSimil[nPosSimil][_nPGMM_Saldo] })
		
		_cDado := ""
		
		GeraAud("")
		
		//-> Recebe vetor _aDado e cria cabecalho - Nao retorna nada!
		_CriaCabec(_aDado,_cDado)
		
		_cDado := "Observacao: "

		GeraAud(_cDado)
		
		_cDado := "o valor obtido de saldo resulta da soma das posicoes aSimil[nPosSimil][59] "
		GeraAud(_cDado)
	
	Endif
	
	
	
	While (_cAlias)->( !Eof() ) .And. cSimil_Eis == (_cAlias)->( B1_X_SIMIL+B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10 )
		
		
		_dDataAtual := (_cAlias)->DTEMISSAO
		
		_aDivDados	:= {}
		
		_nNroDias   := 0
		
		While (_cAlias)->( !Eof() ) .And. cSimil_Eis == (_cAlias)->( B1_X_SIMIL+B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10 );
			.And. (_cAlias)->DTEMISSAO == _dDataAtual
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza Regua 1                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			U_IncPG1T( "Processando Giro " , nCount , cTimeIni , .T. , NIL , 05 )
			
			
			Do Case
				
				Case (_cAlias)->ID == "E"
					
					aSimil[nPosSimil][_nPGMM_Saldo]   :=  aSimil[nPosSimil][_nPGMM_Saldo] - (_cAlias)->QTD
					
					/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
					If _dDataAtual <= _dDataFim
						aSimil[nPosSimil][_nPGMM_AcmEntr] :=  aSimil[nPosSimil][_nPGMM_AcmEntr] + (_cAlias)->QTD
					EndIf
					
				Case (_cAlias)->ID == "S"
					
					aSimil[nPosSimil][_nPGMM_Saldo]    :=  aSimil[nPosSimil][_nPGMM_Saldo] + (_cAlias)->QTD
					
					/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
					If _dDataAtual <= _dDataFim
						aSimil[nPosSimil][_nPGMM_AcmSaida] :=  aSimil[nPosSimil][_nPGMM_AcmSaida] + (_cAlias)->QTD
					EndIf
					
				Case (_cAlias)->ID == "M"
					
					If (_cAlias)->COD_INT < '500'       
					
						aSimil[nPosSimil][_nPGMM_Saldo]   :=  aSimil[nPosSimil][_nPGMM_Saldo] - (_cAlias)->QTD
						
						/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
						If _dDataAtual <= _dDataFim
							aSimil[nPosSimil][_nPGMM_AcmEntr] :=  aSimil[nPosSimil][_nPGMM_AcmEntr] + (_cAlias)->QTD
						EndIf
						
					Else     //-> COD_INT > 500
						aSimil[nPosSimil][_nPGMM_Saldo]    :=  aSimil[nPosSimil][_nPGMM_Saldo] + (_cAlias)->QTD
						
						/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
						If _dDataAtual <= _dDataFim
							aSimil[nPosSimil][_nPGMM_AcmSaida] :=  aSimil[nPosSimil][_nPGMM_AcmSaida] + (_cAlias)->QTD
						EndIf
						
					EndIf
					
			Endcase
			
			//-> Acumula pra descarregar na Auditoria
			//-> DATA, QTD, ID, COD_INT
			Aadd(_aDivDados,{(_cAlias)->DTEMISSAO, (_cAlias)->QTD, (_cAlias)->ID, (_cAlias)->COD_INT})
			
			(_cAlias)->( DbSkip() )
			
			
		EndDo
		
		//-> Mudou a Data - Grava dados pra Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			
			GeraAud("")
			GeraAud("Massa de Dados de "+DtoC(_dDataAtual))
			// Cabec:  Data        Qtd         ID          COD
			//         ==========  ==========  ==========  ==========
			
			GeraAud("Data        Qtd         ID          COD       	")
			GeraAud("==========  ==========  ==========  ==========  ")
			
			For _nI := 1 To Len(_aDivDados)
				_cDado := ""
				For _nJ := 1 To Len(_aDivDados[_nI])
					 _cDado := _cDado + PadL(_aDivDados[_nI,_nJ],10," ") + Space(2)
				Next _nJ
				
				If !Empty(_cDado)
					GeraAud(_cDado)
				EndIf
			Next _nI
			
		EndIf
		
		
		If _dDataAnter > _dDataAtual
			
			_nNroDias   := _dDataAnter - _dDataAtual
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Acumuladores: Data Atual "+DtoC(_dDataAtual)+ " Data Anterior: "+DtoC(_dDataAnter)+ " Dif. Dias: "+PadL(_nNroDias,5," ") )
			EndIf
			
			_dDataAnter := _dDataAtual
			
			//-> Somatorio da Diferenca de Dias
			//-> (Dif entre a Dt da Ult Mov e esta Mov)
			
			/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
			aSimil[nPosSimil][_nPGMM_Acm_dDias] :=  aSimil[nPosSimil][_nPGMM_Acm_dDias] + _nNroDias
			
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Somatorio da Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(aSimil[nPosSimil][_nPGMM_Acm_dDias]) )
				GeraAud("Calculo ----> "+Str(aSimil[nPosSimil][_nPGMM_Acm_dDias] - _nNroDias) + Space(1) + " + " +Str(_nNroDias) + Space(1) + " = " + Str(aSimil[nPosSimil][_nPGMM_Acm_dDias]) )
			EndIf
			
			
			//-> Acumulado do _nPGMM_Saldo * Diferenca de Dias
			//-> (Dif entre a Dt da Ult Mov e esta Mov)
			/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
			aSimil[nPosSimil][_nPGMM_Dias_AcmSld] := aSimil[nPosSimil][_nPGMM_Dias_AcmSld] + (aSimil[nPosSimil][_nPGMM_Saldo]*_nNroDias)
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Acumulado do _nPGMM_Saldo * Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(aSimil[nPosSimil][_nPGMM_Dias_AcmSld]) )
				GeraAud("Calculo ----> "+Str( aSimil[nPosSimil][_nPGMM_Dias_AcmSld] - (aSimil[nPosSimil][_nPGMM_Saldo]*_nNroDias) ) + Space(1) + " + (" +Str(aSimil[nPosSimil][_nPGMM_Saldo]) + Space(1) + " * " + Str(_nNroDias) + ") = " + Str(aSimil[nPosSimil][_nPGMM_Dias_AcmSld]) )
			EndIf
			
			
		Else
			
			_nNroDias := 0
			
		EndIf
		
		
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			
			GeraAud("")
			GeraAud("Dados do Vetor ate o momento:")
			
			//_nPGMM_AcmEntr       1
			//_nPGMM_AcmSaida      2
			//_nPGMM_Saldo         3
			//_nPGMM_AcmSld        4
			//_nPGMM_Acm_dDias     5
			//_nPGMM_Dias_AcmSld   6
			//_nPGMM_SaldoMedio    7
			//_nPGMM_Giro          8
			
			_aDado := {}
			Aadd(_aDado,{"AcmEntr"       ,10, aSimil[nPosSimil][_nPGMM_AcmEntr]     })
			Aadd(_aDado,{"AcmSaida"      ,10, aSimil[nPosSimil][_nPGMM_AcmSaida]    })
			Aadd(_aDado,{"Saldo"         ,10, aSimil[nPosSimil][_nPGMM_Saldo]       })
			Aadd(_aDado,{"AcmSld"        ,10, aSimil[nPosSimil][_nPGMM_AcmSld]      })
			Aadd(_aDado,{"Acm_dDias"     ,10, aSimil[nPosSimil][_nPGMM_Acm_dDias]   })
			Aadd(_aDado,{"Dias_AcmSld"   ,11, aSimil[nPosSimil][_nPGMM_Dias_AcmSld] })
			Aadd(_aDado,{"SaldoMedio"    ,10, aSimil[nPosSimil][_nPGMM_SaldoMedio]  })
			Aadd(_aDado,{"Giro"          ,10, aSimil[nPosSimil][_nPGMM_Giro]        })
			
			_cDado := ""
			
			//GeraAud("")
			// Recebe vetor _aDado e cria cabecalho - Nao retorna nada!
			_CriaCabec(_aDado,_cDado)
			
			//GeraAud("")
			
		EndIf
		
		
	EndDo
	
	/* Novo ajuste no Giro para compatbilizar diferenca entre o
	ultimo movimento e a data de inicio (_dDataIni e _dDataFim) */
	
	/* Somente para _dDataAtual pertencente ao periodo (_dDataAtual <= _dDataFim) */
	If _dDataAtual <= _dDataFim
		
		If _dDataAtual > _dDataIni
			
			_nNroDias   := _dDataAtual - _dDataIni
			
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Solicitado GIRO entre os dias "+DtoC(_dDataIni)+" e "+DtoC(_dDataFim)+".")
				GeraAud("O ultimo Movimento ocorreu em "+DtoC(_dDataAtual) )
				GeraAud("")
				GeraAud("Acumuladores: Data Atual "+DtoC(_dDataAtual)+ " Data Anterior: "+DtoC(_dDataIni)+ " Dif. Dias: "+PadL(_nNroDias,5," ") )
			EndIf
			
			
			//-> Somatorio da Diferenca de Dias
			//-> (Dif entre a Dt da Ult Mov e esta Mov)
			/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
			aSimil[nPosSimil][_nPGMM_Acm_dDias] :=  aSimil[nPosSimil][_nPGMM_Acm_dDias] + _nNroDias
			
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Somatorio da Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(aSimil[nPosSimil][_nPGMM_Acm_dDias]) )
				GeraAud("Calculo ----> "+Str(aSimil[nPosSimil][_nPGMM_Acm_dDias] - _nNroDias) + Space(1) + " + " +Str(_nNroDias) + Space(1) + " = " + Str(aSimil[nPosSimil][_nPGMM_Acm_dDias]) )
			EndIf
			
			
			//-> Acumulado do _nPGMM_Saldo * Diferenca de Dias
			//-> (Dif entre a Dt da Ult Mov e esta Mov)
			/* ??? - So alimenta se a data do movimento pertencer ao periodo. */
			aSimil[nPosSimil][_nPGMM_Dias_AcmSld]:= aSimil[nPosSimil][_nPGMM_Dias_AcmSld] + (aSimil[nPosSimil][_nPGMM_Saldo]*_nNroDias)
			
			
			//-> Auditoria
			If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
				GeraAud("")
				GeraAud("Acumulado do _nPGMM_Saldo * Diferenca de Dias (Dif entre a Dt da Ult Mov e esta Mov) ----> "+Str(aSimil[nPosSimil][_nPGMM_Dias_AcmSld]) )
				GeraAud("Calculo ----> "+Str( aSimil[nPosSimil][_nPGMM_Dias_AcmSld] - (aSimil[nPosSimil][_nPGMM_Saldo]*_nNroDias) ) + Space(1) + " + (" +Str(aSimil[nPosSimil][_nPGMM_Saldo]) + Space(1) + " * " + Str(_nNroDias) + ") = " + Str(aSimil[nPosSimil][_nPGMM_Dias_AcmSld]) )
			EndIf
			
			
		EndIf
		
		
		//-> Saldo Medio
		//-> Saldo x Dias / Acum_Dias
		aSimil[nPosSimil][_nPGMM_SaldoMedio]  :=  aSimil[nPosSimil][_nPGMM_Dias_AcmSld] / aSimil[nPosSimil][_nPGMM_Acm_dDias]
		
		
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Saldo Medio = ( Saldo x Dias / Acum_Dias )" )
			GeraAud("      Saldo x Dias ----> "+Str(aSimil[nPosSimil][_nPGMM_Dias_AcmSld]) )
			GeraAud("      Acm Dias     ----> "+Str(aSimil[nPosSimil][_nPGMM_Acm_dDias  ]) )
			GeraAud("Saldo Medio        ----> "+Str(aSimil[nPosSimil][_nPGMM_SaldoMedio ]) )
		EndIf
		
		
		
		//-> Giro
		//-> Saidas / SaldoMedio
		aSimil[nPosSimil][_nPGMM_Giro] := aSimil[nPosSimil][_nPGMM_AcmSaida] / aSimil[nPosSimil][_nPGMM_SaldoMedio]
		
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			GeraAud("")
			GeraAud("Giro = ( Saidas / SaldoMedio )" )
			GeraAud("      Saidas       ----> "+Str(aSimil[nPosSimil][_nPGMM_AcmSaida   ]) )
			GeraAud("      SaldoMedio   ----> "+Str(aSimil[nPosSimil][_nPGMM_SaldoMedio ]) )
			GeraAud("Giro               ----> "+Str(aSimil[nPosSimil][_nPGMM_Giro       ]) )
		EndIf
		
		
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			
			GeraAud("")
			GeraAud("Posicao Final do Vetor:")
			
			//_nPGMM_AcmEntr       1
			//_nPGMM_AcmSaida      2
			//_nPGMM_Saldo         3
			//_nPGMM_AcmSld        4
			//_nPGMM_Acm_dDias     5
			//_nPGMM_Dias_AcmSld   6
			//_nPGMM_SaldoMedio    7
			//_nPGMM_Giro          8
			
			_aDado := {}
			Aadd(_aDado,{"AcmEntr"       ,10, aSimil[nPosSimil][_nPGMM_AcmEntr]     })
			Aadd(_aDado,{"AcmSaida"      ,10, aSimil[nPosSimil][_nPGMM_AcmSaida]    })
			Aadd(_aDado,{"Saldo"         ,10, aSimil[nPosSimil][_nPGMM_Saldo]       })
			Aadd(_aDado,{"AcmSld"        ,10, aSimil[nPosSimil][_nPGMM_AcmSld]      })
			Aadd(_aDado,{"Acm_dDias"     ,10, aSimil[nPosSimil][_nPGMM_Acm_dDias]   })
			Aadd(_aDado,{"Dias_AcmSld"   ,11, aSimil[nPosSimil][_nPGMM_Dias_AcmSld] })
			Aadd(_aDado,{"SaldoMedio"    ,10, aSimil[nPosSimil][_nPGMM_SaldoMedio]  })
			Aadd(_aDado,{"Giro"          ,10, aSimil[nPosSimil][_nPGMM_Giro]        })
			
			_cDado := ""
			
			GeraAud("")
			
			// Recebe vetor _aDado e cria cabecalho - Nao retorna nada!
			_CriaCabec(_aDado,_cDado)
			
			GeraAud("")
			
		EndIf
		
	Else
		//-> Auditoria
		If !Empty(_ChaveAud) .And. _ChaveAud==cSimil_Eis
			
			GeraAud("")
			GeraAud("Posicao do Vetor:")
			
			//_nPGMM_AcmEntr       1
			//_nPGMM_AcmSaida      2
			//_nPGMM_Saldo         3
			//_nPGMM_AcmSld        4
			//_nPGMM_Acm_dDias     5
			//_nPGMM_Dias_AcmSld   6
			//_nPGMM_SaldoMedio    7
			//_nPGMM_Giro          8
			
			_aDado := {}
			Aadd(_aDado,{"AcmEntr"       ,10, aSimil[nPosSimil][_nPGMM_AcmEntr]     })
			Aadd(_aDado,{"AcmSaida"      ,10, aSimil[nPosSimil][_nPGMM_AcmSaida]    })
			Aadd(_aDado,{"Saldo"         ,10, aSimil[nPosSimil][_nPGMM_Saldo]       })
			Aadd(_aDado,{"AcmSld"        ,10, aSimil[nPosSimil][_nPGMM_AcmSld]      })
			Aadd(_aDado,{"Acm_dDias"     ,10, aSimil[nPosSimil][_nPGMM_Acm_dDias]   })
			Aadd(_aDado,{"Dias_AcmSld"   ,11, aSimil[nPosSimil][_nPGMM_Dias_AcmSld] })
			Aadd(_aDado,{"SaldoMedio"    ,10, aSimil[nPosSimil][_nPGMM_SaldoMedio]  })
			Aadd(_aDado,{"Giro"          ,10, aSimil[nPosSimil][_nPGMM_Giro]        })
			
			_cDado := ""
			
			GeraAud("")
			
			// Recebe vetor _aDado e cria cabecalho - Nao retorna nada!
			_CriaCabec(_aDado,_cDado)
			
			GeraAud("")
			
		EndIf
		
	EndIf
	
EndDo

DbSelectArea( _cAlias )
DbCloseArea()

Return
