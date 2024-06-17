#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MFATC04   ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Manutencao dos Contratos de Venda                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MFATC04()

Local bBlock
Local cFiltraSZ6
Local aIndexSZ6	:= {}
Local nPos		:= 0
Local nX		:= 0
Local nRegSZ6	:= 0
Local lContinua := .T.



Local aCores := {{'SZ6->Z6_STATUS = "N"'      , 'BR_VERDE'    },;	// (N) Em Negociacao           (Verde)
					  {'SZ6->Z6_STATUS = "A"'      , 'BR_AMARELO'  },;	// (A) Aprovado Nao Atendido   (Amarelo) 
					  {'SZ6->Z6_STATUS = "D"'      , 'BR_AZUL'     },;	// (D) Aprovado em Atendimento (Azul)
					  {'SZ6->Z6_STATUS = "F"'      , 'BR_VERMELHO' },;	// (F) Finalizado Atendiomento (Vermelho) 
					  {'SZ6->Z6_STATUS = "E"'      , 'BR_PRETO'    }} 	// (E) Encerrado               (Preto)


Private aBut110		:= {}
PRIVATE aRotina 	:= {{"Pesquisar"       ,"PesqBrw"   ,  0 , 1},;     //1"Pesquisar"
                    	 {"Visualizar"      ,"U_MVisual",  0 , 2},;	     //2"Visualizar"
							 {"Incluir"         ,"U_MInclui",  0 , 3},;	     //3"Incluir"
							 {"Alterar"         ,"U_MAltera",  0 , 4, 4},;  //4"Alterar"
				  			 {"Excluir"         ,"U_MDeleta",  0 , 5, 5} ,; //5"Excluir"         
                    	 {"Reajustar"       ,"U_MFATC08",  0 , 4, 4},;	 //6"Reajuste de Precos"
							 {"Exportar/Excel"  ,"U_MFATC11",  0 , 4, 4},;  //7"Exportar/Excel"
				 			 {"Aprovar/Encerrar","U_MAprovar", 0 , 4},;     //8"Aprovar/Encerrar"
				 			 {"Gerar Pedido"    ,"U_MFATC05" , 0 , 3},;     //9"Gerar Pedido"
		                {"Legenda"         ,"U_MLegenda", 0 , 5, 0} }  // "Legenda"

						    //{"Imprimir"  ,"MImpri" , 0 , 4, 4},;	       //"Imprimir"
		
PRIVATE cCadastro	:= "Contratos de Venda"
PRIVATE bFiltraBrw  := {|| Nil}

DbSelectArea("SZ6")
SZ6->(dbSetOrder(1))
MsSeek(xFilial("SZ6"))	
mBrowse( 6, 1,22,75,"SZ6",,,,,,aCores)
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MVisual   ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de visualizacao das Contrato de Venda                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo visualizar as solicitacoes de  ³±±
±±³          ³compra utilizando-se uma modelo 2                            ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MVisual(cAlias,nReg,nOpcx)

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
Private cLoja         := SZ6->Z6_LOJA
Private dDtElabo      := SZ6->Z6_DTELABO
Private dDtValid      := SZ6->Z6_DTVALID
Private dDtAprov      := SZ6->Z6_DTAPROV
Private dDtEncer      := SZ6->Z6_DTENCER   
Private cCondpag      := SZ6->Z6_CONDPAG 
Private cVend1        := SZ6->Z6_VEND1
Private cTransp       := SZ6->Z6_TRANSP  
Private nFrete        := SZ6->Z6_X_FRETE  
Private nDolar1       := SZ6->Z6_DOLUTIL
Private nDolar2       := SZ6->Z6_DOLCLIE
Private cPedCli       := SZ6->Z6_COTCLI
Private cContCli      := SZ6->Z6_CONTCLI

Private oPedCli,oContCli
Private oDolar1,oDolar2
Private oNum,oCliente,oNome,oLoja,oCondpag
Private oDtElabo,oDtValid,oDtAprov,oDtEncer
Private ogetdad,oFntFecha5
Private oVend1,oTransp,oFrete

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private nProduto   := 0

Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab   := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab

Private CJ_X_ST_CI  := "CONSUMO"
Private a_X_ST_CI   := {"CONSUMO","INDUSTRIA"}

Private o_X_ST_CI



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)

//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
//    U_CalcSim2(nY,.F.,.T.,"U_MFATC04")
//Next

//2. Atualiza a media no Cabecalho
U_MediaRent(NIL,NIL,"C")


AAdd( aObjects, { 0   ,    070, .T., .F. } )
AAdd( aObjects, { 120   ,  110, .T., .T. } )/*160*/
AAdd( aObjects, { 0   ,    008, .T., .F. } )

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
                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][nProduto])})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,01] SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,02] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .f. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,03] SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,04] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .f. Valid CheckSX3("Z6_CLIENTE",cCliente) Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,05] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .f. Valid CheckSX3("Z6_LOJA",cLoja) Of oDlg PIXEL

@ 20,aPosGet[1,06] SAY "Nome"  of oDlg PIXEL 	
@ 19,aPosGet[1,07] MSGET oNome Var cNome  When .F. Of oDlg PIXEL SIZE 120,9	

@ 20,aPosGet[1,08] SAY "Cond. Pgto" of oDlg PIXEL	     
@ 19,aPosGet[1,09] MSGET oCondPag Var cCondpag F3 CpoRetF3("Z6_CONDPAG")    Picture PesqPict("SZ6","Z6_CONDPAG") ;
	When .f. Valid CheckSX3("Z6_CONDPAG",cCondpag) Of oDlg PIXEL

                 
@ 37,aPosGet[2,01] SAY "Data de Elaboracao"  of oDlg PIXEL size 30,20		
@ 36,aPosGet[2,02] MSGET oDtElabo Var dDtElabo F3 CpoRetF3("Z6_DtElabo")    Picture PesqPict("SZ6","Z6_DtElabo");
	When .f. Valid CheckSX3("Z6_DtElabo",dDtElabo) Of oDlg PIXEL

@ 37,aPosGet[2,03] SAY "Data de Validade"  of oDlg PIXEL 	size 30,20
@ 36,aPosGet[2,04] MSGET oDtValid Var dDtValid F3 CpoRetF3("Z6_DtValid") Picture PesqPict("SZ6","Z6_DtValid");
	When .f. Valid CheckSX3("Z6_DtValid",dDtValid) Of oDlg PIXEL

@ 37,aPosGet[2,05] SAY "Industria/Consumo" of oDlg PIXEL  
@ 36,aPosGet[2,06] MSCOMBOBOX o_X_ST_CI VAR CJ_X_ST_CI ITEMS a_X_ST_CI  SIZE 60,50 OF oDlg PIXEL;
  When .f.
// ON CHANGE CheckCombo();

@ 37,aPosGet[2,07] SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .f. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09] SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .f. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL


@ 54,aPosGet[3,01] SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,02] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .f. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL


@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .f. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .f. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL
                    
@ 71,aPosGet[4,01] 	SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .F.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .F.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 
	

ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"A110LinOk","A110TudOk","",.F.)
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 

//@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	


ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1, IIf(ogetdad:TudoOk() .and. U_ValCabec(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpcx)
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)

MsUnLockAll()

RestArea(aArea)

Return ( nOpcA )


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MInclui   ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de inclusao das Contrato de Venda                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo possibilitar a inclusao manual ³±±
±±³          ³das solicitacoes de compra utilizando-se de uma modelo 2     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function MInclui(cAlias,nReg,nOpcx)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := ""   
Private cCliente      := ""
Private cNome         := ""
Private cLoja         := "01"
Private dDtElabo      := ctod("")
Private dDtValid      := ctod("")
Private dDtAprov      := cTod("")
Private dDtEncer      := ctod("")   
Private cCondpag      := CriaVar("Z6_CONDPAG") 
Private cVend1        := CriaVar("Z6_VEND1")
Private cTransp       := CriaVar("Z6_TRANSP")  
Private nFrete        := CriaVar("Z6_X_FRETE")  
Private nDolar1       := 0
Private nDolar2       := 0
Private cPedCli       := SZ6->Z6_COTCLI
Private cContCli      := SZ6->Z6_CONTCLI

Private oPedCli,oContCli
Private oDolar1,oDolar2
Private oNum,oCliente,oNome,oLoja,oCondpag
Private oDtElabo,oDtValid,oDtAprov,oDtEncer
Private ogetdad,oFntFecha5
Private oVend1,oTransp,oFrete


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private nProduto   := 0

Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab    := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab

Private CJ_X_ST_CI   := "CONSUMO"
Private a_X_ST_CI   := {"CONSUMO","INDUSTRIA"}
Private o_X_ST_CI        
        


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)

// Nao e necessario durante a Inclusao
//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
    //U_CalcSim2(nY,.F.,.T.,"U_MFATC04")
//Next

U_MediaRent(NIL,NIL,"CC")


AAdd( aObjects, { 0   ,    070, .T., .F. } )
AAdd( aObjects, { 120   ,  110, .T., .T. } )/*160*/
AAdd( aObjects, { 0   ,    008, .T., .F. } )

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][nProduto])})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,01] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,02] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .T. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,03] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,04] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .T. Valid CheckSX3("Z6_CLIENTE",cCliente).AND. ValNome(nOpcx,"cCliente") .And. U_GetIndCon() Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,05] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .T. Valid CheckSX3("Z6_LOJA",cLoja).AND. ValNome(nOpcx,"cLoja") .And. U_GetIndCon() Of oDlg PIXEL

@ 20,aPosGet[1,06] 	SAY "Nome"  of oDlg PIXEL 	
@ 19,aPosGet[1,07] MSGET oNome Var cNome  ;
    When .F. Of oDlg PIXEL SIZE 120,9	

@ 20,aPosGet[1,08] 	SAY "Cond. Pgto" of oDlg PIXEL	     
@ 19,aPosGet[1,09] MSGET oCondPag Var cCondpag F3 CpoRetF3("Z6_CONDPAG")    Picture PesqPict("SZ6","Z6_CONDPAG") ;
	When .F. Valid CheckSX3("Z6_CONDPAG",cCondpag) .And. U_GetIndCon(.f.)  Of oDlg PIXEL

                 
@ 37,aPosGet[2,01] SAY "Data de Elaboracao"  of oDlg PIXEL size 30,20		
@ 36,aPosGet[2,02] MSGET oDtElabo Var dDtElabo F3 CpoRetF3("Z6_DtElabo")    Picture PesqPict("SZ6","Z6_DtElabo");
	When .T. Valid CheckSX3("Z6_DtElabo",dDtElabo) Of oDlg PIXEL

@ 37,aPosGet[2,03] SAY "Data de Validade"  of oDlg PIXEL 	size 30,20
@ 36,aPosGet[2,04] MSGET oDtValid Var dDtValid F3 CpoRetF3("Z6_DtValid") Picture PesqPict("SZ6","Z6_DtValid");
	When .T. Valid CheckSX3("Z6_DtValid",dDtValid) Of oDlg PIXEL

@ 37,aPosGet[2,05] SAY "Industria/Consumo" of oDlg PIXEL  
@ 36,aPosGet[2,06] MSCOMBOBOX o_X_ST_CI VAR CJ_X_ST_CI ITEMS a_X_ST_CI  SIZE 60,50 OF oDlg PIXEL;
    When .T. Valid CheckSX3("Z6_X_ST_CI",CJ_X_ST_CI)

@ 37,aPosGet[2,07]	SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .T. Valid CheckSX3("Z6_VEND1",cVEND1)  .And. U_GetIndCon() Of oDlg PIXEL

@ 37,aPosGet[2,09]	SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .T. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL


@ 54,aPosGet[3,1] 	SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,2] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .F. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL

@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab;
    When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] 	SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab ;
    When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .T. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .T. Valid CheckSX3("Z6_DOLCLIE",nDolar2) of oDlg PIXEL

@ 71,aPosGet[4,01] 	SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .T.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .T.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 



ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_MLinOK","U_MTudOK","+Z6_ITEM",.T.,aAltGr,,.T.,300)
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 

@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1, IIf(ogetdad:TudoOk() .and. U_ValCabec(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpcx)
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)
          

If ( nOpcA == 1 )


    ConfirmSx8()

	Begin Transaction
	If ( !MGrava(1,cNum,cCliente,cLoja,dDtElabo,dDtValid,dDtAprov,dDtEncer,cCondpag,cVend1,cTransp,nFrete,nDolar1,nDolar2 ) )
		nOpcA := 0
		Help(" ",1,"MNAOREG")
	Else
		EvalTrigger()
		If ( __lSX8 )
			ConfirmSX8()
		Endif
	EndIf
	End Transaction

Else

   RollBackSX8()

EndIf

MsUnLockAll()

RestArea(aArea)

Return ( nOpcA )



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MAltera   ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de alteracao das solicitacoes de compra               ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo possibilitar a alteracao manual³±±
±±³          ³das solicitacoes de compra utilizando-se de uma modelo 2     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MAltera(cAlias,nReg,nOpcx)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
Private cLoja         := SZ6->Z6_LOJA
Private dDtElabo      := SZ6->Z6_DTELABO
Private dDtValid      := SZ6->Z6_DTVALID
Private dDtAprov      := SZ6->Z6_DTAPROV
Private dDtEncer      := SZ6->Z6_DTENCER   
Private cCondpag      := SZ6->Z6_CONDPAG 
Private cVend1        := SZ6->Z6_VEND1
Private cTransp       := SZ6->Z6_TRANSP  
Private nFrete        := SZ6->Z6_X_FRETE  
Private nDolar1       := SZ6->Z6_DOLUTIL
Private nDolar2       := SZ6->Z6_DOLCLIE
Private cPedCli       := SZ6->Z6_COTCLI
Private cContCli      := SZ6->Z6_CONTCLI

Private oPedCli,oContCli
Private oDolar1,oDolar2
Private oNum,oCliente,oNome,oLoja,oCondpag
Private oDtElabo,oDtValid,oDtAprov,oDtEncer
Private ogetdad,oFntFecha5
Private oVend1,oTransp,oFrete

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private nProduto   := 0
                 
Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab    := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab

Private CJ_X_ST_CI   := "CONSUMO"
Private a_X_ST_CI   := {"CONSUMO","INDUSTRIA"}
Private o_X_ST_CI        



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem itens com Status diferente de Encerrado.           ³
//³Caso todos os itens estejam incerrados retornar.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
nRecno:=SZ6->(RECNO())
lRet:=.T.
SZ6->(dbSetOrder(1))
SZ6->(DbGotop())
If SZ6->(DbSeek(xFilial("SZ6")+cNum))
	While ( !Eof() .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
	     	SZ6->Z6_NUM == cNum )
	        If SZ6->Z6_STATUS # "E" 
	           lRet:=.f.
	        Endif
	        SZ6->(DbSkip())
	Enddo              
Endif	
DbGoto(nRecno)

if lRet
    Aviso('Atencao','Contrato Encerrado.'+CHR(13)+CHR(13)+;
                    'Todos os itens deste contrato estao com Status'+CHR(13)+;
                    '(E) Encerrado ou'+chr(13)+;
                    '(F) Finalizado',{'Ok'})
   Return
Endif   
  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)

//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
//    U_CalcSim2(nY,.F.,.T.,"U_MFATC04")
//Next

U_MediaRent(NIL,NIL,"CC")


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

                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][nProduto])})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,1] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,2] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .F. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,3] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,4] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .F. Valid CheckSX3("Z6_CLIENTE",cCliente).AND. ValNome(nOpcx,"cCliente") Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,5] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .F. Valid CheckSX3("Z6_LOJA",cLoja).AND. ValNome(nOpcx,"cLoja") Of oDlg PIXEL


@ 20,aPosGet[1,6] 	SAY "Nome"  of oDlg PIXEL 	
@ 19,aPosGet[1,7] MSGET oNome Var cNome  When .F. Of oDlg PIXEL SIZE 120,9	

@ 20,aPosGet[1,8] 	SAY "Cond. Pgto" of oDlg PIXEL	     
@ 19,aPosGet[1,9] MSGET oCondPag Var cCondpag F3 CpoRetF3("Z6_CONDPAG")    Picture PesqPict("SZ6","Z6_CONDPAG") ;
	When .F. Valid CheckSX3("Z6_CONDPAG",cCondpag) Of oDlg PIXEL

                 
@ 37,aPosGet[2,1] SAY "Data de Elaboracao"  of oDlg PIXEL size 30,20		
@ 36,aPosGet[2,2] MSGET oDtElabo Var dDtElabo F3 CpoRetF3("Z6_DtElabo")    Picture PesqPict("SZ6","Z6_DtElabo");
	When .f. Valid CheckSX3("Z6_DtElabo",dDtElabo) Of oDlg PIXEL

@ 37,aPosGet[2,3] SAY "Data de Validade"  of oDlg PIXEL 	size 30,20
@ 36,aPosGet[2,4] MSGET oDtValid Var dDtValid F3 CpoRetF3("Z6_DtValid") Picture PesqPict("SZ6","Z6_DtValid");
	When .t. Valid CheckSX3("Z6_DtValid",dDtValid) Of oDlg PIXEL


@ 37,aPosGet[2,5] SAY "Industria/Consumo" of oDlg PIXEL  
@ 36,aPosGet[2,6] MSCOMBOBOX o_X_ST_CI VAR CJ_X_ST_CI ITEMS a_X_ST_CI  SIZE 60,50 OF oDlg PIXEL ;
    When .T. Valid CheckSX3("Z6_X_ST_CI",CJ_X_ST_CI)

@ 37,aPosGet[2,07]	SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .T. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09]	SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .T. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL

@ 54,aPosGet[3,1] 	SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,2] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .F. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL

@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab ;
    When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] 	SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab ;
    When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .T. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .T. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL
          
@ 71,aPosGet[4,01] 	SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .T.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .T.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 

ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_MLinOK","U_MTudOK","+Z6_ITEM",.T.,aAltGr,,.T.,300)
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 
 
@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1, IIf(ogetdad:TudoOk() .and. U_ValCabec(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpcx)
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)
          

If ( nOpcA == 1 )

	Begin Transaction
		If !MGrava(2,cNum,cCliente,cLoja,dDtElabo,dDtValid,dDtAprov,dDtEncer,cCondpag,cVend1,cTransp,nFrete,nDolar1,nDolar2)
			Help(" ",1,"MNAOREG")
		Else
			EvalTrigger()
		EndIf
	End Transaction

EndIf

MsUnLockAll()

RestArea(aArea)

Return ( nOpcA )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MDeleta   ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de exclusao das solicitacoes de compra                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo possibilitar a exclusao manual ³±±
±±³          ³das solicitacoes de compra utilizando-se de uma modelo 2     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MDeleta(cAlias,nReg,nOpcx)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
Private cLoja         := SZ6->Z6_LOJA
Private dDtElabo      := SZ6->Z6_DTELABO
Private dDtValid      := SZ6->Z6_DTVALID
Private dDtAprov      := SZ6->Z6_DTAPROV
Private dDtEncer      := SZ6->Z6_DTENCER   
Private cCondpag      := SZ6->Z6_CONDPAG 
Private cVend1        := SZ6->Z6_VEND1
Private cTransp       := SZ6->Z6_TRANSP  
Private nFrete        := SZ6->Z6_X_FRETE  
Private cPedCli       := SZ6->Z6_COTCLI
Private cContCli      := SZ6->Z6_CONTCLI

Private oPedCli,oContCli

Private oNum,oCliente,oNome,oLoja,oCondpag
Private oDtElabo,oDtValid,oDtAprov,oDtEncer
Private ogetdad,oFntFecha5
Private oVend1,oTransp,oFrete

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private nProduto   := 0

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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem itens com Status diferente de Encerrado.           ³
//³Caso todos os itens estejam incerrados retornar.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
nRecno:=SZ6->(RECNO())
lRet:=.T.
SZ6->(dbSetOrder(1))
SZ6->(DbGotop())
SZ6->(DbSeek(xFilial("SZ6")+cNum))
While ( SZ6->(!Eof()) .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
     	SZ6->Z6_NUM == cNum )
        If SZ6->Z6_STATUS # "E" 
           lRet:=.f.
        Endif
        SZ6->(DbSkip())
Enddo              
DbGoto(nRecno)

if lRet
    Aviso('Atencao','Contrato Encerrado.'+CHR(13)+CHR(13)+;
                    'Todos os itens deste contrato estao com Status'+CHR(13)+;
                    '(E) Encerrado ou'+chr(13)+;
                    '(F) Finalizado',{'Ok'})
   Return
Endif   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)

//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
 //   U_CalcSim2(nY,.F.,.T.,"U_MFATC04")
//Next

U_MediaRent(NIL,NIL,"CC")


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

                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][nProduto])})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,1] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,2] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
When .f. Valid  U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,3] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,4] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
When .f. Valid CheckSX3("Z6_CLIENTE",cCliente) Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,5] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
When .f. Valid CheckSX3("Z6_LOJA",cLoja)  Of oDlg PIXEL


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


@ 37,aPosGet[2,07]	SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
When .f. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09]	SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
When .f. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL

@ 54,aPosGet[3,1] 	SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,2] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .f. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL

@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] 	SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .f. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .f. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL

@ 71,aPosGet[4,01] 	SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .F.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .F.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 

//@ 54,aPosGet[3,07]	SAY "Status Rentabil." of oDlg PIXEL	   size 30,20  
//@ 53,aPosGet[3,08] MSGET oSrentab Var cSrentab  When .F. Picture "@!"  Of oDlg PIXEL


//@ 37,aPosGet[2,5] SAY "Data de Aprovacao" of oDlg PIXEL  size 30,20
//@ 36,aPosGet[2,6] MSGET  oDtAprov VAR dDtAprov F3 CpoRetF3("Z6_DtAprov")    Picture PesqPict("SZ6","Z6_DtAprov");
//	When .f. Valid CpoRetF3("Z6_DtAprov") Of oDlg PIXEL

//@ 37,aPosGet[2,7] 	SAY "Data de Encerramento"  of oDlg PIXEL size 35,20	
//@ 36,aPosGet[2,8] MSGET oDtEncer Var dDtEncer F3 CpoRetF3("Z6_DtEncer") Picture PesqPict("SZ6","Z6_DtEncer");
//	When .f. Valid CheckSX3("Z6_DtEncer",dDtEncer) Of oDlg PIXEL

ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_MLinOK","U_MTudOK","+Z6_ITEM",.T.,aAltGr,,.T.,300)
ogetdad:oBrowse:nFreeze := 6       // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 
 
@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1, IIf(ogetdad:TudoOk() .and. U_ValDelet(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpcx)
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F12,nil)
          
If ( nOpcA == 1 )
	Begin Transaction
	If  MGrava(3,cNum,cCliente,cLoja,dDtElabo,dDtValid,dDtAprov,dDtEncer,cCondpag,cVend1,cTransp,nFrete,nDolar1,nDolar2 ) 
		EvalTrigger()
	Endif	
	End Transaction			
EndIf


MsUnLockAll()

RestArea(aArea)

Return ( nOpcA )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MAprovar  ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de visualizacao das Contrato de Venda                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                    ³±±
±±³          ³ ExpN2 = Numero do registro                                  ³±±
±±³          ³ ExpN3 = Numero da opcao selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo visualizar as solicitacoes de  ³±±
±±³          ³compra utilizando-se uma modelo 2                            ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MAprovar(cAlias,nReg,nOpcx)
                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Tela - Utilizadas no Controle das Funcionalidades da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea			  := GetArea()
Local aSizeAut		  := MsAdvSize(,.F.)
Local nOpcA	    	  := 0
Local oDlg      
Local bSetKey5      
Local bSetKey4      
Local bSetKey6      
Local bSetKey12     
Local aObjects		  := {}
Local aInfo 		  := {}
Local aPosGet		  := {}
Local aPosObj		  := {}
Local nZ6Item         := 0
Local nDtAprov        := 0
Local nDtEncer        := 0    
Local nValCols        := 0 
Local lRet            := .F.         
Local nRecno          := 0      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis de Cabecalho - Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cEspress      := ""               
Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da MsGetDados- Valores seram atribuidos pela funcao MMONTA() ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aHeader		:= {}
Private aCols 		:= {}
Private aAltGr      := {}
Private nProduto   := 0

Private nPrentab   := 0
Private nRrentab   := 0 
Private cSrentab    := "Bloqueado" 
Private oPrentab,oRrentab,oSrentab

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
//³Verifica se existem itens com Status diferente de Encerrado.           ³
//³Caso todos os itens estejam incerrados retornar.                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
nRecno:=SZ6->(RECNO())
lRet:=.T.
SZ6->(dbSetOrder(1))
SZ6->(DbGotop())
SZ6->(DbSeek(xFilial("SZ6")+cNum))
While ( SZ6->(!Eof()) .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
     	SZ6->Z6_NUM == cNum )
        If SZ6->Z6_STATUS # "E" 
           lRet:=.f.
        Endif
        SZ6->(DbSkip())
Enddo              
DbGoto(nRecno)

if lRet
    Aviso('Atencao','Contrato Encerrado.'+CHR(13)+CHR(13)+;
                    'Todos os itens deste contrato estao com Status'+CHR(13)+;
                    '(E) Encerrado ou'+chr(13)+;
                    '(F) Finalizado',{'Ok'})
   Return
Endif   
  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(nOpcx)

//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
//    U_CalcSim2(nY,.F.,.T.,"U_MFATC04")
//Next

U_MediaRent(NIL,NIL,"CC")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do Combox                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nValCombo:=aScan(aCols  ,{|x| Empty(x[nDtAprov])})
//AAdd(a_X_ST_CI,Upper("Nenhum Item foi Escolhido       "))   
//if nValCols <> 0   // Existe Alguma data de Aprovacao em Branco
//    AAdd(a_X_ST_CI,Upper("Aprovar todos os Itens          "))    
//Endif
//AAdd(a_X_ST_CI,Upper("Encerrar todos os Itens         "))   


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
                                                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
bSetKey5 :=SetKey(VK_F5 ,{|| U_MLegenda()})
bSetKey4 :=SetKey(VK_F4 ,{|| U_MFATC03(aCols[n][nProduto])})
bSetKey6 :=SetKey(VK_F6 ,{|| U_APROVALL()})
bSetKey12:=SetKey(VK_F12,nil)

@ 20,aPosGet[1,1] 	SAY "N.Contrato" of oDlg PIXEL SIZE 30,09 
@ 19,aPosGet[1,2] MSGET  oNum VAR cNum F3 CpoRetF3("Z6_Num")    Picture PesqPict("SZ6","Z6_NUM");
	When .f. Valid U_MNumero(M->cNum,nOpcx,oDlg) Of oDlg PIXEL

@ 20,aPosGet[1,3] 	SAY "Cliente"  of oDlg PIXEL SIZE 31,9	
@ 19,aPosGet[1,4] MSGET oCliente Var cCliente F3 CpoRetF3("Z6_CLIENTE") Picture PesqPict("SZ6","Z6_CLIENTE");
	When .f. Valid CheckSX3("Z6_CLIENTE",cCliente)  Of oDlg PIXEL
                                                   
@ 19,aPosGet[1,5] MSGET oLoja Var cLoja F3 CpoRetF3("Z6_LOJA")    Picture PesqPict("SZ6","Z6_LOJA");
	When .f. Valid CheckSX3("Z6_LOJA",cLoja)  Of oDlg PIXEL


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

@ 37,aPosGet[2,07]	SAY "Vend. Interno" of oDlg PIXEL	     
@ 36,aPosGet[2,08] MSGET oVEND1 Var cVEND1 F3 CpoRetF3("Z6_VEND1")    Picture PesqPict("SZ6","Z6_VEND1");
	When .f. Valid CheckSX3("Z6_VEND1",cVEND1) Of oDlg PIXEL

@ 37,aPosGet[2,09]	SAY "Transp." of oDlg PIXEL	     
@ 36,aPosGet[2,10] MSGET oTransp Var cTransp F3 CpoRetF3("Z6_TRANSP")    Picture PesqPict("SZ6","Z6_TRANSP");
	When .f. Valid CheckSX3("Z6_TRANSP",cTRANSP) Of oDlg PIXEL

@ 54,aPosGet[3,1] 	SAY "Frete" of oDlg PIXEL	     
@ 53,aPosGet[3,2] MSGET oFrete Var nFrete F3 CpoRetF3("Z6_X_FRETE")    Picture PesqPict("SZ6","Z6_X_FRETE");
	When .f. Valid CheckSX3("Z6_X_FRETE",nFrete) Of oDlg PIXEL

@ 54,aPosGet[3,03] SAY "% Medio de Rentabil."  of oDlg PIXEL 	size 30,20
@ 53,aPosGet[3,04] MSGET oPrentab Var nPrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,05] 	SAY "R$ Media de Rentabil."  of oDlg PIXEL  size 30,20	
@ 53,aPosGet[3,06] MSGET oRrentab Var nRrentab When .F. Picture "@E 9,999,999.99" Of oDlg PIXEL

@ 54,aPosGet[3,07]	SAY "Dolar Utilizado" of oDlg PIXEL	     
@ 53,aPosGet[3,08] MSGET oDolar1 Var nDolar1 F3 CpoRetF3("Z6_DOLUTIL")    Picture PesqPict("SZ6","Z6_DOLUTIL");
	When .f. Valid CheckSX3("Z6_DOLUTIL",nDolar1) Of oDlg PIXEL

@ 54,aPosGet[3,09]	SAY "Dolar Cliente" of oDlg PIXEL	     
@ 53,aPosGet[3,10] MSGET oDolar2 Var nDolar2 F3 CpoRetF3("Z6_DOLCLIE")    Picture PesqPict("SZ6","Z6_DOLCLIE");
	When .f. Valid CheckSX3("Z6_DOLCLIE",nDolar2) Of oDlg PIXEL

@ 71,aPosGet[4,01] 	SAY "Contr.Cliente"  of oDlg PIXEL SIZE 31,9	
@ 70,aPosGet[4,02] MSGET oContCli Var cContCli SIZE 53,9;
   When .f.  Picture PesqPict("SZ6","Z6_CONTCLI") Of oDlg PIXEL 

@ 71,aPosGet[4,03] SAY "N.Ped.Cliente" of oDlg PIXEL SIZE 35,09 
@ 70,aPosGet[4,04] MSGET  oPedCli VAR cPedCli SIZE 67,9; 
   When .f.  Picture PesqPict("SZ6","Z6_COTCLI")  Of oDlg PIXEL 


ogetdad:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_MLinOK","U_MTudOK","+Z6_ITEM",.T.,aAltGr,,.T.,300)
ogetdad:oBrowse:nFreeze := 6        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
ogetdad:nMax:=Len(Acols) 


@ aPosObj[3,1],U_PosMeio(aPosObj[2,3],cEspress)  SAY  cEspress  of oDlg PIXEL  FONT oFntFecha5                          	

ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{|| nOpcA := 1, IIf(ogetdad:TudoOk() .and. U_ValCabec(),oDlg:End(),nOpcA := 0)},{||oDlg:End()},nOpcx)
SetKey(VK_F5,nil)
SetKey(VK_F4,nil) 
SetKey(VK_F6,nil) 
SetKey(VK_F12,nil)
          
if nOpcA = 1

	Begin Transaction

	nZ6Item :=aScan(aHeader,{|x| Trim(x[2])=="Z6_ITEM"})
	nDtAprov:=aScan(aHeader,{|x| Trim(x[2])=="Z6_DTAPROV"})
	nDtEncer:=aScan(aHeader,{|x| Trim(x[2])=="Z6_DTENCER"})

	DbselectArea("SZ6")
	SZ6->(DbSetOrder(3))

	For nY := 1 To Len(Acols)                               
              
	     IF SZ6->(Dbseek(xFilial("SZ6")+cNum+cCliente+cLoja+Acols[nY][nProduto]+Acols[nY][nZ6Item]))
                        
		    RecLock("SZ6",.F.)

   		    IF !EmptY(Acols[nY][nDtAprov]) //.and. EmptY(SZ6->Z6_DTAPROV)    

    		      SZ6->Z6_DTAPROV:= Acols[nY][nDtAprov]   
		          SZ6->Z6_STATUS :="A"

            Else
   		          SZ6->Z6_DTAPROV:= Acols[nY][nDtAprov]   
	              SZ6->Z6_STATUS :="N"
            Endif

		    If !EmptY(Acols[nY][nDtEncer]) .and. EmptY(SZ6->Z6_DTENCER)
    		   SZ6->Z6_DTENCER   := Acols[nY][nDtEncer] 
		       SZ6->Z6_STATUS    :="E" 
		    Endif
		       
			SZ6->(MsUnlock())

		 Endif

	Next ny


	End Transaction
	
Endif

MsUnLockAll()

RestArea(aArea)

Return ( nOpcA )



Static Function ValAprov(dDtAprov) 
Local nDtAprov:=aScan(aHeader,{|x| Trim(x[2])=="Z6_DTAPROV"})
Local nY      :=0

If EmptY(dDtAprov)
   Return(.t.)
Endif

For nY:= 1 to Len(Acols)
    aCols[nY][nDtAprov]:=If(EmptY(aCols[nY][nDtAprov]),dDtAprov,aCols[nY][nDtAprov])
Next
ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento.

Return .T.    


Static Function ValEncer(dDtEncer)                                     
Local nDtEncer:=aScan(aHeader,{|x| Trim(x[2])=="Z6_DTENCER"})
Local nY      :=0          

If EmptY(dDtEncer)
   Return(.t.)
Endif
   
For nY:= 1 to Len(Acols)
    aCols[nY][nDtEncer]:=If(EmptY(aCols[nY][nDtEncer]),dDtAprov,aCols[nY][nDtEncer])
Next
ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento.
Return .T.    



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MNumero   ³ Autor ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de avaliacao do numero da Contrato de Venda           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Numero da Contrato de Venda                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo nao permitir a duplicacao do   ³±±
±±³          ³numero da Contrato de Venda                                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MNumero(cNumSC,nOpcx,oDlg)

Local aArea 	:= GetArea()
Local lRet		:= .T.

If Empty(cNumSC)

    Aviso('Atencao','Numero de Contrato Invalido.'+CHR(13)+CHR(13)+;
                    'Favor informar um numero para o Contrato.',{'Ok'})
	lRet := .F.

Else     
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(1))

    If nOpcx = 3  
    	If SZ6->(MsSeek( xFilial("SZ6")+cNumSC))
           Aviso('Atencao ','Numero de Contrato Invalido.'+CHR(13)+CHR(13)+;
                          'Contrato ja Cadastrado.',{'Ok'})
		   lRet := .F.
	    EndIf
    Else
    	If !SZ6->(MsSeek( xFilial("SZ6")+cNumSC))
           Aviso('Atencao ','Numero de Contrato Invalido.'+CHR(13)+CHR(13)+;
                          'Contrato Nao Cadastrado.',{'Ok'})
		   lRet := .F.
	    EndIf
    Endif

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do aHeader e do aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if nOpcx <> 3 .and. lRet  
   U_MMONTA(nOpcx)
   oDlg:Refresh()
Endif

RestArea(aArea)

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MLinOk    ³ Autor ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de avaliacao LinhaOk                                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da GetDados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. -> Linha valida                                   ³±±
±±³          ³       .F. -> Linha invalida                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao de uma     ³±±
±±³          ³linha da getdados para a rotina de atualizacao da Contrato   ³±±
±±³          ³de Vendas                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MLinOk(o)

Local aArea		:= GetArea()
Local cItem     := ""
Local lRet 		:= .T.
Local lDeleted	:= .F.
Local nPProd    := aScan(aHeader,{|x| Trim(x[2])=="Z6_PRODUTO"})
Local nPQuant   := aScan(aHeader,{|x| Trim(x[2])=="Z6_QTDVEN"})
Local nPItem    := aScan(aHeader,{|x| Trim(x[2])=="Z6_ITEM"})

If ValType(aCols[n,Len(aCols[n])]) == "L"
	lDeleted := aCols[n,Len(aCols[n])]      // Verifica se esta Deletado
EndIf

If ( !lDeleted )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a Linha esta preenchida                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Empty(aCols[n][nPProd]) .Or. Empty(aCols[n][nPQuant]) )
		Help(" ",1,"M02")
		lRet := .F.
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a linha pode ser deletada                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//If ( !INCLUI )
	//	dbSelectArea("SZ6")
	//	dbSetOrder(1)
	//	If ( MsSeek(xFilial("SZ6")+cMNum+aCols[n][nPItem]) )
	//		lRet := MaCanDelSC("SZ6")
	//	EndIf
	//EndIf
EndIf

RestArea(aArea)
Return(lRet)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MTudOk    ³ Autor ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de avaliacao da getdados ( TudoOk )                   ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto da GetDados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: .T. -> GetDados valida                                ³±±
±±³          ³       .F. -> Getdados invalida                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao da solici- ³±±
±±³          ³tacao de compras para a rotina de atualizacao da Contratos   ³±±
±±³          ³de Venda.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTudOk(o)

Local aArea		:= GetArea()
Local nPItem    := aScan(aHeader,{|x| Trim(x[2])=="Z6_ITEM"})
Local nX        := 0
Local lDeleted	:= .F.
Local lRetorno  := .T.

/*
If ( !INCLUI )
	For nX := 1 To Len(aCols)
		If ValType(aCols[nX,Len(aCols[nX])]) == "L"
			lDeleted := aCols[nX,Len(aCols[nX])]
		EndIf
		//If ( lDeleted )
		//	dbSelectArea("SZ6")
		//	dbSetOrder(1)
		//	If ( MsSeek(xFilial("SZ6")+cMNum+aCols[n][nPItem]) )
		//		lRetorno := MaCanDelSC("SZ6")
		//	EndIf
			If ( !lRetorno )
				Exit
			EndIf
		EndIf
	Next nX
EndIf
*/

RestArea(aArea)
Return(lRetorno)
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MValid    ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de validacao da quantidade da Contrato de Venda       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: [P] para Produto                                      ³±±
±±³          ³       [Q] Para quantidade                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Indica se a quantidade eh valida                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao da quantida³±±
±±³          ³de informada na Contrato de Venda para nao permitir          ³±±
±±³          ³que a quantidade da Contrato de Venda seja menor que a       ³±±
±±³          ³quantidade em pedido.                                        ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MValid(cTipo)

Local aArea     := GetArea()
Local cProduto	:= ""
Local nQuant	:= 0
Local nPProduto := aScan(aHeader,{|x| Trim(x[2])=="Z6_PRODUTO"})
Local nPQuant   := aScan(aHeader,{|x| Trim(x[2])=="Z6_QTDVEN"})
Local nPItem    := aScan(aHeader,{|x| Trim(x[2])=="Z6_ITEM"})
Local lRetorno  := .T.

If ( cTipo == "P" )
	cProduto := &(ReadVar())
	nQuant   := aCols[n][nPQuant]
Else
	cProduto := aCols[n][nPProduto]
	nQuant   := &(ReadVar())
EndIf
If ( Altera )
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(2))
	If ( SZ6->(DbSeek(xFilial("SZ6")+aCols[n][nPProduto]+cMNum+aCols[n][nPItem]) ))
		If ( SZ6->Z6_QUJE > nQuant )
			Help(" ",1,"MMAIO")
			lRetorno := .F.
		Else 
			lRetorno := MaCanAltSC("SZ6")
		EndIf

	EndIf
EndIf
Return(lRetorno)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MImpri    ³ Autor ³                       ³ Data ³06.11.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a chamada do relatorio padrao ou do usuario         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpX1 := MImpri( ExpC1, ExpN1, ExpN2 )                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Alias do arquivo                                  ³±±
±±³          ³ ExpN1 -> Recno do registro                                 ³±±
±±³          ³ ExpN2 -> Opcao do Menu                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpX1 -> Retorno do relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MC04                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/           

User Function MImpri( cAlias, nRecno, nOpc )

Local cPrinter := GetMV("MV_SOLIMPR" ,, "" )
Local xRet     := .T. 

If !Empty( cPrinter ) .And. Existblock( cPrinter )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a chamada do relatorio de usuario                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ExecBlock( cPrinter, .F., .F., { cAlias, nRecno, nOpc } )
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a chamada do relatorio padrao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xRet := MATR140( cAlias, nRecno, nOpc ) 		
EndIf

dbSelectArea("SZ6")

Return( xRet )



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MLegenda   ³ Autor ³                      ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Exibe uma janela contendo a legenda da mBrowse.              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MLegenda()

BrwLegenda(cCadastro,"Situacao do Item do contrato" ,{;
                              { "BR_VERDE"   ,"(N) Em Negociacao"  },;
                  			  { "BR_AMARELO" ,"(A) Aprovado Nao Atendido"  },; 
				  			  { "BR_AZUL"    ,"(D) Aprovado em Atendimento"  },;
				  			  { "BR_VERMELHO","(F) Qtd. Contratada Atendida" },; 
				  			  { "BR_PRETO"   ,"(E) Encerrado"}})


Return




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
Static Function RfatBar(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0


If nOpc = 3 .or. nOpc = 4  // Incluir / Alterar
   aadd(aButtons, {"S4WB011N"    , {||U_MFATC03(aCols[n][nProduto])}, "<F4> - Consulta Estoque da Malha Logistica" })	
   If ExistBlock("MA415BUT")
      If ValType( aUsButtons := ExecBlock( "MA415BUT", .F., .F. ) ) == "A"
		 AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	  EndIf
   EndIf
Endif

///if nOPc = 8             // Aprovacao
//   aadd(aButtons, {"S4WB011N"    , {||U_APROVALL()}, "<F6> - Aprovar/Encerrar Todos" })	
///Endif

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))

              

Static Function ValNome(nOpcx,cOpcao)
Local lRet   := .T.
Local aArea  := GetArea()
Local cChave := ""

If cOpcao $ "cCliente"  
   cChave :=  cCliente
Else
   cChave :=  cCliente+cLoja   
Endif

   
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
IF !SA1->(Dbseek(xFilial("SA1")+cChave))
   Aviso('Atencao','Cliente nao Cadastrado.',{'Ok'})
   lRet := .f.
Endif

cNome   :=SA1->A1_NREDUZ
cCondpag:=SA1->A1_COND 

oCondpag:Refresh()
oNome:Refresh()

RestArea(aArea)

Return(lRet)

                                             



User Function PosMeio(nPosMax,cEspress)
Local nLin1 := 0  // Meio da Tela
Local nLin2 := 0  // Meio da Espressao

nLin1:= nPosMax / 2
nLin2:= Len(cEspress)   / 2

Return (nLin1 - nLin2)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValCabec  ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Validacao dos dados do contrato                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValCabec()
Local lRet:=.T.

If Empty(cNum) 
   Aviso('Atencao','Numero de Contrato Invalido.'+CHR(13)+CHR(13)+;
                   'Favor informar um numero para o Contrato.',{'Ok'})
   lRet:=.F.
ElseIf Empty(cCliente)  
   Aviso('Atencao','Nao foi informado o Codigo do Cliente.',{'Ok'})
   lRet:=.F.
ElseIf Empty(dDtElabo)
   Aviso('Atencao','Nao foi Informada a Data de Elaboracao do Contrato.',{'Ok'})
   lRet:=.F.
ElseIf Empty(cCondpag)
   Aviso('Atencao','Nao foi informado a Condicao de Pagamento.',{'Ok'})
   lRet:=.F.
ElseIf Empty(cVend1)
   Aviso('Atencao','Nao foi informado o Vendedor Interno.',{'Ok'})
   lRet:=.F.
ElseIf Empty(cTransp)
   Aviso('Atencao','Nao foi informada a Transportadora.',{'Ok'})
   lRet:=.F.
Endif
Return(lRet)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValDelet  ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Validacao dos dados do contrato                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValDelet()
Local lRet:=.T.

dbSelectArea("SZ6")
SZ6->(dbSetOrder(1))
If SZ6->(DbSeek(xFilial("SZ6")+cNum))
	While SZ6->(!Eof()) .And. SZ6->Z6_FILIAL == xFilial("SZ6") .And.;
	    	SZ6->Z6_NUM == cNum 
	        
	      If SZ6->Z6_STATUS <> "N"
	         lRet := .f.
	      Endif 
	        
	      SZ6->(DBSKIP())   
	
	Enddo
Endif            
if !lRet
    Aviso('Atencao','Nao sera possivel exclusao deste contrato.'+CHR(13)+CHR(13)+;
                    'Para exclusao todos os itens devem estar no'+CHR(13)+CHR(13)+;
                    'processo de Negociacao (N).',{'Ok'})
Endif

Return(lRet)




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | APROVALL ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Objetivo Aprovar ou Encerrar todos os itens em aberto      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function APROVALL()
Local nOpcao       := 0   
Local nY           := 0
Local nDtAprov     := aScan(aHeader,{|x| Trim(x[2])=="Z6_DTAPROV"})
Local nDtEncer     := aScan(aHeader,{|x| Trim(x[2])=="Z6_DTENCER"})
Local nStatus      := aScan(aHeader,{|x| Trim(x[2])=="Z6_STATUS"})
// Verifica posicao da data de aprovacao no aHeader.
Local dDtAprov     := aScan(aHeader,{|x| Trim(x[2])=="Z6_DTAPROV"})
// Verifica se Existem items com data de Aprovaca em Branco.
Local nOperacao    := aScan(aCols  ,{|x| Empty(x[nDtAprov])}) 
Local cCadastro    := ""
Local cSay         := ""
Local dData        := ctod("")



nOperacao  = 1


if nOperacao  = 1

   nOpcao    := Aviso('Atencao', 'Neste Momento voce tem as seguintes opcoes:' + chr(13)+;
                                 '< Aprovar > Aprovar todos os itens'  + chr(13)+;         
                                 '< Encerrar> Encerrar todos os itens' + chr(13)+;
                                 '< Cancelar > Cancelar Operacao',{'Aprovar','Encerrar','Cancelar'})
   if nOpcao = 1       // Aprovar Tudo

       cCadastro := "Data de Aprovacao Geral"
       cSay      := "Informar a data"
       dData     := ConsPer(cCadastro,cSay)
       if dData <> ctod("")    
          For nY:=1 to len(aCols)
              If Empty(aCols[nY][nDtAprov]) .AND. U_VAPROVA(nY,.F.)// antes de aprovar verifica data vazia e 
                 aCols[nY][nDtAprov] := dData                        // valida se nao existe produtos temporarios
                 aCols[nY][nStatus ] := "A"
              Endif
          Next
       Endif       

   ElseIF nOpcao = 2   // Encerrar Tudo

       cCadastro := "Data de Encerramento Geral"
       cSay      := "Informar a data"
       dData     := ConsPer(cCadastro,cSay)
       if dData <> ctod("")    
          For nY:=1 to len(aCols)
              If Empty(aCols[nY][nDtEncer])
                 aCols[nY][nDtEncer] := dData
                 aCols[nY][nStatus ] := "E"
              Endif
          Next    
       Endif
       
   Endif

Else

   nOpcao    := Aviso('Atencao','Neste Momento voce tem as seguintes opcoes:' + chr(13)+chr(13)+;
                                 '< Encerrar > Encerrar todos os Itens' + chr(13)+;
                                 '< Cancelar > Cancelar Operacao',{'Encerrar','Cancelar'})


    if nOpcao = 1       // Encerrar Tudo

       cCadastro := "Data de Encerramento"
       cSay      := "Encerrar"
       dData     := ConsPer(cCadastro,cSay)

       if dData <> ctod("")    
          For nY:=1 to len(aCols)
              If Empty(aCols[nY][nDtEncer])
                 aCols[nY][nDtEncer] := dData
                 aCols[nY][nStatus ] := "E"
              Endif
          Next    
       Endif
       
    Endif

Endif
                   

Return     


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ConsPer  ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela para informar a data de Aprovacao ou Encerramento     ³±±
±±³          ³ Geral                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ConsPer(cCadastro,cSay)
Local aArea		:= GetArea()
Local bKey4     := SetKey(VK_F4)
Local bKey12    := SetKey(VK_F12)

Local oSay
Local aPosObj   := {}
Local aSize     := {}
Local aPosGet   := {}
Local nGetLin   := 0
Local nOpca     := 0
Local oDlgF12
Local dDataAjus := dDataBase


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()                           //315 - Tam. Janela Vertical

aPosGet := MsObjGetPos(aSize[3]-aSize[1],50,;
	{{05,15},{10,15}})
                              
DEFINE MSDIALOG oDlgF12 TITLE cCadastro From aSize[7],0 to aSize[6]-200,aSize[5]-450 of oMainWnd PIXEL
                                                     
@ 25,aPosGet[1,1] SAY oSay PROMPT cSay 	  SIZE 060,009 PIXEL OF oDlgF12 
@ 25,aPosGet[1,2] MSGET dDataAjus  Of oDlgF12 PIXEL

DEFINE SBUTTON FROM 65,aPosGet[2,1]  TYPE 1 ACTION (nOpca:=1,If(dDataAjus=ctod(""),nOpca:=0,oDlgF12:End())) ENABLE OF oDlgF12
DEFINE SBUTTON FROM 65,aPosGet[2,2]  TYPE 2 ACTION (nOpca:=0,dDataAjus:=ctod(""),oDlgF12:End()) ENABLE OF oDlgF12

ACTIVATE MSDIALOG oDlgF12 Centered
SetKey(VK_F4,bKey4)
SetKey(VK_F12,bKey12)
      
RestArea(aArea)

Return dDataAjus   



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MMonta    ³ Autor ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de montabem do Cabecalho e da montabem da MsGetDados  ³±±
±±³          ³(aHeader / aCols ) do Contrato de Venda                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: [2] Visualizacao                                      ³±±
±±³          ³       [3] Inlcusao                                          ³±±
±±³          ³       [4] Alteracao                                         ³±±
±±³          ³       [5] Exclusao                                          ³±±
±±³          ³       [6] Reajuste do Contrato                              ³±±
±±³          ³       [7] Exportar p/ Excel                                 ³±±
±±³          ³       [8] Aprovar/Encerrar                                  ³±±
±±³          ³       [9] Gerar Pedido                                      ³±±
±±³          ³ExpB2: CodeBlock a ser avaliado para o retorno da funcao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1: Conforme indicado pelo CodeBlock em ExpB2, quando o  ³±±
±±³          ³ este indicar .F., a execucao da funcao sera interrompida.   ³±±
±±³          ³ Para o codeblock sera informado o alias do SZ6.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo atualizar as variaveis de uti- ³±±
±±³          ³lizada na modelo 2.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MMonta(nOpc,bBlock,aParam)

Local aArea    := GetArea()
Local lRetorno := .T.
Local nUsado   := 0
Local nX       := 0
Local _xPrcVen := 0
Local _xPrcRea := 0
Local _xValor  := 0
Local _xQtdVen := 0
Local _xPerRea := 0
Local nY       := 0                    

Local _xMargE   := 0
Local _xMargV   := 0
Local _xMargA   := 0

DEFAULT aParam      := {}            

aHeader:={}
aCols  :={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho - Busca Informacoes do Cabecalho           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if    nOpc =  8       // Aprovacao
	cEspress      :=  "< F4 > Consulta Estoque da Malha Logistica"+SPACE(10)+;
	"< F5 > Legenda status do Produto"+SPACE(10)+;
	"< F6 > Aprovar ou Encerrar Tudo"
	
ElseIF nOpc = 6       // Reajuste do Contrato
	cEspress      :=  "< F4 > Consulta Estoque da Malha Logistica"+SPACE(10)+;
	"< F5 > Legenda status do Produto"+SPACE(10)+;
	"< F12 > Filtra itens de Reajuste"
Else
	
	cEspress      :=  "< F4 > Consulta Estoque da Malha Logistica"+SPACE(10)+;
	"< F5 > Legenda status do Produto"
	
Endif


if  nOpc = 3
	
	cNum          := GetSx8Num("SZ6","Z6_NUM")
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTOp())   /// Dbseek(xFilial("SA1")+cCliente)
	
	cCliente      := SA1->A1_COD
	cLoja         := SA1->A1_LOJA
	cNome         := SA1->A1_NREDUZ
	cCondpag      := SA1->A1_COND
	
	dDtElabo      := dDataBase
	dDtValid      := dDataBase
	dDtAprov      := cTod("")
	dDtEncer      := ctod("")
	cTarnsp       := CriaVar("Z6_TRANSP")
	cVend1        := CriaVar("Z6_VEND1")
	CJ_X_ST_CI    := "Industria"
	nDolar1       := 0
	nDolar2       := 0 
   cPedCli       := CriaVar("Z6_COTCLI")
   cContCli      := CriaVar("Z6_CONTCLI")
	
Else
	
	
	DbSelectArea("SA1")
	SA1->(Dbseek(xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA))
	
	cNum          := SZ6->Z6_NUM
	cCliente      := SZ6->Z6_CLIENTE
	cLoja         := SZ6->Z6_LOJA
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
	nDolar1       := SZ6->Z6_DOLUTIL
	nDolar2       := SZ6->Z6_DOLCLIE 
   cPedCli       := SZ6->Z6_COTCLI
   cContCli      := SZ6->Z6_CONTCLI

Endif


DEFAULT bBlock   := {|| .T.}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o MsGetDados - Busca Informacoes do MsGetDados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem do aHeader a partir dos campos SX3.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Opcoes no nOpc      ³
//³                    ³
//³2 - Visualizar      ³
//³3 - Incluir         ³
//³4 - Alterar         ³
//³5 - Excluir         ³
//³6 - Reajustar       ³
//³7 - Exportar/Excel  ³
//³8 - Aprovar/Encerrar³
//³9 - Gerar Pedido    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Campos que nao poderam aparecer na MsGetDados.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Acols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Todo o tratamento abaixo com a aheader e decorrente do cliente nao tratar separadamente
// a definicao do contrato e a geracao do pedido ou seja ou cliente deveria ter um
// cadastro para os itens definidos no pedido e um para os itens enviados em contrato
// mas nao houve interesse por parte do cliente em ter este segundo cadastro logo ajustamos
// a aheader de forma que nao tenhamos que trabalhar com um segundo cadastro de itens enviados ao
// cliente.
// Poderiamos ter separado os aHedear para cada situacao mas depois seria dificil
// indentificar os campos que estao atuando em cada um dos casos por este motivo utilizamos
// os IF'S.

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("Z6_ITEM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_STATUS")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_REFER")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_SUFIX")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_MARCA")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_ORIGEM")          //CDTR / IN NACIONAIS OU IMPORTADOS
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,/*X3_VALID*/,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_DESCRI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
If  nOpc = 9
	DbSeek("Z6_S_REFER")
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("Z6_S_SUFIX")
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("Z6_S_MARCA")
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif


DbSeek("Z6_UM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})


// Foi necessario criar dois campos para esta situacao pois o Z6_QTDENV e alteravel enquanto o
// Z6_QTDVEN nao poderia ser alterado.
If nOpc  = 9
	DbSeek("Z6_QTDENV")   // Quantidade a Enviar no Pedido
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Else
	DbSeek("Z6_QTDVEN")   // Quantidade fechada no Contrato
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif
// Quantidade ja Enviada
DbSeek("Z6_QTDFIM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("Z6_X_CTPAD")      // Custo Stander nao e Alterado.
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("Z6_CTSTD")        // Custo Stander
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("Z6_FOB")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Campos que nao poderam aparecer na MsGetDados.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//  Inclusao / Visualizar / Alteracao / Exclusao / Aprovacao
if  nOpc = 3 .or. nOpc = 2 .or. nOpc = 4 .or. nOpc = 5 .or. nOpc = 8 .or. nOpc = 6
	DbSeek("Z6_PRUNIT")     // Preco de Venda
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif


DbSeek("Z6_PRCVEN")         //  Preco Sugerido
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_VALOR")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})


//  Reajuste de Precos
If  nOpc = 6
	DbSeek("Z6_PRCREA")
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("Z6_PERREA")
    AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif


DbSeek("Z6_X_MARGE")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_MARGV")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_MARGA")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_PQR")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_NEOIL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_XYZ")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_123")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_NC_IM")          //CDTR / IN NACIONAIS OU IMPORTADOS
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_ABC")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_LMN")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_GIROQ")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_CONSM")
AADD(aHeader,{"Consumo Medio Mes",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_CB_MALH")   // Sera utilizado somente como visual para demonstrar a cober Inst Malha em dias
AADD(aHeader,{"Cobert.Inst.Malha em Dias",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_CB_DISP")   // Sera utilizado somente como visual para demonstrar a cober Inst Dispo em dias
AADD(aHeader,{"Cobert.Inst.Disp. em Dias",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_LT")      
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_IPI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_ICM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_PIS")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_COFIN")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_CPMF")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_TES")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_CLASFIS")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_POSIPI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,"@!",X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

// Aprovacao / Encerramento
iF nOpc  = 8
	DbSeek("Z6_DTAPROV")
	AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
	DbSeek("Z6_DTENCER")
	AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif

DbSeek("Z6_PRODCLI")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_RESER")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_ITEM0")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_X_DTENT")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_OBSERVA")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("Z6_PRODUTO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

iF  nOpc = 9
	DbSeek("Z6_S_SKU")
	AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Endif

DbSeek("Z6_LOCAL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_LOCNOME")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

DbSeek("Z6_DTELABO")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_DTVALID")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_SIMIL")           //"S.G.Similar  "
AADD(aHeader,{"Similaridade"   ,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_COD")              //Sera utilizado somente como visual para demostrar o codigo do Produto"
AADD(aHeader,{"EIS"           ,X3_CAMPO,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})

nUsado:=Len(aHeader)

For ny:= 1 to len(aHeader)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Campos que  poderam ser Alterados na MSGetDados.      ³
	//³ de uma forma Visual.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//  Inclusao / Alteracao
	If  (nOpc = 3 .or. nOpc = 4) .and.;
		alltrim(aHeader[ny][2]) $ "Z6_DESCRI"
		//"Z6_TES|Z6_CLASFIS|Z6_DTLABO|Z6_DTVALID|Z6_PRODCLI|Z6_LOCAL|Z6_DESCRI|Z6_OBSERVA"
		//  alltrim(aHeader[ny][2]) $ "Z6_UM|Z6_QTDVEN|Z6_PRCVEN|Z6_TES|Z6_DTLABO|Z6_DTVALID|Z6_PRODCLI"
  	   aHeader[ny][1] :=  aHeader[ny][1]+"(*)"
	   AADD(aAltGr,aHeader[ny][2]) 
      If alltrim(aHeader[ny][2]) $  "Z6_DESCRI"
          aHeader[ny][6] :=  "U_VALDESC(.T.)"
      Endif
	Endif
	//  Reajuste de Precos
	if  (nOpc = 6 ) .and. alltrim(aHeader[ny][2])$"Z6_PERREA|Z6_OBSERVA"
		AADD(aAltGr,aHeader[ny][2])
		aHeader[ny][1] :=  aHeader[ny][1]+"(*)"
		aHeader[ny][6] :=  "U_VREAJUSTE(n,.T.,.T.)"
	Endif
	// Aprovacao/Encerramento
	if nOpc  = 8  .and. alltrim(aHeader[ny][2])$ "Z6_DTAPROV|Z6_DTENCER|Z6_OBSERVA"
		AADD(aAltGr,aHeader[ny][2])
		aHeader[ny][1] := aHeader[ny][1]+"(*)"
        If alltrim(aHeader[ny][2]) $  "Z6_DTAPROV"
           aHeader[ny][6] :=  "U_VAPROVA(n,.T.)"
        Endif
	Endif
	// Geracao do Pedido
	if nOpc  = 9  .and. alltrim(aHeader[ny][2])$ "Z6_QTDENV|Z6_PRCVEN|Z6_TES|Z6_CLASFIS|Z6_LOCAL"
		AADD(aAltGr,aHeader[ny][2])
		aHeader[ny][1] :=  aHeader[ny][1]+"(*)"
		aHeader[ny][6] :=  "U_VQTDENV(.T.)"
	Endif
	
Next


If ( nOpc <> 3 .and. nOpc <> 9 .and. nOpc <> 6 )  // Inclusao e Geracao de Pedido e Reajuste.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a gem do aCols baseado no aHeader.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(1))
	SZ6->(DbSeek(xFilial("SZ6")+cNum+cCliente+cLoja))
	While !SZ6->(Eof()) .And.;
   	      (xFilial("SZ6")+cNum+cCliente+cLoja) = SZ6->(Z6_FILIAL+Z6_NUM+Z6_CLIENTE+Z6_LOJA)
		
		If ( Eval(bBlock,"SZ6") .And. If(nOpc<>2,SoftLock("SZ6"),.T.) )
			aadd(aCols,Array(nUsado+1))
			aCols[Len(aCols)][nUsado+1] := .F.

			For nX := 1 to Len(aHeader)
				If substr(aHeader[nX][02],1,2) = "Z6"
					If ( aHeader[nX][10] <> "V" .And. aHeader[nX][08] <> "M")
						aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
					Else
						If ( aHeader[nX][08] <> "M" )
							aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2],.T.)
						Else
							aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
						EndIf
					EndIf
				Endif

			Next nX
			
		Else
			lRetorno := .F.
			Exit
		EndIf
		dbSelectArea("SZ6")
		SZ6->(dbSkip())
	EndDo
	
	
ElseIf  nOpc = 6                   // Reajuste
	           
	// Efetua o filtro por este motivo esta separada esta etapa.
	
	_xPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"}) // Preco sem Reajuste
	_xPrcRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCREA"}) // Preco Reajustado
	_xPerRea := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PERREA"}) // Percentual de Reajuste
	_xValor  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})  // Valor Total Reajustado
	_xQtdVen := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"}) // Quantidade Contrato
	
	_xMARGE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	_xMARGV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	_xMARGA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz a montagem do aCols baseado no aHeader.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(1))
	SZ6->(MsSeek(xFilial("SZ6")+cNum+cCliente+cLoja))
	While !SZ6->(Eof()) .And.;
   	      (xFilial("SZ6")+cNum+cCliente+cLoja) = SZ6->(Z6_FILIAL+Z6_NUM+Z6_CLIENTE+Z6_LOJA)
		
		If SZ6->Z6_STATUS $ "N|E"
			SZ6->(DBSKIP())
			LOOP
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa Filtro de Acordo com as Perguntas.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		IF !DbSeek(xFilial("SB1")+SZ6->Z6_PRODUTO)
			dbSelectArea("SZ6")
			SZ6->(dbSkip())
			Loop
		Else
			
			// Os Parametros abaixos sao gerados no programa de origem da chamada
			// no caso do reajuste e no MFATC08.PRW
			
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


            //!(EmptY(aParam[05]) .and. aParam[05] != SB1->B1_X_SIMIL) .OR. (!EmptY(aParam[06])	.and. aParam[06] != SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10) .OR. (aParam[09] <  SB1->B1_FABRIC .and.	aParam[10] >  SB1->B1_FABRIC) .or.  (aParam[11] <  SB1->B1_ORIGEM .and.	aParam[12] >  SB1->B1_ORIGEM))
			  
			
			if Len(aParam) != 0
               if  (!EmptY(aParam[05]) .and. aParam[05] != SB1->B1_X_SIMIL) .or.;
				   (!EmptY(aParam[06])	.and. aParam[06] != SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)) .or.;
				   (!EmptY(aParam[09])	.and. aParam[09] != SB1->B1_X_MARCA) .or.;
				   (aParam[11] >  SB1->B1_ORIGEM .or.	aParam[12] <  SB1->B1_ORIGEM)
					
					dbSelectArea("SZ6")
					SZ6->(dbSkip())
					Loop
				Endif
			Endif
		Endif
		
		If ( Eval(bBlock,"SZ6") .And. If(nOpc<>2,SoftLock("SZ6"),.T.) )

			aadd(aCols,Array(nUsado+1))
			aCols[Len(aCols)][nUsado+1] := .F.
			
			For nX := 1 to Len(aHeader)
				If substr(aHeader[nX][02],1,2) = "Z6"
					If ( aHeader[nX][10] <> "V" .And. aHeader[nX][08] <> "M")
						aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
					Else
						If ( aHeader[nX][08] <> "M" )
							aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2],.T.)
						Else
							aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
						EndIf
					EndIf

				Endif
			Next nX
			
		Else
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz a montagem do aCols baseado no aHeader.                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			lRetorno := .F.
			Exit
		EndIf
		dbSelectArea("SZ6")
		dbSkip()
	EndDo
	
Else     // Inclusao
	
	aCols := {}
	aadd(aCols,Array(nUsado+1))
	aCols[1][nUsado+1] := .F.
	For nX := 1 To nUsado
		aCols[1][nX] := CriaVar(aHeader[nX][2],.T.)
		If ( Trim(aHeader[nX][2]) == "Z6_ITEM" )
			aCols[1][nX] := "01"
		EndIf
		If ( Trim(aHeader[nX][2]) == "Z6_OBSERVA" )
			aCols[1][nX] := ""
		EndIf
	Next nX
	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimentacao dos campos Virtuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nY:= 1 to Len(Acols)
    U_B1VIRTUAL(aCols,aHeader,nY)
Next nY


RestArea(aArea)
Return(lRetorno)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MGrava    ³Autor  ³                       ³ Data ³06.11.2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de atualizacao da tabela de Contrato de Venda         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto da GetDados                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: nOpcao sendo:                                         ³±±
±±³          ³       [1] Inclusao                                          ³±±
±±³          ³       [2] Alteracao                                         ³±±
±±³          ³       [3] Exclusao                                          ³±±
±±³          ³ExpC2: Numero da Contrato de Venda                           ³±±
±±³          ³ExpC3: Codigo do Solicitante                                 ³±±
±±³          ³ExpD4: Loja                                                  ³±±
±±³          ³ExpC5: Data                                                  ³±±
±±³          ³ExpC6: Condicoes de Pagamento                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo efetuar a validacao da solici- ³±±
±±³          ³tacao de compras para a rotina de atualizacao da Contrato    ³±±
±±³          ³de Venda.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MGrava(nOpcao,cNum,cCliente,cLoja,dDtElabo,dDtValid,dDtAprov,dDtEncer,cCondpag,cVend1,cTransp,nFrete,nDolar1,nDolar2)

Local aArea 	:= GetArea()
Local aStru     := SZ6->(dbStruct())
Local aRegistro := {}
Local lQuery    := .F.
Local lDeleted  := .F.
Local cQuery    := ""
Local cMayCode	:= ""
Local cOldNum   := cNum
Local cAliasSZ6 := "SZ6"
Local nX        := 0
Local nY        := 0
Local cItem     := "00"


If ( nOpcao == 1 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Consistir o numero da Contrato de Venda                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Empty(cNum) )
		cNum := NextNumero(cAlias,1,"Z6_NUM",.F.,cNum)	
	EndIf
	If ( INCLUI )
		cMayCode := "SZ6"+xFilial("SZ6")+cNum
		dbSelectArea("SZ6")
		SZ6->(dbSetOrder(1))
		While ( MsSeek(xFilial("SZ6")+cNum) .Or. !MayIUseCode(cMayCode) )
			  //cNum       := GetSx8Num("SZ6","Z6_NUM")
			  cNum     := Soma1(cNum,Len(cNum))
			  cMayCode := "SZ6"+xFilial("SZ6")+cNum
		EndDo
	EndIf
	If ( cNum != cOldNum )
		HELP(" ",1,"NUMSEQ",,cOldNum,4,15)
	EndIf
Else 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Estornar os valores acumulados da Contrato de Venda                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ6")
	SZ6->(dbSetOrder(1))
	#IFDEF TOP
		If ( TcSrvType()<>"AS/400" )
			lQuery 		:= .T.
			cAliasSZ6	:= "MGRAVA"
			cQuery := "SELECT SZ6.*,R_E_C_N_O_ SZ6RECNO "
			cQuery += "FROM "+RetSqlName("SZ6")+"(NOLOCK) SZ6 "
			cQuery += "WHERE SZ6.Z6_FILIAL='"+xFilial("SZ6")+"' AND "
			cQuery += "SZ6.Z6_NUM='"+cNum+"' AND "
			cQuery += "SZ6.D_E_L_E_T_<>'*' "
			cQuery += "ORDER BY "+SqlOrder(SZ6->(IndexKey()))
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ6,.T.,.T.)
			For nX := 1 To Len(aStru)
				If ( aStru[nX][2] <> "C" .and. alltrim(aStru[nX][1])$cQuery)
					TcSetField(cAliasSZ6,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
				EndIf
			Next nX
		Else
	#ENDIF

	MsSeek(xFilial("SZ6")+cNum)

	#IFDEF TOP
		EndIf
	#ENDIF	
	
	
	While ( !Eof() .And. (cAliasSZ6)->Z6_FILIAL == xFilial("SZ6") .And.;
		(cAliasSZ6)->Z6_NUM == cNum )
		AADD(aRegistro,If(lQuery,(cAliasSZ6)->SZ6RECNO,SZ6->(RecNo())))
		//MaAvalSC(cAliasSZ6,2)
		dbSelectArea(cAliasSZ6)
		dbSkip()
	EndDo
	
	If ( lQuery ) 
		If Select(cAliasSZ6)>0
			dbSelectArea(cAliasSZ6)
			(cAliasSZ6)->(dbCloseArea())
		Endif	
	EndIf 
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a atualizacao da tabela de Contrato de Venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ6")
SZ6->(dbSetOrder(1))
For nX := 1 To Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifico se a linha foi deletada.                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(aCols[nX,Len(aCols[nX])]) == "L"
		lDeleted := aCols[nX,Len(aCols[nX])]
	EndIf

	If ( nOpcao == 3 )
		lDeleted := .T.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciono no registro para alteracao/exclusao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If ( Len(aRegistro) >= nx )
		dbSelectArea("SZ6")
		SZ6->(dbGoto( aRegistro[nx] ))
		RecLock("SZ6",.F.)
	Else
		If ( !lDeleted )
			RecLock("SZ6",.T.)
		EndIf
	EndIf

    cItem := Soma1(cItem) // Novo Item

	If ( !lDeleted )                


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dados padroes da Contrato de Venda              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		SZ6->Z6_FILIAL  := xFilial("SZ6")
		SZ6->Z6_NUM     := cNUM
		SZ6->Z6_CLIENTE := cCLIENTE 
		SZ6->Z6_LOJA    := cLOJA	
      SZ6->Z6_DTELABO := dDtElabo
      SZ6->Z6_DTVALID := dDtValid
      //SZ6->Z6_DTAPROV := dDtAprov
      //SZ6->Z6_DTENCER := dDtEncer
		SZ6->Z6_CONDPAG := cCONDPAG		
      SZ6->Z6_NOMCLI  := SA1->A1_NREDUZ  
      SZ6->Z6_X_ST_CI := Iif(UPPER(CJ_X_ST_CI) = "INDUSTRIA","I","C")
      SZ6->Z6_VEND1   := cVend1
      SZ6->Z6_CONDPAG := cCondpag
      SZ6->Z6_TRANSP  := cTransp
      SZ6->Z6_X_FRETE := nFrete
      SZ6->Z6_TRANSP  := cTransp
      SZ6->Z6_X_FRETE := nFrete
      SZ6->Z6_DOLUTIL := nDolar1
      SZ6->Z6_DOLCLIE := nDolar2  
      SZ6->Z6_COTCLI := cPedCli
      SZ6->Z6_CONTCLI:= cContCli
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza dados do corpo da SC selecionados pelo cliente  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nY := 1 to Len(aHeader) 
			If substr(aHeader[nY][02],1,2) = "Z6" 
               if aHeader[nY][8] = "N" .and. aCols[nX][nY] = nil
                  aCols[nX][nY]:=0 
               Endif
			      If ( aHeader[nY][10] <> "V" )  
				      SZ6->(FieldPut(FieldPos(Trim(aHeader[nY][2])),aCols[nX][nY]))
			      EndIf 
			Endif
		Next nY 
		
		SZ6->Z6_ITEM    := cItem 
		
        // Efetuo a gravacao do produto do cliente na tabela SA7 que e apenas um 
        // facilitador de digitacao o programa e chamada estao no MFATC02
		  // U_CodCliente(SZ6->Z6_CLIENTE,SZ6->Z6_LOJA,SZ6->Z6_PRODUTO,SZ6->Z6_PRODCLI,.T.)

	Else

		If ( Len(aRegistro) >= nx )
			SZ6->(dbDelete())
		EndIf

	EndIf
	SZ6->(MsUnLock())

Next nX



RestArea(aArea)
Return .T.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | B1VIRTUAL³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a alimentacao dos campos Virtuais.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function B1VIRTUAL(aCols,aHeader,nPosicao)

Local nB1_PosIPI  := 0
Local nB1_ORIGEM  := 0
Local nB1_X_NC_IM :=0
Local nB1_X_PQR   := 0
Local nB1_X_NEOIL := 0
Local nB1_X_XYZ   := 0
Local nB1_X_123   := 0
Local nB1_X_ABC   := 0
Local nB1_X_LMN   := 0
Local nB1_X_GIROQ := 0
Local nB1_X_CONSM := 0
Local nZ6_CB_MALH := 0
Local nB1_X_SIMIL := 0
Local nB1_COD     := 0
Local nZ6_LOCAL   := 0
Local nZ6_LOCNOME := 0
Local nT_SMALHA   := 0
Local aTrataEis   := {}
Local nB1_X_LT    := 0
Local nIcSldMalh  := 0  //  Malha  (Disponivel + Previsto PC)
Local nIcSldDispo := 0  //  Malha  (Saldo Disponivel)
Local nB1_DESC    := 0

nB1_POSIPI  := aScan(aHeader,{|x| Trim(x[2])=="B1_POSIPI"})
nB1_ORIGEM  := aScan(aHeader,{|x| Trim(x[2])=="B1_ORIGEM"})
nB1_X_NC_IM := aScan(aHeader,{|x| Trim(x[2])=="B1_X_NC_IM"})
nB1_X_PQR   := aScan(aHeader,{|x| Trim(x[2])=="B1_X_PQR"})
nB1_X_NEOIL := aScan(aHeader,{|x| Trim(x[2])=="B1_X_NEOIL"})
nB1_X_XYZ   := aScan(aHeader,{|x| Trim(x[2])=="B1_X_XYZ"})
nB1_X_123   := aScan(aHeader,{|x| Trim(x[2])=="B1_X_123"})
nB1_X_ABC   := aScan(aHeader,{|x| Trim(x[2])=="B1_X_ABC"})
nB1_X_LMN   := aScan(aHeader,{|x| Trim(x[2])=="B1_X_LMN"})
nB1_X_GIROQ := aScan(aHeader,{|x| Trim(x[2])=="B1_X_GIROQ"})
nB1_X_CONSM := aScan(aHeader,{|x| Trim(x[2])=="B1_X_CONSM"})
nZ6_CB_MALH := aScan(aHeader,{|x| Trim(x[2])=="Z6_CB_MALH"})
nZ6_CB_DISP := aScan(aHeader,{|x| Trim(x[2])=="Z6_CB_DISP"})
nB1_X_LT    := aScan(aHeader,{|x| Trim(x[2])=="B1_X_LT"})
nProduto    := aScan(aHeader,{|x| Trim(x[2])=="Z6_PRODUTO"})
nB1_X_SIMIL := aScan(aHeader,{|x| Trim(x[2])=="B1_X_SIMIL"})
nB1_COD     := aScan(aHeader,{|x| Trim(x[2])=="B1_COD"})
nZ6_LOCAL   := aScan(aHeader,{|x| Trim(x[2])=="Z6_LOCAL"})
nZ6_LOCNOME := aScan(aHeader,{|x| Trim(x[2])=="Z6_LOCNOME"})

// Preenchimento da Parte do Acols ON-LINE


// Cadastro de Almoxarifados validos
dbSelectArea("SZB")
SZB->(dbSetOrder(1))
SZB->(DbSeek(xFilial("SZB")+aCols[nPosicao][nZ6_LOCAL]))


dbSelectArea("SB1")
SB1->(dbSetOrder(1))
If  SB1->(DbSeek(xFilial("SB1")+aCols[nPosicao][nProduto]))
	
	
	//
	// Define Saldos em estoque
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Parametros : Codigo do Produto                                            ³
	//³                                                                          ³
	//³Retorna:                                                                  ³
	//³                                                                          |
	//³[01]     MALHA                                                            ³
	//³[01][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[01][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[01][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[01][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[01][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[01][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[01][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[01][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[01][09] B2_CLASSIF // Quant.a Classificar                                ³
	//³[01][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³[01][11] B2_QATU    // Fisico                                             ³
	//³                                                                          |
	//³[02]     MATRIZ                                                           ³
	//³[02][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[02][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[02][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[02][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[02][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[02][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[02][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[02][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[02][09] B2_CLASSIF // Quant.a Classificar                                ³
	//³[02][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³[02][11] B2_QATU    // Fisico                                             ³
	//³                                                                          |
	//³                                                                          |
	//³[03]     FILIAL                                                           ³
	//³[03][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[03][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[03][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[03][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[03][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[03][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[03][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[03][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[03][09] B2_CLASSIF // Quant.a Classificar                                ³
	//³[03][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³[03][11] B2_QATU    // Fisico                                             ³
	//³                                                                          |
	//³                                                                          |
	//³[04]     CONSIGNADO                                                       ³
	//³[04][01] SaldoSb2() // Saldo Disponivel                                   ³
	//³[04][02] B2_QNPT    // Controla Estoque  - Nossa em Poder de Terceiros    ³
	//³[04][03] B2_QTNP    // Controla Estoque  - Terceiros em Nosso Poder       ³
	//³[04][04] B2_QTER    // Nao Controla Est. - Saldo em Poder de Terceiros    ³
	//³[04][05] B2_RESERVA // Quantidade reservada - Pedido de Venda             ³
	//³[04][06] B2_QEMP    // Quantidade Empenhada                               ³
	//³[04][07] B2_SALPEDI // Prevista entrar no estoque (via Compras ou Op)     |
	//³[04][08] B2_QPEDVEN // Quant.de Pedidos de Venda nao Lib.p/Faturar        ³
	//³[04][09] B2_CLASSIF // Quant.a Classificar                                ³
	//³[04][10] SaldoSb2() + B2_SALPEDI // Disponivel + Previsto para entrar     ³
	//³[04][11] B2_QATU    // Fisico                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSaldoEst := U_SaldoSb2(aCols[nPosicao][nProduto])  // MFATC12.PRW
	
	// Deve ser igual ao saldo encontrado na consulta de produto
	T_SMALHA    :=  aSaldoEst[1][11]+; // Malha     = Fisico           (Malha) +
	aSaldoEst[4][11]+; //              Fisico           (Consignado) +
	aSaldoEst[1][7]+;  //              Transito         (Malha) +
	aSaldoEst[4][7]    //               Transito         (Consignado)
	//aSaldoEst[1][9]+;  //              Classificar      (Malha) +
	//aSaldoEst[4][9]+;  //              Classificar      (Consignado) +
	
	//
	// Define Codigo Eis
	//
	aTrataEis := U_TrataEIS(SB1->B1_COD)       // (Mfatc03)
	
	
	// Estes campos sao alimentados aqui devido serem virtuais
	aCols[nPosicao][nB1_POSIPI]  := IF(VAL(SB1->B1_POSIPI)<>0,SB1->B1_POSIPI,"NAO DETER.")
	aCols[nPosicao][nB1_ORIGEM]  := SB1->B1_ORIGEM
	aCols[nPosicao][nB1_X_NC_IM] := SB1->B1_X_NC_IM
	aCols[nPosicao][nB1_X_PQR]   := SB1->B1_X_PQR
	aCols[nPosicao][nB1_X_NEOIL] := SB1->B1_X_NEOIL
	aCols[nPosicao][nB1_X_XYZ]   := SB1->B1_X_XYZ
	aCols[nPosicao][nB1_X_123]   := SB1->B1_X_123
	aCols[nPosicao][nB1_X_ABC]   := SB1->B1_X_ABC
	aCols[nPosicao][nB1_X_LMN]   := SB1->B1_X_LMN
	aCols[nPosicao][nB1_X_GIROQ] := SB1->B1_X_GIROQ
	aCols[nPosicao][nB1_X_CONSM] := SB1->B1_X_CONSM
	aCols[nPosicao][nZ6_CB_MALH] := T_SMALHA  / SB1->B1_X_CONSM
	aCols[nPosicao][nB1_X_SIMIL] := SB1->B1_X_SIMIL
	aCols[nPosicao][nB1_COD]     := aTrataEis[1,3]
	
	aCols[nPosicao][nB1_X_LT]    := SB1->B1_X_LT
	
	nIcSldMalh   := aSaldoEst[01][10]  //  Malha  (Disponivel + Previsto PC)
	nIcSldDispo  := aSaldoEst[02][01]  //  Matriz (Disponivel)
	// Estou utilizando este campo para guardar a cobertura em
	// funcao de se tratar de um campo temporario no acols
	aCols[nPosicao][nZ6_CB_MALH] := nIcSldMalh  / SB1->B1_X_CONSM  //(Saldo da Malha / Consumo Medio )
	aCols[nPosicao][nZ6_CB_DISP] := nIcSldDispo / SB1->B1_X_CONSM  //(Saldo da Malha / Consumo Medio )
	aCols[nPosicao][nZ6_LOCNOME] := GetAdvFval("NNR","NNR_DESCRI",xFilial("NNR")+aCols[nPosicao][nZ6_LOCAL], 1)


Endif


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC06   ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Itens do Contrato para Geracao do Pedido                    º±±
±±º          ³Chamado no MFATC05. (Geracao de Pedidos atraves de Contrato)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VAPROVA(nLin,lValid)
Local lRet       := .T.
Local _MV_PRODTMP:= GeTMv("MV_PRODTMP")
Local nDtaprov   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_DTAPROV"})
Local nProduto   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
Local nStatus    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_STATUS"})
Local nDtEncer   := aScan(aHeader,{|x| Alltrim(x[2])=="Z6_DTENCER"})

Local dDtAprov   := IIf(lValid .and. TYPE("Z6_DTAPROV")<>"U",M->Z6_DTAPROV,aCols[nLin][nDtaprov]) 
Local dDtEncer   := aCols[nLin][nDtEncer] 
Local cProduto   := aCols[nLin][nProduto] 
Local cStatus    := aCols[nLin][nStatus]


// 1. Encerrado sai do sistema nao efetua nenhuma alteracao
IF  !EMPTY(dDtEncer)

	Aviso("ATENCAO", "O item nao pode ter a data de aprovacao alterada em funcao de estar Encerrado "+;
	"Produto  cod."+cProduto,{"&Ok"})
	IF lValid
		M->Z6_DTAPROV        := aCols[nLin][nDtaprov]
		lRet := .t.			             // .t. somente emitira o aviso e atualiza a variavel
	else
		lRet := .f.			             // .f. limpa o acols e nao grava as informacoes
	Endif

Else

    // 2. Comeca a avaliar se e possivel alterar a data de aprovacao.
   
    // 2.1. Avaliar se nao e um produto temporario pois nao pode ser aprovado.
	IF  Alltrim(cProduto) $ ALLTRIM(_MV_PRODTMP)
		Aviso("ATENCAO", "O item nao pode ser aprovado em funcao de se tratar "+;
		"do produto temporario cod."+cProduto,{"&Ok"})
		IF TYPE("Z6_DTAPROV")<>"U" .and. lValid
			M->Z6_DTAPROV        := CTOD("")
			lRet := .t.			             // .t. somente emitira o aviso e limpara o conteudo da variavel
		else
			lRet := .f.			             // .f. limpa o acols e nao grava as informacoes
		Endif
		aCols[nLin][nDtaprov]:=CTOD("")
	Endif

    
    // 2.2. Analiso se: 
    //                  A) Nenhuma quantidade  foi fornecida ainda;
    //                  B) Nao foi barrado anteriormente
    If  !(aCols[nLin][nStatus] $ "N|A")  .and. lRet
		Aviso("ATENCAO", "O item nao pode ter sua Data de Aprovacao  alterada  em funcao de ja ter "+;
		"ocorrido fornecimento deste produto cod."+cProduto,{"&Ok"})
       lRet:= .f.
    Endif


	If lRet
	   IF EMPTY(dDtAprov)
	      aCols[nLin][nStatus] :="N"
	   ELSE
	      aCols[nLin][nStatus] :="A"
	   Endif
	Endif
	
Endif

if Type("ogetdad") != "U"
   ogetdad:obrowse:Refresh()        // Atualiza a GetDados do Orcamento.
Endif

Return(lRet) 
