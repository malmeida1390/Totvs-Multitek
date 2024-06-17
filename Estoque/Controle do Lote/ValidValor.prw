#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ValidValor³ Autor ³                       ³ Data ³14.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Uso no Valid do Campo C6_PRVEN                              ³±±                                  
±±³          ³Tem como Objetivo ajustar o Preco Unitario com o preco      ³±±
±±³          ³de Venda Evitando Disconto quando o usuario estiver envia   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ValidValor()
                        

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
Local _nPRCVEN    :=IIF(TYPE("M->C6_PRCVEN")   <>"U",&("M->C6_PRCVEN")    ,aCols[n][nPRCVEN] )

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
// Tratamento de Envio da Matriz para Almoxarifados Fechados
////////////////////////////////////////////////////////////////////////////////////////

If   cFilAlmox $ cArmaFech

    aCols[n][nPRUNIT] = _nPRCVEN

Endif


If  !(cFilAlmox $ cArmaFech)
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Tratamento de Envio da Matriz para qualquer almoxarifados de Fechado
	// Sempre que estiver enviando para uma filial o parametro SA1->A1_X_ALMOX estara preenchido
	////////////////////////////////////////////////////////////////////////////////////////
	
	If   CFILANT = '01'  .and.  (!Empty(SA1->A1_X_ALMOX))
		

        aCols[n][nPRUNIT] = _nPRCVEN

	Endif
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Tratamento de retorno de almoxarifados(Filiais) diferente de Fechado
	////////////////////////////////////////////////////////////////////////////////////////
	
	If   CFILANT # '01'  .and. alltrim(SA1->A1_CGC) $ "49093834000188"

        aCols[n][nPRUNIT] = _nPRCVEN
		
	Endif
	
Endif



Return(lRet)