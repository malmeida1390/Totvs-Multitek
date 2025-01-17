#INCLUDE "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFATC06   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Itens do Contrato para Geracao do Pedido                    ���
���          �Chamado no MFATC05. (Geracao de Pedidos atraves de Contrato)���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MFATC06()                 
            
Local aGetArea    := GetArea()
Local cCadastro   := "Relacao de Itens do Contrato"
Local aSizeAut    := MsAdvSize(,.F.)

Local bSetKey4
Local bSetKey12  

Local nOpcA       := 0
Local nY          := 0
Local nLin        := 0 
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local cItem       := ""
Local nRecno      := 0

Local lInverte    := .f.
Local aBackRot    := aClone(aRotina)
Local aStru       := {}
Local aCampos     := {}
Local cFABRI      := GetMark()
Local nUsado      := 0
Local cArqB1      := ""

Local oMark  
Local cCampo      := ""
Local cVal        := ""
Local nPos        := 0

Local cIndex      := ""
Local cChave      := ""
Local nIndex      := 0


Private cArqDTC   := ""  
Private cIndTmp   := ""
Private aListVend := {}  
Private oListVend   
Private cEspress  := "< F4 > Consulta Estoque da Malha Logistica"               

//������������������������������������������������������������������������Ŀ
//�Variaveis utilizadas no posicionamento do Acols                         �
//��������������������������������������������������������������������������
Private	nITEM     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_ITEM"})
Private	nPRODUTO  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
Private	nPRODCLI  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODCLI"})
Private	nUM       := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_UM"})
Private	nQTDVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
Private	nQTDENV   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"})
Private	nPRCVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
Private	nVALOR    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
Private	nTES      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_TES"})
//Private	nLOCAL    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCAL"})
Private	nPRUNIT   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
Private	nS_Refer  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_REFER"})
Private	nS_Sufix  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SUFIX"})
Private	nS_FABRI  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_MARCA"})
Private	nS_SKU    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SKU"})

Private cIndComb    := ""
Private aIndComb    := {}
Private oIndComb        
Private aIndAll     := {}

Private oProcurar   
Private cProcurar   := space(20)

//��������������������������������������������������������������Ŀ
//�Efetua a montagem do Combox                                   �
//����������������������������������������������������������������
//DbSelectArea("SIX")
//DbSetOrder(1)
//DbSeek("SZ6")
//While !SIX->(EOF()) .and. SIX->INDICE ="SZ6"
//      AAdd(aIndex,Upper(SIX->DESCRICAO))   
//      SIX->(DBSKIP())
//Enddo      


//������������������������������������������������������Ŀ
//� Gera Estrutura do Trb - Mark Browse                  �
//��������������������������������������������������������
AADD(aStru  ,{"T_OK","C", 2 , 0} )
AADD(aCampos,{"T_OK",""," "," "})


dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SZ6")
While ( !SX3->(EOF()) .And. (SX3->X3_ARQUIVO == "SZ6") )

	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ; 
		!Trim(x3_campo)$"Z6_NUM|Z6_CLIENTE|Z6_LOJA|Z6_DATA|Z6_CONDPAG|Z6_NOMCLI|Z6_ITEM|Z6_S_REFER|Z6_S_SUFIX|Z6_S_MARCA|Z6_PRCREA|Z6_DTENCER|Z6_QTDENV" )  
 
        cCampo:=TRIM(SX3->X3_TITULO)                       

		AADD(aStru  ,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL} )
		AADD(aCampos,{SX3->X3_CAMPO,"",cCampo,SX3->X3_PICTURE} )

		nUsado++
	EndIf

	dbSelectArea("SX3")
	dbSkip()
EndDo

//������������������������������������������������������Ŀ
//� Gera o Trb Vazio                                     �
//��������������������������������������������������������
cArqB1   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)

//������������������������������������������������������Ŀ
//� Monta Matriz com os Indices utilizados p/ Trb.       �
//��������������������������������������������������������
AAdd(aIndAll,{"REFERENCIA + SUFIXO + MARCA","Z6_X_REFER+Z6_X_SUFIX+Z6_X_MARCA"})
AAdd(aIndAll,{"SKU (COD. DO CLIENTE)      ","Z6_PRODCLI"})
AAdd(aIndAll,{"SKU (COD. MULTITEK)        ","Z6_PRODUTO"})

//������������������������������������������������������Ŀ
//� 1) Monta o Combobox Baseado na Matriz acima          �
//� 2) Posiciona no Primeiro Index                       �
//��������������������������������������������������������
For nY:=1 to len(aIndAll)
    aadd(aIndComb,aIndAll[nY][1]) 
Next nY    
cIndComb := aIndComb[1]          

//������������������������������������������������������Ŀ
//� Gera o Index para a Primeira Posicao                 �
//��������������������������������������������������������
GeraIndex(cIndComb,cIndex,oMark)

//������������������������������������������������������Ŀ
//� Gera informacoes para o MarkBrose                    �
//��������������������������������������������������������
GeraMarkB(cArqB1,aStru,oMark)


AAdd( aObjects, { 0,    10, .T., .F. } )  // 10 Indica o Inicio linha do MsgetDados
AAdd( aObjects, { 10,   50, .T., .T. } )
AAdd( aObjects, { 10,   15, .T., .F. } )
AAdd( aObjects, { 0,    08, .T., .F. } )
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,40,  155,180,  280}})

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey4 :=SetKey(VK_F4,{|| U_MFATC03(TRB->Z6_PRODUTO)})
bSetKey12:=SetKey(VK_F12,nil)

oMark := MsSelect():New("TRB","T_OK",,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})
oMark:bMark := {| | MfatDisp(cFABRI,lInverte,@oMark)}   // Atualiza outras telas quando dispara o 
oMark:oBrowse:nFreeze := 5  // congelando estas colunas ocorre um "flicker" na tela
oMark:oBrowse:lhasMark = .t.                              // evento click
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark) } // Permite FABRIr um, inverter,

@ aPosObj[3,1],aPosGet[1,1] SAY "Pesquisar por " of oDlg PIXEL  
@ aPosObj[3,1],aPosGet[1,2] MSCOMBOBOX oIndComb VAR cIndComb ITEMS aIndComb  SIZE 120,50 OF oDlg PIXEL; 
  ON CHANGE GeraIndex(cIndComb,cIndex,oMark)


@ aPosObj[3,1],aPosGet[1,3] SAY "Localizar"  of oDlg PIXEL SIZE 31,9	
@ aPosObj[3,1],aPosGet[1,4] MSGET oProcurar Var cProcurar ;
	When .t. Valid .t. of oDlg PIXEL

DEFINE SBUTTON FROM aPosObj[3,1],aPosGet[1,5]  TYPE 15 ACTION ProcPosic(cProcurar) ENABLE OF oDlg

@ aPosObj[4,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{||nOpcA := 1 , oDlg:End()},{||oDlg:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F12,bSetKey12)

//������������������������������������������������������������������������Ŀ
//�Atualiza o Preco de Venda com base no aColsSim.                         �
//��������������������������������������������������������������������������

If  nOpcA == 1

    If Len(aCols) != 0  
	   If LEN(Acols) = 1 .and. EmptY(aCols[1][nPRODUTO])
          cItem     := "00"	
       Else
          cItem     := aCols[LEN(aCols)][nITEM] 
       Endif
    Else   
       cItem     := "00"	
	Endif
	
	DbSelectArea("TRB")
	
	ProcRegua(TRB->(RECCOUNT()) )
	
	DbGotop()
	
	While !TRB->(EOF())
		
		IncProc()
		
		If TRB->T_OK == cFABRI

			cItem := Soma1(cItem) // Novo Item
			
			if  cItem  = "01"
				nLin := 1
			Else
				AADD(aCols,Array(Len(aHeader)+1))
				nLin := Len(aCols)
			Endif

	        DbSelectArea("TRB")
		    For nX := 1 to Len(aHeader)
		        cCampo := aHeader[nX][2]  
		        nPos   := FieldPos(cCampo)           
                if nPos # 0
		           cVal   := FieldGet(nPos)  
		           aCols[nLin][nX] := cVal 
		        Endif   
		    Next nX    

			aCols[nLin][Len(aHeader)+1]:=.F.
			aCols[nLin][nITEM]         := cItem
			aCols[nLin][nS_Refer]      := TRB->Z6_X_REFER
			aCols[nLin][nS_Sufix]      := TRB->Z6_X_SUFIX
			aCols[nLin][nS_FABRI]      := TRB->Z6_X_MARCA
			aCols[nLin][nS_SKU]        := TRB->Z6_PRODUTO
            aCols[nLin][nQtdEnv]       := 1
            aCols[nLin][nVALOR]        := aCols[nLin][nPRCVEN]   * aCols[nLin][nQtdEnv]
                      
           
            //�������������������������������Ŀ
            //�Alimentacao dos campos Virtuais�
            //���������������������������������
            U_B1VIRTUAL(aCols,aHeader,nLin)

			nRecno:=0
			
		Endif
		
		TRB->(DBSKIP())
		
	Enddo

    ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento.

Endif
                    

U_MediaRent(NIL,NIL,"CC")

//��������������������������������������������������������������Ŀ
//� Deleta arquivo temporario                                    �
//����������������������������������������������������������������
If File(cArqB1+".DTC")
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cArqB1+".DTC")
	Ferase(cIndex+OrdBagExt())
Endif

RestArea(aGetArea)

Return

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �MfatInvS  � Autor �                       � Data � 07/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inverte Fabricacoes 										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � MfatInvS     											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MfatInvS(cFABRI,oMark)

Local nReg := TRB->(Recno())

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	RecLock("TRB",.F.)
	IF  T_OK == cFABRI
		TRB->T_OK := "  "
	Else
		TRB->T_OK := cFABRI
	Endif
    MsUnlock()
	dbSkip()
Enddo
TRB->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | GeraMarkB� Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera dados no Trb conf. solitado no filtro para MarkBrowse ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraMarkB(cArqB1,aStru,oMark)

Local aArSZ6 := {}
Local cChave := xFilial("SZ6") + cNum + cCliente + cLoja
Local nY     := 0   
Local cCampo := ""
Local cVal   := ""
Local nPos   := 0
          
dbSelectArea("SZ6")
aArSZ6 := GetArea()

DbSetOrder(1)
DbGoTop()    


If Dbseek(cChave)

   While !SZ6->(EOF()) .and. cChave  =  (xFilial("SZ6") + SZ6->Z6_NUM + SZ6->Z6_CLIENTE + SZ6->Z6_LOJA)
      
         If  SZ6->Z6_STATUS $ 'N'
             SZ6->(DBSKIP())
             Loop
         Endif    

		 Reclock("TRB",.T.)
		 For nY:= 1 to len(aStru) 
   		     DbSelectArea("SZ6")
		     cCampo := aStru[nY][1]                    
		     nPos   := FieldPos(cCampo)                                //FieldName(nCont)// Nome do Campo
		     if nPos # 0
		        cVal   := FieldGet(nPos)                                // Conteudo
  		        DbSelectArea("TRB")
		        nPos   := FieldPos(cCampo)                              // Busca posicao Campo no Trb
  		        if nPos # 0 .and. cCampo # "T_OK"                       //Execao esta na aheder do SZ6
  		           FieldPut(nPos,cVal)                                   // Grava Conteudo
                Endif
             Endif   
         Next
		 MsUnLock()

         SZ6->(DBSKIP())

	Enddo	 

Endif
      

RestArea(aArSZ6) 


DBSELECTAREA("TRB")
DbGotop()                        

//oMark:oBrowse:Refresh(.t.)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RfatBar   � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � EnchoiceBar especifica do MFatc04 atraves deste pego       ���
���          � todas as funcionalidades do ponto de entreda MA415BUT      ���
���          � utilizado pelo Orcamento.                                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oDlg: 	Objeto Dialog                                     ���
���          � bOk:  	Code Block para o Evento Ok                       ���
���          � bCancel: Code Block para o Evento Cancel                   ���
���          � nOpc:		nOpc transmitido pela mbrowse                 ���
���          � aForma: Array com as formas de pagamento                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RfatBar(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

aadd(aButtons,{"S4WB011N",{||U_MFATC03(TRB->Z6_PRODUTO)}, "<F4> - Consulta Estoque da Malha Logistica" })	

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


 /*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �MfatDisp  � Autor �                       � Data � 07/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �MfatDisp													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MfatDisp(cFABRI,lInverte,oMark)
Local nDecs 

If IsMark("T_OK",cFABRI,lInverte)
    //nDecs := MsDecimais(E1_MOEDA)
	//If Subs(E1_TIPO,3,1) == "-"
	//	nValTit   -= Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
    //    aTotais[E1_MOEDA][1] -= Round(E1_VALOR,nDecs)
	//Else
	//	nValTit  += Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
    //    aTotais[E1_MOEDA][1] += Round(E1_VALOR,nDecs)
    //	EndIf
    //	nQuant++
Else                              
    //nDecs := MsDecimais(E1_MOEDA)
	//If Substr(E1_TIPO,3,1) == "-"
	//	nValTit  += Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
    //    aTotais[E1_MOEDA][1] += Round(E1_VALOR,nDecs)
	//Else
	//	nValTit  -= Round(xMoeda(E1_VALOR,E1_MOEDA,nMoeda,E1_EMISSAO,nDecimais+1),nDecimais)
    //    aTotais[E1_MOEDA][1] -= Round(E1_VALOR,nDecs)
	//EndIf
	//nQuant--
	//nQuant:= Iif(nQuant<0,0,nQuant)
Endif
//oValTit:Refresh()
//oQuant:Refresh()
//oQual:Refresh()

oMark:oBrowse:Refresh(.t.)

Return




/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �GeraIndex � Autor �                       � Data � 07/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Index para o Trb do MarkBrowse               		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �GeraIndex     											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraIndex(cIndComb,cIndex,oMark)
Local cChave   := ""
Local nIndComb := aScan(aIndAll,{|x| AllTrim(x[1])==cIndComb })

If EmptY(cIndex)
   cIndex  := CriaTrab(nil,.f.) 
Endif
cChave  := aIndAll[nIndComb][2]

IndRegua("TRB",cIndex,cChave,,,"Selecionando Registros...")  
dbSelectArea("TRB")
#IFNDEF TOP
    dbSetIndex(cIndex+OrdBagExt())
#ENDIF  
dbSetOrder(1)
DbGoTop()

If ValType(oMark) # "U"
   oMark:oBrowse:Refresh()
Endif

Return



/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ProcPosic� Autor �                       � Data � 07/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Index para o Trb do MarkBrowse               		  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Multitek      											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ProcPosic(cProcurar)

DbSelectArea("TRB")
          
SET SOFTSEEK ON
DbSeek(cProcurar)
SET SOFTSEEK OFF      

Return