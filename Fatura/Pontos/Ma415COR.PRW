#INCLUDE "Rwmake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415COR  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Permite controlar a Legenda do Orcamento                    ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA415COR() 

Local aGetArea := GetArea()
Local aCores := { { '(SCJ->CJ_STATUS=="A".and.SCJ->CJ_X_MARGA = "L")' , 'BR_VERDE' },; 	  //Liberado  em Aberto
	                { 'SCJ->CJ_STATUS=="A".and.SCJ->CJ_X_MARGA = "B"' , 'BR_CINZA' },; 	  //Bloqueado em Aberto
	                { 'SCJ->CJ_STATUS=="B"' , 'BR_VERMELHO'},;	  //Orcamento Baixado
	                { 'SCJ->CJ_STATUS=="C"' , 'BR_PRETO'},;	  //Orcamento Cancelado
                	 { 'SCJ->CJ_STATUS=="E"' , 'BR_AZUL' },;	  //Orcamento aprovado
	                { 'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'}}  //Orcamento nao Orcado

RestArea(aGetArea)

Return(aCores)


