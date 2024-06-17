
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TKGRPED   ºAutor  ³Winston D. de Castroº Data ³  09/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executado no inicio da gravacao do atendimento da rotina de º±±
±±º          ³TELEVENDAS.Caso a operacao seja Orcamento verifica se foi   º±±
±±º          ³selecionada a forma de pagamento.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7 - SIGATMK - CALL CENTER(TMKA271) - BGL                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TKGRPED(nLiquido,aParcelas,cOper,cNum,cCodLig,cCodPagto,cOpFat)

	Local lRet     := .T.
	Local aArea    := GetArea()
	Local aAreaSUA := SUA->(GetArea())
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSF4 := SF4->(GetArea())
	Local aAreaSE4 := SE4->(GetArea())
	Local lOk      := .F.
	Local nTPesoLiq := 0  // Total do Peso Liquido
	Local nPesoLiq  := 0  // Peso Liquido do Produto
	Local nPesoBru  := 0  // Peso Bruto do Produto
	Local nReg
	local cQuery    := ""
	Local nBaseIPI  :=100
	Local nIPI      :=0
	Local nValBase  := 0
	Local nVipi     :=0
	Local nPosPes   :=0
	Local oTransp
	Local cTransp := ""
	Private nPosTransp := 0
	Private cObsTransp := ""
	Private oObsCliente
	Private oValFrete
	Private oValFrete_
	Private cOpcao := ""
	Private cMsgExp := ""
	Private aMarcados[2], nMarcado := 0
	Private cCliente := M->UA_CLIENTE
	Private oMark
	Private cMarca
	Private lInverte := .f.
	Private aCampos  := {}
	Private nValorT  := aValores[6]
	Private oValorT
	Private oLbx
	Private nTPesoBru := 0  // Total do Peso Bruto
	Private oTPesoBru
	Private oDlg,oPagTmk,oFretTipo,oFretTipo_,oFretTran,oFretTran_,oFretRede,oFretRede_,oPedCli,oPedCli2
	Private aStruct := {}
	Private cFilialSF4 := xFilial("SF4")
	Private aTransp :={}
	Private cUltPed := ""
	Private nCont := 1
	Private cMunCli := SA1->A1_BGCODMU
	Private cMunRedCli := SA1->A1_BGMNRDC
	Private nRadio := 1
	Private lTravaTransp
	Private lRedes := .F.
	Private cUltTipoFrete, cUltTransp, cUltRedespacho, nFrete

	If Empty(SA1->A1_BGMNRDC)
		cMunRedCli := "009668" // São Paulo
	EndIf

	If !Empty(M->UA_BGREDES)
		nRadio := 2
		lRedes := .T.
	Endif

	// Verifica se a data de entrega é sabado ou domingo
	If DOW(M->UA_BGDTENT) == 1
		MsgInfo ("A data de entrega é um domingo. Confira.", "Atenção")
	ElseIf DOW(M->UA_BGDTENT) == 7
		MsgInfo ("A data de entrega é um sábado. Confira.", "Atenção")
	EndIf

	// Verifica se a data de entrega é menor que a de emissão
	If lRet .And. (M->UA_BGDTENT < M->UA_EMISSAO)
		Alert ("A data de entrega é inferior a data de emissão. Corrija a data de entrega.", "Erro")
		lRet := .F.
	EndIf

	// Calcula o peso liquido e bruto dos produtos
	For nReg := 1 To Len(aCols)
		If !(aCols[nReg][Len(aHeader)+1]) // Caso a linha nao esteja apagada
			nPesoLiq  := Posicione("SB1",1,xFilial("SB1") + aCols[nReg][GdFieldPos("UB_PRODUTO")],"B1_PESO")
			nTPesoLiq := nTPesoLiq + (nPesoLiq * aCols[nReg][GdFieldPos("UB_QUANT")])
			nTPesoBru := nTPesoLiq
		EndIf
	Next

	// Verifica peso ao confirmar um atendimento
	If M->UA_BGPLIQ > 0 .And. M->UA_BGPLIQ <> nTPesoLiq .Or. M->UA_BGPBRUT > 0 .And. M->UA_BGPBRUT <> nTPesoBru
		If Aviso("Erro no Peso!","Peso Liquido Calculado: "+AllTrim(Str(nTPesoLiq))+CRLF;
			+"Peso Liquido Atual: "+AllTrim(Str(M->UA_BGPLIQ))+CRLF +CRLF;
			+"Peso Bruto Calculado: "+AllTrim(Str(nTPesoBru))+CRLF;
			+"Peso Bruto Atual: "+AllTrim(Str(M->UA_BGPBRUT))+CRLF +CRLF;
			,{"Sim","Nao"},3,"Deseja continuar ?") == 2
			lRet := .F.
		EndIf
	EndIf

	// Se o usuário informou peso manual, atualiza as variáveis
	If M->UA_BGPLIQ > 0
		nTPesoLiq := M->UA_BGPLIQ
	EndIf
	/*
	If M->UA_BGPBRUT > 0
		nTPesoBru := M->UA_BGPBRUT
	EndIf
	*/


	If lRet .And. (M->UA_BGIMPRE == "S")
		If Aviso("Atenção","Deseja imprimir novamente?",{"Sim","Nao"},,"Pedido já impresso!") == 1
			M->UA_BGIMPRE := "N"
		EndIf
	EndIf

	If lRet .And. (!Empty(M->UA_OBS) .Or. !Empty(M->UA_BGDTAGEN))
		oSvc := WSCallCenterService():New()
		
		oSvc:centidade_type = "SA1"
		oSvc:centidade_id = M->UA_CLIENTE+M->UA_LOJA
		oSvc:ccontato_id = M->UA_CODCONT

		oSvc:ccomunicacao_id = M->UA_BGCOMUN
		oSvc:cobjetivo_id = "1.07"
		oSvc:coperador_id = M->UA_BGAOPER
		oSvc:catendimento_old_id = M->UA_BGNUMAT
		oSvc:catendimento_id = M->UA_NUM
		oSvc:ctexto = AllTrim(M->UA_OBS)
		oSvc:cdata = dtos(M->UA_EMISSAO)
		oSvc:cdata_prevista = dtos(M->UA_BGDTAGE)
		
		If oSvc:ValidaChamado()
			If oSvc:creturn != "valido"
				MsgAlert("Para incluir um chamado, preencha os campos a seguir:"+CRLF+;
				"- Contato"+CRLF+;
				"- Comunicação"+CRLF+;
				"- Observação"+CRLF+;
				"- Data da Agenda"+CRLF+;
				"- Operador da Agenda")
				lRet := .F.
			EndIf
		Else
			MsgStop("Erro na comunicação com o sistema de chamados. Retire a data da agenda para continuar.")
			lRet := .F.
		EndIf
		
		oSvc := nil
		
	EndIf

	If lRet
		
		If INCLUI
			M->UA_OPER = ""
		EndIf
		
		Aadd(aStruct, {"WK1MARCA","C",1,0})
		Aadd(aStruct, {"WK1PED" ,"C",6,0})
		Aadd(aStruct, {"WK1DATA" ,"D",8,0})
		Aadd(aStruct, {"WK1VALOR" ,"N",12,0})
		Aadd(aStruct, {"WK1PESO" ,"N",12,2})
		Aadd(aStruct, {"WK1TRANSP" ,"C",50,0})
		Aadd(aStruct, {"WK1ATEND" ,"C",6,0})
		Aadd(aStruct, {"WK1TPFRETE" ,"C",1,0})
		Aadd(aStruct, {"WK1VALFRET" ,"N",12,2})
		
		cArqTrab1  := CriaTrab(aStruct)
		dbUseArea(.T.,,cArqTrab1,"WORK1",.T.,.F.)
		
		
		//³Seleciona os pedidos para criação de arquivo do select
		cQuery := "select UA_NUM, C5_TPFRETE,C5_BGDTENT,C5_EMISSAO,C5_NUM, C6_VALOR, C6_PRCVEN,C6_QTDVEN, B1_PESBRU, A4_NREDUZ, F4_BASEIPI, B1_IPI, F4_IPI "
		cQuery += "from SC5010 "
		cQuery += " inner join SC6010 on (C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = C5_NUM and SC6010.D_E_L_E_T_ = '') "
		cQuery += "LEFT OUTER JOIN SF4010 ON (F4_FILIAL = '"+cFilialSF4+"' AND F4_CODIGO = C6_TES AND SF4010.D_E_L_E_T_='') "
		cQuery += "inner join SB1010 on (B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = C6_PRODUTO AND SB1010.D_E_L_E_T_='') "
		cQuery += "inner join SA4010 on (A4_FILIAL = '"+xFilial("SA4")+"' AND A4_COD = C5_TRANSP AND SA4010.D_E_L_E_T_='') "
		cQuery += "inner join SUA010 on (UA_FILIAL = '"+xFilial("SUA")+"' AND UA_NUMSC5 = C5_NUM AND SUA010.D_E_L_E_T_='') "
		cQuery += "where C5_CLIENTE = '"+M->UA_CLIENTE+"' AND C5_BGDTENT >= '"+DtoS(dDataBase - 40)+"' AND C5_BGDTENT <= '"+DtoS(dDataBase + 5)+"' AND C5_NOTA = '' "
		cQuery += "and C5_FILIAL = '"+xFilial("SC5")+"' and SC5010.D_E_L_E_T_ = '' order by SC5010.C5_EMISSAO "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"PED",.T.,.T.)
		
		TcSetField("PED","C5_BGDTENT","D")
		
		dbSelectArea("PED")
		dbGoTop()
		dbSelectArea("WORK1")
		WORK1->(DbGobottom())

		While !PED->(EOF())
			
			
			IF PED->F4_IPI == "S"
				nBaseIPI := IIF(PED->F4_BASEIPI > 0,PED->F4_BASEIPI,100)
				nIPI     := PED->B1_IPI
				nValBase := PED->C6_PRCVEN * PED->C6_QTDVEN
				nVipi    := NoRound(nValBase * (nIPI/100)*(nBaseIPI/100),2)
			Endif
			
			If PED->C5_NUM <> cUltPed
				RecLock("Work1",.T.)
				WORK1->WK1PED    := PED->C5_NUM
				WORK1->WK1DATA   := PED->C5_BGDTENT
				WORK1->WK1VALOR  := (PED->C6_VALOR + nVipi)
				WORK1->WK1PESO   := (PED->B1_PESBRU * PED->C6_QTDVEN)
				WORK1->WK1TRANSP := PED->A4_NREDUZ
				WORK1->WK1ATEND  := PED->UA_NUM
				WORK1->WK1TPFRETE := PED->C5_TPFRETE
				MSUNLOCK()
			Else
				RecLock("Work1",.F.)
				WORK1->WK1VALOR  += (PED->C6_VALOR + nVipi)
				WORK1->WK1PESO   += (PED->B1_PESBRU * PED->C6_QTDVEN)
				MSUNLOCK()
			Endif
			cUltPed := PED->C5_NUM
			
			PED->(dbSkip())
		End
		PED->(dbCloseArea())
		
		Aadd(aCampos, {"WK1MARCA",," "})
		Aadd(aCampos, {"WK1PED" ,,"Pedido"})
		Aadd(aCampos, {"WK1DATA" ,,"Data Ent."})
		Aadd(aCampos, {"WK1VALOR" ,,"Valor","@E 9,999,999.99"})
		Aadd(aCampos, {"WK1PESO" ,,"Peso"})
		Aadd(aCampos, {"WK1TPFRETE" ,,"Tipo"})
		Aadd(aCampos, {"WK1TRANSP" ,,"Transportadora"})
		
		lTravaTransp := Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE,"A1_BGTTRAN")

		DBSELECTAREA("WORK1")
		
		DEFINE FONT fBig BOLD
		DEFINE MSDIALOG oDlg FROM 1,1 TO 665,770 PIXEL TITLE "Análise Crítica do Contrato"
		
		WORK1->(dbgotop())
		
		@  5,7 SAY oPedCli PROMPT "Tipo Atendimento" FONT fBig PIXEL
		@  13,7 COMBOBOX M->UA_OPER ITEMS {"", "1=Faturamento","2=Orçamento"} VALID M->UA_OPER $ "12" WHEN Tk271TpOper() ON CHANGE ValidPedCli() SIZE 65, 20 PIXEL
		
		// --------------
		@  5,142 SAY oPedCli PROMPT "Pedido Cliente" FONT fBig PIXEL
		@  13,142 GET oPedCli2 VAR M->UA_BGPEDCL SIZE 80,7 PICTURE PesqPict("SUA","UA_BGPEDCL") FONT fBig ON CHANGE ValidPedCli() PIXEL
		
		// --------------
		@  30,7 GET M->UA_BGREV1 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  31,23 SAY "Dados Cadastrais" FONT fBig PIXEL
		
		@  40,10 SAY SA1->A1_NOME PIXEL
		@  46,10 SAY SA1->A1_CGC PICTURE "@R 99.999.999/9999-99" PIXEL
		@  52,10 SAY AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST) PIXEL
		
		// --------------
		@  65,7 GET M->UA_BGREV3 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  66,23 SAY "Prazo de Entrega" FONT fBig PIXEL
		
		@  75,10 SAY oDtEnt PROMPT M->UA_BGDTENT PIXEL
		If M->UA_BGDTENT==M->UA_EMISSAO
			@  75,50 SAY oDtEnt_ PROMPT "Imediato" PIXEL
		Else
			@  75,50 SAY oDtEnt_ PROMPT AllTrim(Str(M->UA_BGDTENT-M->UA_EMISSAO)) + " dias" PIXEL
		EndIf

		// --------------
		@  88,7 GET M->UA_BGREV2 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  89,23 SAY "Quantidades" FONT fBig PIXEL
		
		// --------------
		@  30,142 GET M->UA_BGREV5 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  31,158 SAY "Preço" FONT fBig PIXEL
		
		@  40,145 SAY "Valor Mercadoria:" PIXEL
		@  40,195 SAY "R$" PIXEL
		@  40,205 SAY aValores[1] PICTURE "@E 999,999,999.99" PIXEL
		
		@  46,145 SAY "Total do Pedido:" PIXEL
		@  46,195 SAY "R$" PIXEL
		@  46,205 SAY aValores[6] PICTURE "@E 999,999,999.99" PIXEL
		
	
		// -----------------------------------------------------
		@  65,142 GET M->UA_BGREV6 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  66,158 SAY "Cond. Pagamento" FONT fBig PIXEL
		
		@  75,145 SAY oPagTmk PROMPT cCodPagto + " - " + SE4->E4_DESCRI PIXEL
		
		// --------------
		@ 88,142 GET M->UA_BGREV4 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@ 89,158 SAY "Esp. Técnica" FONT fBig PIXEL

		// --------------
		@  13,257 GET M->UA_BGREV7 SIZE 10,7 WHEN M->UA_OPER=="1" PICTURE "@!" PIXEL
		@  14,273 SAY "Transporte" FONT fBig PIXEL
		
		@  33,260 SAY oFretTipo PROMPT "Tipo:" PIXEL
		@  39,265 SAY oFretTipo_ PROMPT IIf(M->UA_TPFRETE = "F","FOB (Por conta do cliente)", "CIF (Por conta da BGL)") PIXEL
		
		@  48,260 SAY oFretTran PROMPT "Transportadora:" PIXEL
		@  54,265 SAY oFretTran_ PROMPT IIf(Empty(M->UA_TRANSP), "NENHUMA", Alltrim(M->UA_TRANSP) + " - " + Posicione("SA4",1,xFilial("SA4")+M->UA_TRANSP,"A4_NREDUZ")) PIXEL
		
		@  63,260 SAY oFretRede PROMPT "Redespacho:" PIXEL
		@  69,265 SAY oFretRede_ PROMPT IIf(Empty(M->UA_BGREDES), "NENHUMA", Alltrim(M->UA_BGREDES) + " - " + Posicione("SA4",1,xFilial("SA4")+M->UA_BGREDES,"A4_NREDUZ")) PIXEL

		oGroup := tGroup():New(81,257,136,378,"Último Transporte",oDlg,,,.T.)
		
		UlTransp(M->UA_CLIENTE, M->UA_LOJA, DtoS(dDataBase))
		
		@  91,260 SAY uoFretTipo PROMPT "Tipo:" OF oGroup PIXEL
		@  97,265 SAY uoFretTipo_ PROMPT cUltTipoFrete OF oGroup PIXEL
		
		@  91,340 SAY uoFretVal PROMPT "Valor:" OF oGroup PIXEL
		@  97,345 SAY uoFretVal_ PROMPT nFrete PICTURE "@E 9,999.99" OF oGroup PIXEL

		@  106,260 SAY uoFretTran PROMPT "Transportadora:" OF oGroup PIXEL
		@  112,265 SAY uoFretTran_ PROMPT cUltTransp OF oGroup PIXEL
		
		@  121,260 SAY uoFretRede PROMPT "Redespacho:" OF oGroup PIXEL
		@  127,265 SAY uoFretRede_ PROMPT cUltRedespacho OF oGroup PIXEL

		//-------------
		If lTravaTransp = .T.
			@  119,7 SAY oObsCliente PROMPT "TRANSPORTADORA TRAVADA A PEDIDO DO CLIENTE"  FONT fBig PIXEL
			oObsCliente:nClrText := rgb(255,0,0)
		Endif

		@ 129,7 SAY "Selecione pedidos extras a serem inclusos:" FONT fBig PIXEL
		
		//--------------------------------------------------------------------------------------------------------------
		oMark := MsSelect():New("WORK1","WK1MARCA",,aCampos,@lInverte,@cMarca,{141,7,193,378})
		oMark:oBrowse:lHasMark := .T.
		oMark:bAval := {|| ChkMarca1() }
		
		oDlg:lEscClose	:= .F. //Nao permite sair ao se pressionar a tecla ESC.
		
		//--------------------------------------------------------------------------------------------------------------
		@ 193,260 RADIO nRadio SIZE 100,10 ITEMS "Entrega Direta p/ Cliente", "Com Redespacho ("+;
			AllTrim(Posicione("SZZ",1,xFilial("SZZ")+cMunRedCli,"ZZ_DESCRIC"))+"-"+;
			AllTrim(Posicione("SZZ",1,xFilial("SZZ")+cMunRedCli,"ZZ_ESTADO"))+;
			")" ON CHANGE AtuTransp() PIXEL
		
		@ 203,07 SAY oTransp Var "Transportadoras" SIZE  50, 7 OF oDlg PIXEL
		@ 213,07 LISTBOX oLbx FIELDS HEADER "Cod","Descricao","Valor Frete"," % Frete-Nota","Prazo de","Prazo ate" SIZE 370,97 OF oDlg PIXEL ON DBLCLICK(nPosTransp := oLbx:nAt,bgAltTela())
		//------------------------------------------------------------------------------------------------------------------
		
		//DEFINE SBUTTON FROM 320,175 TYPE 18   ACTION (U_bgTelaTransp(cCliente,nTPesoBru,nValorT))  ENABLE OF oDlg ONSTOP "Escolha de transportadora"
		TButton():New(311,320,"CIF",oDlg,{|| (bgAltTipo("C"))},28,10,,,.T.,.T.,,"Alterar pedidos para CIF",,,,)
		TButton():New(311,350,"FOB",oDlg,{|| (bgAltTipo("F"))},28,10,,,.T.,.T.,,"Alterar pedidos para FOB",,,,)
			
		@ 313,7 SAY "Peso Total:"  PIXEL
		@ 313,38 SAY oTPesoBru PROMPT nTPesoBru PICTURE "@E 999,999,999.99" SIZE 40, 7 OF oDlg PIXEL
		
		@ 323,7 SAY "Preço total:" PIXEL
		@ 323,38 Say oValor PROMPT nValorT PICTURE "@E 999,999,999.99" SIZE 40, 7 OF oDlg PIXEL
		
		@  323,80 SAY oValFrete PROMPT "Valor Frete:"  PIXEL
		@  323,112 GET _oValFrete VAR aValores[4] SIZE 50,7 PICTURE PesqPict("SUA","UA_FRETE") WHEN M->UA_TPFRETE=="C" PIXEL
		
		AtuTransp()

		DEFINE SBUTTON TYPE 1 FROM 323,325 PIXEL OF oDlg ENABLE ACTION { || IIf (ValidX(nLiquido,aParcelas,cOper,cNum,cCodLig,cCodPagto,aTransp), lOK := .T., nil), IIf(lOK,oDlg:End(),nil) }
		DEFINE SBUTTON TYPE 2 FROM 323,355 PIXEL OF oDlg ENABLE ACTION { || oDlg:End() }
		
		Avermeia(oPagTmk,,cCodPagto != SA1->A1_COND)
		Avermeia(oFretTipo,oFretTipo_,SA1->A1_TPFRET != M->UA_TPFRETE)
		Avermeia(oFretTran,oFretTran_,SA1->A1_TRANSP != M->UA_TRANSP)
		Avermeia(oFretRede,oFretRede_,SA1->A1_BGREDES != M->UA_BGREDES)
		Avermeia(oDtEnt,oDtEnt_,M->UA_BGDTENT != M->UA_EMISSAO)
		
		ValidPedCli()
		
		ACTIVATE MSDIALOG oDlg CENTER
		
		If !lOk
			If Empty(M->UA_OPER)
				M->UA_OPER = "2"
			EndIf
			lRet = .F.
		EndIf
		
		WORK1->(DBCLOSEAREA())
		fErase(cArqTrab1+GetDBExtension())	
		fErase(cArqTrab1+OrdBagExt())
	EndIf
	
	If lRet .And. lRedes .And. Empty(M->UA_BGREDES)
		MsgStop("A opção para redespacho foi selecionada, porém não foi escolhida uma transportadora para redespacho no atendimento!" + CRLF + CRLF + "Volte na edição do atendimento e escolha uma transportadora para redespacho.", "Redespacho")
		lRet := .F.
	EndIf

	If lRet
		If !lRedes
			M->UA_BGREDES := ""
		Endif
	EndIf
	
	RestArea(aAreaSUA)
	RestArea(aAreaSC5)
	RestArea(aAreaSF4)
	RestArea(aAreaSE4)
	RestArea(aArea)

	Return lRet
//--------------------------------------------------------------------------------------------------------------------------------

Static Function bgAltTela()
	Local cDescTran := ""
	Local nValFrete := aTransp[nPosTransp,4]
	Local nTransp := aTransp[nPosTransp,1]

	If lTravaTransp == .T.
		alert("Transportadora travada no cadastro de cliente, para efetuar alteração da mesma altere os dados cadastrais do cadastro de cliente")
	Else
		M->UA_TRANSP := nTransp
	Endif

	cDescTran := Posicione("SA4",1,xFilial("SA4")+M->UA_TRANSP,"A4_NREDUZ")

	DBSELECTAREA("WORK1")
	WORK1->(dbgotop())
	While ! WORK1->(EOF())
		If AllTrim(WORK1->WK1MARCA) # ""
			RecLock("WORK1",.F.)
			WORK1->WK1TRANSP := cDescTran
			If avalores[4] > 0
				WORK1->WK1VALFRET := avalores[4]
			Else
				WORK1->WK1VALFRET := nValFrete
			Endif
			MSUNLOCK()
		Endif
		WORK1->(dbSkip())
	End
	WORK1->(dbgotop())
	oMark:oBrowse:Refresh()
	oFretTran_:Refresh()

//--------------------------------------------------------------------------------------------------------------------------------

Static Function bgAltTipo(cOpcao)

	DBSELECTAREA("WORK1")
	WORK1->(dbgotop())
	While ! WORK1->(EOF())
		If AllTrim(WORK1->WK1MARCA) # ""
			RecLock("WORK1",.F.)
			WORK1->WK1TPFRETE := cOpcao
			MSUNLOCK()
		Endif
		WORK1->(dbSkip())
	End
	WORK1->(dbgotop())
	M->UA_TPFRETE := cOpcao
	oMark:oBrowse:Refresh()
	LimpaTransp()
//--------------------------------------------------------------------------------------------------------------------------------


Static Function ValidPedCli()
	LimpaTransp	()
	Avermeia(oPedCli,oPedCli2,(M->UA_OPER=="2".And.!Empty(M->UA_BGPEDCL)).Or.(M->UA_OPER=="1".And.Empty(M->UA_BGPEDCL)),.F.)

Static Function ValidX(nLiquido,aParcelas,cOper,cNum,cCodLig,cCodPagto,aTransp) // Por falta de um nome melhor, usei esse
	Local lRet := .T.
	Local cTransp := M->UA_TRANSP
	If M->UA_OPER = "1" // Pedido
		
		// Análise crítica deve estar preenchida
		If !(M->UA_BGREV1 == "X" .and. M->UA_BGREV2 == "X" .and. M->UA_BGREV3 == "X" .and. M->UA_BGREV4 == "X" .and. M->UA_BGREV5 == "X" .and. M->UA_BGREV6 == "X" .and. M->UA_BGREV7 == "X")
			Alert ("Faça a análise crítica do contrato, preenchendo os campos.", "Erro")
			lRet := .F.
		EndIf
		
		If lRet
			If alltrim(M->UA_TRANSP) == ""
					Alert ("Escolha uma transportadora.", "Erro")
					lRet := .F.
			Else
				//Altera transportadoras dos pedidos selecionados na tela do select
						
				dbSelectArea("SA1")
				dbSetOrder(1)
				
				dbSelectArea("SC5")
				dbSetOrder(1)
				
				dbSelectArea("SUA")
				dbSetOrder(1)
				
				DBSELECTAREA("WORK1")
	
				WORK1->(dbgotop())
				While ! WORK1->(EOF())
					If AllTrim(WORK1->WK1MARCA) # ""
						If !Empty(cMsgExp)
							cMsgExp += " | "
						EndIf
						cMsgExp += WORK1->WK1PED+" -> "+ DtoC(WORK1->WK1DATA)
					
						If SC5->(dbSeek(xFilial("SC5")+WORK1->WK1PED))
							RecLock("SC5",.F.)
							If M->UA_TPFRETE=="C" //WORK1->WK1TPFRETE == "C"
								SC5->C5_TPFRETE := M->UA_TPFRETE //WORK1->WK1TPFRETE
								SC5->C5_TRANSP := cTransp
								If avalores[4] > 0
									SC5->C5_FRETE := (avalores[4]/nCont)
								Endif
							Endif
							MSUNLOCK()
						Endif
						
						If SUA->(dbSeek(xFilial("SUA")+WORK1->WK1ATEND))
							RecLock("SUA",.F.)
							If M->UA_TPFRETE=="C" //WORK1->WK1TPFRETE == "C" 
								SUA->UA_TPFRETE := M->UA_TPFRETE //WORK1->WK1TPFRETE
								SUA->UA_TRANSP := cTransp
								If avalores[4] > 0
									SUA->UA_FRETE := (avalores[4]/nCont)
								Endif
							Endif
							MSUNLOCK()
						End if
					Endif
					WORK1->(dbSkip())
				End
				If !Empty(cMsgExp)
					M->UA_BGOBS2 := "Pedidos anteriores agrupados: "+cMsgExp
				Endif	
			Endif
		Endif	
		If lRet 
			If M->UA_TPFRETE == "C"
				avalores[4] := (avalores[4]/nCont)
			Elseif M->UA_TPFRETE == "F" .and. avalores[4] > 0
				If MsgYesNo("Tipo de frete igual a FOB, deseja incluir o valor digitado?", "Atenção")
					avalores[4] := (avalores[4]/nCont)
				Else
					avalores[4] := 0
				Endif
			Else
				avalores[4] := 0
			Endif	
		Endif	
	ElseIf M->UA_OPER = "2" // Orçamento
		
		// Análise crítica não deve estar preenchida
		If M->UA_BGREV1 == "X" .or. M->UA_BGREV2 == "X" .or. M->UA_BGREV3 == "X" .or. M->UA_BGREV4 == "X" .or. M->UA_BGREV5 == "X" .or. M->UA_BGREV6 == "X" .or. M->UA_BGREV7 == "X"
			Alert ("Corrija a análise crítica do contrato.", "Erro")
			lRet := .F.
		EndIf
		
		// Transportadora deve ser selecionada
		dbSelectArea("SE4")
		dbSetOrder(1)
		If lRet .And. !dbSeek(xFilial("SE4") + cCodPagto)
			Help(" ",1,"FALTA_PGTO")
			lRet := .F.
		Endif
	EndIf
	Return(lRet)


Static Function Avermeia(a,b,c,d)
	Static fBold
	If fBold == nil
		DEFINE FONT fBold BOLD
	EndIf
	DEFAULT c := .T.
	DEFAULT d := .T.

	If c
		a:nClrText := rgb(255,0,0)
		If d
			a:SetFont(fBold)
		EndIf
		If b != nil
			b:nClrText := rgb(255,0,0)
			If d
				b:SetFont(fBold)
			EndIf
		EndIf
	Else
		a:nClrText := rgb(0,0,0)
		If d
			a:SetFont(oDlg:oFont)
		EndIf
		If b != nil
			b:nClrText := rgb(0,0,0)
			If d
				b:SetFont(oDlg:oFont)
			EndIf
		EndIf
	EndIf

Static Function AtuTransp()
	
	If nRadio == 2
		aTransp := U_bgFrete(cMunRedCli, nTPesoBru, nValorT)
		lRedes  := .T.
	Else
		aTransp := U_bgFrete(cMunCli, nTPesoBru, nValorT)
		lRedes  := .F.
	Endif
	
	oFretRede:lVisibleControl := lRedes
	oFretRede_:lVisibleControl := lRedes
	oValor:Refresh()
	oLbx:SetArray(aTransp)
	
	If Len(aTransp) > 0
		oLbx:bLine:={ || {aTransp[oLbx:nAt,1],aTransp[oLbx:nAt,6],Transform(aTransp[oLbx:nAt,4], "@E 9,999,999.99"),aTransp[oLbx:nAt,5],aTransp[oLbx:nAt,2],aTransp[oLbx:nAt,3]}}
	Else
		oLbx:bLine:={ || {,}}
	EndIf

	oLbx:Refresh()


//Marca e desmarca os pedidos dentro do grid
Static Function ChkMarca1()

	Local n

	Begin Sequence
	IF ! Work1->(Eof() .Or. Bof())
		IF !Empty(Work1->WK1MARCA)
			// Desmarca
			n := aScan(aMarcados,Work1->WK1PED)
			IF n > 0
				aMarcados[n] := ""
			Endif
			
			nTPesoBru -= WORK1->WK1PESO
			
//			If Work1->WK1TPFRETE == "C"
				nValorT -= WORK1->WK1VALOR
//			End
			
			IF RecLock("WORK1",.F.)
				Work1->WK1MARCA := sPACE(2)
				MsUnlock()
				dbCommit()
			Endif
			nCont -= 1
		Else
			// Marca
			
			nTPesoBru += WORK1->WK1PESO
			
//			If Work1->WK1TPFRETE == "C"
				nValorT += WORK1->WK1VALOR
//			End
			
			IF RecLock("WORK1",.F.)
				Work1->WK1MARCA := cMarca
				MsUnlock()
				dbCommit()
			Endif
			nCont += 1
		Endif
		oTPesoBru:Refresh()
		
		AtuTransp()
		
	Endif
	End Sequence

Static Function UlTransp(cCliente, cLoja, dData)
Local aArea := GetArea()

	cUltTransp := ""
	cUltTipoFrete := ""
	cUltRedespacho := ""
	nFrete := 0
	cQuery := "SELECT TOP 1 C5_FRETE, C5_TPFRETE, C5_TRANSP, transp.A4_NREDUZ, C5_REDESP, redesp.A4_NREDUZ 'REDESPACHO' FROM SC5010 INNER JOIN SA4010 transp ON transp.A4_COD=C5_TRANSP AND transp.D_E_L_E_T_='' LEFT OUTER JOIN SA4010 redesp ON redesp.A4_COD=C5_REDESP AND redesp.D_E_L_E_T_='' WHERE C5_FILIAL='" + xFilial("SC5") + "' AND C5_CLIENTE='" + cCliente + "' AND C5_LOJACLI='" + cLoja + "' AND SC5010.D_E_L_E_T_='' AND C5_BGDTFAT <= '" + dData + "' ORDER BY C5_BGDTFAT DESC"
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRA",.T.,.T.)
	dbSelectArea("TRA")                 
	cUltTransp := Iif(Empty(TRA->C5_TRANSP), "NENHUMA", AllTrim(TRA->C5_TRANSP) + " - " + AllTrim(TRA->A4_NREDUZ))
	cUltTipoFrete := IIf(TRA->C5_TPFRETE = "F","FOB (Por conta do cliente)", "CIF (Por conta da BGL)")
	cUltRedespacho := Iif(Empty(TRA->C5_REDESP), "NENHUMA", AllTrim(TRA->C5_REDESP) + " - " + AllTrim(TRA->REDESPACHO))
	nFrete := TRA->C5_FRETE
	dbCloseArea("TRA")

	RestArea(aArea)	

Return 

Static Function LimpaTransp()

	If M->UA_OPER == "1" .AND. M->UA_TPFRETE="C" .AND. lTravaTransp == .F. .AND. Alltrim(SA1->A1_TRANSP) == AllTrim(M->UA_TRANSP)
		M->UA_TRANSP=""
		oFretTran_:Refresh()
		Avermeia(oFretTran,oFretTran_,SA1->A1_TRANSP != M->UA_TRANSP)
	Endif                   
Return