#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �WhenTipo  � Autor �                       � Data �14.05.2005���
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
User Function WhenTipo()
Local lRet         :=.T.
Local cProcName    := FunName()             
Local lBrowDev     :=.F.
Local II           := 0
Local cArmaFech    := GetMv("MV_ARMFECH")
            
            
// Chamado do programa especifico Multitek o Campo Ficara fechado.
// Devido esta rotina somente permitir a inclusao de Notas do Tipo Normal 
If "MTK410" $ UPPER(FunName())  
   lRet := .F.
Endif
     
// No caso de alteracao de um pedido origem Armazem de Fechamento esta possibilidade ficara 
// como fechado.
if Altera .and. cFilAnt $ cArmaFech   
   lRet := .F.
Endif
                 

Return (lRet)


 