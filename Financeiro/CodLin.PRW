#include "rwmake.ch"                                                                        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CodBar    �Autor  �Priscila S Pereira  � Data �  22/07/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validar o codigo de barras ou a linha digitavel de titulos ���
���          � a pagar ou a receber                                       ���
���          �                       1 Linha digitavel de titulos/Boletos ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CodLin()
                 
Local cCodBar  :=  " "
_cALIAS  :=  GetArea()		


    IF SE2->E2_X_LEITO == "N"
                                                                  
		cCodBar:= SUBSTR(SE2->E2_X_CODBA,1,48)
 
	Else
	
		cCodBar := Replicate("0",48)  

Endif	

RestArea(_cAlias)

return(cCodBar) 