#INCLUDE "Rwmake.Ch"
//		DbOrderNickname("B2CODIGO") // CODIGO + ARMAZEM

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415BUT  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Botao para chamada do programa de Simulacao de Vendas       ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA415BUT()
Local aButtons :={}            
Local aAreaAll :=GetArea()  

//Local aAreaTMP1:=TMP1->(GetArea())


//AADD(aButtons, {"AFASTAME" 	, {||u_Pfata07()}	, "Monitoramento - CDA"})
//AADD(aButtons, {"PRODUTO" 	, {||U_PFATC02()}	, "Consulta de Produtos"})
//AADD(aButtons, {""         	, {||			 }	, ""})

If Upper(Funname()) $ "MATA415|#MFATC04" // Pode ser chamado da efetivacao MATA416.
   
   if Inclui .or. Altera                          

      AADD(aButtons, {"PRODUTO"    , {||U_MFATC02()}	, "Consulta Produtos"})
      AADD(aButtons, {"SIMULACAO" 	, {||U_MFATC01()}	, "Simulador de Precos"})

   Endif 
   
Endif

//TMP1->(RestArea(aAreaTMP1))

RestArea(aAreaAll)

Return(aButtons)
