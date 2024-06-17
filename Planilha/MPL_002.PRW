#INCLUDE "FIVEWIN.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MPL_002  ºAutor  ³ Anderson           º Data ³  10/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±ºDesc.     ³Tela de manutencao do LOTE PRATICADO. A mesma ira mostrar   º±±
±±º          ³todos as SKU ref. ao SIMIL + EIS da tela anterior a esta, a º±±
±±º          ³MPL_001. A alteracao efetuada nas SKU deverao ser gravadas  º±±
±±º          ³na tabela SZ8 e tambem ter o saldo do SIMIL + EIS gravado   º±±
±±º          ³no SZ7 e ajustado no array (aCols)da tela anterior.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MPL_002(_xSIMIL  ,_xEIS    ,_nDESVPAD,_nESTSEG,_nLT_DIAS,_nTMEA,;
                      _nCN_MALH,_nCN_DISP,_nCB_MALH,_nCB_DISP,_nPTAUT  ,_nPTMAN ,_nLTAUT  ,_nLTMAN,;
                      _nCOMPRAR,_nGiro)

Local bSetKey4       

Private  _cSIMIL    := _xSIMIL
Private  _cEIS      := _xEIS
Private  cCadastro1 := "Consulta Detalhe Planilha SKU"

// Back-up de dados importante da tela anterior (a que fez chamada a esta)
Private _cAbc		:= "CLAS.NAO ENCONTRADA" // "C - BAIXA IMPORTANCIA ECONOMICA"
Private _cNeoil		:= "CLAS.NAO ENCONTRADA" // "Q - MEDIA"
Private _cGIRO		:= "CLAS.NAO ENCONTRADA" // "Q - MEDIA"
Private _cXYZ		:= "CLAS.NAO ENCONTRADA" // "X - BAIXA"
Private _c123		:= "CLAS.NAO ENCONTRADA" // "3 - FACIL"
Private _cNeoil		:= "CLAS.NAO ENCONTRADA"
Private _cOrigem    := ""
Private _nLtpPed    := IIf (_nLTMAN = 0 , _nCOMPRAR , _nLTMAN)//??? Segundo o Mauricio se Lote Manual = 0 Pego o Qtde Automatica que e igual a comprar

Private aHeader      := {}
Private aCols        := {}
// Variaveis que contralam parte inferior da Tela
Private _X_SELEC    := 0   // Sel
Private _X_SKU      := 0   // SKU
Private _X_REFER    := 0   // Referencia
Private _X_SUFIX    := 0   // Sufixo
Private _X_MARCA    := 0   // Sufixo
Private _X_CDTR     := 0   // Cdtr
Private _X_SHARE    := 0   // SHARE
Private _X_COMPRAR  := 0   // Quantidade a ser comprada 
Private _X_CONSPER  := 0   // Consumo  Periodo
Private _X_CUSMED   := 0   // Custo Medio
Private _X_VLRFOB   := 0   // Valor Fob
Private _X_ITCPR    := 0   // Item  Compra     
Private _X_SLDMALH  := 0   // Saldo da Malha
Private _X_PEDCOMP  := 0   // Saldo Item de Compra
Private _X_NAOCOMP  := 0   // Saldo Item nao Compra

Private _X_SLDTRAN  := 0   // Malha - Saldo em Transito
Private _X_SLDEMPE  := 0   // Malha - Saldo Empenhado
Private _X_SLDFATU  := 0   // Malha - Saldo a Faturar
Private _X_SLDCLAS  := 0   // Malha - Saldo a Classificar
Private _X_DISPONI  := 0   // Malha - Saldo Disponivel

// Variaveis de Controle de Tela Geral
Private nQtdSku     := 0 
Private aCols       := {}
//PRIVATE aRotina 	:= {{"Alterar"      ,"AxAltera", 0 , 4, 4} } 
Private oDlgCons1,oGet1,oSimi1,oEIS1,oABC,oPQR,oGiro,oXYZ,o123,oOrigem,oLead,o_nDESVPAD,oEstSeg,oCobMal,oTMEA,oGatilho,oQtdLote,oQtdSku,oCobDis
Private oPTAUT,oLTAUT,oCOMPRAR,oPTMAN,oLTMAN,oGiro	
                                                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Muda o valor do aRotina para nao incluir linha na GetDados   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aRotina := {{"","",0,1},{"","",0,1},{"","",0,3},{"","",0,6}}


DbSelectArea("SB1")
DbOrderNickname("B1SIMIL")         // Filial+Simil+Eis
If  DbSeek(xFilial("SB1") + _cSIMIL + _cEIS) 

    DbSelectArea("SZR")
    If DbSeek(xFilial("SZR")+SB1->B1_X_ABC)         // Tabela       (ABC)
       _cAbc := SZR->ZR_CODIGO +" - "+SZR->ZR_DESCR
    Endif 
    DbSelectArea("SZN")
    If DbSeek(xFilial("SZN")+SB1->B1_X_NEOIL)         // Popularidade (NEOIL) 
       _cNeoil := SZN->ZN_TIPO +" - "+SZN->ZN_DESCR
    Endif
    DbSelectArea("SZ1")
    If DbSeek(xFilial("SZ1")+SB1->B1_X_LMN)         // Giro         (LMN) 
       _cGIRO := SZ1->Z1_CODIGO +" - "+SZ1->Z1_DESC
    Endif
    DbSelectArea("SZP")
    If DbSeek(xFilial("SZP")+SB1->B1_X_XYZ)         // Aquisicao    (XYZ)
       _cXYZ := SZP->ZP_TIPO +" - "+SZP->ZP_DESCR
    Endif
    DbSelectArea("SZO")
    If DbSeek(xFilial("SZO")+SB1->B1_X_123)         // Criticitade  (123)
       _c123 := SZO->ZO_TIPO +" - "+SZO->ZO_DESCR
    Endif
    DbSelectArea("SZN")
    If DbSeek(xFilial("SZN")+SB1->B1_X_NEOIL)       // Demanda      (NEOIL)
       _cNeoil:= SZN->ZN_TIPO +" - "+SZN->ZN_DESCR 
    Endif

	_cOrigem := IIF(SB1->B1_X_NC_IM == "I","IMPORTADO","NACIONAL")

Else


	Aviso("ATENCAO", "SIMIL + EIS nao encontrados no Cadastro de Produto",{"&Ok"})

   Return

Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aHeader             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("Z8_SELEC")   // Sel
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SKU")      // SKU
Aadd(aHeader,{ "SKU"          , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_REFER")    // Referencia
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SUFIX")    // Sufixo
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_MARCA")    // Marca
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CDTR")     // Cdtr
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SHARE")    // SHARE
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_COMPRAR")  // Quantidade a ser comprada 
Aadd(aHeader,{ "Pedido de Compra" , x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"U_ValLinSZ8(.F.)",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CONSPER")  // Consumo  Periodo
Aadd(aHeader,{ "Consumo Periodo", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_CUSMED")  // Custo Medio
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_VLRFOB")  // Valor Fob
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_ITCPR")  // Item  Compra     
Aadd(aHeader,{ "Item Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )

DbSeek("Z8_SLDMALH")  // Saldo da Malha
Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_PEDCOMP")  // Saldo Item de Compra
Aadd(aHeader,{ "Sld IT Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_NAOCOMP")  // Saldo Item nao Compra
Aadd(aHeader,{ "Sld IT N Compra", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
// ===> Saldos
DbSeek("Z8_DISPONI")  // Malha - Saldo Disponivel
Aadd(aHeader,{ "Qtde Disponivel", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SLDTRAN")  // Malha - Saldo em Transito
Aadd(aHeader,{ "Qtde Transito", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_SLDEMPE")  // Malha - Saldo Empenhado
Aadd(aHeader,{ "Qtde Empenhada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_AFATURA")  // Malha - Saldo a Faturar
Aadd(aHeader,{ "Qtde a Faturar", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_RESERVA")  // Malha - Saldo Reservado
Aadd(aHeader,{ "Qtde Reservada", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
DbSeek("Z8_ACLASS")   // Malha - Saldo a Classificar
Aadd(aHeader,{ "Qtde a Classif.", x3_campo, x3_picture,X3_TAMANHO, X3_DECIMAL,"AllwaysTrue()",X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT } )
AADD(aHeader,{ "","VAZIO","@!",1,0,,x3_usado,"C","", ""} )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando aCols        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_X_SELEC  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SELEC"})   // Sel
_X_SKU    := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SKU"})      // SKU
_X_REFER  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_REFER"})    // Referencia
_X_SUFIX  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SUFIX"})    // Sufixo
_X_MARCA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_MARCA"})    // Sufixo
_X_CDTR   := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_CDTR"})     // Cdtr
_X_SHARE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SHARE"})    // SHARE
_X_COMPRAR:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_COMPRAR"})  // Quantidade a ser comprada 
_X_CONSPER:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_CONSPER"})  // Consumo  Periodo
_X_CUSMED := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_CUSMED"})   // Custo Medio
_X_VLRFOB := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_VLRFOB"})   // Valor Fob
_X_ITCPR  := aScan(aHeader,{|x| AllTrim(x[2])=="Z8_ITCPR"})    // Item  Compra     
_X_SLDMALH:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SLDMALH"})  // Saldo da Malha
_X_PEDCOMP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_PEDCOMP"})  // Saldo Item de Compra
_X_NAOCOMP:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_NAOCOMP"})  // Saldo Item nao Compra

_X_SLDTRAN:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SLDTRAN"})  // Malha - Saldo em Transito
_X_SLDEMPE:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_SLDEMPE"})  // Malha - Saldo Empenhado
_X_SLDFATU:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_AFATURA"})  // Malha - Saldo a Faturar
_X_SLDCLAS:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_ACLASS"})   // Malha - Saldo a Classificar
_X_DISPONI:= aScan(aHeader,{|x| AllTrim(x[2])=="Z8_DISPONI"})  // Malha - Saldo Disponivel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando Janela de Consulta          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MontAcols(_cSIMIL,_cEIS,_nCOMPRAR)		

nQtdSku := Len(aCols)


DEFINE MSDIALOG oDlgCons1 TITLE cCadastro1 FROM 106,65 TO 532+50,835  OF oMainWnd pixel
//bSetKey4 :=SetKey(VK_F4 ,{|| U_MPL_003(_cSimil,_cEis)}) // Ativando F4
bSetKey4 :=SetKey(VK_F4 ,{|| oDlgCons1:End() }) // Ativando F4

@ 015,005   TO 100,380 OF oDlgCons1 PIXEL

@ 020,010  SAY "Similaridade:"			size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 020,080  SAY "EIS:"					size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 020,180  SAY "Classificacao ABC:"   	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5

@ 032,010  SAY "Demanda:"	    		size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 032,100  SAY "Giro :"		        	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 032,162  SAY "Criticidade:"			size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 032,265  SAY "Aquisicao:"	    		size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5

@ 044,010  SAY "Origem:"				size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 044,110  SAY "Lead Time:"		     	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 044,170  SAY "Desvio Padrao:"		    size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 044,250  SAY "Estoque Seguranca:"	    size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5

@ 056,010  SAY "Cober.Instatanea Malha:"	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 056,120  SAY "Cober.Instatanea Disponivel:"	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 056,250  SAY "TMEA:"					size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5

@ 068,010  SAY "Ponto de Pedido Automatico:"	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 068,140  SAY "Lote Automatico:"          	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 068,240  SAY "Lote p/ Pedido de Compra:"	    size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5

@ 080,010  SAY "Ponto de Pedido Manual:"	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 080,140  SAY "Lote Manual:"          	size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 080,240  SAY "Giro Ano:"	               size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5


@ 020,045  MSGET oSimil1	 VAR  _cSimil		Picture "@!"                Size 030,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 020,095  MSGET oEis1		 VAR  _cEis     	Picture "@!"                Size 070,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 020,230  MSGET oABC		 VAR  _cABC	     	Picture "@!"                Size 140,6 OF oDlgCons1 PIXEL When .F. Valid .t.
                                                                     
@ 032,045  MSGET oPQR		 VAR  _cNeoil			Picture "@!"                Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 032,120  MSGET oGiro		 VAR  _cGiro		Picture "@!"                Size 035,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 032,203  MSGET oXYZ		 VAR  _cXYZ	     	Picture "@!"                Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 032,295  MSGET o123		 VAR  _c123	     	Picture "@!"                Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.   

@ 044,045  MSGET oOrigem	 VAR  _cOrigem		Picture "@!"  	  		    Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 044,140  MSGET oLead		 VAR  _nLT_DIAS	    Picture "@E 9999" 		    Size 020,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 044,210  MSGET oDESVPAD	 VAR  _nDesvPad     Picture "@E 9,999.99"	    Size 030,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 044,310  MSGET oEstSeg	 VAR  _nEstSeg     	Picture "@E 9,999.999"	    Size 060,6 OF oDlgCons1 PIXEL When .F. Valid .t.

@ 056,075  MSGET oCobMal	 VAR  _nCB_MALH 	Picture "@E 9999999999"		Size 030,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 056,190  MSGET oCobDis	 VAR  _nCB_DISP    	Picture "@E 9999999999"	    Size 030,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 056,305  MSGET oTMEA		 VAR  _nTMEA	    Picture "@E 99999.99"		Size 030,6 OF oDlgCons1 PIXEL When .F. Valid .t.

@ 068,080  MSGET oPTAUT  	 VAR  _nPTAUT  		Picture "@E 999,999,999.999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 068,185  MSGET oLTAUT 	 VAR  _nLTAUT     	Picture "@E 99,999,999.9999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 068,305  MSGET oCOMPRAR   VAR  _nLtpPed      Picture "@E 999,999,999.999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.

@ 080,080  MSGET oPTMAN	    VAR  _nPTMAN 		Picture "@E 999,999,999.999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 080,185  MSGET oLTMAN	    VAR  _nLTMAN    	Picture "@E 99,999,999.9999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.
@ 080,305  MSGET oGiro	    VAR  _nGiro    	Picture "@E 99,999,999.9999" Size 050,6 OF oDlgCons1 PIXEL When .F. Valid .t.


oGet1:=MSGetDados():New(095,005,195,380,3,"U_ValLinSZ8(.T.)","U_ValLinSZ8(.T.)",,.T.,{"Z8_COMPRAR"},1)      
//oGet1:oBrowse:nFreeze := 5        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
//oGet1:oBrowse:nColPos := xPrcven  // Posiciona no Preco de Venda
oGet1:nMax:=Len(Acols)


@ 199, 010 BUTTON "&Confirmar"	 		SIZE 40, 15 OF oDlgCons1 PIXEL ACTION  ( IIf( GravaSZ(_cSIMIL,_cEIS) , oDlgCons1:End(),) )
@ 199, 060 BUTTON "&Sair"	 		    SIZE 40, 15 OF oDlgCons1 PIXEL ACTION  ( oDlgCons1:End() )
@ 199, 110 BUTTON "&Gera Arquivo"	    SIZE 40, 15 OF oDlgCons1 PIXEL ACTION  ( GravaSZ(_cSIMIL,_cEIS) ,;
 GTxtExcel(_cSIMIL  ,_cEIS    ,_nDESVPAD,_nESTSEG,_nLT_DIAS,_nTMEA,;
           _nCB_MALH,_nCB_DISP,_nPTAUT  ,_nPTMAN ,_nLTAUT  ,_nLTMAN,;
           _nCOMPRAR) )
@ 199, 160 BUTTON "&Desmarca"		  	SIZE 40, 15 OF oDlgCons1 PIXEL ACTION  ( Desmarca() )
@ 199, 210 BUTTON "C&onsumo"	        SIZE 40, 15 OF oDlgCons1 PIXEL ACTION  ( TELA_SKU() )


@ 199,280  SAY "Quantidade Produtos:"		size 100,8 OF oDlgCons1 PIXEL //FONT oFntFecha5
@ 199,350  MSGET oQtdSku  VAR  nQtdSku     	Picture "@!"  Size 30,7 OF oDlgCons1 PIXEL When .F. Valid .t. 

ACTIVATE MSDIALOG oDlgCons1 ON INIT RfatBar(oDlgCons1,{|| IIf( GravaSZ(_cSIMIL, _cEIS) , oDlgCons1:End(),) },{||oDlgCons1:End()},_cSimil,_cEis) CENTERED
SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior da Tecla

                  
// Variaveis Privates declaradas no Mpl_001.prw
aColsSZ8  := aCols
aHeaderSZ8:= aHeader
aRotinaSZ8:= aRotina
nSZ8      := n

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Tela_Sku ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Abre Tela com o consumo/mes por Sku                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Tela_Sku()
Local lRet := .T.            

If Len(acols) = 0 

   Aviso("ATENCAO", "Nao existem itens selecionados para consultar o Consumo , verifique !",{"&Ok"})
   lRet:=.f.

Endif

if lRet
	
	oGet1:oBrowse:lDisablePaint := .T.
	
	U_MPL_C_SKU(acols[n][_X_SKU])
	
	oGet1:oBrowse:lDisablePaint := .F.
	
	oGet1:oBrowse:SetFocus() // Reativa o colorido sobre a celula em que me encontrava

Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Desmarca ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Desmarca todos os Itens                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Desmarca()
Local nY := 0 

For nY:= 1 to len(aCols)
    aCols[nY][_X_COMPRAR]:= 0
    aCols[nY][_X_SELEC]  := IIF(aCols[nY][_X_COMPRAR] <> 0,"X"," ")
Next nY
	
Return
                           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ GravaSZ  ³ Autor ³                       ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o SZ8 e atualiza o SZ7                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaSZ(_cSIMIL, _cEIS)
Local lRet := .T.
Local nY   := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida antes de Gravar  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:= 1 to len(aCols)
	
	DbSelectArea("SZ8")
	DbSetorder(1)         // Filial + Simil + Eis + Sku
	If Dbseek(xFilial("SZ8")+_cSimil+_cEis+aCols[nY][_X_SKU])
		
		If  Z8_COMPRAR <> aCols[nY][_X_COMPRAR] .and. ! EmptY("SZ8->Z8_NUMSC") 
		
			DbSelectArea("SC1")
			DbSetOrder(1)
			If Dbseek(xFilial("SC1")+SZ8->Z8_NUMSC)
				Aviso("ATENCAO", "Nao e permitida a alteracao da quantidade em funcao da quantidade estar "+;
				"contida na SC numero :"+SZ8->Z8_NUMSC+chr(13)+;
				"Caso deseje alterar a quantidade sera necessario deletar a SC.",{"&Ok"})
				lRet := .f.
				Exit
			Endif
				
		Endif
		
	Endif
	
Next nY


If lRet

	MsgRun( OemToAnsi( "Aguarde. Atualizando alteracoes efetuadas na Planilha"),"",{|| lRet:=GrAltSz(_cSIMIL, _cEIS)})

Endif

Return(lRet)



Static Function GrAltSz(_cSIMIL, _cEIS)
Local nS_PedCom := 0
Local lRet      := .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a gravacao do SZ8³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:= 1 to len(aCols)
	
	DbSelectArea("SZ8")
	DbSetorder(1)         // Filial + Simil + Eis + Sku
	If Dbseek(xFilial("SZ8")+_cSimil+_cEis+aCols[nY][_X_SKU])
		
		If  Z8_COMPRAR <> aCols[nY][_X_COMPRAR]
			Reclock("SZ8",.F.)
			SZ8->Z8_COMPRAR := INT(aCols[nY][_X_COMPRAR])
			SZ8->Z8_SELEC   := IIF(Z8_COMPRAR <> 0,"X"," ")
			MsUnlock()
		Endif
		nS_PedCom +=SZ8->Z8_COMPRAR
		
	Endif
	
Next nY

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a gravacao do SZ7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SZ7")
DbSetorder(1)         // Filial + Simil + Eis
If Dbseek(xFilial("SZ7")+_cSimil+_cEis)
	If  Z7_COMPRAR <> nS_PedCom
		Reclock("SZ7",.F.)
		SZ7->Z7_COMPRAR := nS_PedCom
		SZ7->Z7_SELEC   := IIF(Z7_COMPRAR<>0,"X"," ")
		MsUnlock()
	Endif
Endif


Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RfatBar  ³ Autor ³ Anderson              ³ Data ³ 10.12.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ EnchoiceBar especifica do MPL_001                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RfatBar(oDlgCons,bOk,bCancel,nOpc,_cSimil,_cEis)

Private aButtons  := {}
Private aButonUsr := {}
Private nI        := 0

aadd(aButtons,{"PROJETPMS",{|| oDlgCons1:End() }, "<F4> - Manutencao por Simil + Eis" })	

Return (EnchoiceBar(oDlgCons1,bOK,bcancel,,aButtons)) 



/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValLinSZ8 ºAutor  ³                    º Data ³  07/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida as linhas do aCols                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ValLinSZ8(lValid) 
Local _V_COMPRAR  := 0
Local lRet := .T.

DEFAULT lValid    := .F.

_V_COMPRAR := IIF(lValid .AND. TYPE("M->Z8_COMPRAR")  <>"U",&("M->Z8_COMPRAR")   ,aCols[n][_X_COMPRAR] )

aCols[n][_X_SELEC]:=Iif(_V_COMPRAR <> 0,"X"," ")

Return(lRet)


/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALTUDO   ºAutor  ³ Anderson           º Data ³  07/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida as linhas do aCols                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VALTUDO()

/*
_nValLtP := 0

For i := 1 to Len(aCols)
		
	DbSelectArea("SZ8")
	DbSetOrder(1)
	
	If DbSeek(xFilial("SZ8") + _cSimil + Alltrim(_cEis) + aCols[i][3]) // èsquisando por cada SKU (SIMIL + EIS + SKU) no SZ8 para entao GRAVAR os dados digitados
	
		 Reclock("SZ8",.F.)
		 
		 If aCols[i][8] > 0
		 	SZ8->Z8_LOTEPRA	:= aCols[i][8]
		 	SZ8->Z8_SELEC	:= "X"	// "X" no arquivo
		 	aCols[i][1] := "X"	// "X" no browse
		 Else
		  	SZ8->Z8_LOTEPRA := 0
		 	SZ8->Z8_SELEC   := Space(1)	// " " no arquivo
		 	aCols[i][1] := Space(1) 		// " " no browse
		 EndIf

		 MsUnlock()
		 
		 _nValLtP += If(aCols[i][8] > 0,aCols[i][8],0)
	
	EndIf		

Next

If _nValLtP > 0
 	_lSelSZ7 := "M"
Else
 	_lSelSZ7 := "D"
EndIf

oGet1:Refresh()
*/

Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MontAcolsº Autor ³                    º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a Inclusao de informacoes no Acols                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Multitek                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontAcols(_cSIMIL,_cEIS,_nCOMPRAR)		

Local nLin      := 0
Local nS_PedCom := 0
Local nX        := 0

DbSelectArea("SZ8")
DbSetorder(1)        // Simil + Eis + SKU

If Dbseek(xFilial("SZ8") + _cSIMIL + _cEIS )

	While !SZ8->(EOF()) .and. _cSIMIL + _cEIS = SZ8->(Z8_SIMIL+Z8_EIS)
        
		
		AADD(aCols,Array(Len(aHeader)+1))
		nLin                        := Len(aCols)
		aCols[nLin,Len(aHeader)+1] := .F.                           // Nao Deletado
		
		For nX := 1 To Len(aHeader)
			aCols[nLin][nX] := FieldGet(FieldPos(aHeader[nX][2]))
		Next nX
		
		/*
		Obs. O procedimento abaixo nao se tornou mais necessario em funcao
		do campo comprar se alteravel somente nesta tela.
		// Quanto entra na montagem do acols para SZ8 o B1_SHARE ou o _nComprar pode ter sido
		// modificado na tela anterior na manutencao do SZ7.
		aCols[nLin, _X_COMPRAR  ]  := ( _nCOMPRAR * SZ8->Z8_SHARE ) / 100
		aCols[nLin, _X_SELEC    ]  := IIF (aCols[nLin, _X_COMPRAR  ] <> 0 , "X" ," ")

        nS_PedCom += aCols[nLin, _X_COMPRAR  ]
		*/

		SZ8->(DbSkip())

	Enddo
     
    /*
	Obs. O procedimento abaixo nao se tornou mais necessario em funcao
	do campo comprar se alteravel somente nesta tela.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa se durante o processo acima ocorreu alguma divergencia durante    |
	//³o rateamento da quantidade a comprar por SKU.                             |
	//³Caso tenha ocorrido lanca a diferenca no primeiro item que tiver a posicao|
	//³do acols _x_comprar <> 0                                                  |  
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if  _nCOMPRAR - nS_PedCom  <> 0
	    For nY := 1 to Len(Acols)
	        If aCols[nY, _X_COMPRAR  ] <> 0 
	           aCols[nY, _X_COMPRAR  ]:= aCols[nY, _X_COMPRAR  ] + ( _nCOMPRAR - nS_PedCom)
            Endif
        Next nY
    Endif
    */
    
            
Endif

Return
	
	
	
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
Static Function GTxtExcel(_cSIMIL  ,_cEIS    ,_nDESVPAD,_nESTSEG,_nLT_DIAS,_nTMEA,;
                           _nCB_MALH,_nCB_DISP,_nPTAUT  ,_nPTMAN ,_nLTAUT  ,_nLTMAN,;
                           _nCOMPRAR)

Local cPath     := U_Path_Arqu()
   
               
if !Empty(cPath)

      MsgRun( OemToAnsi( "Aguarde. Gerando Arquivo "+cPath ),"",{||GeraSKU(cPath,_cSIMIL  ,_cEIS    ,_nDESVPAD,_nESTSEG,_nLT_DIAS,_nTMEA,;
                          _nCB_MALH,_nCB_DISP,_nPTAUT  ,_nPTMAN ,_nLTAUT  ,_nLTMAN,;
                           _nCOMPRAR)})
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
±±³Fun‡ao    ³GeraSKU    ³ Autor ³                      ³ Data ³ 06-05-2004 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Gera o Arquivo Txt o Xls                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraSKU(cPath,_cSIMIL  ,_cEIS    ,_nDESVPAD,_nESTSEG,_nLT_DIAS,_nTMEA,;
                      _nCB_MALH,_nCB_DISP,_nPTAUT  ,_nPTMAN ,_nLTAUT  ,_nLTMAN,;
                      _nCOMPRAR)

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
//³no aHeader.(Filtrando os campos do SZ8)                       ³
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
    if alltrim(aHeader[nY,2])  $  ("Z8_SKU|Z8_REFER|Z8_MARCA|Z8_CDTR")
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
(cArquivo)->Z8_SKU   := "Similaridade"
(cArquivo)->Z8_REFER := _cSimil
(cArquivo)->Z8_MARCA := "EIS"
(cArquivo)->Z8_CDTR  := _cEis       
MsUnlock()


RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Demanda"
(cArquivo)->Z8_REFER := _cNeoil
(cArquivo)->Z8_MARCA := "Classif. GIRO"
(cArquivo)->Z8_CDTR  := _cGIRO       
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_MARCA := "Classif. ABC"
(cArquivo)->Z8_CDTR  := _cAbc       
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Criticidade"
(cArquivo)->Z8_REFER := _cXYZ
(cArquivo)->Z8_MARCA := "Aquisicao"
(cArquivo)->Z8_CDTR  := _c123
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Origem"
(cArquivo)->Z8_REFER := _cOrigem
(cArquivo)->Z8_MARCA := "Lead Time"
(cArquivo)->Z8_CDTR  := Transform(_nLT_DIAS,"@E 9999")
MsUnlock()
                  
RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Estoque Seguranca"
(cArquivo)->Z8_REFER := Transform(_nEstSeg,"@E 9,999.999")
(cArquivo)->Z8_MARCA := "Desvio Padrao"
(cArquivo)->Z8_CDTR  := Transform(_nDesvPad,"@E 9,999.99")
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Cobertura Malha"
(cArquivo)->Z8_REFER := Transform(_nCB_MALH,"@E 9999999999")
(cArquivo)->Z8_MARCA := "TMEA (Dias)"
(cArquivo)->Z8_CDTR  := Transform(_nTMEA,"@E 99999.99")
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Qtde Lt Manual"
(cArquivo)->Z8_REFER := Transform(_nLTMAN,"@E 99,999,999.9999")
(cArquivo)->Z8_MARCA := "Qtde Lt Autom."
(cArquivo)->Z8_CDTR  := Transform(_nLTAUT,"@E 99,999,999.9999")
MsUnlock()

RecLock(cArquivo, .T.) 
(cArquivo)->Z8_SKU   := "Pt.de Ped. Manual"
(cArquivo)->Z8_REFER := Transform(_nPTMAN,"@E 999,999,999.999")
(cArquivo)->Z8_MARCA := "Pt.de Ped. Autom."
(cArquivo)->Z8_CDTR  := Transform(_nPTAUT,"@E 999,999,999.999")
MsUnlock()


// Pula uma Linha
RecLock(cArquivo, .T.)
MsUnlock()

//
// Monta o Cabecalho.
//
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

DbSelectArea("SZ8")
DbSetOrder(1)
DbGotop()    


For nX := 1 to Len(acols)
	
	RecLock(cArquivo, .T.)
	For nY := 1 To Len(aHeader)
		
		cCampo    := aHeader[nY,2]                     // Campo
		cPicture  := aHeader[nY,3]                     // Picture
		uConteudo := aCols[nX][nY]     ///  SZ7->(FieldGet(FieldPos(aStru[nY,1])))
		
		IF cCampo <> "VAZIO"
			
			If ValType(uConteudo) = "N"
				uConteudo := Transform(uConteudo,cPicture)
			ElseIf ValType(uConteudo) = "D"
				uConteudo := Transform(uConteudo,"DD/MM/AA")
			ElseIf ValType(uConteudo) = "L"
				uConteudo := Transform(uConteudo,"@!!!")
			Endif
			
			//    &(cArquivo)->(FieldPut(FieldPos(aStru[nY,1]),uConteudo))
			&(cArquivo)->(FieldPut(FieldPos(cCampo),uConteudo))
			
		Endif
		
	Next nY
	MsUnlock()
	
	DbSelectArea("SZ8")
	SZ8->(DBSKIP())
	
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
                        
 

