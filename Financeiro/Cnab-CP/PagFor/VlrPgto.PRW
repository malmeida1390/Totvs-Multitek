#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLRPGTO   �Autor  �Edelcio Cano        � Data �  02/03/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula Vlr de Pagto do Titulo, Apos Compensacao de NDF.   ���
���          � Todo o Desconto (Devol e Desconto) deve ser tratado com    ���
���          � uma inclusao de uma NDF e Compensacao, antes de enviar o   ���
���          � titulo ao Banco.                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VlrPgto()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
SetPrvt("_nValPag,")

_nValPag    := 0
_nValCodbar := 0

//_nValPag    := SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_ACRESC
_nValPag    := SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE   //USO DO SALDO DO DECRESCIMO E ACRESCIMO, DISPONIVEL NA VERSAO P10.

/*
If SE2->E2_X_LEITO == "S"   

	If Val(SubStr(SE2->E2_X_CODBA,10,10)) <> 0
		_nValCodBar := StrZero(Val(SubStr(SE2->E2_X_CODBA,10,10)),15)
	Else
	   _nValCodBar := SE2->E2_SALDO
	Endif
Else 
	
	If Val(SubStr(SE2->E2_X_CODBA,38,10)) <> 0
		_nValCodBar := StrZero(Val(SubStr(SE2->E2_X_CODBA,38,10)),15)
	Else
	   _nValCodBar	:= SE2->E2_SALDO
	Endif   
Endif


//�������������������������������������������������Ŀ
//�Verifica se o valor do Cod.Barras eh igual ao    �
//�E2_Saldo. Se for nao houve Retencoes de Impostos.�
//���������������������������������������������������
If !_nValCodBar == StrZero(SE2->E2_SALDO,15) 
	
	_nValPag := SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_ACRESC
	
Else
	
	_nValPag := _nValCodBar
	
Endif
*/
Return(StrZero(_nValPag*100,15))