#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKBWCLI  �Autor  �   Edelcio Cano     � Data � 05/04/2004  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Inclusao de Clientes, com consistencia de apenas���
���          �01 usuario por vez realizar a inclusa                       ���
�������������������������������������������������������������������������͹��
���Uso       �Rochester                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTKBWCLI(aRotAuto,nOpc)

MATA030()
    
  
Return

/*
Public aRotina := { 	{"Pesquisar","AxPesqui" , 0 , 1},;   // "Pesquisar"
						{"Visualizar","AxVisual", 0 , 2},;   // "Visualizar"
						{"Incluir","U_MTKCLI1" , 0 , 3},;      // "Incluir"
						{"Alterar","A030Altera" , 0 , 4},;   // "Alterar"
						{"Excluir","A030Deleta" , 0 , 5,3},; // "Excluir"
						{"Contatos","FtContato" , 0 , 4}}     // "Contatos"


PRIVATE cCadastro := "Clientes"
PRIVATE aMemos    := {}

//��������������������������������������������������������������Ŀ
//� Ponto de entrada para adicao de campos memo do usuario       �
//����������������������������������������������������������������
If ExistBlock( "MA030MEM" )
	aMemUser := ExecBlock( "MA030MEM", .F., .F. )
	If ValType( aMemUser ) == "A"
		AEval( aMemUser, { |x| AAdd( aMemos, x ) } )
	EndIf
EndIf

nOpc := if (nOpc == Nil, 3, nOpc)
//��������������������������������������������������������������Ŀ
//� Definicao de variaveis para rotina de inclusao automatica    �
//����������������������������������������������������������������
Private l030Auto := ( aRotAuto <> NIL )

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������

If Select("SAO") # 0
	aadd(aRotina,{"Referencias","Mata030Ref" , 0 , 3, 0, .F.})
EndIf

If l030Auto
	MsRotAuto(nOpc,aRotAuto,"SA1")
Else
	mBrowse( 6, 1,22,75,"SA1")
EndIf

Return .T.
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKCLI1   �Autor  �Edelcio Cano        � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera C�digo de Cliente, verifica parametro e chama funcao  ���
���          � Padrao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
User Function MTKCLI1()

_aAreaM	    := GetArea()
_lMvClie	:=	GetMv("MV_INCCLIE")

If _lMvClie == .F.
	//�������������������������������������������������������������������Ŀ
	//� Altera parametro que consiste somente 01 usuaria Incluido Clientes�
	//���������������������������������������������������������������������
	_lMvClie	:=	GetMv("MV_INCCLIE")
	Reclock("SX6",.F.)
	SX6->X6_CONTEUD := ".T."
	MsUnlock()
	//����������������������������������������������������������Ŀ
	//�Chamada da Funcao Padrao de Inclusao Cadastro de Clientes.�
	//������������������������������������������������������������
	A030Inclui("SA1")
	
	//�������������������������������������������������������������������Ŀ
	//� LIBERA parametro que consiste somente 01 usuaria Incluido Clientes�
	//���������������������������������������������������������������������
	_lMvClie	:=	GetMv("MV_INCCLIE")
	Reclock("SX6",.F.)
	SX6->X6_CONTEUD := ".F."
	MsUnlock()
	
Else
	MsgBox("Impossivel o acesso simultaneo ao Cadastro de clientes por mais de 01 usuario","ALERT")
	Return
Endif


RestArea(_aAreaM)

Return 

*/