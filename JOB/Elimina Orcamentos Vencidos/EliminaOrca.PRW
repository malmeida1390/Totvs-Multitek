#include "RWMAKE.CH"
#include "topconn.ch"
#include "tbiconn.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �EliminaOrca � Autor �Eduardo Riera        � Data �19/10/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de avaliacao do cancelamento dos Orcamentos por      ���
���          �vencimento de validade.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpC1 := ValidaOrc()                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Observacao�Esta rotina efetua o cancelamento automatico dos orcamento  ���
���          �apos o vencimento da validade do mesmo.                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA415                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function EliminaOrca()

Local aArea      	:= GetArea()
Local lEnd       	:= .F.
Local lContinua 	:= GetMv("MV_ORCVLD")

Local lQuery        := .T.
Local cAlias        := "ARQSCJ"
Local cQuery        := ""


If ( lContinua )

	If ( GetMv("MV_ORCUVLD") >= dDataBase )
		lContinua := .F.
	EndIf
	GetMv("MV_ORCVLD")
	dbSelectArea("SX6")

	lContinua := MsRLock()

	If ( lContinua )
		
		//��������������������������������������������������������Ŀ
		//�Atualiza a data de ultima checagem                      �
		//����������������������������������������������������������
		GetMv("MV_ORCUVLD")
		dbSelectArea("SX6")
		If ( Found() )
			PutMv("MV_ORCUVLD",Dtos(dDataBase))
		EndIf

        TCSQLEXEC(("UPDATE "+ RetSqlName("SCJ")+" (NOLOCK) SCJ "+;
                   "SET SCJ.CJ_STATUS = 'C' "+;
	               "WHERE  SCJ.CJ_VALIDA<'"+Dtos(dDataBase)+"' AND SCJ.CJ_STATUS IN ('A','D') AND SCJ.D_E_L_E_T_=' '"))
		        
		dbSelectArea("SX6")
		GetMv("MV_ORCVLD")
		MsRUnLock()

	EndIf
EndIf
RestArea(aArea)
Return(.T.)

