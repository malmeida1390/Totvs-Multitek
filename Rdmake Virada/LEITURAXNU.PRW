#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LeituraXnu³ Autor ³ Marcelo               ³ Data ³ 22-08-2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de geracao relatorio do xnu                         ³±±
±±³          ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LEITURAXNU()

Aviso("Leitura de Menus","Atencao! Certifique-se de que o arquivo e .XNU.",{"Ok"})

Processa({||A001Import()},"Importando XNU. Aguarde...")

Return



Static Function A001Import()

Local aCalend
Local nx := 0
Local nCntCpo := 0

Local cCodEDT
Local cCodTrf


Local nPosCalend

Local nPosRevisa
Local nPosEdtPai
Local nPosConf


Local nPosSep
Local nDelEDT
Local nDelTrf

Local lNewTrf := .T.

Local lNewEDT := .T.
Local aTipos  := {}
Local aCpoImp := {}


Local nAFC_EDT     := 0
Local nAFC_NIVEL   := 0
Local nAFC_EDTPAI  := 0
Local nAFC_DESCRI  := 0

Local nAF9_TAREFA  := 0
Local nAF9_NIVEL   := 0
Local nAF9_EDTPAI  := 0
Local nAF9_DESCRI  := 0
Local nAFA_TAREFA  := 0
Local nAFA_ITEM    := 0
Local nAFA_PRODUT  := 0
Local nAF9_TVPVC   := 0
Local nAF9_TVRECO  := 0
Local nAF9_TVPEBV  := 0
Local nAF9_TVPRBV  := 0
Local nAFA_QUANT   := 0
Local nAFA_CUSTD   := 0

Local aResumoAF9   := {}

Local lIniciar     := .t.
Local lReembIni    := .t.
Local lReembAtu    := .t.
Local lPula        := .t.

Local _cTarVenda   := ""
Local _cTarReemb   := ""
Local _cTarUtil    := ""


Private cProduto   := ""
Private cDescricao := ""
Private nPosTarefa
Private nPosID
Private cCadastro   := "Leitura de Arquivo "
Private aTxt        := {}
Private aRet        := {}

Private aAFC        := {}
Private aAF9        := {}
Private aAFA        := {}

Private aEDT        := {}
Private aTAR        := {}
Private aPRO        := {}


Private aRotina 	:= {	{ "", "AxPesqui"  , 0 , 1},;
{ "","PMS200Dlg", 0 , 2},;
{ "",   "PMS200Dlg", 0 , 3},;
{ "",   "PMS200Alt", 0 , 4},;
{ "",   "PMS200Dlg", 0 , 4} }

Inclui   := .T.
Altera   := .F.
lRefresh := .T.



If ParamBox({	{6,"Qual Menu (*.xnu)",SPACE(50),"","FILE(mv_par01)","", 55 ,.T.,"Arquivo .XNU |*.XNU"}},;
	"Geracao de Arquivo Texto",@aRet,,)
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
		
		If  '<Title lang="pt">' $ cLinha
			AADD(aTxt,{})
			nCampo := 1
			While At(chr(13),cLinha)>0
				aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(chr(13),cLinha)-1))
				nCampo ++
				cLinha := StrTran(Substr(cLinha,At(chr(13),cLinha)+1,Len(cLinha)-At(chr(13),cLinha)),'"','')
			Enddo
			
			If Len(AllTrim(cLinha)) > 0
				aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
			Else
				aAdd(aTxt[Len(aTxt)],"")
			Endif
		Endif     
		
		FT_FSKIP()  
		
	Enddo
	FT_FUSE()
	
EndIf

_Imprime()

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ _Imprime ³ Autor ³ Edelcio Cano          ³ Data ³ 10/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao do aTxt rotinas a serem validadas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Multi-Tek                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _Imprime()

Private titulo    := ""
Private cDesc1    := ""
Private cDesc2    := ""
Private cDesc3    := PADC("                                       ",74)
Private tamanho   := "M" //Iif ( EmptY(_ChaveAud),"P","G")
Private limite    := 80
Private cString   := "SZ9"
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
Private nomeprog  := "VALIMFOC"
Private nLastKey  := 0
//            0       10       20       30       40       50       60       70
//            .12345679.12345679.12345679.12345679.12345679.12345679.12345679.123456789.
Private cabec1    := ""
Private cabec2    := ""




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao dos Cabecalhos e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cbtxt   := Space(10)
Private cbcont  := 00
Private li      := 80
Private m_pag   := 01

Private wnrel := "VALIMFOC"

titulo    := " Relacao de Rotinas a Serem validadas.               "
cDesc1    := PADC("Relacao de Rotinas a Serem validadas. ",74)
cDesc2    := PADC("Relacao de Rotinas a Serem validadas. ",74)


wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

PROCESSA({|| _ImpNow()},"Processando o relatorio")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ _ImpNow  ³ Autor ³ Edelcio Cano          ³ Data ³ 10/08/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inicio da Impressao (Para funcionamento da REUGA)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Multi-Tek                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function _ImpNow()
Local _i:=0
Private nTipo     := IF(aReturn[4]==1,15,18)


Cabec1  :="| Rotina a Validar                      |     Responsavel     |     Data Inicial   |    Data Final    |    Visto de Ok   |" 
Cabec2  :="|                                       |                     |                    |                  |                  |"
cComple :=                                        "|                     |                    |                  |                  |" 
cLinhas :="+---------------------------------------+---------------------+--------------------+------------------+------------------+"
         



procregua(len(aTxt))

//1               2             3
//<Title lang="pt">Atualizacoes</Title>
//                   
//Aqui temos um problema nao e possivel identificar o que e cabecalho de rotina e rotina.
For nY:= 1 to len(aTxt)
	
	IncProc("Imprimindo, aguarde ...")   
	
	
	//if "Ped." $ aTxt[nY][1]
	//   teste:="xx"
	//Endif

    _cLin := aTxt[nY][1] 
    _nPo1 := At("<",_cLin)                                                                                                                  
    _nPo2 := At(">",_cLin) 
    _nPo3 := At("/",_cLin) 
    _cCont:= SPACE(_nPo1) +  ALLTRIM(SUBSTR(_cLin,_nPo2+1,_nPo3-_nPo2-2))

	If li > 68
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li := prow() 
	    li := li + 1
     	@ li, 000 PSAY aRet[1]
	    li := li + 1
    	@ li, 000 PSAY cLinhas
	    li := li + 1
	EndIf
	
	@ li, 000 PSAY "|"+_cCont 
	@ li, 040 PSAY cComple
	li := li + 1
	@ li, 000 PSAY cLinhas
	li := li + 1

Next


Roda(0,"","P")

Set device to Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

Ms_Flush()

Return




