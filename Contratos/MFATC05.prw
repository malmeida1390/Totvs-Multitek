#INCLUDE "FIVEWIN.CH"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MFATC05   ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Geracao de Pedido do Contrato                      ³±±
±±³          ³Esta rotina esta sendo chamada pelo mBrowse do MFATC04       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MFATC05(cAlias,nReg,nOpcx)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Tela - Utilizadas no Controle das Funcionalidades da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Local nRecno          := 0
Local lRet            := .f.
Local cDoc   := ""

Local aBackRot    := aClone(aRotina)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
//ALTERADO NASSER 03/07/07
Private cGrpVen       := POSICIONE("SA1",6,xFilial("SA1")+SA1->A1_GRPVEN,"A1_GRPVEN")
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

Private aCliente := {}

Private CJ_X_ST_CI   := "CONSUMO"
Private a_X_ST_CI   := {"CONSUMO","INDUSTRIA"}
Private o_X_ST_CI        

Private nDolar1   := 0
Private nDolar2   := 0
Private cPedCli       := SZ6->Z6_COTCLI
Private cContCli      := SZ6->Z6_CONTCLI

Private oPedCli,oContCli
Private oDolar1,oDolar2


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private _xProduto   := 0    // Alimentada pelo mmonta() no mfatc04.prw

Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab    := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Muda o valor do aRotina para nao incluir linha na GetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aRotina)<3
	aRotina[3,4] := 6
Else
	PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem itens com Status diferente de Encerrado.           ³
//³Caso todos os itens estejam incerrados retornar.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
nRecno:=SZ6->(RECNO())
cNum:=SZ6->Z6_NUM 
lRet:=.T.
dbSetOrder(1)
DbGotop()
DbSeek(xFilial("SZ6")+cNum)
While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
     	SZ6->Z6_NUM == cNum )
        If SZ6->Z6_STATUS # "E" 
           lRet:=.f.
        Endif
        SZ6->(DbSkip())
Enddo              
DbGoto(nRecno)

if lRet
    Aviso('Atencao','Contrato Encerrado.'+CHR(13)+CHR(13)+;
                    'Todos os itens deste contrato estao com Status Encerrado.',{'Ok'})
    aRotina := aClone(aBackRot)         
    Return
Endif   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)


DbSelectArea("SA1")
Dbseek(xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA)

cNum          := SZ6->Z6_NUM
cCliente      := SZ6->Z6_CLIENTE
cLoja         := SZ6->Z6_LOJA
//ALTERADO NASSER 03/07/07
cGrpVen       := SA1->A1_GRPVEN
cNome         := SA1->A1_NREDUZ
cCondpag      := SZ6->Z6_CONDPAG

dDtElabo      := SZ6->Z6_DTELABO
dDtValid      := SZ6->Z6_DTVALID
dDtAprov      := SZ6->Z6_DTAPROV
dDtEncer      := SZ6->Z6_DTENCER
cTransp       := SZ6->Z6_TRANSP
nFrete        := SZ6->Z6_X_FRETE
cVend1        := SZ6->Z6_VEND1
CJ_X_ST_CI    := IIf (SZ6->Z6_X_ST_CI = "I","Industria","Consumo")

nQtdEnv       :=  aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"}) 
_xProduto     :=  aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})


AAdd( aObjects, { 0,    070, .T., .F. } )
AAdd( aObjects, { 160,  110, .T., .T. } )
AAdd( aObjects, { 0,    008, .T., .F. } )
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,30,  65,90,120  ,140,155  ,255,275},;
                                                     {05,30,  65,90,  120,160,   200,225,   255,275},;
                                                     {05,30,  65,90,  140,160,   200,225,   255,275},;
                                                     {05,30,  65,90,  140,160,   200,225,   255,275}})

nOpcx := 3
                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03( IIF(LEN(aCols)=0,"",aCols[n][_xProduto]) )})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,1] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,2] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .f. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,3] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,4] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .f. Valid CheckSX3("Z6_CLIENTE",cCliente).AND. ValNome() Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,5] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .f. Valid CheckSX3("Z6_LOJA",cLoja).AND. ValNome() Of oDlg PIXEL


@ 20,aPosGet[1,6] 	SAY "Nome"  of oDlg PIXEL 	
@ 19,aPosGet[1,7] MSGET oNome Var cNome  When .F. Of oDlg PIXEL SIZE 120,9	

@ 20,aPosGet[1,8] 	SAY "Cond. Pgto" of oDlg PIXEL	     
@ 19,aPosGet[1,9] MSGET oCondPag Var cCondpag F3 CpoRetF3("Z6_CONDPAG")    Picture PesqPict("SZ6","Z6_CONDPAG");
	When .T. Valid CheckSX3("Z6_CONDPAG",cCondpag) Of oDlg PIXEL

                 
@ 37,aPosGet[2,1] SAY "Data de Elaboracao"  of oDlg PIXEL size 30,20		
@ 36,aPosGet[2,2] MSGET oDtElabo Var dDtElabo F3 CpoRetF3("Z6_DtElabo")    Picture PesqPict("SZ6","Z6_DtElabo");
	When .f. Valid CheckSX3("Z6_DtElabo",dDtElabo) Of oDlg PIXEL

@ 37,aPosGet[2,3] SAY "Data de Validade"  of oDlg PIXEL 	size 30,20
@ 36,aPosGet[2,4] MSGET oDtValid Var dDtValid F3 CpoRetF3("Z6_DtValid") Picture PesqPict("SZ6","Z6_DtValid");
	When .f. Valid CheckSX3("Z6_DtValid",dDtValid) Of oDlg PIXEL

@ 37,aPosGet[2,5] SAY "Industria/Consumo" of oDlg PIXEL  
@ 36,aPosGet[2,6] MSCOMBOBOX o_X_ST_CI VAR CJ_X_ST_CI ITEMS a_X_ST_CI  SIZE 60,50 OF oDlg PIXEL;
  When .f.

@ 37,aPosGet[2,07] SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .T. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09] SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .T. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL

@ 54,aPosGet[3,1]  SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,2]  MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .f. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL

@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07] SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .f. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09] SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .f. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL

@ 71,aPosGet[4,01] SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .f.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .f.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 


ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_VQtdEnv()","U_VQtdEnv()","+Z6_ITEM",.T.,aAltGr,1)
ogetdad:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],ogetdad:LinhaOk(),ogetdad:oBrowse:Refresh(.T.)}
ogetdad:oBrowse:lDisablePaint := .F. 
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 

 
@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT EBarGer(oDlg,{|| nOpcA := 1, IIf(U_ValCabec() .and. U_ValCliente(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)


If ( nOpcA == 1 )

	Begin Transaction


    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Geracao do Pedido atraves da Rotina SigaAuto³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


    cDoc := GetSxeNum("SC5","C5_NUM")

    MsAguarde({|| lRet:=U_MyMta410(aCols,aCliente[1][1],aCliente[1][2],cCondpag,cDoc) },"Geracao do Pedido Numero "+cDoc)

    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Apos Gerado Atualiza Status do SZ6          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If  lRet
  
    	DbselectArea("SZ6")
    	DbSetOrder(3)
    	
    	For nY := 1 to len(Acols)

	       if Dbseek(xFilial("SZ6")+cNum+cCliente+cLoja+aCols[nY][_xProduto])
		      RecLock("SZ6",.F.)
              SZ6->Z6_QTDFIM := SZ6->Z6_QTDFIM + aCols[nY][nQtdEnv]
		      If SZ6->Z6_QTDFIM >= SZ6->Z6_QTDVEN
                 SZ6->Z6_STATUS := "F"
              Else
                 SZ6->Z6_STATUS := "D"
		      Endif
		      MsUnlock()
		   Endif

        Next  

    Endif
    
	End Transaction
    
EndIf            
aRotina := aClone(aBackRot)         

MsUnLockAll()

RestArea(aArea)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MyMta410  ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao do Pedido via SigaAuto                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MyMta410(aCols,cCliente,cLoja,cCondpag,cDoc)
 
Local aCabec   := {}
Local aItens   := {}
Local aLinha   := {}
Local nX       := 0
Local nY       := 0
Local lOk      := .T.
Local lRet     := .T.
Local _xItem   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_ITEM"}) // Preco sem Reajuste
Local _xPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"}) // Preco sem Reajuste
Local _xPerRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PERREA"}) // Percentual de Reajuste
Local _xValor  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})  // Valor Total Reajustado
Local _xQtdEnv := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"}) // Quantidade Contrato
Local _xQtdFIM := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDFIM"}) // Quantidade Final
Local _xProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SKU"})  // Produto
Local _xTes    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_TES"})    // Tes 
Local _xLocal  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_LOCAL"})  // Local 
Local _xUm     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_UM"})     // Unidade
Local _xMargE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"}) // % Marge
Local _xMargV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"}) // $ Marge
Local _xMargA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"}) // Avaliacao

Local _xRefer  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_REFER"}) // Referencia
Local _xSUFIX  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_SUFIX"}) // Sufixo 
Local _xMarca  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_S_MARCA"}) // Marca     
Local _xClasFis:= aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CLASFIS"}) // Classificacao Fiscal

Local lLibera  := .F.               

Private lMsErroAuto := .F.
Private oGetDad     := Nil  // Esta variavel deve ser Nil caso contrario causara
		                    // Erro na Execucao do SigaAuto
		
DbSelectArea("SE4")
DbSetOrder(1)
if !Dbseek(xFilial("SE4")+cCondpag)
    Aviso('Atencao','Cancelada Geracao do Pedido.'+CHR(13)+CHR(13)+;
                    'Cond.de Pgto '+cCondpag+' nao Cadastrado.',{'Ok'})
    lRet:=.f.
Endif


DbSelectArea("SA1")
DbSetOrder(1)
if !Dbseek(xFilial("SA1")+cCliente+cLoja)
    Aviso('Atencao','Cancelada Geracao do Pedido.'+CHR(13)+CHR(13)+;
                    'Cliente '+cCliente+cLoja+' nao Cadastrado.',{'Ok'})
    lRet:=.f.
Endif


       
aVend:=U_Comissao() // Nao e necessario passar o numero do orcamento neste caso ira se 
                     // basear no cliente em que estiver posicionado.






        
if  lRet


	
	aadd(aCabec,{"C5_FILIAL" ,xFilial("SC5"),Nil})
	aadd(aCabec,{"C5_NUM"    ,cDoc    ,Nil})
	aadd(aCabec,{"C5_TIPO"   ,"N"     ,Nil})
	aadd(aCabec,{"C5_CLIENTE",cCliente,Nil})
	aadd(aCabec,{"C5_LOJACLI",cLoja   ,Nil})
	aadd(aCabec,{"C5_CLIENT" ,cCliente,Nil})
	aadd(aCabec,{"C5_LOJAENT",cLoja   ,Nil})
	aadd(aCabec,{"C5_TIPOCLI","F"     ,Nil})
	aadd(aCabec,{"C5_CONDPAG",cCondpag,Nil})
	
	aadd(aCabec,{"C5_X_ST_CI",Substr(CJ_X_ST_CI,1,1),Nil}) // Campos Obrigatorios  ???
	aadd(aCabec,{"C5_X_ORIGM","C"     ,Nil})
	aadd(aCabec,{"C5_TRANSP" ,cTransp ,Nil})
	aadd(aCabec,{"C5_LIBEROK" ,"S"         ,Nil}) // Campos Obrigatorios
	
   /* Somente nos Itens pois a comissao e por item
	aadd(aCabec,{"C5_VEND1" ,aVend[1][1]  ,Nil}) // Campos Obrigatorios
	aadd(aCabec,{"C5_VEND2" ,aVend[2][1]  ,Nil}) // Campos Obrigatorios
	aadd(aCabec,{"C5_VEND3" ,aVend[3][1]  ,Nil}) // Campos Obrigatorios
	aadd(aCabec,{"C5_VEND4" ,aVend[4][1]  ,Nil}) // Campos Obrigatorios
	aadd(aCabec,{"C5_VEND5" ,aVend[5][1]  ,Nil}) // Campos Obrigatorios
   */
	
	For nX := 1 To Len(Acols)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If !Dbseek(xFilial("SB1")+aCols[nX][_xProduto])
			Aviso('Atencao','Cancelada Geracao do Pedido.'+CHR(13)+CHR(13)+;
			'Produto '+aCols[nX][_xProduto]+' nao Cadastrado.',{'Ok'})
			lRet:=.f.
		Endif
		
		DbSelectArea("SF4")
		DbSetOrder(1)
		If !Dbseek(xFilial("SF4")+aCols[1][_xTes])
			Aviso('Atencao','Cancelada Geracao do Pedido.'+CHR(13)+CHR(13)+;
			'Tes '+aCols[1][_xTes]+' nao Cadastrado.',{'Ok'})
			lRet:=.f.
		Endif
		
		aLinha := {}
		
		lLibera:=If(SUBSTR(aCols[nX][_xMargA],1,1)="L",.T.,.F.)
		
		aadd(aLinha,{"C6_FILIAL" ,xFilial("SC6")      ,Nil})
		aadd(aLinha,{"C6_ITEM"   ,aCols[nX][_xItem]   ,Nil})
		aadd(aLinha,{"C6_PRODUTO",aCols[nX][_xProduto],Nil})
		aadd(aLinha,{"C6_UM"     ,aCols[nX][_xUm]     ,Nil})
		aadd(aLinha,{"C6_QTDVEN" ,aCols[nX][_xQtdEnv] ,Nil})
		aadd(aLinha,{"C6_PRCVEN" ,aCols[nX][_xPrcVen] ,Nil})
		aadd(aLinha,{"C6_PRUNIT" ,aCols[nX][_xPrcVen] ,Nil})
		aadd(aLinha,{"C6_VALOR"  ,aCols[nX][_xQtdEnv] * aCols[nX][_xPrcVen] , Nil})
		aadd(aLinha,{"C6_TES"    ,aCols[nX][_xTes]    ,Nil})
		aadd(aLinha,{"C6_CLASFIS",aCols[nX][_xClasFis],Nil})
		aadd(aLinha,{"C6_LOCAL"  ,aCols[nX][_xLOCAL]  ,Nil})            //SB1->B1_LOCPAD       ,Nil})
		aadd(aLinha,{"C6_ENTREG" ,dDataBase            ,Nil})
		aadd(aLinha,{"C6_BLQ"    ,"N"                  ,Nil})
		aadd(aLinha,{"C6_OP"     ,""                   ,Nil})
		
		//Posibilita Gerar Um Pedido Ja Liberado para estoque
		//Dependendo de Estar Liberado tambem por rentabilidade.
		aadd(aLinha,{"C6_QTDLIB" ,If(lLibera,aCols[nX][_xQtdEnv],0) ,Nil})
		
		aadd(aLinha,{"C6_X_REFER",aCols[nX][_xRefer]  ,Nil})
		aadd(aLinha,{"C6_X_SUFIX",aCols[nX][_xSUFIX]  ,Nil})
		aadd(aLinha,{"C6_X_MARCA",aCols[nX][_xMarca]  ,Nil})
		aadd(aLinha,{"C6_X_MARGE",aCols[nX][_xMargE]  ,Nil})
		aadd(aLinha,{"C6_X_MARGA",SUBSTR(aCols[nX][_xMargA],1,1)  ,Nil})
		aadd(aLinha,{"C6_X_MARGV",aCols[nX][_xMargV]  ,Nil})
		aadd(aLinha,{"C6_X_ORIGM","C"                  ,Nil})
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analiza se o item tera direito a comissao em funcao  ³
		//³da rentabilidade obtida com base na Arvore de Encam. ³
		//³caso contrario continuara ZERADA a comissao.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      /* Aqui nao consegui gravar as comissoes pois nao estao no acols.
      /  por este motivo esta sendo passada para apos a geracao do pedido.
		if U_AnaliRet(aCols[nX][_xProduto],aCols[nX][_xMargE])
			
			aadd(aLinha,{"C6_COMIS1",aVend[1][2]       ,Nil})
			aadd(aLinha,{"C6_COMIS2",aVend[2][2]       ,Nil})
			aadd(aLinha,{"C6_COMIS3",aVend[3][2]       ,Nil})
			aadd(aLinha,{"C6_COMIS4",aVend[4][2]       ,Nil})
			aadd(aLinha,{"C6_COMIS5",aVend[5][2]       ,Nil})
			
		Endif
		*/
		
		aadd(aItens,aLinha)
		
	Next nX
	
Endif

If lRet

    DbSelectArea("SA1")   // Para o sigaautofuncionar deve estar posicionado ao Entrar
                          // O Armazem Local deve estar cadastrado tambem no Produto 01


	MSExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,3)
	
	If lMsErroAuto
		MOSTRAERRO() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
		Aviso('Atencao','Cancelada Geracao do Pedido.',{'Ok'})
		lRet:=.f.
	EndIf

Endif

if lRet
	
	ConfirmSx8()
	
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	if Dbseek(xFilial("SC6")+cDoc)
		
		
		while !SC6->(EOF()) .and. SC6->C6_NUM = cDoc
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Analiza se o item tera direito a comissao em funcao  ³
			//³da rentabilidade obtida com base na Arvore de Encam. ³
			//³caso contrario continuara ZERADA a comissao.         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if U_AnaliRet(SC6->C6_PRODUTO,SC6->C6_X_MARGE)
				Reclock("SC6",.F.)
				SC6->C6_COMIS1 := aVend[1][2]
				SC6->C6_COMIS2 := aVend[2][2]
				SC6->C6_COMIS3 := aVend[3][2]
				SC6->C6_COMIS4 := aVend[4][2]
				SC6->C6_COMIS5 := aVend[5][2]
				MsUnlock()
			Endif
			
			SC6->(DbSkip())
		Enddo
	Endif
	
	
Else
	RollBAckSx8()
Endif


Return ( lRet )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do MFatc04 atraves deste pego       ³±±
±±³          ³ todas as funcionalidades do ponto de entreda MA415BUT      ³±±
±±³          ³ utilizado pelo Orcamento.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlg: 	Objeto Dialog                                     ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EBarGer(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

AADD(aButtons, {"S4WB011N"      , {||U_MFATC03(IIF(LEN(aCols)=0,"",aCols[n][_xProduto]))}, "<F4> - Consulta Estoque da Malha Logistica" })	
AADD(aButtons, {"CARGA"      	, {||U_MFATC06()}	, "Busca Itens do Contrato"})
AADD(aButtons, {"PRODUTO"    	, {||U_MFATC02()}	, "Substitui Item do Contrato"})
AADD(aButtons, {"VENDEDOR"    	, {||U_MFATC07(cCliente,cGrpVen)}	, "Seleciona Clientes p/ Geracao do Pedido"})
//ALTERADO NASSER 03/07/07
//AADD(aButtons, {"VENDEDOR"    	, {||U_MFATC07(cCliente)}	, "Seleciona Clientes p/ Geracao do Pedido"})

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))
                    

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValCliente³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Valida Cliente para geracao do Pedido                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValCliente()
Local lRet:= .T.

If Len(aCliente) = 0 
    Aviso('Atencao','Favor informar Cliente Destino.'+CHR(13)+CHR(13)+;
                    'Deve ser selecionado o Cliente para '+chr(13)+;
                    'Geracao do Pedido',{'Ok'})
    lRet:=.f.
Endif

Return lRet          



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³VQtdEnv   ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao incluida durante a montagem do aHeader no MMONTA      ³±±
±±³          ³que se encontra no MFATC04.PRW                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VQtdEnv(lValid)
Local _xPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"}) // Preco sem Reajuste
Local _xValor  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})  // Valor Total Reajustado
Local _xQtdEnv := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDENV"}) // Quantidade a VENiar
Local lRet     := .T.
Local uQtdMax  
Local _nQtdEnv := 0
                    
DEFAULT lValid := .F.

_nQtdEnv := IIf(lValid .and. TYPE("M->Z6_QTDENV")<>"U",M->Z6_QTDENV,aCols[n][_xQtdEnv]) 
_nPRCVEN := IIf(lValid .and. TYPE("M->Z6_PRCVEN")<>"U",M->Z6_PRCVEN,aCols[n][_xPRCVEN]) 

aCols[n][_xValor] := _nPRCVEN * _nQtdEnv
                                  
//1. Calcula nova Rentabilidade durante a substituicao
//   do item de contrato
U_CalcSim2(n,lValid,.T.,"U_MFATC05")

//2. Atualiza a media no Cabecalho
U_MediaRent(NIL,NIL,"C")

Return(lRet)
                   





