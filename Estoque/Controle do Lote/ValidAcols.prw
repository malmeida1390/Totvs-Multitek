#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidAcols³ Autor ³                       ³ Data ³14.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ValidUser utilizados nos campos C6_PRODUTO e C6_QTDVEN.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ValidAcols()
Local lRet         :=.T.
Local cProcName    := FunName()             
Local lBrowDev     :=.F.
Local II           := 0
Local nY           := 0
Local nPRODUTO     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" }) 
Local nQTDVEN      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" }) 
Local nPRUNIT      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT" }) 
Local nPRCVEN      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN" })
Local nVALOR       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR" }) 
Local nLocal       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL" }) 
Local cProduto     := Acols[n][NPRODUTO]
Local cArmaFech    := GetMv("MV_ARMFECH")
Local _cProduto    :=IIF(TYPE("M->C6_PRODUTO")  <>"U",&("M->C6_PRODUTO")   ,aCols[n][nPRODUTO] )
Local _cLocal      :=IIF(TYPE("M->C6_LOCAL")    <>"U",&("M->C6_LOCAL")     ,aCols[n][nLocal] )
Local _nQTDVEN     :=IIF(TYPE("M->C6_QTDVEN")   <>"U",&("M->C6_QTDVEN")    ,aCols[n][nQTDVEN] )
Local cFilAlmox    := ""
        
dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX) 
			cFilAlmox := SA1->A1_X_ALMOX
	    Endif 
	Endif    
Endif


DbSelectArea("SB2")
DbSetOrder(1)
DBSeek(xFilial("SB2")+_cProduto+_cLocal)

DbSelectArea("SB1")
DbSetOrder(1)
DBSeek(xFilial("SB1")+_cProduto)
                                   


////////////////////////////////////////////////////////////////////////////////////////
// Tratamento para retorno de Almoxarifados Fechados
////////////////////////////////////////////////////////////////////////////////////////


// Durante o processo de ALTERACAO do Pedido de Venda e analizado.
// se os campos que estao sendo alterados tem permisao do sistema.
If  Altera .and. cFilAnt $ cArmaFech
	
	Aviso("ATENCAO", "O Cod. do Produto e a Quantidade desta Nota nao podem ser "+;
	"alterados em funcao de se tratar de uma NF de Remessa para a Matriz. Fica como procedimento Excluir a Nota de Devolucao e Incluir "+;
	"novamente.",{"&Ok"})
	
	lRet := .f.
	
	
ElseIf  Inclui .and. M->C5_TIPO = "N" .and.  cFilAnt $ cArmaFech .and. !l410Auto
	

	
	For nY:=1 to Len(acols)
		
		If !aCols[nY][len(aHeader)+1]
			
			If aCols[nY][nProduto] = cProduto .and. nY != n
				
				Aviso("ATENCAO", "Ja consta este produto nesta mesma Nf de Remessa para a Matriz."+;
				" Esta rotina nao suporte itens repetidos.",{"&Ok"})
				
				lRet := .f.
				
			Endif
			
		Endif
		
	Next nY
	
Endif


////////////////////////////////////////////////////////////////////////////////////////
// Tratamento de Envio da Matriz para Almoxarifados Fechados
////////////////////////////////////////////////////////////////////////////////////////



If  lRet .and. cFilAlmox $ cArmaFech

    aCols[n][nPRUNIT] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // ENVIA O PRODUTO PARA O ALMOX. FECHADO COM O CUSTO
    aCols[n][nPRCVEN] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // DO ARMAZEM.
    aCols[n][nVALOR]  = NOROUND(_nQTDVEN * ROUND(SB2->B2_CM1,2),2) //SB1->B1_X_CTSTD

Endif


//If  !(cFilAlmox $ cArmaFech)
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Tratamento de Envio da Matriz para qualquer almoxarifados de Fechado
	// Sempre que estiver enviando para uma filial o parametro SA1->A1_X_ALMOX estara preenchido
	////////////////////////////////////////////////////////////////////////////////////////
	
	If   CFILANT = '01'  .and.  (!Empty(SA1->A1_X_ALMOX))
		
		aCols[n][nPRUNIT] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // ENVIA O PRODUTO PARA O ALMOX. FECHADO COM O CUSTO
		aCols[n][nPRCVEN] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // DO ARMAZEM.
		aCols[n][nVALOR]  = NOROUND(_nQTDVEN * ROUND(SB2->B2_CM1,2),2) //SB1->B1_X_CTSTD
		
	Endif
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Tratamento de retorno de almoxarifados(Filiais) diferente de Fechado
	////////////////////////////////////////////////////////////////////////////////////////
	
	If   CFILANT # '01'  .and. alltrim(SA1->A1_CGC) $ "49093834000188"
		
		aCols[n][nPRUNIT] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // ENVIA O PRODUTO PARA O ALMOX. FECHADO COM O CUSTO
		aCols[n][nPRCVEN] = ROUND(SB2->B2_CM1,2)            //SB1->B1_X_CTSTD  // DO ARMAZEM.
		aCols[n][nVALOR]  = NOROUND(_nQTDVEN * ROUND(SB2->B2_CM1,2),2) //SB1->B1_X_CTSTD
		
	Endif
	
///Endif

Return (lRet)

