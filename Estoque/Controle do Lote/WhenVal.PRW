#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �WhenVal   � Autor �                       � Data �14.05.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �O campo preco de venda durante o envio para o ALMOX.        ���
���          �FECHADO nao pode ser alterado o mesmo deve assumir          ���
���          �o custo B1_X_CSTD                                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function WhenVal()
Local lRet         :=.T.
Local cProcName    := FunName()             
Local lBrowDev     :=.F.
Local II           := 0
Local cArmaFech    := GetMv("MV_ARMFECH")
Local cFilAlmox    := ""

Local nPRCVEN      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN" })
Local _nPRCVEN    :=IIF(TYPE("M->C6_PRCVEN")   <>"U",&("M->C6_PRCVEN")    ,aCols[n][nPRCVEN] )

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX) 
			cFilAlmox := SA1->A1_X_ALMOX
	    Endif 
	Endif    
Endif
            

if cFilAlmox $ cArmaFech      

   lRet := IiF(EMPTY(_nPRCVEN),.T.,.F.)

Endif


Return (lRet)

     

  
 