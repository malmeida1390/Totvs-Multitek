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
���Programa  �LimpaPTerc�Autor  �                    � Data �  08/05/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Limpa Poder de Terceiros, quantidades Reservadas            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LimpaPTerc()

TCSQLEXEC("update sb2010 set b2_qnpt = 0 where b2_qnpt <> 0 and b2_filial <> '99'")
TCSQLEXEC("COMMIT")
TCSQLEXEC("update sb2010 set b2_qtnp = 0 where b2_qtnp <> 0 and b2_filial <> '99'")
TCSQLEXEC("COMMIT")
TCSQLEXEC("update SC9010 set c9_blwms = '  ' where c9_blwms <> '  ' and c9_filial <> '99'")
TCSQLEXEC("COMMIT")
TCSQLEXEC("update SC9010 set c9_identb6 = '"+space(6)+"' where c9_identb6 <> '"+space(6)+"' and c9_filial <> '99'")
TCSQLEXEC("COMMIT")

Return
