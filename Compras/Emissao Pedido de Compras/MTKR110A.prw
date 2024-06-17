#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "REPORT.CH"
#include "rwmake.ch"
#INCLUDE "MATR110A.CH"

/*-------------------------------------------------------------------------------------------
Função: Matr110a()

Descrição: Esta rotina tem como objetivo imprimir os pedidos de compras com um layout
alternativo com o objeto TmsPrinter

---------------------------------------------------------------------------------------------*/

User Function MTKR110a(cNumPed)

DEFAULT cNumPed		:= ""
Private _cAlias		:= GetNextAlias()
Private _cAlias1	:= GetNextAlias()
Private cEOL 		:= "CHR(13)+CHR(10)"
Private cPerg   	:= "MTR110A" // Nome do grupo de perguntas

AjustaSX1()

If !Empty(cNumPed)
	Pergunte(cPerg,.F.)
	MV_PAR01 := Replicate(" ", Len(SA2->A2_COD)) 
	MV_PAR02 := Replicate("Z", Len(SA2->A2_COD))
	MV_PAR03 := Replicate(" ", Len(SA2->A2_LOJA)) 
	MV_PAR04 := Replicate("Z", Len(SA2->A2_LOJA))
	MV_PAR05 := cNumPed
	MV_PAR06 := cNumPed
	MV_PAR07 := CTOD("01/01/1900")
	MV_PAR08 := CTOD("31/12/2049")
ElseIf !Pergunte(cPerg,.T.)
	
	Return
Endif

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//Monta arquivo de trabalho temporário
MsAguarde({||MontaQuery()},STR0001,STR0002) //"Aguarde"##"Criando arquivos para impressão..."

//Verifica resultado da query

DbSelectArea(_cAlias)
DbGoTop()
If (_cAlias)->(Eof())
	MsgAlert(STR0003,STR0004)  //"Relatório vazio! Verifique os parâmetros."##"Atenção"
	(_cAlias)->(DbCloseArea())
Else
	Processa({|| Imprime() },STR0005,STR0006) //"Pedido de Compras "##"Imprimindo..."
EndIf

Return

//********************************************************************************************
//                                          MONTA A PAGINA DE IMPRESSAO
//********************************************************************************************
Static Function Imprime()

Local _nCont 		:= 1
Local cPedidoAtu	:= ""
Local aAreaSM0	    := {}	 
Local cDescricao    := ""             

Private cBitmap	:= ""
Private cStartPath:= GetSrvProfString("Startpath","")
Private oFont08
Private oFont09
Private oFont10
Private cPosi
Private nLin
Private _nValIcm		:= 0   // Valor do Icms
Private _nValIcmR		:= 0	// Valore do Icms retido
Private _nValIpi		:= 0   // Valor do Ipi
Private _nPag  		:= 1   // Numero da
Private _nTot    		:= 0   // Valor Total
Private _nFrete		:= 0   // Valor do frete
Private _nDescPed		:= 0
Private _nDesc1	 	:= 0
Private _nDesc2	 	:= 0
Private _nDesc3	 	:= 0
Private _nDespesa	:= 0
Private _nSeguro		:= 0
Private _dDtEnt
Private _cEndEnt		:= ""
Private _cBairEnt		:= ""
Private _cCidEnt		:= ""
Private _cEstEnt		:= ""		
Private _cTel			:= ""
Private cPedidoAnt	:= ""

cBitmap := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
If !File( cBitmap )
	cBitmap := "LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
EndIf

//Fontes a serem utilizadas no relatório
Private oFont08  	:= TFont():New( "Arial",,08,,.F.,,,,,.f.)
Private oFont08N 	:= TFont():New( "Arial",,08,,.T.,,,,,.f.)
Private oFont08I 	:= TFont():New( "Arial",,08,,.f.,,,,,.f.,.T.)
Private oFont09  	:= TFont():New( "Arial",,09,,.F.,,,,,.f.)
Private oFont09N 	:= TFont():New( "Arial",,09,,.T.,,,,,.f.)
Private oFontC9  	:= TFont():New( "Courier New",,09,,.F.,,,,,.f.)
Private oFontC9N 	:= TFont():New( "Courier New",,09,,.T.,,,,,.f.)
Private oFont10  	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFont10N 	:= TFont():New( "Arial",,10,,.T.,,,,,.f.)
Private oFont10I 	:= TFont():New( "Arial",,10,,.f.,,,,,.f.,.T.)
Private oFont11  	:= TFont():New( "Arial",,11,,.f.,,,,,.f.)
Private oFont11N 	:= TFont():New( "Arial",,11,,.T.,,,,,.f.)
Private oFont12N 	:= TFont():New( "Arial",,12,,.T.,,,,,.f.)
Private oFont12  	:= TFont():New( "Arial",,12,,.F.,,,,,.F.)
Private oFont12NS	:= TFont():New( "Arial",,12,,.T.,,,,,.T.)
Private oFont13N 	:= TFont():New( "Arial",,13,,.T.,,,,,.f.)
Private oFont17 	:= TFont():New( "Arial",,17,,.F.,,,,,.F.)
Private oFont17N 	:= TFont():New( "Arial",,17,,.T.,,,,,.F.)

//Start de impressão
Private oPrn:= TMSPrinter():New()
Private nxTam  := len(Alltrim(SM0->M0_ENDENT)+" "+ Alltrim(SM0->M0_BAIRENT)+" - "+Alltrim(SM0->M0_CIDENT)+" /"+Alltrim(SM0->M0_ESTENT)+" "+STR0011+" "+(SM0->M0_CEPENT)) 

oPrn:SetLandScape()  // SetPortrait() - Formato retrato   SetLandscape() - Formato Paisagem

//cabecalho da pagina
Cabec(.t.)

cPedidoAnt := (_cAlias)->C7_NUM

// Carrega dados da filial de Entrega
If((_cAlias)->C7_FILENT != NIL) 
 	aAreaSM0 := SM0->(GetArea())
	dbSelectArea("SM0")
	dbGoTop()
	While !SM0->(Eof())  
		If AllTrim(SM0->M0_CODFIL) = AllTrim((_cAlias)->C7_FILENT) .AND. AllTrim(SM0->M0_CODIGO) = cEmpAnt 
 			_cEndEnt	:= M0_ENDENT
 			_cBairEnt	:= M0_BAIRENT
			_cCidEnt	:= M0_CIDENT
			_cEstEnt	:= M0_ESTENT
			_cTel		:= M0_TEL
		EndIf
		dbSkip()
	EndDo
	RestArea(aAreaSM0)
EndIf

While (_cAlias)->(!Eof())

	
	cPedidoAtu := (_cAlias)->C7_NUM
	
	If _nCont >= 29 .Or. cPedidoAtu <> cPedidoAnt
		
		If cPedidoAtu <> cPedidoAnt
					
			Rodap()
			
			// Carrega dados da filial de Entrega
			If((_cAlias)->C7_FILENT != NIL)
				aAreaSM0 := SM0->(GetArea())
				dbSelectArea("SM0")
				dbGoTop()
				While !Eof()
					If Trim(M0_CODFIL) == Trim((_cAlias)->C7_FILENT) .AND. AllTrim(SM0->M0_CODIGO) = cEmpAnt
 						_cEndEnt	:= M0_ENDENT
 						_cBairEnt	:= M0_BAIRENT
						_cCidEnt	:= M0_CIDENT
						_cEstEnt	:= M0_ESTENT
						_cTel		:= M0_TEL
					EndIf
					dbSkip()
				EndDo
				RestArea(aAreaSM0)
			EndIf
			
			
			_nDescPed 	:= 0
			_nDesc1 	:= 0
			_nDesc2 	:= 0
			_nDesc3 	:= 0
			_nValIpi	:= 0
			_nValIcm	:= 0
			_nValIcmR	:= 0
			_nTot		:= 0
			_nFrete	:= 0
			_dDtEnt 	:= NIL
			
			oPrn :EndPage() 
			
		Else
			oPrn:line(1960,0075,1960,3425)    //Linha Horizontal Rodape Inferior
		EndIf
		
		_nCont		:= 0
		_nPag 		+= 1
		
		oPrn :EndPage() 
		Cabec(.t.)
	EndIf

    SC1->(dbSelectArea("SC1"),dbSetOrder(1),dbSeek(xFilial("SC1")+(_cAlias)->C7_NUMSC+(_cAlias)->C7_ITEMSC))   
    
    If Empty(SC1->C1_X_OBS)
       cDescricao := ""
	Else                           
       cDescricao := " ("+alltrim(Substr(SC1->C1_X_OBS,1,35))+") "
	Endif
		
	oPrn:say(nLin,0035,(_cAlias)->C7_ITEM, oFont08)		  									//item

	// Multitek - Ajuste  - Tratativa para corrente que trabalha com mais casas decimais.
    //----------------------------------------------------------------------------------------------------------
    If "MT" $ (_cAlias)->C7_UM  
       oPrn:say(nLin,0100,Transform((_cAlias)->C7_QUANT,"@E 999999999.99"), oFont08)	//Quantidade
    Else
       oPrn:say(nLin,0100,Transform((_cAlias)->C7_QUANT,"@R 999999999"), oFont08)		//Quantidade
    Endif 
    
	oPrn:say(nLin,0280,Substr((_cAlias)->C7_PRODUTO,1,25),oFont08)						//codigo
	oPrn:say(nLin,0500,Substr((_cAlias)->A5_CODPRF,1,18),oFont08)						//codigo do fornecedor
	oPrn:say(nLin,0800,(_cAlias)->C7_UM,oFont08)												//unidade de medida
	oPrn:say(nLin,1160,Substr((_cAlias)->B1_DESC,1,35),oFont08)							//descricao
	oPrn:say(nLin,1660,cDescricao,oFont08)		                       					//descricao
	oPrn:say(nLin,2250,Transform((_cAlias)->C7_PRECO,"@R 999,999,999.99"),oFont08)		//VLR UNIT
	oPrn:say(nLin,2570,Transform((_cAlias)->C7_TOTAL,"@R 999,999,999.99"),oFont08)		//VLR TOT
	oPrn:say(nLin,2890,Transform((_cAlias)->C7_IPI,"@R 999.99"),oFont08)				//IPI
	oPrn:say(nLin,3150,DTOC((_cAlias)->C7_DATPRF),oFont08)									//data de entrega
	
	_nFrete	+= (_cAlias)->C7_VALFRE
	
	If (_cAlias)->C7_DESC1 != 0 .or. (_cAlias)->C7_DESC2 != 0 .or. (_cAlias)->C7_DESC3 != 0
		_nDescPed  += CalcDesc((_cAlias)->C7_TOTAL,(_cAlias)->C7_DESC1,(_cAlias)->C7_DESC2,(_cAlias)->C7_DESC3)
	    _nDesc1	:= (_cAlias)->C7_DESC1
		_nDesc2	:= (_cAlias)->C7_DESC2
		_nDesc3	:= (_cAlias)->C7_DESC3
	Else
		_nDescPed += (_cAlias)->C7_VLDESC
	Endif
	
	If _dDtEnt == NIL
		_dDtEnt := (_cAlias)->C7_DATPRF 
	ElseIf (_cAlias)->C7_DATPRF > _dDtEnt
		_dDtEnt := (_cAlias)->C7_DATPRF 
	Endif
	
	_nCont 		+= 1
	_nValIcm 	+= (_cAlias)->C7_VALICM
	_nValIcmR	+= (_cAlias)->C7_ICMSRET
	_nValIpi 	+= (_cAlias)->C7_VALIPI
	_nTot 	 	+= (_cAlias)->C7_TOTAL
	_nDespesa 	+= (_cAlias)->C7_DESPESA
	_nSeguro	+= (_cAlias)->C7_SEGURO
	
	nLin += 50   //pula linha
	
	cPedidoAnt := (_cAlias)->C7_NUM
	
	//Verifica a quebra de pagina
	
	(_cAlias)->(dBskip())
EndDo

If _nCont <= 32
	(_cAlias)->(DbGoTop())
	//		Infoger()
	Rodap()
	//		WordImp()
Else
	(_cAlias)->(DbGoTop())
	Rodap()
	oPrn :EndPage()
	Cabec(.f.)
	//   		Infoger()
	Rodap()
	//   		WordImp()
EndIF

If(mv_par09 == 1)
  oPrn:Print()
Else
  oPrn:Preview() //Preview DO RELATORIO
EndIf

Return

//********************************************************************************************
//										Impressão do Relatório
//********************************************************************************************
Static Function  Cabec(_lCabec)
Private nxTam  := len(Alltrim(SM0->M0_ENDENT)+" "+ Alltrim(SM0->M0_BAIRENT)+" - "+Alltrim(SM0->M0_CIDENT)+" /"+Alltrim(SM0->M0_ESTENT)+" "+STR0011+" "+(SM0->M0_CEPENT)) 

oPrn:StartPage()	//Inicia uma nova pagina

_cFileLogo	:= GetSrvProfString('Startpath','') + cBitmap

oPrn:SayBitmap(0045,0060,_cFileLogo,0400,0125)

oPrn:say(0070,1000, STR0007+ " " +Alltrim((_cAlias)->C7_NUM),oFont17) //"PEDIDO DE COMPRA:"
oPrn:say(0070,1865,Iif(!Empty(Alltrim((_cAlias)->C7_OP))," |   OP: " +Alltrim((_cAlias)->C7_OP),""),oFont17N)
oPrn:say(0090,2800, STR0008+ " " + dtoc((_cAlias)->C7_EMISSAO) ,oFont08) //"EMISSÃO:"

if nxTam < 67
   oPrn:line(180,1350,430,1350) 	//Linha Vertical Cabecalho                                               '
   oPrn:line(445,0035,445,3425)    //Linha Horizontal Cabecalho Inferior
   oPrn:line(505,0035,505,3425)    //Linha Horizontal Cabecalho Inferior
Else
   oPrn:line(180,1350,430,1350) 	//Linha Vertical Cabecalho                                               '
   oPrn:line(445+50,0035,445+50,3425)    //Linha Horizontal Cabecalho Inferior
   oPrn:line(505+50,0035,505+50,3425)    //Linha Horizontal Cabecalho Inferior
Endif   

//********************************************************************************************
//										cabecalho
//********************************************************************************************

// MULTITEK - SEGUNDO INFORMADO DEVE SAIR  A FILIAL DE ENTREGA NESTE PONTO
aAreaSM0 := SM0->(GetArea())
dbSelectArea("SM0")
dbGoTop()
While !Eof()
	If Alltrim(M0_CODFIL) = AllTrim((_cAlias)->C7_FILENT) .and.  Alltrim(M0_CODIGO) = cEmpAnt
	   EXIT
	EndIf
	dbSkip()
EndDo


// Primeira coluna do cabecalho
nLin := 225
oPrn:say (nLin,0035, SM0->M0_NOMECOM ,oFont08)
nLin += 50
oPrn:say (nLin,0035,STR0009+" "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"  -  "+STR0010+" "+Alltrim(SM0->M0_INSC) ,oFont08)  //"CNPJ:"##"I.E:"
nLin += 50
// oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDCOB)+" "+ Alltrim(SM0->M0_BAIRCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" /"+Alltrim(SM0->M0_ESTCOB)+" "+STR0011+" "+(SM0->M0_CEPENT),oFont08) //"CEP:"

If nxTam < 67
   oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDENT)+" "+ Alltrim(SM0->M0_BAIRENT)+" - "+Alltrim(SM0->M0_CIDENT)+" /"+Alltrim(SM0->M0_ESTENT)+" "+STR0011+" "+(SM0->M0_CEPENT),oFont08) //"CEP:"
Else 
   oPrn:say (nLin,0035,Alltrim(SM0->M0_ENDENT)+" "+ Alltrim(SM0->M0_BAIRENT),oFont08)
   nLin += 50
   oPrn:say (nLin,0035,Alltrim(SM0->M0_CIDENT)+" /"+Alltrim(SM0->M0_ESTENT)+" "+STR0011+" "+(SM0->M0_CEPENT),oFont08)
Endif   
nLin += 50
oPrn:say (nLin,0035,STR0012+" "+Alltrim(SM0->M0_TEL)+"  -  "+STR0013+" "+Alltrim(SM0->M0_FAX) ,oFont08) //"TEL.:"##"FAX:"

RestArea(aAreaSM0) // MULTITEK - SEGUNDO INFORMADO DEVE SAIR  A FILIAL DE ENTREGA NESTE PONTO


//............................................................................................
// Segunda coluna do cabecalho (FORNECEDOR)
nLin := 180
oPrn:say (nLin,1365,STR0014,oFont08I)  //"Fornecedor"
nLin += 40
oPrn:say (nLin,1365,(_cAlias)->A2_COD+" - ", oFont08)
oPrn:say (nLin,1535,(_cAlias)->A2_NOME, oFont08)
oPrn:say (nLin,2700,STR0009+" ", oFont08I) //"CNPJ:"
oPrn:say (nLin,2830,Transform((_cAlias)->A2_CGC,"@R 99.999.999/9999-99"), oFont08)
nLin += 50
oPrn:say (nLin,1365,STR0015+" ", oFont08I) //"End:"
oPrn:say (nlin,1535,(_cAlias)->A2_END, oFont08)
oPrn:say (nLin,2700,STR0010+" ",oFont08I) //"I.E:"
oPrn:say (nLin,2830,Transform((_cAlias)->A2_INSCR,"@R 999.999.999.999"),oFont08)
nLin += 50
oPrn:say (nLin,1365,STR0016+" ", oFont08I) //"Bairro:"
oPrn:say (nLin,1535,(_cAlias)->A2_BAIRRO,oFont08)
oPrn:say (nLin,2125,STR0017+" ", oFont08I) //"Municipio/UF:"
oPrn:say (nLin,2370,Alltrim((_cAlias)->A2_MUN)+" / "+(_cAlias)->A2_EST,oFont08)
oPrn:say (nLin,2700,STR0011+" ", oFont08I) //"CEP:"
oPrn:say (nLin,2830,Transform((_cAlias)->A2_CEP,"@R 99.999-999"), oFont08)
nLin += 50
oPrn:say (nLin,1365,STR0012+" ", oFont08I) //"TEL.:"
oPrn:say (nLin,1535,"("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_TEL,"@R 9999-9999"),oFont08)
oPrn:say (nLin,2125,STR0013+" ", oFont08I) //"FAX:"
oPrn:say (nLin,2370,"("+Alltrim((_cAlias)->A2_DDD)+") "+Transform((_cAlias)->A2_FAX,"@R 9999-9999"),oFont08)

//********************************************************************************************
//										Corpo
//********************************************************************************************
if nxTam < 67
   nLin := 450
Else 
   nLin := 450+050
Endif   
// Subtitulo do Corpo
oPrn:say (nLin,0035,STR0018,oFont08I) //"Item"
oPrn:say (nLin,0160,STR0019,oFont08I) //"Qtde"
oPrn:say (nLin,0280,STR0020,oFont08I) //"Código"
oPrn:say (nLin,0500,STR0021,oFont08I) //"Cód. Prod. Fornec."
oPrn:say (nLin,0800,STR0041,oFont08I)
oPrn:say (nLin,1160,STR0022,oFont08I) //"Descrição"
oPrn:say (nLin,2300,STR0024,oFont08I) //"Vl. Unit."
oPrn:say (nLin,2600,STR0025,oFont08I) //"Vl. Total"
oPrn:say (nLin,2900,STR0026,oFont08I) //"IPI"
oPrn:say (nLin,3150,STR0042,oFont08I)

if nxTam < 67
  nLin := 510
Else
  nLin := 510 + 050
Endif  
  
oPrn:say (2340,3330,Transform(_nPag,"@R 999"),oFont08I)    //Impressão do numero da página

return
//********************************************************************************************
//										Rodape
//********************************************************************************************
Static Function Rodap()
oPrn:line(1900,0035,1900,3425)    //Linha Horizontal Rodape Inferior
oPrn:line(1960,0035,1960,3425)    //Linha Horizontal Rodape Inferior
oPrn:line(2120,0035,2120,3425)    //Linha Horizontal Rodape Inferior  Alterado em 22.08.2012 por André Luiz de Sousa

nLin := 1905

_nTot := (_nTot + _nValIcmR + _nValIpi + _nDespesa + _nSeguro - _nDescPed)

oPrn:say(nLin,0035,STR0027+" "+Transform(_nDesc1,"@E 999.99")+"%  "+Transform(_nDesc2,"@E 999.99")+"%  "+Transform(_nDesc3,"@E 999.99")+"%    "+Transform(_nDescPed, "@E 999,999,999.99") ,oFont08I) //"Desc:"
oPrn:say(nLin,0700,STR0028+" "+Transform(_nValIcm,"@E 999,999,999.99"),oFont08I) 		//"ICMS:"
oPrn:say(nLin,1100,STR0029+" "+Transform(_nValIpi,"@E 999,999,999.99"),oFont08I) 		//"IPI:"
oPrn:say(nLin,1500,STR0044+" "+Transform(_nDespesa,"@E 99,999,999.99"),oFont08I)		//"Despesas: "
oPrn:say(nLin,1900,STR0045+" "+Transform(_nSeguro,"@E 99,999,999.99"),oFont08I)		//"Seguro: "
oPrn:say(nLin,2300,STR0043+" "+Transform(_nFrete,"@E 999,999,999.99"),oFont08I) 		//"Vlr Frete:"
oPrn:say(nLin,2700,STR0030+" "+Transform(_nTot,"@E 999,999,999.99"),oFont08N) 			//"Valor Total:"
nLin += 60                                                                                              

// Multitek - Ajuste
//----------------------------------------------------------------------------------------------------------
SC7->(dbSelectArea("SC7"),dbSetOrder(1),dbSeek(xFilial("SC7")+cPedidoAnt))
SE4->(dbSelectArea("SE4"),dbSetOrder(1),dbSeek(xFilial("SE4")+SC7->C7_COND))
cAprov := ""
dbSelectArea("SCR")
dbSetOrder(1)
dbSeek(xFilial("SCR")+"PC"+(_cAlias)->C7_NUM)
While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+(_cAlias)->C7_NUM .And. SCR->CR_TIPO == "PC"
  cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
  IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
  dbSelectArea("SCR")
  dbSkip()
Enddo                       
oPrn:say(nLin,0035,"Condicao de Pagamento: "+"  "+SubStr(SE4->E4_DESCRI,1,15),oFont08) 	 // Condicao de Pagto
oPrn:say(nLin,1700,"Aprovador: "+"  "+cAprov,oFont08) 		//"Cidade / UF:"
//----------------------------------------------------------------------------------------------------------

nLin += 50
oPrn:say(nLin,0035,STR0031+"  "+DTOC(_dDtEnt),oFont08) 										//"Prazo Programado p/ Entrega:"
nLin += 50
oPrn:say(nLin,0035,STR0032+" "+Alltrim(_cEndEnt) +" - "+Alltrim(_cBairEnt),oFont08) 	//"Endereço de Entrega:"
oPrn:say(nLin,1700,STR0033+" "+Alltrim(_cCidEnt)+ "/" +Alltrim(_cEstEnt),oFont08) 		//"Cidade / UF:"
oPrn:say(nLin,2300,STR0034+" "+Alltrim(_cTel),oFont08) 									//"Telefone:"
nLin += 50

oPrn :EndPage()

Return

//********************************************************************************************
// 										   		QUERY
//********************************************************************************************
Static Function MontaQuery

Local cQuery  
                                                                                                           

cQuery := "SELECT DISTINCT SC7.C7_NUM,SC7.C7_ITEM,SC7.C7_FILENT, SC7.C7_VALFRE, SC7.C7_UM, SC7.C7_OP,SC7.C7_OBS,SC7.C7_NUMSC,SC7.C7_ITEMSC,"
cQuery += " SC7.C7_QUANT, SC7.C7_PRODUTO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_DESCRI, SC7.C7_PRECO,"
cQuery += " SC7.C7_TOTAL, SC7.C7_EMISSAO, SC7.C7_DATPRF, SC7.C7_IPI, SC7.C7_DESC1,"
cQuery += " SC7.C7_DESC2, SC7.C7_DESC3, SC7.C7_VLDESC, SC7.C7_BASEICM, SC7.C7_BASEIPI, SC7.C7_VALIPI,"
cQuery += " SC7.C7_VALICM,SC7.C7_DT_EMB, SC7.C7_TOTAL, SC7.C7_CODTAB, SC7.C7_SEGURO, SC7.C7_DESPESA, SC7.C7_ICMSRET,"
cQuery += " SA2.A2_COD, SA2.A2_NOME, SA2.A2_END, SA2.A2_BAIRRO, SA2.A2_EST, SA2.A2_MUN, SA2.A2_CEP,"
cQuery += " SA2.A2_CGC, SA2.A2_INSCR, SA2.A2_TEL, SA2.A2_FAX, SA2.A2_DDD, SA5.A5_CODPRF, SB1.B1_DESC"
cQuery += " FROM "+RetSqlName('SC7')+" SC7 "
cQuery += " INNER JOIN "+RetSqlName('SA2')+" SA2 ON SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND SC7.C7_FORNECE =  SA2.A2_COD AND SC7.C7_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN "+RetSqlName('SA5')+" SA5 ON SA5.A5_FILIAL = '"+xFilial("SA5")+"'  AND SC7.C7_PRODUTO =  SA5.A5_PRODUTO AND SC7.C7_FORNECE = SA5.A5_FORNECE AND SC7.C7_LOJA = SA5.A5_LOJA AND SA5.D_E_L_E_T_ <> '*' "
cQuery += " INNER JOIN "+RetSqlName('SB1')+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SC7.C7_PRODUTO =  SB1.B1_COD     AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery += "   AND SC7.C7_FORNECE BETWEEN '"+(MV_PAR01)+"' AND '"+(MV_PAR02)+"'
cQuery += "   AND SC7.C7_LOJA    BETWEEN '"+(MV_PAR03)+"' AND '"+(MV_PAR04)+"'
cQuery += "   AND SC7.C7_NUM     BETWEEN '"+(MV_PAR05)+"' AND '"+(MV_PAR06)+"'
cQuery += "   AND SC7.C7_EMISSAO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"'
cQuery += "   AND SC7.D_E_L_E_T_ <> '*' "

If Upper(TcGetDb()) $ "ORACLE.INFORMIX"
	cQuery += "   ORDER BY 1,2"
Else
	cQuery += "   ORDER BY SC7.C7_NUM,SC7.C7_ITEM"
Endif

//Criar alias temporário
TCQUERY cQuery NEW ALIAS (_cAlias)

tCSetField((_cAlias), "C7_EMISSAO", "D")
tCSetField((_cAlias), "C7_DATPRF",  "D")
tCSetField((_cAlias), "C7_DT_EMB",  "D")

Return

//********************************************************************************************
// 										   		Grupo de perguntas
//********************************************************************************************
Static Function AjustaSX1()

Local i 		:= 0
Local aArea	:= GetArea()
Local nTamForn:= TamSX3("A2_COD")[1]
Local nTamLoja:= TamSX3("A2_LOJA")[1]
Local nTamPedi:= TamSX3("C7_NUM")[1]

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("MTR110A",10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Do Fornecedor ?"			,"¿De proveedor		 ?","From Supplier 	?"    ,"mv_ch1","C",nTamForn,0,0,"G","","mv_par01",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SA2","S"})
AADD(aRegs,{cPerg,"02","Até o Fornecedor ?"			,"¿A proveedor 		 ?","To Supplier		?","mv_ch2","C",nTamForn,0,0,"G","","mv_par02",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SA2","S"})
AADD(aRegs,{cPerg,"03","Da loja ?"					,"¿De Tienda		 ?","From Unit    	?"    ,"mv_ch3","C",nTamLoja,0,0,"G","","mv_par03",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"04","Até loja ?"					,"¿A Tienda 		 ?","To Unit         ?"   ,"mv_ch4","C",nTamLoja,0,0,"G","","mv_par04",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"05","Do Pedido ?"				,"¿De Pedido		 ?","From Order 		?","mv_ch5","C",nTamPedi,0,0,"G","","mv_par05",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SC7","S"})
AADD(aRegs,{cPerg,"06","Até o Pedido ?"				,"¿A pedido			 ?","To Order 		?"    ,"mv_ch6","C",nTamPedi,0,0,"G","","mv_par06",""        	,""				,""         ,"","",""      ,""			,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","","SC7","S"})
AADD(aRegs,{cPerg,"07","Da Emissão ?"				,"¿De emision 		 ?","From Issue 		?","mv_ch7","D",08	    ,0,0,"G","","mv_par07",""        	,""				,""         ,"","",""      ,""		  	,""			,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"08","Até Emissão ?"				,"¿A emision 		 ?","To Issue 		?"    ,"mv_ch8","D",08	    ,0,0,"G","","mv_par08",""        	,""				,""         ,"","",""      ,""   		,""		    ,"","",""       ,"","","","",""       ,"","","","",""        ,"","","",""   ,"S"})
AADD(aRegs,{cPerg,"09","Tipo de Impressão ?"		,"¿tipo de impresión?" ,"type of printing?"   ,"mv_ch9","N",01	    ,0,1,"C","","mv_par09","Impressora" , "Impresora" , "Printer","","", "Tela", "Pantalla"	, "Screen"	,"","",""		    ,"","","","",""		  ,"","","","",""		 ,"","","",""   ,"S"})

If dbSeek(cPerg+"03")
	If AllTrim(X1_PERGUNT) <> ("Da loja ?")
		dbSeek(cPerg)
		While !Eof() .And. AllTrim(X1_GRUPO) == AllTrim(cPerg)
			RecLock("SX1",.F.)
			DbDelete()
			MsUnLock()
			DbSkip()
		End
	EndIf
EndIf

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
			X1_GRUPO  	:= aRegs[i,1]
			X1_ORDEM  	:= aRegs[i,2]
			X1_PERGUNT	:= aRegs[i,3]
			X1_PERSPA	:= aRegs[i,4]
			X1_PERENG	:= aRegs[i,5]
			X1_VARIAVL	:= aRegs[i,6]
			X1_TIPO  	:= aRegs[i,7]
			X1_TAMANHO	:= aRegs[i,8]
			X1_DECIMAL	:= aRegs[i,9]
			X1_PRESEL	:= aRegs[i,10]
			X1_GSC		:= aRegs[i,11]
			X1_VAR01	:= aRegs[i,13]
			X1_DEF01	:= aRegs[i,14]
			X1_DEFSPA1	:= aRegs[i,15]
			X1_DEFENG1	:= aRegs[i,16]
			X1_DEF02	:= aRegs[i,19]
			X1_DEFSPA2	:= aRegs[i,20]
			X1_DEFENG2	:= aRegs[i,21]
			X1_F3		:= aRegs[i,38]
			X1_PYME	:= aRegs[i,39]
		SX1->(MsUnlock())
	Endif
Next

RestArea(aArea)

Return
