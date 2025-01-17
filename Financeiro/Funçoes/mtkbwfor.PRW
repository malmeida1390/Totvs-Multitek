#include "FiveWin.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKBWFOR  �Autor  �   Edelcio Cano     � Data � 05/04/2004  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Inclusao de Fornc., com consistencia de apenas  ���
���          �01 usuario por vez realizar a inclusao                      ���
�������������������������������������������������������������������������͹��
���Uso       �Rochester                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTKBWFOR(aRotAuto, nOpc)

MATA020()  // Utilizacao do Padrao.

Return

// Apos conversa com o Mauricio a funcionalidade abaixo deixou de ser utilizada
// apos processo de virada.
// A customizacao deste fonte ocorria na versao 7 em funcao da necessidade de travar a 
// inclusao de novos fornecedors com o mesmo codigo.
// Na versao Protheus10 existe o checkuniq que ira impedir esta ocorrencia.

/*
Public aRotina := { 	{"Pesquisar","AxPesqui" , 0 , 1},;  // "Pesquisar"
						{"Visualizar","AxVisual", 0 , 2},;  // "Visualizar"
						{"Incluir","U_MTKFOR1" , 0 , 3},;  // "Incluir"
						{"Alterar","A020Altera" , 0 , 4},;  // "Alterar"
						{"Excluir","A020Deleta" , 0 , 5,3},;// "Excluir"
						{"Contatos","FtContato" , 0 , 4}}   // "Contatos"


//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := "Fornecedores"
Private l020Auto  := ( aRotAuto <> NIL )
PRIVATE aMemos    := {}

AjustaSx3()

//��������������������������������������������������������������Ŀ
//� Ponto de entrada para adicao de campos memo do usuario       �
//����������������������������������������������������������������
If ExistBlock( "MA020MEM" )
	aMemUser := ExecBlock( "MA020MEM", .F., .F. )
	If ValType( aMemUser ) == "A"
		AEval( aMemUser, { |x| AAdd( aMemos, x ) } )
	EndIf
EndIf

If cModulo == "COM"
	Set Key VK_F12 to FAtiva()
EndIf

pergunte("MTA020",.F.)

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
If ( l020Auto )
	MsRotAuto(nOpc,aRotAuto,"SA2")
Else
	mBrowse( 6, 1,22,75,"SA2")
EndIf

If !( l020Auto )
	Set Key VK_F12 To 
EndIf

Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTKFOR1   �Autor  �Edelcio Cano        � Data �  19/03/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera COdigo de Fornec., verifica parametro e chama funcao  ���
���          � Padrao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
User Function MTKFOR1()

_aAreaM	    := GetArea()
_lMvForn	:=	GetMv("MV_INCFORN")

If _lMvForn == .F.
	//�������������������������������������������������������������������Ŀ
	//� Altera parametro que consiste somente 01 usuaria Incluido Forneced�
	//���������������������������������������������������������������������
	_lMvForn	:=	GetMv("MV_INCFORN")
	Reclock("SX6",.F.)
	SX6->X6_CONTEUD := ".T."
	MsUnlock()
	//�����������������������������������������������Ŀ
	//�Chamada da Funcao Padrao, Cadastro de Forneced.�
	//�������������������������������������������������
	A020Inclui("SA2")
	//�������������������������������������������������������������������Ŀ
	//� LIBERA parametro que consiste somente 01 usuaria Incluido Forneced�
	//���������������������������������������������������������������������
	_lMvForn	:=	GetMv("MV_INCFORN")
	Reclock("SX6",.F.)
	SX6->X6_CONTEUD := ".F."
	MsUnlock()
	
Else
	Aviso("ATENCAO", "Impossivel acesso simultaneo ao Cadastro de Fornecedores por mais de 01 usuario",{"&Sair"})
	Return
Endif


RestArea(_aAreaM)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FAtiva   � Autor � Cristina Ogura        � Data � 18.10.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chama a pergunte                                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA020                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function FAtiva()
pergunte("MTA020",.T.)
Return



// Funcao para retirada da validacao do banco do fornecedor.
// O banco do fornecedor nao esta ligado ao cadastro de bancos SA6
Static Function AjustaSx3()
LOCAL aArea := GetArea()
LOCAL aAreaSx3 := SX3->(GetArea())

DbSelectArea("SX3")
dbSetOrder(2)
If dbseek("A2_BANCO")
	If !Empty(X3_VALID)
		RecLock("SX3",.F.)
		Replace X3_VALID with ""
		MsUnlock()
	Endif
Endif
If dbseek("A2_AGENCIA")
	If !Empty(X3_VALID)
		RecLock("SX3",.F.)
		Replace X3_VALID with ""
		MsUnlock()
	Endif
Endif
RestArea(aAreaSx3)
RestArea(aArea)
Return .t.	