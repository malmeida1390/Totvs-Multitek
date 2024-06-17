#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GRAVA_SRV ³ Autor ³ JULIO                 ³ Data ³ 31-01-2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao das verbas                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GRAVA_SRV()

Aviso("Importacao de projetos","Atencao! Certifique-se de que o arquivo foi gerado com este formato EVENTOS - CSV (MS-DOS)  e que as configuracoes regionais do windows utilizam '.' para decimais.",{"Ok"})


Processa({||A001Import()},"Importando CSV. Aguarde...")


Return



Static Function A001Import()

Local nx := 0

Private aTxt        := {}
Private aRet        := {}

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
		
		DbSelectArea("SRV")  
		DbSetORder(1)
		If  Dbseek(xFilial("SRV")+aTxt[nX][01])
		    Reclock("SRV",.F.)      
            SRV->RV_X_DADM := aTxt[nX][04]
            SRV->RV_X_CADM := aTxt[nX][05]

            SRV->RV_X_DVEND := aTxt[nX][06]
            SRV->RV_X_CVEND := aTxt[nX][07]

            SRV->RV_X_DPLAB := aTxt[nX][08]
            SRV->RV_X_CPLAB := aTxt[nX][09]

            SRV->RV_X_DAUT := aTxt[nX][10]
            SRV->RV_X_CAUT := aTxt[nX][11]

            SRV->RV_X_DPLA2 := aTxt[nX][12]
            SRV->RV_X_CPLA2 := aTxt[nX][13]

            SRV->RV_X_DAUT2 := aTxt[nX][14]
            SRV->RV_X_CAUT2 := aTxt[nX][15]
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