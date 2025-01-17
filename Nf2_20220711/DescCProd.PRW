#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"              
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �DesCCProd � Autor � Marcelo (Imfoc)       � Data �04.03.2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Complemento descricao do Produto                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �String com complemento do Produto                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Tipo da NF                                           ���
���          �       [0] Entrada                                          ���
���          �       [1] Saida                                            ���
���          �ExpC2: Serie da NF                                          ���
���          �ExpC3: Numero da nota fiscal                                ���
���          �ExpC4: Codigo do cliente ou fornecedor                      ���
���          �ExpC5: Loja do cliente ou fornecedor                        ���        
���          �ExpC6: Alias do SD2                                         ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

USER Function DesCCProd()

Local cTipo      := PARAMIXB[1]
Local cSerie     := PARAMIXB[2]
Local cNota      := PARAMIXB[3]
Local cClieFor   := PARAMIXB[4]
Local cLoja      := PARAMIXB[5]
Local cAliasSD2  := PARAMIXB[6]
Local cReferencia:= PARAMIXB[7]

Local xMENSAGEM  := ""

Local aGetArea   := GetArea()

IF  cTipo = "1"      
         
	DbSelectArea("SZ5")
	DbSeek(xfilial()+SB1->B1_X_DESCR)

   	xMENSAGEM := alltrim(cReferencia)+" "+alltrim(SZ5->Z5_DESCR) 

    If !Empty(SC6->C6_X_PRCLI) .and. !("NAO DETERMINADO" $ SC6->C6_X_PRCLI)
    	xMENSAGEM += " Cod.Cliente: "+ALLTRIM(SC6->C6_X_PRCLI)               
	Endif

    If !Empty(SC6->C6_X_RESER) 
    	xMENSAGEM += " Reserva: "+ALLTRIM(SC6->C6_X_RESER)+" - "+ALLTRIM(SC6->C6_X_ITEMO)              
    Endif
    	
ELSE
	
    xMENSAGEM :=""
	
ENDIF

RestArea(aGetArea)

Return(xMENSAGEM)


