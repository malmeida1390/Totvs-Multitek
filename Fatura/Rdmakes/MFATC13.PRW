#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFATC13   �Autor  �                    � Data �  05/05/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de Usuarios que poderam efetuar Liberacao Manual   ���
���          �de Rentabilidade no Sistema.                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP7                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MFATC13()

Local aArea := GetArea()

DbSelectArea("SZC")
DbSetOrder(1)

AxCadastro("SZC","Cadastro de Usuarios",".T.","U_ValUsu13()")

RetIndex("SZC")

RestArea(aArea)

Return


User Function ValUsu13(cCodigo)
Local lRet:= .t.


If Inclui                     //Processo semelhante ao EXISTCHAV("SZ5")
	If !ExistChav("SZC",cCodigo,,"")
		Aviso("ATENCAO", "Codigo de Usuario Ja Cadastrado",{"&Ok"})
		lRet := .f.
	Endif
Endif

Return(lRet)


  