#INCLUDE "MATXFIS.CH"
#INCLUDE "FIVEWIN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ MATXFIS  ³ Autor ³ Eduardo / Edson       ³ Data ³08.12.1999	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de Calculo de Impostos Fiscais e Financeiros      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         	³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#DEFINE NF_TIPONF		01    //Tipo : N , I , C , P
#DEFINE NF_OPERNF		02    //E-Entrada | S - Saida
#DEFINE NF_CLIFOR		03    //C-Cliente | F - Fornecedor
#DEFINE NF_TPCLIFOR    	04    //Tipo do destinatario R,F,S,X
#DEFINE NF_LINSCR		05    //Indica se o destino possui inscricao estadual
#DEFINE NF_GRPCLI		06    //Grupo de Tributacao
#DEFINE NF_UFDEST		07    //UF do Destinatario
#DEFINE NF_UFORIGEM	    08    //UF de Origem
#DEFINE NF_DESCONTO	    10    //Valor Total do Deconto
#DEFINE NF_FRETE		11    //Valor Total do Frete
#DEFINE NF_DESPESA	    12    //Valor Total das Despesas Acessorias
#DEFINE NF_SEGURO		13    //Valor Total do Seguro
#DEFINE NF_AUTONOMO 	14    //Valor Total do Frete Autonomo
#DEFINE NF_ICMS		    15    //Array contendo os valores de ICMS
#DEFINE NF_BASEICM	    15,01 //Valor da Base de ICMS
#DEFINE NF_VALICM		15,02 //Valor do ICMS Normal
#DEFINE NF_BASESOL	    15,03 //Base do ICMS Solidario
#DEFINE NF_VALSOL		15,04 //Valor do ICMS Solidario
#DEFINE NF_BICMORI	    15,05 //Base do ICMS Original
#DEFINE NF_VALCMP		15,06 //Valor do Icms Complementar
#DEFINE NF_BASEICA	    15,07 //Base do ICMS sobre o Frete Autonomo
#DEFINE NF_VALICA 	    15,08 //Valor do ICMS sobre o Frete Autonomo
#DEFINE NF_IPI  		16    //Array contendo os valores de IPI
#DEFINE NF_BASEIPI	    16,01 //Valor da Base do IPI
#DEFINE NF_VALIPI		16,02 //Valor do IPI
#DEFINE NF_BIPIORI	    16,03 //Valor da Base Original do IPI
#DEFINE NF_TOTAL		17    //Valor Total da NF
#DEFINE NF_VALMERC	    18 	  //Total de Mercadorias
#DEFINE NF_FUNRURAL 	19	  //Valor Total do FunRural
#DEFINE NF_CODCLIFOR	20    //Codigo do Cliente/Fornecedor
#DEFINE NF_LOJA		    21	  //Loja do Cliente/Fornecedor
#DEFINE NF_LIVRO		22    //Array contendo o Demonstrativo Fiscal
#DEFINE NF_ISS			23	  //Array contendo os Valores de ISS
#DEFINE NF_BASEISS		23,01 //Base de Calculo do ISS
#DEFINE NF_VALISS		23,02 //Valor do ISS
#DEFINE NF_IR			24    //Array contendo os valores do Imposto de renda
#DEFINE NF_BASEIRR		24,01 //Base do Imposto de Renda do item
#DEFINE NF_VALIRR		24,02 //Valor do IR do item
#DEFINE NF_INSS		    25    //Array contendo os valores de INSS
#DEFINE NF_BASEINS		25,01 //Base de calculo do INSS
#DEFINE NF_VALINS		25,02 //Valor do INSS do item
#DEFINE NF_NATUREZA	    26	  //Codigo da natureza a ser gravado nos titulos do Financeiro.
#DEFINE NF_VALEMB		27	  //Valor da Embalagem
#DEFINE NF_RESERV1		28	  //Array contendo as Bases de Impostos ( Argentina,Chile,Etc.)
#DEFINE NF_RESERV2 	    29	  //Array contendo os valores de Impostos ( Argentina,Chile,Etc. )
#DEFINE NF_IMPOSTOS	    30	  //Array contendo todos os impostos calculados na funcao Fiscal com quebra por impostos+aliquotas
#DEFINE NF_BASEDUP		31	  //Base de calculo das duplicatas geradas no financeiro
#DEFINE NF_RELIMP		32	  //Array contendo a relacao de impostos que podem ser alterados
#DEFINE NF_IMPOSTOS2 	33	  //Array contendo todos os impostos calculados na funcao Fiscal com quebras por impostos
#DEFINE NF_DESCZF		34	  //Valor Total do desconto da Zona Franca
#DEFINE NF_SUFRAMA		35	  // Indica se o Cliente pertence a SUFRAMA
#DEFINE NF_BASEIMP		36	  //Array contendo as Bases de Impostos Variaveis
#DEFINE NF_BASEIV1		36,01 //Base de Impostos Variaveis 1
#DEFINE NF_BASEIV2		36,02 //Base de Impostos Variaveis 2
#DEFINE NF_BASEIV3		36,03 //Base de Impostos Variaveis 3
#DEFINE NF_BASEIV4		36,04 //Base de Impostos Variaveis 4
#DEFINE NF_BASEIV5		36,05 //Base de Impostos Variaveis 5
#DEFINE NF_BASEIV6		36,06 //Base de Impostos Variaveis 6
#DEFINE NF_BASEIV7		36,07 //Base de Impostos Variaveis 7
#DEFINE NF_BASEIV8		36,08 //Base de Impostos Variaveis 8
#DEFINE NF_BASEIV9		36,09 //Base de Impostos Variaveis 9
#DEFINE NF_VALIMP		37 	  //Array contendo os valores de Impostos Agentina/Chile/Etc.
#DEFINE NF_VALIV1		37,01 //Valor do Imposto Variavel 1
#DEFINE NF_VALIV2		37,02 //Valor do Imposto Variavel 2
#DEFINE NF_VALIV3		37,03 //Valor do Imposto Variavel 3
#DEFINE NF_VALIV4		37,04 //Valor do Imposto Variavel 4
#DEFINE NF_VALIV5		37,05 //Valor do Imposto Variavel 5
#DEFINE NF_VALIV6		37,06 //Valor do Imposto Variavel 6
#DEFINE NF_VALIV7		37,07 //Valor do Imposto Variavel 7
#DEFINE NF_VALIV8		37,08 //Valor do Imposto Variavel 8
#DEFINE NF_VALIV9		37,09 //Valor do Imposto Variavel 96
#DEFINE NF_TPCOMP		38    //Tipo de complemento  - F Frete , D Despesa Imp.
#DEFINE NF_INSIMP		39	  //Flag de Controle : Indica se podera inserir Impostos no Rodape.
#DEFINE NF_PESO  		40	  //Peso Total das mercadorias da NF
#DEFINE NF_ICMFRETE 	41	  //Valor do ICMS relativo ao frete
#DEFINE NF_BSFRETE 		42	  //Base do ICMS relativo ao frete
#DEFINE NF_BASECOF 		43	  //Base de calculo do COFINS
#DEFINE NF_VALCOF  		44	  //Valor do COFINS
#DEFINE NF_BASECSL 		45	  //Base de calculo do CSLL
#DEFINE NF_VALCSL 		46	  //Valor do CSLL
#DEFINE NF_BASEPIS 		47	  //Base de calculo do PIS
#DEFINE NF_VALPIS 		48	  //Valor do PIS
#DEFINE NF_ROTINA 		49	  //Nome da rotina que esta utilizando a funcao
#DEFINE NF_AUXACUM 		50	  //Campo auxiliar para acumulacao no calculo de impostos
#DEFINE NF_ALIQIR      51    //Aliquota de IRF do Cliente
#DEFINE NF_VNAGREG     52	  //Valor da Mercadoria nao agregada.
#DEFINE NF_RECPIS      53    //Recolhe PIS
#DEFINE NF_RECCOFI     54    //Recolhe CONFINS
#DEFINE NF_RECCSLL     55    //Recolhe CSLL
#DEFINE NF_RECISS      56    //Recolhe ISS
#DEFINE NF_RECINSS     57    //Recolhe INSS
#DEFINE NF_MOEDA       58    //Moeda da nota
#DEFINE NF_TXMOEDA     59    //Taxa da moeda
#DEFINE NF_SERIENF     60    //Serie da nota fiscal
#DEFINE NF_TIPODOC     61    //Tipo do documento (localizacoes)
#DEFINE NF_MINIMP 		62    //Minimo para calcular Impostos Variaveis
#DEFINE NF_MINIV1		62,01 //Minimo para calcular Imposto Variavel 1
#DEFINE NF_MINIV2		62,02 //Minimo para calcular Imposto Variavel 2
#DEFINE NF_MINIV3		62,03 //Minimo para calcular Imposto Variavel 3
#DEFINE NF_MINIV4		62,04 //Minimo para calcular Imposto Variavel 4
#DEFINE NF_MINIV5		62,05 //Minimo para calcular Imposto Variavel 5
#DEFINE NF_MINIV6		62,06 //Minimo para calcular Imposto Variavel 6
#DEFINE NF_MINIV7		62,07 //Minimo para calcular Imposto Variavel 7
#DEFINE NF_MINIV8		62,08 //Minimo para calcular Imposto Variavel 8
#DEFINE NF_MINIV9		62,09 //Minimo para calcular Imposto Variavel 9
#DEFINE NF_BASEPS2     63	  //Base de calculo do PIS 2
#DEFINE NF_VALPS2      64	  //Valor do PIS 2
#DEFINE NF_ESPECIE     65	  //Especie do Documento

#DEFINE IT_GRPTRIB  	01    //Grupo de Tributacao
#DEFINE IT_EXCECAO  	02    //Array da EXCECAO Fiscal
#DEFINE IT_ALIQICM		03    //Aliquota de ICMS
#DEFINE IT_ICMS 		04    //Array contendo os valores de ICMS
#DEFINE IT_BASEICM		04,01 //Valor da Base de ICMS
#DEFINE IT_VALICM		04,02 //Valor do ICMS Normal
#DEFINE IT_BASESOL		04,03 //Base do ICMS Solidario
#DEFINE IT_ALIQSOL		04,04 //Aliquota do ICMS Solidario
#DEFINE IT_VALSOL		04,05 //Valor do ICMS Solidario
#DEFINE IT_MARGEM		04,06 //Margem de lucro para calculo da Base do ICMS Sol.
#DEFINE IT_BICMORI		04,07 //Valor original da Base de ICMS
#DEFINE IT_ALIQCMP		04,08 //Aliquota para calculo do ICMS Complementar
#DEFINE IT_VALCMP		04,09 //Valor do ICMS Complementar do item
#DEFINE IT_BASEICA 	    04,10 //Base do ICMS sobre o frete autonomo
#DEFINE IT_VALICA  	    04,11 //Valor do ICMS sobre o frete autonomo
#DEFINE IT_ALIQIPI  	05    //Aliquota de IPI
#DEFINE IT_IPI  		06    //Array contendo os valores de IPI
#DEFINE IT_BASEIPI  	06,01 //Valor da Base do IPI
#DEFINE IT_VALIPI		06,02 //Valor do IPI
#DEFINE IT_BIPIORI		06,03 //Valor da Base Original do IPI
#DEFINE IT_NFORI		07    //Numero da NF Original
#DEFINE IT_SERORI		08    //Serie da NF Original
#DEFINE IT_RECORI		09    //RecNo da NF Original (SD1/SD2)
#DEFINE IT_DESCONTO	    10    //Valor do Desconto
#DEFINE IT_FRETE		11    //Valor do Frete
#DEFINE IT_DESPESA		12    //Valor das Despesas Acessorias
#DEFINE IT_SEGURO		13    //Valor do Seguro
#DEFINE IT_AUTONOMO	14        //Valor do Frete Autonomo
#DEFINE IT_VALMERC		15    //Valor da mercadoria
#DEFINE IT_PRODUTO		16    //Codigo do Produto
#DEFINE IT_TES			17    //Codigo da TES
#DEFINE IT_TOTAL		18    //Valor Total do Item
#DEFINE IT_CF			19    //Codigo Fiscal de Operacao
#DEFINE IT_FUNRURAL	20        //Aliquota para calculo do Funrural
#DEFINE IT_PERFUN		21    //Valor do Funrural do item
#DEFINE IT_DELETED		22    //Flag de controle para itens deletados
#DEFINE IT_LIVRO		23    //Array contendo o Demonstrativo Fiscal do Item
#DEFINE IT_ISS			24    //Array contendo os valores de ISS
#DEFINE IT_ALIQISS		24,01 //Aliquota de ISS do item
#DEFINE IT_BASEISS  	24,02 //Base de Calculo do ISS
#DEFINE IT_VALISS		24,03 //Valor do ISS do item
#DEFINE IT_CODISS		24,04 //Codigo do ISS
#DEFINE IT_CALCISS		24,05 //Flag de controle para calculo do ISS
#DEFINE IT_RATEIOISS	24,06 //Flag de controle para calculo do ISS
#DEFINE IT_IR			25    //Array contendo os valores do Imposto de renda
#DEFINE IT_BASEIRR		25,01 //Base do Imposto de Renda do item
#DEFINE IT_REDIR		25,02 //Percentual de Reducao da Base de calculo do IR
#DEFINE IT_ALIQIRR		25,03 //Aliquota de Calculo do IR do Item
#DEFINE IT_VALIRR		25,04 //Valor do IR do Item
#DEFINE IT_INSS		    26    //Array contendo os valores de INSS
#DEFINE IT_BASEINS		26,01 //Base de calculo do INSS
#DEFINE IT_REDINSS		26,02 //Percentual de Reducao da Base de Calculo do INSS
#DEFINE IT_ALIQINS		26,03 //Aliquota de Calculo do INSS
#DEFINE IT_VALINS		26,04 //Valor do INSS
#DEFINE IT_VALEMB		27	  //Valor da embalagem
#DEFINE IT_BASEIMP		28	  //Array contendo as Bases de Impostos Variaveis
#DEFINE IT_BASEIV1		28,01 //Base de Impostos Variaveis 1
#DEFINE IT_BASEIV2		28,02 //Base de Impostos Variaveis 2
#DEFINE IT_BASEIV3		28,03 //Base de Impostos Variaveis 3
#DEFINE IT_BASEIV4		28,04 //Base de Impostos Variaveis 4
#DEFINE IT_BASEIV5		28,05 //Base de Impostos Variaveis 5
#DEFINE IT_BASEIV6		28,06 //Base de Impostos Variaveis 6
#DEFINE IT_BASEIV7		28,07 //Base de Impostos Variaveis 7
#DEFINE IT_BASEIV8		28,08 //Base de Impostos Variaveis 8
#DEFINE IT_BASEIV9		28,09 //Base de Impostos Variaveis 9
#DEFINE IT_ALIQIMP		29	  //Array contendo as Aliquotas de Impostos Variaveis
#DEFINE IT_ALIQIV1		29,01 //Aliquota de Impostos Variaveis 1
#DEFINE IT_ALIQIV2		29,02 //Aliquota de Impostos Variaveis 2
#DEFINE IT_ALIQIV3		29,03 //Aliquota de Impostos Variaveis 3
#DEFINE IT_ALIQIV4		29,04 //Aliquota de Impostos Variaveis 4
#DEFINE IT_ALIQIV5		29,05 //Aliquota de Impostos Variaveis 5
#DEFINE IT_ALIQIV6		29,06 //Aliquota de Impostos Variaveis 6
#DEFINE IT_ALIQIV7		29,07 //Aliquota de Impostos Variaveis 7
#DEFINE IT_ALIQIV8		29,08 //Aliquota de Impostos Variaveis 8
#DEFINE IT_ALIQIV9		29,09 //Aliquota de Impostos Variaveis 9
#DEFINE IT_VALIMP		30    //Array contendo os valores de Impostos Agentina/Chile/Etc.
#DEFINE IT_VALIV1		30,01 //Valor do Imposto Variavel 1
#DEFINE IT_VALIV2		30,02 //Valor do Imposto Variavel 2
#DEFINE IT_VALIV3		30,03 //Valor do Imposto Variavel 3
#DEFINE IT_VALIV4		30,04 //Valor do Imposto Variavel 4
#DEFINE IT_VALIV5		30,05 //Valor do Imposto Variavel 5
#DEFINE IT_VALIV6		30,06 //Valor do Imposto Variavel 6
#DEFINE IT_VALIV7		30,07 //Valor do Imposto Variavel 7
#DEFINE IT_VALIV8		30,08 //Valor do Imposto Variavel 8
#DEFINE IT_VALIV9		30,09 //Valor do Imposto Variavel 9
#DEFINE IT_BASEDUP		31	  //Base das duplicatas geradas no financeiro
#DEFINE IT_DESCZF		32	  //Valor do desconto da Zona Franca do item
#DEFINE IT_DESCIV		33	  //Array contendo a descricao dos Impostos Variaveis
#DEFINE IT_DESCIV1		33,1  //Array contendo a Descricao dos IV 1
#DEFINE IT_DESCIV2		33,2  //Array contendo a Descricao dos IV 2
#DEFINE IT_DESCIV3		33,3  //Array contendo a Descricao dos IV 3
#DEFINE IT_DESCIV4		33,4  //Array contendo a Descricao dos IV 4
#DEFINE IT_DESCIV5		33,5  //Array contendo a Descricao dos IV 5
#DEFINE IT_DESCIV6		33,6  //Array contendo a Descricao dos IV 6
#DEFINE IT_DESCIV7		33,7  //Array contendo a Descricao dos IV 7
#DEFINE IT_DESCIV8		33,8  //Array contendo a Descricao dos IV 8
#DEFINE IT_DESCIV9		33,9  //Array contendo a Descricao dos IV 9
#DEFINE IT_QUANT		34	  //Quantidade do Item
#DEFINE IT_PRCUNI		35	  //Preco Unitario do Item
#DEFINE IT_VIPIBICM 	36	  //Valor do IPI Incidente na Base de ICMS
#DEFINE IT_PESO     	37	  //Peso da mercadoria do item
#DEFINE IT_ICMFRETE 	38	  //Valor do ICMS Relativo ao Frete
#DEFINE IT_BSFRETE  	39	  //Base do ICMS Relativo ao Frete
#DEFINE IT_BASECOF  	40	  //Base de calculo do COFINS
#DEFINE IT_ALIQCOF  	41	  //Aliquota de calculo do COFINS
#DEFINE IT_VALCOF   	42	  //Valor do COFINS
#DEFINE IT_BASECSL  	43    //Base de calculo do CSLL
#DEFINE IT_ALIQCSL  	44    //Aliquota de calculo do CSLL
#DEFINE IT_VALCSL   	45	  //Valor do CSLL
#DEFINE IT_BASEPIS  	46	  //Base de calculo do PIS
#DEFINE IT_ALIQPIS  	47	  //Aliquota de calculo do PIS
#DEFINE IT_VALPIS   	48	  //Valor do PIS
#DEFINE IT_RECNOSB1 	49	  //RecNo do SB1
#DEFINE IT_RECNOSF4 	50	  //RecNo do SF4
#DEFINE IT_VNAGREG     51	  //Valor da Mercadoria nao agregada.
#DEFINE IT_TIPONF      52    //Tipo da nota fiscal
#DEFINE IT_REMITO      53    //Remito
#DEFINE IT_BASEPS2     54	  //Base de calculo do PIS 2
#DEFINE IT_ALIQPS2     55	  //Aliquota de calculo do PIS 2
#DEFINE IT_VALPS2      56	  //Valor do PIS 2

#DEFINE LF_CFO			01	  // Codigo Fiscal
#DEFINE LF_ALIQICMS 	02	  // Aliquota de ICMS
#DEFINE LF_VALCONT		03	  // Valor Contabil
#DEFINE LF_BASEICM		04	  // Base de ICMS
#DEFINE LF_VALICM		05	  // Valor do ICMS
#DEFINE LF_ISENICM		06	  // ICMS Isento
#DEFINE LF_OUTRICM		07	  // ICMS Outros
#DEFINE LF_BASEIPI		08	  // Base de IPI
#DEFINE LF_VALIPI		09	  // IPI Tributado
#DEFINE LF_ISENIPI		10	  // IPI Isento
#DEFINE LF_OUTRIPI		11	  // IPI Outros
#DEFINE LF_OBSERV		12	  // Observacao
#DEFINE LF_VALOBSE		13 	  // Valor na Observacao
#DEFINE LF_ICMSRET		14	  // Valor ICMS Retido
#DEFINE LF_LANCAM		15	  // Numero do Lancamento
#DEFINE LF_TIPO		    16	  // Tipo de Lancamento
#DEFINE LF_ICMSCOMP 	17 	  // ICMS Complementar
#DEFINE LF_CODISS		18	  // Cod.Serv. ISS
#DEFINE LF_IPIOBS		19	  // IPI na Observacao
#DEFINE LF_NFLIVRO		20	  // Numero do Livro
#DEFINE LF_ICMAUTO		21	  // ICMS Frete Autonomo
#DEFINE LF_BASERET		22	  // Base do ICMS Retido
#DEFINE LF_FORMUL		23	  // Flag de Fom. Proprio
#DEFINE LF_FORMULA		24	  // Formula
#DEFINE LF_DESPESA		25	  // Despesas Acessorias
#DEFINE LF_ICMSDIF		26	  // Icms Diferido
#DEFINE LF_TRFICM	    27	  // Transferencia de Debito e Credito
#DEFINE LF_OBSICM	    28	  // Icms na coluna de observacoes
#DEFINE LF_OBSSOL	    29	  // Solidario na coluna de observacoes
#DEFINE LF_SOLTRIB	    30	  // Valor do ICMS Solidario que possui tributacao com credito de imposto

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle do Tipo de Entrada e Saida                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE TS_CODIGO      01    //Codigo da TES
#DEFINE TS_TIPO        02    //Tipo da TES - S Saida , E Entrada
#DEFINE TS_ICM         03    //Calcula ICMS , S-Sim,N-Nao
#DEFINE TS_IPI         04    //Calcula IPI , S-Sim,N-Nao,R-Comerciante nao Atac.
#DEFINE TS_CREDICM     05    //Credito de ICMS , S-Sim,N-Nao
#DEFINE TS_CREDIPI     06    //Credito de IPI  , S-Sim,N-Nao
#DEFINE TS_DUPLIC      07    //Gera Duplicata , S-Sim,N-Nao
#DEFINE TS_ESTOQUE     08    //Movimenta Estoque , S-Sim,N-Nao
#DEFINE TS_CF          09    //Codigo Fiscal de Operacao
#DEFINE TS_TEXTO       10    //Descricao do TES
#DEFINE TS_BASEICM     11    //Reducao da Base de ICMS
#DEFINE TS_BASEIPI     12    //Reducao da Base de IPI
#DEFINE TS_PODER3      13    //Controla Poder de 3os R-Remessa,D-Devolucao,N-Nao Controla
#DEFINE TS_LFICM       14    //Coluna Livros Fiscais ICM - T-Tributado,I-Isentas,O-Outras,N-Nao,Z-ICMS Zerado
#DEFINE TS_LFIPI       15    //Coluna Livros Fiscais IPI - T-Tributado,I-Isentas,O-Outras,N-Nao,Z-IPI Zerado
#DEFINE TS_DESTACA     16    //Destaca IPI S-Sim,N-Nao
#DEFINE TS_INCIDE      17    //Incide IPI na Base de ICMS , S-Sim,N-Nao
#DEFINE TS_COMPL       18    //Calcula ICMS Complementar , S-Sim,N-NAo
#DEFINE TS_IPIFRET     19    //Calcula IPI sobre Frete S-Sim,N-Nao
#DEFINE TS_ISS         20    //Calcula ISS S-Sim,N-Nao
#DEFINE TS_LFISS       21    //Coluna Livros Fiscais ISS - T=Tributado;I=Isento;O=Outros;N=Nao calcula
#DEFINE TS_NRLIVRO     22    //Numero do Livro
#DEFINE TS_UPRC        23    //Atualiza Ultimo Preco de Compra S-Sim,N-Nao
#DEFINE TS_CONSUMO     24    //Material de Consumo S-Sim,N-Nao
#DEFINE TS_FORMULA     25    //Formula para uso na impressao dos Livros Fiscais
#DEFINE TS_AGREG       26    //Agrega Valor a Mercadoria S-Sim N-Nao
#DEFINE TS_INCSOL      27    //Agrega Valor do ICMS Sol. S-Sim,N-Nao
#DEFINE TS_CIAP        28    //Livro Fiscal CIAP S-Sim,N-Nao
#DEFINE TS_DESPIPI     29    //Calcula IPI sobre Despesas S-Sim,N-Nao
#DEFINE TS_LIVRO       30    //Formula para livro Fiscal
#DEFINE TS_ATUTEC      31    //Atualiza SigaTec S-Sim,N-Nao
#DEFINE TS_ATUATF      32    //Atualiza Ativo Fixo S-Sim,N-Nao
#DEFINE TS_TPIPI       33    //Base do IPI B - Valor Bruto , L - Valor Liquido
#DEFINE TS_SFC         34    //Array contendo os Itens do SFC
#DEFINE TS_LIVRO       35    //Nome do Rdmake de complemento/geracao dos livors Fiscais
#DEFINE TS_STDESC      36    //Define se considera o Desconto no calculo do ICMS Retido.
#DEFINE TS_DESPICM     37    //Define se as Despesas entram na base de Calculo de ICMS
#DEFINE TS_BSICMST     38    //% de Reduco da Base de Calculo do ICMS Solidario
#DEFINE TS_BASEISS     39    //% de Reduco da Base de Calculo do ISS.
#DEFINE TS_IPILICM     40    //O ipi deve ser lancado nas colunas nao tributadas do ICMS
#DEFINE TS_ICMSDIF     41    //ICMS Diferido
#DEFINE TS_QTDZERO     42    //Tes permite digitar quantidade zero.
#DEFINE TS_TRFICM      43    //Tes permite digitar quantidade zero.
#DEFINE TS_OBSICM      44    //Icms na coluna de observacao
#DEFINE TS_OBSSOL      45    //Icms Solidario na coluna de observacao
#DEFINE TS_PICMDIF     46    //Percentual do ICMS Diferido
#DEFINE TS_PISCRED     47    //Credita/Debita PIS/COFIS
#DEFINE TS_PISCOF      48    //Calcula PIS/COFIS
#DEFINE TS_CREDST      49    //Credita Solidario

#DEFINE MAX_TS    	 	49    //Tamanho do array de TES

#DEFINE SFC_SEQ        01    //Sequencia de calculo do Imposto
#DEFINE SFC_IMPOSTO    02    //Codigo do imposto
#DEFINE SFC_INCDUPL    03    //Indica se incide nas Duplicatas
#DEFINE SFC_INCNOTA    04    //Indica se incide no total da NF
#DEFINE SFC_CREDITA    05    //Indica de Credita o Imposto
#DEFINE SFC_INCIMP     06    //Indica se incide na Base de Calculo de Outro imposto
#DEFINE SFC_BASE       07    // %Reducao da base de calculo
#DEFINE SFB_DESCR      08    //Descricao do Imposto
#DEFINE SFB_CPOVREI    09    //Campo do Valor de Entrada Item
#DEFINE SFB_CPOBAEI    10    //Campo da Base de Entrada do Item
#DEFINE SFB_CPOVREC    11    //Campo do Valor de Entrada Cabecalho
#DEFINE SFB_CPOBAEC    12    //Campo da Base de Entrada Cabecalho
#DEFINE SFB_CPOVRSI    13    //Campo do Valor de Saida Item
#DEFINE SFB_CPOBASI    14    //Campo da Base de Saida Item
#DEFINE SFB_CPOVRSC    15    //Campo do Valor de Saida Cabecalho
#DEFINE SFB_CPOBASC    16    //Campo da Base de Saida Cabecalho
#DEFINE SFB_FORMENT    17    //Rotina para calculo do imposto na Entrada
#DEFINE SFB_FORMSAI    18    //Rotina para calculo do imposto na Saida
#DEFINE SFC_CALCULO    19    //Tipo de calculo

#DEFINE IMP_COD		    01    //Codigo do imposto no Array NF_IMPOSTOS
#DEFINE IMP_DESC		02    //Descricao do imposto no Array NF_IMPOSTOS
#DEFINE IMP_BASE		03    //Base de Calculo do Imposto no Array NF_IMPOSTOS
#DEFINE IMP_ALIQ		04    //Aliquota de calculo do imposto
#DEFINE IMP_VAL		    05    //Valor do Imposto no Array NF_IMPOSTOS
#DEFINE IMP_NOME		06    //Nome de referencia aos Impostos do cabecalho

#DEFINE NMAXIV	        09    // Numero maximo de Impostos Variaveis

STATIC aMaster
STATIC aNFCab
STATIC aNFItem
STATIC aItemDec
STATIC bFisRefresh
STATIC bLivroRefresh
STATIC aBrwLF
STATIC aStack
STATIC aRefSX3
STATIC aSaveDec
STATIC aAuxOri
STATIC cAliasPROD

STATIC aTES[MAX_TS]
STATIC aItemRef
STATIC aCabRef
STATIC aResRef
STATIC aLFIS

STATIC MV_ALIQISS
STATIC MV_ESTADO
STATIC MV_ICMPAD
STATIC MV_NORTE
STATIC MV_ESTICM
STATIC MV_IPIBRUT
STATIC MV_SOLBRUT
STATIC MV_DSZFSOL
STATIC MV_BASERET
STATIC MV_GERIMPV
STATIC MV_FRETEST
STATIC MV_CONTSOC
STATIC MV_RATDESP

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaFisIni  ³ Autor ³Eduardo/Edson          ³ Data ³08.12.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa o Calculo das operacoes Fiscais                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Codigo do Cliente / Fornecedor                     ³±±
±±³          ³ ExpC2 : Loja do Cliente / Fornecedor                       ³±±
±±³          ³ ExpC3 : "C" / Cliente , "F" / Fornecedor                   ³±±
±±³          ³ ExpC4 : Tipo da NF ( "N","D","B","C","P","I" )             ³±±
±±³          ³ ExpC5 : Tipo do Cliente / Fornecedor                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MaFisIni2(cCodCliFor,;	// 1-Codigo Cliente/Fornecedor
	cLoja,;		// 2-Loja do Cliente/Fornecedor
	cCliFor,;	// 3-C:Cliente , F:Fornecedor
	cTipoNF,;	// 4-Tipo da NF
	cTpCliFor,;	// 5-Tipo do Cliente/Fornecedor
	aRelImp,;	// 6-Relacao de Impostos que suportados no arquivo
	cTpComp,;	// 7-Tipo de complemento
	lInsere,;	// 8-Permite Incluir Impostos no Rodape .T./.F.
	cAliasP,;	// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	cRotina,;	// 10-Nome da rotina que esta utilizando a funcao
	cTipoDoc)	// 11-Tipo de documento

Local aArea    := GetArea()
Local aAreaSA1 := SA1->(GetArea())
Local aAreaSA2 := SA2->(GetArea())
Local cOperNf  := ""
Local cGrpCliFor:= CriaVar("A1_GRPTRIB")
Local cUfDest  := ""
Local cUfOrig  := ""
Local cNatureza:= ""
Local cRecPIS  := "N"
Local cRecCOFI := "N"
Local cRecCSLL := "N"
Local cRecISS  := "N"
Local cRecINSS := "N"
Local lInclui  := .T.
Local lInscrito:= .F.
Local lSuframa := .F.
Local nAliqIRF := 0
Local cSerie   := ''
Local nMoeda   := 1
Local nTxMoeda := 0

DEFAULT aRelImp := {}
DEFAULT cTpComp := ""
DEFAULT lInsere := .F.
DEFAULT cAliasP := "SB1"
DEFAULT cTipoDoc:= ""

cTpCliFor		 := IIf(cTpCliFor==Nil," ",cTpCliFor)

If MaFisFound("NF")
	lInclui 		:= .F.
	cCodCliFor	:= aNfCab[NF_CODCLIFOR]
	cLoja			:= aNfCab[NF_LOJA]
	cCliFor		:= aNfCab[NF_CLIFOR]
	cTipoNF		:= aNfCab[NF_TIPONF]
	cTpCliFor	:= aNfCab[NF_TPCLIFOR]
	aRelImp		:= aNfCab[NF_RELIMP]
	cNatureza	:= aNfCab[NF_NATUREZA]
	cTpComp		:= aNfCab[NF_TPCOMP]
	lInsere		:= aNfCab[NF_INSIMP]
	cRotina		:= aNfCab[NF_ROTINA]
	nAliqIRF    := aNfCab[NF_ALIQIR]
	cSerie		:= aNfCab[NF_SERIENF]
	cTipoDoc		:= aNfCab[NF_TIPODOC]
	nMoeda 		:= aNfCab[NF_MOEDA]
	nTxMoeda		:= aNfCab[NF_TXMOEDA]
EndIf

If lInclui
	aNFCab	:= {}
	aNFItem	:= {}
	aItemDec:= {}
	MV_ALIQISS := GetMv("MV_ALIQISS")
	MV_ESTADO  := GetMv("MV_ESTADO")
	MV_ICMPAD  := GetMv("MV_ICMPAD")
	MV_NORTE   := GetMv("MV_NORTE")
	MV_ESTICM  := GetMv("MV_ESTICM")
	MV_IPIBRUT := GetMv("MV_IPIBRUT")
	MV_SOLBRUT := GetMv("MV_SOLBRUT")
	MV_DSZFSOL := GetMv("MV_DSZFSOL")
	MV_BASERET := GetMv("MV_BASERET")
	MV_GERIMPV := GetMv("MV_GERIMPV")
	MV_FRETEST := GetMv("MV_FRETEST")
	MV_CONTSOC := GetMv("MV_CONTSOC")
	MV_RATDESP := GetMv("MV_RATDESP")
	cAliasPROD := cAliasP
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os registros necessarios                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cCliFor == "C" )
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+cCodCliFor+cLoja)
	cOperNf   := IIf(cTipoNf$"DB","E","S")
	lInscrito := IIf(Empty(SA1->A1_INSCR).Or."ISENT"$SA1->A1_INSCR,.T.,.F.)
	lSuframa  := !Empty(SA1->A1_SUFRAMA).And.SA1->A1_CALCSUF<>'N'
	cGrpCliFor:= SA1->A1_GRPTRIB
	cUfDest   := IIf(cTipoNf$"DB",MV_ESTADO,SA1->A1_EST)
	cUfOrig   := IIf(cTipoNf$"DB",SA1->A1_EST,MV_ESTADO)

	If lInclui
		cNatureza := SA1->A1_NATUREZ
		cTpCliFor := IIf(Empty(cTpCliFor),SA1->A1_TIPO,cTpCliFor)
	Else
		cTpCliFor := SA1->A1_TIPO
	EndIf
	nAliqIRF    := SA1->A1_ALIQIR
	cRecPIS  := SA1->A1_RECPIS
	cRecCOFI := SA1->A1_RECCOFI
	cRecCSLL := SA1->A1_RECCSLL
	cRecISS  := SA1->A1_RECISS
	cRecINSS := SA1->A1_RECINSS
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+cCodCliFor+cLoja)
	cOperNf   := IIf(cTipoNf$"DB","S","E")
	cGrpCliFor:= SA2->A2_GRPTRIB
	lInscrito := IIf(Empty(SM0->M0_INSC).Or."ISENT"$SM0->M0_INSC,.T.,.F.)
	cUfDest   := IIf(cTipoNf$"DB",SA2->A2_EST,MV_ESTADO)
	cUfOrig   := IIf(cTipoNf$"DB",MV_ESTADO,SA2->A2_EST)

	If lInclui
		cNatureza := &(GetMV("MV_2DUPNAT"))
		If Empty( cTpCliFor )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Converte os tipos do fornecedor para os tipos validos       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTpCliFor := MaFisTpCon( SA2->A2_TIPO )
		EndIf
	Else
		cTpCliFor := MaFisTpCon( SA2->A2_TIPO )
	EndIf
	cRecISS  := SA2->A2_RECISS
	cRecINSS := SA2->A2_RECINSS
EndIf

If lInclui
	aNfCab := {	cTipoNF,;		//1
		cOperNF,;		//2
		cCliFor,;		//3
		cTpCliFor,;		//4
		lInscrito,;		//5
		cGrpCliFor,;	//6
		cUFdest,;       //7
		cUfOrig,;		//8
		0,;				//9
		0,;				//10
		0,;				//11
		0,;				//12
		0,;				//13
		0,;				//14
		{0,0,0,0,0,0,0,0,0},;	//15
		{0,0,0},;		//16
		0,;				//17
		0,;				//18
		0,;				//19
		cCodCliFor,;	//20
		cLoja,;			//21
		{},;			//22
		{0,0},;		    //23
		{0,0},;		    //24
		{0,0},;		    //25
		cNatureza,;		//26
		0,;				//27
		{},;			//28
		{},;			//29
		{{'...','  ',0,0,0,'NEW'}},;	//30
		0,;				//31
		aRelImp,;		//32
		{{'...','  ',0,0,'NEW'}},;//33
		0,;				//34
		lSuframa,;		//35
		{0,0,0,0,0,0,0,0,0},;//36
		{0,0,0,0,0,0,0,0,0},;//37
		cTpComp,;		//38
		lInsere,;		//39
		0,;				//40
		0,;				//41
		0,;				//42
		0,;				//43
		0,;				//44
		0,;				//45
		0,;				//46
		0,;				//47
		0,;				//48
		cRotina,;       //49
		0,;				//50
		nAliqIRF,;		//51
		0,;   			//52
		cRecPIS,;		//53
		cRecCOFI,;		//54
		cRecCSLL,;		//55
		cRecISS,;		//56
		cRecINSS,;		//57
		nMoeda,;		//58
		nTxMoeda,;		//59
		cSerie,;		//60
		cTipoDoc,;		//61
		{0,0,0,0,0,0,0,0,0},;		//62
		0,;				//63
		0,;				//64
		""}             //65		
Else
	aNfCab	:= {	cTipoNF,;		//1
		cOperNF,;		//2
		cCliFor,;		//3
		cTpCliFor,;		//4
		lInscrito,;		//5
		cGrpCliFor,;	//6
		cUFdest,;	    //7
		cUfOrig,;		//8
		0,;				//9
		0,;				//10
		0,;				//11
		0,;				//12
		0,;				//13
		0,;				//14
		{0,0,0,0,0,0,0,0,0},;		//15
		{0,0,0},;		//16
		0,;	 			//17
		0,;				//18
		0,;				//19
		cCodCliFor,;	//20
		cLoja,;			//21
		{},;			//22
		{0,0},;			//23
		{0,0},;			//24
		{0,0},;	  		//25
		cNatureza,;		//26
		0,;				//27
		{},;			//28
		{},;			//29
		{{"","",0,0,0,""}},;	//30
		0,;				//31
		aRelImp,;		//32
		{{"","",0,0,""}},;	 //33
		0,;				//34
		lSuframa,;		//35
		{0,0,0,0,0,0,0,0,0},;	 //36
		{0,0,0,0,0,0,0,0,0},;	 //37
		cTpComp,;		//38
		lInsere,;		//39
		0,;				//40
		0,;				//41
		0,;				//42
		0,;				//43
		0,;				//44
		0,;				//45
		0,;				//46
		0,;				//47
		0,;				//48
		cRotina,;       //49
		0,;				//50
		nAliqIRF,;    	//51
		0,;   			//52
		cRecPIS,;		//53
		cRecCOFI,;		//54
		cRecCSLL,;		//55
		cRecISS,;		//56
		cRecINSS,;		//57
		nMoeda,;		//58
		nTxMoeda,;		//59
		cSerie,;		//60
		cTipoDoc,;		//61
		{0,0,0,0,0,0,0,0,0},;		//62
		0,;				//63
		0,;				//64
		""}             //65
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o array de Referencias                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aItemRef == Nil
	MaIniRef()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o array de arredondamentos do item                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aSaveDec == Nil
	aSaveDec := Array(Len(aItemRef))
	aFill(aSaveDec,0)
EndIf
If aAuxOri == Nil
	aAuxOri := {}
EndIf

RestArea(aAreaSA1)
RestArea(aAreaSA2)
RestArea(aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaFisAdd  ³ Autor ³ Edson Maricate        ³ Data ³09.12.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inicializa o Calculo das operacoes Fiscais por item         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array contendo o calculo de impostos do item                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MaFisAdd2(cProduto,;   	// 1-Codigo do Produto ( Obrigatorio )
	cTes,;	   	// 2-Codigo do TES ( Opcional )
	nQtd,;	   	// 3-Quantidade ( Obrigatorio )
	nPrcUnit,;   	// 4-Preco Unitario ( Obrigatorio )
	nDesconto,;  	// 5-Valor do Desconto ( Opcional )
	cNFOri,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
	cSEROri,;		// 7-Serie da NF Original ( Devolucao/Benef )
	nRecOri,;		// 8-RecNo da NF Original no arq SD1/SD2
	nFrete,;		// 9-Valor do Frete do Item ( Opcional )
	nDespesa,;	// 10-Valor da Despesa do item ( Opcional )
	nSeguro,;		// 11-Valor do Seguro do item ( Opcional )
	nFretAut,;	// 12-Valor do Frete Autonomo ( Opcional )
	nValMerc,;	// 13-Valor da Mercadoria ( Obrigatorio )
	nValEmb,;		// 14-Valor da Embalagem ( Opiconal )
	nRecSB1,;		// 15-RecNo do SB1
	nRecSF4)		// 16-RecNo do SF4

Local aArea    := GetArea()
Local nItem

DEFAULT nRecSB1 := 0
DEFAULT nRecSF4 := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona os registros necessarios                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasPROD)
If nRecSB1 <> 0 .And. cAliasPROD=="SB1"
	MsGoto(nRecSB1)
Else
	dbSetOrder(1)
	MsSeek(xFilial(cAliasPROD)+cProduto)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a TES utilizada no calculo de impostos      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisTes(@cTes,nRecSF4)

aadd(aNfItem,{MaSBCampo("GRTRIB"),;			//1 - Grupo de Tributacao
	{},;										//2 - Array contendo as excessoes Fiscais
	0,;											//3 - Aliquota de ICMS
	{0,0,0,0,0,0,0,0,0,0,0},;					//4 - Valores de ICMS
	0,;											//5 - Aliquota de IPI
	{0,0,0},;									//6 - Valores de IPI
	cNFOri,;          							//7 - Numero da NF Original
	cSEROri,;									//8 - Serie da NF Original
	nRecOri,;									//9 - RecNo da NF original
	nDesconto,;									//10 - Valor do desconto do item
	nFrete,;									//11 - Valor do Frete
	nDespesa,;									//12 - Valor da despesa
	nSeguro,;									//13 - Valor do seguro
	nFretAut,;									//14 - Valor do frete autonomo
	nValMerc,; 									//15 - Valor da Mercadoria
	cProduto ,;									//16 - Codigo do produto
	cTes	,;									//17 - Codigo da TES
	0 ,;										//18 - Valor Total do item
	"",;										//19 - Codigo FIscal de Operacao
	0 ,;										//20 - Valor do Funrural
	0 ,;                     					//21 - Aliquota para calculo do FunRural
	.F.,;										//22 - Flag de controle para itens deletados
	MaFisRetLF() ,;	         					//23 - Array Contendo o demonstrativo fiscal
	{0,0,0,"","",""},;		             		//24 - Array contendo os valores de ISS
	{0,0,0,0},;							     	//25 - Array contendo os valores de IR
	{0,0,0,0},;								    //26 - Array contendo os valores de INSS
	0,; 										//27 - Valor da Embalagem
	{0,0,0,0,0,0,0,0,0},;						//28
	{0,0,0,0,0,0,0,0,0},;						//29
	{0,0,0,0,0,0,0,0,0},;						//30
	0,;											//31
	0,;											//32
	{{"","",""},{"","",""},{"","",""},{"","",""},;
	{"","",""},{"","",""},{"","",""},{"","",""},;
	{"","",""}},;									//33
	nQtd ,;										//34
	nPrcUnit,;									//35
	0,;											//36
	0,;											//37
	0,;											//38
	0,;											//39
	0,;											//40
	0,;											//41
	0,;											//42
	0,;			  			  					//43
	0,;			  								//44
	0,;			  								//45
	0,;											//46
	0,;											//47
	0,;											//48
	nRecSB1,;									//49
	nRecSF4,;									//50
	0,; 											//51
	aNfCab[NF_TIPONF],;						//52
	"",;											//53
	0,;											//54
	0,;											//55
	0 })											//56

aadd(aItemDec,{Nil,Nil})
aItemDec[Len(aItemDec)][1] := Array(Len(aItemRef))
aItemDec[Len(aItemDec)][2] := Array(Len(aItemRef))
aFill(aItemDec[Len(aItemDec)][1],0)
aFill(aItemDec[Len(aItemDec)][2],0)

nItem 	:= Len(aNfItem)
MaFisRecal("",nItem)
MaIt2Cab()

RestArea(aArea)
Return(nItem)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MaFisRet ³ Autor ³ Edson Maricate        ³ Data ³08.12.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os impostos calculados pela MATXFIS.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN1: Valor do imposto.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MaFisRet2(nItem,cCampo)
Local nRetorno
Local cPosCpo := MaFisScan(cCampo)

Do Case
Case Substr(cCampo,1,2) == "IT"
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfItem[nItem][cPosCpo[1]][cPosCpo[2]]
	Else
		nRetorno:=aNfItem[nItem][Val(cPosCpo)]
	EndIf
Case Substr(cCampo,1,2) == "LF"
	If nItem == Nil
		nRetorno:=aNfItem[nItem][NF_LIVRO][cPosCpo]
	Else
		nRetorno:=aNfItem[nItem][IT_LIVRO][cPosCpo]
	EndIf
OtherWise
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfCab[cPosCpo[1]][cPosCpo[2]]
	Else
		nRetorno:=aNfCab[Val(cPosCpo)]
	EndIf
EndCase

Return nRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MaFisEnd ³ Autor ³ Edson Maricate        ³ Data ³10.01.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Finaliza o uso das funcoes Fiscais.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1: Indica se deve reinicializar o codeblock da funcao  ³±±
±±³          ³        MaFisRodape ( bFisRefresh )                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MaFisEnd2(lRodape)

DEFAULT lRodape := .T.
aNfCab	:= Nil
aNfItem	:= Nil
aItemDec:= Nil
aSaveDec:= Nil
aAuxOri	:= Nil
aTes    := Array(MAX_TS)
bLivroRefresh := Nil
If lRodape
	bFisRefresh := Nil
EndIf
Return .T.



