#include "rwmake.ch"
/*
// SALDO=U_SOMAMTK("+D;-6;-7")
// DUVIDAS
// http://tdn.totvs.com.br/pages/releaseview.action?pageId=6068417

User Function SomaMtk(_uString)

Local aGetArea:= GetArea()
Local cArqTmp := "cArqTmp"
Local nRecno  := (cArqTmp)->(recno())
Local nSoma   := 0
LOcal aElem   := {}
Local aVetor  := {}
Local aTotal  := {0,0,0,0,0,0,0,0,0}

cCodVis		:= CTS->CTS_CODPLA
cOrdVis		:= CTS->CTS_ORDEM
nTpSaldo	:= 1


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿟rata o parametro para poder ser utilizado pelas Query's               �
//쿽 conteudo fica quardado na variavel _cStrAlmox                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
While Len(_uString) > 0             // necessario extrair outras formas ja esta
	AADD(aElem,U_Parse(@_uString))    // pronto.
End

For nY := 1 to len(aElem)
	cEntidade := substr(aElem[nY],2,len(aElem[nY])-1)
	cOperacao := substr(aElem[nY],1,1)
	
	If UPPER(cOperacao) = "C"
		cOperacao := substr(aElem[nY],2,1)
		nValor    := substr(aElem[nY],3,len(aElem[nY])-2)
		aVetor    := {nvalor,nValor,nValor,nvalor,nvalor,nvalor,nvalor,nvalor,nvalor}
	Else
		aVetor    := GetSldEnt( cEntidade , cCodVis, cOrdVis, 0 )
	Endif
	
	If Len(aVetor) <> 0
		nZ:=0
		For nZ:= 1 to 9
			If cOperacao = "+"
				aTotal[nZ]:= aTotal[nZ] + aVetor[nZ]
			Elseif cOperacao = "-"
				aTotal[nZ]:= aTotal[nZ] - aVetor[nZ]
			Elseif cOperacao = "*"
				aTotal[nZ]:= aTotal[nZ] * aVetor[nZ]
			Elseif cOperacao = "/"
				aTotal[nZ]:= aTotal[nZ] / aVetor[nZ]
			ENdif
		Next nZ
	Endif
	
Next nY

//DbGoto(nRecno)
//Reclock(cArqTmp,.f.)
//&(cArqTmp)->( SALDOATU   ) := &(cArqTmp)->( SALDOATU   ) + aVetor[1]			// 01- Saldo Atual
//&(cArqTmp)->( SALDODEB   ) := &(cArqTmp)->( SALDODEB   ) + aVetor[2]    		// 02- Debito na Data
//&(cArqTmp)->( SALDOCRD   ) := &(cArqTmp)->( SALDOCRD   ) + aVetor[3]			// 03- Credito na Data
//&(cArqTmp)->( SALDOATUDB ) := &(cArqTmp)->( SALDOATUDB ) + aVetor[4]			// 04- Saldo Atual Devedor
//&(cArqTmp)->( SALDOATUCR ) := &(cArqTmp)->( SALDOATUCR ) + aVetor[5]			// 05- Saldo Atual Credor
//&(cArqTmp)->( SALDOANT   ) := &(cArqTmp)->( SALDOANT   ) + aVetor[6]			// 06- Saldo Anterior
//&(cArqTmp)->( SALDOANTDB ) := &(cArqTmp)->( SALDOANTDB ) + aVetor[7]			// 07- Saldo Anterior Devedor
//&(cArqTmp)->( SALDOANTCR ) := &(cArqTmp)->( SALDOANTCR ) + aVetor[9]			// 08- Saldo Anterior Credor
//&(cArqTmp)->( (SALDOATU-SALDOANT) ) := &(cArqTmp)->( (SALDOATU-SALDOANT) )   // 09- Variacao
//MsUnlock()

RestArea(aGetArea)

aVetor:=aClone(aTotal)

Return(aVetor)


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿒etSldEnt 튍utor  � Totvs              � Data �  16/09/08   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Retorna o saldo de uma entidade gerencial em tempo de      볍�
굇�          � processamento                                              볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튡arametros� cEntidade = Codigo da Entidade em que se deseja consultar  볍�
굇�          � cCodVis   = Cod da visao gerencial da entidade chamadora.  볍�
굇�          � cOrdVis   = Cod da ordem da visao gerenc da entid chamadora볍�
굇�          � nTpSaldo  = tipo de saldo a ser retornado.                 볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
/*
User Function _GetSldEnt( cEntidade, cCodVis, cOrdVis, nTpSaldo, cArqTmp )
Local aAreaCTS		:= CTS->( GetArea() )						// Posicao atual da tabela CTS (seguranca)
Local aAreaTMP													// Posicao atual do arquivo temporario (seguranca)
Local aReturn		:= {}										// Array com os saldos

Default cCodVis		:= CTS->CTS_CODPLA
Default cOrdVis		:= CTS->CTS_ORDEM
Default nTpSaldo	:= 0										// Saldo Atual

Default cArqTmp		:= "cArqTmp"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿛rotecao para evitar array out of bounds pois esta funcao�
//쿾odera ser chamada a partir de formulas.                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If nTpSaldo < 0 .OR. nTpSaldo > 8
nTpSaldo := 1
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣erifica se a entidade que esta consultando eh superior em�
//퀁elacao a  entidade que  se quer o saldo  e verifica se  a�
//쿮ntidade  referenciada  no  parametro  faz parte da  visao�
//쿲erencial da entidade que esta consultando o saldo.       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞e o tipo de saldo informado for igual a zero (0), a funcao�
//쿭eve retornar o array com todos os saldos.                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If nTpSaldo == 0
Return aReturn
EndIf

Return aReturn[ nTpSaldo ]

*/


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿒etSldVis 튍utor  � Totvs              � Data �  02/02/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Retorna o saldo de uma visao gerencial                     볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튡arametros� cCodVis   = Cod da visao gerencial da entidade chamadora.  볍�
굇�          � nTpSaldo  = o saldo que devera ser retornado.              볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
User Function TesteVis( 	cCodVis, nTpSaldo, oMeter, oText, oDlg, ;
lEnd, dFinalA, dFinal, cSaldos, lVlrZerado, ;
cMoedaDesc, lMovPeriodo, aSetOfBook, cMoeda, ;
lImpAntLP, dDataLP, lConsSaldo, cEntidade )

Local aAreaCTS		:= CTS->( GetArea() )						// Posicao atual da tabela CTS (seguranca)
Local aReturn		:= {0,0,0,0,0,0,0,0}						// Array com os saldos
Local aAux   		:= {}										// Array com os saldos
Local nInc			:= 1
Local aCpyBook		:= {"","","","","","","",""} //aClone( aSetOfBook )
Local cArqTmp2		:= ""

Local nTpSaldo	:= 0										// Saldo Atual

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿛rotecao para evitar array out of bounds pois esta funcao�
//쿾odera ser chamada a partir de formulas.                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If nTpSaldo < 0 .OR. nTpSaldo > 8
	nTpSaldo := 1
EndIf

DbSelectArea( "CTS" )
CTS->( DbSetOrder( 2 ) )
If CTS->( DbSeek( xFilial( "CTS" ) + cCodVis ) )
	aCpyBook[5] := cCodVis
	CTGerPlan(		/*01*/,;
	/*02*/,;
	/*03*/,;
	/*04*/,;
	/*05*/@cArqTmp2,;
	/*06*/dFinalA+1,;
	/*07*/dFinal,;
	/*08*/"",;
	/*09*/"",;
	/*10*/"",;
	/*11*/Repl("Z", TamSx3("CT1_CONTA")[1]),;
	/*12*/"",;
	/*13*/Repl("Z", TamSx3("CTT_CUSTO")[1]),;
	/*14*/"",;
	/*15*/Repl("Z", TamSx3("CTD_ITEM")[1]),;
	/*16*/"",;
	/*17*/Repl("Z", TamSx3("CTH_CLVL")[1]),;
	/*18*/cMoeda,;
	/*19*/cSaldos,;
	/*20*/aCpyBook,;
	/*21*/,;
	/*22*/"",;
	/*23*/Repl("Z", 20),;
	/*24*/,;
	/*25*/,;
	/*26*/,;
	/*27*/,;
	/*28*/,;
	/*29*/lImpAntLP,;
	/*30*/dDataLP,;
	/*31*/,;
	/*32*/lVlrZerado,;
	/*33*/,;
	/*34*/,;
	/*35*/,;
	/*36*/,;
	/*37*/,;
	/*38*/,;
	/*39*/,;
	/*40*/,;
	/*41*/,;
	/*42*/,;
	/*43*/,;
	/*44*/,;
	/*45*/,;
	/*46*/,;
	/*47*/,;
	/*48*/,;
	/*49*/,;
	/*50*/,;
	/*51*/,;
	/*52*/,;
	/*53*/,;
	/*54*/,;
	/*55*/,;
	/*56*/,;
	/*57*/cMoedaDesc,;
	/*58*/lMovPeriodo,;
	/*59*/,;
	/*60*/,;
	/*61*/.T.,;
	/*62*/lConsSaldo,;
	/*63*/,;
	/*64*/"cSldVis")
	
	While CTS->( !Eof() ) .AND. CTS->CTS_FILIAL == xFilial( "CTS" ) .AND. CTS->CTS_CODPLA == cCodVis
		If AllTrim( CTS->CTS_CONTAG ) == cEntidade
			aAux := GetSldEnt( CTS->CTS_CONTAG, CTS->CTS_CODPLA, "", 0, "cSldVis" )
			For nInc := 1 To Len( aAux )
				aReturn[nInc] += aAux[nInc]
			Next
		EndIf
		
		CTS->( DbSkip() )
	End
	
	cSldVis->( DbCloseArea() )
EndIf

RestArea( aAreaCTS )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞e o tipo de saldo informado for igual a zero (0), a funcao�
//쿭eve retornar o array com todos os saldos.                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
If nTpSaldo == 0
	Return aReturn
EndIf

Return aReturn[ nTpSaldo ]
