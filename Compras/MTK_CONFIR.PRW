#include "RWMAKE.CH"
#include "colors.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTK_CONFIRบAutor  ณ                    บ Data ณ  02/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela utilizada para gravar a data de confirmacao do produto บฑฑ
ฑฑบ          ณna SC.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMultitek                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MTK_CONFIR()
            

Local aFixe     := {{ "Numero do PC","C7_NUM    " },;		//"Numero do PC"
	{ "Data Emissao","C7_EMISSAO" },;		//"Data Emissao"
	{ "Fornecedor  ","C7_FORNECE" } }		//"Fornecedor  "
Local aCores    := {{ 'C7_TIPO!=nTipoPed'	, 'BR_PRETO' },; 	//Autorizacao de Entrega ou Pedido
	{ '!Empty(C7_RESIDUO)' , 'BR_CINZA'},;		//Eliminado por Residuo
	{ 'C7_CONAPRO=="B".And.C7_QUJE < C7_QUANT' , 'BR_AZUL'},;	//Bloqueado
	{ 'C7_QUJE==0'   		  , 'ENABLE'},;					//Pendente
	{ 'C7_QUJE<>0.And.C7_QUJE<C7_QUANT', 'BR_AMARELO'},;	//Pedido Parcialmente Atendido
	{ 'C7_QUJE>=C7_QUANT', 'DISABLE'} }						//Pedido Atendido


PRIVATE nTipoPed := 1
Private l120Auto    := .f.
Private nomeprog    := "MTK_CONFIRMA"
Private cString     := ""
Private cCadastro   := "MTK - Pedido de Compras - Alteracao da Data de Confirmacao"
Private _cAlias     := "SC7"
Private aRotina     := { {"Pesquisar"    ,"AxPesqui"     ,0,1 } ,;
{"Visualizar"    ,"A120PEDIDO"      ,0,2 } ,;
{"Alterar Data"  ,"U_fDtConf()"    ,0,3 } ,;
{"Legenda"       ,"A120Legend"     , 0 , 2}}


dbSelectArea(_cAlias)
dbSetOrder(1)

mBrowse( 6, 1,22,75,"SC7",aFixe,,,,,aCores)

Return


*------------------------
User Function fDtConf()

Private  _dDataConf      := SC7->C7_X_DTCON
Private  oDlg


SA2->(DbSelectArea("SA2"),DbSetOrder(1),DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+SC7->C7_PRODUTO))


@ 100,182 To 400,590 Dialog oDlg Title OemToAnsi( Space(10)+"ALTERACAO DE DADOS DO PEDIDO." )
@ 006,009 To 133,196

@ 014,015 Say "Nr. Pedido  :  "+SC7->C7_NUM     COLOR CLR_HRED
@ 029,015 Say "Fornecedor  :  "+SA2->A2_NREDUZ  COLOR CLR_HRED
@ 044,015 Say "Produto     :  "+SC7->C7_PRODUTO COLOR CLR_HRED

@ 059,015 Say "                 "+SB1->B1_DESC    COLOR CLR_HRED

@ 074,015 Say "Data de Confirmacao:"
@ 074,120 Get _dDataConf Size 50,7

@ 100,110 BmpButton Type 1 Action GravaConf()
@ 100,150 BmpButton Type 2 Action Close(oDlg)

Activate Dialog oDlg Centered

Return




//*-----------------------
Static Function GravaConf()

aGetArea:=GetArea()             

DbSelectArea("SB1")
DbSetorder(1)
DbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
Close(oDlg)

If ALLTRIM(SB1->B1_ORIGEM) $ ("0|2|3|5|7")
   RecLock("SC7",.f.)
   SC7->C7_X_DTCON   	:=	 _dDataConf
   SC7->( MsUnLock() )
Else
   Aviso("ATENCAO", "A confirmacao da data nao e possivel em produtos importados Origem 1",{"&Ok"})
Endif
        
RestArea(aGetArea)
Return
    



/*
User Function ALM()

DbSelectArea("SC7")
DbGotop()

While !SC7->(EOF())

		DbSelectArea("SB1")
		DbSetorder(1)
		IF DbSeek(xFilial("SB1")+SC7->C7_PRODUTO)

		   If ALLTRIM(SB1->B1_ORIGEM) $ ("1")
			   RecLock("SC7",.f.)
   			SC7->C7_X_DTCON   	:=	 CTOD("")
			   SC7->( MsUnLock() )
         Endif

      Endif
      
      SC7->(DBSKIP())

Enddo
      
Return






User Function AjustaD
     
Private cEmpImp     := "01", cFilImp := "01"

//*******************************************************/
//                                                       //
//       Iniciando o La็o de Filiais                     //
//                                                       //
//*******************************************************//
//ConOut("**********************************************************")
//ConOut("**                  Preparando Ambiente                 **")
//ConOut("**********************************************************")

//PREPARE ENVIRONMENT EMPRESA cEmpImp FILIAL cFilImp TABLES "SX6","SCJ","SCK","SB1","SC7"

/*
		"SD2","SF4","SE2","SE1","SEF","SL1","SE5","SE3","SD3","SG1","SF5","SFC",;
		"SA3","SA6","SLF","SC1","SC7","SC9","SC6","SC5","SF4","SE4",;
		"SB2","SB1","SM0","PZ1","PZ2","PZ3","PZ4","PZ5","SFB",;
		"SZ2","SZ3","SBM","SZ5","Z01","Z02","Z03","Z04","Z05","Z06","Z07",;
		"Z08","Z09","Z10","SZA","SZH","SZ9"

ConOut("**********************************************************")
ConOut("**Iniciando Processo de Analise de Validade do Orcamento**")
ConOut("**********************************************************")


U_ALM()


ConOut("**********************************************************")
ConOut("**Finalizando Proc.  de Analise de Validade do Orcamento**")
ConOut("**********************************************************")

RESET ENVIRONMENT

Return
*/
