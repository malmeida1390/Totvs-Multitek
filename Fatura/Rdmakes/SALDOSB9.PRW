#INCLUDE  "FIVEWIN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SaldoSb9  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retornar o saldos de um dado Produto.                       º±±
±±º          |                                                            º±±
±±ºParametros|cProduto  =  Codigo do Produto                              º±±
±±º          |                                                            º±±
±±º          |cNAlmox    =  Almoxarifados Invalidos.                      º±±
±±º          |                                                            º±±
±±º          |cSAlmox    =  Almoxarifados Desejados.                      º±±
±±º          |                                                            º±±
±±º          ³Somente posso utilizar uma destas opcoes                    º±±
±±º          |                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SaldoSb9(cProduto,cNAlmox,cSAlmox)

//
// Define Saldos em estoque
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros : Codigo do Produto                                                                  ³
//³                                                                                                ³
//³Retorna:                                                                                        ³
//³                                                                                                |
//³[01]     MALHA                                                                                  ³
//³[01][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//³[02]     MATRIZ                                                                                 ³
//³[02][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//³[03]     FILIAL                                                                                 ³
//³[03][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//³[04]     CONSIGNADO                                                                             ³
//³[04][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//³[05]     DEPOSITO FECHADO                                                                       ³
//³[05][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//³[06]     SALDO DA FILIAL CORRENTE                                                               ³
//³[06][01] SB9_QINI                         // Saldo no Fechamento                                ³
//³                                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea     := GetArea()
Local cParAlmox := GETMV("MV_ALMCONS")
Local cData     := Dtos(GETMV("MV_ULMES"))  // Data do Ultimo Fechamento 
//Local nSaldo    := 0
Local nSaldoSB9 := 0

Local nDispo    := 0   // Malha  
Local nFDispo   := 0   // Filial (todas Filiais)
Local nMDispo   := 0   // Matriz
Local nDEFDispo := 0   // Matriz
Local nCorDispo := 0   // FILIAL CORRENTE
Local nCDispo   := 0   // Filial


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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o saldo atual de todos os almoxarifados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB9")
DbOrderNickname("B9CODIGO") // DATA + CODIGO + ARMAZEM
DBSeek( cData + cProduto )

//SET SOFTSEEK ON  // OBS. O .T. NO DBSEEK JA ATIVA O SOFSEEK
//dbSeek( cProduto , .T. )
//SET SOFTSEEK OFF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho Log de Analise de Simil + Eis                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	_ChaveAud = cCdSimil+cCodiEis
	
	cDescricao:=Iif(cNAlmox <> nil," Nao serao levados em consideracao os almoxaridados : "+cNAlmox+" e somente serao considerados item de compra","")
	
	GeraAud("")
	GeraAud("Saldo do Produto com base no SB9 (Saldos Iniciais) : "+cProduto+cDescricao)
	GeraAud("")
	GeraAud("Fil.-Loc.-Item Co"+;
	"Fisica - "+space(3)+;
	"Data")
	GeraAud("")
	
Endif




While !SB9->(Eof()) .and. cData + cProduto = DTOS(SB9->B9_DATA) + SB9->B9_COD
	
	nSaldoSB9 := SB9->B9_QINI
	
	//
	//  Almoxarifados NAO PODE ESTAR NO parametro para continuar.
	//
	If  cNAlmox <> nil
		
		if  (SB9->B9_LOCAL $  cNAlmox)
			SB9->(DBSKIP())
			loop
		Endif
		
	Endif

	
	//
	//  Almoxarifado DEVE ESTAR NO PARAMETRO para continuar ou seja o almox.
   //
	If  cSAlmox <> nil
		
		if  !(SB9->B9_LOCAL $  cSAlmox)
			SB9->(DBSKIP())
			loop
		Endif
		
	Endif
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida os Almoxarifados Invalidos (CONSIGNADOS) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  SB9->B9_LOCAL $ cParAlmox
		
		nCDispo  += nSaldoSB9           // Saldo do Estoque Disponivel
		
		SB9->(DBSKIP())
		loop

	Endif
	
	//
	// Saldo da Malha
	//
	nDispo   += nSaldoSB9               // Saldo do Estoque Disponivel
	
	
	If	_ChaveAud = cCdSimil+cCodiEis
		
		GeraAud(SB9->B9_FILIAL+;
		SB9->B9_LOCAL+;
		" "+;
		STR(SB9->B9_QINI,17)+;
		" "+;
		DTOS(SB9->B9_DATA))
		
	Endif
	
	
	//
	// Saldo da Matriz
	//
	if SB9->B9_FILIAL = "01"
		
		nMDispo   += nSaldoSB9           // Saldo do Estoque Disponivel
		
	Endif
	
	
	//
	// Saldo da Filial 02 (Deposito Fechado)
	//
	if  alltrim(SB9->B9_FILIAL) $ "03|02"
		
		nDEFDispo   += nSaldoSB9           // Saldo do Estoque Disponivel
		
	Endif


	//
	// Saldo da Filial Corrente
	//
	if SB9->B9_FILIAL = cFilAnt
		
		nCorDispo   += nSaldoSB9           // Saldo do Estoque Disponivel
		
	Endif

	
	//
	// Saldo da Filial
	//
	IF SB9->B9_FILIAL <> "01"
		
		nFDispo   += nSaldoSB9           // Saldo do Estoque Disponivel
		
	Endif
	
	SB9->(dbSkip())
	
Enddo


AADD(aSaldo,{nDispo})   // Fisico no Fechamento Malha
AADD(aSaldo,{nMDispo})  // Fisico no Fechamento Matriz
AADD(aSaldo,{nFDispo})  // Fisico no Fechamento Filial
AADD(aSaldo,{nCDispo})  // Fisico no Fechamento Consignados
AADD(aSaldo,{nDEFDispo})// Fisico no Fechamento Deposito Fechado Filial 02
AADD(aSaldo,{nCorDispo})// Fisico no Fechamento Filial Corrente


If	_ChaveAud = cCdSimil+cCodiEis
	
	GeraAud("")
	GeraAud("Tot: "+;
	str(nDispo,17))
	
Endif


RestArea(aArea)

Return(aSaldo)


Static Function GeraAud(_cString1)

AADD(_aAud,_cString1)

Return
