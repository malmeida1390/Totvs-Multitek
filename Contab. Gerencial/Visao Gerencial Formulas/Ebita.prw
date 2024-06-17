#include "rwmake.ch"

User Function SomaMtk(_uString)

Local cArquivo := &(cArqTmp)->( GetArea() )

nSoma := 0              

cCodVis		:= CTS->CTS_CODPLA
cOrdVis		:= CTS->CTS_ORDEM
nTpSaldo	:= 1	


//�����������������������������������������������������������������������Ŀ
//�Trata o parametro para poder ser utilizado pelas Query's               �
//�o conteudo fica quardado na variavel _cStrAlmox                        �
//�������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetSldEnt �Autor  � Totvs              � Data �  16/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o saldo de uma entidade gerencial em tempo de      ���
���          � processamento                                              ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� cEntidade = Codigo da Entidade em que se deseja consultar  ���
���          � cCodVis   = Cod da visao gerencial da entidade chamadora.  ���
���          � cOrdVis   = Cod da ordem da visao gerenc da entid chamadora���
���          � nTpSaldo  = tipo de saldo a ser retornado.                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function _GetSldEnt( cEntidade, cCodVis, cOrdVis, nTpSaldo, cArqTmp )
	Local aAreaCTS		:= CTS->( GetArea() )						// Posicao atual da tabela CTS (seguranca)
	Local aAreaTMP													// Posicao atual do arquivo temporario (seguranca)
	Local aReturn		:= {}										// Array com os saldos

	//Default cCodVis		:= CTS->CTS_CODPLA
	//Default cOrdVis		:= CTS->CTS_ORDEM
	//Default nTpSaldo	:= 0										// Saldo Atual

	//Default cArqTmp		:= "cArqTmp"

	//���������������������������������������������������������Ŀ
	//�Protecao para evitar array out of bounds pois esta funcao�
	//�podera ser chamada a partir de formulas.                 �
	//�����������������������������������������������������������
	If nTpSaldo < 0 .OR. nTpSaldo > 8
		nTpSaldo := 1
	EndIf

	//����������������������������������������������������������Ŀ
	//�Verifica se a entidade que esta consultando eh superior em�
	//�relacao a  entidade que  se quer o saldo  e verifica se  a�
	//�entidade  referenciada  no  parametro  faz parte da  visao�
	//�gerencial da entidade que esta consultando o saldo.       �
	//������������������������������������������������������������
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

	//�����������������������������������������������������������Ŀ
	//�Se o tipo de saldo informado for igual a zero (0), a funcao�
	//�deve retornar o array com todos os saldos.                 �
	//�������������������������������������������������������������
	If nTpSaldo == 0
		Return aReturn
	EndIf

Return aReturn[ nTpSaldo ]



