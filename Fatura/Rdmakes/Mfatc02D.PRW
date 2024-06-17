#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

#DEFINE X_SIMIL			1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MFATC02D  ºAutor  ³                    º Data ³  13/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TELA DIRETORIA (CONSULTA DE PRODUTOS)                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC02D()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Em funcao da utilizacao de Interfaces de varios      ³
//³ programas e aconselhaveu manter todas as variaveis   ³
//³ como Local evitando o uso de Privante                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aGetArea  := GetArea()
//Local nOpca     := 0
Local cCadastro := "Consulta de Produtos"
Local nY        := 0
Local lInverte  := .f.
Local aStru     := {}
Local aCampos   := {}
Local cFABRI    := GetMark()
Local cRefe     := CriaVar("B1_X_REFER")
Local cSimil    := CriaVar("B1_X_SIMIL")
Local bSetKey4                             
Local bSetKey12
Local bSetKey8

Local oMark , oRefe,oDlgProd
Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5
Local cPRODUTO  := ""
Local ii        := 0
Local nQTDVEN   := 0
Local nQTDFIM   := 0
Local nPRODUTO  := 0
Local nREFE     := 0

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Local _nGetRent  := 0
Local _nGetRenVr := 0
Local _cStatus   := "L"
Local _nElem     := 0


PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}
Private lF8        := .T.
Private _cArqPRO   := ""
Private cArqB1     := ""
Private BX_X_REFER := CriaVar("SB1->B1_X_REFER")
Private BX_X_SUFIX := CriaVar("SB1->B1_X_SUFIX")
Private BX_X_MARCA := CriaVar("SB1->B1_X_MARCA")
Private oBX_X_REFER , oBX_X_SUFIX , oBX_X_MARCA
Private cProcName := FunName()      

//
// Parametros
//
Private _cIndComer:= ""  //IIF("MATA415" $ Upper(Funname()) ,M->CJ_X_ST_CI,IIF( UPPER(CJ_X_ST_CI) $ "INDUSTRIA","I","C"))
Private _cGetCond := ""  //IIF("MATA415" $ Upper(Funname()) ,M->CJ_CONDPAG,M->CCONDPAG)
Private _nFrete   := 0   //IIF("MATA415" $ Upper(Funname()) ,M->CJ_X_FRETE,M->nFrete  )
Private _nIcms    := 0   //Icms
Private _ncomis   := 0   //Somatoria das Comissoes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o SX1 -                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()


pergunte("CONSU2",.F.) // Sempre Le a ultima solicitacao com base no SX1

_cIndComer:= MV_PAR01     //Industria ou Comercio
_cGetCond := MV_PAR02     //Condicoes Pagamento
_nFrete   := MV_PAR03     //Frete
_nIcms    := MV_PAR04     //Icms 
_ncomis   := MV_PAR05     //Somatoria das Comissoes
               

AADD(aStru  ,{"T_OK","C", 2 , 0} )
//AADD(aCampos,{"T_OK",""," "," "})

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_REFER")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SUFIX")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_MARCA")         // FABRI  + ORIGEM + PRODUTO
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO+10,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Marca - Origem - Producao"/*X3_TITULO*/,X3_PICTURE})


DbSeek("CK_PRCVEN")          // Preco Simulado
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Preco Venda",X3_PICTURE})  // Preco Sugerido

                             // Matriz - Disponivel
AADD(aStru  ,{"T_SMATRIZ","N" , 14 , 0} )
AADD(aCampos,{"T_SMATRIZ","","Estoque+Deposito","@E 999,999,999"})

                              // Saldo Malha
AADD(aStru  ,{"T_SMALHA","N" , 14 , 0} )
//AADD(aCampos,{"T_SMALHA","","Saldo Malha","@E 999,999,999.99"})

DbSeek("B1_ORIGEM")         // ORIGEM
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


AADD(aStru  ,{"T_SDISPO","N" , 14 , 0} )
//AADD(aCampos,{"T_SDISPO","","Malha(Disp)","@E 999,999,999.99"})


DbSeek("CK_X_MARGV")          // $  Rentabilidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("CK_X_MARGA")          // Avaliacao da Margem
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

AADD(aStru  ,{"T_SFILIAL","N" , 14 , 0} )
AADD(aCampos,{"T_SFILIAL","","Filiais","@E 999,999,999"})
                                
AADD(aStru  ,{"T_STRANSI","N" , 14 , 0} )
AADD(aCampos,{"T_STRANSI","","Transito","@E 999,999,999"})
               
DbSeek("B1_X_CTSTD")         // Custo Padrao
AADD(aStru  ,{X3_CAMPO,X3_TIPO,10/*X3_TAMANHO*/,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Custo Padrao",X3_PICTURE})

DbSeek("B1_UPRC")            //   Ultima compra
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_UCOM")            //   Ultima compra
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_CTFOB")         // Custo FOB
AADD(aStru  ,{X3_CAMPO,X3_TIPO,10/*X3_TAMANHO*/,X3_DECIMAL} )
AADD(aCampos,{X3_CAMPO,"","Custo Fob",X3_PICTURE})


AADD(aStru  ,{"T_FATURAR","N" ,  14, 0} )
AADD(aCampos,{"T_FATURAR","","A Faturar","@E 999,999,999"})

AADD(aStru  ,{"T_SCONSIG","N" ,  14, 0} )
AADD(aCampos,{"T_SCONSIG","","Consignados","@E 999,999,999"})


AADD(aStru  ,{"T_RESERVA","N" ,  14, 0} )
AADD(aCampos,{"T_RESERVA","","Reserva","@E 999,999,999"})
                        

AADD(aStru  ,{"T_SEMPENH","N" ,  14, 0} )
//AADD(aCampos,{"T_SEMPENH","","Empenho","@E 999,999,999"})


AADD(aStru  ,{"T_CLASSIF","N" , 14 , 0} )
//AADD(aCampos,{"T_CLASSIF","","A Classificar","@E 999,999,999"})


DbSeek("B1_UM")              // UNIDADE
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_ABC")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_GIROQ")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_LMN")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_PQR")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_NEOIL")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_XYZ")     // Criticidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_123")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_NC_IM")         // Origem
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


DbSeek("B1_X_TMEA")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_COD")       // SKU
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SIMIL")     // B1_SIMIL
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})

DbSeek("B1_X_SBSIM")
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"",X3_TITULO,X3_PICTURE})


AADD(aStru  ,{"T_EIS","C",20,0} )
//AADD(aCampos,{"T_EIS","","EIS","@!"})

DbSeek("CK_X_MARGE")          //  % Rentabilidade
AADD(aStru  ,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL} )
//AADD(aCampos,{X3_CAMPO,"","Margem",X3_PICTURE})

AADD(aStru  ,{"T_FINALIZ","C" ,1, 0} )  // Este campo e apenas para corrigir
AADD(aCampos,{"T_FINALIZ","","",""})    // o ultimo item do acols para nao ficar com um
// espaco enorme.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera o Trb Vazio                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqB1   := CriaTrab(aStru,.T.)
_cArqPRO := CriaTrab(,.F.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)
IndRegua("TRB",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
dbGotop()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Fontes para esta janela ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 7,16
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD



aSize := MsAdvSize()

aObjects := {}

AAdd( aObjects, { 100, 025, .t., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 025, .t., .f. } )


// Esta matriz contem os limites da tela
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{020,50,105,135,180,200,255,290}} )
nGetLin := aPosObj[3,1]


DEFINE MSDIALOG oDlgProd TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel
bSetKey4  := SetKey(VK_F4  ,{|| U_MFATC03(TRB->B1_COD)})
bSetKey12 := SetKey(VK_F12 ,{|| pergunte("CONSU2",.T.),ExistRefe(@oMark,cArqB1,@aStru,@M->cRefe,@oRefe)})
bSetKey8  := SetKey(VK_F8  ,{|| lF8:=IF(lF8,.F.,.T.) ,GeraMarkB(@cArqB1,@aStru,@oMark,M->cRefe,oMark)})

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4]  OF oDlgProd PIXEL
@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4]  OF oDlgProd PIXEL


nGetLin := ROUND((aPosObj[1,3]-aPosObj[1,1])/2,0) + aPosObj[1,1]
nGetLin := nGetLin - 3
@ nGetLin,aPosGet[1,1]   SAY "Referencia" size 100,8 OF oDlgProd PIXEL //FONT oFntFecha5

@  nGetLin,aPosGet[1,2]    MSGET oRefe  VAR cRefe  Picture "@!" F3 "Z31"   Size 50,8 OF oDlgProd PIXEL  When .T.;
  Valid ExistRefe(@oMark,cArqB1,@aStru,@M->cRefe,@oRefe)

oMark := MsSelect():New("TRB","T_OK",,aCampos,@lInverte,@cFABRI,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})
oMark:bMark := {| | MfatDisp(oRefe,@cRefe,aStru,oMark)}   // Atualiza outras telas quando dispara o
//oMark:oBrowse:lhasMark = .t.                             // evento click
//oMark:oBrowse:lCanAllmark := .t.
//oMark:oBrowse:bAllMark := { || MfatInvS(cFABRI,@oMark) } // Permite FABRIr um, inverter,
oMark:oBrowse:nFreeze := 3  // congelando estas colunas ocorre um "flicker" na tela
//oMark:oBrowse:nColPos := 7  // POSICIONA NA ULTIMA COLUNA DA TELA FACILITANDO O USUARIO MOVIMENTAR
//oMark:oBrowse:nColPos := 1


nGetLin := ROUND((aPosObj[3,3]-aPosObj[3,1])/2,0) + aPosObj[3,1]
nGetLin := nGetLin - 5
@ nGetLin , 50   SAY  "< F4 > Consulta Estoque Lojas "+;
"   < F8 > Desabilita Filtro do Estoque "+;
"   < F12 > Parametros Preco Sugerido " of oDlgProd PIXEL  FONT oFntFecha5

oMark:oBrowse:Refresh(.t.)

ACTIVATE MSDIALOG oDlgProd ON INIT RfatBar(oDlgProd,;
{|| oDlgProd:End()},{|| oDlgProd:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F12,bSetKey12)
SetKey(VK_F8 ,bSetKey8)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
dbSelectArea("TRB")
dbCloseArea()
If File(cArqB1+".DTC")
	Ferase(cArqB1+".DTC")
Endif

If File(_cArqPro+OrdBagExt())
	FErase(_cArqPro+OrdBagExt())
Endif
*/

//FimEstrut2("TRB",cArqB1) // Finaliza o uso do Temporario funcao dentro do sigacusb
If Select("TRB") <> 0
  TRB->(DbcloseArea())
Endif


RestArea(aGetArea)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do Mfatc01                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oDlgProd: 	Objeto Dialog                                 ³±±
±±³          ³ bOk:  	Code Block para o Evento Ok                       ³±±
±±³          ³ bCancel: Code Block para o Evento Cancel                   ³±±
±±³          ³ nOpc:		nOpc transmitido pela mbrowse                 ³±±
±±³          ³ aForma: Array com as formas de pagamento                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RfatBar(oDlgProd,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

//aadd(aButtons,{"POSCLI",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi‡„o de Cliente" }) 	//"Posi‡„o de Cliente"

aadd(aButtons,{"S4WB011N",{||U_MFATC03(TRB->B1_COD)}, "<F4> - Consulta Estoque da Malha Logistica" })

Return (EnchoiceBar(oDlgProd,bOK,bcancel,,aButtons))



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatDisp  ³ Autor ³                       ³ Data ³ 07/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³MfatDisp													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MfatDisp(oRefe,cRefe,aStru,oMark)
Local nDecs

cRefe:= CriaVar("B1_X_REFER")

oRefe:Refresh()
SetFocus(oRefe:hWnd)


/*
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


//oBX_X_REFER:Refresh()
//oBX_X_SUFIX:Refresh()
//oBX_X_MARCA:Refresh()

oMark:oBrowse:Refresh(.t.)
*/

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³MfatInvS  ³ Autor ³                       ³ Data ³ 07/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Inverte FABRIoes 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ MfatInvS     											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MfatInvS(cFABRI,oMark)

Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	RecLock("TRB")
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

Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraListB³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monsta a Lista de Itens das Ultimas Compras com base no TMP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraListB(cRefe,oRefe,cArqB1,aStru)


Local cChave   := ""
Local aTrataEis := {}
Local aPrVenda  := {}
Local nCount    := 0
Local aSaldoEst := {}
Local lBucaUnid := .F.
Local _concSimil:= ""
Local lQuery    := .F.
Local lContinua := .T.
Local cAliasSB1 := "SB1"
Local aStruSB1  := {}

Local   _Recno    := 0
Local   aElem     := {}
Local   _uString   := _cParAlmox:= GETMV("MV_ALMCONS")
Local   nPos      := 0
Local  lContinue  := .T.
Local  nCusto     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta arquivo temporario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
dbSelectArea("TRB")
dbCloseArea()

If File(cArqB1+".DTC")
	Ferase(cArqB1+".DTC")
Endif
*/
//FimEstrut2("TRB",cArqB1) // Finaliza o uso do Temporario funcao dentro do sigacusb
If Select("TRB") <> 0
  TRB->(DbcloseArea())
Endif
      

cArqB1   := CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArqB1, "TRB", .F., .F.)



If !Empty(cRefe)    // Se for digitada a Referencia
	
	
	//
	// Busca pela unidade de Medida
	//
	DbSelectArea("SZ3")
	DbSetOrder(2)       // Z3_FILIAL +  Z3_DESC  (NOVO INDICE)
	if DbSeek(xFilial("SZ3") + cRefe )
		lBucaUnid := .T.
		cChave   := "B1_X_MEDID"
	Else
		lBucaUnid := .F.
		cChave   := "B1_X_REFER"
	Endif
	
	
	#IFDEF TOP
		
		aStruSB1  := SB1->(dbStruct())
		lQuery    := .T.
		cAliasSB1 := "MFATC02SB1"
		
		
		//
		// Define todas as Similaridades Envolvidas
		//
		cQuery := ""
		cQuery := "SELECT B1_X_SIMIL "
		cQuery += "FROM "
		cQuery += RetSqlName("SB1")+" SB1 (NOLOCK) "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		if lBucaUnid
			cQuery += "SB1.B1_X_MEDID ='"+SZ3->Z3_CODIGO +"' AND "
		Else
			cQuery += "SB1.B1_X_REFER ='"+cRefe+"' AND "
		Endif
		cQuery += "SB1.D_E_L_E_T_<>'*' "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
		DbSelectArea(cAliasSB1)

		MemoWrit("!1_query unidade Medida.Sql",cQuery)   //   Apenas utilizado para validar a query.

		
		_concSimil := ""
		While !(cAliasSB1)->(Eof())
			
			If !((cAliasSB1)->B1_X_SIMIL $  _concSimil)
				_concSimil:= _concSimil + "'" + (cAliasSB1)->B1_X_SIMIL + "',"
			Endif
			(cAliasSB1)->(Dbskip())
			
		Enddo
		_concSimil := substr(_concSimil,1,len(_concSimil)-1)

		MemoWrit("!2_similaridades extraidas desta query.Sql",_concSimil)   //   Apenas utilizado para validar a query.

		(cAliasSB1)->(DbcloseArea())
		
		lContinue:= If(alltrim(_concSimil) = "",.f.,.t.)
		
		if 	lContinue
			
			//
			//  Contador de Registros
			//
			cQuery := ""
			cQuery := "SELECT COUNT(*) AS nCount "
			cQuery += "FROM "
			cQuery += RetSqlName("SB1")+" SB1 (NOLOCK) "
			cQuery += "WHERE "
			cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
			cQuery += "SB1.B1_X_SIMIL IN ("+_concSimil+") AND "
			cQuery += "SB1.D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
			nCount := (cAliasSB1)->nCount
			(cAliasSB1)->(DbcloseArea())
			
			
			//
			// Inicia Processo de Filtro
			//
			cQuery := ""
			cQuery := "SELECT "
			cQuery += " B1_X_REFER,B1_X_SUFIX,B1_X_MARCA,B1_ORIGEM,B1_X_PRODU,B1_ORIGEM,B1_UM,B1_X_CTSTD,B1_X_CTFOB,B1_X_NC_IM,B1_X_ABC,"
			cQuery += " B1_X_GIROQ,B1_X_LMN,B1_X_PQR,B1_X_NEOIL,B1_X_XYZ,B1_X_123,B1_X_ABC,B1_X_TMEA,B1_COD,B1_X_SIMIL,B1_X_SBSIM,B1_UPRC,B1_UCOM "
			cQuery += "FROM "
			cQuery += RetSqlName("SB1")+" (NOLOCK) SB1 "
			cQuery += "WHERE "
			cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
			cQuery += "SB1.B1_X_SIMIL IN ("+_concSimil+") AND "
			cQuery += "SB1.D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)

   		    MemoWrit("!3_usando as similaridades encontradas nesta query.Sql",cQuery)   //   Apenas utilizado para validar a query.

			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
			For nX := 1 To Len(aStruSB1)
				If ( aStruSB1[nX][2] <> "C" .and. alltrim(aStruSB1[nX][1])$cQuery )
					TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
				EndIf
			Next nX
			
			(cAliasSB1)->(DbGotop())
			
		Endif
		
	#ELSE
		
		If lBucaUnid
			
			DbSelectArea("SB1")
			DbGoTop()
			DbOrderNickname("B1UNMED")             //B1_X_REFER + B1_X_MEDID (NOVO INDICE
			
			nCount := 0
			If  Dbseek(xFilial("SB1") + SZ3->Z3_CODIGO )
				While !SB1->(Eof())  .and. SZ3->Z3_CODIGO = &cChave
					nCount++
					SB1->(DBSKIP())
				Enddo
			Endif
			
			Dbseek(xFilial("SB1") + SZ3->Z3_CODIGO  )
			
		Else
			
			DbSelectArea("SB1")
			DbGoTop()
			DbOrderNickname("B1REFER")             //B1_X_REFER + B1_X_SIMIL
			
			nCount := 0
			If  Dbseek(xFilial("SB1") + cRefe )
				While !SB1->(Eof())  .and. cRefe = &cChave
					nCount++
					SB1->(DBSKIP())
				Enddo
			Endif
			
			Dbseek(xFilial("SB1") + cRefe ) // Define todos os Similares
			
		Endif
		
	#ENDIF


    IF nCount = 0   
	   Aviso("ATENCAO", "Nenhum produto foi encontrado com esta Referencia...",{"&Ok"})
       lContinue := .f.
	Endif   


	if lContinue
		
		DbSelectArea(cAliasSB1)
		
		ProcRegua(nCount)
		
		While !(cAliasSB1)->(Eof())
			
			If  !lQuery
				if  cRefe <> &cChave
					Exit
				Endif
			Endif
			
			IncProc()
			
			
			//
			// Define Codigo Eis
			//
			aTrataEis := U_TrataEIS((cAliasSB1)->B1_COD)       // (Mfatc03)
			
			//
			// Define Condicao de Pagamento a ser Utilizada
			//
			//_cGetCond:= IIF( "MATA415" $ Upper(Funname()) ,M->CJ_CONDPAG,M->CCONDPAG)
			
			//
			// Define Preco de Venda
			//
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
			//³ Parametros                                                             ³
			//³ 1. < cGetCond > - Condicoes de Pagamento                               ³
			//³ 2 <._cProd    > - Produto Desejado                                     ³
			//³ 3.< NIL       > - I(Industria)/C(Comercio)                             ³
			//³                   Caso Nil a propria rotina define                     ³
			//³                   atraves da Origem.                                   ³
			//³  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  ³
			//³                   .F. Outras origens.                                  ³
			//³                   Motivo controle do custo que vem do acols.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aPrVenda  := U_PrVenda(_cGetCond,(cAliasSB1)->B1_COD,_cIndComer,.F.,_nFrete)
			
//
// Define Saldos em estoque
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros : Codigo do Produto                                                                  ³
//³                                                                                                ³
//³Retorna:                                                                                        ³
//³                                                                                                |
//³[01]     MALHA                                                                                  ³
//³[01][01] SaldoSb2()                       // DISPONIVEL                                         ³
//³[01][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
//³[01][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
//³[01][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
//³[01][05] B2_RESERVA                       // RESERVADO                                          ³
//³[01][06] B2_QEMP                          // EMPENHADO                                          ³
//³[01][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//³[01][08] B2_QPEDVEN                       // A FATURAR                                          ³
//³[01][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
//³[01][10] SB2->B2_QATU                     // FISICO                                             ³
//³[01][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
//³[01][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
//³                                                                                                |
//³[02]     MATRIZ                                                                                 ³
//³[02][01] SaldoSb2()                       // DISPONIVEL                                         ³
//³[02][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
//³[02][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
//³[02][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
//³[02][05] B2_RESERVA                       // RESERVADO                                          ³
//³[02][06] B2_QEMP                          // EMPENHADO                                          ³
//³[02][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//³[02][08] B2_QPEDVEN                       // A FATURAR                                          ³
//³[02][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
//³[02][10] SB2->B2_QATU                     // FISICO                                             ³
//³[02][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
//³[02][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
//³                                                                                                |
//³[03]     FILIAL                                                                                 ³
//³[03][01] SaldoSb2()                       // DISPONIVEL                                         ³
//³[03][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
//³[03][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
//³[03][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
//³[03][05] B2_RESERVA                       // RESERVADO                                          ³
//³[03][06] B2_QEMP                          // EMPENHADO                                          ³
//³[03][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//³[03][08] B2_QPEDVEN                       // A FATURAR                                          ³
//³[03][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
//³[03][10] SB2->B2_QATU                     // FISICO                                             ³
//³[03][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
//³[03][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
//³                                                                                                |
//³[04]     CONSIGNADO                                                                             ³
//³[04][01] SaldoSb2()                       // DISPONIVEL                                         ³
//³[04][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
//³[04][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
//³[04][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
//³[04][05] B2_RESERVA                       // RESERVADO                                          ³
//³[04][06] B2_QEMP                          // EMPENHADO                                          ³
//³[04][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//³[04][08] B2_QPEDVEN                       // A FATURAR                                          ³
//³[04][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
//³[04][10] SB2->B2_QATU                     // FISICO                                             ³
//³[04][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
//³[04][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
//³                                                                                                |
//³[05]     DEPOSITO FECHADO                                                                       ³
//³[05][01] SaldoSb2()                       // DISPONIVEL                                         ³
//³[05][02] B2_QNPT                          //     Controla Estoque  - Nossa em Poder de Terceiros³
//³[05][03] B2_QTNP                          //     Controla Estoque  - Terceiros em Nosso Poder   ³
//³[05][04] B2_QTER                          //     Nao Controla Est. - Saldo em Poder de Terceiros³
//³[05][05] B2_RESERVA                       // RESERVADO                                          ³
//³[05][06] B2_QEMP                          // EMPENHADO                                          ³
//³[05][07] B2_SALPEDI                       // TRANSITO (SC+PC+OP)                                |
//³[05][08] B2_QPEDVEN                       // A FATURAR                                          ³
//³[05][09] B2_QCLASS                        // A CLASSIFICAR                                      ³
//³[05][10] SB2->B2_QATU                     // FISICO                                             ³
//³[05][11] SB2->B2_QATU + SB2->B2_SALPEDI   // FISICO + TRANSITO         (Saldo Malha)            ³
//³[05][12]	nSaldoSB2    -  SB2->B2_QPEDVEN  // FISICO - R - E - FATURAR  (Saldo Malha Disp)       ³
//³                                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSaldoEst := U_SaldoSb2((cAliasSB1)->B1_COD)  // MFATC12.PRW
			

			Reclock("TRB",.T.)
			
			TRB->B1_X_REFER  :=  (cAliasSB1)->B1_X_REFER
			TRB->B1_X_SUFIX  :=  (cAliasSB1)->B1_X_SUFIX
			TRB->B1_X_MARCA  :=  (cAliasSB1)->B1_X_MARCA+" - "+(cAliasSB1)->B1_ORIGEM+" - "+IF((cAliasSB1)->B1_X_PRODU="1",SPACE(3),"MTK")
			TRB->B1_ORIGEM   :=  (cAliasSB1)->B1_ORIGEM
			TRB->B1_UM       :=  (cAliasSB1)->B1_UM
			TRB->B1_X_CTSTD  :=  (cAliasSB1)->B1_X_CTSTD
			TRB->B1_X_CTFOB  :=  (cAliasSB1)->B1_X_CTFOB
			
			TRB->CK_PRCVEN   :=  aPrVenda[02,03]    // Preco de Venda
			TRB->CK_X_MARGE  :=  aPrVenda[06,03]    //  % Rentabilidade
			TRB->CK_X_MARGV  :=  aPrVenda[03,03]    //  $  Rentabilidade
			TRB->CK_X_MARGA  :=  aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
			TRB->B1_X_NC_IM  :=  (cAliasSB1)->B1_X_NC_IM

			TRB->T_SMALHA    :=  aSaldoEst[01][11]+aSaldoEst[04][11] // FISICO + TRANSITO         (Saldo Malha)
			TRB->T_SDISPO    :=  aSaldoEst[01][12]+aSaldoEst[04][12] // FISICO - R - E - FATURAR  (Saldo Malha Disp)
			TRB->T_SMATRIZ   :=  aSaldoEst[02][12]+aSaldoEst[05][12] // Disponivel (Filiais+Deposito)                   
			TRB->T_SFILIAL   :=  aSaldoEst[03][12]-aSaldoEst[05][12] // Filiais-deposito fechado (Estoque+Deposito) Fisico - R - E - FATURAR (Filial)                
			TRB->T_SCONSIG   :=  aSaldoEst[04][12]    // CONSIGNADO (SALDO MALHA)
			TRB->T_RESERVA   :=  aSaldoEst[01][05]    // RESERVA
			TRB->T_STRANSI   :=  aSaldoEst[01][07]    // TRANSITO
			TRB->T_SEMPENH   :=  aSaldoEst[01][06]    // EMPENHO
			TRB->T_FATURAR   :=  aSaldoEst[01][08]    // A FATURAR
			TRB->T_CLASSIF   :=  aSaldoEst[01][09]    // A CLASSIFICAR
			
			TRB->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			TRB->B1_X_GIROQ  :=  (cAliasSB1)->B1_X_GIROQ
			TRB->B1_X_LMN    :=  (cAliasSB1)->B1_X_LMN
			TRB->B1_X_PQR    :=  (cAliasSB1)->B1_X_PQR
			TRB->B1_X_NEOIL  :=  (cAliasSB1)->B1_X_NEOIL
			TRB->B1_X_XYZ    :=  (cAliasSB1)->B1_X_XYZ
			TRB->B1_X_123    :=  (cAliasSB1)->B1_X_123
			TRB->B1_X_ABC    :=  (cAliasSB1)->B1_X_ABC
			//TRB->T_SAPANHE   :=  0                    // ???
			TRB->B1_X_TMEA   :=  (cAliasSB1)->B1_X_TMEA
			TRB->B1_COD      :=  (cAliasSB1)->B1_COD
			TRB->B1_X_SIMIL  :=  (cAliasSB1)->B1_X_SIMIL
			TRB->B1_X_SBSIM  :=  (cAliasSB1)->B1_X_SBSIM
			TRB->T_EIS       :=  aTrataEis[1,3]
			TRB->B1_UPRC     :=  (cAliasSB1)->B1_UPRC
			TRB->B1_UCOM     :=  (cAliasSB1)->B1_UCOM
			
			MsUnlock()
			
			
			DbSelectArea(cAliasSB1)
			(cAliasSB1)->(DBSKIP())
			
		Enddo
		
		DbSelectArea("TRB")
		DbGoTop()
		
		If lQuery
			dbSelectArea(cAliasSB1)
			dbCloseArea()
		EndIf
		
	Endif
	
Endif




Return(lContinue)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | GeraMarkB³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera dados no Trb conf. solitado no filtro para MarkBrowse ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraMarkB(cSimil,cArqB1,aStru,cRefe,oMark)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra Trb de acordo com a Similaridade                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  Select("TRB") <> 0 .and. !EmptY(cSimil)
	dbSelectArea("TRB")
	If !lF8
		Set FIlter to    // TRB->B1_X_SIMIL = cSimil
	Else
		Set FIlter to ;    //TRB->B1_X_SIMIL = cSimil .and.;
		TRB->T_SMATRIZ <> 0 .or.;
		TRB->T_SFILIAL  <> 0 .or.;
		TRB->T_SMALHA   <> 0 .or.;
		TRB->T_SCONSIG  <> 0 .or.;
		TRB->T_RESERVA  <> 0 .or.;
		TRB->T_STRANSI  <> 0 .or.;
		TRB->T_SEMPENH  <> 0 .or.;
		TRB->T_FATURAR  <> 0 .or.;
		TRB->T_CLASSIF  <> 0
		
		
	Endif
	IndRegua("TRB",_cArqPRO,"B1_X_SBSIM",,,"Indexando Registros...")
	DbGotop()
Endif

oMark:oBrowse:Refresh(.t.)

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ExistRefe ³ Autor ³                       ³ Data ³ 13.10.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Refencia                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExistRefe(oMark,cArqB1,aStru,cRefe,oRefe)
Local lRet:=.f.

Processa({|| lRet:=GeraListB(cRefe,oRefe,cArqB1,aStru),"Aguarde...Buscando Simil"})

GeraMarkB(@cArqB1,@aStru,@oMark,cRefe,oMark)

If !lRet
   oRefe:Refresh()
   SetFocus(oRefe:hWnd)
Endif

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Alice Y Yamamoto    ³Data³ 22.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aPerg := {}
Local cPerg := "CONSU2"+SPACE(4), nI, nPerg


//aadd(aPerg,{"01","Mes            ?","Mes            ?","Mes            ?","mv_ch1","N",2,0,0,"G","U_VALMES(MV_PAR01)","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aadd(aPerg,{"02","Ano            ?","Ano            ?","Ano            ?","mv_ch2","N",4,0,0,"G","U_VALANO(MV_PAR02)","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

aadd(aPerg,{"01","Industria/Consumo  ?","Industria/Consumo  ?","Industria/Consumo  ?","mv_ch1","N",01,0,0,"C","","MV_PAR01","Industria","","","","Consumo","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"02","Condicoes Pagamento?","Condicoes Pagamento?","Condicoes Pagamento?","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","","","","","SE4","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"03","Frete              ?","Frete              ?","Frete              ?","mv_ch3","N",10,2,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"04","% Icms             ?","% Icms             ?","% Icms             ?","mv_ch4","N",02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"05","% Comissoes        ?","% Comissoes        ?","% Comissoes        ?","mv_ch5","N",07,2,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
                        

_cIndComer:= MV_PAR01     //Industria ou Comercio
_cGetCond := MV_PAR02     //Condicoes Pagamento
_nFrete   := MV_PAR03     //Frete
_nIcms    := MV_PAR04     //Icms 
_ncomis   := MV_PAR05     //Somatoria das Comissoes


nPerg := Len(aPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao exista a Pergunta a mesma sera criada.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX1")
dbSetOrder(1)
For nI := 1 To nPerg
	If ! dbSeek(cPerg+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_DECIMAL  With aPerg[nI,08]
		Replace X1_PRESEL   With aPerg[nI,09]
		Replace X1_GSC		With aPerg[nI,10]
		Replace X1_VALID    With aPerg[nI,11]
		Replace X1_VAR01	With aPerg[nI,12]
		Replace X1_DEF01	With aPerg[nI,13]
		Replace X1_DEFSPA1	With aPerg[nI,14]
		Replace X1_DEFENG1	With aPerg[nI,15]
		Replace X1_CNT01	With aPerg[nI,16]
		Replace X1_DEF02	With aPerg[nI,17]
		Replace X1_DEFSPA2	With aPerg[nI,18]
		Replace X1_DEFENG2	With aPerg[nI,19]
		Replace X1_F3   	With aPerg[nI,20]
		MsUnlock()
	EndIf
Next





			
