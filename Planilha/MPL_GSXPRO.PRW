#include "PROTHEUS.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPL_GSXPROºAutor  ³                    º Data ³  01/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Amarrar Produto a Grupo de Simil e Sub-Grupo                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MPL_GSXPRO()

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)


Local cCadastro   := "Lanca Similaridade de Produtos"

Private _n_COD    := 0
//Private _n_Desc   := 0
Private _n_Refe   := 0
Private _n_Sufi   := 0
Private _n_Marca  := 0
Private _n_NC_IM  := 0
Private _n_SBSIM  := 0
               
PRIVATE aRotina 	:= {{"Alterar"      ,"AxAltera", 0 , 4, 4} } 

Private aHeader   := {}
Private aCols     := {} 


Private cCodigo := SPACE(6)              //	Código SIMIL
Private cDesGru := Criavar("Z2_DESCR")   // 	Descricao do Grupo
Private cCodMed := Criavar("Z2_CODMED")  //    Cod Medida
Private cDesMed := Criavar("Z3_DESC")    //    Descricao da Medida
Private nQuant  := 0

Private oGet,oCodigo,oDesGru,oCodMed,oDesMed

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aHeader             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("B2_COD")       // Codigo do Produto
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"U_ValSku(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
//DbSeek("B1_DESC")      // Descricao
//Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("B1_X_REFER")    // Referencia
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("B1_X_SUFIX")    // Sufixo
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("B1_X_MARCA")   // Marca
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("B1_ORIGEM")    // Origem
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
                       // B1_X_SBSIM Sub.Grupo.
                       // A troca de B1_X_SBSIM por SUBSIMIL E devido o mesmo estar somente visual no 
                       // cadastro de produtos e aqui precisa ser um campo aberto.
                       //Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"U_ValSimil(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
AADD(aHeader,{ "Sub-Simil","SUBSIMIL","@!",6,0,"U_ValSimil(.T.)","","C","", ""} )
AADD(aHeader,{ "","VAZIO","@!",1,0,,x3_usado,"C","", ""} )
AADD(aHeader,{ "","VAZIO2","@!",1,0,,x3_usado,"C","", ""} )
              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens no Cabecalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_n_COD    := aScan(aHeader,{|x| AllTrim(x[2])=="B2_COD" })        // Codigo do Produto
//_n_Desc   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_DESC" })       // Descricao
_n_Refe   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_REFER" })    // Referencia
_n_Sufi   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SUFIX" })    // Sufixo
_n_Marca  := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_MARCA" })    // Marca
_n_NC_IM  := aScan(aHeader,{|x| AllTrim(x[2])=="B1_ORIGEM" })     // Origem
_n_SBSIM  := aScan(aHeader,{|x| AllTrim(x[2])=="SUBSIMIL" })    // Sub.Grupo.
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Janela de Consulta          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Esta rotina e realizada conforme os filtros.


AAdd( aObjects, { 0,      30  , .T., .F. } )
AAdd( aObjects, { 100,    160, .T. , .T. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas
AAdd( aObjects, { 0,     020, .T. , .F. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas

// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )     
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{195,250}})

DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd pixel

@ aPosObj[1,1],aPosObj[1,2]/*005*/   TO aPosObj[1,3],aPosObj[1,4]/*380*/ OF oDlgCons PIXEL

@ 025,010   SAY "Grp.Similar:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 025,230   SAY "Medida:"			    size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 025,050   MSGET oCodigo	 VAR  cCodigo		Picture "@!"  F3 "SZ2"        Size 30,8 OF oDlgCons PIXEL Valid ValCod()
@ 025,090   MSGET oDesGru	 VAR  cDesGru		Picture "@!"                  Size 100,8 OF oDlgCons PIXEL Valid .t. When(.f.)

@ 025,280   MSGET oCodMed	 VAR  cCodMed		Picture "@!"                  Size 30,8 OF oDlgCons PIXEL Valid .t. When(.f.)
@ 025,320   MSGET oDesMed 	 VAR  cDesMed		Picture "@!"                  Size 100,8 OF oDlgCons PIXEL Valid .t. When(.f.)
                                                                                                                             
oGet:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"U_VALLINE()","U_VALTUDO()",,.T.,{"B2_COD","SUBSIMIL"},,.T.,300)

//@ aPosObj[3,1], 010 BUTTON "&Confirmar"	SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Confirma())
//@ aPosObj[3,1], 060 BUTTON "&Sair"	 		SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( oDlgCons:End() )

ACTIVATE MSDIALOG oDlgCons ON INIT RfatBar(oDlgCons,{|| Confirma() },{||oDlgCons:End()}) CENTERED

Return
        
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ValCod() ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a Tela                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValCod()

DbSelectArea("SZ2")
DbSetorder(1)
If !Dbseek(xFilial("SZ2")+cCodigo)
   Aviso("ATENCAO", "Grupo de Similaridade nao Cadastrado , verifique !",{"&Ok"})
   Return(.f.)
Endif


DbSelectArea("SZ3")
DbSetorder(1)
If !Dbseek(xFilial("SZ3")+SZ2->Z2_CODMED)
   Aviso("ATENCAO", "Existe problema neste grupo de Similaridade, o grupo esta apontando para uma medida nao cadastrada no sistema , verifique !",{"&Ok"})
   Return(.f.)
Endif

cDesGru  := SZ2->Z2_DESCR
cCodMed	 := SZ2->Z2_CODMED
cDesMed	 := SZ3->Z3_DESC	

oDesGru:Refresh()
oCodMed:Refresh()
oDesMed:Refresh()	

MsgRun( OemToAnsi( "Aguarde. Buscando Produtos com esta Similaridade " ),"",{||MontAcols()})


Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MontAcols ³ Autor ³ Anderson              ³ Data ³ 03.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Browse                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontAcols()
Local cQuery   := ""
Local nLin     := 0
Local cAliasSB1:= ""              
Local cChave   := ""

aCols := {} // Zera aCols para que possa receber os novos dados filtrados

#IFDEF TOP
	
	aStruSB1  := SB1->(dbStruct())             
	lQuery    := .T.
	cAliasSB1 := "QUERYSB1"
	
	cQuery := ""
	cQuery := "SELECT SB1.* "
	cQuery += "FROM "
	cQuery += RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE "
	cQuery += " SB1.B1_FILIAL  ='" + xFilial("SB1") + "' AND"
	cQuery += " SB1.B1_X_SIMIL ='" + cCodigo + "' AND"
	cQuery += " SB1.D_E_L_E_T_=' ' "
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)
	For nX := 1 To Len(aStruSB1)
		If ( aStruSB1[nX][2] <> "C" .and. alltrim(aStruSB1[nX][1])$cQuery  )
			TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
		EndIf
	Next nX
	
	(cAliasSB1)->(DbGotop())
	                         
#ELSE
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por Filial + Simil + Eis                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery   := .F.
	cAliasSB1:= "SB1"
	cChave   := xFilial("SB1") + cCodigo

	dbSelectArea("SB1")
	DbGoTop()
	DbOrderNickname("B1SIMIL")             //B1_X_SIMIL + EIS

	SET SOFTSEEK ON
	DbSeek(cChave,.T.)
	SET SOFTSEEK OFF
	
#ENDIF


DbSelectArea(cAliasSB1)


//ProcRegua(nCount)
While !(cAliasSB1)->(Eof())
	
	If  !lQuery
        
        // O substr abaixo e devido a chave nem sempre vir completa todos o numero do Eis.
		if 	cChave <> (cAliasSB1)->(B1_FILIAL + B1_SIMIL)
			exit
		Endif
		
	Endif
	
	//IncProc()
	
	AADD(aCols,Array(Len(aHeader)+1))
	nLin                        := Len(aCols)
	aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado

	aCols[nLin, _n_COD    ] := (cAliasSB1)->B1_COD
	//aCols[nLin, _n_Desc  ] := (cAliasSB1)->B1_Desc       // Descricao
	aCols[nLin, _n_Refe  ] := (cAliasSB1)->B1_X_REFER     // Referencia
	aCols[nLin, _n_Sufi  ] := (cAliasSB1)->B1_X_SUFIX     // Sufixo
	aCols[nLin, _n_Marca  ] := (cAliasSB1)->B1_X_MARCA    // Marca
	aCols[nLin, _n_NC_IM  ] := (cAliasSB1)->B1_ORIGEM     // Importados / Nacionais
	aCols[nLin, _n_SBSIM  ] := (cAliasSB1)->B1_X_SBSIM    // Eis contatenado
	
	(cAliasSB1)->(DbSkip())
	
Enddo


If  lQuery
	DbSelectArea(cAliasSB1)
	(cAliasSB1)->(DbCloseArea())
Endif


If Len(acols) = 0
   AADD(aCols,Array(Len(aHeader)+1))
   nLin                        := Len(aCols)
   aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado

   aCols[nLin, _n_COD    ] := Criavar("B1_COD")
   aCols[nLin, _n_SBSIM  ] := Criavar("B1_X_SBSIM")

Else
   nQuant := Len(aCols)  // Controla as linhas que podem ser alteradas
Endif


// Atualiza a GetDados 
n:= 1


// Coloca em Ordem de Sub Simil
aCols := Asort(aCols,,,{|x,y| x[_n_SBSIM] < y[_n_SBSIM]})

oget:obrowse:Refresh() 

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VALSIMIL() ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida Simil escolhido                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VALSIMIL(lValid)

Local _cProdu   := 0
Local _cSubSi   := 0
Local cAliasSB1 := "SB1"
Local lRet      := .T.
                      
DEFAULT lValid    := .F.

IF lValid .AND. TYPE("M->SUBSIMIL") <>"U" 
   M->SUBSIMIL := STRZERO(VAL(M->SUBSIMIL),6)
Endif

_cProdu    :=IIF(lValid .AND. TYPE("M->B2_COD")     <>"U",&("M->B2_COD")     ,aCols[n][_n_COD] )
_cSubSi    :=IIF(lValid .AND. TYPE("M->SUBSIMIL") <>"U",&("M->SUBSIMIL") ,aCols[n][_n_SBSIM] )

For nY = 1 to len(Acols)

    if _cSubSi = aCols[nY][_n_SBSIM] .and. nY <> n
       
       Aviso("ATENCAO", "Sub Simil ja Utilizado , verifique !",{"&Ok"})

       M->SUBSIMIL := aCols[n][_n_SBSIM]

       lRet:= .f.         
       
    Endif

Next


Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ValSku()   ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida Sku escolhida                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValSku(lValid)

Local _cProdu   := 0
Local _cSubSi   := 0
                      
DEFAULT lValid    := .F.

_cProdu    :=IIF(lValid .AND. TYPE("M->B2_COD")     <>"U",&("M->B2_COD")   ,aCols[n][_n_COD] )
_cSubSi    :=IIF(lValid .AND. TYPE("M->SUBSIMIL")   <>"U",&("M->SUBSIMIL") ,aCols[n][_n_SBSIM] )
         

If n <= nQuant 
   if _cProdu  <> aCols[n,_n_COD]
      Aviso("ATENCAO", "Produto nao pode ser alterado...",{"&Ok"})
   Endif
   M->B2_COD := aCols[n][_n_COD]
   Return .f.
Endif   

IF Empty(_cProdu)  
   Aviso("ATENCAO", "Favor informar o codigo da Sku...",{"&Ok"})
   Return(.f.)  
Endif


DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+_cProdu)
   Aviso("ATENCAO", "Produto nao cadastrado...",{"&Ok"})
   Return(.f.)  
Endif

// Dispara Gatilhos
aCols[n, _n_COD    ] := SB1->B1_COD
//aCols[n, _n_Desc   ] := SB1->B1_Desc     // Descricao
aCols[n, _n_Refe   ] := SB1->B1_X_REFER   // Refencia
aCols[n, _n_Sufi   ] := SB1->B1_X_SUFIX    // Sufixo
aCols[n, _n_Marca  ] := SB1->B1_X_MARCA    // Marca
aCols[n, _n_NC_IM  ] := SB1->B1_ORIGEM     // Importados / Nacionais
aCols[n, _n_SBSIM  ] := SB1->B1_X_SBSIM    // Subsimilo Eis contatenado

/* Nao estava funcionando em tempo de execucao
   provavelmente devido serem funcoes interanas ao acols
// Atualiza a GetDados 
n:= 1
// Coloca em Ordem de Sub Simil
aCols := Asort(aCols,,,{|x,y| x[5] < y[5]})
oget:obrowse:Refresh() 
*/

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ Valline() ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida toda a informacao na Linha                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VALLINE(lValid)

Local _cProdu   := 0
Local _cSubSi   := 0
Local cAliasSB1 := "SB1"
                      
DEFAULT lValid    := .F.

_cProdu    :=IIF(lValid .AND. TYPE("M->B2_COD")     <>"U",&("M->B2_COD")     ,aCols[n][_n_COD] )
_cSubSi    :=IIF(lValid .AND. TYPE("M->B1_X_SIMIL") <>"U",&("M->B1_X_SIMIL") ,aCols[n][_n_SBSIM] )


IF Empty(_cProdu) .AND. !aCols[n,Len(aHeader)+1] 
   Aviso("ATENCAO", "Favor informar o codigo da Sku...",{"&Ok"})
   Return(.f.)  
Endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ValTudo() ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida toda a informacao na Linha                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VALTudo()

aCols := Asort(aCols,,,{|x,y| x[5] < y[5]})

// Atualiza a GetDados 
n:=1
oget:obrowse:Refresh() 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Confirma() ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Confirma dados da Tela                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Confirma()
Local nLin := 0

For nLin:= 1 to len(Acols)
	
	if  !aCols[nLin,Len(aHeader)+1]          // Nao Deletado
		                                            
		DbSelectArea("SB1")
		DbSetOrder(1)
		If Dbseek(xFilial("SB1")+aCols[nLin, _n_COD    ])
			
			// Verifica se alterou Grupo ou Sub-Grupo
			If aCols[nLin, _n_SBSIM  ] <> SB1->B1_X_SBSIM  .OR.;
				cCodigo                  <> SB1->B1_X_SIMIL

            If !Empty(SB1->B1_X_SBSIM) 
               lAlteracao:=.T.
            Endif
            
				DbSelectArea("SZ2")
				DbSetorder(1)
				If DbSeek(xFilial("SZ2") + cCodigo )
					Reclock("SB1",.F.)
					SB1->B1_X_SIMIL    := cCodigo                   // Grupo de Similaridade
					SB1->B1_X_SBSIM  := aCols[nLin, _n_SBSIM  ]  // Sub Grupo
					SB1->B1_X_MEDID    := SZ2->Z2_CODMED           // Deve alterar a Medida Caso altere o Grupo
				Endif

		      ////
    		   // A funcao abaixo tem como objetivo ajustar os historicos em funcao da inclusao ou alteracao do Eis.
      		// E importante deixar claro ao usuario que apos a efetivacao desta manutencao devera ser efetuada um novo fechamento da 
     			// Planilha.
      		////
      		
				MsgRun( OemToAnsi( "Aguarde. Efetuando ajustes nos Historicos por Sku e Simil e Eis..." ),"",{||U_RegravaEIS(.F.)})
				

			Endif

		Endif

	Endif

Next nLin


cCodigo := SPACE(6)              //	Código SIMIL
cDesGru := Criavar("Z2_DESCR")   // 	Descricao do Grupo
cCodMed := Criavar("Z2_CODMED")  //    Cod Medida
cDesMed := Criavar("Z3_DESC")    //    Descricao da Medida
acols   := {}
n       := 1


// Refrash de Tela
oDesGru:Refresh()
oCodMed:Refresh()
oDesMed:Refresh()	
oget:obrowse:Refresh() 

// Foco no Simil
SetFocus(oCodigo:hWnd) 

Return(.t.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³                       ³ Data ³ 03.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do MPL_001                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RfatBar(oDlgCons,bOk,bCancel,nOpc)

PRIVATE aButtons  := {}
PRIVATE aButonUsr := {}
PRIVATE nI        := 0

//aadd(aButtons,{"PROJETPMS",{|| Tela_SZ8() }, "<F4> - Manutencao SKU" })

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))




