#INCLUDE "FIVEWIN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLOCALSD1 �Autor  �                    � Data �  06/09/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida local de Entrada da Nota Fiscal todas as NF          ���
���          �devem entrar como local 01 em funcao das nossas             ���
���          �customizacoes.                                              ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT100TOK()                                                      
Local lRet  := .T.
Local nY    := 0
Local nLocal:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})
Local nCod  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})

For nY := 1 to Len(acols)
	
	If !aCols[nY][Len(aHeader)+1]
		
		IF  ! SUBSTR(aCols[nY][nCod],1,2) $ "PS|MC|AF"
			
			If aCols[nY][nLocal]<>'01'
				Aviso("ATENCAO", "O Local de entrada do material deve ser sempre 01 ",{"&Ok"})
				lRet := .f.
			Endif
			
		Endif
		
	Endif
	
Next

Return(lRet)

