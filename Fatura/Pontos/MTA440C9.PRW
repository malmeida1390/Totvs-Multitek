#INCLUDE "Rwmake.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA440C9  ºAutor  ³                    º Data ³  30/04/2004 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³Gravar informacoes no SC9 Durante Liberacao                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Multitek                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA440C9
Local _areaAll:=GetArea()
Local _areaSB1:=GetArea("SB1")
Local _cNome  :=""
 
SB1->(DbSelectArea("SB1"),DbSetOrder(1),dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
SF4->(DbSelectArea("SF4"),DbSetOrder(1),Dbseek(xFilial("SF4")+SC6->C6_TES))
SCJ->(DbSelectArea("SCJ"),DbSetOrder(1),Dbseek(xFilial("SCJ")+SC5->C5_X_NUM)) 

If  SC5->C5_TIPO $ 'D|B'
    _cNome := POSICIONE("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NREDUZ")
Else
    _cNome := POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")
Endif


If SC5->C5_TIPO $ "I/C/P"               // Estes itens nao devem gerar ordem de separacao devido 
   SC9->C9_ORDSEP:="XXXXXX"             // tratar de Notas Fiscais de Complemento de Ipi, Icm e Preco
Endif
if SF4->F4_ESTOQUE <> "S"               // Este item nao deve gerar ordem de separacao
   SC9->C9_ORDSEP:="XXXXXX"  
Endif
SC9->C9_X_DESCR := SB1->B1_DESC         // Nao foi possivel criar estes campos como Virtuais em funcao da 
SC9->C9_X_NOME  := _cNome               // necessidade de durante a geracao da ordem de producao os virtuais 
SC9->C9_X_ENTRE := SC5->C5_X_DTPRE      // nao se tornarem visiveis. Tal fato se da em funcao do objeto utilizado 
SC9->C9_X_COTCL := SCJ->CJ_COTCLI       // durante a apresentacao da ordem de producao ser um MarkBrowse
SC9->C9_X_VEND1 := SC5->C5_VEND1        // Filtra por vendeor na Liberadao do pedido
SC9->C9_X_PRODU := SC6->C6_X_PRODU      // Filtra por vendeor na Liberadao do pedido
SB1->(RestArea(_areaSB1))
RestArea(_areaAll)                                           


RETURN