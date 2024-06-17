#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �ValidTipo  � Autor �                       � Data �14.05.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �O objetivo desta funcao e tratar o X3_WHEN do campo         ���
���          �C5_TIPO controlando a rotina que tem permissao para efetuar ���
���          �DEVOLUCAO pois na Multitek existe um especifico para        ���
���          �tratar DEVOLUCAO.                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Opcao do aRotina                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ValidTipo()
Local lRet         :=.T.
Local cProcName    := FunName()             
Local lBrowDev     :=.F.
Local II           := 0 
Local cArmaFech    := GetMv("MV_ARMFECH")
              

// A inclusao de Nota Fiscal Normal de Saida para os almoxarifados fechados somente e 
// Possivel atraves da rotina especifica para Multitek.

If !("MTK410" $ UPPER(FunName()) ) .and. M->C5_TIPO = "N" .and. cFilAnt $ cArmaFech .and. Inclui

   Aviso("ATENCAO", "A Inclusao de Notas do Tipo Normal para os Almoxarifados Fechados informados no parametro MV_ARMFECH somente podem ocorrer atraves da Rotina Especifica para Multitek.",{"&Ok"})

   lRet := .f.

Endif

Return (lRet)



