#INCLUDE "FIVEWIN.CH"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼FATC08   矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 砇otina de reajuste de Precos dos Contratos                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function MFATC08(cAlias,nReg,nOpcx)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//砎ariaveis de Tela - Utilizadas no Controle das Funcionalidades da Tela�
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local aArea			  := GetArea()
Local aSizeAut		  := MsAdvSize(,.F.)
Local nOpcA	    	  := 0
Local oDlg      
Local bSetKey5      
Local bSetKey4      
Local bSetKey12     
Local aObjects		  := {}
Local aInfo 		  := {}
Local aPosGet		  := {}
Local aPosObj		  := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//砎ariaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
Private dDtElabo      := SZ6->Z6_DTELABO
Private dDtValid      := SZ6->Z6_DTVALID
Private dDtAprov      := SZ6->Z6_DTAPROV
Private dDtEncer      := SZ6->Z6_DTENCER   
Private cCondpag      := SZ6->Z6_CONDPAG 
Private cVend1        := SZ6->Z6_VEND1
Private cTransp       := SZ6->Z6_TRANSP  
Private nFrete        := SZ6->Z6_X_FRETE  
Private oNum,oCliente,oNome,oLoja,oCondpag
Private oDtElabo,oDtValid,oDtAprov,oDtEncer
Private ogetdad,oFntFecha5
Private oVend1,oTransp,oFrete

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//砎ariaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private cProduto   := 0

Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab    := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab

Private CJ_X_ST_CI   := "CONSUMO"
Private a_X_ST_CI   := {"CONSUMO","INDUSTRIA"}
Private o_X_ST_CI        

Private nDolar1   := 0
Private nDolar2   := 0
Private oDolar1,oDolar2


Private oVrSReaj
Private oVrCReaj
Private nVrSReaj :=0
Private nVrCReaj :=0

PRIVATE nPerRea  := 0
PRIVATE nPrcRea  := 0
PRIVATE nQtdven  := 0
PRIVATE nPrcven  := 0

PRIVATE nMargE   := 0
PRIVATE nMargV   := 0
PRIVATE cMargA   := 0


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//砎ariaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}

Private aParam      := {}   
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//砎erifica se existem itens com Status diferente de Encerrado.           �
//矯aso todos os itens estejam incerrados retornar.                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
dbSelectArea("SZ6")
nRecno:=SZ6->(RECNO())
cNum:=SZ6->Z6_NUM 
lRet:=.T.
SZ6->(dbSetOrder(1))
SZ6->(DbGotop())
If SZ6->(DbSeek(xFilial("SZ6")+cNum))
	While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
	     	SZ6->Z6_NUM == cNum )
	        If !(SZ6->Z6_STATUS $ "N|E") 
	           lRet:=.F.
	        Endif
	        SZ6->(DbSkip())
	Enddo              
Endif	
DbGoto(nRecno)

if lRet
    Aviso('Atencao','Contrato nao pode ser Reajustado.'+CHR(13)+CHR(13)+;
                    'Todos os seus itens estao com Status'+CHR(13)+;
                    '(N) Em Negociacao ou'+CHR(13)+;
                    '(E) Encerrado.',{'Ok'})
   Return
Endif   
  

// 谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
// 矱fetua a montagem do aHeader e do aCols                       �
// 滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
// U_MMONTA(nOpcx) // Sera chamado pela funcao abaixo
U_FiltraF12(nOpcx,ogetdad,@aParam)
// Operacao Cancelada pelo Usuario
If Len(aParam)=0
   Return
Endif   


AAdd( aObjects, { 0,    055, .T., .F. } )
AAdd( aObjects, { 140,  110, .T., .T. } )
AAdd( aObjects, { 0,    015, .T., .F. } )
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,30,  65,90,120  ,140,155  ,255,280},;
                                                       {05,30,  65,90,  120,160,   205,230,   255,280},;
                                                       {05,30,  65,90,  140,160,   205,230,   255,280}})
                                                     
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Definicao de Fontes para esta janela �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][cProduto])})
bSetKey12:=SetKey(VK_F12,{|| U_FILTRAF12(nOpcx,ogetdad,@aParam)})

@ 20,aPosGet[1,1] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,2] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .f. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,3] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,4] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .f. Valid CheckSX3("Z6_CLIENTE",cCliente) Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,5] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .f. Valid CheckSX3("Z6_LOJA",cLoja) Of oDlg PIXEL

@ 20,aPosGet[1,6] 	SAY "Nome"  of oDlg PIXEL 	
@ 19,aPosGet[1,7] MSGET oNome Var cNome  When .F. Of oDlg PIXEL SIZE 120,9	

@ 20,aPosGet[1,8] 	SAY "Cond. Pgto" of oDlg PIXEL	     
@ 19,aPosGet[1,9] MSGET oCondPag Var cCondpag F3 CpoRetF3("Z6_CONDPAG")    Picture PesqPict("SZ6","Z6_CONDPAG") ;
	When .f. Valid CheckSX3("Z6_CONDPAG",cCondpag) Of oDlg PIXEL

                 
@ 37,aPosGet[2,1] SAY "Data de Elaboracao"  of oDlg PIXEL size 30,20		
@ 36,aPosGet[2,2] MSGET oDtElabo Var dDtElabo F3 CpoRetF3("Z6_DtElabo")    Picture PesqPict("SZ6","Z6_DtElabo");
	When .f. Valid CheckSX3("Z6_DtElabo",dDtElabo) Of oDlg PIXEL

@ 37,aPosGet[2,3] SAY "Data de Validade"  of oDlg PIXEL 	size 30,20
@ 36,aPosGet[2,4] MSGET oDtValid Var dDtValid F3 CpoRetF3("Z6_DtValid") Picture PesqPict("SZ6","Z6_DtValid");
	When .f. Valid CheckSX3("Z6_DtValid",dDtValid) Of oDlg PIXEL

@ 37,aPosGet[2,5] SAY "Industria/Consumo" of oDlg PIXEL  
@ 36,aPosGet[2,6] MSCOMBOBOX o_X_ST_CI VAR CJ_X_ST_CI ITEMS a_X_ST_CI  SIZE 60,50 OF oDlg PIXEL;
  When .f.
// ON CHANGE CheckCombo();

@ 37,aPosGet[2,07]	SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .f. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09]	SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .f. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL


@ 54,aPosGet[3,01] 	SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,02] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .f. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL


@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] 	SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

//@ 54,aPosGet[3,07]	SAY "Status Rentabil." of oDlg PIXEL	   size 30,20  
//@ 53,aPosGet[3,08] MSGET oSrentab Var cSrentab  When .F. Picture "@!"  Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .T. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .T. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL


ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,,,"+Z6_ITEM",.T.,aAltGr,,.T.,300)
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 

@ aPosObj[3,1],aPosGet[3,1] SAY "Total s/ Reajuste"  of oDlg PIXEL 	size 30,20
@ aPosObj[3,1],aPosGet[3,2] MSGET oVrSReaj Var nVrSReaj  Picture PesqPict("SZ6","Z6_PRCVEN");
	When .f. Of oDlg PIXEL

@ aPosObj[3,1],aPosGet[3,3] SAY "Total c/ Reajuste"  of oDlg PIXEL 	size 30,20
@ aPosObj[3,1],aPosGet[3,4] MSGET oVrCReaj Var nVrCReaj   Picture PesqPict("SZ6","Z6_PRCVEN");
	When .f. of oDlg PIXEL
                
//@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT EBarGer(oDlg,{|| nOpcA := 1,oDlg:End()},{||oDlg:End()})
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)

          
If ( nOpcA == 1 )

	Begin Transaction

	DbselectArea("SZ6")
	SZ6->(DbSetOrder(3))

	For nY := 1 to len(Acols)

	    if SZ6->(Dbseek(xFilial("SZ6")+cNum+cCliente+cLoja+aCols[nY][cProduto]))
		   RecLock("SZ6",.F.)

           SZ6->Z6_PRCVEN := aCols[nY][nPrcVen]
           SZ6->Z6_VALOR  := aCols[nY][nPrcVen] * aCols[nY][nQtdven] 

           SZ6->Z6_X_MARGE:= aCols[nY][nMARGE]
           SZ6->Z6_X_MARGV:= aCols[nY][nMARGV]
           SZ6->Z6_X_MARGA:= aCols[nY][cMARGA]

		   SZ6->(MsUnlock())
		Endif

    Next


	End Transaction
    
EndIf


RestArea(aArea)
            

Return(nOpcA)



/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    砇fatBar   � Autor �                       � Data � 13.10.03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � EnchoiceBar especifica do MFatc04 atraves deste pego       潮�
北�          � todas as funcionalidades do ponto de entreda MA415BUT      潮�
北�          � utilizado pelo Orcamento.                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� oDlg: 	Objeto Dialog                                     潮�
北�          � bOk:  	Code Block para o Evento Ok                       潮�
北�          � bCancel: Code Block para o Evento Cancel                   潮�
北�          � nOpc:		nOpc transmitido pela mbrowse                 潮�
北�          � aForma: Array com as formas de pagamento                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function EBarGer(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

aadd(aButtons, {"S4WB011N"      , {||U_MFATC03(aCols[n][cProduto])}, "<F4> - Consulta Estoque da Malha Logistica" })	
AADD(aButtons, {"SIMULACAO" 	, {||U_MFATC01()}	, "Simulador de Precos"})

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))
                    

                           


/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    砎REAJUSTE 矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 矲uncao incluida durante a montagem do aHeader no MMONTA      潮�
北�          硄ue se encontra no MFATC04.PRW                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function VREAJUSTE(nLin,lValid,lPrecoAlt)
Local _xQtdVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"}) // 08 Quantidade Contrato
Local _xPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"}) // 10 Preco ja Reajusto
Local _xValor  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})  // 11 Valor Total Reajustado
Local _xPrcRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCREA"}) // 12 Preco Anterior
Local _xPerRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PERREA"}) // 13 Percentual de Reajuste

Local _nPerRea := 0
Default lValid := .F.

_nPerRea := IIf(lValid .and. TYPE("Z6_PERREA")<>"U",M->Z6_PERREA,aCols[nLin][_xPERREA]) 




//1. [12] Guardo o Preco Anterior - Este processo ocorre quando a rotina e startada
//        nao pode ocorrer a todo momento pois o preco de venda esta sendo alterado.
//aCols[nLin][_xPrcRea] := aCols[nLin][_xPrcVen] 
//2. [10] Com base no Preco Anterior ja armazenado calculo o novo preco atual
if SUBSTR(aParam[02],01,01)="N"
   aCols[nLin][_xPrcVen] := aCols[nLin][_xPrcRea] +  NoRound( (aCols[nLin][_xPrcRea] * _nPerRea) /100 ,2)
Else
   aCols[nLin][_xPrcVen] := aCols[nLin][_xPrcRea] +    Round( (aCols[nLin][_xPrcRea] * _nPerRea) /100 ,2)
Endif

//3. [11] Com base no Novo preco e na quantidade calculo o valor total 
aCols[nLin][_xValor] := aCols[nLin][_xPrcVen] * aCols[nLin][_xQTDVEN]

//4. Define o Percentual correto de Rentababilidade e Valor.
CalcSim3(nLin,.F.,lPrecoAlt)


//5. Atualiza a media no Cabecalho
U_MediaRent(NIL,NIL,"C")
    
//6. Atualiza os valores no Rodape 
nVrSReaj := 0
nVrCReaj := 0
If Len(Acols) # 0
   For nY := 1 to len(Acols)
       nVrSReaj := nVrSReaj + (aCols[nY][_xQtdVen] * aCols[nY][_xPrcRea])
       nVrCReaj := nVrCReaj + (aCols[nY][_xQtdVen] * aCols[nY][_xPrcVen])
   Next    
Endif

if VALTYPE(ogetdad) # "U"
   oVrSReaj:Refresh()    
   oVrCReaj:Refresh()
   oPrentab:Refresh()
   oRrentab:Refresh()               
   //oSrentab:Refresh()
Endif

    
Return(.T.)
                   

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矲iltraF12 矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 砇otina responsavel pelo filtro dos itens para Reajuste.      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function FiltraF12(nOpcx,ogetdad,aParam)
Local nY        := 0        
Local lPrecoAlt := .T.
Local nLin      := 0
// aParam - Posicoes disponiveis
//[01] n_perce             % Linear
//[02] c_arred             Arredonda
//[03] a_arred
//[04] n_arred
//[05] c_simil  B1_X_SIMIL Simil
//[06] c_eis    Eis
//[07] a_eis
//[08] n_eis
//[09] c_fabr1  B1_FABRIC  Fabricante1
//[10] c_fabr2  B1_FABRIC  Fabricante2 
//[11] c_cdtr1  B1_ORIGEM  CDTR
//[12] c_cdtr2  B1_ORIGEM  CDTR
//[13] c_Opera             Arredonda
//[14] a_Opera
//[15] n_Opera

aParam:=FilReaj()
If Len(aParam)=0
   Return
Endif   

// Se for gerado % de Aumento ou % Desc nao podera ser alterado
// o preco simulado em funcao do mesmo ja estar calculado bastando
// calcular a nova rentabilidade. (lPrecoAlt = .T.)
// Mas caso seja alterada a rentabilidade sera necessario calcular
// o novo preco Simulado. (lPrecoAlt = .F.)
lPrecoAlt   := Iif(aParam[15] = 1 .or. aParam[15] = 2,.T.,.F.)


U_MMONTA(nOpcx,NIL,aParam)


cProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})

nPrcven := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
nPerRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PERREA"})
nPrcRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCREA"})
nQtdven := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})

nMargE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
nMargV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
cMargA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua o Calculo do Reajuste a ser aplicado                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
For  nLin:= 1 to Len(Acols)
     
     //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
     //� Statart da Tela neste momento e fornecido o % de reajuste e  |
     //� guardado o preco anterior ao reajuste.                       |
     //滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
     //_aReturn:={n_perce,c_arred,a_arred,n_arred,c_simil,c_eis,a_eis,n_eis,c_fabr1,c_fabr2,c_cdtr1,c_cdtr2,c_Opera,a_Opera,n_Opera}
     
     // Altero o % de Reajuste com +% ou -% (Acrescimo ou Desconto) ou
     // Altero a Margem do Produto.
     If lPrecoAlt                                      // Preco sera alterado
        aCols[nLin][nPerRea] := aParam[01]            // % de Aumento ou Desconto
     Else                                              // Preco sera alterado com base na Margem
        aCols[nLin][nMargE]  := aParam[01]            // % de Margem
     Endif

     // Guardo o Preco Anterior
     aCols[nLin][nPrcRea] := aCols[nLin][nPrcven]     // Preco Anterior
     
     U_VREAJUSTE(nLin,.F.,lPrecoAlt)

Next



Return 
             


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    | FilReaj  � Autor �                       � Data � 13.10.03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Parametros para Filtrar a MsGetDados  durante o processo   潮�
北�          � de Reajustes de Precos                                     潮�
北矷mportante� Toda a montagem desta tela se deu pelo fato    que o       潮�
北�          � cliente necessitava executar um combox com os Eis com      潮�
北�          � base no Simil tal operacao nao e suportada pelo SX1        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function FilReaj()
//n_perce,c_arred,a_arred,n_arred,c_simil,c_eis,a_eis,n_eis,c_fabr1,c_fabr2,c_cdtr1,c_cdtr2,nOpc)

Local  n_perce  := 0

Local  c_Opera  := "% Aumento"
Local  a_Opera  := {"% Aumento","% Desconto","% Rentabilidade"}
Local  n_Opera  := 1

Local  c_arred  := "SIM"
Local  a_arred  := {"SIM","NAO"}
Local  n_arred  := 1


Local  c_simil  := CriaVar("B1_X_SIMIL")

Local  c_eis    := Space(20)
Local  n_eis    := 1
Local  a_eis    := {}

Local  c_fabr1  := CriaVar("B1_FABRIC")
Local  c_fabr2  := "ZZZZZZZZZZZZZZZZZZZZ"

Local  c_cdtr1  := "0"                       //Do CDTR             ?
Local  c_cdtr2  := "2"                       //Ate CDTR            ?
Local  nOpc     := 0
Local  _aReturn := {}
Local  o_perce,o_Opera,o_arred,o_simil,o_eis,o_fabr1,o_fabr2,o_cdtr1,o_cdtr2
Local  oBold,oDlgReaj

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Definicao de Fontes para esta janela �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

DEFINE MSDIALOG oDlgReaj TITLE "Parametros para Fitrar" From 0,0 TO 400,350 OF oMainWnd PIXEL

@ 010, 016 	SAY "Oper.Desejada"  OF oDlgReaj FONT oBold PIXEL
@ 010, 085 	MSCOMBOBOX o_Opera VAR c_Opera ITEMS a_Opera SIZE 70, 80 OF oDlgReaj;
PIXEL ON CHANGE	(n_Opera := o_Opera:nAt)

@ 030, 016 	SAY "% Linear " OF oDlgReaj FONT oBold PIXEL
@ 030, 085 	MSGET o_perce VAR n_perce PICTURE "@E 999.99" SIZE 070, 10 OF oDlgReaj;
VALID Vperce(n_Opera,n_perce) PIXEL

@ 050, 016 	SAY "Arredonda"       OF oDlgReaj FONT oBold PIXEL
@ 050, 085 	MSCOMBOBOX o_arred VAR c_arred ITEMS a_arred SIZE 70, 80 OF oDlgReaj;
PIXEL ON CHANGE	(n_arred := o_arred:nAt)

@ 070, 016 	SAY "Simil" OF oDlgReaj FONT oBold PIXEL
@ 070, 085 	MSGET o_Simil VAR c_Simil   F3 "SZ2" SIZE 070, 10 OF oDlgReaj;
PIXEL VALID (U_VLDSIMIL(c_simil,@a_eis,o_eis,@n_eis,@c_eis))

@ 090, 016 	SAY "Eis" OF oDlgReaj FONT oBold PIXEL
@ 090, 085 	MSCOMBOBOX o_eis VAR c_eis ITEMS a_eis SIZE 70, 80 OF oDlgReaj;
PIXEL ON CHANGE	(n_eis := o_eis:nAt)

@ 110, 016 	SAY "Marca " OF oDlgReaj FONT oBold PIXEL
@ 110, 085 	MSGET o_fabr1 VAR c_fabr1 SIZE 070, 10 OF oDlgReaj;
PIXEL

@ 130, 016 	SAY "Da Origem (CDTR) " OF oDlgReaj FONT oBold PIXEL
@ 130, 085 	MSGET o_cdtr1 VAR c_cdtr1 SIZE 070, 10 OF oDlgReaj;
PIXEL VALID VALORIG(c_cdtr1,c_cdtr2)

@ 150, 016 	SAY "Ate a Origem (CDTR) " OF oDlgReaj FONT oBold PIXEL
@ 150, 085 	MSGET o_cdtr2 VAR c_cdtr2 SIZE 070, 10 OF oDlgReaj;
PIXEL VALID VALORIG(c_cdtr1,c_cdtr2)

@ 175, 040	BUTTON "Confirma" SIZE 40,14 OF oDlgReaj;
PIXEL ACTION (nOpc:=1,oDlgReaj:End())

@ 175, 090	BUTTON "Cancelar" SIZE 40,14 OF oDlgReaj;
PIXEL ACTION (nOpc:=0,oDlgReaj:End())

ACTIVATE MSDIALOG oDlgReaj CENTER

If nOpc = 1
   _aReturn:={n_perce,c_arred,a_arred,n_arred,c_simil,c_eis,a_eis,n_eis,c_fabr1,c_fabr2,c_cdtr1,c_cdtr2,c_Opera,a_Opera,n_Opera}
Else
   _aReturn:={}
Endif 

Return(_aReturn)


/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    | VLDSIMIL � Autor �                       � Data � 13.10.03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Monta uma matriz com todos os Eis com base no Simil        潮�
北�          � Esta sendo utilizada tambem pelo Movigrama                 潮�
北�          � C U I D A D O ao alterar.                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nenhum                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/              
User Function VLDSIMIL(c_Simil,a_Eis,o_Eis,n_Eis,c_Eis)
Local lRet := .T.
Local nPos := 0
Local _area:= GetArea()

o_Eis:Disable()    // Desebilita

If "#MFATC04" $ Upper(Funname())
   If Empty(c_Simil)
      n_Eis := 1
      c_Eis := ""
      a_Eis := {}
      RestArea(_area)
      Return lRet
   Endif 
Endif   

DbSelectArea("SZ2")
SZ2->(DbSetorder(1))
If !SZ2->(Dbseek(xFilial("SZ2")+c_Simil))
	Aviso("ATENCAO", "Similaridade nao Cadastrada no Grupo de Similaridade",{"&Ok"})
	lRet := .f.
Else
	a_Eis := {}
	DbSelectArea("SB1")
	SB1->(DbGoTop())
	SB1->(DbOrderNickname("B1SIMIL"))             //B1_X_SIMIL + EIS
	If  SB1->(Dbseek(xFilial("SB1") + c_Simil ))
		While  !SB1->(Eof())  .and. c_Simil = SB1->B1_X_SIMIL
			
			nPos := Ascan(a_Eis ,SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10))
			If  nPos == 0 .and. !Empty(c_Simil)
				AADD(a_Eis,SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10))
			Endif
			
			
			SB1->(DBSKIP())
		Enddo
	Endif
Endif

n_Eis := 1
c_Eis := Iif(Len(a_Eis)!=0,a_Eis[n_Eis],space(20))
o_Eis:SetItems(a_Eis)
o_Eis:Refresh()
             
o_Eis:Enable()     // Abilita

o_Eis:Refresh()

RestArea(_area)

Return(lRet)



Static Function VALORIG(c_cdtr1,c_cdtr2)
Local lRet:=.T.

If !(alltrim(c_cdtr1) $ "0,1,2") 
   Aviso("ATENCAO", "Somente sao validas as Origens 0,1,2..",{"&Ok"})
   lRet:=.f.
Else
   If !(alltrim(c_cdtr2) $ "0,1,2") 
      Aviso("ATENCAO", "Somente sao validas as Origens 0,1,2..",{"&Ok"})
      lRet:=.f.
   Endif
Endif   
 
If val(c_cdtr1) > val(c_cdtr2) 
   Aviso("ATENCAO", "A origem Inicial (CDTR) deve ser sempre maior que a origem Final (CDTR).",{"&Ok"})
Endif

Return(lRet)
      

 
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矯alcSim3  篈utor  �                    � Data �  13/10/03   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     矱fetua todos os calculos necessarios para determinar:       罕�
北�          砤) Novo Preco do Produto                                    罕�
北�          砨) Determina a Rentabilidade do Item                        罕�
北�          砪) Calcula o Preco Total                                    罕�
北�          砪) Informa a Rentabilidade Media em % e $                   罕�
北�          砅reco do Produto                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       矼ultitek                                                    罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CalcSim3(nLin,lValid,lPrecoAlt)

Local cAreaAtu    := GetArea()

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� O conteudo das variaveis abaixo tem como origem o acols.               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local _nQtdven    := 0
Local _nPreunit   := 0
Local _nPrcven    := 0
Local _nValor     := 0
Local _nMargV     := 0
Local _nMargA     := 0
Local _nMargE     := 0
Local _nDescont   := 0
Local _nIpi       := 0
Local _nIcm       := 0
Local _nPis       := 0
Local _nCofins    := 0
Local _nCpmf      := 0
Local _nCtStd     := 0




//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Variaveis necessarias para execucao dos Calculos pela Funcao ExecCalc  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local _X_Custo    := 0
Local _X_Margem   := 0
Local _X_Ipi      := 0
Local _X_Comissao := 0
Local _X_Pis      := 0
Local _X_Cofins   := 0
Local _X_Cpmf     := 0
Local _X_Icms     := 0
Local _X_Frete    := 0
Local _X_TxFinan  := 0
Local _X_PrazoVe  := 0
Local _X_DescLin  := 0
Local _x_DescAll  := 0
Local nY          := 0
Local _uString               // Retorna o numero de dias para a cond.de Pagto

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Posicao do acols do Contrato apos executado o filtro doos itens a serem�
//� reajustados.                                                           �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Local nZItem     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_ITEM"})
Local nZProduto  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
Local nZQtdven   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
Local nZPrcven   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
Local nZTes      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_TES"})
Local nZClasfis  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CLASFIS"})
Local nZLocal    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCAL"})
Local nZLocNome  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCNOME"})
Local nZCtStd    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CTSTD"})
Local nZPrunit   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
Local nZValor    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
Local nZUm       := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_UM"})
Local nZRefer    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_REFER"})
Local nZSufix    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_SUFIX"})
Local nZFABRI    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARCA"})
Local nZMargE    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
Local nZMargV    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
Local nZMargA    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	
Local nZPis      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_PIS"})
Local nZCofins   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_COFIN"})
Local nZCpmf     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CPMF"})
Local nZICM      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_ICM"})
Local nZIPI	     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_IPI"})
	
Local nZProdCli  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODCLI"})


Private lCancelar := .F.
Private _n_Mv_Jurmes := GetMV("MV_JURMES")          //  Juros no Mes   (Especifico)
Private _n_Mv_Comical:= GetMV("MV_COMICAL")

DEFAULT lValid    := .F.
                                                         

//Estou considerando apenas no momento do calculo mostrar em tela
//pois um item pode ser deletado e neste momento esta rotina deve ser
//chamada
if aCols[nLin][Len(aHeader)+1]  // Item deletado do Acols no Simulador
	Return                         // Nao e necessario calcular
Endif

_nQtdven  := aCols[nLin][nZQtdven] 
_nCtStd   := aCols[nLin][nZCtStd] 
_nPrcven  := aCols[nLin][nZPrcven] 
_nValor   := aCols[nLin][nZValor]
_nMarge   := aCols[nLin][nZMargE]
_nMargV   := aCols[nLin][nZMargV]
_nMargA   := aCols[nLin][nZMargA]
_nDescont := 0
_nIpi     := aCols[nLin][nZIpi]
_nIcm     := aCols[nLin][nZIcm]
_nPis     := aCols[nLin][nZPis]
_nCofins  := aCols[nLin][nZCofins]
_nCpmf    := aCols[nLin][nZCpmf]




DbSelectArea("SB1")
SB1->(DbSetOrder(1))
If !SB1->(DbSeek(xFilial("SB1")+aCols[nLin][nZProduto]))
	Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo :"+aCols[nLin][nZProduto]+;
	" nao Cadastrado.",{"&Ok"})
	Return(.f.)
Endif


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矯usto do Produto                                                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//_X_Custo  := U_AjudCalc("CUSTO",SB1->B1_COD,0,"",@lCancelar,.T.)
_X_Custo    := _nCtStd
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矼argem do Produto                                                       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
_X_Margem   := U_AjudCalc("MARGEM",SB1->B1_COD,_nMarge,"",@lCancelar,.T.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矯omissao do Item                                                        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
_X_Comissao := U_AjudCalc("COMISSAO",SB1->B1_COD,0,"",@lCancelar,.T.)
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矯ondicoes de Pagamento                                                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
_uString    := U_AjudCalc("PGTO",SB1->B1_COD,0,cCondpag,@lCancelar,.T.)


If lCancelar
	Return({})
Endif


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//�                         Inicio dos Calculos                            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//�	Rotina 2		Simula玢o de pre鏾s dos produtos atrav閟 de alteracoes |
//|                 de dados pr�-definidos (margem de contribui玢o,        |
//|                 comiss鉶 de vendas, fretes, prazo)				   	   |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
_X_Margem     :=  _nMarge  // Margem digitada.
_X_Ipi        :=  _nIpi
_X_Pis        :=  _nPis
_X_Cofins     :=  _nCofins
_X_Cpmf       :=  _nCpmf
_X_Icms       :=  _nIcm
_X_Frete      :=  nFrete
_X_TxFinan    :=  _n_Mv_Jurmes
_X_PrazoVe    :=  _uString
_X_DescLin    :=  _nDescont
_x_DescAll    :=  0


//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//砎erifica se a alteracao partiu do preco de venda, caso, �
//砤firmativo executa o calculo de novo maneira            �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
//lPrecoAlt :=.T.	

	
aPrVenda := {}
aPrVenda := U_ExecCalc(_X_Custo ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,lPrecoAlt,_nPrcven,nLin,CJ_X_ST_CI)
                                                          

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Resultado da Rotina 3 - Efetua Atualizacoes de Tela                    �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
// 1) Atualiza a Rentabilidade em termos de Valor($)
aCols[nLin][nZMargV]  := aPrVenda[03,03]
// 2) Atualiza o Preco de Venda do Produto(Preco SImulado)
aCols[nLin][nZPrcven] := aPrVenda[02,03]
// 3) Atualiza o Preco Total
aCols[nLin][nZValor]  := aCols[nLin][nZPrcven] * _nQtdven


If lPrecoAlt  // .t. preco foi alterado 
	
    // 4) Atualiza a Rentabilidade em termos de Percentuais(%)
    aCols[nLin][nZMargE]  := aPrVenda[04,03]

	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矱ste parametro permite que o calculo apos efetuado pela rotina  4   �
	//硆otina que trata desconto seja refeito pela Rotina 1                �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	
	If GETMV("MV_TIPCAL")
		
		U_CalcSim(nLin,.F.)   // Chamo novamente para ajustar corretamente com base na Rotina 1
		
	Endif
	
Endif

aCols[nLin][nZMargA]  :=  U_AvalMarg(aCols[nLin][nZMargE])

RestArea(cAreaAtu)

Return(.T.)



Static Function Vperce(n_Opera,n_perce)
Local lRet := .T.

// Esta sendo validado somente a operacao numero 2 relativo a desconto
If n_opera = 2 .and. n_perce > 0
   Aviso("ATENCAO","O % Informado deve ser negativo pois sera efetuado um desconto para todos os itens" ,{"&Ok"})
   lRet := .f.
Endif

// Esta sendo validado somente a operacao numero 2 relativo a desconto
If n_opera = 1 .and. n_perce < 0
   Aviso("ATENCAO","O % Informado deve ser positivo pois sera efetuado um Acrescimo do valor" ,{"&Ok"})
   lRet := .f.
Endif

// Esta sendo validado somente a operacao numero 2 relativo a desconto
If n_opera = 3 .and. n_perce < 0
   Aviso("ATENCAO","O % Informado para margem deve positivo" ,{"&Ok"})
   lRet := .f.
Endif

Return(lRet)
