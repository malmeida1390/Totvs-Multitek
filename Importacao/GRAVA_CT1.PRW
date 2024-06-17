#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVA_CT1 ³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Ajuste SB9 com base na data de fechamento.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRAVA_CT1()

Aviso("Importacao de projetos","Atencao! Certifique-se de que o arquivo foi gerado com este formato EVENTOS - CSV (MS-DOS)  e que as configuracoes regionais do windows utilizam '.' para decimais.",{"Ok"})


Processa({||A001Import()},"Importando CSV. Aguarde...")


Return



Static Function A001Import()

Local nx := 0

Local cCodEDT
Local cCodTrf
Local _dData:=cTod("31/12/11")


Private cCadastro   := "Ajustando Saldos Iniciais com base no  "
Private aTxt        := {}
Private aRet        := {}


Private aSB1 := {}
//Private nSB1_X_CDNEW  := 0
Private nSB1_X_CDDAY  := 0
Private nSB1_X_CDIBE  := 0

Private aImport := {}
Private aRotina 	:= {	{ "", "AxPesqui"  , 0 , 1},;
{ "","PMS200Dlg", 0 , 2},;
{ "",   "PMS200Dlg", 0 , 3},;
{ "",   "PMS200Alt", 0 , 4},;
{ "",   "PMS200Dlg", 0 , 4} }

Inclui   := .T.
Altera   := .F.
lRefresh := .T.



If ParamBox({	{6,"Arquivo",SPACE(50),"","FILE(mv_par01)","", 55 ,.T.,"Arquivo .CSV |*.CSV"}},;
	"Atualizar Projeto",@aRet,,)
	//{1,"Importar .CSV",SPACE(10),"","dbSeek(xFilial('AF8')+AllTrim(mv_par03))","AF8","", 45 ,.F.},;
	//{3,"Versao do Project",1 ,{"Portugues","Ingles"},70,,.F.},;
	
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
	
	
	For nX := 2 to Len(aTxt)
		
		PmsIncProc(.T.)
		
		DbSelectArea("CT1")  
		DbSetORder(1)
		If  !Dbseek(xFilial("CT1")+TiraPonto(aTxt[nX][02]))
		    Reclock("CT1",.T.)      
            CT1->CT1_CONTA  := TiraPonto(aTxt[nX][02])
            CT1->CT1_DESC01 := aTxt[nX][03]
            CT1->CT1_CLASSE := aTxt[nX][04]
            CT1->CT1_NORMAL := aTxt[nX][05]
            CT1->CT1_BLOQ   := aTxt[nX][06]
            CT1->CT1_DC     := aTxt[nX][07]
            CT1->CT1_CTASUP := aTxt[nX][08]
            CT1->CT1_CVD02  := "5"
            CT1->CT1_CVD03  := "5"
            CT1->CT1_CVD04  := "5"
            CT1->CT1_CVD05  := "5"
            CT1->CT1_CVC02  := "5"
            CT1->CT1_CVC03  := "5"
            CT1->CT1_CVC04  := "5"
            CT1->CT1_CVC05  := "5"
            CT1->CT1_ACITEM := "1"
            CT1->CT1_ACCUST  := "1"
            CT1->CT1_ACCLVL := "2"
            CT1->CT1_DTEXIS:= ctod("01/01/1980")
            CT1->CT1_AGLSLD     := "2"
            CT1->CT1_CCOBRG     := "2"
            CT1->CT1_ITOBRG     := "2"
            CT1->CT1_CLOBRG     := "2"
            CT1->CT1_INDNAT     := aTxt[nX][09]
            CT1->CT1_CTAANT     := aTxt[nX][10]
     		MsUnlock() 
        Endif

	Next nX
	
EndIf

Return


Static Function TiraPonto(cConteudo)
Local _cLinha := cConteudo
Local aTxt2:={}
Local cConteFim := ""

nCampo := 1
While At(".",cLinha)>0
	cConteFim += Substr(_cLinha,1,At(".",_cLinha)-1)
	nCampo ++
	_cLinha := StrTran(Substr(_cLinha,At(".",_cLinha)+1,Len(_cLinha)-At(".",_cLinha)),'"','')
Enddo         

If Len(AllTrim(_cLinha)) > 0
	cConteFim += StrTran(Substr(_cLinha,1,Len(_cLinha)),'"','')
Else
	cConteFim += ""
Endif
		
Return(cConteFim)