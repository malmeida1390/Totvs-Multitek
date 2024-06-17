#INCLUDE "Fivewin.ch"
#INCLUDE "SIGA.ch"
#Include "COLORS.CH"
#Include "FONT.CH"                          
#INCLUDE "VKEY.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MESTC03  บ Autor ณ                    บ Data ณ  31/07/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Telas de Quotas (Share)                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorna   ณ Matriz com as Formas de Pagamento                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MESTC03(cSimil,cEISCod)    

Local aGetArea        := GetArea()
Local nOpcA           := 0 
Local aSizeAut		  := MsAdvSize(,.F.)
Local aObjects		  := {}
Local aInfo 		  := {}
Local aPosGet		  := {}
Local aPosObj		  := {}  
Local nY              := 0

Local nGetLin         := 0
Local _nLtMan         := 0
Local _nPtMan         := 0
Local _nJust          := space(250)

Local oJust,oPtMan,oLtMan,oSimil,oEIS,oDlg,oGet2
         
Local bSetKey4

Private oTQuotas  
Private aHeader   := {}
Private aCols     := {}
Private nopc      := 3

PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}

Private _nQuotas  := 0 

Private _n_SHARE := 0
Private _n_REFER := 0
Private _n_SUFIX := 0
Private _n_MARCA := 0    // Fabricante
Private _n_ORIGEM:= 0 	 // Origem
Private _n_SIMIL := 0 	 // Similaridade
Private _n_SBSIM := 0	 // Grupo de Similaridade
Private _n_XYZ   := 0    // Criticidade
Private _n_123   := 0    // 123
Private _n_NC_IM := 0    // NACIONAL/IMPORTADO
Private _n_LT    := 0    // LEAD TIME 
Private _n_ITCPR := 0    // Item de Compra
Private _n_LTMAN := 0    // Lote Manual
Private _n_PTMAN := 0    // Ponto de Pedido Manual
Private _n_COD   := 0    // SKU
Private _n_EIS01 := 0	 // EIS Codigo 01
Private _n_EIS02 := 0	 // EIS Codigo 02
Private _n_EIS03 := 0	 // EIS Codigo 03
Private _n_EIS04 := 0	 // EIS Codigo 04
Private _n_EIS05 := 0	 // EIS Codigo 05
Private _n_EIS06 := 0	 // EIS Codigo 06
Private _n_EIS07 := 0	 // EIS Codigo 07
Private _n_EIS08 := 0	 // EIS Codigo 08
Private _n_EIS09 := 0	 // EIS Codigo 09
Private _n_EIS10 := 0	 // EIS Codigo 10

Private cCadastro := "Cadastro de Quotas"                                     



if EmptY(cSimil)
   Aviso("ATENCAO", "Nao foi possivel continuar pois o Simil esta em branco",{"&Ok"})
   Return
Endif

If EmptY(cEISCod)
   Aviso("ATENCAO", "Nao foi possivel continuar pois o Cod.Eis esta em branco",{"&Ok"})
   Return
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriar os campos de cabecalho do oGet2        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_SHARE")   // Share
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"U_VALQUOTA(.T.)","","C",})
DbSeek("B1_X_REFER")	// Referencia
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_SUFIX")    // Sufixo
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_MARCA")	// Marca
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_ORIGEM")   	// Origem
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_SIMIL")	// Similaridade
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_SBSIM")	// Grupo de Similaridade
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_XYZ")     // Criticidade
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_123")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_NC_IM")	// NACIONAL/IMPORTADO
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_LT")       // LEAD TIME 
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_ITCPR")    // Item de Compra
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_LTMAN")    // Lote Manual
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_PTMAN")   // Ponto de Pedido Manual
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_COD")       // SKU
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS01")	// EIS Codigo 01
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS02")	// EIS Codigo 02
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS03")	// EIS Codigo 03
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS04")	// EIS Codigo 04
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS05")	// EIS Codigo 05
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS06")	// EIS Codigo 06
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS07")	// EIS Codigo 07
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS08")	// EIS Codigo 08
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS09")	// EIS Codigo 09
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})
DbSeek("B1_X_EIS10")	// EIS Codigo 10
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,"","","C",})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPega posicoes  dos itens no Cabecalho      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_n_SHARE := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SHARE"})
_n_REFER := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_REFER"})
_n_SUFIX := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SUFIX"})
_n_MARCA := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_MARCA"})   // Fabricante
_n_ORIGEM:= aScan(aHeader,{|x| AllTrim(x[2])=="B1_ORIGEM"}) 	 // Origem
_n_SIMIL := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SIMIL"}) 	 // Similaridade
_n_SBSIM := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SBSIM"})	 // Grupo de Similaridade
_n_XYZ   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_XYZ"})     // Criticidade
_n_123   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_123"})     // 123
_n_NC_IM := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_NC_IM"})	 // NACIONAL/IMPORTADO
_n_LT    := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_LT"})      // LEAD TIME 
_n_ITCPR := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_ITCPR"})  // Item de Compra
_n_LTMAN := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_LTMAN"})   // Lote Manual
_n_PTMAN := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_PTMAN"})   // Ponto de Pedido Manual
_n_COD   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_COD"})       // SKU
_n_EIS01 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS01"})	 // EIS Codigo 01
_n_EIS02 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS02"})	 // EIS Codigo 02
_n_EIS03 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS03"})	 // EIS Codigo 03
_n_EIS04 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS04"})	 // EIS Codigo 04
_n_EIS05 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS05"})	 // EIS Codigo 05
_n_EIS06 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS06"})	 // EIS Codigo 06
_n_EIS07 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS07"})	 // EIS Codigo 07
_n_EIS08 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS08"})	 // EIS Codigo 08
_n_EIS09 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS09"})	 // EIS Codigo 09
_n_EIS10 := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_EIS10"})	 // EIS Codigo 10


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua a Montagem do Acols                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MontAcols(cSimil,cEISCod,@_nLtMan,@_nPtMan,@_nJust)


AAdd( aObjects, { 050, 025, .t., .f. } )
AAdd( aObjects, { 050, 100, .t., .t. } )
AAdd( aObjects, { 050, 050, .t., .f. } )

// Esta matriz contem os limites da tela                              
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
//Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{05,40}})

aSizeAut[5] := aSizeAut[5]-150
aPosObj[1,4]:= aPosObj[1,4] - 130
aPosObj[2,4]:= aPosObj[2,4] - 130
aPosObj[3,4]:= aPosObj[3,4] - 130
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao de Fontes para esta janela ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD

//DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL		
DEFINE MSDIALOG oDlg TITLE cCadastro From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]-100 OF oMainWnd PIXEL		
bSetKey4 :=SetKey(VK_F4 , nil ) // Ativando F4

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlg PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlg PIXEL

nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1] 
nGetLin := nGetLin - 3
@ nGetLin,aPosGet[1,1]     SAY "Similaridade" size 100,8 OF oDlg PIXEL //FONT oFntFecha5
@ nGetLin,aPosGet[1,2]     MSGET oSimil VAR cSimil  Picture "@!"  Size 50,8 OF oDlg PIXEL  When .F. 

@ nGetLin,aPosGet[1,1]+150  SAY "EIS Selecionado " size 100,8 OF oDlg PIXEL //FONT oFntFecha5
@ nGetLin,aPosGet[1,2]+150 MSGET oEIS   VAR cEISCod Picture "@!"    Size 100,8 OF oDlg PIXEL  When .F. 

oGet2:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_VALQUOTA()","U_VALQUOTA()",,.F.,{"B1_X_SHARE"},2)
oGet2:oBrowse:bDelete :={ || aCols[n,Len(Acols[n])]:=!aCols[n,Len(Acols[n])],oGet2:LinhaOk(),oGet2:oBrowse:Refresh(.T.)}
//oGet2:oBrowse:nFreeze := 3        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
oGet2:nMax:=Len(Acols) 
    

nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1] 
//nGetLin := nGetLin - 3
// 1 Linha
nGetLin := aPosObj[3,1] + 5
@ nGetLin,aPosGet[1,1]     Say OemToAnsi("Total de Quotas") Size 50,08 OF oDlg PIXEL
@ nGetLin,aPosGet[1,2]     Msget oTQuotas Var  _nQuotas when .f. Picture "@E 9999999.99" Size 50,08 OF oDlg PIXEL                        // Lead Time (Dias)

// 2 Linha
nGetLin := aPosObj[3,1] + 20
@ nGetLin,aPosGet[1,1]     Say OemToAnsi("Lote Manual") Size 50,08 OF oDlg PIXEL
@ nGetLin,aPosGet[1,2]     Msget oLtMan Var _nLtMan Picture PesqPict("SB1","B1_X_LTMAN") Size 80,08 OF oDlg PIXEL                        // Lead Time (Dias)

@ nGetLin,aPosGet[1,1]+170 Say OemToAnsi("Pt.Ped.Manual") Size 50,08 OF oDlg PIXEL
@ nGetLin,aPosGet[1,2]+140 Msget oPtMan Var _nPtMan Picture PesqPict("SB1","B1_X_PTMAN") Size 80,08 OF oDlg PIXEL                        // Lead Time (Dias)

// 3 Linha
nGetLin := aPosObj[3,1] + 35
@ nGetLin,aPosGet[1,1] Say OemToAnsi("Justificativa") Size 50,08 OF oDlg PIXEL
@ nGetLin,aPosGet[1,2] Msget oJust Var _nJust Picture "@!" Size 200,08 OF oDlg PIXEL                        // Lead Time (Dias)

// Neste ponto a funcao somente e iniciada durante a entrada a primeira entrada
// do usuario neste momento ja passou pelo MsGetdados e o n utilizado pela a mesma ja
// esta ativo. 
If Len(aCols) > 0
    U_VALQUOTA(.F.,.F.)    
Endif
		
ACTIVATE MSDIALOG oDlg ON INIT PAR_BAR(oDlg,{|| nOpcA := 1 ,If(U_VALTOTAL(),oDlg:End(),nOpcA:=0) },{||oDlg:End()})  CENTERED
SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior da Tecla
		



if nOpca = 1


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//|Atualiza todas as SKU do SB1 com mesmo Simil e EIS                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   DbselectArea("SB1")
	DbSetOrder(1)

	For nY:=1 to Len(acols)

		If  DbSeek(xFilial("SB1")+aCols[nY,_n_COD])
			// Evita processamento desnecessario.
			If  SB1->B1_X_SHARE <> aCols[nY,_n_SHARE] .OR.;
				SB1->B1_X_PTMAN <> _nPtMan .OR.;
				SB1->B1_X_LTMAN <> _nLtMan .OR.;
				SB1->B1_X_JUSTF <> _nJust
				
				RECLOCK("SB1",.F.)
				SB1->B1_X_SHARE := aCols[nY,_n_SHARE]
				SB1->B1_X_PTMAN := _nPtMan
				SB1->B1_X_LTMAN := _nLtMan
				SB1->B1_X_JUSTF := _nJust
				MsUnlock()
			Endif
		Endif

/*
     //TESTES
	DbSelectArea("SZ8")
	DbSetorder(1)         // Filial + Simil + Eis + Sku
	If Dbseek(xFilial("SZ8")+_cSimil+_cEis+aCols[nY][_X_SKU])
		
		If  Z8_COMPRAR <> aCols[nY][_X_COMPRAR]
			Reclock("SZ8",.F.)
			SZ8->Z8_COMPRAR := aCols[nY][_X_COMPRAR]
			SZ8->Z8_SELEC   := IIF(Z8_COMPRAR <> 0,"X"," ")
			MsUnlock()
		Endif
		nS_PedCom +=SZ8->Z8_COMPRAR
		
	Endif
	
Next nY

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua a gravacao do SZ7ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SZ7")
DbSetorder(1)         // Filial + Simil + Eis
If Dbseek(xFilial("SZ7")+_cSimil+_cEis)
	If  Z7_COMPRAR <> nS_PedCom
		Reclock("SZ7",.F.)
		SZ7->Z7_COMPRAR := nS_PedCom
		SZ7->Z7_SELEC   := IIF(Z7_COMPRAR<>0,"X"," ")
		MsUnlock()
	Endif
Endif

// TESTES
*/
	Next nY





Endif


RETURN (IIf(nOpca = 1,.T.,.F.))


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
Static Function MontAcols(cSimil,cEISCod,_nLtMan,_nPtMan,_nJust)

Local nLin   := 0

_nQuotas:=0
	
DbSelectArea("SB1")
DbOrderNickname("B1SIMIL")             //B1_X_SIMIL + EIS
		
If  Dbseek(xFilial("SB1") + cSimil + cEISCod )

    _nLtMan         := SB1->B1_X_LTMAN
    _nPtMan         := SB1->B1_X_PTMAN
    _nJust          := SB1->B1_X_JUSTF

	While !SB1->(Eof())  .and. (cSimil + cEISCod) = ;
		SB1->(B1_X_SIMIL + B1_X_EIS01 + B1_X_EIS02 + B1_X_EIS03 +;
		B1_X_EIS04 + B1_X_EIS05 + B1_X_EIS06 + B1_X_EIS07 + B1_X_EIS08 +;
		B1_X_EIS09 + B1_X_EIS10)
		
		AADD(aCols,Array(Len(aHeader)+1))
		nLin                        := Len(aCols)
		aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado
		
		aCols[nLin,_n_SHARE ] := SB1->B1_X_SHARE
		aCols[nLin,_n_REFER ] := SB1->B1_X_REFER
		aCols[nLin,_n_SUFIX ] := SB1->B1_X_SUFIX
		aCols[nLin,_n_MARCA ] := SB1->B1_X_MARCA    // Fabricante
		aCols[nLin,_n_ORIGEM] := SB1->B1_ORIGEM  	 // Origem
		aCols[nLin,_n_SIMIL ] := SB1->B1_X_SIMIL  	 // Similaridade
		aCols[nLin,_n_SBSIM ] := SB1->B1_X_SBSIM 	 // Grupo de Similaridade
		aCols[nLin,_n_XYZ   ] := SB1->B1_X_XYZ      // Criticidade
		aCols[nLin,_n_123   ] := SB1->B1_X_123      // 123
		aCols[nLin,_n_NC_IM ] := SB1->B1_X_NC_IM 	 // NACIONAL/IMPORTADO
		aCols[nLin,_n_LT    ] := SB1->B1_X_LT       // LEAD TIME
		aCols[nLin,_n_ITCPR ] := SB1->B1_X_ITCPR    // Item de Compra
		aCols[nLin,_n_LTMAN ] := SB1->B1_X_LTMAN    // Lote Manual
		aCols[nLin,_n_PTMAN ] := SB1->B1_X_PTMAN    // Ponto de Pedido Manual
		aCols[nLin,_n_COD   ] := SB1->B1_COD        // SKU
		aCols[nLin,_n_EIS01 ] := SB1->B1_X_EIS01 	 // EIS Codigo 01
		aCols[nLin,_n_EIS02 ] := SB1->B1_X_EIS02 	 // EIS Codigo 02
		aCols[nLin,_n_EIS03 ] := SB1->B1_X_EIS03 	 // EIS Codigo 03
		aCols[nLin,_n_EIS04 ] := SB1->B1_X_EIS04 	 // EIS Codigo 04
		aCols[nLin,_n_EIS05 ] := SB1->B1_X_EIS05 	 // EIS Codigo 05
		aCols[nLin,_n_EIS06 ] := SB1->B1_X_EIS06 	 // EIS Codigo 06
		aCols[nLin,_n_EIS07 ] := SB1->B1_X_EIS07 	 // EIS Codigo 07
		aCols[nLin,_n_EIS08 ] := SB1->B1_X_EIS08 	 // EIS Codigo 08
		aCols[nLin,_n_EIS09 ] := SB1->B1_X_EIS09	     // EIS Codigo 09
		aCols[nLin,_n_EIS10 ] := SB1->B1_X_EIS10 	 // EIS Codigo 10

		SB1->(DbSkip())

     _nQuotas := _nQuotas + SB1->B1_X_SHARE

	Enddo
   
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VALQUOTA บ Autor ณ                    บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida o Conteudo do Parametro Digitado                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VALQUOTA(lValid,lMensagem)
Local  lRet      := .T.                      
Local  _nShare   := 0
Local  _cConteudo:= 0
Local  nX        := 0
Local _nSQuotas  := 0         
Local _nErro     := 0 
Local nY         := 0

DEFAULT lValid    := .F.
DEFAULT lMensagem := .T.
           

/*
_nShare := IIF(lValid .AND. TYPE("M->B1_X_SHARE")<>"U" ,  &("M->B1_X_SHARE")   ,aCols[n][_n_SHARE] )       
                  
if _nShare 

For nY := 1 to Len(Acols)
    if   nY = n 
         _nSQuotas += _nShare
    Else    
         _nSQuotas += aCols[nY][_n_SHARE]
    Endif
Next nY    
*/


For nY := 1 to len(Acols)

    _nShare   := IIF(lValid .AND. n = nY .and. TYPE("M->B1_X_SHARE")<>"U" ,  &("M->B1_X_SHARE")   ,aCols[nY][_n_SHARE] )       

    If   valtype(_nShare)<>"N"
          _nShare := 0
    Endif

    _nSQuotas += _nShare 

Next nY


M->_nQuotas:=_nSQuotas
oTQuotas:Refresh()

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VALTOTAL บ Autor ณ                    บ Data ณ  18/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida todo o acols na saida.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multitek                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VALTOTAL(lValid,lMensagem)
Local  lRet       := .T.                      
Local  _nShare    := 0
Local  _cConteudo := 0
Local  nX         := 0
Local _nSQuotas   := 0         
Local _nErro      := 0 

DEFAULT lValid    := .F.
DEFAULT lMensagem := .T.
            
_nShare :=IIF(lValid .AND. TYPE("M->B1_X_SHARE")<>"U", &("M->B1_X_SHARE")   ,aCols[n][_n_SHARE] )       
               

For nY := 1 to Len(Acols)
    if nY = n .and. lValid
       _nSQuotas += _nShare
    Else    
       _nSQuotas += aCols[nY][_n_SHARE]
    Endif
Next nY    

// Observe que o Erro 2 nao e tratado quando o usuario esta digitando as
// cotas evitando que fique dando mensagens a todo o momento.
_nErro := IIF(_nSQuotas > 100,1,IIF(_nSQuotas < 100 .and. !lValid ,2,0))

if lMensagem
	If  _nErro = 1         // > 100
		
		Aviso("ATENCAO", "Nao foi possivel continuar pois o total de Quotas excede a quantidade "+;
		"de quotas total que e de 100 % ",{"&Ok"})
		
	ElseIf _nErro = 2   // <  100
		
		
		Aviso("ATENCAO", "Nao foi possivel continuar pois o total de Quotas "+;
		"distribuidos na coluna Quotas nao pode ser menor que 100 %",{'Ok'})
		
	Endif
Endif


// 15/02/2006 - Anteriorment o erro era tratado mas conforme solicitacao do Sr. Milton
//              o mesmo deseja informar cotas aliatoriamente.
//              O mesmo foi informado do problema desta atitude.
_nErro    := 0

/*
// Retorna a Mensagem de Erro mas trata o Erro
// neste momento o usuario esta digitando uma cota o que ocasionou o erro.
if  _nErro = 1 .and. lValid
    _nSQuotas := 100 - (_nSQuotas - _nShare )  //  100 -   Somatoria das Contas - % Digitado
    M->B1_X_SHARE := _nSQuotas 
    _nErro    := 0
Endif         
*/

M->_nQuotas:=_nSQuotas
oTQuotas:Refresh()

lRet := IIF(_nErro = 0 , .T. , .F.)

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


