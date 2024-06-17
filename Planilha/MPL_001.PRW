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
±±ºPrograma  ³ MPL_001  ºAutor  ³ Anderson           º Data ³  01/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Tela de consulta dos dados gerados no recalculo da Planilha,º±±
±±º          ³referente a SIMIL + EIS aglutinados. Nesta tela existem di- º±±
±±º          ³versos filtros para apresentacao do browser. Nela NAO eh    º±±
±±º          ³possivel efetuar quaisquer alteracoes, a mesma apenas permi-º±±
±±º          ³te que atraves da tecla F4 o usuario abra uma outra janela  º±±
±±º          ³contendo as SKUs pertencentes ao SIMIl + EIS posicionaod e  º±±
±±º          ³entao efetue, nesta nova tela. a manutencao direto no item  º±±
±±º          ³desejado.                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPL_001()
Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Local bSetKey4

Private _cDtProc   := CriaVar("Z7_DATA")
Private _cHrProc   := CriaVar("Z7_HORA")
Private _cUsProc   := CriaVar("Z7_USUARIO")
Private _n_SELECT := 0
Private _n_Simil  := 0
Private _n_EIS    := 0    // Eis
Private _n_PTAUT  := 0    // PPA
Private _n_PTMAN  := 0    // PPM
Private _n_LTAUT  := 0    // Lote Automatico
Private _n_LTMAN  := 0    // Lote Manual
Private _n_LTAUT  := 0
Private _n_Comprar:= 0
Private _n_CONSMED:= 0
Private _n_SLDMALH:= 0    // Saldo da Malha
Private _n_PEDCOMP:= 0    // Saldo Item de Compra
Private _n_NAOCOMP:= 0    // Saldo Item nao Compra
Private _n_SLDTRAN:= 0    // Malha - Saldo em Transito
Private _n_SLDEMPE:= 0    // Malha - Saldo Empenhado
Private _n_DISPONI:= 0    // Malha - Saldo Disponivel
Private _n_LT_DIAS:= 0    // Lead Time  (Dias)
Private _n_QTDAPAN:= 0    // Qtde de Apanhe (Ano)
Private _n_TMEA   := 0    // TMEA (Dias)
Private _n_TAMLOTE:= 0
Private _n_CONSMED:= 0    // Consumo Periodo
Private _n_DESVPAD:= 0    // Desvio Padrao
Private _n_CN_MALH:= 0    // Cob. Inst. da Malha C/NC (Dias)
Private _n_CN_DISP:= 0    // Cob. Inst. Disp.C/NC(Dias)
Private _n_CB_MALH:= 0    // Cob. Inst. da Malha IT.CMP.(Dias)
Private _n_CB_DISP:= 0    // Cob. Inst. Disp. IT.CMP.(Dias)

Private _n_AUXILIA:= 0    // Auxiliar
Private _n_ESTSEG := 0    // Estq.Seguranca (Dias)
Private _n_DESC001:= 0
Private _n_DESC002:= 0
Private _n_DESC003:= 0
Private _n_SLRESER:= 0   // Malha - Saldo Reservado
Private _n_SLFATUR:= 0   // Malha - Saldo a Faturar
Private _n_GIRO   := 0   // Giro Ano

Private nQtdeSku   := 0    // Aqui teremos as quantidade de SKUs referente aos filtros colocados, por enquanto CHUMBADO para apresentacao, depois NO CLIENTE, usaremos uma query no SZ8 (conforme os parametros informados nesta tela) para entao obter o VALOR CORRETO

Private cCadastro := "Consulta Planilha Simil EIS"
Private cSimil    := CriaVar("B1_X_SIMIL")
Private cCombo1   := ""
Private cCombo2   := ""
Private cCombo3   := ""
Private cCombo4   := ""
Private cCombo5   := ""

Private aItems1   := {}
Private aItems2   := {}
Private aItems3   := {}
Private aItems4   := {}
Private aItems5   := {}
Private aSKU      := {}
Private aRotina   := {{"Visualizar"      ,"AxVisual", 0 , 2} }
Private aHeader   := {}
Private aCols     := {}

Private oEisCod1,oEisCod2,oEisCod3,oEisCod4,oEisCod5,oEisCod6,oEisCod7,oEisCod8,oEisCod9,oEisCod0
Private oDtProc,oHrProc,oUsProc,oQtSku,oGet
Private oDlgCons,oSimil,oCombo1,oCombo2,oCombo3,oCombo4,oCombo5



Private cEisCod1   := SPACE(2)
Private cEisCod2   := SPACE(2)
Private cEisCod3   := SPACE(2)
Private cEisCod4   := SPACE(2)
Private cEisCod5   := SPACE(2)
Private cEisCod6   := SPACE(2)
Private cEisCod7   := SPACE(2)
Private cEisCod8   := SPACE(2)
Private cEisCod9   := SPACE(2)
Private cEisCod0   := SPACE(2)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta combo para aItems1(Demanda)                          ³
//|{"Todos",NEOIL"}                                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aItems1,"Todos")
DbSelectArea("SZN")
DbGotop()
while !SZN->(EOF())
	aadd(aItems1,SZN->ZN_TIPO +" - "+SZN->ZN_DESCR)
	SZN->(DBSKIP())
Enddo
cCombo1 := aItems1[1]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta combo para aItems2(ABC)                              ³
//|{"Todos","Class. A","Class. B","Class. C"}                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aItems2,"Todos")
DbSelectArea("SZR")
DbGotop()
while !SZR->(EOF())
	aadd(aItems2,SZR->ZR_CODIGO +" - "+SZR->ZR_DESCR)
	SZR->(DBSKIP())
Enddo
cCombo2 := aItems2[1]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta combo para aItems3 Lote                              ³
//|{"Todos","Maior que Zero","Menor que Zero","Igual a Zero"} |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aItems3,"Todos         ")
aadd(aItems3,"Maior que Zero")       // Neste caso apenas analiso o
aadd(aItems3,"Menor que Zero")       // campo Lote automatico  ???
aadd(aItems3,"Igual a Zero  ")
cCombo3 := aItems3[1]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta combo para aItems4 Lista de Comprados                ³
//|{"Todos","Comprados","Nao Comprados"}                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aItems4,"Todos         ")
aadd(aItems4,"Comprados-    ")      // Neste caso apenas ???
aadd(aItems4,"Nao Comprados ")
cCombo4 := aItems4[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta combo para aItems5(Giro)                             ³
//|{"Todos","Class. L","Class. M","Class. H"}                 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aItems5,"Todos")
DbSelectArea("SZ1")
DbGotop()
while !SZ1->(EOF())
	aadd(aItems5,SZ1->Z1_CODIGO +" - "+SZ1->Z1_DESC)
	SZ1->(DBSKIP())
Enddo
cCombo5 := aItems5[1]



DbSelectArea("SZ7")
DbGotop()
If !Eof()
	_cDtProc := SZ7->Z7_DATA
	_cHrProc := SZ7->Z7_HORA
	_cUsProc := SZ7->Z7_USUARIO
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aHeader             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSeek("SZ7")

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("Z7_SELEC")   // Sel
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SIMIL")    // SIMIL
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_EIS")      // Eis
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_PTAUT")    // PPA
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_PTMAN")    // PPM
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_LTAUT")    // Lote Automatico
Aadd(aHeader,{ "Lote Automatico" , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_LTMAN")    // Lote Manual
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_COMPRAR")  // Quantidade a ser comprada
Aadd(aHeader,{ "Pedido de Compra" , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_CONSPER")  // Consumo no Periodo
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SLDMALH")  // Saldo da Malha
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_PEDCOMP")  // Saldo Item de Compra
Aadd(aHeader,{ "Sld IT Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_NAOCOMP")  // Saldo Item nao Compra
Aadd(aHeader,{ "Sld IT N Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_DISPONI")  // Malha - Disponivel
Aadd(aHeader,{ "Qtde Disponivel", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SLDTRAN")  // Malha - Transito
Aadd(aHeader,{ "Qtde Transito", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SLDEMPE")  // Malha - Empenhado
Aadd(aHeader,{ "Qtde Empenhada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SLFATUR")  // Malha - a Faturar
Aadd(aHeader,{ "Qtde a Faturar", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_SLRESER")  // Malha - Reservado
Aadd(aHeader,{ "Qtde Reservada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_LT_DIAS")  // Lead Time  (Dias)
Aadd(aHeader,{ "Lead Time (Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_QTDAPAN")  // Qtde de Apanhe (Ano)
Aadd(aHeader,{ "Qtd Apanhe (Ano)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_GIROANO")  // Qtde de Giro (Ano)
Aadd(aHeader,{ "Qtde Giro (Ano)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_TMEA")  // TMEA (Dias)
Aadd(aHeader,{ "TMEA (Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_TAMLOTE")   // Tamanho do Lote
Aadd(aHeader,{ "Tamanho Lote Apanhe", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_CONSMED")  // Consumo Medio (Mes)
Aadd(aHeader,{ "Consumo Medio (Mes)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_DESVPAD")  // Desvio Padrao
Aadd(aHeader,{ "Desvio Padrao", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_CN_MALH")   // Cob. Inst. da Malha C/NC (Dias)
Aadd(aHeader,{ "Cob. Inst. da Malha C/NC (Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_CN_DISP")   // Cob. Inst. Disp.C/NC(Dias)
Aadd(aHeader,{ "Cob. Inst. Disp.C/NC(Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_CB_MALH")   // Cob. Inst. da Malha IT.CMP.(Dias)
Aadd(aHeader,{ "Cob. Inst. da Malha IT.CMP.(Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_CB_DISP")   // Cob. Inst. Disp. IT.CMP.(Dias)
Aadd(aHeader,{ "Cob. Inst. Disp. IT.CMP.(Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z7_AUXILIA")   // Auxiliar
Aadd(aHeader,{ "Auxiliar", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_ESTSEG")   // Estq.Seguranca (Dias)
Aadd(aHeader,{ "Estq. Seguranca (Dias)", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_DESCR1")   // Dimensiomamento do Estoque
Aadd(aHeader,{ "Dimensionameto do Estoque", x3_campo , x3_picture,X3_TAMANHO,X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_DESCR2")   // Sistema de Tratamento
Aadd(aHeader,{ "Sistema de Tratamento", x3_campo , x3_picture,X3_TAMANHO,X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z7_DESCR3")   // Sistema de Tratamento
Aadd(aHeader,{ "Descricao", x3_campo , x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega posicoes  dos itens no Cabecalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_n_SELECT := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SELEC" })
_n_Simil  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SIMIL"  })  // Eis
_n_EIS    := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_EIS"    })  // Eis
_n_PTAUT  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_PTAUT"  })  // PPA
_n_PTMAN  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_PTMAN"  })  // PPM
_n_LTAUT  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_LTAUT"  })  // Lote Automatico
_n_LTMAN  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_LTMAN"  })  // Lote Manual
_n_LTAUT  := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_LTAUT"  })  // Lote Automatico
_n_Comprar:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_COMPRAR"})  // Qtde a ser comprada = Lote Automatico (Unico Alteravel)
_n_CONSPER:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CONSPER"})  // Consumo no Periodo
_n_SLDMALH:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SLDMALH"})  // Saldo da Malha
_n_PEDCOMP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_PEDCOMP"})  // Saldo Item de Compra
_n_NAOCOMP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_NAOCOMP"})  // Saldo Item nao Compra
_n_SLDTRAN:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SLDTRAN"})  // Malha - Saldo em Transito
_n_SLDEMPE:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SLDEMPE"})  // Malha - Saldo Empenhado
_n_DISPONI:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_DISPONI"})  // Malha - Saldo Disponivel
_n_SLRESER:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SLRESER"})  // Malha - Saldo Reservado
_n_SLFATUR:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_SLFATUR"})  // Malha - Saldo a Faturar
_n_LT_DIAS:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_LT_DIAS"})  // Lead Time  (Dias)
_n_QTDAPAN:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_QTDAPAN"})  // Qtde de Apanhe (Ano)
_n_GIRO   := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_GIROANO"   })  // Giro (Ano)
_n_TMEA   := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_TMEA"   })  // TMEA (Dias)
_n_TAMLOTE:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_TAMLOTE"})  // Tamanho do Lote
_n_CONSMED:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CONSMED"})  // Consumo Medio (Mes)
_n_DESVPAD:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_DESVPAD"})  // Desvio Padrao

_n_CN_MALH:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CN_MALH"})
_n_CN_DISP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CN_DISP"})   // Cob. Inst. Disp.C/NC(Dias)
_n_CB_MALH:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CB_MALH"})   // Cob. Inst. da Malha IT.CMP.(Dias)
_n_CB_DISP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_CB_DISP"})   // Cob. Inst. Disp. IT.CMP.(Dias)

_n_AUXILIA:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_AUXILIA"})   // Auxiliar
_n_ESTSEG := aScan(aHeader,{|x| AllTrim(x[2])=="Z7_ESTSEG" })   // Estq.Seguranca (Dias)
_n_DESC001:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_DESCR1" })
_n_DESC002:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_DESCR2" })
_n_DESC003:= aScan(aHeader,{|x| AllTrim(x[2])=="Z7_DESCR3" })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Janela de Consulta          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Esta rotina e realizada conforme os filtros.


AAdd( aObjects, { 0,     70  , .T., .F. } )
AAdd( aObjects, { 90,    160, .T. , .T. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas
AAdd( aObjects, { 0,     020, .T. , .F. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas

// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{195,250}})


//DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM 106,65 TO 552-20,835  OF oMainWnd pixel
DEFINE MSDIALOG oDlgCons TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd pixel
bSetKey4 :=SetKey(VK_F4 ,{|| Tela_SZ8()}) // Ativando F4

@ 015,aPosObj[2,2] TO 065,aPosObj[2,4] OF oDlgCons PIXEL


@ 020,010   SAY "Similaridade:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 020,090   SAY "Codigo EIS:"				size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 035,010   SAY "ABC:"						size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,115   SAY "Lote Automatico:"		size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 035,220   SAY "Lista de Compras:"		size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 050,010   SAY "Giro:"	              	size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,115   SAY "Demanda:"	    			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ 050,220   SAY "Processado em:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5

@ 020,045   MSGET oSimil	 VAR  cSimil		Picture "@!"  F3 "SZ2"        Size 30,8 OF oDlgCons PIXEL Valid .t.


@ 020,120   MSGET oEisCod1  VAR  cEisCod1     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,134	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("1",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,145   MSGET oEisCod2  VAR  cEisCod2     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,159	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("2",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,170   MSGET oEisCod3  VAR  cEisCod3     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,184	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("3",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,195   MSGET oEisCod4  VAR  cEisCod4     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,209	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("4",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,220   MSGET oEisCod5  VAR  cEisCod5     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,234	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("5",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,245   MSGET oEisCod6  VAR  cEisCod6     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,259	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("6",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,270   MSGET oEisCod7  VAR  cEisCod7     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,284	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("7",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,295   MSGET oEisCod8  VAR  cEisCod8     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,309	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("8",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,320   MSGET oEisCod9  VAR  cEisCod9     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,334	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("9",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())
@ 020,345   MSGET oEisCod0  VAR  cEisCod0     	Picture "@!"	Size 15,7 OF oDlgCons PIXEL Valid .t. When .F.
@ 019,359	BUTTON "..."		SIZE 007,012 OF oDlgCons PIXEL ACTION  ( U_MPL_001A("10",cEisCod1,cEisCod2,cEisCod3,cEisCod4,cEisCod5,cEisCod6,cEisCod7,cEisCod8,cEisCod9,cEisCod0),oGet:Refresh())

@ 035,050 MSCOMBOBOX oCombo2 VAR cCombo2 ITEMS aItems2 SIZE 50,50 OF oDlgCons PIXEL Valid .t. // Abc
@ 035,160 MSCOMBOBOX oCombo3 VAR cCombo3 ITEMS aItems3 SIZE 50,50 OF oDlgCons PIXEL Valid .t. // Lote Automatico
@ 035,290 MSCOMBOBOX oCombo4 VAR cCombo4 ITEMS aItems4 SIZE 50,50 OF oDlgCons PIXEL Valid .t. // Lista de Compras

@ 050,050 MSCOMBOBOX oCombo5 VAR cCombo5 ITEMS aItems5 SIZE 50,50 OF oDlgCons PIXEL Valid .t. // Giro
@ 050,160 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS aItems1 SIZE 50,50 OF oDlgCons PIXEL Valid .t. // Demanda

@ 050,265   MSGET oDtProc  VAR  _cDtProc     	Picture "@!"  Size 40,7 OF oDlgCons PIXEL When .F. Valid .t.
@ 050,310   MSGET oHrProc  VAR  _cHrProc     	Picture "@!"  Size 15,7 OF oDlgCons PIXEL When .F. Valid .t.
@ 050,345   MSGET oUsProc  VAR  _cUsProc     	Picture "@!"  Size 60,7 OF oDlgCons PIXEL When .F. Valid .t.

//oGet:=MSGetDados():New(070,005,195,380,1,"","",,.T.,{},1)
oGet:=MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],1,"","",,.T.,{},1)

@ aPosObj[3,1], 010 BUTTON "&Renovar"		SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Processa({||MontAcols(),"Aguarde...Levantamento Informacoes com base nos Filtros..."}))
@ aPosObj[3,1], 060 BUTTON "&Sair"	 		SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( oDlgCons:End() )
@ aPosObj[3,1], 110 BUTTON "&Quotas"			SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Tela_Quota() )
@ aPosObj[3,1], 160 BUTTON "&Gera SC"    	SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( GeraSol() )
@ aPosObj[3,1], 210 BUTTON "Gera &Arquivo"	SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( GTxtExcel() )
@ aPosObj[3,1], 260 BUTTON "&Limpa Filtro"	SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( LimpFil() )
@ aPosObj[3,1], 310 BUTTON "C&onsumo"	    SIZE 40, 15 OF oDlgCons PIXEL ACTION  ( Tela_EIS())


//@ 199, 110 BUTTON "&Ajuda"			SIZE 50, 15 OF oDlgCons PIXEL ACTION  ( PlayWave("BJ.WAV") )
// Nao tem a descricao do campo na dela modelo.
///@ 199,300   SAY "Qtde Popularidade:"			size 100,8 OF oDlgCons PIXEL //FONT oFntFecha5
@ aPosObj[3,1],400  MSGET oQtSku  VAR  nQtdeSku     	Picture "@ 999,999"  Size 30,7 OF oDlgCons PIXEL When .F. Valid .t.

ACTIVATE MSDIALOG oDlgCons ON INIT RfatBar(oDlgCons,{|| oDlgCons:End()},{||oDlgCons:End()}) CENTERED
//SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior da Tecla
SetKey(VK_F4 ,nil )       // Desabilita a Tecla

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tela_EIS ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre Tela com o consumo/mes por Simil + Eis                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela_EIS()

Local lRet := .T.

If Len(acols) = 0
	Aviso("ATENCAO", "Nao existem itens selecionados para consultar o Consumo , verifique !",{"&Ok"})
	lRet:=.f.
Endif

if lRet
	oGet:oBrowse:lDisablePaint := .T.
	
	U_MPL_C_EIS(acols[n][_n_SIMIL],acols[n][_n_EIS])
	
	oGet:oBrowse:lDisablePaint := .F.
	
	oGet:oBrowse:SetFocus() // Reativa o colorido sobre a celula em que me encontrava
	
Endif

RETURN(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraSol   º Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Gera a Solicitacao de Compras com base no SZ8               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSol()

Local aArea   := GetArea()
Local aCab    := {}
Local aItem   := {}
Local nItem   := 0
Local nPCompra:= GetSxeNum("SC1","C1_NUM")
Local lRet    := .T.
LOCAL nQuest  := 0
Local nY      := 0

Local cURequis   := "001"
Local cComprador := GetMv("MV_CODCOMP",,"021")

Private lMsErroAuto := .F.



nQuest:=Aviso("ATENCAO", "Deseja gerar solicitacoes de acordo com o filtro acima...",{"&SIM","&NAO"})
if nQuest = 2
   Return(.F.)
Endif


//
// Posiciona na UnidReq
//

SY3->(DbSelectArea("SY3"),DbSetorder(1),DbSeek(xFilial("SY3")+cURequis))

//
// Posicona no Comprador
//
SY1->(DbSelectArea("SY1"),DbSetorder(1),DbSeek(xFilial("SY1")+cComprador))





For nY := 1 to len(Acols)
	
	DbSelectArea("SZ8")
	DbSetorder(1)
	If DbSeek(xFilial("SZ8")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
		
		
		If !EmptY("SZ8->Z8_NUMSC")
			DbSelectArea("SC1")
			DbSetOrder(1)
			If Dbseek(xFilial("SC1")+SZ8->Z8_NUMSC)
				nQuest:=Aviso("ATENCAO", "Solicitacao de Compras N. "+SZ8->Z8_NUMSC+;
				" foi gerada no dia "+DTOC(SC1->C1_EMISSAO)+" para o simil-Eis : "+;
				aCols[nY][_n_Simil]-aCols[nY][_n_EIS]+". "+chr(13)+;
				"Deseja gerar nova solicitacao...",{"&SIM","&NAO"})
				if nQuest = 2
					Return(.F.)
				Endif
			Endif
		Endif
		
	Else
		
		Aviso("ATENCAO", "Nao foram encontradas sku para este simil no SZ8 ocorreu algum problema durante a geracao da planilha", "verifique !",{"&Ok"})
		
		Return(.F.)
		
	Endif
	
	//__cUserId  Variável Publica com o ID do Usuário Logado
	cNome := Alltrim(UsrRetName(__cUserId))
	
	aCab:= {		{"C1_NUM",nPCompra,NIL},;
	{"C1_SOLICIT",cNome,NIL},;
	{"C1_UNIDREQ" ,cURequis,NIL},;
	{"C1_CODCOMP" ,cComprador,NIL},;
	{"C1_EMISSAO",dDataBase,NIL}}

	
	DbSelectArea("SZ8")
	DbSetorder(1)
	If DbSeek(xFilial("SZ8")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
		
		
		while !SZ8->(Eof()) .And. xFilial("SZ8") =  SZ8->Z8_FILIAL .And.;
			SZ8->(Z8_SIMIL+Z8_EIS) = aCols[nY][_n_Simil] + aCols[nY][_n_EIS]
			
		
			If SZ8->Z8_COMPRAR > 0
				
				
				//
				// Posiciona Cadastro de Produtos
				//
				SB1->(DbSelectArea("SB1"),	DbSetOrder(1),Dbseek(xFilial("SB1")+SZ8->Z8_SKU))
				
				//
				// Posiciona Fornecedor
				//
				SA2->(DbSelectArea("SA2"),	DbSetOrder(1),Dbseek(xFilial("SA2")+SB1->B1_X_FORN+SB1->B1_X_LOJA))
				
				
				nItem := nItem + 1    // Nao ha necessidade de colocar lotra aqui tambem devido
				// o campo item ser igual a 9999
				
				Aadd(aItem, {	{"C1_ITEM"   ,strzero(nItem,4),NIL},;
				{"C1_PRODUTO" ,SZ8->Z8_SKU,NIL},;
				{"C1_UM"      ,SB1->B1_UM,NIL},;
				{"C1_QUANT"   ,SZ8->Z8_COMPRAR,NIL},;
				{"C1_DATPRF"  ,dDataBase+SB1->B1_X_LT,NIL},;
				{"C1_LOCAL"   ,"01",NIL},;
				{"C1_FORNECE" ,SB1->B1_X_FORN,NIL},;
				{"C1_LOJA"    ,SB1->B1_X_LOJA,NIL},;
				{"C1_OBS"     ,"",NIL},;
				{"C1_X_NOMCP" ,SY1->Y1_NOME,NIL},;
				{"C1_X_NOMFO" ,SA2->A2_NREDUZ,NIL},;
				{"C1_IMPORT"  ,SB1->B1_IMPORT,NIL}})
				
			Endif
			
			DbSelectArea("SZ8")
			SZ8->(DBSKIP())
			
			
		Enddo
		
	Endif
	
Next nY


If nItem = 0
	
	Aviso("ATENCAO", "Nao existem itens selecionados para gerar Solicitacao de Compras , verifique !",{"&Ok"})
	lRet:=.f.
	
Else
	
	DbSelectArea("SC1")
	
	MSExecAuto({|x,y,z| mata110(x,y,z)},aCab,aItem,3) //Inclusao
	
	If lMsErroAuto
		
		MOSTRAERRO() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
		Aviso('Atencao','Cancelada Geracao do Pedido.',{'Ok'})
		lRet:=.f.
		
	Else
		
		//
		// O sigaauto acima nao estava alterando esta data mantinha sempre ddatabase
		//
		DbSelectArea("SC1")
		If DbSeek(xFilial("SC1")+nPCompra)
			While !SC1->(EOF())  .AND.  xFilial("SC1")+nPCompra = C1_FILIAL+C1_NUM
				
				SB1->(DbSelectArea("SB1"),DbSetOrder(1),Dbseek(xFilial("SB1")+SC1->C1_PRODUTO))
				
				DbSelectArea("SC1")
				Reclock("SC1",.F.)
				SC1->C1_DATPRF := (dDataBase + SB1->B1_X_LT)
				MsUnlock()
				
				SC1->(DBSKIP())
			Enddo
		Endif
		
		Aviso("ATENCAO", "Foi gerada a solicitacao de compras n."+nPCompra+".",{"&Ok"})
		
	Endif
	
Endif


if lRet
	
	ConfirmSx8()
	
	For nY := 1 to len(Acols)
		
		DbSelectArea("SZ8")
		DbSetorder(1)
		if DbSeek(xFilial("SZ8")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
			
			while !SZ8->(Eof()) .And. xFilial("SZ8") =  SZ8->Z8_FILIAL .And.;
				SZ8->(Z8_SIMIL+Z8_EIS) = aCols[nY][_n_Simil] + aCols[nY][_n_EIS]
				
				Reclock("SZ8",.F.)
				SZ8->Z8_NUMSC:= nPCompra
				MsUnlock()
				
				DbSelectArea("SZ8")
				SZ8->(DBSKIP())
				
			Enddo
			
		Endif
		
	Next nY
	
	
Else
	
	RollBAckSx8()
	
Endif




oDlgCons:Refresh()
SetFocus(oSimil:hWnd)

RestArea(aArea)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LimpFil   º Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Efetua a limpeza dos Filtros.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LimpFil()

cSimil     := CriaVar("B1_X_SIMIL")
cEisCod1   := SPACE(2)
cEisCod2   := SPACE(2)
cEisCod3   := SPACE(2)
cEisCod4   := SPACE(2)
cEisCod5   := SPACE(2)
cEisCod6   := SPACE(2)
cEisCod7   := SPACE(2)
cEisCod8   := SPACE(2)
cEisCod9   := SPACE(2)
cEisCod0   := SPACE(2)
nQtdeSku   := 0
cCombo1    := aItems1[1]
cCombo2    := aItems2[1]
cCombo3    := aItems3[1]
cCombo4    := aItems4[1]
cCombo5    := aItems5[1]
aCols      := {}

oDlgCons:Refresh()

SetFocus(oSimil:hWnd)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Tela_Quotaº Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Interfase entre Tela de PGMM e Manutencao de Quotas.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela_Quota()

Local aArea       := GetArea()
Local _cSimil     := ""
Local _cEISCod    := ""
// (SZ7) - Guarda o aCols atual do SZ7
Local aColsSZ7    := {}
Local aHeaderSZ7  := {}
Local aRotinaSZ7  := {}
Local nSZ7        := 0
Local nS_PedCom   := 0
Local lRet        := .T.
Local nNvCompra   := 0
Local nPedComp    := 0

if Len(Acols) = 0
	Aviso("ATENCAO", "Nao existem itens selecionados para acionar , verifique !",{"&Ok"})
	Return(.f.)
Endif


oGet:oBrowse:lDisablePaint := .T.

aColsSZ7      := aClone (aCols)
aHeaderSZ7    := aClone (aHeader)
aRotinaSZ7    := aClone (aRotina)
nSZ7          := n

_cSimil   := acols[n][_n_SIMIL]
_cEISCod  := acols[n][_n_EIS]


lRet:=U_MESTC03(_cSimil,_cEISCod)


// (SZ7) - Retorna o controle para o SZ7 e executa as alteracoes necessarias
aCols  := aClone (aColsSZ7)
aHeader:= aClone (aHeaderSZ7)
aRotina:= aClone (aRotinaSZ7)
N      := nSZ7

oGet:oBrowse:lDisablePaint := .F.


// (SB1) - Posiciona
If lRet
	DbselectArea("SB1")
	DbOrderNickname("B1SIMIL") // Filial+Simil+Eis
	if !Dbseek(xFilial("SB1") + _cSIMIL + _cEISCod )
		lRet := .F.
	Endif
Endif


// (SZ7) - Posiciona
If lRet
	DbSelectArea("SZ7")
	DbSetorder(1)
	If !Dbseek(xFilial("SZ7") + _cSIMIL + _cEISCod )
		lRet := .F.
	Endif
Endif


// (SZ8) - Posiciona
If lRet
	DbSelectArea("SZ8")
	DbSetorder(1)
	If !Dbseek(xFilial("SZ8") + _cSIMIL + _cEISCod )
		lRet := .f.
	Endif
Endif

if lRet
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza o SZ7 corrente                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ7")
	RecLock("SZ7",.F.)
	SZ7->Z7_PTMAN	:= SB1->B1_X_PTMAN
	SZ7->Z7_LTMAN	:= SB1->B1_X_LTMAN
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Retorna a Quantidade a ser comprada por EIS                               ³
	//|Ped_Comp(nLtMan,nLtAut,nPtman,nPtAut,nSldMalha itens de Compra ???)       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//                               Importante
	//nPedComp   -  A ser Comprado que dever ser Ratiado conforme o Share para gravacao no SZ8 (POR SKU)
	//nS_PedCom  -  Contem a Somatoria do Valor que foi Ratiado que ira ser gravado no SZ7.
	
	nPedComp:= U_PED_COMP(SZ7->Z7_LTMAN,SZ7->Z7_LTAUT,SZ7->Z7_PTMAN,SZ7->Z7_PTAUT,SZ7->Z7_PEDCOMP)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza o SZ8 corrente em diante                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !SZ8->(EOF()) .and. _cSIMIL + _cEISCod = SZ8->(Z8_SIMIL+Z8_EIS)
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		If  Dbseek(xFilial("SB1")+SZ8->Z8_SKU)
			nNvCompra:= INT((nPedComp * SB1->B1_X_SHARE) / 100)
		Else
			nNvCompra:= 0
		Endif
		
		nS_PedCom   += nNvCompra
		
		DbSelectArea("SZ8")
		RECLOCK("SZ8",.F.)                    //??? E IMPORTANTE RESALTAR QUE TODAS ALTERACOES ANTERIORES
		SZ8->Z8_SHARE    :=  SB1->B1_X_SHARE  //    SERAM PERDIDAS
		SZ8->Z8_COMPRAR  :=  nNvCompra
		SZ8->Z8_SELEC    :=  IF(nNvCompra<> 0,"X"," ")
		SZ8->(MsUnlock())
		
		SZ8->(DbSkip())
		
	Enddo
	
	SZ7->Z7_COMPRAR := nS_PedCom
	SZ7->Z7_SELEC   := IF(SZ7->Z7_COMPRAR<> 0,"X"," ")
	SZ7->(MsUnlock())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Atualiza o aCols                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n][_N_PTMAN]   := SZ7->Z7_PTMAN
	aCols[n][_N_LTMAN]   := SZ7->Z7_LTMAN
	aCols[n][_N_COMPRAR] := SZ7->Z7_COMPRAR
	aCols[n][_N_SELECT ] := IF(SZ7->Z7_COMPRAR<>0,"X"," ")
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//|Check SZ7 (Z7_COMPRAR) se nao houve divergencia originada do Share        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SZ7")
	DbSetORder(1)
	Dbseek(xFilial("SZ7") + _cSIMIL + _cEISCod )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa se durante o processo acima ocorreu alguma divergencia durante    |
	//³o rateamento da quantidade a comprar por SKU.                             |
	//³Caso tenha ocorrido lanca a diferenca no primeiro item que tiver Z8_COMPRAR|        |
	//³diferente de ZERO.                                                        |        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if  SZ7->Z7_COMPRAR - nS_PedCom  <> 0
	DbSelectArea("SZ8")
	DbSetOrder(1)       // Filial + Simil + Eis + Sku
	If DbSeek(xFilial("SZ8")+_cSIMIL + _cEISCod )
	While SZ8->(EOF()) .and. _cSIMIL + _cEISCod == SZ8->(Z8_SIMIL + Z8_EIS);
	.AND. xFilial("SZ8") == SZ8->Z8_FILIAL
	If  SZ8->SZ8_COMPRAR <> 0
	Reclock("SZ8",.F.)
	SZ8->Z8_COMPRAR := SZ8->Z8_COMPRAR + (SZ7->Z7_COMPRAR - nS_PedCom)
	SZ8->Z8_SELEC   := IF(SZ8->Z8_COMPRAR<> 0,"X"," ")
	MsUnLock()
	EXIT
	Endif
	SZ8->(DBSKIP())
	Enddo
	Endif
	
	Endif
	*/
	
	
Endif


oGet:Refresh()
oGet:oBrowse:SetFocus() // Reativa o colorido sobre a celula em que me encontrava

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Tela_SZ8 º Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Interfase entre as Telas Manutencao por Eis (SZ7) e SKU(SZ8)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela_SZ8()

Local aArea         := GetArea()
Local _cSIMIL   	:= 0
Local _cEISCod      := 0
Local _nDESVPAD	    := 0
Local _nESTSEG	    := 0
Local _nLT_DIAS	    := 0
Local _nTMEA		:= 0
Local _nCN_MALH     := 0
Local _nCN_DISP     := 0
Local _nCB_MALH     := 0
Local _nCB_DISP     := 0
Local _nPTAUT       := 0
Local _nPTMAN       := 0
Local _nLTAUT       := 0
Local _nLTMAN       := 0
Local _nCOMPRAR	    := 0
Local _X_SELECT     := 0
Local _X_COMPRAR    := 0
Local _nGiro        := 0

// Guarda o aCols atual do SZ7
Local aColsSZ7      := 0
Local aHeaderSZ7    := {}
Local aRotinaSZ7    := {}
Local nSZ7          := 0
// Estas variaveis sao abastecidas na tela do SZ8
Private aColsSZ8    := {}
Private aHeaderSZ8  := {}
Private aRotinaSZ8  := {}
Private nSZ8        := 0

If Len(aCols) = 0
	Aviso("ATENCAO", "Nao existem itens selecionados para acionar , verifique !",{"&Ok"})
Endif


oGet:oBrowse:lDisablePaint := .T.

aColsSZ7      := aClone (aCols)
aHeaderSZ7    := aClone (aHeader)
aRotinaSZ7    := aClone (aRotina)
nSZ7          := n


_cSIMIL       := aCols[n][_n_SIMIL]
_cEISCod      := aCols[n][_n_EIS]
_nDESVPAD	  := aCols[n][_n_DESVPAD]
_nESTSEG	  := aCols[n][_n_ESTSEG]
_nLT_DIAS	  := aCols[n][_n_LT_DIAS]
_nTMEA		  := aCols[n][_n_TMEA]


_nCN_MALH     := aCols[n][_n_CN_MALH]
_nCN_DISP     := aCols[n][_n_CN_DISP]
_nCB_MALH     := aCols[n][_n_CB_MALH]
_nCB_DISP     := aCols[n][_n_CB_DISP]

_nPTAUT       := aCols[n][_n_PTAUT]  // PPA
_nPTMAN       := aCols[n][_n_PTMAN]  // PPM
_nLTAUT       := aCols[n][_n_LTAUT]  // Lote Automatico
_nLTMAN       := aCols[n][_n_LTMAN]  // Lote Manual
_nCOMPRAR	  := aCols[n][_n_COMPRAR] // Lote p/ Pedido de Compra
_nGiro        := aCols[n][_n_Giro]   // Giro Ano



// Abre a Tela para manutencao do SZ8
U_MPL_002(_cSIMIL,;      // Codigo Simil
_cEISCod,;        // Codigo Eis
_nDESVPAD,;    // Desvio Padrao
_nESTSEG,;     // Estoque de Seguranca
_nLT_DIAS,;    // Lead Time
_nTMEA,;       // TMEA
_nCN_MALH,;    // Cobertura da Malha
_nCN_DISP,;    // Cobertura Disponivel
_nCB_MALH,;    // Cobertura da Malha
_nCB_DISP,;    // Cobertura Disponivel
_nPTAUT,;      // PPA
_nPTMAN,;      // PPM
_nLTAUT,;      // Lote Automatico
_nLTMAN,;      // Lote Manual
_nCOMPRAR,;    // Lote p/ Pedido de Compra
_nGiro)        // Total de Giro

// Retorna o controle para o SZ7 e executa as alteracoes necessarias
aCols  := aClone (aColsSZ7)
aHeader:= aClone (aHeaderSZ7)
aRotina:= aClone (aRotinaSZ7)
N      := nSZ7

oGet:oBrowse:lDisablePaint := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O SZ7 ja foi atualizado na Tela Mpl_002 aqui apenas atualizamos o Acols ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SZ7")
IF DbSeek(xFilial("SZ7")+_cSIMIL+_cEISCod)
	aCols[n][_N_COMPRAR] := SZ7->Z7_COMPRAR
	aCols[n][_N_SELECT ] := IF(SZ7->Z7_COMPRAR<>0,"X"," ")
Endif


//oGet:Refresh()
oGet:oBrowse:SetFocus() // Reativa o colorido sobre a celula em que me encontrava


RestArea(aArea)

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MontAcols ³ Autor ³ Anderson              ³ Data ³ 03.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza o Browse ao clicar no botao RENOVAR               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontAcols()

Local cQuery   := ""
Local nLin     := 0
Local cEisConc := ""
Local nLen     := 0
Local cAliasSZ7:=""

cEisConc := IIf(!Empty(cEisCod1) ,cEisConc , cEisConc+cEisCod1)
cEisConc := IIf(!Empty(cEisCod2) ,cEisConc , cEisConc+cEisCod2)
cEisConc := IIf(!Empty(cEisCod3) ,cEisConc , cEisConc+cEisCod3)
cEisConc := IIf(!Empty(cEisCod4) ,cEisConc , cEisConc+cEisCod4)
cEisConc := IIf(!Empty(cEisCod5) ,cEisConc , cEisConc+cEisCod5)
cEisConc := IIf(!Empty(cEisCod6) ,cEisConc , cEisConc+cEisCod6)
cEisConc := IIf(!Empty(cEisCod7) ,cEisConc , cEisConc+cEisCod7)
cEisConc := IIf(!Empty(cEisCod8) ,cEisConc , cEisConc+cEisCod8)
cEisConc := IIf(!Empty(cEisCod9) ,cEisConc , cEisConc+cEisCod9)
cEisConc := IIf(!Empty(cEisCod0) ,cEisConc , cEisConc+cEisCod0)


//If  Empty(cSimil)
//	Aviso("ATENCAO", "Informe pelo menos o SIMIL, verifique !",{"&Ok"})
//	Return(.f.)
//Endif


n     := 1
aCols := {} // Zera aCols para que possa receber os novos dados filtrados


#IFDEF TOP
	
	aStruSZ7  := SZ7->(dbStruct())
	lQuery    := .T.
	cAliasSZ7 := "QUERYSZ7"
	
	cQuery := ""
	cQuery := "SELECT SZ7.* "
	cQuery += "FROM "
	cQuery += RetSqlName("SZ7")+" SZ7 "
	cQuery += "WHERE "
	cQuery += "Z7_FILIAL ='" + xFilial("SZ7") + "'"
	// Filtra por Simil
	If !Empty(cSimil)
		cQuery += " AND Z7_SIMIL  = '" + cSimil + "'"
	Endif
	// Filtra por Eis
	If !Empty(cEisCod1)
		cQuery += " AND Z7_EIS01 = '" + cEisCod1 + "'"
		If !Empty(cEisCod2)
			cQuery += " AND Z7_EIS02 = '" + cEisCod2 + "'"
			If !Empty(cEisCod3)
				cQuery += " AND Z7_EIS03 = '" + cEisCod3 + "'"
				If !Empty(cEisCod4)
					cQuery += " AND Z7_EIS04 = '" + cEisCod4 + "'"
					If !Empty(cEisCod5)
						cQuery += " AND Z7_EIS05 = '" + cEisCod5 + "'"
						If !Empty(cEisCod6)
							cQuery += " AND Z7_EIS06 = '" + cEisCod6 + "'"
							If !Empty(cEisCod7)
								cQuery += " AND Z7_EIS07 = '" + cEisCod7 + "'"
								If !Empty(cEisCod8)
									cQuery += " AND Z7_EIS08 = '" + cEisCod8 + "'"
									If !Empty(cEisCod9)
										cQuery += " AND Z7_EIS09 = '" + cEisCod9 + "'"
										If !Empty(cEisCod0)
											cQuery += " AND Z7_EIS10 = '" + cEisCod0 + "'"
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	If  !("Todos" $ cCombo1)      // Filtra por PQR (combo1)
		cQuery += " AND Z7_NEOIL = '" + Substr(cCombo1,1,1) + "'"
	Endif
	If  !("Todos" $ cCombo2)      // Filtra por ABC (combo2)
		cQuery += " AND Z7_ABC   = '" + Substr(cCombo2,1,1) + "'"
	Endif
	If  !("Todos" $ cCombo3)      // Filtra por Lote Manual (combo3)
		//aadd(aItems3,"Todos         ")
		//aadd(aItems3,"Maior que Zero")       // Neste caso apenas analiso o
		//aadd(aItems3,"Menor que Zero")       // campo Lote Manual
		//aadd(aItems3,"Igual a Zero  ")
		If  "Maior" $ cCombo3
			cQuery += " AND Z7_LTAUT > 0 "
		ElseIf "Menor" $ cCombo3
			cQuery += " AND Z7_LTAUT < 0 "
		ElseIf "Igual" $ cCombo3
			// Segundo o Mauricio sempre que o Lote Manual for = 0
			// devo me guiar pelo lote Automatico
			cQuery += " AND Z7_LTAUT = 0 "
		Endif
	Endif
	If !("Todos" $ cCombo4 )       // Filtra por Lote pelos Selecionados (combo4)
		
		//aadd(aItems4,"Todos         ")
		//aadd(aItems4,"Comprados     ")      // Neste caso apenas ???
		//aadd(aItems4,"Nao Comprados ")
		if  "Comprados-" $ cCombo4
			cQuery += " AND Z7_SELEC = 'X'"
		ElseIF "Nao" $ cCombo4
			cQuery += " AND Z7_SELEC = ' '"
		Endif
	Endif
	If  !("Todos" $ cCombo5)
		// Filtra por ABC (combo5)
		cQuery += " AND SZ7.Z7_LMN = '" + Substr(cCombo5,1,1) + "'"
	Endif
	cQuery += " AND SZ7.D_E_L_E_T_=' ' "
	//cQuery += "ORDER BY SB7.B1_X_SUBSIMIL"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZ7,.T.,.T.)
	For nX := 1 To Len(aStruSZ7)
		If ( aStruSZ7[nX][2] <> "C" .and. alltrim(aStruSZ7[nX][1])$cQuery )
			TcSetField(cAliasSZ7,aStruSZ7[nX][1],aStruSZ7[nX][2],aStruSZ7[nX][3],aStruSZ7[nX][4])
		EndIf
	Next nX
	
	(cAliasSZ7)->(DbGotop())
	
#ELSE
	
	lQuery   := .F.
	cAliasSZ7:= "SZ7"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o arquivo por Filial + Simil + Eis                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ7")
	dbSetOrder(1)        // Filial + Simil + Eis
	cChave  := xFilial("SZ7") + cSimil + ALLTRIM(cEisConc)
	nLen    := Len(cChave)
	
	SET SOFTSEEK ON
	DbSeek(cChave,.T.)
	SET SOFTSEEK OFF
	
#ENDIF



DbSelectArea(cAliasSZ7)



//ProcRegua(nCount)
While !(cAliasSZ7)->(Eof()) .AND. xFilial("SZ7") == Z7_FILIAL
	
	If  !lQuery
		
		// O substr abaixo e devido a chave nem sempre vir completa todos o numero do Eis.
		if 	cChave <> Substr(xFilial("SZ7")+Z7_SIMIL+Z7_EIS,1,nLen)
			exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando cCombo1³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  !("Todos" $ cCombo1)                      // PQR
			If  SZ7->Z7_PQR <> Substr(cCombo1,1,1)
				SZ7->(DbSkip())
				Loop
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando cCombo2³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !("Todos" $ cCombo2)                      // ABC
			If  SZ7->Z7_ABC <> Substr(cCombo2,1,1)
				SZ7->(DbSkip())
				Loop
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando cCombo3³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !("Todos" $ cCombo3 )
			//aadd(aItems3,"Todos         ")
			//aadd(aItems3,"Maior que Zero")       // Neste caso apenas analiso o
			//aadd(aItems3,"Menor que Zero")       // campo Lote Manual
			//aadd(aItems3,"Igual a Zero  ")
			If  "Maior" $ cCombo3
				If SZ7->Z7_LTMAN <= 0
					SZ7->(DbSkip())
					Loop
				Endif
			Elseif "Menor" $ cCombo3
				If SZ7->Z7_LTMAN >= 0
					SZ7->(DbSkip())
					Loop
				Endif
			Elseif "Igual" $ cCombo3
				If SZ7->Z7_LTMAN # 0
					SZ7->(DbSkip())
					Loop
				Endif
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando cCombo4³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !("Todos" $ cCombo4)
			//aadd(aItems4,"Todos         ")
			//aadd(aItems4,"Comprados     ")      // Neste caso apenas ???
			//aadd(aItems4,"Nao Comprados ")
			if "Comprados" $ cCombo4
				If SZ7->Z7_SELEC = "X"
					SZ7->(DbSkip())
					Loop
				Endif
			ElseIF "Nao Comprados" $ cCombo4
				If SZ7->Z7_SELEC = " "
					SZ7->(DbSkip())
					Loop
				Endif
			Endif
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Analisando cCombo5³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !("Todos" $ cCombo5)                      // ABC
			If  SZ7->Z7_LMN <> Substr(cCombo5,1,1)
				SZ7->(DbSkip())
				Loop
			Endif
		Endif
		
	Endif
	
	//IncProc()
	
	AADD(aCols,Array(Len(aHeader)+1))
	nLin                        := Len(aCols)
	aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado
	
	aCols[nLin, _n_SELECT ] := (cAliasSZ7)->Z7_SELEC
	aCols[nLin, _n_SIMIL  ] := (cAliasSZ7)->Z7_SIMIL      // SIMIL
	aCols[nLin, _n_EIS    ] := (cAliasSZ7)->Z7_EIS        // Eis
	aCols[nLin, _n_PTAUT  ] := (cAliasSZ7)->Z7_PTAUT      // PPA
	aCols[nLin, _n_PTMAN  ] := (cAliasSZ7)->Z7_PTMAN      // PPM
	aCols[nLin, _n_LTAUT  ] := (cAliasSZ7)->Z7_LTAUT      // Lote Automatico
	aCols[nLin, _n_LTMAN  ] := (cAliasSZ7)->Z7_LTMAN      // Lote Manual
	aCols[nLin, _n_COMPRAR] := (cAliasSZ7)->Z7_COMPRAR    // Quantidade a ser Comprada
	aCols[nLin, _n_CONSPER] := (cAliasSZ7)->Z7_CONSPER    // Consumo no Periodo
	aCols[nLin, _n_SLDMALH] := (cAliasSZ7)->Z7_SLDMALH    // Saldo da Malha
	aCols[nLin, _n_PEDCOMP] := (cAliasSZ7)->Z7_PEDCOMP    // Saldo Item de Compra
	aCols[nLin, _n_NAOCOMP] := (cAliasSZ7)->Z7_NAOCOMP    // Saldo Item nao Compra
	aCols[nLin, _n_SLDTRAN] := (cAliasSZ7)->Z7_SLDTRAN    // Malha - Saldo em Transito
	aCols[nLin, _n_SLDEMPE] := (cAliasSZ7)->Z7_SLDEMPE    // Malha - Saldo Empenhado
	aCols[nLin, _n_DISPONI] := (cAliasSZ7)->Z7_DISPONI    // Malha - Saldo Disponivel
	aCols[nLin, _n_SLRESER] := (cAliasSZ7)->Z7_SLRESER    // Malha - Saldo Reservado
	aCols[nLin, _n_SLFATUR] := (cAliasSZ7)->Z7_SLFATUR    // Malha - Saldo a Faturar
	aCols[nLin, _n_LT_DIAS] := (cAliasSZ7)->Z7_LT_DIAS    // Lead Time  (Dias)
	aCols[nLin, _n_QTDAPAN] := (cAliasSZ7)->Z7_QTDAPAN    // Qtde de Apanhe (Ano)
	aCols[nLin, _n_TMEA   ] := (cAliasSZ7)->Z7_TMEA       // TMEA (Dias)
	aCols[nLin, _n_Giro   ] := (cAliasSZ7)->Z7_GIROANO      // TMEA (Dias)
	aCols[nLin, _n_TAMLOTE] := (cAliasSZ7)->Z7_TAMLOTE    // Tamanho Lote de Apanhe
	aCols[nLin, _n_CONSMED] := (cAliasSZ7)->Z7_CONSMED    // Consumo Medio (Mes) = Z7_CONSPER / PERIODO DO PARAMETRO
	aCols[nLin, _n_DESVPAD] := (cAliasSZ7)->Z7_DESVPAD    // Desvio Padrao
	
	aCols[nLin, _n_CN_MALH] := (cAliasSZ7)->Z7_CN_MALH    // Cob. Inst. da Malha C/NC (Dias)
	aCols[nLin, _n_CN_DISP] := (cAliasSZ7)->Z7_CN_DISP    // Cob. Inst. Disp.C/NC(Dias)
	aCols[nLin, _n_CB_MALH] := (cAliasSZ7)->Z7_CB_MALH    // Cob. Inst. da Malha IT.CMP.(Dias)
	aCols[nLin, _n_CB_DISP] := (cAliasSZ7)->Z7_CB_DISP    // Cob. Inst. Disp. IT.CMP.(Dias)
	
	aCols[nLin, _n_AUXILIA] := (cAliasSZ7)->Z7_AUXILIA    // Auxiliar
	aCols[nLin, _n_ESTSEG ] := (cAliasSZ7)->Z7_ESTSEG     // Estq.Seguranca (Dias)
	aCols[nLin, _n_DESC001] := (cAliasSZ7)->Z7_DESCR1     // Metodo usado no Dimencionamento do Estoque.
	aCols[nLin, _n_DESC002] := (cAliasSZ7)->Z7_DESCR2     // Sistema de Tratamento.
	aCols[nLin, _n_DESC003] := (cAliasSZ7)->Z7_DESCR3     // Descricao Eis contatenado
	
	(cAliasSZ7)->(DbSkip())
	
Enddo

aCols := Asort(aCols,,,{|x,y| x[_n_SIMIL]+x[_n_EIS] < y[_n_SIMIL]+y[_n_EIS]})

If  lQuery
	DbSelectArea(cAliasSZ7)
	(cAliasSZ7)->(DbCloseArea())
Endif

nQtdeSku := Len(Acols)
oQtSku:Refresh()

If Len(acols) = 0
	Aviso("ATENCAO", "IMPOSSIVEL localizar dados, verifique os filtros !" ,{"&Ok"})
	SetFocus(oSimil:hWnd)
	Return(.F.)
Else
	oGet:Refresh()
	oGet:oBrowse:lDisablePaint := .F.
	oGet:oBrowse:SetFocus() // Reativa o colorido sobre a celula em que me encontrava
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³GTxtExcel()³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Exporta a planilha de trabalho para o Excel.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  // Otimo fonte para exemplo de geracao de txt - CSAM040()
Static Function GTxtExcel()

Local cPath     := U_Path_Arqu()



if !Empty(cPath)
   nQuest:=Aviso("Imprimir", "Somente os EIS que estao na Tela ou as SKU que irão gerar Solicitacoes de Compras com base nas Eis apresentadas em tela.",{"&EIS","&COMPRAS"})
   
   If nQuest = 1
   	MsgRun( OemToAnsi( "Aguarde. Gerando Arquivo "+cPath ),"",{||GeraEis(cPath)})
   Else
   	MsgRun( OemToAnsi( "Aguarde. Gerando Arquivo "+cPath ),"",{||GeraSku(cPath)})
   Endif

Endif

If ".TXT" $ cPath
	Aviso("ATENCAO", "O arquivo TXT foi gerado como sucesso em: "+CHR(13)+CHR(13)+;
	cPath,{"&Ok"})
Endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³GeraEIS    ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Gera o Arquivo Txt o Xls                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraEIS(cPath)

LOCAL cDirDocs  := MsDocPath()
Local cArquivo  := CriaTrab(,.F.)
Local oExcelApp

Local nPos      := 0
Local nLenDesc  := 0
Local nTamCamp  := 0
Local aStru     := {}
Local uConteudo
Local cCampo    := 0
Local cPicture  := ""
Local nY        := 0

Local _cPath    := Substr(cPath,1,Rat("\",cPath))
Local _Arquivo  := Substr(cPath,Rat("\",cPath)+1,Rat(".",cPath)-Rat("\",cPath)-1)
Local _Extensao := (Substr(cPath,Rat(".",cPath),Rat(".",cPath)+4))
Local _lExcel   := IIf( "XLS" $ _Extensao , .T. , .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Neste Modelo a strutura do DTC se ajustara ao cabecalho ou ao ³
//³conteudo o que maior for. E serao somente os campos contidos  ³
//³no aHeader.(Filtrando os campos do SZ7)                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aHeader[1][1] - Descricao
//aHeader[1][2] - Campo
//aHeader[1][3] - Picture
//aHeader[1][4] - Tamanho
For nY := 1 to len(aHeader)
	nLenDesc:= Len(aHeader[nY,1])
	// Tamanho da Descricao <= Tamanho do Campo , Tamanho do Campo , Tamanho da Descricao
	nTamCamp:= If (nLenDesc <= aHeader[nY,4],aHeader[nY,4],nLenDesc)
	// Ajuste em funcao do cabecalho conter outras informacoes.
	if alltrim(aHeader[nY,2])  $  ("Z7_EIS|Z7_PTAUT|Z7_LTAUT|Z7_LTMAN")
		nTamCamp:= 20
	Endif
	aadd(aStru,{aHeader[nY,2],"C",nTamCamp,0})
Next


// Substitui o nome dado pelo criatrab pelo nome dado pelo usuario
cArquivo := _Arquivo


//Nao tente alterar o caminho acima pois o copy deixa de funcionar.
//dbCreate( cArquivo , aStru)
//dbUseArea(.T.,,cArquivo,cArquivo,.F.,.F.)
dbCreate(cDirDocs+"\"+cArquivo,aStru)
dbUseArea(.T.,,cDirDocs+"\"+cArquivo,cArquivo,.F.,.F.)


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z7_EIS  := "Similaridade"
(cArquivo)->Z7_PTAUT:= cSimil
(cArquivo)->Z7_LTAUT:= "EIS"
(cArquivo)->Z7_LTMAN:= (cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+;
cEisCod6+cEisCod7+cEisCod8+cEisCod9+cEisCod0)
MsUnlock()




RecLock(cArquivo, .T.)
(cArquivo)->Z7_EIS  := "Classif. ABC"
(cArquivo)->Z7_PTAUT:= cCombo2
(cArquivo)->Z7_LTAUT:= "Lote Automatico"
(cArquivo)->Z7_LTMAN:= cCombo3
MsUnlock()


RecLock(cArquivo, .T.)
(cArquivo)->Z7_EIS  := "Lista de Compras"
(cArquivo)->Z7_PTAUT:= cCombo4
(cArquivo)->Z7_LTAUT:= "Giro"
(cArquivo)->Z7_LTMAN:= cCombo5
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z7_EIS  := "Demanda"
(cArquivo)->Z7_PTAUT:= cCombo1
MsUnlock()


RecLock(cArquivo, .T.)
(cArquivo)->Z7_EIS  := "Processado em"
(cArquivo)->Z7_PTAUT:= dtoc(_cDtProc)
(cArquivo)->Z7_LTAUT:= "pelo usuario"
(cArquivo)->Z7_LTMAN:= _cUsProc
MsUnlock()


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

// Monta o Cabecalho.
RecLock(cArquivo, .T.)
For nY := 1 to len(aStru)
	nPos     := aScan(aHeader,{|x| AllTrim(x[2])== allTrim(aStru[nY,1]) })
	uConteudo:= aHeader[nPos,1]
	&(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
Next
MsUnlock()

// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

DbSelectArea("SZ7")
DbSetOrder(1)
DbGotop()

For nX := 1 to Len(acols)
	
	RecLock(cArquivo, .T.)
	For nY := 1 To Len(aHeader)
		
		cCampo    := aHeader[nY,2]                     // Campo
		cPicture  := aHeader[nY,3]                     // Picture
		uConteudo := aCols[nX][nY]     ///  SZ7->(FieldGet(FieldPos(aStru[nY,1])))
		
		If ValType(uConteudo) = "N"
			uConteudo := Transform(uConteudo,cPicture)
		ElseIf ValType(uConteudo) = "D"
			uConteudo := Transform(uConteudo,"DD/MM/AA")
		ElseIf ValType(uConteudo) = "L"
			uConteudo := Transform(uConteudo,"@!!!")
		Endif
		
		//    &(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
		&(cArquivo)->(FieldPut(FieldPos(cCampo),uConteudo))
		
	Next nY
	MsUnlock()
	
	DbSelectArea("SZ7")
	SZ7->(DBSKIP())
	
Next nX


dbSelectArea(cArquivo)

if  _lExcel
	
	dbCloseArea()
	
	CpyS2T( cDirDocs+"\"+cArquivo+".DTC" , _cPath , .T. )
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop( "MsExcel nao instalado" )
		Return
	EndIf
	
	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open( _cPath+_Arquivo+".DTC" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
Else
	
	Copy To &cPath SDF
	
	dbSelectArea(cArquivo)
	dbCloseArea()
	
Endif

Return



/*
Static Function Cs040Copia(cNomeDir)
Local cAtuDir := ""

IF !Empty ( AllTrim( cAtuDir := GetPvProfString( GetEnvServer(), "StartPath", "", GetADV97() ) ) )
IF Subst( cAtuDir , 1 , 1 ) != "\"
cAtuDir := "\"+cAtuDir
EndIF
IF Subst( cAtuDir , -1	) != "\"
cAtuDir += "\"
EndIF
EndIf

cNomeDir := Alltrim(cNomeDir)

#IFNDEF TOP
MSCOPYFILE(cAtuDir+"EXECUTE.EXE",cNomeDir+"EXECUTE.EXE")
#ELSE
__COPYFILE(cAtuDir+"EXECUTE.EXE",cNomeDir+"EXECUTE.EXE")
#ENDIF

*/

Return .T.



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

aadd(aButtons,{"PROJETPMS",{|| Tela_SZ8() }, "<F4> - Manutencao SKU" })

Return (EnchoiceBar(oDlgCons,bOK,bcancel,,aButtons))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³GeraSKU    ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Gera o Arquivo Txt o Xls                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraSKU(cPath)

LOCAL cDirDocs  := MsDocPath()
Local cArquivo  := CriaTrab(,.F.)
Local oExcelApp

Local nPos      := 0
Local nLenDesc  := 0
Local nTamCamp  := 0
Local aStru     := {}
Local uConteudo
Local cCampo    := 0
Local cPicture  := ""
Local nY        := 0

Local _cPath    := Substr(cPath,1,Rat("\",cPath))
Local _Arquivo  := Substr(cPath,Rat("\",cPath)+1,Rat(".",cPath)-Rat("\",cPath)-1)
Local _Extensao := (Substr(cPath,Rat(".",cPath),Rat(".",cPath)+4))
Local _lExcel   := IIf( "XLS" $ _Extensao , .T. , .F. )

// Variaveis que contralam parte inferior da Tela
Local _X_SELEC    := 0   // Sel
Local _X_SKU      := 0   // SKU
Local _X_REFER    := 0   // Referencia
Local _X_SUFIX    := 0   // Sufixo
Local _X_MARCA    := 0   // Sufixo
Local _X_CDTR     := 0   // Cdtr
Local _X_SHARE    := 0   // SHARE
Local _X_COMPRAR  := 0   // Quantidade a ser comprada
Local _X_CONSPER  := 0   // Consumo  Periodo
Local _X_CUSMED   := 0   // Custo Medio
Local _X_VLRFOB   := 0   // Valor Fob
Local _X_ITCPR    := 0   // Item  Compra
Local _X_SLDMALH  := 0   // Saldo da Malha
Local _X_PEDCOMP  := 0   // Saldo Item de Compra
Local _X_NAOCOMP  := 0   // Saldo Item nao Compra

Local _X_SLDTRAN  := 0   // Malha - Saldo em Transito
Local _X_SLDEMPE  := 0   // Malha - Saldo Empenhado
Local _X_SLDFATU  := 0   // Malha - Saldo a Faturar
Local _X_SLDCLAS  := 0   // Malha - Saldo a Classificar
Local _X_DISPONI  := 0   // Malha - Saldo Disponivel

Local nLin        := 0
Local nX          := 0

Local aHeaderSZ8  :={}
Local aColsSZ8    :={}

Local cEis        :=cEisCod1+cEisCod2+cEisCod3+cEisCod4+cEisCod5+cEisCod6+cEisCod7+cEisCod8+cEisCod9+cEisCod0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aHeaderSZ8          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("Z8_SELEC")   // Sel
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SIMIL")   // Simil
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_EIS")   // Eis
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SKU")      // SKU
Aadd(aHeaderSZ8,{ "SKU"          , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_REFER")    // Referencia
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SUFIX")    // Sufixo
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_MARCA")    // Marca
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CDTR")     // Cdtr
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SHARE")    // SHARE
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_COMPRAR")  // Quantidade a ser comprada
Aadd(aHeaderSZ8,{ "Pedido de Compra" , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"U_ValLinSZ8(.F.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CONSPER")  // Consumo  Periodo
Aadd(aHeaderSZ8,{ "Consumo Periodo", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CUSMED")  // Custo Medio
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_VLRFOB")  // Valor Fob
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_ITCPR")  // Item  Compra
Aadd(aHeaderSZ8,{ "Item Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z8_SLDMALH")  // Saldo da Malha
Aadd(aHeaderSZ8,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_PEDCOMP")  // Saldo Item de Compra
Aadd(aHeaderSZ8,{ "Sld IT Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_NAOCOMP")  // Saldo Item nao Compra
Aadd(aHeaderSZ8,{ "Sld IT N Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
// ===> Saldos
DbSeek("Z8_DISPONI")  // Malha - Saldo Disponivel
Aadd(aHeaderSZ8,{ "Qtde Disponivel", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SLDTRAN")  // Malha - Saldo em Transito
Aadd(aHeaderSZ8,{ "Qtde Transito", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SLDEMPE")  // Malha - Saldo Empenhado
Aadd(aHeaderSZ8,{ "Qtde Empenhada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_AFATURA")  // Malha - Saldo a Faturar
Aadd(aHeaderSZ8,{ "Qtde a Faturar", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_RESERVA")  // Malha - Saldo Reservado
Aadd(aHeaderSZ8,{ "Qtde Reservada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_ACLASS")   // Malha - Saldo a Classificar
Aadd(aHeaderSZ8,{ "Qtde a Classif.", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aCols        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_SELEC  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SELEC"})   // Sel
_X_SKU    := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SKU"})      // SKU
_X_REFER  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_REFER"})    // Referencia
_X_SUFIX  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SUFIX"})    // Sufixo
_X_MARCA  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_MARCA"})    // Sufixo
_X_CDTR   := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_CDTR"})     // Cdtr
_X_SHARE  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SHARE"})    // SHARE
_X_COMPRAR:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_COMPRAR"})  // Quantidade a ser comprada
_X_CONSPER:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_CONSPER"})  // Consumo  Periodo
_X_CUSMED := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_CUSMED"})   // Custo Medio
_X_VLRFOB := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_VLRFOB"})   // Valor Fob
_X_ITCPR  := aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_ITCPR"})    // Item  Compra
_X_SLDMALH:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SLDMALH"})  // Saldo da Malha
_X_PEDCOMP:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_PEDCOMP"})  // Saldo Item de Compra
_X_NAOCOMP:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_NAOCOMP"})  // Saldo Item nao Compra

_X_SLDTRAN:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SLDTRAN"})  // Malha - Saldo em Transito
_X_SLDEMPE:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_SLDEMPE"})  // Malha - Saldo Empenhado
_X_SLDFATU:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_AFATURA"})  // Malha - Saldo a Faturar
_X_SLDCLAS:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_ACLASS"})   // Malha - Saldo a Classificar
_X_DISPONI:= aScan(aHeaderSZ8,{|x| AllTrim(x[2])=="Z8_DISPONI"})  // Malha - Saldo Disponivel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Neste Modelo a strutura do DTC se ajustara ao cabecalho ou ao ³
//³conteudo o que maior for. E serao somente os campos contidos  ³
//³no aHeader.(Filtrando os campos do SZ7)                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//aHeader[1][1] - Descricao
//aHeader[1][2] - Campo
//aHeader[1][3] - Picture
//aHeader[1][4] - Tamanho
For nY := 1 to len(aHeaderSZ8)
	nLenDesc:= Len(aHeaderSZ8[nY,1])
	// Tamanho da Descricao <= Tamanho do Campo , Tamanho do Campo , Tamanho da Descricao
	nTamCamp:= If (nLenDesc <= aHeaderSZ8[nY,4],aHeaderSZ8[nY,4],nLenDesc)
	// Ajuste em funcao do cabecalho conter outras informacoes.
	if alltrim(aHeaderSZ8[nY,2])  $  ("Z8_SKU|Z8_REFER|Z8_MARCA|Z8_CDTR")
		nTamCamp:= 20
	Endif
	aadd(aStru,{aHeaderSZ8[nY,2],"C",nTamCamp,0})
Next

// Substitui o nome dado pelo criatrab pelo nome dado pelo usuario
cArquivo := _Arquivo


//Nao tente alterar o caminho acima pois o copy deixa de funcionar.
//dbCreate( cArquivo , aStru)
//dbUseArea(.T.,,cArquivo,cArquivo,.F.,.F.)
dbCreate(cDirDocs+"\"+cArquivo,aStru)
dbUseArea(.T.,,cDirDocs+"\"+cArquivo,cArquivo,.F.,.F.)


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "Similaridade"
(cArquivo)->Z8_REFER:= cSimil
(cArquivo)->Z8_MARCA:= "EIS"
(cArquivo)->Z8_CDTR := cEis
MsUnlock()


RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "Classif. ABC"
(cArquivo)->Z8_REFER:= cCombo2
(cArquivo)->Z8_MARCA:= "Lote Automatico"
(cArquivo)->Z8_CDTR:= cCombo3
MsUnlock()


RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "Lista de Compras"
(cArquivo)->Z8_REFER:= cCombo4
(cArquivo)->Z8_MARCA:= "Giro"
(cArquivo)->Z8_CDTR:= cCombo5
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "Demanda"
(cArquivo)->Z8_REFER:= cCombo1
MsUnlock()


RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "Processado em"
(cArquivo)->Z8_REFER:= dtoc(_cDtProc)
(cArquivo)->Z8_MARCA:= "pelo usuario"
(cArquivo)->Z8_CDTR := _cUsProc
MsUnlock()


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

// Monta o Cabecalho.
RecLock(cArquivo, .T.)
For nY := 1 to len(aStru)
	nPos     := aScan(aHeaderSZ8,{|x| AllTrim(x[2])== allTrim(aStru[nY,1]) })
	uConteudo:= aHeaderSZ8[nPos,1]
	&(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
Next
MsUnlock()

// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "IRA GERAR SC"
MsUnlock()


//
// LISTA ITENS COMPRADOS QUE IRAM GERAR SOLICITACAO DE COMPRAS
//

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  MONTA O VETOR aColsSZ8              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ8")
DbSetorder(1)        // Simil + Eis + SKU
For nY:= 1 to len(aCols)
	If DbSeek(xFilial("SZ8")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
		while !SZ8->(Eof()) .And. xFilial("SZ8") =  SZ8->Z8_FILIAL .And.;
			SZ8->(Z8_SIMIL+Z8_EIS) = aCols[nY][_n_Simil] + aCols[nY][_n_EIS]
			If SZ8->Z8_COMPRAR > 0
				AADD(aColsSZ8,Array(Len(aHeaderSZ8)+1))
				nLin                        := Len(aColsSZ8)
				aColsSZ8[nLin,Len(aHeaderSZ8)+1] := .F.                           // Nao Deletado
				For nX := 1 To Len(aHeaderSZ8)
					aColsSZ8[nLin][nX] := FieldGet(FieldPos(aHeaderSZ8[nX][2]))
				Next nX
			Endif
			SZ8->(DbSkip())
		Enddo
	Endif
Next nY


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()


DbSelectArea("SZ7")
DbSetOrder(1)
DbGotop()

For nX := 1 to Len(acolsSZ8)
	
	RecLock(cArquivo, .T.)
	For nY := 1 To Len(aHeaderSZ8)
		
		cCampo    := aHeaderSZ8[nY,2]                     // Campo
		cPicture  := aHeaderSZ8[nY,3]                     // Picture
		uConteudo := aColsSZ8[nX][nY]     ///  SZ7->(FieldGet(FieldPos(aStru[nY,1])))
		
		If ValType(uConteudo) = "N"
			uConteudo := Transform(uConteudo,cPicture)
		ElseIf ValType(uConteudo) = "D"
			uConteudo := Transform(uConteudo,"DD/MM/AA")
		ElseIf ValType(uConteudo) = "L"
			uConteudo := Transform(uConteudo,"@!!!")
		Endif
		
		//    &(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
		&(cArquivo)->(FieldPut(FieldPos(cCampo),uConteudo))
		
	Next nY
	MsUnlock()
	
	DbSelectArea("SZ7")
	SZ7->(DBSKIP())
	
Next nX


RecLock(cArquivo, .T.)
MsUnlock()

RecLock(cArquivo, .T.)
(cArquivo)->Z8_SKU  := "NAO IRA GERAR SC"
MsUnlock()

RecLock(cArquivo, .T.)
MsUnlock()


//
// LISTA ITENS NAO COMPRADOS QUE IRAM GERAR SOLICITACAO DE COMPRAS
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  MONTA O VETOR aColsSZ8              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ8")
DbSetorder(1)        // Simil + Eis + SKU

aColsSZ8:={}

For nY:= 1 to len(aCols)
   
   DbSelectArea("SZ7")
	IF DbSeek(xFilial("SZ7")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
		
		If SZ7->Z7_COMPRAR = 0
			
         DbSelectArea("SZ8")
			If DbSeek(xFilial("SZ8")+aCols[nY][_n_Simil]+aCols[nY][_n_EIS])
				while !SZ8->(Eof()) .And. xFilial("SZ8") =  SZ8->Z8_FILIAL .And.;
					SZ8->(Z8_SIMIL+Z8_EIS) = aCols[nY][_n_Simil] + aCols[nY][_n_EIS]
					If SZ8->Z8_COMPRAR <= 0
						AADD(aColsSZ8,Array(Len(aHeaderSZ8)+1))
						nLin                        := Len(aColsSZ8)
						aColsSZ8[nLin,Len(aHeaderSZ8)+1] := .F.                           // Nao Deletado
						For nX := 1 To Len(aHeaderSZ8)
							aColsSZ8[nLin][nX] := FieldGet(FieldPos(aHeaderSZ8[nX][2]))
						Next nX
					Endif
					SZ8->(DbSkip())
				Enddo
			Endif
			
		Endif
		
	Endif
	
Next nY


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()


DbSelectArea("SZ7")
DbSetOrder(1)
DbGotop()

For nX := 1 to Len(acolsSZ8)
	
	RecLock(cArquivo, .T.)
	For nY := 1 To Len(aHeaderSZ8)
		
		cCampo    := aHeaderSZ8[nY,2]                     // Campo
		cPicture  := aHeaderSZ8[nY,3]                     // Picture
		uConteudo := aColsSZ8[nX][nY]     ///  SZ7->(FieldGet(FieldPos(aStru[nY,1])))
		
		If ValType(uConteudo) = "N"
			uConteudo := Transform(uConteudo,cPicture)
		ElseIf ValType(uConteudo) = "D"
			uConteudo := Transform(uConteudo,"DD/MM/AA")
		ElseIf ValType(uConteudo) = "L"
			uConteudo := Transform(uConteudo,"@!!!")
		Endif
		
		//    &(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
		&(cArquivo)->(FieldPut(FieldPos(cCampo),uConteudo))
		
	Next nY
	MsUnlock()
	
	DbSelectArea("SZ7")
	SZ7->(DBSKIP())
	
Next nX



dbSelectArea(cArquivo)

if  _lExcel
	
	dbCloseArea()
	
	CpyS2T( cDirDocs+"\"+cArquivo+".DTC" , _cPath , .T. )
	
	If ! ApOleClient( 'MsExcel' )
		MsgStop( "MsExcel nao instalado" )
		Return
	EndIf
	
	oExcelApp:= MsExcel():New()
	oExcelApp:WorkBooks:Open( _cPath+_Arquivo+".DTC" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
Else
	
	Copy To &cPath SDF
	
	dbSelectArea(cArquivo)
	dbCloseArea()
	
Endif

Return




