#INCLUDE "Rwmake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120GRV  �Autor  � Marcelo Almeida    � Data �  23/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Apos Gravacao do Pedido de Compra.                          ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120GRV()

// Exitem casos que o pedido e excluido tendo SCR isto deixa o lixo dentro do sistema.
// Esta query tera o papel de manter a base limpa caso o processo acima venha a ocorrer 
TCSQLEXEC("UPDATE SCR010 SET D_E_L_E_T_='*' WHERE D_E_L_E_T_<>'*' AND CR_NUM NOT IN ( SELECT C7_NUM FROM SC7010 WHERE D_E_L_E_T_<>'*') " )
TCSQLEXEC(("COMMIT"))

Return
