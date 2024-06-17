#INCLUDE "Fivewin.ch"
#INCLUDE "SIGA.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ANA_RENATA³Autor  ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Geracao de Arquivo txt para uso da impressao da etiqueta     ³±±
±±³          ³Bidimencional (Alcoa)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ANA_RENATA()

Local cTFrete     :=0             
Local	nPesoBR     :=0
Local nVotNf      :=0

Local cArqSaida   :="NF"+xNUM_NF+".TXT"

Local lImportacao := If(xTipo="C" .and. !EMPTY(xHWB_MTK),.f.,.t.) // Tratamento Especifico para o Caso de Importacao e   

Local cDestino    := ""
Local cUnidade    := ""    

Local cPedClie1   := Alltrim(substr(xPED_ORC,1,at("-",xPED_ORC)-1)) 
Local cPedClie2   := Alltrim(substr(xPED_ORC,at("-",xPED_ORC)+1,4)) 
Local cItemLinh   := ""

Private  nHdlSaida:= 0
Private  aCabNF   :={}                          
Private  aCliente :={}
Private  aTrans   :={}
Private  aItensNF :={}
Private  nTotProd :=LEN(xCOD_PRO) // Total de Itens


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Saida                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  

//
// Verifica se o diretorio existe caso negativo sera criado
//
//MAKEDIR("F:\CNAB\ANA_REN\"+ALLTRIM(SM0->M0_FILIAL))
MAKEDIR("Y:\"+ALLTRIM(SM0->M0_FILIAL))

//
// Cria um arquivo texto no diretorio gerado acima logo abaixo sera renomeado com waitrun
// devido o microsiga somente trabalhar com letras minusculas.
//
//nHdlSaida:=MSFCREATE("F:\CNAB\ANA_REN\"+ALLTRIM(SM0->M0_FILIAL)+"\"+cArqSaida,0)
nHdlSaida:=MSFCREATE("Y:\"+ALLTRIM(SM0->M0_FILIAL)+"\"+cArqSaida,0)


//
// AADD(aCabNF , {"06","Flag Frete	                                        ",_Transf("Varchar2 	M",	 1,	 ,	 16,  16,cTFrete}
//
IF MV_PAR04 == 2
	If XTIPO <> "B"
		IF Alltrim(xFRETE_SCJ) <> Alltrim(xTPFRETE)
			If xTPFRETE   == 'C'					// Frete por conta do
				cTFrete:="1"				// Emitente (1)
			Else 									//     ou
				cTFrete:="2"				// Destinatario (2)
			Endif
		ELSE
			If xFRETE_SCJ == 'C'					// Frete por conta do
				cTFrete:="1"				// Emitente (1)
			Else 									//     ou
				cTFrete:="2"				// Destinatario (2)
			Endif
		ENDIF
	Endif
ELSE
	cTFrete:="1"				// Emitente (1)
ENDIF


//
//AADD(aCabNF , {"07","Peso total do Frete (TON)                           ",_Transf("Number	   O",	12,	4,	 17,  28,}
//
IF !EMPTY(xHWB_MTK)
	_nPesoBrt := Getadvfval("SW6","W6_PESO_BR",xFILIAL("SW6")+xHWB_MTK,1," ")
	nPesoBR:= _nPesoBrt
Else
	nPesoBR:= xPBRUTO
ENDIF

//
//AADD(aCabNF , {"10","Valor NF	Valor total da nota fiscal mais encargos   ",_Transf("Number   	M",	15,	2,	 47,  61,}
//
IF xTipo <> "I" .and. xTipo <> "P" .and. lImportacao
	nVotNf:= xTOT_FAT
ELSEIF xTipo == "P"
	nVotNf:= xVALOR_IPI 
ELSEIF xTipo == "C" .and. !EMPTY(xHWB_MTK)
	nVotNf:= xVALOR_MERC 
EndIF



//
// Dados do Cliente 
//
AADD(aCliente , {"01","Indentificacao da Linha                             ","Varchar2 M",01,00,01,01,"C"})
AADD(aCliente , {"02","Indentificacao do Cliente.Codigo Sequencial         ","Varchar2 M",	 8,	0,	  2,   9, xCLIENTE + xLOJA})
AADD(aCliente , {"03","Razao Social do Cliente                             ","Varchar2 M",	40,   0,	 10,  49, xNOME_CLI})
AADD(aCliente , {"04","Nome Fantasia                                  	    ","Varchar2 M",	20,   0,	 50,  69, SA1->A1_NREDUZ}) 
AADD(aCliente , {"05","CNPJ do cliente                                     ","Varchar2	 M",	15,	0,	 70,  84, STRZERO(VAL(xCGC_CLI),15)})
AADD(aCliente , {"06","Inscricao Estatual                                  ","Varchar2 M",	18,	0,	 85, 102, xINSC_CLI })
AADD(aCliente , {"07","Endereco de Faturamento                             ","Varchar2 M",	40,	0,	103, 142, xREC_CLI  })
AADD(aCliente , {"08","Cidade de Faturamento                               ","Varchar2 M",	15,	0,	143, 157, xMNE_CLI  }) 
AADD(aCliente , {"09","Estado de Faturamento                               ","Varchar2 M",	02,	0,	158, 159, xUFE_CLI  })
AADD(aCliente , {"10","Bairro de Fatruamento                               ","Varchar2 M",	20,	0,	160, 179, xBRE_CLI  })
AADD(aCliente , {"11","CEP de Faturamento                                  ","Varchar2 M",	 8,	0,	180, 187, XCEP_CLI  })
AADD(aCliente , {"12","Telefone                                            ","Varchar2 M", 	15,	0,	188, 202, xTEL_CLI  })


//
// Dados da Nota Fiscal
//
AADD(aCabNF   , {"01","Caracter de Controle	'C' (Identificador de cabeçalho","Varchar2 M",  1,	   0,  01,  01, "N"})
AADD(aCabNF   , {"02","Numero da Nota Fiscal	 Número da Nota Fiscal	       ","Number	 M",  6,    0,	 02,  07, xNUM_NF}) 
AADD(aCabNF   , {"03","Serie da documento Fiscal                            ","Varchar2 M",  3,	   0,	 08,  10, xSERIE})
AADD(aCabNF   , {"04","Data da NF	Data de emissao do documento	          ","Date 	 M",  8,	   0,	 11,  18, xEMISSAO})  ///(ddmmaaaa)
AADD(aCabNF   , {"05","Flag Frete	                                        ","Varchar2 M",  1,	   0,	 19,  19, cTFrete})
AADD(aCabNF   , {"06","Razao Social do Remetente    (Cliente)              ","Varchar2 M",  40,   0,	 20,  59, SM0->M0_NOMECOM})
AADD(aCabNF   , {"07","Razao Social do Destinatario (Cliente)              ","Varchar2 M",	40,   0,	 60,  99, xNOME_CLI})
AADD(aCabNF   , {"08","CFOP                                                 ","Number	 M",  05,	4,	100, 104, xCF[1]})
AADD(aCabNF   , {"09","Texto da Natureza da Operacao                        ","Varchar2 M", 20,	   0,	105, 124, xNATUREZA}) 
AADD(aCabNF   , {"10","Especie da Carga                                     ","Varchar2 M", 10,	   0,	125, 134, xESPECIE}) 
AADD(aCabNF   , {"11","Quantidade de Volumes                                ","Varchar2 M",  6,	   3,	135, 144, xVOLUME}) 
AADD(aCabNF   , {"12","Peso Bruto                                           ","Varchar2 M", 10,   	3,	145, 154, nPesoBR}) 
AADD(aCabNF   , {"13","Peso Liquido                                         ","Varchar2 M", 10,   	3,	155, 164, xPESO_LIQUID}) 
AADD(aCabNF   , {"14","Valor NF	Valor total da nota fiscal mais encargos   ","Number   M", 15,  	2, 165, 179, nVotNf})
AADD(aCabNF   , {"15","Endereco de Entrega                                  ","Number   M", 30,  	0, 180, 209, xREC_CLI})
AADD(aCabNF   , {"16","Bairro de Entrega                                    ","Number   M", 15,  	0, 210, 224, xBRE_CLI})
AADD(aCabNF   , {"17","Cidade de Entrega                                    ","Number   M", 20,  	0, 225, 244, xMNE_CLI})
AADD(aCabNF   , {"18","Estado de Entrega                                    ","Number   M", 02,  	0, 245, 246, xUFE_CLI})


//
// Dados da Transportadora
//
AADD(aTrans   , {"01","Caracter de Controle	'C' (Identificador de cabeçalho","Varchar2 M",  01,   0,  1,   1, "T"})
AADD(aTrans   , {"02","Indentificacao do Cliente.Codigo Sequencial         ","Varchar2 M",	06,	0,	  2,   7, SA4->A4_COD})
AADD(aTrans   , {"03","Razao Social                                         ","Number	 M",  37,   0,	  8,  44, SUBSTR(xNOME_TRANSP,1,37)  }) 
AADD(aTrans   , {"04","CNPJ da Transportadora                               ","Varchar2 M",  15,   0,	 45,  59, xCGC_TRANSP})
AADD(aTrans   , {"05","Endereco da Transportadora                           ","Date 	  M", 35,   0,	 60,  94, SUBSTR(xEND_TRANSP,1,35)   }) 
AADD(aTrans   , {"06","Bairro da Transportadora                             ","Varchar2 M",  08,   0,	 95, 102, SUBSTR(xBAIRRO_TRANSP,1,8) })
AADD(aTrans   , {"07","Municipio da Transportadora                          ","Varchar2 M",  15,   0,	103, 117, xMUN_TRANSP })
AADD(aTrans   , {"08","Estado da Transportadora                             ","Varchar2 M", 	 02,   0,118, 119, xEST_TRANSP })
AADD(aTrans   , {"09","Inscricao Estadual da Transportadora                 ","Varchar2 M",	 15,   0,120, 134, xINSCR_TRANSP  })
AADD(aTrans   , {"10","Telefone da Transportadora                           ","Varchar2 M",	 15,   0,135, 149, xTEL_TRANSP  })



//
// Dados do Cliente 
//
For nY:= 1 to Len(aCliente)
            
    nTam      := aCliente[nY][4]
    nDec      := aCliente[nY][5]
    cConteudo := aCliente[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY

FWRITE(nHdlSaida,CHR(13)+CHR(10)) // Salta no Txt

//
// Dados da Nota Fiscal
//
For nY:= 1 to Len(aCabNF)
            
    nTam      := aCabNF[nY][4]
    nDec      := aCabNF[nY][5]
    cConteudo := aCabNF[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY

FWRITE(nHdlSaida,CHR(13)+CHR(10)) // Salta no Txt

//
// Dados da Transportadora
//
For nY:= 1 to Len(aTrans)
            
    nTam      := aTrans[nY][4]
    nDec      := aTrans[nY][5]
    cConteudo := aTrans[nY][8]
                                
    cCampo    := _Transf( nTam, nDec , cConteudo)

    Fwrite( nHdlSaida  , cCampo , nTam )

Next nY

FWRITE(nHdlSaida,CHR(13)+CHR(10)) // Salta no Txt


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos ASC II                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FCLOSE(nHdlSaida)                                       

// Conteudo da BAT - REN F:\CNAB\ALCOA\%1\nf??????.2d  NF??????.2D       
///WAITRUN("F:\CNAB\ALCOA\REN_ALCOA.BAT "+ALLTRIM(SM0->M0_FILIAL))


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








