#INCLUDE "Fivewin.ch"
#INCLUDE "SIGA.ch"
#Include "COLORS.CH"
#Include "FONT.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ETQ_ALCOA ³Autor  ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Geracao de Arquivo txt para uso da impressao da etiqueta     ³±±
±±³          ³Bidimencional (Alcoa)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ETQ_ALCOA()

Local cTFrete       :=0
Local	nPesoBR     :=0
Local nVotNf        :=0

Local cNumNFT   := Substr(xNUM_NF,4,6)          // Numero da Nota Fiscal Tratado

Local cArqSaida   :="NF"+cNumNFT+".2D"

Local lImportacao := If(xTipo="C" .and. !EMPTY(xHWB_MTK),.f.,.t.) // Tratamento Especifico para o Caso de Importacao e

Local cDestino     := ""
Local cUnidade    := ""

Local cPedClie1   := Alltrim(substr(xPED_ORC,1,at("-",xPED_ORC)-1))
Local cPedClie2   := Alltrim(substr(xPED_ORC,at("-",xPED_ORC)+1,4))
Local cItemLinh   := ""

Private  nHdlSaida:= 0
Private  aMedidas :={}
Private  aCabNF   :={}
Private  aItensNF :={}
Private  nTotProd :=LEN(xCOD_PRO) // Total de Itens


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Saida                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//
// Verifica se o diretorio existe caso negativo sera criado
//
MAKEDIR("F:\CNAB\ALCOA\"+ALLTRIM(SM0->M0_FILIAL))

//
// Cria um arquivo texto no diretorio gerado acima logo abaixo sera renomeado com waitrun
// devido o microsiga somente trabalhar com letras minusculas.
//
nHdlSaida:=MSFCREATE("F:\CNAB\ALCOA\"+ALLTRIM(SM0->M0_FILIAL)+"\"+cArqSaida,0)


// Deleta Reimpressoes quando tenho que imprimir novamente
// o arquivo anterior I-...... deve ser excluido, devido
// o software da impressora apos impresso tentar renomear o
// arquivo lido para I-...... caso nao consiga a impressora
// fica em loop ou seja imprimindo sem parar.
If File("F:\CNAB\ALCOA\"+ALLTRIM(SM0->M0_FILIAL)+"\"+"I-"+cArqSaida)
	Ferase("F:\CNAB\ALCOA\"+ALLTRIM(SM0->M0_FILIAL)+"\"+"I-"+cArqSaida)
Endif



AADD(aMedidas,{"Metro               ","M   ","M      "})
AADD(aMedidas,{"Quilograma          ","KG  ","KG     "})
AADD(aMedidas,{"Hora/Homem          ","HH  ","       "})
AADD(aMedidas,{"Peca   	            ","PC  ","PC     "})
AADD(aMedidas,{"Unidade	            ","PC  ","UN     "}) // ESTOU FORCANDO UNIDADE COMO PECA POIS NAO EXISTE PARA ALCOA UNIDADE
AADD(aMedidas,{"Litro   	         ","L   ","LT     "})
AADD(aMedidas,{"Metro Quadrado      ","M2  ","M2     "})
AADD(aMedidas,{"Balde   		      ","BD  ","BD     "})
AADD(aMedidas,{"Barra   		      ","BR  ","       "})
AADD(aMedidas,{"Bisnaga   		      ","BNG ","       "})
AADD(aMedidas,{"Bloco   		      ","BL  ","       "})
AADD(aMedidas,{"Bobina   		      ","BBI ","       "})
AADD(aMedidas,{"Bombona  		      ","BBA ","       "})
AADD(aMedidas,{"Box   		         ","BOX ","       "})
AADD(aMedidas,{"Caixa   		      ","CX  ","CX     "})
AADD(aMedidas,{"Centimetro  	      ","CM  ","CM     "})
AADD(aMedidas,{"Centimetro Cubico   ","CM3 ","CC     "})
AADD(aMedidas,{"Cento   		      ","CT  ","CT     "})
AADD(aMedidas,{"Centrimetro Quadrado","CM2 ","       "})
AADD(aMedidas,{"Conjunto  	         ","CJ  ","CJ     "})
AADD(aMedidas,{"Decimetro  	   	","DM  ","       "})
AADD(aMedidas,{"Decimetro Cubico 	","DM3 ","       "})
AADD(aMedidas,{"Decimetro quadrado  ","DM2 ","       "})
AADD(aMedidas,{"Dúzia   		      ","DZ  ","       "})
AADD(aMedidas,{"Elo   		         ","EL  ","       "})
AADD(aMedidas,{"Embalagem  		   ","EMB ","       "})
AADD(aMedidas,{"Fardo   		      ","FD  ","       "})
AADD(aMedidas,{"Folha   	     	   ","FL  ","FL     "})
AADD(aMedidas,{"Frasco   		      ","FR  ","       "})
AADD(aMedidas,{"Galão   		      ","GL  ","GL     "})
AADD(aMedidas,{"Garrafa   	   	   ","GF  ","       "})
AADD(aMedidas,{"Garrafão  		      ","GO  ","       "})
AADD(aMedidas,{"Grade   		      ","GRD ","       "})
AADD(aMedidas,{"Grama   	         ","GR  ","       "})
AADD(aMedidas,{"Hectolitro  		   ","HL  ","       "})
AADD(aMedidas,{"Horas   		      ","HR  ","       "})
AADD(aMedidas,{"Jogo   		         ","JG  ","JG     "})
AADD(aMedidas,{"Kilowat   	  	      ","KW  ","       "})
AADD(aMedidas,{"Lata   		         ","LAT ","LT     "})
AADD(aMedidas,{"Libra   		      ","LB  ","       "})
AADD(aMedidas,{"Lote   		         ","LOT ","       "})
AADD(aMedidas,{"Maço   		         ","MC  ","       "})
AADD(aMedidas,{"Metro Cubico  	   ","M3  ","M3     "})
AADD(aMedidas,{"Milheiro   		   ","MLH ","ML     "})
AADD(aMedidas,{"Mililitro   	      ","ML  ","MM     "})
AADD(aMedidas,{"Milimetro  		   ","MM  ","       "})
AADD(aMedidas,{"Milimetro Quadrado  ","MM2 ","       "})
AADD(aMedidas,{"Minuto   		      ","MIN ","       "})
AADD(aMedidas,{"Pacotes   		      ","PT  ","PT     "})
AADD(aMedidas,{"Par   		         ","PR  ","P      "})
AADD(aMedidas,{"Polegada  		      ","IN  ","PL     "})
AADD(aMedidas,{"Polegada Quadrada   ","IN2 ","       "})
AADD(aMedidas,{"PE   	        	   ","FT  ","FT     "})
AADD(aMedidas,{"PE Quadrado  	      ","FT2 ","       "})
AADD(aMedidas,{"Quilometro  	      ","KM  ","       "})
AADD(aMedidas,{"Resma   		      ","RM  ","       "})
AADD(aMedidas,{"Rolo   		         ","RL  ","       "})
AADD(aMedidas,{"Saco   		         ","SC  ","       "})
AADD(aMedidas,{"Serviço   	  	      ","SRV ","       "})
AADD(aMedidas,{"Talão   		      ","TAL ","       "})
AADD(aMedidas,{"Tanque   		      ","TQ  ","       "})
AADD(aMedidas,{"Tonelada  		      ","T   ","TL     "})
AADD(aMedidas,{"Tonelada Curta      ","TS  ","       "})
AADD(aMedidas,{"Tonelada Métrica    ","TM  ","       "})
AADD(aMedidas,{"Tubo   		         ","TBV ","       "})


//
// AADD(aCabNF , {"06","Flag Frete	                                        ",_Transf("Varchar2 	M",	 1,	 ,	 16,  16,cTFrete}
//
IF Alltrim(xFRETE_SCJ) <> Alltrim(xTPFRETE)
	cTFrete:=xTPFRETE
ELSE
	cTFrete:=xFRETE_SCJ
ENDIF


//
//AADD(aCabNF , {"07","Peso total do Frete (TON)                           ",_Transf("Number	   O",	12,	4,	 17,  28,}
//
If cTFrete = "F"
	IF !EMPTY(xHWB_MTK)
		_nPesoBrt := Getadvfval("SW6","W6_PESO_BR",xFILIAL("SW6")+xHWB_MTK,1," ")
		nPesoBR:= _nPesoBrt
	Else
		nPesoBR:= xPBRUTO
	ENDIF
Endif

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




AADD(aCabNF , {"01","Caracter de Controle	'C' (Identificador de cabeçalho","Varchar2	M",    1,	0,	  1,   1, "C"})
AADD(aCabNF , {"02","Tipo NF-ALCOA	 'M' - Nota Fiscal de Mercadoria	    ","Varchar2   M",	 1,	0,	  2,   2, "M"})
AADD(aCabNF , {"03","Reservado	Preencher com ZEROS	                   ","Number	   M",	 2,   0,	  3,   4, 0})
AADD(aCabNF , {"04","Numero da Nota Fiscal	 Número da Nota Fiscal	    ","Number	   M",	 6,   0,	  5,  10, cNumNFT})
AADD(aCabNF , {"05","Serie da documento Fiscal                           ","Varchar2	M",	 5,	0,	 11,  15, xSERIE})
AADD(aCabNF , {"06","Flag Frete	                                        ","Varchar2 	M",	 1,	0,	 16,  16, cTFrete})
AADD(aCabNF , {"07","Peso total do Frete (TON)                           ","Number	   O",	12,	4,	 17,  28, 0})
AADD(aCabNF , {"08","Tipo de Documento	'CGC'	                            ","Varchar2	M",	 3,	0,	 29,  31, "CGC"})
AADD(aCabNF , {"09","Numero do documento	CGC                            ","Varchar2	M",	15,	0,	 32,  46, STRZERO(VAL(SM0->M0_CGC),15)})
AADD(aCabNF , {"10","Valor NF	Valor total da nota fiscal mais encargos   ","Number   	M",	15,	2,	 47,  61, nVotNf})
AADD(aCabNF , {"11","Data da NF	Data de emissao do documento	          ","Date 	   M",	 8,	0,	 62,  69, xEMISSAO})  ///(ddmmaaaa)
AADD(aCabNF , {"12","Tipo ICMS	                                        ","Varchar2	M", 	 2,	0,	 70,  71, "08"})
AADD(aCabNF , {"13","Base de cáculo do ICMS	                            ","Number   	M",	15,	2,	 72,  86, xBASE_ICMS})
AADD(aCabNF , {"14","Valor do ICMS	Valor total do ICMS na nota fiscal   ","Number	   M",	15,	2,	 87, 101, xVALOR_ICMS})
AADD(aCabNF , {"15","Valor do IPI	Valor total do IPI na nota fiscal.   ","Number	   M",	15,	2,	102, 116, xVALOR_IPI})
AADD(aCabNF , {"16","Modelo de documento fiscal	                         ","Varchar2	M",	10,	0,	117, 126, "NF"})
AADD(aCabNF , {"17","Base de cálculo do ICMS Substituto	                ","Number   	M",	15,	2,	127, 141, 0})
AADD(aCabNF , {"18","Valor do ICMS Substituto	 Valor do ICMS Substituto","Number	   M",	15,	2,	142, 156, 0})
AADD(aCabNF , {"19","Data do Primeiro Vencimento                         ","Date      M",	    8,	0,	157, 164, xVENC_DUP[1]})  ///(ddmmaaaa)
AADD(aCabNF , {"20","Valor do desconto / encargo	Valor de desconto     ","Number	   O",	15,	2,	165, 179, 0})
AADD(aCabNF , {"21","Quantidade de linhas da Nota Fiscal	Quantidade      ","Number	   M",	 4,	0,	180, 183, nTotProd})

//
// HEADER
//
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


For I:= 1 to  Len(xCOD_PRO)
	
	aItensNF:={}
	
	cUnidade  := Medidas(ALLTRIM(xUNID_PRO[I]))
	
	cItemLinh := Alltrim(substr(xCOD_CLI_ORC[I],at("-",xCOD_CLI_ORC[I])+1,4))
	
	
	AADD(aItensNF, {"01","Caracter de Controle	'L' (identificador de linha)       ","Varchar2	M",  1,	0,     1,	  1, "L"           })
	AADD(aItensNF, {"02","Número da Linha do Item	Número da Linha da NF	        ","Number	   M",  4,	0,	    2,     5, I             })
	AADD(aItensNF, {"03","Número da Nota Fiscal	Mesma informação do cabeçalho	     ","Number	   M",  6,	0,	    6,    11, cNumNFT       })
	AADD(aItensNF, {"04","Serie da Nota Fiscal	Mesma informação do cabeçalho	     ","Varchar2	M",  5,	0,	   12,    16, xSERIE        })
	AADD(aItensNF, {"05","Código da Classificação Fiscal	                          ","Varchar2	M",  8,	0,	   17,    24, xPS_MTK[I]    })
	AADD(aItensNF, {"06","Código do CFO	Código fiscal da operação, sem ponto. 	     ","Number	   M",  4,	0,	   25,    28, xCF[1]        })
	AADD(aItensNF, {"07","Unidade de medida	Unidade de medida do item da linha.   ","Varchar2	M",  3,  0,    29,	 31, cUnidade      })
	AADD(aItensNF, {"08","Quantidade da linha da NF	Quantidade total do item        ","Number	   M", 15,  7,	   32,	 46, xQTD_PRO[I]   })
	AADD(aItensNF, {"09","Preço unitário da linha da NF	Valor unitário do item    ","Number	   M", 15,  7,	   47,	 61, xPRE_UNI[I]   })
	AADD(aItensNF, {"10","Base de cálculo do ICMS	Valor total da Base Cálculo ICMS","Number	   M", 15,  2,	   62,	 76, xIcmBase[I]   })
	AADD(aItensNF, {"11","Alíquota do ICMS	Alíquota do ICMS	                       ","Number	   M",  4,  2,	   77,	 80, xICMS[I]      })
	AADD(aItensNF, {"12","Valor do ICMS	Valor total do  ICMS da linha.	           ","Number	   M", 15,  2,	   81,	 95, xIcmValor[I]  })
	AADD(aItensNF, {"13","Base de cálculo do IPI	Valor total da base            	  ","Number	   M", 15,  2,	   96,	110, xIpiBase[I]   })
	AADD(aItensNF, {"14","Alíquota do IPI	Alíquota de IPI	                       ","Number	   M",  4,  2,	  111,	114, xIPI[I]       })
	AADD(aItensNF, {"15","Valor do IPI	Valor total do IPI na linha do item.	     ","Number	   M", 15,  2,	  115,	129, xVAL_IPI[I]   })
	AADD(aItensNF, {"16","Base de cálculo ICMS substituto	Base de cálculo ICMS 	  ","Number	   M", 15,  2,	  130,	144, 0             })
	AADD(aItensNF, {"17","Valor do ICMS substituto	Valor do ICMS substituto	     ","Number   	M", 15,  2,	  145,	159, 0             })
	AADD(aItensNF, {"18","Pedido de compra	Numero do pedido de compra ALCOA	        ","Varchar2	M", 15,  0,   160,	174, cPedClie1     })
	AADD(aItensNF, {"19","Linha do pedido de compra	Número da linha do pedido   	  ","Number	   M",  4,  0,   175,	178, cItemLinh     })
	AADD(aItensNF, {"20","Número da liberação	Número da liberação              	  ","Number	   O",  4,  0,	   179,	182, cPedClie2     })
	
	//
	// ITENS DA NOTA FISCAL
	//
	For nY:= 1 to Len(aItensNF)
		
		nTam      := aItensNF[nY][4]
		nDec      := aItensNF[nY][5]
		cConteudo := aItensNF[nY][8]
		
		cCampo    := _Transf( nTam, nDec , cConteudo)
		
		Fwrite( nHdlSaida  , cCampo , nTam )
		
	Next nY
	
	//
	// SALTA NO TXT
	//
	FWRITE(nHdlSaida,CHR(13)+CHR(10))
	
Next I


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos ASC II                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FCLOSE(nHdlSaida)

// Conteudo da BAT - REN F:\CNAB\ALCOA\%1\nf??????.2d  NF??????.2D

WAITRUN("F:\CNAB\ALCOA\REN_ALCOA.BAT "+ALLTRIM(SM0->M0_FILIAL))


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



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ Medidas  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mediante nossa unidade de medida retorna a unidade         ³±±
±±³			 ³ equivalente a Alcoa                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Medidas(cMedMtk)
Local  _lRet :=.T.
Local _nPos:= aScan(aMedidas,{|x| AllTrim(x[3])==alltrim(cMedMtk)})

If  _nPos = 0
	cMedAlcoa:="PC"
Else
	cMedAlcoa:=alltrim(aMedidas[_nPos][2])
Endif

If EmptY(cMedAlcoa)
	cMedAlcoa:="PC"
	//Aviso( "Atencao!", "Unidade de Medida Equivalente a "+cMedMtk+"nao encontrada na Alcoa, sera necessario intervencao via programa!",{"&Ok"})
Endif

Return(cMedAlcoa)







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ValAlcoa | Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mediante nossa unidade de medida retorna a unidade         ³±±
±±³			 ³ equivalente a Alcoa                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValAlcoa(cCodigo)

Local lRet:=.T.

If  UPPER(alltrim(cCodigo))<>"N"
	
	If  SA1->A1_X_GETIQ $ "2/3" // Valiada Alcoa e Mrn
		
		if at("-",cCodigo) = 0
			
			lRet:=.F.
			
			If !lRet .AND. SA1->A1_X_GETIQ $ "2"
				  Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
			Endif

			If !lRet .AND. SA1->A1_X_GETIQ $ "3"
				  Aviso( "Atencao!", "O codigo informado para Mrn nao e valido o mesmo deve ser o 999999-99 (apos o Hifem informar 02 Digitos).",{"&Ok"})
            Endif

		Else
			
			If SA1->A1_X_GETIQ $ "2" // Valida Alcoa
				
				If Len(alltrim(substr(cCodigo,at("-",cCodigo)+1,4)))  <  4
					
					lRet:=.F.
					
				EndIf
				
				If !lRet
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
				Endif
				
				
			Else                    // Valida Mrn
				
				If Len(alltrim(substr(cCodigo,at("-",cCodigo)+1,2)))  <  2
					lRet:=.F.
				EndIf

				If Len(alltrim(cCodigo)) <> 9
					lRet:=.F.
                Endif
                
				If !lRet
					Aviso( "Atencao!", "O codigo informado para Mrn nao e valido o mesmo deve ser o 999999-99 (apos o Hifem informar 02 Digitos).",{"&Ok"})
				Endif
				
			Endif

		Endif
		
	Endif
	
Endif

Return(lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ValAlcoa | Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mediante nossa unidade de medida retorna a unidade         ³±±
±±³			 ³ equivalente a Alcoa                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
SOMENTE UTILIZADA NO CAMPO CJ_COTCLI - SEGUNDO INFORMADO A ALCOA ESTA SE APOIANDO
NESTE CAMPO PARA GERACAO DE ETIQUETA.

*/
// Atencao
//SOMENTE UTILIZADA NO CAMPO CJ_COTCLI - SEGUNDO INFORMADO A ALCOA ESTA SE APOIANDO
//NESTE CAMPO PARA GERACAO DE ETIQUETA.Esta rotina nao e utilizada na tela do simulador
//apenas no Capecalho do ORcamento 
User Function Val2Alcoa(cCodigo)

Local lRet:=.T.

If  UPPER(alltrim(cCodigo))<>"N"
	
	If  SA1->A1_X_GETIQ $ "2" // Valiada Alcoa e Mrn
		
		if at("-",cCodigo) = 0
			
			lRet:=.F.
			
			If !lRet .AND. SA1->A1_X_GETIQ $ "2"
				  Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
			Endif

		Else
			
			If SA1->A1_X_GETIQ $ "2" // Valida Alcoa
				
				If Len(alltrim(substr(cCodigo,at("-",cCodigo)+1,4)))  <  4
					
					lRet:=.F.
					
				EndIf
				
				If !lRet
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
				Endif
				
				
			Endif

		Endif
		
	Endif
	
Endif

Return(lRet)



