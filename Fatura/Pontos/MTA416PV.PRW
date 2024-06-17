#include "rwmake.ch"   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MTA416PV ³ Autor ³                       ³ Data ³ 11/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Gravar informacoes do Orcamento no Pedido durante a Lib.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Mta416pv()        // incluido pelo assistente de conversao do AP5 IDE em 20/12/01

Local _cPedido   := M->C5_NUM
Local _nPedido   := 0         
                            
Local _Produto:= aScan(_aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local _Comis1 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_COMIS1"})
Local _Comis2 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_COMIS2"})
Local _Comis3 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_COMIS3"})
Local _Comis4 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_COMIS4"})
Local _Comis5 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_COMIS5"})
Local _nItem  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
Local _nMargE := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_MARGE"})
Local _nMargA := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_MARGA"})
Local _nMargV := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_MARGV"})
Local _nOrigm := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_ORIGM"})
Local _nRefer := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_REFER"})
Local _nSufix := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_SUFIX"})
Local _nMarca := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_MARCA"})
Local _nBlq   := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_BLQ"})
Local _nPrCli := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_PRCLI"})
Local _nEntre := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local _nReser := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_RESER"})
Local _nItem0 := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_ITEMO"})
Local _nCtpad := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_CTPAD"})
Local _nCtSim := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_CTSIM"})
Local _nPrun  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_PRUNI"})  // PRECO SUGERIDO.

Local _nProduc:= aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_PRODU"})  // Producao Mtk.
Local _nNumOrc:= aScan(_aHeader,{|x| AllTrim(x[2])=="C6_NUMORC"})   // Numero do Orcamento.

Local _In     := 1
Local _cItem  := ""             

Local aVend   := {}
Local _nCont  := 0
Local nY      := 0
Local _str    := ""

                      
if Type("aPedProc") = "U"
	
	Public aPedProc  := {}  // Variavel especifica Multitek para controle de todos
	// os pedidos que estao sendo gerados dentro da rotina
	// automatica.
	// Esta variavel esta sendo alimentada dentro do ponto
	// de entrada MTA416PV.
	// E sera tratada no ultimo ponto de entrada MTA416FIM.
	
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava comissao.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA1")
DbSetorder(1)

If Dbseek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
	/* Somente gravo comissao no cabecalho quando o calculo da comissao e feito com base no valor total da NF
	   no nosso caso e efetuado com base no Item
	   
	DbSelectArea("SA3")
	DbSetorder(1)
	IF DbSeek(xFilial("SA3")+SCJ->CJ_X_VEND1)    // Vendedor Interno
		M->C5_COMIS1 := SA3->A3_COMIS
	Endif
	IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND2)    // Vendedor Externo
		M->C5_COMIS2 := SA3->A3_COMIS
	Endif
	IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND3)    // Vendedor Externo
		M->C5_COMIS3 := SA3->A3_COMIS
	Endif
	IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND4)    // Vendedor Externo
		M->C5_COMIS4 := SA3->A3_COMIS
	Endif
	IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND5)    // Vendedor Externo
		M->C5_COMIS5 := SA3->A3_COMIS
	Endif
	*/
Endif

                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia gravacao SC5 e SC6        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->C5_X_ORIGM :=  "S"         
M->C5_X_ST_CI :=  SCJ->CJ_X_ST_CI
M->C5_X_NUM   :=  SCJ->CJ_NUM
M->C5_X_DTPRE :=  SCJ->CJ_X_DTPRE       
M->C5_TRANSP  :=  SCJ->CJ_TRANSP                                  
M->C5_MOEDA   :=  SCJ->CJ_MOEDA 
M->C5_TIPLIB  :=  SCJ->CJ_X_LIBER              //  2 - Somente libera o pedido integral.
M->C5_NREDUZ  :=  SA1->A1_NREDUZ               //  1 - Libera o Pedido Parcial.     
M->C5_TPFRETE :=  SCJ->CJ_X_TPFRT              //  Tipo Frete: C=Cif ou F=Fob
M->C5_X_COTCL :=  SCJ->CJ_COTCLI
M->C5_MENNOTA :=  SCJ->CJ_MENNOTA

M->C5_COMIS1  :=  0                            //  A comissao e calculada durante o Faturamento m460fim.
M->C5_COMIS1   := 0
M->C5_COMIS2   := 0
M->C5_COMIS3   := 0
M->C5_COMIS4   := 0
M->C5_COMIS5   := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta o vetor aPedProc que    ³
//³sera utilizado no final          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nPedido = aScan(aPedProc,{|x| AllTrim(x[1])==_cPedido})
if _nPedido = 0    
   aadd(aPedProc,{_cPedido,SCJ->CJ_NUM+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,.f.})  // _cPedido    -> Numero do Pedido
   _nPedido = len(aPedProc)            									        // SCJ->CJ_NUM -> Numero do Orcamento
Endif                                  									        // .F./.T.     -> .T. foram deletados itens durante
                                     										     //                o processo de geracao do Pedido


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia alteracao do Acols        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While (_In <= Len(_aCols))
              
      //_cItem   := _aCols[_in,_nItem]
      
      _cFilial := xFilial("SCK")

      DbSelectArea("SCK")
      DbSetOrder(1)
      If DbSeek(xFilial("SCK")+_aCols[_in,_nNumOrc],.F.)
      //If DbSeek(xFilial("SCK")+SCJ->CJ_NUM+_cItem,.F.)
         
          If SCK->CK_FILIAL = _cFilial
	         _aCols[_in,_nRefer] := SCK->CK_X_REFER
    	     _aCols[_in,_nSufix] := SCK->CK_X_SUFIX
        	 _aCols[_in,_nMarca] := SCK->CK_X_MARCA
         	 _aCols[_in,_nBlq]   := "N"
           	 _aCols[_in,_nMargE] := SCK->CK_X_MARGE
         	 _aCols[_in,_nMargA] := SCK->CK_X_MARGA
             _aCols[_in,_nMargV] := SCK->CK_X_MARGV
             _aCols[_in,_nOrigm] := "S"
             _aCols[_in,_nPrCli] := SCK->CK_X_PRCLI
             _aCols[_in,_nEntre] := SCK->CK_X_ENTRE
         	 _aCols[_in,_nReser] := SCK->CK_X_RESER
             _aCols[_in,_nItem0] := SCK->CK_X_ITEM0
             _aCols[_in,_nCtpad] := SCK->CK_X_CTPAD
             _aCols[_in,_nCtSim] := SCK->CK_X_CTSTD
             _aCols[_in,_nPRUN]  := SCK->CK_X_PRUN  // Preco Sugerido
             _aCols[_in,_nProduc]:= SCK->CK_X_PRODU // Producao
         Endif
                
         // conforme conversa com o Sr. Mauricio nao ocorrera delecao do Item
         //IF ALLTRIM(_MV_PRODTMP) = ALLTRIM(_aCols[_in,_Produto])
         //   _aCols[_in,len(_aHeader)+1] := .T.
         //   aPedProc[_nPedido][3]        :=.T. //start pedido a para ser dado manutencao
         //ENDIF                                  //antes de sair da rotina automatica.
       

      Endif         
   
      _In := _In + 1

End



Return



// C U I D A D O S  A  SEREM TOMADOS.
/*

1) Cuidado com o tes campo F4_AGREGA pode parar de gerar comissao.
   no cadastro de produto   

2) Geracao da Comissao como ocorre:

  A) MATA415       ( ORCAMENTO )        - Nao e gravado nem comisao nem Vendedor.
     SA1 (Vendedor Externo)
     CJ_X_VEND1 (Vendedor Interno)  sao apenas utilizados para calculo.

  B)  MATA416PV    ( Geracao do Pedido) -  Efetuo a gravacao dos Vendedores Envolvidos
	  IF DbSeek(xFilial("SA3")+SCJ->CJ_X_VEND1)    // Vendedor Interno
		M->C5_COMIS1 := SA3->A3_COMIS
	  Endif
	  IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND2)    // Vendedor Externo
	  	M->C5_COMIS2 := SA3->A3_COMIS
	  Endif
	  IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND3)    // Vendedor Externo
	     M->C5_COMIS3 := SA3->A3_COMIS
	  Endif
  	  IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND4)    // Vendedor Externo
	   	 M->C5_COMIS4 := SA3->A3_COMIS
	  Endif
	  IF DbSeek(xFilial("SA3")+SA1->A1_X_VEND5)    // Vendedor Externo
		 M->C5_COMIS5 := SA3->A3_COMIS
	  Endif
 
   C) MT416FIM    (Finalizacao do Processo de Geracao do Pedido com gravacao dos % Comissao por Item

	Efetuo a gravacao do % de comissao
	Mas para tando avalio  na funcao AnaliRet se os vendedores teram direito a comissao.

             if AnaliRet(SC6->C6_PRODUTO,SC6->C6_X_MARGE)       
                Reclock("SC6",.F.)
                SC6->C6_COMIS1 := aVend[1][2]
                SC6->C6_COMIS2 := aVend[2][2]
                SC6->C6_COMIS3 := aVend[3][2]
                SC6->C6_COMIS4 := aVend[4][2]
                SC6->C6_COMIS5 := aVend[5][2]
                MsUnlock()
             Endif

*/




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ MTA416PV ³ Autor ³ Cleber Neves          ³ Data ³ 02/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Permitir digitar numero do Pedido de Venda gerado pelo     ³±±
±±³          ³ Or‡amento                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico ALKA Tecnologia em Diagnostico                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
_cPedido:= M->C5_NUM

@ 0,0 TO 250,400 DIALOG oDlg TITLE "Alterar Numero do Pedido de Venda"
@ 30,35 TO 80,130
@ 50,40 SAY "Pedido: "
@ 50,80 GET _cPedido VALID !Empty(_cPedido)
@ 50,150 BMPBUTTON TYPE 1 ACTION GravaNum()// Substituido pelo assistente de conversao do AP5 IDE em 20/12/01 ==> @ 50,150 BMPBUTTON TYPE 1 ACTION Execute(GravaNum)
ACTIVATE DIALOG oDlg CENTERED
Return

// Substituido pelo assistente de conversao do AP5 IDE em 20/12/01 ==> Function GravaNum
Static Function GravaNum()

M->C5_NUM:= _cPedido
M->C5_MOEDA    :=  val(substr(STR(SCJ->CJ_MOEDA),1,1))
M->C5_TRANSP   :=  SCJ->CJ_TRANSP
M->C5_TIPOCLI  :=  SCJ->CJ_TIPOCLI
M->C5_VEND1    :=  SCJ->CJ_VEND1
M->C5_COMIS1   :=  SCJ->CJ_COMIS1
M->C5_VEND2    :=  SCJ->CJ_VEND2
M->C5_COMIS2   :=  SCJ->CJ_COMIS2
M->C5_TPFRETE  :=  SCJ->CJ_TFRETE
M->C5_FRETE    :=  SCJ->CJ_FRETE
M->C5_PESOL    :=  SCJ->CJ_PESOL
M->C5_PBRUTO   :=  SCJ->CJ_PBRUTO
M->C5_VOLUME1  :=  SCJ->CJ_VOLUME1
M->C5_ESPECI1  :=  SCJ->CJ_ESPECI1
M->C5_MENNOTA  :=  SCJ->CJ_OBS

_cAlias := Alias()
_cReg   := Recno()
_cOrd   := IndexOrd()

_In := 1

While (_In <= Len(_aCols))

      _cItem   := _aCols[_in,1]
      _nNroOrc := SCJ->CJ_NUM

      DbSelectArea("SCK")
      DbSetOrder(1)
      If DbSeek(xFilial("SCK")+_nNroOrc+_cItem,.F.)
         _aCols[_in,35] := SCK->CK_LOTECTL
         _aCols[_in,37] := SCK->CK_DTVALID
      Endif
      _In := _In + 1

End

DbSelectArea(_cAlias)
DbSetOrder(_cOrd)
Dbgoto(_cReg)
      

Close(oDlg)
*/


