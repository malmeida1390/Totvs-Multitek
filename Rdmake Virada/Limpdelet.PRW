#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LimpDelet �Autor  �                    � Data �  08/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Trata Custo Negativo de Produtos                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LimpDelet()
Local cTabela := "  "                       
Local aTabela := {}
      

dbUseArea(.t.,,"SX2010","TMP")

                 
DbSelectArea("TMP")
DbGotop()
While !TMP->(eof())
      aadd(aTabela,ALLTRIM(TMP->X2_CHAVE))
 		TMP->(DBSKIP())        
Enddo

 
For nY := 1 to len(aTabela)
    cTabela = aTabela[nY]
    TCSQLEXEC("DELETE FROM "+ RetSqlName(cTabela)+"  "+cTabela+"  "+"WHERE D_E_L_E_T_ = '*'")
    TCSQLEXEC("COMMIT") 
Next nY

Return

//set autocommit off; 

