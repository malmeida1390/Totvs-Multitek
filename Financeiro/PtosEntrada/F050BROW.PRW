#include "rwmake.ch"       
#include "protheus.ch" // Luciano M - 25/04/2013 

/*
+-------------------------------------------------------------------------+
! Função    ! F750BROW ! Autor ! Ambrosio-Jr        ! Data ! 14/03/13   !
+-----------+-----------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                         !
+-----------+-------------------------------------------------------------+
! Descricao ! P.E. para filtrar o browse da tela de FUNC contas a pagar. |
+-----------+-------------------------------------------------------------+
*/
User Function F050BROW()

aadd(aRotina,{"Altera VCTO","U_ALTVCTO()" , 0 , 2,5,NIL})

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
User Function ALTVCTO()
Private _oVcto :=SE2->E2_VENCTO
Private _dVcto :=SE2->E2_VENCTO
Private _lTela := .T.
Static _oDlg

// Verifica se é título de importação
If Alltrim(SE2->E2_PREFIXO) == "EIC" .And. SuperGetMv ("FG_EICFIN",.F.,.F.)
	
	While _lTela
		DEFINE MSDIALOG _oDlg TITLE "Altera Vencimento" FROM 000,000 TO 145,487 PIXEL
       
		@ 015,001 TO 053,245 TITLE "[ Altera Vencimento ]"
		@ 026,006 SAY "Vencimento:" 
		//SIZE 40,08 OF _oDlg
		@ 025,040 MSGET _oVcto VAR _dVcto SIZE 040,008 OF _oDlg PIXEL

		@ 030,050 Button OemToAnsi("_Confirma") Size 36,16 Action ACTION (_lTela:=.F.,Close(oDialog))
        @ 030,080 Button OemToAnsi("_Cancela") Size 36,16 Action  ACTION (_lTela:=.F.,Close(oDialog)) 

		ACTIVATE MSDIALOG _oDlg CENTERED
	Enddo
	   
	IF RecLock("SE2",.F.)
		SE2->E2_VENCTO := _dVcto
		SE2->E2_VENCREAL:= _dVcto
		MsUnlock("SE2")
	Else
		Msginfo("Titulo nao pode ser alterado o Vencimento.")
	Endif
	
Endif

Return


