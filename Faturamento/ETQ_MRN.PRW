#INCLUDE "Fivewin.ch"
#INCLUDE "SIGA.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³NF_MRN    ³Autor  ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Geracao de Arquivo txt para exportacao NF                    ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ETQ_MRN() 
                                                  
Local cNumNF   := SF2->F2_DOC              // Numero da Nota Fiscal Tratado
Local XSerie   := SF2->F2_SERIE

Local cArqSaida   :="NF_"+alltrim(cNumNF)+"_MULTITEK.TXT"
Local cViaTran    := "" 
Local cPed_Orc   := ""
Local cPedClie1  := ""
Local cPedClie2  := ""

Local cItemLinh   := ""

Local cMTKPed:= ""
Local nMoeda	:= 0 
Local cCOD_MENS := ""
Local cTPFRETE     := ""
Local  cMensagem := ""
Local nSequencia   := "0000000"
Local nQtItens        := 0
Local cData           := ""
Local cTime           := ""
                     
Private  aCabNF   :={}                          
Private  aItensNF :={} 
Private  aHeader  := {}
Private  aTrailler  := {}
Private  aObserv  := {}
Private  aMatriz   := {}
Private  aTransp  := {}


Private  aPed       := {}
Private   aPED_VEND:= {}
Private  lFlag_MTK	   := .F.
Private cObs 			:= ""



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Saida                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//
// Verifica se o diretorio existe caso negativo sera criado
//F:\CNAB\MRN\
MAKEDIR("F:\CNAB\MRN\"+ALLTRIM(SM0->M0_FILIAL))

//
// Cria um arquivo texto no diretorio gerado acima logo abaixo sera renomeado com waitrun
// devido o microsiga somente trabalhar com letras minusculas.
//
nHdlSaida:=MSFCREATE("F:\CNAB\MRN\"+ALLTRIM(SM0->M0_FILIAL)+"\"+cArqSaida,0)


// Deleta Reimpressoes quando tenho que imprimir novamente
// o arquivo anterior I-...... deve ser excluido, devido 
// o software da impressora apos impresso tentar renomear o 
// arquivo lido para I-...... caso nao consiga a impressora
// fica em loop ou seja imprimindo sem parar.
If File("F:\CNAB\MRN\"+ALLTRIM(SM0->M0_FILIAL)+"\"+"I-"+cArqSaida)
	Ferase("F:\CNAB\MRN\"+ALLTRIM(SM0->M0_FILIAL)+"\"+"I-"+cArqSaida)
Endif



//
//AADD(aCabNF , {"07","Peso total do Frete (TON)                           ",_Transf("Number	   O",	12,	4,	 17,  28,}
/*
If cTFrete = "F"
	IF !EMPTY(xHWB_MTK)
		_nPesoBrt := Getadvfval("SW6","W6_PESO_BR",xFILIAL("SW6")+xHWB_MTK,1," ")
		nPesoBR:= _nPesoBrt
	Else
		nPesoBR:= xPBRUTO
	ENDIF
Endif


IF xTipo <> "I" .and. xTipo <> "P" .and. lImportacao
	nVotNf:= xTOT_FAT
ELSEIF xTipo == "P"
	nVotNf:= xVALOR_IPI 
ELSEIF xTipo == "C" .and. !EMPTY(xHWB_MTK)
	nVotNf:= xVALOR_MERC 
EndIF

*/


dbSelectArea("SF2")
DbSetOrder(1)
DbSeek(xFilial("SF2")+alltrim(cNumNF))
                            
dbSelectArea("SA4")
DbSetOrder(1)
//DbSeek(xFilial("SA4")+alltrim(SF2->F2_TRANSP))
DbSeek(xFilial("SA4")+alltrim(SF2->F2_TRANSP))

dbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+alltrim(SF2->F2_CLIENTE))

Do Case
	Case alltrim(SA4->A4_Via) == "RODOVIARIO"
		cViaTran := "1"
	Case alltrim(SA4->A4_Via) == "AEROVIARIO"
		cViaTran := "2"
	Case alltrim(SA4->A4_Via) == "MARITIMO"
		cViaTran := "3"
	Case alltrim(SA4->A4_Via) == "FERROVIARIO"
		cViaTran := "4"
	Case alltrim(SA4->A4_Via) == "RODOFERROVIARIO"
		cViaTran := "5"
	Case alltrim(SA4->A4_Via) == "RODOFLUVIAL"
		cViaTran := "6"
	Case alltrim(SA4->A4_Via) == "RODOAEROVIARIO"
		cViaTran := "7"
	Case alltrim(SA4->A4_Via) == "OUTROS" 
		cViaTran := "8"
ENDCASE

//
// HEADER
//


//_cNumseq := STRZERO(VAL(Getmv("MV_DOCSEQ"))+1,6)

nSequencia := Getmv("MV_NUMMRN")

//DbSelectArea("SX6")
//DbSetorder(1)
//DbSeek(xFilial("SX6")+"MV_NUMMRN")

cData:= strzero(day(date()),2)+strzero(month(date()),2)+substr(str(year(date()),4),3,2)   
cTime := strtran(time(),":","")

AADD(aHeader , {"01","Identificador                                       ","Varchar2   M",	03,   0,001, 003, "ITP"})
AADD(aHeader , {"02","Transacao                                           ","Varchar2   M",	03,   0,004, 006, "NFS"})
AADD(aHeader , {"03","Controle                                            ","Number     M",	07,   0,007, 013, nSequencia  })
AADD(aHeader , {"04","Data Geracao                                        ","Number     M",	06,   0,014, 019, cData})
AADD(aHeader , {"05","Hora Geracao                                        ","Varchar2   M",	06,   0,020, 025, ctime})
AADD(aHeader , {"06","CGC MRN                                             ","Varchar2   M",	14,   0,026, 039, SA1->A1_CGC})
AADD(aHeader , {"07","CGC Fornecedor                                      ","Varchar2   M",	14,   0,040, 053, SM0->M0_CGC})
AADD(aHeader , {"08","Espacos                                             ","Varchar2   M",	197,  0,054, 250, Space(197)})

//
//DADOS DOS ITENS DAS NOTAS
//
dbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2")+alltrim(cNumNF)) 

aItensNF:={}
cCF:= SD2->D2_CF
cTES:= SD2->D2_TES
aPed_Vend:={} 
nPESO_LIQ := 0  
Do While SD2->D2_filial == XfILIAL("SD2") .and. alltrim(SD2->D2_DOC) == ALLTRIM(cNumNF) .and. alltrim(SD2->D2_SERIE) == ALLTRIM(xSerie) .and. !SD2->(EOf())

	dbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+alltrim(SD2->D2_COD))

	AADD(aPED_VEND ,SD2->D2_PEDIDO) 
	nPESO_LIQ  := nPESO_LIQ + ( SB1->B1_PESO * SD2->D2_QUANT )
	
	dbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
	
	cPedClie1   := Alltrim(substr(SC6->C6_x_PRCLI,1,at("-",SC6->C6_x_PRCLI)-1)) 
	cPedClie2   := Alltrim(substr(SC6->C6_x_PRCLI,at("-",SC6->C6_x_PRCLI)+1,2)) 
   
	AADD(aItensNF, {"01","Caracter de Controle	'IT1' (identificador de linha)          ","Varchar2	M",  3,	0,     1,	  3, "IT1"})
	AADD(aItensNF, {"02","Situacao Tributaria                                                      ","Number	   O",  3,	0,	    4,     6, SD2->D2_CLASFIS  })
	AADD(aItensNF, {"03","Numero da Ordem de Compra                                      ","Number	   O",  6,	0,	    7,    12,cPedClie1})
	AADD(aItensNF, {"04","Parcela da Ordem de Compra                                      ","Number	   O",  2,	0,	    13,   14,cPedClie2})
	AADD(aItensNF, {"05","Quantidade da linha da NF	Quantidade total do item    ","Number	   M", 12,  4,	    15,	 26, SD2->D2_QUANT })
	AADD(aItensNF, {"06","Preço unitário da linha da NF	Valor unitário do item     ","Number	   M", 14,  5,	   27,	 40, (SD2->D2_TOTAL + SD2->D2_VALIPI  )  / SD2->D2_QUANT   }) 
	AADD(aItensNF, {"07","Valor Total do item                                                      ","Number	   M", 12,  2,	   41,	 52, SD2->D2_TOTAL + SD2->D2_VALIPI   }) 
	AADD(aItensNF, {"08","Alíquota do ICMS	                                                       ","Number	   O",  3,  0,	   53,	 55, SD2->D2_PICM   }) 
	AADD(aItensNF, {"09","Valor total do  ICMS da linha.	                                   ","Number	   M", 12,  2,	   56,	 67, SD2->D2_VALICM  })
	AADD(aItensNF, {"10","Alíquota do ISS	                                                       ","Number	   O",  2,  0,	   68,	 69, SD2->D2_ALIQISS }) 
	AADD(aItensNF, {"11","Base de cálculo do ISS                                              ","Number	   O", 15,  2,	   70,	 84, SD2->D2_BASEISS })
	AADD(aItensNF, {"12","Valor total do  ICMS da linha.	                                   ","Number	   O", 15,  2,	   85,	 99, SD2->D2_VALISS  })
	AADD(aItensNF, {"13","Espacos                                       	                           ","Varchar2	M", 151,  0,  100,	250, SPACE(151)     })

    nQtItens := nQtItens + 1
	SD2->(DBSkip())
EndDo

aPed := {}
For I:=1 to Len(aPED_VEND)
		
	dbSeek( xFilial("SC5") + aPED_VEND[I] )
			
	cMTKPed	 := SC5->C5_X_NUM
	nMoeda    := SC5->C5_MOEDA		
	
	If !EMPTY(SC5->C5_ESPECI4)
		lFlag_MTK	:=	.T.
	EndIF
			
	If ASCAN(aPED,aPED_VEND[I])==0
				
		dbSeek( xFilial("SC5") + aPED_VEND[I] )
				
		cCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
		cMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
	   //	cTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
	  
		If alltrim(SC5->C5_TPFRETE) == "C"
			cTPFRETE := "2"
		ElseIf alltrim(SC5->C5_TPFRETE) == "F"	
			cTPFRETE := "1"
		EndIf				
		
		AADD(aPED,aPED_VEND[I])
				
	Endif
				
Next


//DADOS DO CABECALHO

cData:= strzero(day(SF2->F2_EMISSAO),2)+strzero(month(SF2->F2_EMISSAO),2)+substr(str(year(SF2->F2_EMISSAO),4),3,2)  
cSerie:=Alltrim(str(val(SF2->F2_SERIE)))

AADD(aCabNF , {"01","Caracter de Controle	'C' (Identificador de cabeçalho",        "Varchar2	   M",    3,	0,	  1,   3, "NF1"})
AADD(aCabNF , {"02","Numero da Nota Fiscal	 Número da Nota Fiscal	       ",        "Number	   M", 	  7,    0,	  4,  10, Subs(SF2->F2_DOC,3,7)}) 
AADD(aCabNF , {"03","Serie da documento Fiscal                            ",         "Varchar2	   M",	  3,	0,	 11,  13, cSerie})
AADD(aCabNF , {"04","Data da NF	Data de emissao do documento	           ",         "Date 	   M",	  6,	0,	 14,  19, cdata})  ///(ddmmaa)
AADD(aCabNF,  {"05","Código do CFO	Código fiscal da operação, sem ponto.  ",         "Number	   M",    6,	0,	   20,    25,val(cCF) })

dbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+alltrim(cTES))

AADD(aCabNF,  {"06","Descricao Código fiscal da operação  ","Varchar2	   M",  30,	0,	   26,    55,SF4->F4_TEXTO     })
AADD(aCabNF , {"07","Quantidade de Itens                             	    ","Number   M",	 5,	0,	  56,   60, nQtItens})
AADD(aCabNF , {"08","Valor dos produtos                                     ","Number   	M",	15,	2,	 61,  75, SF2->F2_VALMERC+SF2->F2_VALIPI})
AADD(aCabNF , {"09","Valor total da NF                                     ","Number   	M",	15,	2,	 76,  90, SF2->F2_VALBRUT})
AADD(aCabNF , {"10","Base de cáculo do ICMS	                            ","Number   	M",	15,	2,	 91,  105,SF2->F2_BASEICM }) 
AADD(aCabNF , {"11","Valor do ICMS	Valor total do ICMS na nota fiscal   ","Number	   M",	15,	2,	 106, 120, SF2->F2_VALICM})
AADD(aCabNF , {"12","Base de cálculo do ICMS Substituto	                ","Number   	M",	15,	2,	121, 135, SF2->F2_BRICMS})
AADD(aCabNF , {"13","Valor do ICMS Substituto	 Valor do ICMS Substituto","Number	   M",	15,	2,	136, 150, SF2->F2_ICMSRET})
AADD(aCabNF , {"14","Valor do Frete                                      ","Number	   M",	15,	2,	151, 165, SF2->F2_FRETE})
AADD(aCabNF , {"15","Valor do Seguro                                     ","Number	   M",	15,	2,	166, 180, SF2->F2_SEGURO})
AADD(aCabNF , {"16","Valor das Despesas                                  ","Number	   M",	15,	2,	181, 195, SF2->F2_DESPESA})
AADD(aCabNF , {"17","Valor do IPI	Valor total do IPI na nota fiscal.   ","Number	   M",	15,	2,	196, 210, SF2->F2_VALIPI}) 
AADD(aCabNF , {"18","Nome da transportadora                              ","Varchar2   M",	30,   0,211, 240, SA4->A4_NOME})
AADD(aCabNF , {"19","Tipo Frete                                          ","Varchar2   M",1,   0,241, 241,cTPFRETE})
AADD(aCabNF , {"20","Via Transporte                                      ","Varchar2   M",	01,   0,242, 242, cViaTran})





AADD(aCabNF , {"21","Tipo NF                                             ","Varchar2   O",	03,   0,243, 245, "   "})
AADD(aCabNF , {"22","Espacos                                             ","Varchar2   M",	05,   0,246, 250, Space(5)})


//Dados do Transportador
AADD(aTransp , {"01","Identificador                                       ","Varchar2   M",	03,   0,001, 003, "NF2"})
AADD(aTransp , {"02","CGC Transportador                                   ","Varchar2   M",	14,   0,004, 017, SA4->A4_CGC})
AADD(aTransp , {"03","Placa do veiculo                                    ","Varchar2   O",	08,   0,018, 025, ""  })
AADD(aTransp , {"04","UF Veiculo                                          ","Varchar2   O",	02,   0,026, 027, ""  })
AADD(aTransp , {"05","Endereco                                            ","Varchar2   O",	40,   0,028, 067, SA4->A4_END})
AADD(aTransp , {"06","Cidade                                              ","Varchar2   O",	15,   0,068, 082, SA4->A4_MUN})
AADD(aTransp , {"07","UF                                                  ","Varchar2   O",	02,   0,083, 084, SA4->A4_EST})
AADD(aTransp , {"08","Inscricao Estadual                                  ","Varchar2   O",	14,   2,085, 098, strtran(SA4->A4_INSEST,".","")})
AADD(aTransp , {"09","Qtde Volumes                                        ","Number     O",	08,   0,099, 106, 0 })
AADD(aTransp , {"10","Especie Volumes                                     ","Varchar2   O",	10,   0,107, 116, SF2->F2_ESPECIE1})
AADD(aTransp , {"11","Marca Volumes                                       ","Varchar2   O",	20,   0,117, 136, SPACE(20) })
AADD(aTransp , {"12","Numero Volumes                                      ","Varchar2   O",	10,   0,137, 146, SPACE(10) })
AADD(aTransp , {"13","Peso Bruto                                          ","Number     O",	12,   5,147, 158, 0 }) //SF2->F2_PBruto
AADD(aTransp , {"14","Peso Liquido                                        ","Number     O",	12,   5,159, 170, 0 })  // nPESO_LIQ
AADD(aTransp , {"15","Espacos                                             ","Varchar2   M",	80,   0,171, 250, SPACE(80)})


DbSelectArea("SCJ")
DbSetOrder(1)
DbSeek(xfilial()+alltrim(cMTKPED))

cPED_ORC	   := SCJ->CJ_COTCLI			
cMENSAGEM1	:= SCJ->CJ_MENNOTA  
IF SCJ->CJ_X_NFTRI	== "S"
	lFLAG_MTK	:= .T.
ENDIF

//cPedClie1   := Alltrim(substr(cPED_ORC,1,at("-",cPED_ORC)-1)) 
//cPedClie2   := Alltrim(substr(cPED_ORC,at("-",cPED_ORC)+1,2)) 

//For nx:= 1 to nQtItens
//	aItensNf[3+((nX-1)*13)][8] := cPedClie1
//	aItensNf[4+((nX-1)*13)][8] := cPedClie2
//Next nX                         

cObs := ""
IF Len(cVar1) > 0 .and. lFlag_MTK
	cObs:= Alltrim(cVar1)
EndIF
IF Len(cVar2) > 0 .and. lFlag_MTK
	cObs:= cObs + " " + Alltrim(cVar2)
EndIF
IF Len(cVar3) > 0 .and. lFlag_MTK
	cObs:= cObs + " " + Alltrim(cVar3)
EndIF
If !EMPTY(cMensagem1)
	cObs := cObs + " " + IIF(Len(cMensagem1)>122,SubStr(cMensagem1,1,122),Alltrim(cMensagem1))
ELSE
	cObs := cObs + " " + IIF(Len(cMensagem)>122,SubStr(cMensagem,1,122),Alltrim(cMensagem))
EndIF
If !(SF2->F2_TIPO $ "B|D")
	cObs := cObs + " " + "***************** PRODUTO COMERCIALIZADO DE ACORDO COM O CODIGO DO CONSUMIDOR - LEI 8078/90 - ART.31 **********"
	cObs := cObs + " " + "** PRODUTO DESTINADO PARA USO OU APLICACAO EXCLUSIVAMENTE INDUSTRIAL DECRETO 53040/08 E PROTOCOLO ICMS 49/08.**"
	cObs := cObs + " " + "**** OBRIGATORIEDADE DE EMISSAO DE NFe A PARTIR DE 01/04/2010, CONFORME PROTOCOLO ICMS nr.42 de 03/07/2009.****"
Endif

//OBSERVACAO DA NOTA
AADD(aObserv , {"01","Identificador                                       ","Varchar2   M",	03,   0,001, 003, "OBS"})
AADD(aObserv , {"02","Observacao da nota                                  ","Varchar2   O",	247,  0,004, 250,  cObs})
 

//RATEIO                                                                                                               
/*
AADD(aMatriz , {"01","Identificador                                       ","Varchar2   M",	03,   0,001, 003, "MR1"})
AADD(aMatriz , {"02","Numero do contrato                                  ","Number     M",	09,   0,004, 012, "666687"  })
AADD(aMatriz , {"03","Sequencia do contrato                               ","Number     M",	04,   0,013, 016, " "  })
AADD(aMatriz , {"04","Tipo do movimento                                   ","Varchar2   M",	01,   0,017, 017, " "  })
AADD(aMatriz , {"05","Conta contabil  OI/OM                               ","Varchar2   M",	17,   0,028, 034, SPACE(17)})
AADD(aMatriz , {"06","Valor Apropriacao                                   ","Number     M",	12,   0,068, 046, 0})
AADD(aMatriz , {"07","Espacos                                             ","Varchar2   M",204,   0,171, 250, SPACE(80)})                                                                                         
*/ 

//TRAILLER
AADD(aTrailler , {"01","Identificador                                     ","Varchar2   M", 03,   0,001, 003, "FTP"})
AADD(aTrailler , {"02","Nr. Controle                                      ","Varchar2   M",	07,   0,004, 010, nSequencia })
AADD(aTrailler , {"03","Quantidade de Registros                           ","Number     M",	12,   0,011, 022, nQtItens + 5})
AADD(aTrailler , {"04","Quantidade de Notas                               ","Number     O",	12,   0,023, 034, 1})
AADD(aTrailler , {"05","Valor Total das Notas                             ","Number     O",	19,   2,035, 053, SF2->F2_VALBRUT})
AADD(aTrailler , {"06","Espacos                                           ","Varchar2   M",	197,  0,054, 250, Space(197)})


//Grava proximo numero para novo arquivo 
nSequencia := soma1(nSequencia)

PutMv("MV_NUMMRN",nSequencia)

//Reclock(cArqTemp,.f.)
//    SX6->X6_CONTEUDO := nSequencia
//MsUnlock()

/*
nSequencia := Val(cSequencia)
nSequencia := nSequencia + 1
cSequencia  := str(nSequencia,6)
Reclock(cArqTemp,.f.)
    SX6->X6_CONTEUDO := cSequencia
MsUnlock()
*/

//HEADER
For nY:= 1 to Len(aHeader)
            
    nTam      := aHeader[nY][4]
    nDec      := aHeader[nY][5]
    cConteudo := aHeader[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY
//
// SALTA NO TXT
//
FWRITE(nHdlSaida,CHR(13)+CHR(10))

//CABECALHO DA NOTA
For nY:= 1 to Len(aCabNF)
            
    nTam      := aCabNF[nY][4]
    nDec      := aCabNF[nY][5]
    cConteudo := aCabNF[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY
//
// SALTA NO TXT
//
FWRITE(nHdlSaida,CHR(13)+CHR(10))
      

//TRANSPORTADOR
For nY:= 1 to Len(aTransp)
            
    nTam      := aTransp[nY][4]
    nDec      := aTransp[nY][5]
    cConteudo := aTransp[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY
//
// SALTA NO TXT
//
FWRITE(nHdlSaida,CHR(13)+CHR(10))


// ITENS DA NOTA FISCAL
//

For nY:= 1 to nQtItens
	For nx:= 1 to 13              
		nTam      := aItensNF[nX+((nY-1)*13)][4]
   		nDec      := aItensNF[nX+((nY-1)*13)][5]
     	cConteudo := aItensNF[nX+((nY-1)*13)][8]

	    cCampo    := _Transf( nTam, nDec , cConteudo)

    	Fwrite( nHdlSaida  , cCampo , nTam )

    Next nX
   //	nY := nX - 1
	//
	// SALTA NO TXT
	//	
	FWRITE(nHdlSaida,CHR(13)+CHR(10))         
    
Next nY
//
// SALTA NO TXT
//
//FWRITE(nHdlSaida,CHR(13)+CHR(10))

	

For nY:= 1 to Len(aObserv)
            
    nTam      := aObserv[nY][4]
    nDec      := aObserv[nY][5]
    cConteudo := aObserv[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY
//
// SALTA NO TXT
//
FWRITE(nHdlSaida,CHR(13)+CHR(10))


For nY:= 1 to Len(aTrailler)
            
    nTam      := aTrailler[nY][4]
    nDec      := aTrailler[nY][5]
    cConteudo := aTrailler[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY
//
// SALTA NO TXT
//
FWRITE(nHdlSaida,CHR(13)+CHR(10))



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos ASC II                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FCLOSE(nHdlSaida)                                       

// Conteudo da BAT - REN F:\CNAB\ALCOA\%1\nf??????.2d  NF??????.2D       

//WAITRUN("F:\CNAB\MRN\REN_ALCOA.BAT "+ALLTRIM(SM0->M0_FILIAL))


RETURN



Static Function _Transf( nTam, nDec , cConteudo)  

Local cCampo
Local lConteudo:=.F.
Private xConteudo


xConteudo:=cConteudo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Analisa conteudo                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF Empty(xConteudo)

	if ValType(xConteudo)="N" 
   		cCampo:=REPLICATE("0",nTam)
   	Else
   		cCampo:=Space(nTam)
   	Endif 	

Else
	   
		//lConteudo := fa150Orig( cConteudo ) // Analiza se a expresao e valida retornando o xConteudo
		//IF !lConteudo
		//	Return
		//Else
		IF ValType(xConteudo)="D"
			cCampo := GravaData(xConteudo,.F.,5) //DDMMAAAA VER MATXFUNB
		Elseif ValType(xConteudo)="N"
		   If  nDec > 0 
		       _nvl:=val("1"+REPLICATE("0",nDec))
  		       xConteudo:= xConteudo*_nvl
  		   Endif    
		   cCampo:=Substr(Strzero(xConteudo,nTam),1,nTam)
		   //cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
		Else
			cCampo:=Substr(xConteudo,1,nTam)
		EndIf
		//EndIf
EndIf
If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
	cCampo:=cCampo+Space(nTam-Len(cCampo))
EndIf

Return(cCampo)

