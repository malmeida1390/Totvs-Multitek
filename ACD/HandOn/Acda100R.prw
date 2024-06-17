#INCLUDE "Acda100.ch"
#include "FiveWin.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณACDA100Re ณ Autor ณ Anderson Rodrigues    ณ Data ณ 29/10/04 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณRotina de Impressao das ordens de separacao                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ SIGAACD                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACDA100Re()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString		:= "CB7"
Private aOrd         := {}
Private cDesc1       := "Este programa tem como objetivo imprimir informacoes das"
Private cDesc2       := "Ordens de Separacao"
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "M"
Private nomeprog     := "ACDA100R" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1} 
Private nLastKey     := 0
Private cPerg        := "ACD100"+SPACE(4)
Private titulo       := "Impressao das Ordens de Separacao"
Private nLin         := 06
Private Cabec1       := ""
Private Cabec2       := ""
Private cbtxt        := "Regsitro(s) lido(s)"
Private cbcont       := 0
Private CONTFL       := 01
Private m_pag        := 01
Private lRet         := .T.
Private imprime      := .T.
Private wnrel        := "ACDA100R" // Coloque aqui o nome do arquivo usado para impressao em disco

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas como Parametros                                ฟ
//ณ MV_PAR01 = Ordem de Separacao de       ?                            ฟ
//ณ MV_PAR02 = Ordem de Separacao Ate      ?                            ฟ
//ณ MV_PAR03 = Data de Emissao de          ?                            ฟ
//ณ MV_PAR04 = Data de Emissao Ate    	    ?                            ฟ
//ณ MV_PAR05 = Considera Ordens encerradas ?                            ฟ
//ณ MV_PAR06 = Imprime Codigo de barras    ?                            ฟ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

CriaPerg2()
          
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| Relatorio() },Titulo)
CB7->(DbClearFilter())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ Relatorioบ Autor ณ Anderson Rodrigues บ Data ณ  29/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Relatorio()

CB7->(DbSetOrder(1))
CB7->(DbSeek(xFilial("CB7")+MV_PAR01,.T.)) // Posiciona no 1o.reg. satisfatorio 
SetRegua(RecCount()-Recno())

While ! CB7->(EOF()) .and. (CB7->CB7_ORDSEP >= MV_PAR01 .and. CB7->CB7_ORDSEP <= MV_PAR02)	
	If CB7->CB7_DTEMIS < MV_PAR03 .or. CB7->CB7_DTEMIS > MV_PAR04 // Nao considera as ordens que nao tiver dentro do range de datas 
	   CB7->(DbSkip())
	   Loop
	Endif
	If MV_PAR05 == 2 .and. CB7->CB7_STATUS == "9" // Nao Considera as Ordens ja encerradas
	   CB7->(DbSkip())
	   Loop
	Endif
	CB8->(DbSetOrder(1))
   If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP))
	   CB7->(DbSkip())
	   Loop
   EndIf
	IncRegua("Imprimindo") 
	If lAbortPrint
	   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   Exit
	Endif			           	
	Imprime()	   
	CB7->(DbSkip())
Enddo
Fim()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ Imprime  บ Autor ณ Anderson Rodrigues บ Data ณ  12/09/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela funcao Relatorio              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Imprime(lRet)

Local cOrdSep := Alltrim(CB7->CB7_ORDSEP)
Local cPedido := Alltrim(CB7->CB7_PEDIDO)
Local cCliente:= Alltrim(CB7->CB7_CLIENT)
Local cLoja   := Alltrim(CB7->CB7_LOJA	)
Local cNota   := Alltrim(CB7->CB7_NOTA)
Local cSerie  := Alltrim(CB7->CB7_SERIE)
Local cOP     := Alltrim(CB7->CB7_OP)
Local cStatus := RetStatus(CB7->CB7_STATUS)
Local nWidth  := 0.050 
Local nHeigth := 0.75
Local oPr     := ReturnPrtObj()

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+cPedido,.T.)) // Posiciona no 1o.reg. satisfatorio 

If SC5->C5_TIPO $ "N/C/I/P"
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja,.T.)) // Posiciona no 1o.reg. satisfatorio 
	_cRazSoc := SA1->A1_NOME 
ElseIf SC5->C5_TIPO $ "D/B"
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+cCliente+cLoja,.T.)) // Posiciona no 1o.reg. satisfatorio 
	_cRazSoc := SA2->A2_NOME
Endif	

SA4->(DbSetOrder(1))
SA4->(DbSeek(xFilial("SA4")+SC5->C5_TRANSP,.T.)) // Posiciona no 1o.reg. satisfatorio   

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)		   

@ 06, 000 Psay "Ordem de Separacao"
@ 06, 020 Psay "--> "+cOrdSep

If MV_PAR06 == 1 .And. aReturn[5] # 1
   MSBAR3("CODE128",2.3,11.8,cOrdSep,oPr,Nil,Nil,Nil,nWidth,nHeigth,.t.,Nil,Nil)
   nLin := 09
Else
	nLin := 08
EndIf   

If CB7->CB7_ORIGEM == "1" // Pedido de Venda      
	@ nLin, 000 Psay "Pedido de Venda"
   @ nLin, 020 Psay "--> "+cPedido 	                                              
   If SC5->C5_TIPO $ "N/C/I/P"
		@ nLin, 047 Psay "Cliente --> "+cCliente+" - "+"Loja --> "+cLoja+" "+_cRazSoc
	ElseIf SC5->C5_TIPO $ "D/B"
		@ nLin, 047 Psay "Fornec --> "+cCliente+" - "+"Loja --> "+cLoja+" "+_cRazSoc
	Endif
Elseif CB7->CB7_ORIGEM == "2" // Nota Fiscal de Saida   
	@ nLin, 000 Psay "Nota Fiscal"
   @ nLin, 020 Psay "--> "+cNota+" - Serie --> "+cSerie
	If SC5->C5_TIPO $ "N/C/I/P"
		@ nLin, 047 Psay "Cliente --> "+cCliente+" - "+"Loja --> "+cLoja+" "+_cRazSoc
	ElseIf SC5->C5_TIPO $ "D/B"
		@ nLin, 047 Psay "Fornec --> "+cCliente+" - "+"Loja --> "+cLoja+" "+_cRazSoc
	Endif
Elseif CB7->CB7_ORIGEM == "3" // Ordem de Producao   
	@ nLin,000 Psay "Ordem de Producao"
   @ nLin,020 Psay "--> "+cOP
Endif                             

nLin+= 2                      
@ nLin,000 Psay "Transportadora "
@ nLin,020 Psay "--> "+SA4->A4_COD+" "+Alltrim(SA4->A4_NREDUZ)

nLin+= 2
@ nLin,000 Psay "Status "
@ nLin,020 Psay "--> "+cStatus

@ ++nLin, 000 Psay Replicate("=",132)

nLin+= 1 
@nLin, 000 Psay "Produto"
@nLin, 016 Psay "Descricao"
@nLin, 048 Psay "Marca"	   
@nLin, 054 Psay "Armazem" 
@nLin, 063 Psay "Endereco" 
@nLin, 079 Psay "Qtd Original"
@nLin, 092 Psay "Sld Separar" 
@nLin, 105 Psay "Sld Embalar"

CB8->(DbSetOrder(1))
CB8->(DbSeek(xFilial("CB8")+cOrdSep))

While ! CB8->(EOF()) .and. (CB8->CB8_ORDSEP == cOrdSep)      	
   nLin++
   If nLin > 59 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 06
	   @nLin, 000 Psay "Produto"
      @nLin, 016 Psay "Descricao"
      @nLin, 048 Psay "Marca"	   
   	@nLin, 054 Psay "Armazem"
		@nLin, 063 Psay "Endereco"
		@nLin, 079 Psay "Qtd Original"
   	@nLin, 092 Psay "Sld Separar"
  	   @nLin, 105 Psay "Sld Embalar"
	Endif		

	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+CB8->CB8_PROD,.T.)) // Posiciona no 1o.reg. satisfatorio   

	@nLin, 000 Psay CB8->CB8_PROD
   @nLin, 016 Psay Alltrim(SB1->B1_DESC)
   @nLin, 048 Psay Alltrim(SB1->B1_X_MARCA)
   @nLin, 054 Psay CB8->CB8_LOCAL
	@nLin, 063 Psay CB8->CB8_LCALIZ
	@nLin, 079 Psay CB8->CB8_QTDORI Picture "@E 999,999.99"
	@nLin, 092 Psay CB8->CB8_SALDOS Picture "@E 999,999.99"
	@nLin, 105 Psay CB8->CB8_SALDOE Picture "@E 999,999.99"	
   CB8->(DbSkip())
Enddo	

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza impressao                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function Fim()

SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RetStatusบ Autor ณ Anderson Rodrigues บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela funcao Imprime                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RetStatus(cStatus)

Local cDescri:= " "

If Empty(cStatus) .or. cStatus == "0"
	cDescri:= "Nao iniciado"
ElseIf cStatus == "1"
	cDescri:= "Em separacao"
ElseIf cStatus == "2"
	cDescri:= "Separacao finalizada"
ElseIf cStatus == "3"
	cDescri:= "Em processo de embalagem"
ElseIf cStatus == "4"
	cDescri:= "Embalagem Finalizada"
ElseIf cStatus == "5"
	cDescri:= "Nota gerada"
ElseIf cStatus == "6"
	cDescri:= "Nota impressa"
ElseIf cStatus == "7"
	cDescri:= "Volume impresso"
ElseIf cStatus == "8"
	cDescri:= "Em processo de embarque"
ElseIf cStatus == "9"
	cDescri:=  "Finalizado"
EndIf

Return(cDescri)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ CriaPerg2 บ Autor ณ Anderson Rodrigues บ Data ณ  29/10/04   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja    บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaPerg2()

Local cAlias:= Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AAdd(aRegs,{cPerg,"01","Ordem de Separacao De      ?","Ordem de Separacao De      ?","Ordem de Separacao De      ?","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CB7"}) 
AAdd(aRegs,{cPerg,"02","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CB7"}) 
AAdd(aRegs,{cPerg,"03","Data de Emissao De         ?","Data de Emissao De         ?","Data de Emissao De         ?","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AAdd(aRegs,{cPerg,"04","Data de Emissao Ate        ?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AAdd(aRegs,{cPerg,"05","Considera Ordens encerradas?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch5","N",01,00,1,"C","","mv_par05","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""}) 
AAdd(aRegs,{cPerg,"06","Imprime codigo de barras   ?","Imprime codigo de barras   ?","Imprime codigo de barras   ?","mv_ch6","N",01,00,1,"C","","mv_par06","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","",""}) 
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(cAlias)
Return