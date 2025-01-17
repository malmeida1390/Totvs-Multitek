#INCLUDE  "FIVEWIN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SaldoSb2  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retornar o saldos de um dado Produto.                       ���
���          |                                                            ���
���Parametros|cProduto  =  Codigo do Produto                              ���
���          |                                                            ���
���          |cNAlmox    =  Almoxarifados Invalidos.                      ���
���          |                                                            ���
���          |cSAlmox    =  Almoxarifados Desejados.                      ���
���          |                                                            ���
���          �Somente posso utilizar uma destas opcoes                    ���
���          |                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function Ant_SaldoSb2(cProduto,cNAlmox,cSAlmox)

//
// Define Saldos em estoque
//
//������������������������������������������������������������������������������������������������Ŀ
//�Parametros : Codigo do Produto                                                                  �
//�                                                                                                �
//�Retorna:                                                                                        �
//�                                                                                                |
//�[01]     MALHA                                                                                  �
//�[01][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[01][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[01][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[01][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[01][05] B2_RESERVA                       // RESERVADO                                          �
//�[01][06] B2_QEMP                          // EMPENHADO                                          �
//�[01][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[01][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[01][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[01][10] SB2->B2_QATU                     // FISICO                                             �
//�[01][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[01][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//�[02]     MATRIZ                                                                                 �
//�[02][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[02][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[02][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[02][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[02][05] B2_RESERVA                       // RESERVADO                                          �
//�[02][06] B2_QEMP                          // EMPENHADO                                          �
//�[02][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[02][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[02][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[02][10] SB2->B2_QATU                     // FISICO                                             �
//�[02][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[02][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//�[03]     FILIAL                                                                                 �
//�[03][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[03][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[03][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[03][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[03][05] B2_RESERVA                       // RESERVADO                                          �
//�[03][06] B2_QEMP                          // EMPENHADO                                          �
//�[03][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[03][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[03][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[03][10] SB2->B2_QATU                     // FISICO                                             �
//�[03][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[03][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//�[04]     CONSIGNADO                                                                             �
//�[04][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[04][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[04][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[04][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[04][05] B2_RESERVA                       // RESERVADO                                          �
//�[04][06] B2_QEMP                          // EMPENHADO                                          �
//�[04][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[04][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[04][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[04][10] SB2->B2_QATU                     // FISICO                                             �
//�[04][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[04][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//�[05]     DEPOSITO FECHADO                                                                       �
//�[05][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[05][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[05][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[05][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[05][05] B2_RESERVA                       // RESERVADO                                          �
//�[05][06] B2_QEMP                          // EMPENHADO                                          �
//�[05][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[05][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[05][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[05][10] SB2->B2_QATU                     // FISICO                                             �
//�[05][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[05][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//�[06]     SALDO DA FILIAL CORRENTE                                                               �
//�[06][01] SaldoSb2()                       // DISPONIVEL                                         �
//�[06][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros�
//�[06][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   �
//�[06][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros�
//�[06][05] B2_RESERVA                       // RESERVADO                                          �
//�[06][06] B2_QEMP                          // EMPENHADO                                          �
//�[06][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//�[06][08] B2_QPEDVEN                       // A FATURAR                                          �
//�[06][09] B2_QCLASS                        // A CLASSIFICAR                                      �
//�[06][10] SB2->B2_QATU                     // FISICO                                             �
//�[06][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            �
//�[06][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       �
//�                                                                                                |
//��������������������������������������������������������������������������������������������������

Local aArea     := GetArea()
Local cParAlmox := GETMV("MV_ALMCONS")
Local nSaldo    := 0
Local nSaldoSB2 := 0

// Malha
Local nDispo    := 0
Local nQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nReser    := 0 // Itens em Transito
Local nEmpe     := 0
Local nSalPed   := 0
Local nPedVen   := 0
Local nClassif  := 0
Local nQtdAtu   := 0
Local nMalha    := 0
Local nDispMal  := 0


// Filial (todas Filiais)
Local nFDispo    := 0
Local nFQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nFQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nFQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nFTran     := 0 // Itens em Transito
Local nFEmpe     := 0
Local nFSalPed   := 0
Local nFPedVen   := 0
Local nFClassif  := 0
Local nFQtdAtu   := 0
Local nFMalha    := 0
Local nFDispMal  := 0

// Matriz
Local nMDispo    := 0
Local nMQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nMQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nMQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nMTran     := 0 // Itens em Transito
Local nMEmpe     := 0
Local nMSalPed   := 0
Local nMPedVen   := 0
Local nMClassif  := 0
Local nMQtdAtu   := 0
Local nMMalha    := 0
Local nMDispMal  := 0



// Matriz
Local nDEFDispo    := 0
Local nDEFQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nDEFQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nDEFQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nDEFTran     := 0 // Itens em Transito
Local nDEFEmpe     := 0
Local nDEFSalPed   := 0
Local nDEFPedVen   := 0
Local nDEFClassif  := 0
Local nDEFQtdAtu   := 0
Local nDEFMalha    := 0
Local nDEFDispMal  := 0


// FILIAL CORRENTE
Local nCorDispo    := 0
Local nCorQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nCorQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nCorQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nCorTran     := 0 // Itens em Transito
Local nCorEmpe     := 0
Local nCorSalPed   := 0
Local nCorPedVen   := 0
Local nCorClassif  := 0
Local nCorQtdAtu   := 0
Local nCorMalha    := 0
Local nCorDispMal  := 0


// Filial
Local nCDispo    := 0
Local nCQNPT     := 0 // Controla Estoque  - Qtde nossa em Poder de Terceiros
Local nCQTNP     := 0 // Controla Estoque  - Qtde Terceiros em Nosso Poder
Local nCQTER     := 0 // Nao Controla Est. - Saldo em Poder de Terceiros
Local nCTran     := 0 // Itens em Transito
Local nCEmpe     := 0
Local nCSalPed   := 0
Local nCPedVen   := 0
Local nCClassif  := 0
Local nCQtdAtu   := 0
Local nCMalha    := 0
Local nCDispMal  := 0


Local cDescricao := ""
Local aSaldo     :={}
Local cCdSimil := SB1->B1_X_SIMIL
Local cCodiEis := SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+;
B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)


If Type("_ChaveAud") = "U"   // Variaveis utilizadas durante Analise Fechamento Mensal Planilha
	Private _aLog    := {}
	Private _aAud    := {}
	Private _ChaveAud:= ""
Endif


DEFAULT cNAlmox   := NIL     // Almoxarifados Invalidos.

DEFAULT cSAlmox   := NIL     // Almoxarifados Desejados.

//�������������������������������������������������Ŀ
//� Calcula o saldo atual de todos os almoxarifados �
//���������������������������������������������������
dbSelectArea("SB2")
DbOrderNickname("B2CODIGO") // CODIGO + ARMAZEM
DBSeek( cProduto )

//SET SOFTSEEK ON  // OBS. O .T. NO DBSEEK JA ATIVA O SOFSEEK
//dbSeek( cProduto , .T. )
//SET SOFTSEEK OFF

//������������������������������������������������������������������������Ŀ
//� Cabecalho Log de Analise de Simil + Eis                                �
//��������������������������������������������������������������������������
If	_ChaveAud = cCdSimil+cCodiEis
	
	cDescricao:=Iif(cNAlmox <> nil," Nao serao levados em consideracao os almoxaridados : "+cNAlmox+" e somente serao considerados item de compra","")
	
	GeraAud("")
	GeraAud("Saldo do Produto : "+cProduto+cDescricao)
	GeraAud("")
	GeraAud("Fil.-Loc.-Item Co"+;
	"Fisica - "+space(3)+;
	"Reservado - "+space(2)+;
	"Empenhada - "+space(4)+;
	"(SC+PC+OP) - "+;
	"Pc Nao Lib. Fat.- "+;
	"F+T (Sld Malha) -   "+;
	"(F-R-E-FATURA)+(SC+PC+OP)(Sld Disp Malha)")
	GeraAud("")
	
	
Endif






While !SB2->(Eof()) .and. SB2->B2_COD == cProduto
	
	
	//�������������������������������������������������Ŀ
	//� Origem SaldoSb2 (MatxFunA.prx)                  �
	//���������������������������������������������������
	/*
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Fun��o    � SaldoSB2 � Autor � Eveli Morasco         � Data � 15/04/92 ���
	�������������������������������������������������������������������������Ĵ��
	���Descri��o � Calcula o saldo do arquivo SB2                             ���
	�������������������������������������������������������������������������Ĵ��
	���Sintaxe   � ExpN1 := SaldoSB2(ExpL1,ExpL2,ExpD1,ExpL3)                 ���
	�������������������������������������������������������������������������Ĵ��
	���Parametros� ExpN1 = Saldo devolvido pela funcao                        ���
	���          � ExpL1 = Flag que indica se chamada da funcao � utilizada p/���
	���          � calculo de necessidade. Caso .T. deve considerar quantidade���
	���          � a distribuir, pois a mesma apenas nao pode ser utilizada,  ���
	���          � porem ja esta em estoque.                                  ���
	���          � ExpL2 = Flag que indica se deve substrair o empenho do     ���
	���          � saldo a ser retornado.                                     ���
	���          � ExpD1 = Data final para filtragem de empenhos. Empenhos ate���
	���          � esta data serao considerados no caso de leitura do SD4.    ���
	���          � ExpL3 = Flag que indica se deve considerar o saldo de terc ���
	���          � eiros em nosso poder ou nao (B2_QTNP).                     ���
	���          � ExpL4 = Flag que indica se deve considerar nosso saldo em  ���
	���          � poder de terceiros ou nao (B2_QNPT).                       ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso      � Generico                                                   ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
	Function SaldoSB2(lNecessidade,lEmpenho,dDataFim,lConsTerc,lConsNPT,cAliasSB2)
	
	DEFAULT lNecessidade := .F.
	DEFAULT lEmpenho     := .T.
	DEFAULT lConsTerc    := .T.
	DEFAULT lConsNPT     := .F.
	
	Return (QtdComp((cAlias)->B2_QATU
	-(cAlias)->B2_RESERVA
	.T.  -If(lEmpenho,nEmpenho,0)
	.F.  -IF(lNecessidade,0,(cAlias)->B2_QACLASS) (Obs o If esta considerado B2_QACLASS)
	-(cAlias)->B2_QEMPSA
	-(cAlias)->B2_QEMPPRJ
	-AvalQtdPre("SB2",1)
	.T.  -If(lConsTerc,0,(cAlias)->B2_QTNP)  (Obs que nao considera qtde em terceiros)
	.F.  +If(lConsNPT,(cAlias)->B2_QNPT,0))
	*/
	
	nSaldoSB2 := SaldoSb2(.T.)
	
	//�������������������������������������������������Ŀ
	//� Esta opcao e util quando o usuario deseja       �
	//� descartar os almoxarifados durante a            �
	//� geracao da planilha.                            �
	//���������������������������������������������������

	//
	//  Almoxarifados NAO PODE ESTAR NO parametro para continuar.
	//
	If  cNAlmox <> nil
		
		if  (SB2->B2_LOCAL $  cNAlmox)
			SB2->(DBSKIP())
			loop
		Endif
		
	Endif

	
	//
	//  Almoxarifado DEVE ESTAR NO PARAMETRO para continuar ou seja o almox.
   //
	If  cSAlmox <> nil
		
		if  !(SB2->B2_LOCAL $  cSAlmox)
			SB2->(DBSKIP())
			loop
		Endif
		
	Endif
	
	
	//�������������������������������������������������Ŀ
	//� Valida os Almoxarifados Invalidos (CONSIGNADOS) �
	//���������������������������������������������������
	If  SB2->B2_LOCAL $ cParAlmox
		
		nCDispo  += nSaldoSB2           // Saldo do Estoque Disponivel
		nCQNPT   += SB2->B2_QNPT        // Controla Estoque  - Qtde nossa em Poder de Terceiros
		nCQTNP   += SB2->B2_QTNP        // Controla Estoque  - Qtde Terceiros em Nosso Poder
		nCQTER   += SB2->B2_QTER        // Nao Controla Est. - Saldo em Poder de Terceiros
		nCTran   += SB2->B2_RESERVA     // Quantidade reservada - Pedido de Venda
		nCEmpe   += SB2->B2_QEMP        // Quantidade Empenhada
		nCSalPed += SB2->B2_SALPEDI     // Prevista para entrar (via Compras ou OP)
		nCPedVen += SB2->B2_QPEDVEN     // Em pedido de Vendas ainda nao liberado p/ Faturar
		nCClassif+= SB2->B2_NAOCLAS     // Saldo a Classificar (Entrada)
		nCQtdAtu += SB2->B2_QATU                     //  Fisico
		nCMalha  += SB2->B2_QATU   + SB2->B2_SALPEDI  //  Fisico + Transito         (Saldo Malha)
		nCDispMal+= nSaldoSB2            // -  SB2->B2_QPEDVEN //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
		
		SB2->(DBSKIP())
		loop
	Endif
	
	
	
	//
	// Saldo da Malha
	//
	nDispo   += nSaldoSB2               // Saldo do Estoque Disponivel
	nQNPT    += SB2->B2_QNPT            // Controla Estoque  - Qtde nossa em Poder de Terceiros
	nQTNP    += SB2->B2_QTNP            // Controla Estoque  - Qtde Terceiros em Nosso Poder
	nQTER    += SB2->B2_QTER            // Nao Controla Est. - Saldo em Poder de Terceiros
	nReser   += SB2->B2_RESERVA         // Quantidade reservada - Pedido de Venda
	nEmpe    += SB2->B2_QEMP            // Quantidade Empenhada
	nSalPed  += SB2->B2_SALPEDI         // Prevista para entrar (via Compras ou OP)
	nPedVen  += SB2->B2_QPEDVEN         // Em pedido de Vendas ainda nao liberado p/ Faturar
	nClassif += SB2->B2_NAOCLAS         // Saldo a Classificar (Entrada)
	nQtdAtu  += SB2->B2_QATU                      //  Fisico
	nMalha   += SB2->B2_QATU  + SB2->B2_SALPEDI   //  Fisico + Transito         (Saldo Malha)
	nDispMal += nSaldoSB2               //-  SB2->B2_QPEDVEN   //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
	
	
	If	_ChaveAud = cCdSimil+cCodiEis
		
		GeraAud(SB2->B2_FILIAL+;
		SB2->B2_LOCAL+;
		SB1->B1_X_ITCPR+;
		STR(SB2->B2_QATU,17)+;                // Fisica
		STR(SB2->B2_RESERVA,17)+;             // Reservado
		STR(SB2->B2_QEMP,17)+;                // Empenhada
		STR(SB2->B2_SALPEDI,17)+;             // (SC+PC+OP)
		STR(SB2->B2_QPEDVEN,17)+;             // Pc Nao Lib. Faturar
		STR(SB2->B2_QATU + SB2->B2_SALPEDI,17)+;  //  Fisico + Transito
		STR(nSaldoSB2  /*-  SB2->B2_QPEDVEN*/,17))  //  F - R - E - F
		
	Endif
	
	
	//
	// Saldo da Matriz
	//
	if SB2->B2_FILIAL = "01"
		
		nMDispo   += nSaldoSB2           // Saldo do Estoque Disponivel
		nMQNPT    += SB2->B2_QNPT        // Controla Estoque  - Qtde nossa em Poder de Terceiros
		nMQTNP    += SB2->B2_QTNP        // Controla Estoque  - Qtde Terceiros em Nosso Poder
		nMQTER    += SB2->B2_QTER        // Nao Controla Est. - Saldo em Poder de Terceiros
		nMTran    += SB2->B2_RESERVA     // Quantidade reservada - Pedido de Venda
		nMEmpe    += SB2->B2_QEMP        // Quantidade Empenhada
		nMSalPed  += SB2->B2_SALPEDI     // Prevista para entrar (via Compras ou OP)
		nMPedVen  += SB2->B2_QPEDVEN      // Em pedido de Vendas ainda nao liberado p/ Faturar
		nMClassif += SB2->B2_NAOCLAS      // Saldo a Classificar (Entrada)
		nMQtdAtu  += SB2->B2_QATU                      //  Fisico
		nMMalha   += SB2->B2_QATU + SB2->B2_SALPEDI   //  Fisico + Transito         (Saldo Malha)
		nMDispMal += nSaldoSB2            // -  SB2->B2_QPEDVEN  //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
		
	Endif
	
	
	//
	// Saldo da Filial 02 (Deposito Fechado)
	//
	if SB2->B2_FILIAL = "03"
		
		nDEFDispo   += nSaldoSB2           // Saldo do Estoque Disponivel
		nDEFQNPT    += SB2->B2_QNPT        // Controla Estoque  - Qtde nossa em Poder de Terceiros
		nDEFQTNP    += SB2->B2_QTNP        // Controla Estoque  - Qtde Terceiros em Nosso Poder
		nDEFQTER    += SB2->B2_QTER        // Nao Controla Est. - Saldo em Poder de Terceiros
		nDEFTran    += SB2->B2_RESERVA     // Quantidade reservada - Pedido de Venda
		nDEFEmpe    += SB2->B2_QEMP        // Quantidade Empenhada
		nDEFSalPed  += SB2->B2_SALPEDI     // Prevista para entrar (via Compras ou OP)
		nDEFPedVen  += SB2->B2_QPEDVEN      // Em pedido de Vendas ainda nao liberado p/ Faturar
		nDEFClassif += SB2->B2_NAOCLAS      // Saldo a Classificar (Entrada)
		nDEFQtdAtu  += SB2->B2_QATU                      //  Fisico
		nDEFMalha   += SB2->B2_QATU + SB2->B2_SALPEDI   //  Fisico + Transito         (Saldo Malha)
		nDEFDispMal += nSaldoSB2            // -  SB2->B2_QPEDVEN  //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
		
	Endif


	//
	// Saldo da Filial Corrente
	//
	if SB2->B2_FILIAL = cFilAnt
		
		nCorDispo   += nSaldoSB2           // Saldo do Estoque Disponivel
		nCorQNPT    += SB2->B2_QNPT        // Controla Estoque  - Qtde nossa em Poder de Terceiros
		nCorQTNP    += SB2->B2_QTNP        // Controla Estoque  - Qtde Terceiros em Nosso Poder
		nCorQTER    += SB2->B2_QTER        // Nao Controla Est. - Saldo em Poder de Terceiros
		nCorTran    += SB2->B2_RESERVA     // Quantidade reservada - Pedido de Venda
		nCorEmpe    += SB2->B2_QEMP        // Quantidade Empenhada
		nCorSalPed  += SB2->B2_SALPEDI     // Prevista para entrar (via Compras ou OP)
		nCorPedVen  += SB2->B2_QPEDVEN      // Em pedido de Vendas ainda nao liberado p/ Faturar
		nCorClassif += SB2->B2_NAOCLAS      // Saldo a Classificar (Entrada)
		nCorQtdAtu  += SB2->B2_QATU                      //  Fisico
		nCorMalha   += SB2->B2_QATU + SB2->B2_SALPEDI   //  Fisico + Transito         (Saldo Malha)
		nCorDispMal += nSaldoSB2            // -  SB2->B2_QPEDVEN  //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
		
	Endif

	
	//
	// Saldo da Filial
	//
	IF SB2->B2_FILIAL <> "01"
		
		
		nFDispo   += nSaldoSB2           // Saldo do Estoque Disponivel
		nFQNPT    += SB2->B2_QNPT        // Controla Estoque  - Qtde nossa em Poder de Terceiros
		nFQTNP    += SB2->B2_QTNP        // Controla Estoque  - Qtde Terceiros em Nosso Poder
		nFQTER    += SB2->B2_QTER        // Nao Controla Est. - Saldo em Poder de Terceiros
		nFTran    += SB2->B2_RESERVA     // Quantidade reservada - Pedido de Venda
		nFEmpe    += SB2->B2_QEMP        // Quantidade Empenhada
		nFSalPed  += SB2->B2_SALPEDI     // Prevista para entrar (via Compras ou OP)
		nFPedVen  += SB2->B2_QPEDVEN     // Em pedido de Vendas ainda nao liberado p/ Faturar
		nFClassif += SB2->B2_NAOCLAS     // Saldo a Classificar (Entrada)
		nFQtdAtu  += SB2->B2_QATU                      //  Fisico
		nFMalha   += SB2->B2_QATU + SB2->B2_SALPEDI   //  Fisico + Transito         (Saldo Malha)
		nFDispMal += nSaldoSB2            // -  SB2->B2_QPEDVEN  //  Fisico - R - E - FATURAR  (Saldo Malha Disp)
		
	Endif
	
	SB2->(dbSkip())
	
Enddo


// Malha
AADD(aSaldo,{;
nDispo,;           // Saldo do Estoque Disponivel
nQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nReser,;            // Quantidade reservada - Pedido de Venda
nEmpe,;            // Quantidade Empenhada
nSalPed,;          // Prevista para entrar (via Compras ou OP)
nPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nClassif,;         // Saldo a Classificar
nQtdAtu,;          //  Fisico
nMalha,;           //  Fisico + Transito         (Saldo Malha)
nDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)


// Matriz
AADD(aSaldo,{;
nMDispo,;           // Saldo do Estoque Disponivel
nMQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nMQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nMQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nMTran,;            // Quantidade reservada - Pedido de Venda
nMEmpe,;            // Quantidade Empenhada
nMSalPed,;          // Prevista para entrar (via Compras ou OP)
nMPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nMClassif,;         // Saldo a Classificar
nMQtdAtu,;          //  Fisico
nMMalha,;           //  Fisico + Transito         (Saldo Malha)
nMDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)


// Filial
AADD(aSaldo,{;
nFDispo,;           // Saldo do Estoque Disponivel
nFQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nFQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nFQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nFTran,;            // Quantidade reservada - Pedido de Venda
nFEmpe,;            // Quantidade Empenhada
nFSalPed,;          // Prevista para entrar (via Compras ou OP)
nFPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nFClassif,;         // Saldo a Classificar
nFQtdAtu,;          //  Fisico
nFMalha,;           //  Fisico + Transito         (Saldo Malha)
nFDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)


// Consignados
AADD(aSaldo,{;
nCDispo,;           // Saldo do Estoque Disponivel
nCQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nCQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nCQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nCTran,;            // Quantidade reservada - Pedido de Venda
nCEmpe,;            // Quantidade Empenhada
nCSalPed,;          // Prevista para entrar (via Compras ou OP)
nCPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nCClassif,;         // Saldo a Classificar
nCQtdAtu,;           //  Fisico
nCMalha,;           //  Fisico + Transito         (Saldo Malha)
nCDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)


// Deposito Fechado Filial 02
AADD(aSaldo,{;
nDEFDispo,;           // Saldo do Estoque Disponivel
nDEFQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nDEFQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nDEFQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nDEFTran,;            // Quantidade reservada - Pedido de Venda
nDEFEmpe,;            // Quantidade Empenhada
nDEFSalPed,;          // Prevista para entrar (via Compras ou OP)
nDEFPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nDEFClassif,;         // Saldo a Classificar
nDEFQtdAtu,;          //  Fisico
nDEFMalha,;           //  Fisico + Transito         (Saldo Malha)
nDEFDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)



// Filial Corrente
AADD(aSaldo,{;
nCorDispo,;           // Saldo do Estoque Disponivel
nCorQNPT,;            // Controla Estoque  - Qtde nossa em Poder de Terceiros
nCorQTNP,;            // Controla Estoque  - Qtde Terceiros em Nosso Poder
nCorQTER,;            // Nao Controla Est. - Saldo em Poder de Terceiros
nCorTran,;            // Quantidade reservada - Pedido de Venda
nCorEmpe,;            // Quantidade Empenhada
nCorSalPed,;          // Prevista para entrar (via Compras ou OP)
nCorPedVen,;          // Em pedido de Vendas ainda nao liberado p/ Faturar
nCorClassif,;         // Saldo a Classificar
nCorQtdAtu,;          //  Fisico
nCorMalha,;           //  Fisico + Transito         (Saldo Malha)
nCorDispMal})         //  Fisico - R - E - FATURAR  (Saldo Malha Disp)



If	_ChaveAud = cCdSimil+cCodiEis
	
	GeraAud("")
	GeraAud("Tot: "+;
	str(nQtdAtu,17)+;           //  Fisica
	str(nReser,17) +;   		 //  Reservado
	str(nEmpe,17) +;     		 //  Empenhada
	str(nSalPed,17) +;  		 // (SC+PC+OP)
	str(nPedVen,17) +; 		 //  Pc Nao Lib. Faturar
	str(nMalha,17) +;    		 //  Fisico + Transito         (Saldo Malha)
	str(nDispMal+nSalPed-nPedVen,17)) 	 //  Fisico - R - E - FATURAR + (SC+PC+OP) (Saldo Malha Disp)
	
Endif


RestArea(aArea)

Return(aSaldo)


Static Function GeraAud(_cString1)

AADD(_aAud,_cString1)

Return
