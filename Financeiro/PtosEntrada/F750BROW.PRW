#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
/*
+-------------------------------------------------------------------------+
! Função    ! F750BROW ! Autor ! Ambrosio-Jr        ! Data ! 14/03/13   !
+-----------+-----------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                         !
+-----------+-------------------------------------------------------------+
! Descricao ! P.E. para filtrar o browse da tela de FUNC contas a pagar. |
+-----------+-------------------------------------------------------------+
*/
User Function F750BROW()  

//Local cCodUser := RetCodUsr()

If RetCodUsr() <> "000000"
    //aadd(aRotina,{"Altera VCTO EIC","U_F_ALTVCTO()" , 0 , 2,5,NIL})  // Rotina Anterior
     aadd(aRotina,{"Altera VCTO EIC","U_ALTVCTO2()" , 0 , 3, , .T.}) // Luciano M - 25/04/2013
Else
   Alert("Usuario sem acesso")
Endif   

Return(aRotina)

/*
+-------------------------------------------------------------------------+
! Função    ! F750BROW ! Autor ! Ambrosio-Jr        ! Data ! 14/03/13   !
+-----------+-----------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                         !
+-----------+-------------------------------------------------------------+
! Descricao ! Programa chamado pelos P.E. para alterar o vcto EIC        |
! Lambrando que nem toda a alteração por aqui pode ser realizada por causa!
! do vinculo com o modulo EIC                                             !
+-----------+-------------------------------------------------------------+
*/
User Function ALTVCTO2()
Local   _oVcto
Local   oDlgProd
Local   _dVcto :=SE2->E2_VENCTO
LOcal   _lTela := .F.


// Verifica se é título de importação
If Alltrim(SE2->E2_PREFIXO) == "EIC" .and. SE2->E2_SALDO<>0 //.And. SuperGetMv ("FG_EICFIN",.F.,.F.)
	
	DEFINE MSDIALOG oDlgProd TITLE  "Altera Vencimento - Titulos EIC." FROM 000,000 TO 145,487  OF oMainWnd pixel
	@ 026,006   SAY "Vencimento: " size 100,8 OF oDlgProd PIXEL //FONT oFntFecha5
	@ 025,040   MSGET _oVcto  VAR _dVcto  Size 50,8 OF oDlgProd PIXEL  When .T. Valid .T.
	ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,;
	{|| _lTela:=.T.,oDlgProd:End()},;
	{|| oDlgProd:End()}) CENTERED
	
	iF _lTela        
	    DbSelectArea("SE2") 
		IF RecLock("SE2",.F.)
			SE2->E2_VENCTO := _dVcto
			SE2->E2_VENCREAL:= _dVcto
			MsUnlock("SE2")
		Else
			Msginfo("Titulo nao pode ser alterado o Vencimento.")
		Endif
	enDIF
	
Else
	
	Msginfo("Prefixo do titulo nao e EIC ou titulo ja esta baixado.")
	
Endif

Return



Static Function RfatBar(oDlgCons,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))


