#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �bgCadZZ   � Autor � Desconhecido       � Data �  04/12/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          � Cadastro de Municipio - Bertoloto e Grotta                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function bgCadZZ

dbSelectArea("SZZ")
dbSetOrder(1)

AxCadastro("SZZ","Municipios",".T.",".T.")

Return