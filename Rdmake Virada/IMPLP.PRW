#include "protheus.ch"

/*/                    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CSV_EVENTO³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de importacao de projetos no AF8 atraves de arquivo ³±±
±±³          ³ texto.                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPLP()

If Aviso("Importacao de produtos","Deseja Continuar ?",;
	{"Sim", "Nao"}) == 2
	Return
Endif

Processa({||A001Import()},"Importando CSV. Aguarde...")

Return



Static Function A001Import()

Local aCalend
Local nx := 0
Local nCntCpo := 0

Local cCodEDT
Local cCodTrf

Local cProduto:= ''
Local cCusto  := ''          //- Custos não vendidos em planilha

Local nPosCalend

Local nPosRevisa
Local nPosEdtPai
Local nPosConf
Local nPosSep
Local nDelEDT
Local nDelTrf
Local aVetor  := {}
Local lNewTrf := .T.

Local lNewEDT := .T.
Local aTipos  := {}
Local aCpoImp := {}

Local aResumoAF9   := {}
LOCAL cAF8_FASE    := ""
Local lIniciar     := .t.
Local lReembIni    := .t.
Local lReembAtu    := .t.
Local lPula        := .t.

Local lErro        := .t.

Private cProduto   := ""
Private cDescricao := ""
Private nPosTarefa
Private nPosID
Private cCadastro   := "Importar arquivo .CSV"
Private aTxt        := {}
Private aRet        := {}
Private aSB1        := {}

If ParamBox({	{6,"Arquivo",SPACE(50),"","FILE(mv_par01)","", 55 ,.T.,"Arquivo .CSV |*.CSV"}},;
	"Atualizar Produtos",@aRet,,)
	
	If (nHandle := FT_FUse(AllTrim(aRet[1])))== -1
		Help(" ",1,"NOFILEIMPOR")
		Return
	EndIf
	
	FT_FGOTOP()
	While !FT_FEOF()
		PmsIncProc(.T.)
		cLinha := FT_FREADLN()
		AADD(aTxt,{})
		nCampo := 1
		While At(";",cLinha)>0
			aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
			nCampo ++
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		Enddo
		If Len(AllTrim(cLinha)) > 0
			aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
		Else
			aAdd(aTxt[Len(aTxt)],"")
		Endif
		FT_FSKIP()
	Enddo
	FT_FUSE()
	
EndIf

_apeca := {}

_Cont := 0
For nY:= 1 to Len(aTxt)
	
	_Cont := _Cont + 1
	Reclock("CT5",.t.)
	CT5->CT5_FILIAL  := xFilial("CT5")
	//CT5->CT5_CODFOR  := aTxt[ny,2]
	//CT5->CT5_CODCLI  := aTxt[ny,3]
	CT5->CT5_LANPAD  := aTxt[ny,1]
	CT5->CT5_STATUS  := "1"  
	CT5->CT5_SEQUEN  := aTxt[ny,2]
	CT5->CT5_DESC  	 := aTxt[ny,3]
	CT5->CT5_DC   	 := IIF(Substring(aTxt[ny,4],1,1)=="D","1", IIF(Substring(aTxt[ny,4],1,1)=="C","2", IIF(Substring(aTxt[ny,4],1,1)=="P","3","")))  
	CT5->CT5_DEBITO  := aTxt[ny,5]	
	CT5->CT5_CREDIT  := aTxt[ny,6]   
	CT5->CT5_MOEDAS  := "12222"   
	CT5->CT5_VLR01  := aTxt[ny,7]   
	//CT5->CT5_VLR02  := aTxt[ny,13]  
	//CT5->CT5_VLR03  := aTxt[ny,14]  
	//CT5->CT5_VLR04  := aTxt[ny,15]  
	//CT5->CT5_VLR05  := aTxt[ny,16]  
	CT5->CT5_HIST   := aTxt[ny,8]  
	//CT5->CT5_HAGLUT  := aTxt[ny,18]  
	CT5->CT5_CCD    := aTxt[ny,9]  
	CT5->CT5_CCC    := aTxt[ny,10]  
	CT5->CT5_ORIGEM  := aTxt[ny,11]  
	CT5->CT5_ITEMD   := aTxt[ny,12]  
	CT5->CT5_ITEMC   := aTxt[ny,13]  
	CT5->CT5_INTERC	 := "N"
	CT5->CT5_TPSALD  := "1"
	CT5->CT5_MOEDLC	 := "1"  
	CT5->CT5_MLTSLD  := "1"			
	MsUnlock()
	
Next

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


Static Function Troca(cCampo)
Local nCampo := 0

cCampo := StrTran(cCampo,".","")

cCampo := StrTran(cCampo,",",".")


nCampo := Val(cCampo)

Return(nCampo)


