#include "FiveWin.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ACDSTATU � Autor �                       � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Altera o Status do campo CB7_STATPA                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAACD                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACDSTATU       

PRIVATE aRotina := {	{ "Pesquisar"  ,"AxPesqui"   , 0, 1 }   ,; //"Pesquisar"
{"Alterar Status","U_STATUALT"  , 0,6}  ,; //"Alterar"                  
{"Legenda"       ,"T_ACDA100Lg"  , 0,3}} //"Legenda"

PRIVATE cCadastro := "Altera Status da Ordens de separacao"
PRIVATE aRecno     :={}

//Configuracoes da pergunte AIA106 (Pedidos de Venda), ativado pela tecla F12:
PRIVATE nConfLote
PRIVATE nEmbSimul
PRIVATE nEmbalagem
PRIVATE nGeraNota
PRIVATE nImpNota
PRIVATE nImpEtVol
PRIVATE nEmbarque
PRIVATE nAglutPed
PRIVATE nAglutArm
//Configuracoes da pergunte AIA107 (Notas Fiscais), ativado pela tecla F12:
PRIVATE nEmbSimuNF
PRIVATE nEmbalagNF
PRIVATE nImpNotaNF
PRIVATE nImpVolNF
PRIVATE nEmbarqNF
//Configuracoes da pergunte AIA108 (Ordens de Producao), ativado pela tecla F12:
PRIVATE nReqMatOP
PRIVATE nAglutArmOP

aCores := { { "CB7->CB7_DIVERG == '1'", "DISABLE" },;
{ "CB7->CB7_STATPA == '1'", "BR_CINZA"    },;
{ "CB7->CB7_STATUS == '9'", "ENABLE"  },;
{ "CB7->CB7_STATUS $ '12345678'","BR_AMARELO" },;
{ "CB7->CB7_STATUS == '0'","BR_AZUL" }}

//����������������������������������������������������������������Ŀ
//� Ativa tecla F12 para acionar perguntas                         �
//������������������������������������������������������������������
mBrowse( 6, 1, 22, 75, "CB7", , , , , , aCores, , , ,{|x|TimerBrw(x)})

Return



USER FUNCTION STATUALT

Local _lOpc := MsgYesNo("Deseja alterar o Estatus de pausa desta ordem de Separacao ???")


IF !(CB7->CB7_STATUS $ '9')
   if _lOpc
    	CB7->(RecLock( "CB7",.F.))
	   CB7->CB7_STATPA := if(Empty(CB7_STATPA) .or. CB7_STATPA = "2","1","2")
	   CB7->(MsUnLock())
   Endif
Else
	Aviso("ATENCAO", "Ordem de Separacao ja Finalizada.",{"&Ok"})
ENDIF

Return
		
             

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TimerBrw  � Autor � Eduardo Motta         � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que cria timer no mbrowse                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cMBrowse -> form em que sera criado o timer                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAACD                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function TimerBrw(oMBrowse)
Local oTimer
DEFINE TIMER oTimer INTERVAL 1000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
oTimer:Activate()
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TmBrowse � Autor � Eduardo Motta         � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de timer do mbrowse                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cMBrowse -> objeto mbrowse a dar refresh                   ���
���          � oTimer   -> objeto timer                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAACD                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function TmBrowse(oObjBrow,oTimer)
oTimer:Deactivate()
oObjBrow:Refresh()
oTimer:Activate()
Return .T.
