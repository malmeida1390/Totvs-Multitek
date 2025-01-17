#INCLUDE  "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M415GRV   �Autor  �                    � Data �  30/04/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta Ponto permite a Alteracao do SCJ apos atualizacao do  ���
���          � Orcamento. Ele Avalia se o Orcamento esta Liberado por     ���
���          � Rentabilidade.                                             ���
���          � Ver Solicitacao de Desenvolvimento D-00001                 ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M415GRV() 
Local nOpc     := ParamIxb[1]         
Local aGetArea := GetArea()
Local cNum     := SCJ->CJ_NUM
Local cStatus  := "L"
Local _MV_PRODTMP:= GeTMv("MV_PRODTMP")
Local nContador:= 0      
Local cItem    := " "
Local aRecno   := {}

if nOpc == 1 .or. nOpc == 2   // Inclusao ou Altercao


   // Ajusta Numeracao do item do Sck
	DbSelectArea("SCK")
	DbSetOrder(1)
	If Dbseek(xFilial("SCK") + cNum)  
                                     
      // define todas os registros que compoem o orcamento
		While !SCK->(EOF()) .and. xFilial("SCK")+cNum = SCK->(CK_FILIAL+CK_NUM) 
			   AADD(aRecno,SCK->(RECNO()))
			   SCK->(DBSKIP())
	    Enddo		   
			   
         // Inicia alteracao do item dos registros caso necessario.
     	DbSetOrder(0)
		For nY:= 1 to len(aRecno)
	       DbGoTo(aRecno[nY])
			 If nY > 99
				 cItem := RetAsc( StrZero(nY,3), 2, .T. )
			 Else
				 cItem := StrZero(nY,2)
			 EndIf

          // Garante que a numeracao esteja correta no orcamento e que 
          // nao seje gerado nenhum tipo de desconto no Orcamento.
	       If SCK->CK_ITEM != cItem .OR. SCK->CK_PRUNIT != SCK->CK_PRCVEN 
	         DbSelectArea("SCK")
             Reclock("SCK",.F.)
             SCK->CK_PRUNIT := SCK->CK_PRCVEN
             SCK->CK_ITEM    := cItem
             MsUnlock()
          Endif   
      Next nY
  	   DbSetOrder(1)

   Endif

			
	//���������������������������������Ŀ
	//�Liberacao Manual - Pega o Nome   �
	//�����������������������������������  
	////__cUserId // Vari�vel Publica com o ID do Usu�rio Logado
	cNome := Alltrim(UsrRetName(__cUserId))

	
	DbSelectArea("SCK")
	DbSetOrder(1)
	If Dbseek(xFilial("SCK") + cNum)
		
		While !SCK->(EOF()) .and.  xFilial("SCK")+cNum = SCK->(CK_FILIAL+CK_NUM) 

			
			// conforme conversa com o Sr. Mauricio caso o Orcamento.
			// possua algum item temporario ficara como bloqueado.
			
			IF  ALLTRIM(SCK->CK_PRODUTO) $ ALLTRIM(_MV_PRODTMP)
				cStatus  := "B"
				//Aviso("ATENCAO", "O orcamento ficara como bloqueado em funcao do item "+;
				//SCK->CK_ITEM + " estar utilizando o produto " + Alltrim(SCK->CK_PRODUTO)+"."+;
				//"Produto Temporario especificado no parametro MV_PRODTMP",{"&Ok"})
				
            Else
         
		    	IF SCK->CK_X_CTSTD = 0
		       	    cStatus  := "B"
					//Aviso("ATENCAO", "O orcamento ficara como bloqueado em funcao do item "+;
					//SCK->CK_ITEM + " estar com o campo Custo Padrao em Branco.",{"&Ok"})
				Endif
	
			Endif
			
			//���������������������������������Ŀ
			//�Verifica se existe algum item Bloqueado�
			//�����������������������������������
			If SCK->CK_X_MARGA = "B"
				cStatus  := "B"
			Endif
                               
            If SCK->CK_X_MARGA = "M" 
			   If  EmptY(SCK->CK_X_USER)
			       DbSelectarea("SCK")
				   SCK->(RECLOCK("SCK",.F.))
				   SCK->CK_X_USER  := substr(cNome,7,15)
				   SCK->CK_X_DTLIB := dDataBase
				   MsUnlock() 
				Endif   
			Else  // Diferente de "M" analisa se esta preenchido para nao perder tempo dando Reclock para limpar o campo
			   if !EmptY(SCK->CK_X_USER)
			       DbSelectarea("SCK")
				   SCK->(RECLOCK("SCK",.F.))
				   SCK->CK_X_USER  := ""
				   SCK->CK_X_DTLIB := CTOD("")                                                       
				   MsUnlock()
			   Endif
			Endif   
	        DbSelectarea("SCK")
			SCK->(DbSkip())
		Enddo
		
		//���������������������������������Ŀ
		//�Status Final do Orcamento        �
		//�����������������������������������
		DbSelectArea("SCJ")
		DbSetOrder(1)
        If Dbseek(xFilial("SCJ") + cNum)  
		   SCJ->(RECLOCK("SCJ",.F.))
		   SCJ->CJ_X_MARGA := cStatus
		   SCJ->(MSUNLOCK())
		Endif   

	Endif

	
Endif

RestArea(aGetArea)
Return
               


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValAltDes �Autor  �                    � Data �  30/04/2004 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se e permitido a alteradao da Descricao de um       ���
���          � Produto.                                                   ���
���          � Conforme Orientacao somente o Produto Temporario poderia   ���
���          � ser alterado.                                              ���
�������������������������������������������������������������������������͹��
���          � Esta funcao e chamda na x3_valid do CK_DESCRI              ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValDesc(lValid)  

Local _MV_PRODTMP := GeTMv("MV_PRODTMP")
Local lRet        := .T. 
Local nProduto    := 0
Local cProduto    := ""

                    
DEFAULT lValid := .f.

If "MATA415" $ Upper(Funname()) // Defido trabalhar com Temporario.
	
	If !(ALLTRIM(TMP1->CK_PRODUTO) $ ALLTRIM(_MV_PRODTMP))
		Aviso("ATENCAO", "Somente e Permitido Alterar a descricao do Item Temporario."+;
		"O Produto Temporario esta especificado no parametro MV_PRODTMP",{"&Ok"})
		
		lRet:=.F.
	Endif
	
Else
	
	nProduto    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
	cProduto    := aCols[n][nProduto] 
   

	If !(ALLTRIM(cProduto) $ ALLTRIM(_MV_PRODTMP))
		Aviso("ATENCAO", "Somente e Permitido Alterar a descricao do Item Temporario."+;
		"O Produto Temporario esta especificado no parametro MV_PRODTMP",{"&Ok"})
		
		lRet:=.F.
	Endif
	
Endif

Return(lRet)


