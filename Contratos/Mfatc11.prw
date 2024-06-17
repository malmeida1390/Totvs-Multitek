#include "rwmake.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MFATC11  ³ Autor ³                       ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera todos os arquivos em formato texto relativos ao       ³±±
±±³          ³ Contrato em um Local especifico.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MFATC11(cAlias,nReg,nOpcx)
                                 
Local   nOpc          := 0 

Private cNum          := SZ6->Z6_NUM
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := SZ6->Z6_NOMCLI
Private cLoja         := SZ6->Z6_LOJA
Private cDiretorio    := GETMV("MV_DIRTXT")
Private cArqTmp       := ""
Private oDlg


@ 100,050 TO 305,450 DIALOG oDlg TITLE "Gerar contrato em Arquivo Txt"
@ 005,005 SAY "Esta rotina gera uma copia dos itens do contrato em um Arquivo Txt." SIZE 160,7

@ 025,005 SAY "Cod. Contrato    : "                                  SIZE 160,7
@ 035,005 SAY "Cliente/Loja     : "                                  SIZE 160,7
@ 045,005 SAY "        Nome     : "                                  SIZE 160,7

@ 065,005 SAY "Diretorio Destino: "                                  SIZE 160,7


@ 025,060 GET cNum        VALID VALCONTR(M->cNum)
@ 035,060 GET cCliente    WHEN .F.
@ 035,090 GET cLoja       WHEN .F.
@ 045,060 GET cNome       WHEN .F.

@ 065,060 GET cDiretorio  WHEN .F.  


@ 085,100 BMPBUTTON TYPE 01 ACTION (nOpc := 1,oDlg:End())
@ 085,135 BMPBUTTON TYPE 02 ACTION (nOpc := 2,oDlg:End())		//, lContinua:= "N")

ACTIVATE DIALOG oDlg CENTERED


If nOpc == 1

   Processa({||Gertxt()})

Endif

Return
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GerTXT   ³ Autor ³ Marcos Quebralha      ³ Data ³ 20/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera em modo texto, todos os arquivos definidos no array.  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico KODAK                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION GERTXT()
Local   cArquivo      := ""
Local   cArqexp       := ""
Local   cArqori       := "" 
Local   aStru         := {} 
Local   nTamanho      := 0
Local   nSpace        := 0          
Local   cConteudo     := ""                        

Local   oExcelApp
             
Private aHeader	      := {}
Private aCols 	      := {}

Private cNum          := SZ6->Z6_NUM   
Private cCliente      := SZ6->Z6_CLIENTE
Private cNome         := POSICIONE("SA1",1,xFilial("SA1")+SZ6->Z6_CLIENTE+SZ6->Z6_LOJA,"A1_NREDUZ")
Private cLoja         := SZ6->Z6_LOJA
Private dDtElabo      := dtoc(SZ6->Z6_DTELABO)
Private dDtValid      := dtoc(SZ6->Z6_DTVALID)
Private dDtAprov      := dtoc(SZ6->Z6_DTAPROV)
Private dDtEncer      := dtoc(SZ6->Z6_DTENCER)   
Private cCondpag      := SZ6->Z6_CONDPAG 
Private cVend1        := SZ6->Z6_VEND1
Private cTransp       := SZ6->Z6_TRANSP  
Private nFrete        := str(SZ6->Z6_X_FRETE,8,2)  
                          
Private cIndCOm       := IIf(SZ6->Z6_X_ST_CI = "I","Industria","Consumo")

Private	nPrentab  := 0 // Utilizadas pela funcao U_MediaRent
Private	nRrentab  := 0 // Utilizadas pela funcao U_MediaRent 

Private	_cStatus   := "L"
Private _xMargE     := 0
Private _xMargV     := 0
Private _xMargA     := 0
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera Diretorio caso nao Exista                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !File(cDiretorio)
	MontaDir(cDiretorio)
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define nome do Arquivo a Ser Gerado e Local                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqori:= cNum                  
cArqexp:= cDiretorio+"C"+cArqori+".TXT" 	// "\<Diretorio>\<nome do Arquivo>.TXT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Arquivo Dbf Temporario                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTmp:= cDiretorio+"C"+cArqori+".DTC"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o aHeader e o Acols com base na Visualizacao                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
U_MMONTA(2/*nOpcx*/)

// Seram utilizadas na chamada do U_MEDIARENT
_xMargE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})           // "% Rentab. "
_xMargV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})            // "% Rentab. "
_xMargA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})            // "Avaliacao"
 

//For nY := 1 to Len(Acols)       
    //1. Calcula nova Rentabilidade durante a substituicao
    //   do item de contrato
  //  U_CalcSim2(n,lValid,.T.,"U_MFATC11")
//Next
// A funcao abaixo retorna as variaveis abaixo preenchidas.
// nPrentab  := 0 // Utilizadas pela funcao U_MediaRent
// nRrentab  := 0 // Utilizadas pela funcao U_MediaRent 
U_MediaRent(NIL,NIL,"CC")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia Processo de Geracao de Arquivo temporario apos Txt               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Incproc("Gerando Arquivo: "+cArqexp) 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Com base no aHeader monto a Strutura do DTC                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
For nY := 1 to Len(aHeader)                   
    // Analiso o tamanho campo e tamanho do Titulo e sempre fica valendo o maior 
    nTamanho:=IIF(LEN(aHeader[nY][1])>aHeader[nY][4],LEN(aHeader[nY][1]),aHeader[nY][4])
    AADD(aStru  ,{aHeader[nY][2],"C" ,nTamanho, 0} ) 
Next
cArquivo:=CriaTrab(aStru,.T.)
DbUseArea(.T.,, cArquivo, "TRB01", .F., .F.)
dbSelectArea("TRB01")
Copy stru to &cArqTmp        // Copia somente a Extrutura do DTC (Gerando Vazio)
//Copy To &cArqexp SDF       // Copia strutura e conteudo (Copia Inteira)formato TEXTO
//Copy To &cArqTmp           // Copia strutura e conteudo (Copia Inteira)formato DTC
TRB01->(DBCLOSEAREA())      // Fecha o arquivo
Ferase(cArquivo)             // Deleta o Arquivo 

Use &cArqTmp  Alias TRB New  // Agora irei somente trabalhar com a Copia 
DbSelectArea("TRB")         

Reclock("TRB",.T.)      // Pula Linha ou Registro
TRB->(MsUnLock())

                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Cabecalho.                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reclock("TRB",.T.)
TRB->(FieldPut(02,"N.Contrato"))
TRB->(FieldPut(03,cNum))
TRB->(FieldPut(05,"Cliente"))
TRB->(FieldPut(06,cCliente+cLoja))
TRB->(FieldPut(08,"Nome"))
TRB->(FieldPut(09,cNome))
TRB->(FieldPut(10,"Cond.Pgto"))
TRB->(FieldPut(11,cCondpag))
TRB->(MsUnLock())


Reclock("TRB",.T.)
TRB->(FieldPut(02,"Dt.Elebo"))
TRB->(FieldPut(03,dtoc(dDtElabo)))
TRB->(FieldPut(05,"Dt.Valid"))
TRB->(FieldPut(06,dtoc(dDtValid)))
TRB->(FieldPut(08,"Ind./Cons."))
TRB->(FieldPut(09,cIndCOm))
TRB->(FieldPut(10,"Vend.Interno"))
TRB->(FieldPut(11,cVend1))
TRB->(FieldPut(13,"Transp"))
TRB->(FieldPut(14,cTransp))
TRB->(MsUnLock())


Reclock("TRB",.T.)
TRB->(FieldPut(02,"Frete"))
TRB->(FieldPut(03,str(nFrete,8,2)))
TRB->(FieldPut(05,"% M.Rent."))
TRB->(FieldPut(06,STR(nPrentab,8,2)))
TRB->(FieldPut(08,"R$ M.Rent."))
TRB->(FieldPut(09,STR(nRrentab,8,2)))
TRB->(FieldPut(10,"Status"))
TRB->(FieldPut(11,_cStatus))
TRB->(MsUnLock())


Reclock("TRB",.T.)          // Pula Linha ou Registro
TRB->(MsUnLock())


Reclock("TRB",.T.)          // Pula Linha ou Registro
TRB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gero o cabecalho dos itens                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reclock("TRB",.T.)
For nY := 1 to Len(aHeader)                        
    // Analiso o tamanho campo e tamanho do Titulo e sempre fica valendo o maior 
    nTamanho:= IIF(LEN(aHeader[nY][1])>aHeader[nY][4],LEN(aHeader[nY][1]),aHeader[nY][4])
    // Efetua alinhamento para esquerda nos titulos.
    nSpace  := nTamanho - Len(alltrim(aHeader[nY][1]))
	TRB->(FieldPut(FieldPos(Trim(aHeader[nY][2])),Space(nSpace)+alltrim(aHeader[nY][1])))
Next nY
TRB->(MsUnLock())

Reclock("TRB",.T.)      // Pula Linha ou Registro
TRB->(MsUnLock())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o Trb com as informacoes gravadas no acols.     |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(Acols)
	Reclock("TRB",.T.)
	For nY := 1 to Len(aHeader)
        // Analiso o tamanho campo e tamanho do Titulo e sempre fica valendo o maior 
        nTamanho:=IIF(LEN(aHeader[nY][1])>aHeader[nY][4],LEN(aHeader[nY][1]),aHeader[nY][4])
		if aHeader[nY][8] = "N" .and. aCols[nX][nY] = nil
			aCols[nX][nY]:=0
		Endif
		   If aHeader[nY][8] = "D" 
			  cConteudo:=DTOC(aCols[nX][nY])
		   ElseIf aHeader[nY][8] = "N"                              		              // tamanho , decimais
			  cConteudo:=STR(aCols[nX][nY],nTamanho,aHeader[nY][5])
		   Else
			  cConteudo:=aCols[nX][nY]
		   Endif
           // Alinha o conteudo do lado esquerdo
           nSpace  := nTamanho - LEN(alltrim(cConteudo))
		   TRB->(FieldPut(FieldPos(Trim(aHeader[nY][2])),Space(nSpace)+alltrim(cConteudo)))
	Next nY
	TRB->(MsUnLock())
Next nX

DbselectArea("TRB")
TRB->(DbCloseArea())
//Copy To &cArqexp SDF  Gera o Txt
//Ferase(cArqTmp)
//OpenFile(SubStr(cNumEmp,1,2))

	
//	CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , _cPath , .T. )

Aviso("ATENCAO", "Arquivo DTC Gerado em : "+chr(13)+chr(13)+cArqTmp,{"&Ok"})

/*
If ! ApOleClient( 'MsExcel' )
	MsgStop( "MsExcel nao instalado" )
	Return
EndIf
	
oExcelApp:= MsExcel():New()         
oExcelApp:WorkBooks:Open(cArqTmp)   // Abre uma planilha
oExcelApp:SetVisible(.T.)
*/

Return




/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VALCONTR ³ Autor ³                       ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao do Contrato                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Multitek                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Valcontr(cContr)
Local lRet := .T.  

DbSelectArea("SZ6")
DbSetOrder(1)
If DbSeek(xFilial("SZ6")+cContr)

   cCliente      := SZ6->Z6_CLIENTE
   cNome         := SZ6->Z6_NOMCLI
   cLoja         := SZ6->Z6_LOJA

Else

   Aviso("ATENCAO", "Contrato nao Cadastrado",{"&Ok"})
   lRet := .F.

Endif

Return(lRet)