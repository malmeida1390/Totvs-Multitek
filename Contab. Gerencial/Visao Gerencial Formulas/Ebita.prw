#include "rwmake.ch"

User Function SomaMtk(_uString)

Local cArquivo := &(cArqTmp)->( GetArea() )

nSoma := 0              

cCodVis		:= CTS->CTS_CODPLA
cOrdVis		:= CTS->CTS_ORDEM
nTpSaldo	:= 1	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata o parametro para poder ser utilizado pelas Query's               ³
//³o conteudo fica quardado na variavel _cStrAlmox                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While Len(_uString) > 0             // necessario extrair outras formas ja esta
	AADD(aElem,U_Parse(@_uString))    // pronto.
End

For nY := 1 to len(aElem)
   cEntidade := aElem[nY]
   aVetor    := U__GetSldEnt( cEntidade , cCodVis, cOrdVis, nTpSaldo )
 
   DbSelectArea(cArqTmp)  
   Reclock(cArqTmp,.f.)
   &(cArqTmp)->( SALDOATU   ) := &(cArqTmp)->( SALDOATU   ) + aReturn[1]			// 01- Saldo Atual
   &(cArqTmp)->( SALDODEB   ) := &(cArqTmp)->( SALDODEB   ) + aReturn[2]    		// 02- Debito na Data
   &(cArqTmp)->( SALDOCRD   ) := &(cArqTmp)->( SALDOCRD   ) + aReturn[3]			// 03- Credito na Data
   &(cArqTmp)->( SALDOATUDB ) := &(cArqTmp)->( SALDOATUDB ) + aReturn[4]			// 04- Saldo Atual Devedor
   &(cArqTmp)->( SALDOATUCR ) := &(cArqTmp)->( SALDOATUCR ) + aReturn[5]			// 05- Saldo Atual Credor
   &(cArqTmp)->( SALDOANT   ) := &(cArqTmp)->( SALDOANT   ) + aReturn[6]			// 06- Saldo Anterior
   &(cArqTmp)->( SALDOANTDB ) := &(cArqTmp)->( SALDOANTDB ) + aReturn[7]			// 07- Saldo Anterior Devedor
   &(cArqTmp)->( SALDOANTCR ) := &(cArqTmp)->( SALDOANTCR ) + aReturn[9]			// 08- Saldo Anterior Credor
   &(cArqTmp)->( (SALDOATU-SALDOANT) ) := &(cArqTmp)->( (SALDOATU-SALDOANT) ) + aReturn[9]  // 09- Variacao             					
   MsUnlock()

Next

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetSldEnt ºAutor  ³ Totvs              º Data ³  16/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o saldo de uma entidade gerencial em tempo de      º±±
±±º          ³ processamento                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cEntidade = Codigo da Entidade em que se deseja consultar  º±±
±±º          ³ cCodVis   = Cod da visao gerencial da entidade chamadora.  º±±
±±º          ³ cOrdVis   = Cod da ordem da visao gerenc da entid chamadoraº±±
±±º          ³ nTpSaldo  = tipo de saldo a ser retornado.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function _GetSldEnt( cEntidade, cCodVis, cOrdVis, nTpSaldo, cArqTmp )
	Local aAreaCTS		:= CTS->( GetArea() )						// Posicao atual da tabela CTS (seguranca)
	Local aAreaTMP													// Posicao atual do arquivo temporario (seguranca)
	Local aReturn		:= {}										// Array com os saldos

	//Default cCodVis		:= CTS->CTS_CODPLA
	//Default cOrdVis		:= CTS->CTS_ORDEM
	//Default nTpSaldo	:= 0										// Saldo Atual

	//Default cArqTmp		:= "cArqTmp"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Protecao para evitar array out of bounds pois esta funcao³
	//³podera ser chamada a partir de formulas.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTpSaldo < 0 .OR. nTpSaldo > 8
		nTpSaldo := 1
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a entidade que esta consultando eh superior em³
	//³relacao a  entidade que  se quer o saldo  e verifica se  a³
	//³entidade  referenciada  no  parametro  faz parte da  visao³
	//³gerencial da entidade que esta consultando o saldo.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select( cArqTmp ) > 0
		aAreaTmp := &(cArqTmp)->( GetArea() )

		DbSelectArea( "CTS" )
		CTS->( DbSetOrder( 2 ) )
		If CTS->( DbSeek( xFilial( "CTS" ) + cCodVis + cEntidade ) )
			If Empty( cOrdVis ) .OR. cOrdVis > CTS->CTS_ORDEM
				DbSelectArea( cArqTmp )
				&(cArqTmp)->( DbSetOrder( 1 ) )
				If &(cArqTmp)->( DbSeek( cEntidade ) )
					aAdd( aReturn, &(cArqTmp)->( SALDOATU   ) )			// 01- Saldo Atual
					aAdd( aReturn, &(cArqTmp)->( SALDODEB   ) )			// 02- Debito na Data
					aAdd( aReturn, &(cArqTmp)->( SALDOCRD   ) )			// 03- Credito na Data
					aAdd( aReturn, &(cArqTmp)->( SALDOATUDB ) )			// 04- Saldo Atual Devedor
					aAdd( aReturn, &(cArqTmp)->( SALDOATUCR ) )			// 05- Saldo Atual Credor
					aAdd( aReturn, &(cArqTmp)->( SALDOANT   ) )			// 06- Saldo Anterior
					aAdd( aReturn, &(cArqTmp)->( SALDOANTDB ) )			// 07- Saldo Anterior Devedor
					aAdd( aReturn, &(cArqTmp)->( SALDOANTCR ) )			// 08- Saldo Anterior Credor
					aAdd( aReturn, &(cArqTmp)->( (SALDOATU-SALDOANT) ) )// 09- Variacao             					
				EndIf
			EndIf
		EndIf

		RestArea( aAreaTMP )
		RestArea( aAreaCTS )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se o tipo de saldo informado for igual a zero (0), a funcao³
	//³deve retornar o array com todos os saldos.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTpSaldo == 0
		Return aReturn
	EndIf

Return aReturn[ nTpSaldo ]



