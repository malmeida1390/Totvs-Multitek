/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VLR01510 �Autor  �Edelcio Cano        � Data �  03/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consiste Naturezas(Higien Limp/Mat.Segur/Mat.Cons/Manut.   ���
���          �                    Bens Inst.)                             ���
�������������������������������������������������������������������������͹��
���Uso       � Multitek                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                          

User Function VLR01510()

Local _aAreaAt	:=	GetArea()
Local _nValor   := 0        

//�����������������������Ŀ
//�Captura Valor do Titulo�
//�������������������������
If Alltrim(SE2->E2_NATUREZ)$ "02057/02059/02060/02061/02055/02013/02058/02089/02109" .AND. SE2->E2_TIPO <> "NDF"                                 
                           
	_nValor	:= SE2->E2_VALOR
	
Endif
                              
RestArea(_aAreaAt)

Return(_nValor)