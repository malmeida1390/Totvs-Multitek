#INCLUDE "MATA340.CH"
#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA340  � Autor � Eveli Morasco         � Data � 11/03/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera requisicoes e devolucoes para acertar estoque de acor-���
���          � do com a digitacao do inventario                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Rodrigo Sart.�07/08/98�16465A�Acerto na gravacao da data do inventario���
��� Fernando Joly�01/02/99�19590A�Acerto na Impress�o do Relatorio.       ���
���Rodrigo Sart. �22/04/99�XXXXXX�Incluido tratamento p/ INTERNET         ���
���Rodrigo Sart. �13/05/99�21692A�Alterado programa para tratar corretamen���
���              �        �      �te saldos por Lote e Localizacao Fisica ���
���Rodrigo Sart. �01/07/99�22290A�Alterada chamada da funcao CalcEstL     ���
���Fernando Joly �04/08/99�23131A�Cria�ao do Ponto de Entrada MT340D3     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MATA340(lBatch,cCodInv)
//��������������������������������������������������������������Ŀ
//� Salva a Integridade dos dados de Entrada                     �
//����������������������������������������������������������������

LOCAL oDlg,nOpca:=0

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 -Pesquisa e Posiciona em um Banco de Dados              �
//�    2 -Simplesmente Mostra os Campos                          �
//�    3 -Inclui registros no Bancos de Dados                    �
//�    4 -Altera o registro corrente                             �
//�    5 -Estorna registro selecionado gerando uma contra-partida�
//����������������������������������������������������������������

#IFDEF TOP
	TCInternal(5,"*OFF")   // Desliga Refresh no Lock do Top
#ENDIF
lBatch := IIF(lBatch==Nil,.f.,lBatch)
PRIVATE aRotina := { {STR0001,"MATA340" ,0 ,1 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,2 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,3 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,4 ,19},;	//"Processar"
{STR0001,"MATA340" ,0 ,5 ,19} }	//"Processar"

PRIVATE nHdlPrv   	// Endereco do arquivo de contra prova dos lanctos cont.
PRIVATE cLoteEst 		// Numero do lote para lancamentos do estoque
PRIVATE lLocCQ:=.T.	// Flag usado para indicar se criou IndRegua no SD7
PRIVATE cNomArq		//	Nome do arquivo temporario criado pela IndRegua
PRIVATE nNewOrd

IF lBatch
	nOpca := 1
Endif

If __cInternet != Nil
	lBatch := .T.
EndIf
IF !lBatch
	If Substr(cAcesso,19,1) == " "
		Help ( " ", 1, "SEMPERM" )
		Return .F.
	EndIf
	DEFINE MSDIALOG oDlg FROM  96,4 TO 355,625 TITLE OemToAnsi(STR0002) PIXEL	//"Acerto do Invent�rio"
	@ 18, 9 TO 99, 300 LABEL "" OF oDlg  PIXEL
	@ 29, 15 Say OemToAnsi(STR0003) SIZE 275, 10 OF oDlg PIXEL	//"Este programa ir� gerar movimenta��es de ajuste para corrigir o saldo do estoque."
	@ 38, 15 Say OemToAnsi(STR0004) SIZE 275, 10 OF oDlg PIXEL	//"Estas movimenta��es ser�o baseadas nas contagens realizadas e cadastradas na Rotina Invent�rio."
	@ 48, 15 Say OemToAnsi(STR0005) SIZE 275, 10 OF oDlg PIXEL	//"O programa dever� gerar uma Requisi��o ou uma Devolu��o autom�tica, dependendo da diferen�a encontrada."
	@ 58, 15 Say OemToAnsi(STR0006) SIZE 255, 10 OF oDlg PIXEL	//"Nota: Ser� considerado apenas o estoque inventariado na data da sele��o (par�metros)."
	@ 68, 15 Say OemToAnsi(STR0007) SIZE 255, 10 OF oDlg PIXEL	//"Caso algum produto apresente diverg�ncias, ser� gerado um relat�rio."
	@ 78, 15 Say OemToAnsi(STR0008) SIZE 275, 10 OF oDlg PIXEL	//"Se o almoxarifado inventariado for o almoxarifado do CQ, sera considerada como quantidade em estoque "
	@ 88, 15 Say OemToAnsi(STR0009) SIZE 100, 10 OF oDlg PIXEL	//"a quantidade rejeitada."
	DEFINE SBUTTON FROM 108,209 TYPE 5 ACTION Pergunte("MTA340",.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,238 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 108,267 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg
Endif
If nOpca == 1
	If lBatch
		MA340Process(lBatch,cCodInv)
	Else
		Processa({|lend| MA340Process(lBatch)},STR0002,STR0010,.F.)	//"Acerto do Invent�rio"###"Efetuando Acerto do Inventario..."
	Endif
EndIf

If !lLocCQ
	//��������������������������������������������������������������Ŀ
	//� Devolve as ordens originais do arquivo                       �
	//����������������������������������������������������������������
	RetIndex("SD7")
	Set Filter to
	//��������������������������������������������������������������Ŀ
	//� Apaga indice de trabalho                                     �
	//����������������������������������������������������������������
	cNomArq += OrdBagExt()
	Delete File &(cNomArq)
EndIf

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MA340Process� Autor � Rodrigo de A. Sartorio� Data �28/11/95���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processa o Acerto do Inventario.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA340                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MA340Process(lBatch,cCodInv)
LOCAL lOpca,cCod,cLocal,dData,nQuant,nQtSegUm
LOCAL lPassou,cApropri,cNumSeq,aCM:={},aCusto:={},aCM1:={}
LOCAL lDigita,lAglutina,lEstNeg :=If(GetMV('MV_ESTNEG')=='N',.F.,.T.)
LOCAL aSaldo:=Array(7)
LOCAL aLogs:={{}},i,z,cLog:=""
LOCAL nAchou,lMovto:=.F.
LOCAL cLote:="",cLoteCtl:="",dDtValid:="",cNumSerie:="",cLocaliza:=""
LOCAL cLocalCQ:=GetMv("MV_CQ")
LOCAL dDataFec:=GETMV("MV_ULMES")
LOCAL cCusMed :=GETMV("MV_CUSMED")
LOCAL nEmpenho:=0          
LOCAL cAliasSql:="SB7",lQuery:=.F.
Local aStruSB7 := {},cQuery:=""

Do While .T.
	dbSelectArea("SB2")
	IF lBatch
		pergunte("MTA340",.F.)
		//��������������������������������������������������������������Ŀ
		//� Carrega as perguntas selecionadas                            �
		//����������������������������������������������������������������
		If cCodInv#NIL
			MV_PAR01 := SB7->B7_DATA
			MV_PAR03 := 2
			MV_PAR05 := SB7->B7_COD
			MV_PAR06 := SB7->B7_COD
			MV_PAR07 := SB7->B7_LOCAL
			MV_PAR08 := SB7->B7_LOCAL
			MV_PAR09 := Posicione('SB1',1, xFilial('SB1')+SB7->B7_COD,"B1_GRUPO")
			MV_PAR10 := MV_PAR09
			MV_PAR11 := cCodInv
			MV_PAR12 := cCodInv
		EndIf
	Else
		pergunte("MTA340",.F.)
		lOpca:=.T.
	Endif
	//����������������������������������������������������������������Ŀ
	//� mv_par01 - Data a ser considerada                              �
	//� mv_par02 - Em qual centro de custo sera' jogada a diferenca    �
	//� mv_par03 - Se deve mostrar os lancamentos contabeis            �
	//� mv_par04 - Se deve aglutinar os lancamentos contabeis          �
	//� mv_par05 - De  Produto                                         �
	//� mv_par06 - Ate Produto                                         �
	//� mv_par07 - De  Local                                           �
	//� mv_par08 - Ate Local                                           �
	//� mv_par09 - De  Grupo                                           �
	//� mv_par10 - Ate Grupo                                           �
	//� mv_par11 - De  Documento                                       �
	//� mv_par12 - Ate Documento                                       �
	//������������������������������������������������������������������
	IF lBatch
		lOpca := .T.
	Endif
	
	If !lOpca
		Exit
	Else
		//��������������������������������������������������������������Ŀ
		//� Posiciona numero do Lote para Lancamentos do Faturamento     �
		//����������������������������������������������������������������
		dbSelectArea("SX5")
		dbSeek(xFilial()+"09EST")
		cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
		PRIVATE nTotal := 0 	// Total dos lancamentos contabeis
		PRIVATE cArquivo	// Nome do arquivo contra prova
		dbSelectArea("SB7")
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				//������������������������������������������������������������������������Ŀ
				//� Totaliza registros de digitacao de inventario                          �
				//��������������������������������������������������������������������������
				lQuery:=.T.
				cAliasSQL := "SB7SQL"
				aStruSB7 := SB7->(dbStruct())
				cQuery := "SELECT SUM(SB7.B7_QUANT) TOTQUANT, SUM(SB7.B7_QTSEGUM) TOTQUANT2,"
				cQuery += " B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID,B7_DOC  FROM "
				cQuery += RetSqlName("SB7")+" SB7 ,"
				cQuery += RetSqlName("SB1")+" SB1  "
				cQuery += " WHERE SB7.B7_FILIAL='"+xFilial("SB7")+"' AND"
				cQuery += " SB7.B7_DATA='"+DTOS(mv_par01)+"' AND"
				cQuery += " SB7.B7_COD>='"+mv_par05+"' AND SB7.B7_COD<='"+mv_par06+"' AND"
				cQuery += " SB7.B7_LOCAL>='"+mv_par07+"' AND SB7.B7_LOCAL<='"+mv_par08+"' AND"
				cQuery += " SB7.B7_DOC>='"+mv_par11+"' AND SB7.B7_DOC<='"+mv_par12+"' AND"
				cQuery += " SB7.D_E_L_E_T_<>'*' AND"
				cQuery += " SB1.B1_FILIAL='"+xFilial("SB1")+"' AND"
				cQuery += " SB1.B1_COD=SB7.B7_COD AND" 
				cQuery += " SB1.B1_GRUPO>='"+mv_par09+"' AND SB1.B1_GRUPO<='"+mv_par10+"' AND"
				cQuery += " SB1.D_E_L_E_T_<>'*' GROUP BY B7_FILIAL,B7_DATA,B7_COD,B7_LOCAL,B7_LOCALIZ,B7_NUMSERI,B7_LOTECTL,B7_NUMLOTE,B7_DTVALID,B7_DOC" 
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSQL,.F.,.T.)
				For nX := 1 To Len(aStruSB7)
					If aStruSB7[nX][2]<>"C" .And. FieldPos(aStruSB7[nX][1])<>0
						TcSetField(cAliasSQL,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
					EndIf
				Next nX
			Else
				cFilSB7 := 'DTOS(B7_DATA)=="'+dtos(mv_par01)+'".And.'
				cFilSB7 += 'B7_DOC>="'+mv_par11+'".And.B7_DOC<="'+mv_par12+'"'
				MsFilter(cFilSB7)
				dbSetOrder(1)		
				dbSeek(xFilial()+dtos(mv_par01))		
			EndIf		
		#ELSE
			dbSetOrder(1)		
			dbSeek(xFilial()+dtos(mv_par01))		
		#ENDIF
		If !lBatch
			ProcRegua(LastRec(),21,6)
		EndIf
		While !EOF() .And. If(lQuery,.T.,B7_FILIAL+dtos(B7_DATA) == xFilial()+dtos(mv_par01))
			If !lBatch
				IncProc()
			EndIf
			If !lQuery
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo documento digitado                               �
				//����������������������������������������������������������������
				If B7_DOC < mv_par11 .Or. B7_DOC > mv_par12
					dbSkip()
					Loop
				EndIf
				
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo codigo do produto                                �
				//����������������������������������������������������������������
				If B7_COD < mv_par05 .Or. B7_COD > mv_par06
					dbSkip()
					Loop
				EndIf
				
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo almoxarifado inventariado                        �
				//����������������������������������������������������������������
				If B7_LOCAL < mv_par07 .Or. B7_LOCAL > mv_par08
					dbSkip()
					Loop
				EndIf
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//� Filtra itens com digitacao incorreta rastreabilidade         �
			//����������������������������������������������������������������
			If Rastro(B7_COD) .And. Empty(B7_LOTECTL) .Or. (Rastro(B7_COD,"S") .And. Empty(B7_NUMLOTE))
				dbSkip()
				Loop
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//� Filtra itens com digitacao incorreta localizacao fisica      �
			//����������������������������������������������������������������
			If Localiza(B7_COD) .And. Empty(B7_LOCALIZ+B7_NUMSERI)
				dbSkip()
				Loop
			EndIf
			
			cCod     := B7_COD
			cLocal   := B7_LOCAL
			dData    := B7_DATA
			cLote	 := B7_NUMLOTE
			cLoteCtl := B7_LOTECTL
			dDtValid := B7_DTVALID
			nQuant   := 0
			nQtSegUm := 0
			nEmpenho := 0
			cLocaliza:=B7_LOCALIZ
			cNumSerie:=B7_NUMSERI
			
			SB1->(dbSeek(xFilial("SB1")+cCod))

			If !lQuery
				//��������������������������������������������������������������Ŀ
				//� Filtra pelo grupo do produto                                 �
				//����������������������������������������������������������������
				If SB1->B1_GRUPO < mv_par09 .Or. SB1->B1_GRUPO > mv_par10
					dbSkip()
					Loop
				EndIf
				
				Do While !Eof() .And. B7_FILIAL+dtos(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE;
					== xFilial()+dtos(mv_par01)+cCod+cLocal+cLocaliza+cNumSerie+cLoteCtl+cLote
					//��������������������������������������������������������������Ŀ
					//� Filtra pelo documento digitado                               �
					//����������������������������������������������������������������
					If B7_DOC >= mv_par11 .And. B7_DOC <= mv_par12
						nQuant	+=B7_QUANT
						nQtSegum	+=B7_QTSEGUM
					EndIf
					dbSKip()
				EndDo
			Else
				nQuant   := (cAliasSQL)->TOTQUANT
				nQtSegum := (cAliasSQL)->TOTQUANT2
				(cAliasSQL)->(dbSkip())
			EndIf
			
			cApropri := "0"
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !dbSeek(xFilial()+cCod+cLocal)
				CriaSB2(cCod,cLocal)
			EndIf
			If Rastro(cCod) .Or. Localiza(cCod)
				aSaldo:=u_CalcEstL(cCod,cLocal,mv_par01+1,cLoteCtl,cLote,cLocaliza,cNumSerie)
				If Localiza(cCod)
					nEmpenho:=EmpLocLz(cCod,cLocal,cLoteCTL,cLote,cLocaliza,cNumSerie)
					cLog:="SBF"
					aSaldo[7]:=aSaldo[1]*SB1->B1_CONV
				ElseIf Rastro(cCod)
					nEmpenho:=EmpLote(cCod,cLocal,cLoteCTL,cLote)
					cLog:="SB8"
				EndIf
			Else
				If cLocal == cLocalCQ
					aSaldo := A340QtdCQ(cCod,cLocal,mv_par01+1,"")
				Else
					aSaldo := CalcEst(cCod,cLocal,mv_par01+1)
					If !lEstNeg
						nEmpenho:=SB2->B2_RESERVA
						cLog:="SB2E"
					EndIf
				EndIf
			EndIf
			//--> Verifica se o saldo do produto no armazem esta disponivel
			If SB2->B2_STATUS $ "2"
				cLog := "SB2I"
			EndIf
			//�������������������������������������������������Ŀ
			//� Verifica se deve gravar a data do inventario    �
			//� independentemente do saldo em estoque           �
			//���������������������������������������������������
			If SB2->B2_DINVENT <= mv_par01 .And. SB2->B2_STATUS # "2"
				dbSelectArea("SB2")
				RecLock("SB2",.F.)
				Replace B2_DINVENT With mv_par01
				MsUnlockAll()
			EndIf
			If (QtdComp(aSaldo[1]) != QtdComp(nQuant) .Or. QtdComp(aSaldo[7]) != QtdComp(nQtSegum)) .And. B2_DINVENT <= mv_par01
				If QtdComp(nEmpenho) <= QtdComp(nQuant) .And. SB2->B2_STATUS # "2"
					If nHdlPrv == NIL
						//���������������������������������������������Ŀ
						//� Cria o cabecalho do arquivo de prova        �
						//�����������������������������������������������
						nHdlPrv := HeadProva(cLoteEst,"MATA340",Subs(cUsuario,7,6),@cArquivo)
					EndIf
					//��������������������������������������������Ŀ
					//� Pega o numero sequencial do movimento      �
					//����������������������������������������������
					cNumseq := ProxNum()
					dbSelectArea("SD3")
					RecLock("SD3",.T.)
					Replace	D3_FILIAL  With xFilial(),	D3_COD     With cCod,;
						D3_DOC     With "INVENT" ,	D3_EMISSAO With mv_par01,;
						D3_CC      With mv_par02 ,	D3_GRUPO   With SB1->B1_GRUPO,;
						D3_LOCAL   With cLocal   ,	D3_UM      With SB1->B1_UM,;
						D3_NUMSEQ  With cNumSeq  ,	D3_SEGUM   With SB1->B1_SEGUM,;
						D3_CONTA   With SB1->B1_CONTA,;
						D3_QUANT   With Abs(nQuant - aSaldo[1]),;
						D3_QTSEGUM With Abs(nQtSegUm - aSaldo[7]),;
						D3_TIPO    With SB1->B1_TIPO,;
						D3_LOCALIZ With cLocaliza,;
						D3_NUMSERI With cNumSerie,;
						D3_LOTECTL With cLoteCtl,;
						D3_NUMLOTE With cLote,;
						D3_USUARIO With SubStr(cUsuario,7,15),;
						D3_DTVALID With dDtValid
					If aSaldo[1] > nQuant
						Replace D3_TM With "999",D3_CF With "RE"+cApropri
					Else
						Replace D3_TM With "499",D3_CF With "DE"+cApropri
					EndIf
					Replace D3_CHAVE With SubStr(D3_CF,2,1)+IIF(D3_CF=="DE4","9","0")
					
					If (ExistBlock( "MT340D3" ) )
						ExecBlock("MT340D3",.F.,.F.)
					EndIf
					
					If cCusMed == "O"
						//��������������������������������������������Ŀ
						//� Pega os custos medios atuais               �
						//����������������������������������������������
						aCM := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
					Else
						//��������������������������������������������Ŀ
						//� Pega os custos medios finais               �
						//����������������������������������������������
						aCM := PegaCMFim(SD3->D3_COD,SD3->D3_LOCAL)
					EndIf
					//��������������������������������������������Ŀ
					//� Grava o custo da movimentacao              �
					//����������������������������������������������
					aCusto := GravaCusD3(aCM)
					//�������������������������������������������������������Ŀ
					//� Atualiza o saldo atual do estoque com os dados do SD3 �
					//� e caso retorne .T. grava o registro para log de saldo �
					//� negativo.											  �
					//���������������������������������������������������������
					If B2AtuComD3(aCusto,,.F.)
						If !lEstNeg
							For i:=1 to Len(aLogs)
								nAchou:=ASCAN(aLogs[i],{|x| x[1] == "SB2" .And. x[2]+x[3] == SD3->D3_COD+SD3->D3_LOCAL})
								If nAchou > 0
									Exit
								EndIf
							Next i
							If nAchou == 0
								//������������������������������������������������Ŀ
								//� Adiciona registro em array p/ baixar empenho.  �
								//��������������������������������������������������
								If Len(aLogs[Len(aLogs)]) > 4095
									AADD(aLogs,{})
								EndIf
								AADD(aLogs[Len(aLogs)],{"SB2",SD3->D3_COD,SD3->D3_LOCAL,"","","",""})
							EndIf
						EndIf
					EndIf
					//�������������������������������������������������������Ŀ
					//� Atualiza o saldo final do estoque com os dados do SD3 �
					//���������������������������������������������������������
					If dData <= dDataFec
						B2FimComD3(aCusto)
					EndIf
					If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
						//�������������������������������������������������Ŀ
						//� Gera o lancamento no arquivo de prova           �
						//���������������������������������������������������
						If SD3->D3_TM <= "500"
							nTotal+=DetProva(nHdlPrv,"676","MATA340",cLoteEst)
						Else
							nTotal+=DetProva(nHdlPrv,"674","MATA340",cLoteEst)
						EndIf
					EndIf
					aSaldo := CalcEst(SD3->D3_COD,SD3->D3_LOCAL,Ctod("31/12/49","ddmmyy"))
					RecLock("SB2")
					Replace B2_QATU  With aSaldo[1]
					Replace B2_VATU1 With aSaldo[2]
					Replace B2_VATU2 With aSaldo[3]
					Replace B2_VATU3 With aSaldo[4]
					Replace B2_VATU4 With aSaldo[5]
					Replace B2_VATU5 With aSaldo[6]
					MsUnlockAll()
				Else
					For i:=1 to Len(aLogs)
						nAchou:=ASCAN(aLogs[i],{|x| x[1] == cLog .And. x[2]+x[3]+x[4]+x[5]+x[6]+x[7] == cCod+cLocal+cLoteCtl+cLote+cLocaliza+cNumSerie})
						If nAchou > 0
							Exit
						EndIf
					Next i
					If nAchou == 0
						//������������������������������������������������Ŀ
						//� Adiciona registro em array p/ baixar empenho.  �
						//��������������������������������������������������
						If Len(aLogs[Len(aLogs)]) > 4095
							AADD(aLogs,{})
						EndIf
						AADD(aLogs[Len(aLogs)],{cLog,cCod,cLocal,cLoteCtl,cLote,cLocaliza,cNumSerie})
					EndIf
				EndIf
			EndIf
			dbSelectArea(cAliasSql)
		EndDo
		Exit
	EndIf
EndDo

//��������������������������������������������������������������Ŀ
//� Se ele criou o arquivo de prova ele deve gravar o rodape'    �
//����������������������������������������������������������������
If nHdlPrv != NIL .And. (Valtype(nHdlPrv) == "N" .And. nHdlPrv > 0)
	pergunte("MTA340",.F.)
	//����������������������������������������������������������������Ŀ
	//� mv_par01 - Data a ser considerada                              �
	//� mv_par02 - Em qual centro de custo sera' jogada a diferenca    �
	//� mv_par03 - Se deve mostrar os lancamentos contabeis            �
	//� mv_par04 - Se deve aglutinar os lancamentos contabeis          �
	//� mv_par05 - De  Produto                                         �
	//� mv_par06 - Ate Produto                                         �
	//� mv_par07 - De  Local                                           �
	//� mv_par08 - Ate Local                                           �
	//� mv_par09 - De  Grupo                                           �
	//� mv_par10 - Ate Grupo                                           �
	//������������������������������������������������������������������
	lDigita   := Iif(mv_par03 == 1,.T.,.F.)
	lAglutina := Iif(mv_par04 == 1,.T.,.F.)
	RodaProva(nHdlPrv,nTotal)
	cA100Incl(cArquivo,nHdlPrv,3,cLoteEst,lDigita,lAglutina)
EndIf
MsUnlockAll()

If lQuery
	dbSelectArea(cAliasSQL)
	dbCloseArea()
	dbSelectArea("SB7")
Else
	RETINDEX("SB7")
	Set Filter to
EndIf

If Len(aLogs[1]) > 0
	For i:=1 to Len(aLogs)
		For z:=1 to Len(aLogs[i])
			// Verifica saldo em estoque
			If aLogs[i,z,1] == "SB2"
				dbSelectArea("SB2")
				dbSetOrder(1)
				If dbSeek(xFilial()+aLogs[i,z,2]+aLogs[i,z,3])
					If B2_QATU > 0 .And. B2_STATUS # "2"
						aLogs[i,z,1] := "OK"
					EndIf
				EndIf
			EndIf
		Next z
	Next i
	A340LstNeg(aLogs)
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A340LstNeg� Autor �Rodrigo de A. Sartorio � Data � 10/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Produtos que ficaram com o saldo negativo     ���
���          � ou tiveram itens que nao podem ser inventariados           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST/SIGAPCP                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function A340LstNeg(aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio            �
//����������������������������������������������������������������
LOCAL titulo   := STR0014	//"Itens nao Inventariados"
LOCAL cDesc1   := STR0015	//"O relatorio lista os produtos que nao puderam ser inventariados por "
LOCAL cDesc2   := STR0016	//"alguma situacao que impede a correta contagem de seus saldos e lista "
LOCAL cDesc3   := STR0017	//"tb produtos que continuam com saldo divergente apos o processamento."
LOCAL cString  := "SB2"
LOCAL wnrel    := "MATA340"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn:= {STR0018,1,STR0019, 2, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0,cPerg:="      "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=	SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,,,,.F.)
If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| C340Imp(@lEnd,wnRel,titulo,aLogs)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C340IMP  � Autor � Rodrigo de A. Sartorio� Data � 10/01/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA340  			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C340Imp(lEnd,WnRel,titulo,aLogs)
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
LOCAL Tamanho  := "P"
LOCAL nTipo    := 0
LOCAL cRodaTxt := STR0020	//"REGISTRO(S)"
LOCAL nCntImpr := 0
LOCAL i,z

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(Len(aLogs))

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li := 80 ,m_pag := 1

//����������������������������������������������������������Ŀ
//� Cria o cabecalho.                                        �
//������������������������������������������������������������
cabec1 := STR0021	//"OCOR PRODUTO         DESCRICAO       LOCAL   QUANTIDADE     LOTE      SUB-LOTE"
cabec2 := STR0023 //"                                            LOCALIZACAO     NUMERO DE SERIE   "
//                   1234 123456789012345 12345678901234545 12   12345678901234  1234567890 123456
//                                                               123456789012345 12345678901234567890
//                   0         1         2         3         4         5         6         7         8
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890

SB1->(dbSetOrder(1))
SB2->(dbSetOrder(1))

For i:=1 to Len(aLogs)
	IncRegua()
	For z:=1 to Len(aLogs[i])
		If aLogs[i,z,1] != "OK"
			If li > 58
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			SB1->(dbSeek(xFilial("SB1")+aLogs[i,z,2]))
			SB2->(dbSeek(xFilial("SB2")+aLogs[i,z,2]+aLogs[i,z,3]))
			@ li,000 PSay aLogs[i,z,1]
			@ li,005 PSay aLogs[i,z,2] Picture PesqPict("SD3","D3_COD",15)
			@ li,021 PSay Left(SB1->B1_DESC,15) Picture PesqPict("SB1","B1_DESC",15)
			@ li,039 PSay aLogs[i,z,3] Picture PesqPict("SD3","D3_LOCAL",2)
			@ li,044 PSay SB2->B2_QATU	Picture PesqPictQt("B2_QATU",14)
			@ li,060 PSay aLogs[i,z,4]	Picture PesqPict("SB7","B7_LOTECTL",10)
			@ li,071 PSay aLogs[i,z,5]	Picture PesqPict("SB7","B7_NUMLOTE",8)
			If !Empty(aLogs[i,z,6]+aLogs[i,z,7])
				li++
				@ li,044 PSay aLogs[i,z,6]	Picture PesqPict("SB7","B7_LOCALIZ",15)
				@ li,060 PSay aLogs[i,z,7]	Picture PesqPict("SB7","B7_NUMSERI",20)
			EndIf
			li++
		EndIf
	Next z
Next i


IF li != 80
	If li > 55
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ li,10 PSay STR0011  //"Legenda das Ocorrencias"
	li++
	@ li,10 PSay STR0012  //"SB2 - > Itens com saldo negativo nos Saldos em estoque."
	li++
	@ li,10 PSay STR0013  //"SB2E/SB8/SBF - > Itens empenhados / reservados no arquivo SB2/SB8/SBF"
	li++
	@ li,10 PSay STR0024  //"SB2I  - > Itens com saldo Indisponivel nos Saldos em Estoque"
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A340QtdCQ � Autor � Rodrigo de A. Sartorio� Data � 05/05/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Calcula o saldo rejeitado do produto no almoxarifado de CQ. ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MATA340                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A340QtdCQ(cProduto,cLocal,dData,cLote)
Local cAlias:= Alias(), nOrdem := IndexOrd()
Local cCond
Local aQtd:={0,0,0,0,0,0,0}
dbSelectArea("SD7")
If lLocCQ
	cNomArq:= CriaTrab("",.F.)
	cCond:='D7_ESTORNO != "S" .And. D7_TIPO == 2 .And. DTOS(D7_DATA) < "'+DTOS(dData)+'"'
	IndRegua("SD7",cNomArq,"D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE",,cCond,STR0022)	//"Selecionando Registros..."
	nNewOrd:=RetIndex("SD7")
	DbSelectArea("SD7")
	#IFNDEF TOP
		DbSetIndex(cNomArq+OrdBagExt())
	#ENDIF
	lLocCQ:=.F.
	DbSetOrder(nNewOrd+1)
EndIf
dbGotop()
If Empty(cLote)
	dbSeek(xFilial()+cProduto+cLocal)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL == xFilial()+cProduto+cLocal
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
Else
	dbSeek(xFilial()+cProduto+cLocal+cLote)
	Do While !Eof() .And. D7_FILIAL+D7_PRODUTO+D7_LOCAL+D7_NUMLOTE == xFilial()+cProduto+cLocal+cLote
		aQtd[1] += SD7->D7_QTDE
		dbSkip()
	EndDo
EndIf

If aQtd[1] > 0
	// Subtraio qtd. j� devolvida
	dbSelectArea("SD2")
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto+cLocal)
	Do While !Eof() .And. D2_FILIAL+D2_COD+D2_LOCAL == xFilial()+cProduto+cLocal
		If D2_TIPO != "D"
			dbSkip()
			Loop
		EndIf
		dbSelectArea("SF4")
		dbSetOrder(1)
		If dbSeek(xFilial()+SD2->D2_TES) .And. F4_ESTOQUE == "S"
			aQtd[1] -= SD2->D2_QUANT
		EndIf
		dbSelectArea("SD2")
		dbSkip()
	EndDo
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial()+cProduto)
		aQtd[7]:= ConvUm(SB1->B1_COD,aQtd[1],aQtd[7],2)
	EndIf
EndIf
dbSelectArea(cAlias)
dbSetOrder(nOrdem)
Return aQtd




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CalcEstL � Autor �Rodrigo de A. Sartorio � Data � 15/05/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o Saldo inicial por Produto/Local do arquivo SD5   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpA1 := CalcEstL(ExpC1,ExpC2,ExpD1,ExpC3,ExpC4,ExpC5,ExpC6)���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Codigo do Produto                                  ���
���          � ExpC2 = Local (Almoxarifado)                               ���
���          � ExpD1 = Data para obter o Saldo Inicial.                   ���
���          � ExpC3 = Lote                                               ���
���          � ExpC4 = Sub-Lote                                           ���
���          � ExpC5 = Localizacao                                        ���
���          � ExpC6 = Numero de Serie                                    ���
���          � ExpL1 = Verifica se obtem o saldo por Sub-Lote com rastro L���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGACUS                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CalcEstL(cCod,cLocal,dData,cLoteCtl,cNumLote,cLocaliz,cNumSeri,lConsSub)

Local aSaldo     := {0, 0, 0, 0, 0, 0, 0}
Local aAreaAnt   := GetArea()
Local aAreaSBJ   := SBJ->(GetArea())
Local aAreaSBK   := SBK->(GetArea())
Local aAreaSD5   := SD5->(GetArea())
Local aAreaSDB   := SDB->(GetArea())
Local lRastro    := Rastro(cCod)
Local lSRastro   := Rastro(cCod, 'S')
Local lHasRec    := .F.
Local cCompSBJ   := ''
Local cCompSBK   := ''
Local cCompSBK1  := ''
Local cCompSD5   := ''
Local cCompSDB   := ''
Local cCompSDB1  := ''
Local cSeekSBJ   := ''
Local cSeekSBK   := ''
Local cSeekSBK1  := ''
Local cSeekSD5   := ''
Local cSeekSDB   := ''
Local cSeekSDB1  := ''
Local dUltFec    := CtoD('  /  /  ')
Local cFiltroSD5 := ''
#IFDEF TOP
	dbSelectArea("SD5")
	cFiltroSD5 := dbFilter()
	If !Empty(cFiltroSD5)
		cFiltroSD5 += ".And. OrderBy("+StrTran(ClearKey(IndexKey()),"+",",")+")"
		Set Filter To
	EndIf	
#ENDIF			

//�������������������������������������������������������������Ŀ
//� Preenche os parametros n�o inicializados                    �
//���������������������������������������������������������������
dData    := If(dData==Nil, dDataBase, dData)
cLoteCtl := If(cLoteCtl==Nil, CriaVar('D5_LOTECTL'), cLoteCtl)
cNumLote := If(cNumLote==Nil, CriaVar('D5_NUMLOTE'), cNumLote)
cLocaliz := If(cLocaliz==Nil, CriaVar('DB_LOCALIZ'), cLocaliz)
cNumSeri := If(cNumSeri==Nil, CriaVar('DB_NUMSERI'), cNumSeri)
lConsSub := If(Valtype(lConsSub) # "L", .F. ,lConsSub)

//�������������������������������������������������������������Ŀ
//� Verifica se obtem o saldo por Sub-Lote mesmo com rastro L   �
//���������������������������������������������������������������
If lConsSub .And. lRastro .And. !Empty(cNumLote)
	lSRastro:=.T.
EndIf	

//�������������������������������������������������������������Ŀ
//� Retorna o Saldo Inicial da Rastreabilidade (SBJ ou SD5)     �
//���������������������������������������������������������������
If Empty(cLocaliz+cNumSeri) .And. !Empty(cLoteCtl)

	//�������������������������������������������������������������Ŀ
	//�Procura no SBJ por Saldos Iniciais ref. ao Ultimo Fechamento �
	//���������������������������������������������������������������
	dbSelectArea('SBJ')
	dbSetOrder(2)
	cSeekSBJ := xFilial('SBJ') + cCod + cLocal + cLoteCtl
	cCompSBJ := 'BJ_FILIAL+BJ_COD+BJ_LOCAL+BJ_LOTECTL'
	If !Empty(cNumLote) .And. lSRastro
		dbSetOrder(1)
		cSeekSBJ += cNumLote
		cCompSBJ += '+BJ_NUMLOTE'
	EndIf

	dbSeek(cSeekSBJ)
	lHasRec := .F.
	Do While !Eof() .And. cSeekSBJ == &(cCompSBJ)
		If BJ_DATA >= dData .And. lHasRec
			Exit
		Else
			lHasRec := .T.
			dUltFec := If(BJ_DATA>dUltFec .And. BJ_DATA <= dData,BJ_DATA,dUltFec)
		EndIf
		dbSkip()
	EndDo
	If lHasRec
		cSeekSBJ+=DTOS(dUltFec)
		cCompSBJ+="+DTOS(BJ_DATA)"
		dbSeek(cSeekSBJ)
		Do While !Eof() .And. &(cCompSBJ) == cSeekSBJ
			aSaldo[1] += BJ_QINI
			aSaldo[7] += BJ_QISEGUM
			dUltFec   := BJ_DATA
			dbSkip()
		EndDo
	EndIf
	RestArea(aAreaSBJ)

	//�������������������������������������������������������������Ŀ
	//� Procura no SD5 por Movimentacoes posteriores ao Ultimo SBJ  �
	//���������������������������������������������������������������
	If (QtdComp(aSaldo[1]+aSaldo[7])==QtdComp(0)) .Or. (QtdComp(aSaldo[1]+aSaldo[7])>QtdComp(0).And.!Empty(dUltFec))
		dbSelectArea('SD5')
		dbSetOrder(2)
		cCompSD5 := 'D5_FILIAL+D5_PRODUTO+D5_LOCAL+D5_LOTECTL'
		cSeekSD5 := xFilial('SD5')+cCod+cLocal+cLoteCtl

		If !Empty(cNumLote) .And. lSRastro
			cCompSD5 += '+D5_NUMLOTE'
			cSeekSD5 += cNumLote
		EndIf

		If dbSeek(cSeekSD5, .F.)
			Do While !Eof() .And. &(cCompSD5) == cSeekSD5
				If !Empty(dUltFec) .And. D5_DATA <= dUltFec
					dbSkip()
					Loop
				EndIf				
				If D5_DATA < dData .And. D5_ESTORNO # 'S'
					If D5_ORIGLAN<='500' .Or. Substr(D5_ORIGLAN,1,2) $ 'DE�PR�MA'
						aSaldo[1] += D5_QUANT
						aSaldo[7] += D5_QTSEGUM
					Else
						aSaldo[1] -= D5_QUANT
						aSaldo[7] -= D5_QTSEGUM
					EndIf
				EndIf
				dbSkip()
			EndDo
		EndIf
		RestArea(aAreaSD5)
	EndIf

	//�������������������������������������������������������������Ŀ
	//� Retorna o Saldo Inicial da Localiza��o (SBK ou SDB)         �
	//���������������������������������������������������������������
ElseIf !Empty(cLocaliz+cNumSeri)

	//�������������������������������������������������������������Ŀ
	//�Procura no SBK por Saldos Iniciais ref. ao Ultimo Fechamento �
	//���������������������������������������������������������������
	dbSelectArea('SBK')
	dbSetOrder(2)

	cSeekSBK := xFilial('SBK') + cCod + cLocal
	cCompSBK := 'BK_FILIAL+BK_COD+BK_LOCAL'

	cCompSBK1 := 'BK_LOCALIZ+BK_NUMSERI'
	cSeekSBK1 := cLocaliz + cNumSeri
	If lRastro
		cCompSBK1 += '+BK_LOTECTL'
		cSeekSBK1 += cLoteCtl
		If !Empty(cNumLote) .And. lSRastro
			dbSetOrder(1)
			cCompSBK1 += '+BK_NUMLOTE'
			cSeekSBK1 += cNumLote
		EndIf
	EndIf

	If dbSeek(cSeekSBK, .F.)
		Do While !Eof() .And. &(cCompSBK) == cSeekSBK
			If &(cCompSBK1) == cSeekSBK1
				If BK_DATA > dData
					Exit
				EndIf
				aSaldo[1] := BK_QINI
				aSaldo[7] := BK_QISEGUM
				dUltFec   := BK_DATA
				If BK_DATA == dData
					RestArea(aAreaSBK)
					RestArea(aAreaAnt)
					Return aSaldo
				EndIf
			EndIf
			dbSkip()
		EndDo
	EndIf
	RestArea(aAreaSBK)

	//�������������������������������������������������������������Ŀ
	//� Procura no SDB por Movimentacoes posteriores ao Ultimo SBJ  �
	//���������������������������������������������������������������
	If (QtdComp(aSaldo[1]+aSaldo[7])==QtdComp(0)) .Or. (QtdComp(aSaldo[1]+aSaldo[7])>QtdComp(0).And.!Empty(dUltFec))

		dbSelectArea('SDB')
		dbSetOrder(1)
		cSeekSDB := xFilial('SDB') + cCod + cLocal
		cCompSDB := 'DB_FILIAL+DB_PRODUTO+DB_LOCAL'

		cSeekSDB1 := cLocaliz + cNumSeri
		cCompSDB1 := 'DB_LOCALIZ+DB_NUMSERI'
		If lRastro
			cSeekSDB1 += cLoteCtl
			cCompSDB1 += '+DB_LOTECTL'
			If !Empty(cNumLote) .And. lSRastro
				cSeekSDB1 += cNumLote
				cCompSDB1 += '+DB_NUMLOTE'
			EndIf
		EndIf

		If dbSeek(cSeekSDB, .F.)
			Do While !Eof() .And. &(cCompSDB) == cSeekSDB
				If !Empty(dUltFec) .And. DB_DATA <= dUltFec
					dbSkip()
					Loop
				EndIf				
				If &(cCompSDB1) == cSeekSDB1 .And. DB_DATA < dData .And. DB_ESTORNO # 'S' .And. DB_ATUEST # "N"
					If DB_TM<='500' .Or. Substr(DB_TM,1,2) $ 'DE�PR�MA'
						aSaldo[1] += SDB->DB_QUANT
					Else
						aSaldo[1] -= SDB->DB_QUANT
					EndIf
				EndIf
				dbSkip()
			EndDo
		EndIf
		RestArea(aAreaSDB)
	EndIf
EndIf

#IFDEF TOP
	If !Empty(cFiltroSD5)
		SD5->(dbSetFilter({||&cFiltroSD5},cFiltroSD5))
		SD5->(dbGoTop(aAreaSD5[3]))
	EndIf
#ENDIF			

RestArea(aAreaAnt)
Return(aSaldo)

