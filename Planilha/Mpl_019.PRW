#INCLUDE  "FIVEWIN.CH"
#INCLUDE  "TCBROWSE.CH"
#INCLUDE  "SIGA.CH"
#INCLUDE  "FONT.CH"
#INCLUDE  "COLORS.CH"
#INCLUDE  "VKEY.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MPL_019   ºAutor  ³ Anderson           º Data ³  06/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Arvore de Encaminhamento ou                                 º±±
±±º          ³Metodo Seg/Dimensionamento Etq                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_019()


Private _npCODLMN	:= 0
Private _npDESCLMNC	:= 0
Private _npCODPQR	:= 0
Private _npDESCPQR	:= 0
Private _npCDNEOIL	:= 0
Private _npD_NEOIL	:= 0
Private _npCODXYZ	:= 0
Private _npDESCXYZ	:= 0
Private _npCOD123	:= 0
Private _npDESC123	:= 0
Private _npCODABC	:= 0
Private _npDESCABC	:= 0
Private _npAUXILIA	:= 0
Private _npMCIDEAL 	:= 0
Private _npMCMIN  	:= 0
Private cCadastro   := "Arvore de Dimensionamento "
Private cCodMet	    := " "
Private cDescri	    := CriaVar("ZG_DESCMET")
Private cDisNor	    := Space(50)
Private cSisTra	    := Space(40)
Private aCols       := {}
Private aHeader     := {}
Private nopc        := 3
PRIVATE aRotina     := {{"","",0,1},{"","",0,1},{"","",0,3,3},{"","",0,4,4},{"","",0,6}}
Private aItems1     := {}
Private aItems2     := {}

Private cConteudo   := ""
Private aItemAux    := {}
Private oDlgCons,oGet1,oCodMet,oDescri,oDisNor,oSisTra
Private aAltCamp:={"ZH_CODPQR","ZH_CDNEOIL","ZH_CODXYZ",;
"ZH_COD123","ZH_CODABC","ZH_LMN",;
"ZH_MCIDEAL","ZH_MCMIN"}
Private lMetodo      := .T.               
Private lSaida       := .F. 

Public  n
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tabela de Distribuicao Normal                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZQ")
DbGotop()
while !SZQ->(EOF())
	cConteudo:="NIVEL DE SERVICO:  "+TRANSFORM(SZQ->ZQ_NIVSER,"@E 99.99") +"   -   FATOR SEGURANCA:  "+TRANSFORM(SZQ->ZQ_FATSEG,"@E 99.99")
	aadd(aItems1 ,cConteudo)
	aadd(aItemAux,{cConteudo,SZQ->ZQ_CODIGO})
	SZQ->(DBSKIP())
Enddo
 
aItems1 := Asort(aItems1,,,{|x,y|  x   <  y })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sistema de Tratamento                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Apos conversa com o Sr. Maurcio o mesmo explicou junto com alexandre
// que este campo e meramente informativo visto o metodo ser o responsavel
// em indicar qual a formula de calculo sera utilizada no fechamento do mes.
aadd(aItems2 ,"01 - EMPURRAR POR PONTO DE PEDIDO ")
aadd(aItems2 ,"02 - EMPURRAR POR ESTOQUE MINIMO  ")
aadd(aItems2 ,"03 - EMPURRAR POR ESTOQUE MAXIMO  ")
aadd(aItems2 ,"04 - PUXAR SOB ENCOMENDA          ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aHeader             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("ZH_CODPQR")     // Classificacao PQR  (Popularidade)
Aadd(aHeader,{ "Cod.PQR"   , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_PRQ(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_DESCPQR")
Aadd(aHeader,{ "Popularidade", x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_CDNEOIL")    // Classificacao Neoil (Tipode Demanda)
Aadd(aHeader,{ "Cod.NEOIL" , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_NEOIL(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_D_NEOIL")
Aadd(aHeader,{ "Tipo de Demanda", x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_CODXYZ")      // Classificacao XYZ   (Criticidade)
Aadd(aHeader,{ "Cod.XYZ"   , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_XYZ(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_DESCXYZ")
Aadd(aHeader,{ "Tipo de Demanda", x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_COD123")      // Classificacao 123   (Aquisicao)
Aadd(aHeader,{ "Cod.123"   , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_123(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_DESC123")
Aadd(aHeader,{ "Aquisicao" , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_CODABC")      // Classificacao ABC   (Aquisicao)
Aadd(aHeader,{ "Cod.ABC"   , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_ABC(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_DESCABC")
Aadd(aHeader,{ "Classificacao ABC", x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_LMN")         // Classificacao HLM   (Giro)
Aadd(aHeader,{ "Cod.LMN"   , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"U_VAL_LMN(.T.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_DESCLMN")
Aadd(aHeader,{ "Giro  "    , x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_AUXILIA")     // Auxiliar
Aadd(aHeader,{ "Cod.Auxiliar", x3_campo, "@!" ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_MCIDEAL")     // Margem Alvo
Aadd(aHeader,{ "Marg.Contr.Alvo", x3_campo, x3_picture, X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("ZH_MCMIN")       // Margem de Contribuicao Min.Comis
Aadd(aHeader,{ "Marg.Cont.Min.p/ Comissao", x3_campo, x3_picture ,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
AADD(aHeader,{ "","VAZIO","@!",1,0,,x3_usado,"C","", ""} )


// Fui obrigado a criar um acols vazio na entrada devido 
// estar trabalhando somente com alteracao na Getdados.
// logo caso nao fosse criado este acols daria erro ao entrar.
AADD(aCols,Array(Len(aHeader)+1))
nLin                        := Len(aCols)
aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado
                          
DbSelectArea("SX3")
DbSetOrder(2)
For nY := 1 to Len(aHeader)
    if DbSeek(aHeader[nY][2])
       IF x3_tipo == "C"
	   	  aCOLS[1][nY] := SPACE(x3_tamanho)
	   Elseif x3_tipo == "N"
   		  aCOLS[1][nY] := 0
	   Elseif x3_tipo == "D"
	      aCOLS[1][nUsado] := dDataBase
	   Elseif x3_tipo == "M"
	      aCOLS[1][nUsado] := ""
	   Endif
	Endif
	dbSkip()
End
	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define posicao dos Campos            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_npCODLMN	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_LMN"})
_npDESCLMNC	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_DESCLMN"})
_npCODPQR	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_CODPQR"})
_npDESCPQR	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_DESCPQR"})
_npCDNEOIL	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_CDNEOIL"})
_npD_NEOIL	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_D_NEOIL"})
_npCODXYZ	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_CODXYZ"})
_npDESCXYZ	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_DESCXYZ"})
_npCOD123	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_COD123"})
_npDESC123	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_DESC123"})
_npCODABC	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_CODABC"})
_npDESCABC	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_DESCABC"})
_npAUXILIA	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_AUXILIA"})
_npMCIDEAL 	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_MCIDEAL"})
_npMCMIN  	:= aScan(aHeader,{|x| AllTrim(x[2])=="ZH_MCMIN"})




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Janela de Consulta          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM 106,65 TO 552-20,835  OF oMainWnd pixel

@ 015,005   TO 080,380 OF oDlgCons PIXEL

@ 020,060   SAY "Codigo do Metodo:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,060   SAY "Descricao:"				size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,060   SAY "Distribuicao Normal:"		size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 065,060   SAY "Sistema de Tratamento:"	size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5


@ 020,120   MSGET oCodMet	VAR  cCodMet	Picture "@!"  /*F3 SZG*/ Size 010,8 OF oDlgCons WHEN lMetodo PIXEL Valid Val_CodMet()
@ 035,120   MSGET oDescri	VAR  cDescri 	Picture "@!"  Size 160,8 OF oDlgCons PIXEL When  .t. Valid .t.
@ 050,120   MSCOMBOBOX oDisNor VAR cDisNor ITEMS aItems1 SIZE  160,8 OF oDlgCons PIXEL Valid .t.
@ 065,120   MSCOMBOBOX oSisTra VAR cSisTra ITEMS aItems2 SIZE  140,8 OF oDlgCons PIXEL Valid .t.

//@ 050,120   MSGET oDisNor	VAR  cDisNor   	Picture "@!"  Size 140,8 OF oDlgCons PIXEL When .F. Valid .t.
//@ 065,120   MSGET oSisTra	VAR  cSisTra   	Picture "@!"  Size 080,8 OF oDlgCons PIXEL When .F. Valid .t.
oGet1:=MSGetDados():New(095,005,195,380,nopc,"U_ValAll()","AllwaysTrue()","",.T.,aAltCamp,,.T.,300)



@ 199, 010 BUTTON "&Confirmar"		SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Grava(),Limpar())
@ 199, 060 BUTTON "&Deletar"		SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Deletar())
@ 199, 110 BUTTON "&Limpar"	    	SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Limpar())
@ 199, 160 BUTTON "&Sair"			SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( oDlgCons:End())

ACTIVATE MSDIALOG oDlgCons ON INIT RfatBar(oDlgCons,{|| Grava(),Limpar() },{||oDlgCons:End()}) CENTERED

Return


Static Function Limpar()

//
// Limpa a Tela
//
cCodMet	    := CriaVar("ZG_CODIGO")
cDescri	    := CriaVar("ZG_DESCMET")
cDisNor	    := Space(50)
cSisTra	    := Space(40)
aCols       := {}

// Fui obrigado a criar um acols vazio na entrada devido 
// estar trabalhando somente com alteracao na Getdados.
// logo caso nao fosse criado este acols daria erro ao entrar.
AADD(aCols,Array(Len(aHeader)+1))
nLin                        := Len(aCols)
aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado

//
// Libera para a Solicitacao do novo Metodo
//
lMetodo :=.T.
SetFocus(oCodMet:hWnd)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Deletar  ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campos do Acols                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Deletar()

aCols[n,Len(aHeader)+1] := .T.     // Item Nao Deletado  

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Grava    ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campos do Acols                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Grava()

Local cCodDist  := ""
Local _cChave   := ""


//
// Verifica se ha informacoes a segerem gravadas
//
If Len(Acols) != 0  .and. !EmptY(cCodMet)
	
	//
	// Executando Manutencao no SZH
	//
	For nY := 1 to Len(Acols)
		
		_cChave     :=  aCols[nY][_npAUXILIA]
		
		if !EmptY(_cChave)                  // Analisa se existe problemas de Chave
			
			if aCols[nY,Len(aHeader)+1]     // Item Deletado
				
				DbSelectArea("SZH")
				DbSetOrder(2)
				IF  DbSeek(xFilial("SZH")+_cChave)
					Reclock("SZH",.F.)
					SZH->(DbDelete())
					MsUnlock()
				Endif
				
			Else
				
				
				DbSelectArea("SZH")
				DbSetOrder(2)
				IF  DbSeek(xFilial("SZH")+_cChave)
					Reclock("SZH",.F.)
				Else
					Reclock("SZH",.T.)
				Endif
				
				SZH->ZH_FILIAL   := xFilial("SZH")
				SZH->ZH_CODMET   := cCodMet
				SZH->ZH_AUXILIA  := _cChave
				SZH->ZH_CODPQR   := aCols[nY][_npCODPQR]
				SZH->ZH_DESCPQR  := aCols[nY][_npDESCPQR]
				SZH->ZH_CDNEOIL  := aCols[nY][_npCDNEOIL]
				SZH->ZH_D_NEOIL  := aCols[nY][_npD_NEOIL]
				SZH->ZH_CODXYZ   := aCols[nY][_npCODXYZ]
				SZH->ZH_DESCXYZ  := aCols[nY][_npDESCXYZ]
				SZH->ZH_COD123   := aCols[nY][_npCOD123]
				SZH->ZH_DESC123  := aCols[nY][_npDESC123]
				SZH->ZH_CODABC   := aCols[nY][_npCODABC]
				SZH->ZH_DESCABC  := aCols[nY][_npDESCABC]
				SZH->ZH_LMN      := aCols[nY][_npCODLMN]
				SZH->ZH_DESCLMN  := aCols[nY][_npDESCLMNC]
				SZH->ZH_MCIDEAL  := aCols[nY][_npMCIDEAL]
				SZH->ZH_MCMIN    := aCols[nY][_npMCMIN]
				
			Endif
			
		Endif
		
	Next nY
	
	
	
	
	//
	// Executando Manutencao no SZG
	//
	DbSelectArea("SZH")
	DbSetOrder(1)
	IF  DbSeek(xFilial("SZH")+cCodMet)
		
		//
		//  Determino o novo Codigo de Distribuicao
		//
		//	aadd(aItems1 ,cConteudo)
		//	aadd(aItemAux,{cConteudo,SZQ->ZQ_CODIGO})
		nPos    := aScan(aItemAux , {|x| AllTrim(x[1])== Alltrim(cDisNor) })
		cCodDist:= aItemAux[nPos][2]   // Codigo da Distribuicao Escolhida.
		
		
		DbSelectArea("SZG")
		DbSetOrder(1)
		If  DbSeek(xFIlial("SZG")+cCodMet)
			Reclock("SZG",.F.)
		Else
			Reclock("SZG",.T.)
		Endif
		SZG->ZG_FILIAL := xFilial("SZG")
		SZG->ZG_CODIGO := cCodMet
		SZG->ZG_DESCMET:= cDescri
		SZG->ZG_CNORM  := cCodDist
		SZG->ZG_DSCDIST:= cDisNor
		SZG->ZG_SISTEMA:= substr(cSisTra,1,2)
		SZG->ZG_DSCTRAT:= substr(cSisTra,6,15)
		MsUnlock()
		
	Else
		
		DbSelectArea("SZG")
		DbSetOrder(1)
		If  DbSeek(xFIlial("SZG")+cCodMet)
			Reclock("SZG",.F.)
			DbDelete()
			MsUnlock()
		Endif
		
	Endif
	
Endif
               

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Val_CodMet³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Browse clicando ou nao em RENOVAR               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Val_CodMet()
Local _lRet     := .T.
Local nLin      := 0         
Local cCodDist  := ""


//
// Avalia se o Metodo foi Informado para poder continuar             
//
If  Empty(cCodMet)
    Return(.T.)
Elseif len(aItems1) = 0
    Aviso("ATENCAO", "Tabela de Distribuicao se encontra vazia..",{"&Ok"})
    Return(.f.)
Endif

//
// Limpa a Tela
//
cDescri	    := CriaVar("ZG_DESCMET")
cDisNor	    := Space(50)
cSisTra	    := Space(40)
aCols       := {}


DbSelectArea("SZG")
DbSetOrder(1)
If  DbSeek(xFIlial("SZG")+cCodMet)

	//
	// Descricao do Metodo Utilizado com base no posicionamento do SZG.
	//
	cDescri := SZG->ZG_DESCMET
	//
	//  Define o Nivel e Fator de Seguranca atual com base no posicionamento do SZG.
	//
	//  Nivel e Fator de Seguranca atual.
	//	aadd(aItems1 ,cConteudo)
	//	aadd(aItemAux,{cConteudo,SZQ->ZQ_CODIGO})
	cDisNor := aItems1[1]     // DEFAULT
	nPos    := aScan(aItemAux , {|x| x[2] ==  SZG->ZG_CNORM })
	If  nPos <> 0
		cDisNor := aItemAux[nPos][1]
	Endif
	//
	// Define o Sistema de Tratamento com base no Posicionamento do SZG.
	//
	cSisTra	:= aItems2[1]
	For nY := 1 to Len(aItems2)
		if SZG->ZG_SISTEMA = SUBSTR(aItems2[nY],1,2)
			cSisTra := aItems2[nY]
		Endif
	Next nY
	//
	// Monta o acols com base no SZH filtrado pelo Metodo.
	//
Else  


	//
	// Define a Distribuicao Normal
	//
	cDisNor := aItems1[1]   //DEFAULT
	nPos    := aScan(aItemAux , {|x| x[2] ==  SZG->ZG_CNORM })
	If nPos <> 0
		cDisNor := aItemAux[nPos][1]
	Endif
	//
	// Define o Sistema de Tratamento com base no Posicionamento do SZG.
	//
	cSisTra	:= aItems2[1]
	For nY := 1 to Len(aItems2)
		if SZG->ZG_SISTEMA = SUBSTR(aItems2[nY],1,2)
			cSisTra := aItems2[nY]
		Endif
	Next nY
    //
	// Cria o Metodo pois durante o processo de Implantacao esta tabela ira estar fazia
	// mas durante o processo de confirmacao e validado se o metodo criado esta associado
    // ha algum elemento da Arvore.
    //
	DbSelectArea("SZG")
	DbSetOrder(1)
	If  DbSeek(xFIlial("SZG")+cCodMet)
		Reclock("SZG",.F.)
	Else
		Reclock("SZG",.T.)
	Endif
	SZG->ZG_FILIAL := xFilial("SZG")
	SZG->ZG_CODIGO := cCodMet
	SZG->ZG_DESCMET:= cDescri
	SZG->ZG_CNORM  := cCodDist
	SZG->ZG_DSCDIST:= cDisNor
	SZG->ZG_SISTEMA:= substr(cSisTra,1,2)
	SZG->ZG_DSCTRAT:= substr(cSisTra,6,15)
	MsUnlock()


Endif



DbSelectArea("SZH")
DbSetOrder(1)
DbGotop()
IF  DbSeek(xFilial("SZH")+cCodMet)
	While !SZH->(EOF()) .and.;
		xFilial("SZH") == SZH->ZH_FILIAL .and.;
		SZH->ZH_CODMET == cCodMet
		
		AADD(aCols,Array(Len(aHeader)+1))
		nLin                        := Len(aCols)
		aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado
		
		
		aCols[nLin, _nPCODLMN  ]	:= SZH->ZH_LMN
		aCols[nLin, _nPDESCLMNC]	:= SZH->ZH_DESCLMN
		aCols[nLin, _nPCODPQR  ]	:= SZH->ZH_CODPQR
		aCols[nLin, _nPDESCPQR ]	:= SZH->ZH_DESCPQR
		aCols[nLin, _nPCDNEOIL ]	:= SZH->ZH_CDNEOIL
		aCols[nLin, _nPD_NEOIL ]	:= SZH->ZH_D_NEOIL
		aCols[nLin, _nPCODXYZ  ]	:= SZH->ZH_CODXYZ
		aCols[nLin, _nPDESCXYZ ]	:= SZH->ZH_DESCXYZ
		aCols[nLin, _nPCOD123  ]	:= SZH->ZH_COD123
		aCols[nLin, _nPDESC123 ]	:= SZH->ZH_DESC123
		aCols[nLin, _nPCODABC  ]	:= SZH->ZH_CODABC
		aCols[nLin, _nPDESCABC ]	:= SZH->ZH_DESCABC
		aCols[nLin, _nPAUXILIA ]	:= SZH->ZH_AUXILIA
		aCols[nLin, _nPMCIDEAL ] 	:= SZH->ZH_MCIDEAL
		aCols[nLin, _nPMCMIN   ]	:= SZH->ZH_MCMIN
		
		SZH->(DBSKIP())
		
	Enddo
Endif

If Len(Acols) = 0
   AADD(aCols,Array(Len(aHeader)+1))
   nLin                        := Len(aCols)
   aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado

	For nX := 1 To Len(aHeader)
		aCols[nLin][nX] := Criavar(aHeader[nX][2])
	Next nX

Endif

oDlgCons:Refresh()
oGet1:Refresh()

lMetodo :=.f.
SetFocus(oDescri:hWnd)

Return (.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³          ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abaixo funcoes de validacao de Tela.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VAL_LMN(lValid)
Local _cVCODLMN	:= IIF(lValid .AND. TYPE("M->ZH_LMN")     <>"U",&("M->ZH_LMN")     ,aCols[n][_npCODLMN] )
Local _cVCODPQR	:= aCols[n][_npCODPQR]
Local _cVCDNEOIL:= aCols[n][_npCDNEOIL] 
Local _cVCODXYZ := aCols[n][_npCODXYZ]
Local _cVCOD123	:= aCols[n][_npCOD123]
Local _cVCODABC	:= aCols[n][_npCODABC] 
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZ1	Classificação de Giro de Estoque
DbSelectArea("SZ1")
DbSetOrder(1)
If !Dbseek(xFilial("SZ1")+ _cVCODLMN)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Classificacao do Giro (HLM)."+CHR(13)+CHR(13)+"Tabela SZ1",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npDESCLMNC]:= SZ1->Z1_DESC
Endif
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


User Function VAL_PRQ(lValid)
Local _cVCODPQR	:= IIF(lValid .AND. TYPE("M->ZH_CODPQR")  <>"U",&("M->ZH_CODPQR")  ,aCols[n][_npCODPQR] )
Local _cVCODLMN	:= aCols[n][_npCODLMN]
Local _cVCDNEOIL:= aCols[n][_npCDNEOIL] 
Local _cVCODXYZ := aCols[n][_npCODXYZ]
Local _cVCOD123	:= aCols[n][_npCOD123]
Local _cVCODABC	:= aCols[n][_npCODABC] 
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZM	Tipo de Popularidade	PQR
DbSelectArea("SZM")
DbSetOrder(1)
If !Dbseek(xFilial("SZM")+ _cVCODPQR)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Tipo de Popularidade (PQR)."+CHR(13)+CHR(13)+"Tabela SZM",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npDESCPQR]:= SZM->ZM_DESCR
Endif
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


User Function VAL_NEOIL(lValid)
Local _cVCDNEOIL:= IIF(lValid .AND. TYPE("M->ZH_CDNEOIL") <>"U",&("M->ZH_CDNEOIL") ,aCols[n][_npCDNEOIL] )
Local _cVCODLMN	:= aCols[n][_npCODLMN]
Local _cVCODPQR	:= aCols[n][_npCODPQR]
Local _cVCODXYZ := aCols[n][_npCODXYZ]
Local _cVCOD123	:= aCols[n][_npCOD123]
Local _cVCODABC	:= aCols[n][_npCODABC] 
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZN	Tipo de Demanda	NEOIL
DbSelectArea("SZN")
DbSetOrder(1)
If !Dbseek(xFilial("SZN")+ _cVCDNEOIL)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Tipo de Demanda (NEOIL)."+CHR(13)+CHR(13)+"Tabela SZN",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npD_NEOIL]:= SZN->ZN_DESCR
Endif
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


User Function VAL_XYZ(lValid)
Local _cVCODXYZ := IIF(lValid .AND. TYPE("M->ZH_CODXYZ")  <>"U",&("M->ZH_CODXYZ")  ,aCols[n][_npCODXYZ] )
Local _cVCODLMN	:= aCols[n][_npCODLMN]
Local _cVCODPQR	:= aCols[n][_npCODPQR]
Local _cVCDNEOIL:= aCols[n][_npCDNEOIL] 
Local _cVCOD123	:= aCols[n][_npCOD123]
Local _cVCODABC	:= aCols[n][_npCODABC] 
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZP	Tipo de Criticidade	XYZ
DbSelectArea("SZP")
DbSetOrder(1)
If !Dbseek(xFilial("SZP")+ _cVCODXYZ)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Tipo de Criticidade (XYZ)."+CHR(13)+CHR(13)+"Tabela SZP",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npDESCXYZ]:= SZP->ZP_DESCR
Endif
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


User Function VAL_123(lValid)
Local _cVCOD123	:= IIF(lValid .AND. TYPE("M->ZH_COD123")  <>"U",&("M->ZH_COD123")  ,aCols[n][_npCOD123] )
Local _cVCODLMN	:= aCols[n][_npCODLMN]
Local _cVCODPQR	:= aCols[n][_npCODPQR]
Local _cVCDNEOIL:= aCols[n][_npCDNEOIL] 
Local _cVCODXYZ := aCols[n][_npCODXYZ]
Local _cVCODABC	:= aCols[n][_npCODABC] 
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZO	Tipo de Aquisicao 123
DbSelectArea("SZO")
DbSetOrder(1)
If !Dbseek(xFilial("SZO")+ _cVCOD123)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Tipo de Aquisicao (123)."+CHR(13)+CHR(13)+"Tabela SZO",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npDESC123]:= SZO->ZO_DESCR
Endif 
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


User Function VAL_ABC(lValid)
Local _cVCODABC	:= IIF(lValid .AND. TYPE("M->ZH_CODABC")  <>"U",&("M->ZH_CODABC")  ,aCols[n][_npCODABC] )
Local _cVCODLMN	:= aCols[n][_npCODLMN]
Local _cVCODPQR	:= aCols[n][_npCODPQR]
Local _cVCDNEOIL:= aCols[n][_npCDNEOIL] 
Local _cVCODXYZ := aCols[n][_npCODXYZ]
Local _cVCOD123	:= aCols[n][_npCOD123]
Local _lRet     := .T.
DEFAULT lValid := .F.
//SZR	Tabela ABC	Conterá a Letra e a Faixa Inicial e Final
DbSelectArea("SZR")
DbSetOrder(1)
If !Dbseek(xFilial("SZR")+ _cVCODABC)
	Aviso("ATENCAO", "Codigo nao Cadastrado na Tabela Curva ABC. "+CHR(13)+CHR(13)+"Tabela SZR",{"&Ok"})
	_lRet:= .f.
Else
	aCols[n][_npDESCABC] := SZR->ZR_DESCR
Endif
If _lRet 
   _lRet:=U_VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ,_cVCOD123,_cVCODABC)
Endif
Return(_lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³VAL_CLASS ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida campos do Acols                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function VAL_CLASS(_cVCODLMN,_cVCODPQR,_cVCDNEOIL,_cVCODXYZ ,_cVCOD123,_cVCODABC)
Local _cChave   :=  _cVCODPQR + _cVCDNEOIL + _cVCODXYZ + _cVCOD123 + _cVCODABC + _cVCODLMN
Local _lRetorna := .T.

// Avalia se todos os 6 campos estao preechidos para poder validar
If  EmptY(_cVCODLMN) .or. Empty(_cVCODPQR)  .or. EmptY(_cVCDNEOIL) .or.;
	EmptY(_cVCODXYZ) .or. Empty(_cVCOD123)  .or. EmptY(_cVCODABC)
	
	_lRetorna := .f.
	
Else
	
	
	//
	// Inicia processo de validacao do Codigo Auxiliar.
	//
	DbSelectArea("SZH")
	DbSetOrder(2)
	If DbSeek(xFilial("SZH")+ _cChave )
		While !SZH->(EOF()) .and. _cChave = SZH->(ZH_AUXILIA)
			If	SZH->ZH_CODMET <> cCodMet
				Aviso("ATENCAO", "Cod. Auxiliar :   "+_cChave+"   encontra-se cadastrado no Metodo " + SZH->ZH_CODMET +" desta forma nao pode ser incluido... , verifique !",{"&Ok"})
            	_lRetorna := .f.
			Endif
			SZH->(DBSKIP())
		Enddo
	Endif
	
	For nY:= 1 to Len(Acols)
		if nY <> n  .and. aCols[nY][_npAUXILIA] = _cChave
			Aviso("ATENCAO", "Cod. Auxiliar : "+_cChave+" esta duplicado dentro deste metodo... , verifique !",{"&Ok"})
        	_lRetorna := .f.
		Endif
	Next
	
Endif

IF _lRetorna
   aCols[n][_npAUXILIA] := _cChave
Else
   aCols[n][_npAUXILIA] := SPACE(6)
Endif 

Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RfatBar   ³ Autor ³ Anderson              ³ Data ³ 10/05/04 ³±±
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

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Val_SZHDel³ Autor ³                       ³ Data ³ 10/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida se pode ocorrer delecao do item em uma data Tabela  ³±±
±±³          ³ Apenas para Relembrar (Tabelas das Classificacoes)         ³±±
±±³          ³ SZM - PQR   -  POPULARIDADE                                ³±±
±±³          ³ SZN - NEOIL -  DEMANDA                                     ³±±
±±³          ³ SZP - XYZ   -  CRITICIDADE                                 ³±±
±±³          ³ SZO - 123   -  AQUISICAO                                   ³±±
±±³          ³ SZR - ABC   -  CURVA ABC                                   ³±±
±±³          ³ SZ1 - HLM   -  GIRO                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Val_SZHDel(cClass,cConteudo) // cClass $ "PQR|NEOIL|XYZ|123|ABC|HLM"

Local lRet  := .t.
Local aArea := GetArea()
Local cCampo:= ""

If EmptY(cClass)
   Aviso("ATENCAO", "Uso indevido da funcao Val_Delecao em MPL_019 "+chr(13)+;
         "Esta funcao tem como objetivo avaliar se uma classificao pode ser "+; 
         "excluida da Tabela de Origem (Garantindo Integridade)"  ,{"&Ok"})
   lRet := .f.
Endif    

If EmptY(cConteudo)
   Aviso("ATENCAO", "Uso indevido da funcao Val_Delecao em MPL_019 "+chr(13)+;
         "Esta funcao tem como objetivo avaliar se uma classificao pode ser "+; 
         "excluida da Tabela de Origem (Garantindo Integridade)"  ,{"&Ok"})
   lRet := .f.
Endif    
    
If !(cClass $ "PQR|NEOIL|XYZ|123|ABC|HLM")
   Aviso("ATENCAO", "Uso indevido da funcao Val_Delecao em MPL_019 "+chr(13)+;
         "O parametro Primeiro parametro de deve conter PQR|NEOIL|XYZ|123|ABC|LMN",{"&Ok"})
   lRet := .f.
Endif


//MsgRun( OemToAnsi( "Aguarde. Verificando Arvore de Dimencionamento SZH antes de Excluir..." ),"",{||AltMedi()})

if lRet
	Do Case
		Case cClass $ "PQR"
			cCampo := "ZH_CODPQR"
		Case cClass $ "NEOIL"
			cCampo := "ZH_CDNEOIL"
		Case cClass $ "XYZ"
			cCampo := "ZH_CODXYZ"
		Case cClass $ "123"
			cCampo := "ZH_COD123"
		Case cClass $ "ABC"
			cCampo := "ZH_CODABC"
		Case cClass $ "HLM"
			cCampo := "ZH_LMN"
	Endcase
	
	DbSelectArea("SZH")
	DbGotop()
	IF DbSeek(xFilial("SZH"))
		While !SZH->(Eof()) .and. xFilial("SZH") = ZH_FILIAL
			If &cCampo = cConteudo
				lRet := .f.
			Endif
			SZH->(DBSKIP())
		Enddo
	Endif

	If !lRet 
   		Aviso("ATENCAO", "Item nao podera ser excluido da tabela pois esta associado a arvore de Dimencionamento",{"&Ok"})
	Endif

Endif

RestArea(aArea)

Return(lRet) 



User Function ValAll()
Local lRet:= .T.
         
If !aCols[n,Len(aHeader)+1]
   If EmptY(aCols[n][_npCODLMN]) .or. EmptY(aCols[n][_npCODPQR])  .or. EmptY(aCols[n][_npCDNEOIL]) .or.;
      EmptY(aCols[n][_npCODXYZ]) .or. EmptY(aCols[n][_npCOD123])  .or. EmptY(aCols[n][_npCODABC])  
      Aviso("ATENCAO", "Existem campos obrigatorios nao Preenchidos!",{"&Ok"})
      lRet := .f.
   Endif
Endif   

Return(lRet)   
   
