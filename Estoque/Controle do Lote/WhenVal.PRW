#INCLUDE "MATA410.CH"
#INCLUDE "FIVEWIN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³WhenVal   ³ Autor ³                       ³ Data ³14.05.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³O campo preco de venda durante o envio para o ALMOX.        ³±±
±±³          ³FECHADO nao pode ser alterado o mesmo deve assumir          ³±±
±±³          ³o custo B1_X_CSTD                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function WhenVal()
Local lRet         :=.T.
Local cProcName    := FunName()             
Local lBrowDev     :=.F.
Local II           := 0
Local cArmaFech    := GetMv("MV_ARMFECH")
Local cFilAlmox    := ""

Local nPRCVEN      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN" })
Local _nPRCVEN    :=IIF(TYPE("M->C6_PRCVEN")   <>"U",&("M->C6_PRCVEN")    ,aCols[n][nPRCVEN] )

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI)
	If SA1->(FieldPos("A1_X_ALMOX")) > 0
		If !Empty(SA1->A1_X_ALMOX) 
			cFilAlmox := SA1->A1_X_ALMOX
	    Endif 
	Endif    
Endif
            

if cFilAlmox $ cArmaFech      

   lRet := IiF(EMPTY(_nPRCVEN),.T.,.F.)

Endif


Return (lRet)

     

  
 