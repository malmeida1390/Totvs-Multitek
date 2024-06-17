/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � IMPETIHOF� Autor � Anderson Rodrigues    � Data � 17/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao de etiquetas de produto baseado na tabela SBF    ���
���          �	conforme os parametros informados pelo usuario             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Hofmann do Brasil                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function IMPETIHF()

If IsTelNet()
   IMPETISBF()
Else
   Processa({||IMPETISBF()})
EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �IMPETISBF � Autor � Anderson Rodrigues    � Data � 17/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Execucao da  Funcao Chamada pelo programa IMPETIHOF		     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function IMPETISBF
Local   nQtde,nQE
Local   cPerg := If(IsTelNet(),'VTPERGUNTE','PERGUNTE')
Private cEndSBF
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Produto de                                   �
//� mv_par02     // Produto ate                                  �
//� mv_par03     // Armazem de                                   �
//� mv_par04     // Endereco de                                  �
//� mv_par05     // Armazem Ate                                  �
//� mv_par06     // Endereco Ate                                 �
//� mv_par07     // Local de Impressao                           �
//����������������������������������������������������������������

AjustaSX1()
IF ! &(cPerg)("IMPETI",.T.)
   Return
EndIF
If IsTelNet()
   VtMsg('Imprimindo') 
EndIF

If ! CB5SetImp(MV_PAR07,IsTelNet())
	IF ! IsTelNet()
		MSGAlert('Codigo do tipo de impressao invalido')   
	Else
		VTAlert('Codigo do tipo de impressao invalido')           
	EndIf
	Return .f.
EndIF

SBF->(DbSetOrder(2))
SBF->(DbSeek(xFilial("SBF")+MV_PAR01+MV_PAR03,.t.))
While ! SBF->(Eof()).and. SBF->BF_PRODUTO >= MV_PAR01 .and. SBF->BF_PRODUTO <= MV_PAR02 
   If SBF->BF_LOCAL < MV_PAR03 .or. SBF->BF_LOCAL > MV_PAR05 
      SBF->(DbSkip())	
      Loop
   Endif   
	If SBF->BF_LOCALIZ < MV_PAR04 .or. SBF->BF_LOCALIZ > MV_PAR06 
	   SBF->(DbSkip())	 
	   Loop
	Endif
	If CBProdUnit(SBF->BF_PRODUTO)  	
	   If CBQtdVar(SBF->BF_PRODUTO)  	
	      nQtde := 1
	      nQE   := SBF->BF_QUANT
	   Else
	      nQE   := IF(Empty(SB1->B1_QE),1,SB1->B1_QE)
	      nQtde := SBF->BF_QUANT/nQE	   
	   Endif   
	Else
	   nQtde := 1
	   nQE   := SBF->BF_QUANT
	EndIf
	If ! CBImpEti(SBF->BF_PRODUTO)  	
	   SBF->(DbSkip())
	   Loop
	EndIf 
   SB1->(DbSetOrder(1))
   If SB1->(DbSeek(xFilial("SB1")+SBF->BF_PRODUTO))
	   cEndSBF:= SBF->BF_LOCALIZ 
	   If ExistBlock('IMG01')
	      ExecBlock('IMG01',,,{nQE,NIL,NIL,nQtde,NIL,NIL,NIL,NIL,SBF->BF_LOCAL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,SBF->BF_LOCALIZ})
	   EndIf
	Endif   
	SBF->(DbSkip())	
Enddo      	
If ExistBlock('IMG00')
   ExecBlock('IMG00',,,{"U_IMPETIHF",MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05,MV_PAR06})
EndIf
MSCBCLOSEPRINTER()   
Return
	   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1    �Autor � Anderson Rodrigues   �Data� 17/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Cria o grupo de perguntas no SX1 caso o mesmo nao exista   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AjustaSX1()
Local cAlias := Alias()
Local aRegistros:={}
Local i,j:=0

aadd(aRegistros,{"IMPETI","01","Produto de          ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegistros,{"IMPETI","02","Produto ate         ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aadd(aRegistros,{"IMPETI","03","Armazem de          ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(aRegistros,{"IMPETI","04","Endereco de        ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})
aadd(aRegistros,{"IMPETI","05","Armazem ate         ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ",""})
aadd(aRegistros,{"IMPETI","06","Endereco ate       ?","","","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SBE",""})
aadd(aRegistros,{"IMPETI","07","Local de Impressao ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CB5",""})

DbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next j
		MsUnlock()
	EndIf
Next I
dbSelectArea(cAlias)
Return