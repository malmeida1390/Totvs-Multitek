#INCLUDE "Fivewin.ch"
#INCLUDE "SIGA.ch"
#Include "COLORS.CH"
#Include "FONT.CH"                          
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MFATC09  บ Autor ณ                    บ Data ณ  31/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Controla Parametros do Sistema                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณ Matriz com as Formas de Pagamento                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MFATC09()    

Local aGetArea        := GetArea()
Local aParam          := {} 
Local nOpcA           := 0 
Local aSizeAut		  := MsAdvSize(,.F.)
Local aObjects		  := {}
Local aInfo 		  := {}
Local aPosGet		  := {}
Local aPosObj		  := {}  

Private aHeader   := {}
Private aCols     := {}
Private nopc      := 3
//Private aRotina   := {{,,0,4}}
PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private oDlg,oGet

Private _nPos_Atu := 0
Private _nPos_Par := 0
Private _nPos_Pro := 0
Private _nPos_Con := 0
Private _nPos_Des := 0

Private cCadastro := "Parametros"                                     


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณParametros que seram manuseados nesta rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aParam ,{"Simulador de Precos","MV_TXPIS"  })
AADD(aParam ,{"Simulador de Precos","MV_TXCOFIN"}) // MV_COFINS1  ??
AADD(aParam ,{"Simulador de Precos","MV_CPMF"   })
AADD(aParam ,{"Simulador de Precos","MV_FRETEC" })
AADD(aParam ,{"Simulador de Precos","MV_JURMES" })
AADD(aParam ,{"Simulador de Precos","MV_EST2ICM" })
AADD(aParam ,{"Simulador de Precos","MV_BLOQRET"})
AADD(aParam ,{"Simulador de Precos","MV_ALMCONS"})
AADD(aParam ,{"Simulador de Precos","MV_TIPCAL" })
AADD(aParam ,{"Simulador de Precos","MV_COMICAL"})
AADD(aParam ,{"Simulador de Precos","MV_CODCLIE"})
AADD(aParam ,{"Simulador de Precos","MV_MAXREGI"})
AADD(aParam ,{"Simulador de Precos","MV_MCCOMIS"})
AADD(aParam ,{"Orcamento Validade ","MV_DVALORC"})
AADD(aParam ,{"Validade Proposta  ","MV_DTPROPO"})

AADD(aParam ,{"Geracao do Pedido  ","MV_PRODTMP"})
AADD(aParam ,{"Contrato           ","MV_DIRTXT" })
AADD(aParam ,{"Almox. Fechados    ","MV_ARMFECH"})
AADD(aParam ,{"PGMM - Mod. Estoque","MV_PGMPERI"})
AADD(aParam ,{"PGMM - Mod. Estoque","MV_PGMGIRO"})
AADD(aParam ,{"PGMM - Mod. Estoque","MV_TMPREPR"})
AADD(aParam ,{"PGMM - Mod. Estoque","MV_ALMFECH"})
AADD(aParam ,{"PGMM - Grava  Giro ","MV_GRGIRO" })
AADD(aParam ,{"PGMM - Cod.Comprador","MV_CODCOMP" })

//Anderson - 30/05/2005  
AADD(aParam ,{"ACD - Almox.e Endereco Vendas","MV_ALMX01" })
AADD(aParam ,{"ACD - Almox.e Endereco Divergentes","MV_ALMX02" }) 
AADD(aParam ,{"ACD - Almox.e Endereco Divergentes p/ Importacao","MV_ALMX03" }) 
AADD(aParam ,{"ACD - Codigo do TM utilizado na Desmontagem (Entrada)","MV_TMDE" })
AADD(aParam ,{"ACD - Codigo do TM utilizado na Desmontagem (Saida)","MV_TMDS" })
// Fim                                          
//Cleber  Matinez - 25/07/2005  
AADD(aParam ,{"ACD - Serie Nota de Entrada (PADRAO)          ","MV_SERIPAD" })
AADD(aParam ,{"ACD - Fornecedor Nota de Entrada (PADRAO)     ","MV_FORNPAD" })
AADD(aParam ,{"ACD - Almox. Requisicao a ser Transmitido     ","MV_ALMXREQ" })
AADD(aParam ,{"ACD - Almox. Devolucao  a ser Transmitido     ","MV_ALMXDEV" })
AADD(aParam ,{"ACD - Almox. Venda      a ser Transmitido     ","MV_ALMXVDA" })
AADD(aParam ,{"EMISSAO DE NOTA FISCAL                        ","MV_MTKCF" })
// Fim                                          



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriar os campos de cabecalho do oGet        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aHeader,{"Uso"        ,"_cAtu" ,"@!",20,0,"","","C",})
AADD(aHeader,{"Parametro"  ,"_cPar" ,"@!",15,2,"","","C",})
AADD(aHeader,{"Conteudo(*)","_cCon" ,"@!",20,2,"U_ValcPar(.T.)","","C",})
AADD(aHeader,{"Propr."     ,"_cPro" ,"@!",02,0,"","","C",})
AADD(aHeader,{"Descricao"  ,"_cDes" ,"@!",50,2,"","","C",})


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPega posicoes  dos itens no Cabecalho      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nPos_Atu := aScan(aHeader,{|x| AllTrim(x[2])=="_cAtu"})
_nPos_Par := aScan(aHeader,{|x| AllTrim(x[2])=="_cPar"})
_nPos_Pro := aScan(aHeader,{|x| AllTrim(x[2])=="_cPro"})
_nPos_Con := aScan(aHeader,{|x| AllTrim(x[2])=="_cCon"})
_nPos_Des := aScan(aHeader,{|x| AllTrim(x[2])=="_cDes"})



For nY := 1 to len(aParam)

    MontAcols(aParam[nY,1],aParam[nY,2])

Next nY


AAdd( aObjects, { 0,    100, .T., .T. } )
// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
//aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,30,  65,90,120  ,140,155  ,255,280},;
//                                                       {05,30,  80,105,  155,180,  235,265}})

                                                     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao de Fontes para esta janela ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		


oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,"U_ValcPar()","U_ValcPar()",,.F.,{"_cCon"},2)
oGet:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:nMax:=Len(Acols) 

		
ACTIVATE MSDIALOG oDlg ON INIT PAR_BAR(oDlg,{|| nOpcA := 1, oDlg:End()},{||oDlg:End()})
		

if nOpca = 1

   For nY:=1 to Len(acols)
       DbselectArea("SX6")
       If DbSeek(xFilial("SX6")+aCols[nY,_nPos_Par])
          RECLOCK("SX6",.F.)
          Field->X6_CONTEUD := aCols[nY,_nPos_Con]    
          Field->X6_CONTSPA := aCols[nY,_nPos_Con]    
          Field->X6_CONTENG := aCols[nY,_nPos_Con]    
          MsUnlock()
       Endif
   Next nY

Endif

RETURN 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontAcolsบ Autor ณ                    บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua a Inclusao de informacoes no Acols                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontAcols(cDescr,cParam)
Local nLin   := 0
	
dbSelectArea( "SX6" )
dbSetorder(1)
If dbSeek( xFilial("SX6")+cParam)
  
   AADD(aCols,Array(Len(aHeader)+1))
   nLin                        := Len(aCols)
   aCols[nLin,Len(aHeader)+1] := .F.                    // Nao Deletado
   aCols[nLin,_nPos_Atu]               := cDescr                 // Uso
   aCols[nLin,_nPos_Par]               := cParam                 // Parametro
   aCols[nLin,_nPos_Pro]               := SX6->X6_PROPRI         // Propriedade
   aCols[nLin,_nPos_Con]               := SX6->X6_CONTEUD        // Conteudo
   aCols[nLin,_nPos_Des]               := SX6->(X6_DESCRIC +" "+X6_DESC1+" "+X6_DESC2) // Descricao
    
Else
  
   Aviso("ATENCAO", "Favor verificar o parametro "+cParam+" de uso no ("+cDescr+") nao esta cadastrado no SX6.",{"&Ok"})
       
Endif    
    
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValcPar  บ Autor ณ                    บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida o Conteudo do Parametro Digitado                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ValcPar(lValid)
Local  lRet := .T.                      
Local  _nVal_Atu := ""
Local  _nVal_Par := ""
Local  _nVal_Pro := ""
Local  _nVal_Con := ""
Local  _nVal_Des := ""
Local  _cConteudo:= 0
Local  nX        := 0

DEFAULT lValid   := .F.
            

_cVal_Atu :=IIF(lValid .AND. TYPE("M->_cAtu")     <>"U",&("M->_cAtu")   ,aCols[n][_nPos_Atu] )       
_cVal_Par :=IIF(lValid .AND. TYPE("M->_cPar")     <>"U",&("M->_cPar")   ,aCols[n][_nPos_Par] )       
_cVal_Pro :=IIF(lValid .AND. TYPE("M->_cPro")     <>"U",&("M->_cPro")   ,aCols[n][_nPos_Pro] )       
_cVal_Con :=IIF(lValid .AND. TYPE("M->_cCon")     <>"U",&("M->_cCon")   ,aCols[n][_nPos_Con] )       
_cVal_Des :=IIF(lValid .AND. TYPE("M->_cDes")     <>"U",&("M->_cDes")   ,aCols[n][_nPos_Des] )       


DbselectArea("SX6")
DbSeek(xFilial("SX6")+_cVal_Par)
                                         
If SX6->X6_TIPO = "N"  
   
   _cConteudo:= STRTRAN(_cVal_Con,",",".")

   aCols[n][_nPos_Con] := _cConteudo
   M->_cCon            := _cConteudo   

   _cConteudo :=alltrim(aCols[n][_nPos_Con])

   For nX := 1 to Len(_cConteudo)
       If !(Substr(_cConteudo,nX,1) $ "0123456789.")
          Aviso("ATENCAO", "Este parametro e do tipo Numerico, logo somente aceita numeros.",{"&Ok"})
          lRet := .F. 
       Endif
   Next nx    

Endif

if _cVal_Par = "MV_ALMCONS" .and. LEN(ALLTRIM(_cVal_Con)) > 2 
   iF  AT(";",_cVal_Con) = 0
       Aviso("ATENCAO", "Deve ser utilizado < ; >  para separar almoxarifados",{"&Ok"})
       lRet := .F. 
   Endif
Endif   

if _cVal_Par = "MV_ALMFECH" .and. LEN(ALLTRIM(_cVal_Con)) > 2 
   iF  AT(";",_cVal_Con) = 0
       Aviso("ATENCAO", "Deve ser utilizado < ; >  para separar almoxarifados",{"&Ok"})
       lRet := .F. 
   Endif
Endif   

if _cVal_Par = "MV_GRGIRO" 
   If !(alltrim(_cVal_Con) $ ".F.|.T.") 
       Aviso("ATENCAO", "Deve ser utilizado somente < .F. ou .T. > para o parametro",{"&Ok"})
       lRet := .F. 
   Endif
Endif   


Return(lRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณPAR_BAR   ณ Autor ณ                       ณ Data ณ 13.10.03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ EnchoiceBar especifico                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ oDlg: 	Objeto Dialog                                     ณฑฑ
ฑฑณ          ณ bOk:  	Code Block para o Evento Ok                       ณฑฑ
ฑฑณ          ณ bCancel: Code Block para o Evento Cancel                   ณฑฑ
ฑฑณ          ณ nOpc:		nOpc transmitido pela mbrowse                 ณฑฑ
ฑฑณ          ณ aForma: Array com as formas de pagamento                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PAR_BAR(oDlg,bOk,bCancel,nOpc)
Local aUsButtons:= {}
Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

//AADD(aButtons, {"S4WB011N"      , {||U_MFATC03(ACOLS[N][_xProduto])}, "<F4> - Consulta Estoque da Malha Logistica" })	
//AADD(aButtons, {"CARGA"      	, {||U_MFATC06()}	, "Busca Itens do Contrato"})
//AADD(aButtons, {"PRODUTO"    	, {||U_MFATC02()}	, "Substitui Item do Contrato"})
//AADD(aButtons, {"VENDEDOR"    	, {||U_MFATC07(cCliente)}	, "Seleciona Clientes p/ Geracao do Pedido"})

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))
