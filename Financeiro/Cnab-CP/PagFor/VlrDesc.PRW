#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLRDESC   �Autor  �Edelcio Cano        � Data �  04/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula Vlr de Desconto do Titulo, apos Compensacao da(s)  ���
���          � NDF(s)                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VlrDesc() 

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������
SetPrvt("_nValDesc,")

_nValDesc := 0  

IF (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL) = 0 
	   
	_nValDesc := SE2->E2_DECRESC + (SE2->E2_VALOR - SE2->E2_SALDO)
Else
         
	_nValor   := SE2->E2_VALOR - (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
			
	_nValDesc := SE2->E2_DECRESC + (_nValor - SE2->E2_SALDO)
Endif   

Return(StrZero(_nValDesc*100,15))        