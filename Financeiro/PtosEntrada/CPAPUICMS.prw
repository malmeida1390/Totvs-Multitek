#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � CPAPUICMS  � Autor � Marcelo.            � Data � 12/12/2005 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Grava o Tipo+Fornec+Loja do Titulo de Origem no Titulo de PIS ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                       ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function CPAPUICMS()

Local cAlias    := PARAMIXB[1]
Local dVencto   := (cAlias)->E2_VENCTO                                                           
//Local dDataVenc := DataValida(Ctod("18/"+STRZERO(Month(dVencto),2)+"/"+STR(Year(dVencto),4)),.t.)                                                                                                     
Local dDataVenc :=  DataValida(U_F_VENCICMS())

dDataVenc := If ( Empty(dDataVenc), (cAlias)->E2_VENCTO , dDataVenc )
                       
(cAlias)->E2_VENCTO  := dDataVenc
(cAlias)->E2_VENCREAL:= dDataVenc

Return

                            

/*
+-------------------------------------------------------------------------+
! Fun��o    ! F750BROW ! Autor ! Ambrosio-Jr        ! Data ! 14/03/13   !
+-----------+-----------+-------+--------------------+------+-------------+
! Par�metros! N/A                                                         !
+-----------+-------------------------------------------------------------+
! Descricao ! Programa chamado pelos P.E. para alterar o vcto EIC        |
! Lambrando que nem toda a altera��o por aqui pode ser realizada por causa!
! do vinculo com o modulo EIC                                             !
+-----------+-------------------------------------------------------------+
*/
User Function F_VENCICMS()
Local   _oVcto
Local   _oDlgProd
Local   _dVcto := CTOD("")
LOcal   _lTela := .F.

	
DEFINE MSDIALOG oDlgProd TITLE  "Data Vencimento" FROM 000,000 TO 145,487  OF oMainWnd pixel
@ 026,006   SAY "Vencimento: " size 100,8 OF oDlgProd PIXEL 
@ 025,040   MSGET _oVcto  VAR _dVcto  Size 50,8 OF oDlgProd PIXEL  When .T. Valid .T.
ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,;
{|| _lTela:=.T.,oDlgProd:End()},;
{|| oDlgProd:End()}) CENTERED

Return(_dVcto)



Static Function RfatBar(oDlgCons,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))



