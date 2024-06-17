#include "protheus.ch"
#INCLUDE "SIGA.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "VKEY.CH"


#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE X_DATA  					1
#DEFINE X_ORIGM   		         	2                                             
#DEFINE X_NREDUZ 					3
#DEFINE X_VRUNIT                    4
#DEFINE X_MARGE     				5
#DEFINE X_ICM        		        6
#DEFINE X_MUN                       7
#DEFINE X_EST                       8
#DEFINE X_QTDE  					9
#DEFINE X_VRTOTAL   			   10
#DEFINE X_MARGV     			   11
#DEFINE X_IPI   				   12
#DEFINE X_NF                       13
#DEFINE X_SERIE                    14


#DEFINE Y_DATA  					1
#DEFINE Y_NREDUZ 					2
#DEFINE Y_VRUNIT                    3
#DEFINE Y_MARGE     				4
#DEFINE Y_ICM        		        5
#DEFINE Y_MUN                       6
#DEFINE Y_EST                       7
#DEFINE Y_QTDE  					8
#DEFINE Y_VRTOTAL   			    9
#DEFINE Y_MARGV     			   10
#DEFINE Y_IPI   				   11
#DEFINE Y_PEDIDO                   12
#DEFINE Y_NUM     				   13


#DEFINE X_ENCARGO         	        1
#DEFINE X_VALORITEM       		    2
#DEFINE X_ACUMULADO                 3

#define GD_INSERT 1
#define GD_UPDATE 2
#define GD_DELETE 4
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MFATCO1   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Simulador de Vendas                                         ���
���          �SCJ - Cabacalho do Orcamento                                ���
���          �SCK - Itens do Orcamento                                    ���
���          �                                                            ���
���Parametros�TMP1 - Que e aCols de onde serao extraidas e retornadas     ���
���          �       todas as informacoes.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MFATC01()

Local aGetArea    := GetArea()
Local cCadastro   := "Simulador"

Local cLocal      := 01
Local nOpc        := 3          // Nao trocar caso contrario comecara a
Local nOpcA 	  := 0          // incluir linhas no acols.
Local nCntFor	  := 0
Local bSetKey4
Local bSetKey9
Local bSetKey11
Local bSetKey12

Local nY          := 0
Local nLin        := 0
//Local nTotal      := 0

Local aSize       := {}
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aPosGet     := {}
Local aSizeAut	  := MsAdvSize(,.F.)

Local aAltGr	  := {}

Local oFntFecha,oFntFecha1,oFntFecha2,oFntFecha3,oFntFecha4,oFntFecha5
Local II          := 0
Local lMFATC08    :=.f.
Local _lDelet     :=.f.

Local lAjusTel    := .f.

Local cTexto      :=""
Local nPosTexto   := 0

Local oDlg
Private oGet


Private aPrVenda  := {}
Private lPrVenda  := .F.

If "MATA415" $ Upper(Funname()) // Defido trabalhar com Temporario.
	Private aCols      :={}
	Private n          :=1 
Endif
Private aHeadAux	  :={}
Private aColsAux	  :={}
Private nNAux         :=0
Private aBackRot      := aClone(aRotina)


Private cProcName     := FunName()
Private _dDataIni     := dDataBase - 360
Private _dDataFinal   := dDataBase           // Periodo de Um ano
Private nMaxReg       := GetMv("MV_MAXREGI")   // Maximo de Registros
Private nFiltra       := 1

Private cArqVend      := ""
Private cArqOrca      := ""
Private cIndVend      := ""
Private cIndOrca      := ""
Private aListVend     := {}
Private oListVend

Private aListOrca    := {}
Private oListOrca

Private oTimer
Private nPosicao      := 0


Private lOrigem       := IIF( "MATA415" $ Upper(Funname()),.T.,.F.)


//�������������������������������������������������������������������������Ŀ
//�                 V a r i a v e i s  d e  C a l c u l o s                 �
//�Estas variaveis sao alteradas em tela fora do Acols mas seram utilizadas �
//�nos calculos.                                                            �
//���������������������������������������������������������������������������

Private  oGetCond
Private  oGetDesc
Private  oGetFrete
Private  oGetRent
Private  oGetRenVr

Private  _cIndComer:= IIF( "MATA415" $ Upper(Funname()),M->CJ_X_ST_CI,IIF( UPPER(CJ_X_ST_CI) $ "INDUSTRIA","I",IIF( UPPER(CJ_X_ST_CI) $ "CONSUMO","C","R" )))
Private  _cGetCond := IIF( "MATA415" $ Upper(Funname()),M->CJ_CONDPAG,M->CCONDPAG)
Private  _cCliente := IIF( "MATA415" $ Upper(Funname()),M->CJ_CLIENTE, cCliente   )
Private  _cLoja    := IIF( "MATA415" $ Upper(Funname()),M->CJ_LOJA   , cLoja      )

Private  _cClient := IIF( "MATA415" $ Upper(Funname()),M->CJ_CLIENT  , cCliente   )
Private  _cLojaEnt:= IIF( "MATA415" $ Upper(Funname()),M->CJ_LOJAENT , cLoja      )


Private  _nGetFrete:= IIF( "MATA415" $ Upper(Funname()),M->CJ_X_FRETE,nFrete  )
Private  _nGetDesc := 0               // O usuario pode interagir
Private  _nGetRent := 0               // Resultado dos Calculos
Private  _nGetRenVr:= 0                // Resultado dos Calculos
Private  _cStatus  :="L"

//������������������������������������������������������������������������Ŀ
//�Variaveis utilizadas no posicionamento dos elementos do Acols           �
//��������������������������������������������������������������������������
Private xItem      := 0
Private xRefer     := 0
Private xCDTR      := 0
Private xQtdven    := 0
Private xPreunit   := 0
Private xCtStd     := 0
Private xCTFOB     := 0
Private xItem0     := 0
Private xPrcven    := 0
Private xValor     := 0
Private xMargE     := 0
Private xMargv     := 0
Private xMargA     := 0
Private xPQR       := 0
Private xNeoil     := 0
Private xXYZ       := 0
Private x123       := 0
Private xABC       := 0
Private xLHM       := 0
Private xGiro      := 0
Private xDescont   := 0
Private xIcm       := 0
Private xPis       := 0
Private xCofins    := 0
Private xCpmf      := 0
Private xProduto   := 0
Private xSimil     := 0
Private xEis       := 0
Private xIpi       := 0
Private xTes       := 0
Private xClasFis   := 0
Private xProdCli   := 0
Private xReser     := 0
Private xItemO     := 0
Private xLocal     := 0
Private xLocNome   := 0
Private xDTENT     := 0
Private xObs       := 0
Private xCtPadrao  := 0


Private xNC_IM     := 0
//������������������������������������������������������������������������Ŀ
//�Variaveis Posicionamento do Acols quando origem e Contrato              �
//�O contrato o acols e uma matriz no Orcamento e um Arquivo Tmp1          �
//��������������������������������������������������������������������������
Private	nItem        := 0
Private	nProduto     := 0
Private	nQtdven      := 0
Private	nPrcven      := 0
Private	nTes         := 0
Private  nCtStd       := 0
Private  nCtPadrao    := 0
Private  nCtFOB       := 0
Private	nPrunit      := 0
Private	nValor       := 0
Private	nUm          := 0
Private nRefer       := 0
Private nSufix       := 0
Private nFABRI       := 0
Private nMargE       := 0
Private nMargV       := 0
Private nMargA       := 0
Private nTes         := 0
Private nPis         := 0
Private nCofins      := 0
Private nCpmf        := 0
Private nICM         := 0
Private nIPI	      := 0
Private nProdCli     := 0
Private nPrcRea      := 0
Private nPerrea      := 0

Private nClasFis     := 0
Private nLocal       := 0
Private nLocNome     := 0
Private lUsuLib      := .F. // Usuario Liberado para efetuar Liberacao Manual.

Private nPrcRea      := 0
Private nPerrea      := 0

Private lReplace     := .f.
Private nReser       := 0
Private nItem0       := 0
Private nDtEnt       := 0
Private nObs         := 0


Pergunte("PARSIM"+SPACE(4),.F.)
_dDataIni     := MV_PAR01
_dDataFinal   := MV_PAR02
nMaxReg       := MV_PAR03
nFiltra       := MV_PAR04

//DbSelectArea("SX1")
//DbSetOrder(1)
//IF Dbseek("PARSIM"+SPACE(4)+"04")
//   nFiltra := SX1->X1_PRESEL	
//Endif


//������������������������������������������������������������������������Ŀ
//�Variavel utilizada para armazenar a simulacao.                          �
//��������������������������������������������������������������������������
if Type("aColsSim") = "U"
	Public AcolsSim := {}
	Public aHeadSim := {}
Endif

//������������������������������������������������������������������������Ŀ
//�Posiciona o item no Cadastro de Clientes                                �
//��������������������������������������������������������������������������
DbSelectArea("SA1")
DbSetorder(1)
Dbseek(xFilial("SA1")+_cCliente+_cLoja)


//������������������������������������������������������������������������Ŀ
//�Definie se o Usuario pode Efetuar Liberacao por Rentabilidade Manual.   �
//��������������������������������������������������������������������������
//__cUserId // Vari�vel Publica com o ID do Usu�rio Logado
cNome := UsrRetName(__cUserId)

DbSelectArea("SZC")
DbSetOrder(2)
If Dbseek(xFilial("SZC")+UPPER(ALLTRIM(cNome)))
	lUsuLib      := .T. // Usuario Liberado para efetuar Liberacao Manual.
Endif

//��������������������������������������������������������������Ŀ
//� Muda o valor do aRotina para nao incluir linha na GetDados   �
//����������������������������������������������������������������
If Len(aRotina)<3
	aRotina[3,4] := 6
Else
	PRIVATE aRotina := {{"","",0,1, , .T.},{"","",0,1, , .T.},{"","",0,3, , .T.},{"","",0,6, , .T.}}
EndIf



aHeadAux	  := aClone(aHeader)
aColsAux	  := IIf("MATA415" $ Upper(Funname()) ,  {}              ,aClone(aCols))
nNAux         := Iif("MATA415" $ Upper(Funname()) ,  TMP1->(RECNO()) ,n)

aCols         := {}
aHeader       := {}


DbSelectArea("SE4")
DbSetOrder(1)
if !Dbseek(xFilial("SE4")+_cGetCond)
	If Empty(_cGetCond)
		Aviso("ATENCAO", "Favor digitar a Condicao de Pagamento antes de entrar no Simulador",{"&Ok"})
	Else
		Aviso("ATENCAO", "Condicao de Pagamento "+_cGetCond+" nao Cadastrada.",{"&Ok"})
	Endif
	
	StarVar()	 // Retorna o aHeader/Acols antes de entrar nesta operacao
	
	Return(.T.)
Endif



If "MATA415" $ Upper(Funname())
	
	dbSelectArea("TMP1")
	dbGotop()
	if Eof()
		Aviso("ATENCAO", "Nao existe itens para ativar o Simulador.",{"&Ok"})
		StarVar()	//Retorna o aHeader/Acols antes de entrar nesta operacao
		Return
	Endif
	while !EOF()
		If ( !TMP1->CK_FLAG .And. !Empty(TMP1->CK_PRODUTO)) //.Or.!Empty(TMP1->CK_CLIPROD)) )
			Exit
		Endif
		
		TMP1->(Dbskip())
		
		If Eof()
			Aviso("ATENCAO", "Nao existe itens para ativar o Simulador.",{"&Ok"})
			StarVar() // Retorna o aHeader/Acols antes de entrar nesta operacao
			Return
		Endif
	Enddo
	
	If Empty(M->CJ_X_VEND1) //.and. substr(_n_Mv_Comical,1,1) <> "T"
		Aviso("ATENCAO", "Favor informar o vendedor interno para prosseguir.",{"&Ok"})
		StarVar()	 // Retorna o aHeader/Acols antes de entrar nesta operacao
		Return
	Endif
	
	
ElseIF Upper(Funname()) $ "#MFATC04"
	
	
	//������������������������������������������������������������������������Ŀ
	//� Analisa qual a rotina do contrato esta sendo chamada                   �
	//��������������������������������������������������������������������������
	While !Empty(cProcName)
		If cProcName $ "U_MFATC08"   // Reajuste de Preco
			lMFATC08:=.T.
		Endif
		ii++
		cProcName := UPPER(AllTrim(ProcName(ii)))
	EndDo
	
	nItem     := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_ITEM"})
	nProduto  := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
	nQtdven   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
	nTes      := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_TES"})
	nClasfis  := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_CLASFIS"})
	nLocal    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_LOCAL"})
	nLocNome  := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_LOCNOME"})
	nCtStd    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_CTSTD"})
	nCtPadrao := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_CTPAD"})
	nCTFOB    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_FOB"})
	nPrunit   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
	nValor    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_VALOR"})
	nUm       := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_UM"})
	nRefer    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_REFER"})
	nSufix    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_SUFIX"})
	nFABRI    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_MARCA"})
	nMargE    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	nMargV    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	nMargA    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	
	nPis      := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_PIS"})
	nCofins   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_COFIN"})
	nCpmf     := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_CPMF"})
	nICM      := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_ICM"})
	nIPI	    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_IPI"})
	
	nProdCli  := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PRODCLI"})
	nPrcRea   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PRCREA"})
	nPerrea   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PERREA"})
	nPrcven   := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_PRCVEN"})
	nReser    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_RESER"})
	nItem0    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_ITEM0"})
	nDtEnt    := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_X_DTENT"})
	nObs      := aScan(aHeadAux,{|x| AllTrim(x[2])=="Z6_OBSERVA"})
	
	//��������������������������������������������������������Ŀ
	//�Verifico se todo o acols esta vario ou se todos os itens�
	//�do acols foram deletados.                               �
	//����������������������������������������������������������
	_lDelet :=.T.
	For nY:= 1 to len(aColsAux)
		if  !aColsAux[nY,Len(aHeadAux)+1] .and. !EMPTY(aColsAux[nY,nProduto])
			_lDelet :=.F.
			exit
		Endif
	Next nY
	
	if  len(aColsAux)  = 0 .or. _lDelet
		Aviso("ATENCAO", "Nao existe itens para ativar o Simulador.",{"&Ok"})
		StarVar()	 // Retorna o aHeader/Acols antes de entrar nesta operacao
		Return
	Endif
	
	
Endif



//������������������������������������������������������������������������Ŀ
//�Monta aHeader e aCols                                                   �
//��������������������������������������������������������������������������
aCols         := {}
aHeader       := {}

DbSelectArea("SX3")
DbSetOrder(2)

DbSeek("B1_X_REFER")
AADD(aHeader,{"Produto",X3_CAMPO,X3_PICTURE,X3_TAMANHO+16+4,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_ITEM")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_QTDVEN")
Aadd(aHeader,{Trim(X3Titulo())+"(*)","ALT_QTDVEN",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,SX3->X3_VALID,"",X3_TIPO,"", "" })
DbSeek("CK_X_CTPAD")         //  Custo Padrao ( Nao Alteravel )
AADD(aHeader,{X3_TITULO,X3_CAMPO,                  X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_X_CTSTD")         //  Custo Padrao ( Alteravel )
Aadd(aHeader,{Trim(X3Titulo())+"(*)","ALT_CTSTD",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,"",SX3->X3_TIPO,"", "" })
DbSeek("CK_X_FOB")           //  Custo Fob
AADD(aHeader,{X3_TITULO ,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_X_PRUN")          //  Preco de Tabela
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("Z6_PRCVEN")          //  Preco Simulado (O uso do Z6_PRCVEN se deu em funcao do ck_prcven estar com when .f.
Aadd(aHeader,{Trim(X3Titulo())+"(*)","ALT_PRCVEN",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,"", "" })
DbSeek("CK_VALOR")
AADD(aHeader,{X3_TITULO       ,"ALT_VALOR",       X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("B1_IPI")              //% Ipi(*)
AADD(aHeader,{"% Desc.s/Simulado(*)","ALT_XDES",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("CK_X_MARGE")         //% SLOW
AADD(aHeader,{"% Rent.Slow Mov","ALT_SLOW",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_X_MARGE")          //  "% Rentab. "
AADD(aHeader,{X3_TITULO+"(*)","ALT_MARGE"        ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("CK_X_MARGV")           // "Margem em Valor"
AADD(aHeader,{X3_TITULO      ,"ALT_MARGV",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_X_MARGA")           // "Avaliacao" - NAO PODE SER TRANSFORMADO EM ALT_MARGA POIS DEIXA DE APARECER POR EXTENSO NO ACOLS.
//AADD(aHeader,{X3_TITULO      ,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
DbSeek("C6_X_PRCLI")           //"Codigo SKU   CK_X_PRCLI // ESTA INIBIDO
Aadd(aHeader,{"Cod.Cliente (*)" ,"ALT_PROCL",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,"", "" })
DbSeek("CK_X_RESER")             //"Reserva do Cliente
AADD(aHeader,{"Reserva (*)"      ,X3_CAMPO,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("CK_X_ITEM0")             //"Item da Reserva
AADD(aHeader,{"Item Reserva (*)" ,X3_CAMPO,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("CK_X_ENTRE")
AADD(aHeader,{X3_TITULO+" (*)",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_TIPO,"",""})
DbSeek("CK_OBS")
AADD(aHeader,{X3_TITULO+"(*)",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,"",""})
DbSeek("B1_X_NEOIL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_ABC")
AADD(aHeader,{X3_TITULO+"   ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_LMN")
AADD(aHeader,{X3_TITULO+"   ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_NC_IM")         // Origem
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_GIROQ")
AADD(aHeader,{X3_TITULO+"   ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_PQR")
AADD(aHeader,{X3_TITULO+"   ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_XYZ")
AADD(aHeader,{X3_TITULO+"   ",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_123")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_IPI")              //% Ipi(*)
AADD(aHeader,{X3_TITULO   ,"ALT_IPI"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
AADD(aHeader,{"% Icm"    ,"ALT_ICM"   ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
AADD(aHeader,{"% Pis "    ,"ALT_PIS"   ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
AADD(aHeader,{"% Cofins " ,"ALT_COFINS",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
AADD(aHeader,{"% Cpmf "   ,"ALT_CPMF"  ,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,"",""})
DbSeek("B1_COD")             //"Codigo SKU
AADD(aHeader,{"Cod.SKU MTK " ,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("C6_TES")
AADD(aHeader,{X3_TITULO+" (*)",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,"",""})
DbSeek("C6_CLASFIS")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_LOCAL")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("CK_LOCNOME")
AADD(aHeader,{X3_TITULO,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_X_SIMIL")     //"S.G.Similar  "
AADD(aHeader,{"Similaridade"   ,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})
DbSeek("B1_COD")           //"Codigo SKU
AADD(aHeader,{"EIS"           ,"ALT_EIS" ,X3_PICTURE,21,X3_DECIMAL,,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_CONTEXT})


//������������������������������������������������������������������������Ŀ
//�Posicao dos itens no novo acols                                         �
//��������������������������������������������������������������������������

xRefer     := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_REFER"})
xItem      := aScan(aHeader,{|x| AllTrim(x[2])=="CK_ITEM"})

//xCDTR      := aScan(aHeader,{|x| AllTrim(x[2])=="B1_ORIGEM"})
xQtdven    := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_QTDVEN"})
xCtStd     := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_CTSTD"})           // Custo Stander
xCtPadrao  := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_CTPAD"})          // Custo Padrao nao Alteravel
xCTFOB     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_FOB"})          // Custo Fob
xPreunit   := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_PRUN"})           // Preco de Tabela
xPrcven    := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_PRCVEN"})           // Preco Simulado
xValor     := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_VALOR"})
xMargE     := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_MARGE"})           // "% Rentab. "
xSlow      := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_SLOW"})             // "% Slow. "
xMargV     := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_MARGV"})            // "% Rentab. "
xMargA     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_MARGA"})            // "Avaliacao"
xPQR       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_PQR"})
xNeoil     := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_NEOIL"})
xXYZ       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_XYZ"})
x123       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_123"})
xNC_IM     := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_NC_IM"})
xABC       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_ABC"})
xLHM       := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_LMN"})
xGiro      := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_GIROQ"})
xDescont   := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_XDES"})            //"% Desc Item(*)"
xIpi       := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_IPI"})                //"% Ipi(*)
xIcm       := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_ICM"})             //"% Icm(*)
xPis       := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_PIS"})             //"% Pis(*)
xCofins    := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_COFINS"})          //"% Cofins(*)
xCpmf      := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_CPMF"})            //"% Cpmf(*)
xProduto   := aScan(aHeader,{|x| AllTrim(x[2])=="B1_COD"})                //"Codigo SKU
xSimil     := aScan(aHeader,{|x| AllTrim(x[2])=="B1_X_SIMIL"})            //"S.G.Similar  "
xEis       := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_EIS"})             //"Codigo EIS"
xTES       := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})              //"TES
xClasFis   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})          //"CLASSIFICACAO
xLocal     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_LOCAL"})            //"LOCAL
xLocNome   := aScan(aHeader,{|x| AllTrim(x[2])=="CK_LOCNOME"})           //"NOME DO LOCAL
xProdCli   := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_PROCL"})           //"Codigo do Cliente
xReser     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_RESER"})           //"Codigo da Reserva
xItem0     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_ITEM0"})           //"Codigo do Item da Reserva
xDTENT     := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_ENTRE"})          //"Data de Entrega
xObs       := aScan(aHeader,{|x| AllTrim(x[2])=="CK_OBS"})             //"Observacao


//������������������������������������������������������������������������Ŀ
//�Montagem do Array dos campos  que podem ser alterados                   �
//�e simultaneamente inclui funcao no aHeaeder para refazer calculos.      �
//�Observe que o * esta sendo incluido via programa durante a montagem do  �
//�aheader logo acima.                                                     �
//��������������������������������������������������������������������������
For nCntFor := 2 To Len(aHeader)
	
	If "*" $ aHeader[nCntFor][1]
		If !lMFATC08
			aadd(aAltGr,aHeader[nCntFor][2])
		Else
			If aHeader[nCntFor][2] != "ALT_QTDVEN" // Devido durante o reajuste nao poder alterar a quantidade
				aadd(aAltGr,aHeader[nCntFor][2])
			Endif
		Endif
		
		If aHeader[nCntFor][2] = "ALT_PROCL"
			aHeader[nCntFor][6] :=  "U_ValClie(oGet:oBrowse:nAt,.T.)"
		Elseif aHeader[nCntFor][2] = "CK_X_ENTRE"
			aHeader[nCntFor][6] :=  "U_ValEntre(oGet:oBrowse:nAt,.T.)"
			aadd(aAltGr,aHeader[nCntFor][2])
		Else
			aHeader[nCntFor][6] :=  "U_CalcSim(oGet:oBrowse:nAt,.T.)"
		Endif
	Endif

Next nCntFor



// Campos que seram alteraveis mas nao iram disparar a rotina de calculo.

aadd(aAltGr,aHeader[xClasFis][2])
aadd(aAltGr,aHeader[xLOCAL][2])
aadd(aAltGr,aHeader[xProdCli][2])
aadd(aAltGr,aHeader[xReser][2])
aadd(aAltGr,aHeader[xItem0][2])
aadd(aAltGr,aHeader[xDTENT][2])
aadd(aAltGr,aHeader[xOBS][2])


//��������������������������������������������������������������Ŀ
//�Montagem do ACols                                             �
//�Durante este processo as informacoes podem  vir do orcamento  �
//�SCK que trabalha com arquivo TMP1 ou do Contrato que trab. com�
//�(matriz). Tentei fazer o contrato trabalhar tambem com        |
//� mas o processo de controle e mais complexo inviabilizando|
//�a operacao. Desta forma optei  em trabalhar com acols (matriz)�
//�no contrato pois o desenvolvimento do mesmo sera facilitado.  �
//����������������������������������������������������������������

If  lOrigem
	
	DbSelectArea("TMP1")
	DbGotop()
	
	
	While !TMP1->(eof())
		
		//if !EmptY(TMP1->CK_PRODUTO)  // NAO POSSO FILTRAR CASO CONTRARIO GERA ERRO DURANTE MONTAGEM DO ACOLS
		MontaAcols(lOrigem,TMP1->(RECNO()),@aCols)
		//Endif
		
		TMP1->(DBSKIP())
		
	Enddo
	
Else
	
	For  nY:= 1 to Len(aColsAux)
		
		//if !EmptY(aColsAux[nY][nProduto])  // NAO POSSO FILTRAR CASO CONTRARIO GERA ERRO DURANTE MONTAGEM DO ACOLS
		MontaAcols(lOrigem,nY,@aCols)
		//Endif
		
	Next
	
Endif




//������������������������������������������������������������������������Ŀ
//�Monta a consulta do Produto das ultimas Vendas para este cliente        �
//��������������������������������������������������������������������������
Processa({|| ConsVend(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra)},"Levantando Ultimas Vendas")

//������������������������������������������������������������������������Ŀ
//�Monta a consulta do Produto das ultimas Vendas para este cliente        �
//��������������������������������������������������������������������������
Processa({|| ConsORCA(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra)},"Levantando Orcamentos")


//������������������������������������������������������������������������Ŀ
//�Monta o ListBox com base no Primeiro item                               �
//��������������������������������������������������������������������������
n:=1               
aListVend:=GeraVend(aCols[1][xPRODUTO])

aListORCA:=GeraORCA(aCols[1][xPRODUTO])


//��������������������������������������Ŀ
//� Definicao de Fontes para esta janela �
//����������������������������������������
DEFINE FONT oFntFecha  NAME "TIMES NEW ROMAN" SIZE 19,34 BOLD   //Largura x Altura
DEFINE FONT oFntFecha1 NAME "TIMES NEW ROMAN" SIZE 8,16 BOLD
DEFINE FONT oFntFecha2 NAME "TIMES NEW ROMAN" SIZE 11.5,22 BOLD
DEFINE FONT oFntFecha3 NAME "Ms Sans Serif" BOLD
DEFINE FONT oFntFecha4 NAME "Mono As" SIZE 6,10
DEFINE FONT oFntFecha5 NAME "TIMES NEW ROMAN" SIZE 6,15 BOLD
           

ogetdad:oBrowse:lDisablePaint := .F. // (Nao Mexer nao sei por que motivo mas
// quando esta falso o MsGetDados abaixo
// nao funciona direito)
// Quando vem de outro acols o processo de delecao vem
// desabilitado ou seja nao e possivel ver a cor
// cinza quanto passo .F. e reabilitado.
// Os eventos bDelete,bEditCol,lDisablePaint trabalham juntos.


AAdd( aObjects, { 0,     210, .T., .T. } )
AAdd( aObjects, { 116,   160, .F., .T. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas
AAdd( aObjects, { 0,     020, .F., .F. } )  // Quando coloco .F. Consigo o controle atraves das minhas coordenadas

// Esta matriz contem os limites da tela
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
// Esta matriz retorna a posicao dos objetos em tela ver loja021b
// Objetos Tridimencionais
aPosObj := MsObjSize( aInfo, aObjects )
// Esta matriz retorna a posicao dos gets
// Objetos Bidimencional
aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{195,250}})

// Esta sendo analizada as dimensoes sobre o resultado
// da funcao tamanho de monitor.
lAjusTel := IIf(aSizeAut[3] < 490,.T.,.F.)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF oMainWnd pixel
bSetKey4  :=SetKey(VK_F4 , {|| Consulta()})
bSetKey9  :=SetKey(VK_F9 , {|| lPrVenda:=.T. , U_CalcSim(n,.F.) })
bSetKey11 :=SetKey(VK_F11, {|| CONSPER(xPRODUTO,@_dDataIni,@_dDataFinal,@nMaxReg,@nFiltra,aPosObj,oDlg,oFntFecha2)})
bSetKey12 :=SetKey(VK_F12, {|| LIBMANUAL(oGet:oBrowse:nAt) })     // Liberacao Automatiaca


//oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,,"U_ValAllSim()",,.T.,aAltGr,4/*nFreeze*/)
//oGet:=MSGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpc,,"U_ValAllSim()",,.T.,aAltGr, , .F., 200, , , , , oDlg)

//oGet:= MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],;
//GD_UPDATE+GD_DELETE,"AllwaysTrue","U_ValAllSim()",,aAltGr,4,;
//999,"AllwaysTrue","","AllwaysTrue",oDLG, aHeader, @aCols)
                      
//MsNewGetDados(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight ],
// [ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], [ nFreeze],
// [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] ) 
                                              

////////////  Versao freeze desativado
//oGet:= MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],;
//GD_UPDATE+GD_DELETE,"allwaystrue()",,"",aAltGr,,;
//9999,,,,oDlg,aHeader,@aCols)

////////////  Versao freeze ativo
oGet:= MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],;
GD_UPDATE+GD_DELETE,"allwaystrue()",,"",aAltGr,4,;
9999,,,,oDlg,aHeader,@aCols)
                                             
//AllwaysFalse
//MsNewGetDados(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight ], 
//[ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], 
//[ nFreeze], [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] )
                       
  
//oGet:oBrowse:bDelete :={ || aCols[oGet:oBrowse:nAt,Len(oGet:acols[oGet:oBrowse:nAt])]:=!oGet:aCols[oGet:oBrowse:nAt,Len(oGet:acols[oGet:oBrowse:nAt])],oGet:LinhaOk(),oGet:oBrowse:Refresh(.T.)}
oGet:oBrowse:lDisablePaint := .F.
//oGet:oBrowse:nColPos := 5
                                                             
//oGet:oBrowse:GoDown()
//oGet:oBrowse:nFreeze := 4        // Colunas Congeladas (Quando Ativado Desabilita o Posiconamento de coluna abaixo)
oGet:oBrowse:nColPos := xPrcven  // Posiciona no Preco de Venda
oGet:nMax:=Len(Acols)
                                  
@ aPosObj[2,1],aPosObj[2,2] SAY "VENDAS EFETIVADAS" size 100,8 OF oDlg PIXEL FONT oFntFecha1

@ aPosObj[2,1]+10,aPosObj[2,2]  LISTBOX oListVend FIELDS ;
HEADER "Data",;
"S/C",;
"Cliente",;
" R$ Unit",;
" % Rent.",;
" % Icm",;
"Municipio" ,;
"Uff" ,;
"Qtde",;
" R$ Total",;
" $ Rentab.",;
" % Ipi",;
"Nf" ,;
"Serie";
SIZE  240+70,75;      //aPosObj[2,3]+55,Iif( lAjusTel , aPosObj[2,4] , 85) ; //aPosObj[2,2]+50, 100 ;
COLSIZES 30,;
10,;
55,;   
40,;
25,;
20,;
40,;   
10,;    
30,;
50,;
50,;
20,;
30,;   
30;    
OF oDlg PIXEL


xxPOS:=70

@ aPosObj[2,1],245+xxPOS SAY "ORCAMENTOS GERADOS" size 100,8 OF oDlg PIXEL FONT oFntFecha1

@ aPosObj[2,1]+10,245+xxPOS  LISTBOX oListORCA FIELDS ;
HEADER "Data",;
"Cliente",;
" R$ Unit",;
" % Rent.",;
" % Icm",;
"Municipio" ,;
"Uff" ,;
"Qtde",;
" R$ Total",;
" $ Rentab.",;
" % Ipi",;
"Pedido",;
"Num.Orc",;
SIZE aPosObj[1,4]-315,75;     //SIZE  240+70,80;      //aPosObj[2,3]+55,Iif( lAjusTel , aPosObj[2,4] , 85) ; //aPosObj[2,2]+50, 100 ;
COLSIZES 30,;
55,;   
40,;
25,;
20,;
40,;   
10,;    
30,;
50,;
50,;
20,;
30,;   
30;    
OF oDlg PIXEL

       
U_AtuDisp(aListVend,oListVend,oGet,oTimer,aPosObj,oDlg,oFntFecha2,aListORCA,oListORCA)


xxPOS:=70
yyPOS:=90

@ aPosObj[2,1]+yyPOS,245+xxPOS TO aPosObj[2,3]+yyPOS-70,aPosObj[1,4] OF oDlg PIXEL

@ aPosObj[2,1]+yyPOS+05,255+xxPOS/*aPosGet[1,1]*/ SAY "Condicoes de Pagamento      " size 100,8 OF oDlg PIXEL //FONT oFntFecha5
@ aPosObj[2,1]+yyPOS+05,330+xxPOS/*aPosGet[1,2]*/ MSGET oGetCond  VAR _cGetCond   Picture "@!" F3 "SE4"        Size 60,8 OF oDlg PIXEL  When .t. Valid Val_GetCond(_cGetCond)  //.AND.MAVLDTABPRC(M->CJ_TABELA,_cGetCond)

xxPOS:=230
yyPOS:=90

@ aPosObj[2,1]+yyPOS+05,255+xxPOS/*aPosGet[1,1]*/ SAY "% Desc.Total s/ R$ Simulado " size 100,8 OF oDlg PIXEL //FONT oFntFecha5
@ aPosObj[2,1]+yyPOS+15,255+xxPOS/*aPosGet[1,1]*/ SAY "% Frete                     " size 100,8 OF oDlg PIXEL  //FONT oFntFecha5
@ aPosObj[2,1]+yyPOS+25,255+xxPOS/*aPosGet[1,1]*/ SAY "%  Total Media Rent. Ped.   " size 100,8 OF oDlg PIXEL //FONT oFntFecha5
@ aPosObj[2,1]+yyPOS+35,255+xxPOS/*aPosGet[1,1]*/ SAY "R$ Total Media Rent. Ped.   " size 100,8 OF oDlg PIXEL //FONT oFntFecha5

@ aPosObj[2,1]+yyPOS+05,330+xxPOS/*aPosGet[1,2]*/ MSGET oGetDesc  VAR _nGetDesc   Picture "@E 999.99"          when .f. SIZE 60,8 OF oDlg PIXEL  When .t. Valid Val_GetDesc(_nGetDesc)
@ aPosObj[2,1]+yyPOS+15,330+xxPOS/*aPosGet[1,2]*/ MSGET oGetFrete VAR _nGetFrete  Picture "@E 999,999,999.99"  when .f. Size 60,8 OF oDlg PIXEL  When .t. Valid Val_Frete(_nGetFrete)
@ aPosObj[2,1]+yyPOS+25,330+xxPOS/*aPosGet[1,2]*/ MSGET oGetRent  VAR _nGetRent   Picture "@E 999.99"          SIZE 60,8 OF oDlg PIXEL  When .f.
@ aPosObj[2,1]+yyPOS+35,330+xxPOS/*aPosGet[1,2]*/ MSGET oGetRenVr VAR _nGetRenVr  Picture "@E 999,999,999.99"  Size 60,8 OF oDlg PIXEL  When .f.


//"< F3 > Detalhes dos Calculos"+SPACE(10)+;
cTexto:="< F4 > Consulta Estoque da Malha Logistica"+SPACE(10)+;
"< F11 > Periodo das Ultimas Vendas"        +SPACE(10)+;
"< F12 > Liberacao de Rentabilidade Manual"

nPosTexto:= INT((aPosObj[1,4] - Len(cTexto)) / 2)
nPosTexto:= INT( nPosTexto - ( Len(cTexto) / 2 ) )


@ aPosObj[3,1]+030,10 SAY  cTexto of oDlg  PIXEL  FONT oFntFecha1


DEFINE TIMER oTimer INTERVAL 1 ACTION U_AtuDisp(aListVend,oListVend,oGet,oTimer,aPosObj,oDlg,oFntFecha2,aListORCA,oListORCA) OF oDlg
oTimer:Activate()

//ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{||nOpcA := 1,If(U_ValAllSim(),oDlg:End(),nOpcA := 0},{||oDlg:End()}) CENTERED
ACTIVATE MSDIALOG oDlg ON INIT RfatBar(oDlg,{||nOpcA := 1,if(oget:TudoOk(),(aCols:=aClone(oGet:aCols),oDlg:End()),nOpcA := 0)},{||oDlg:End()}) CENTERED
SetKey(VK_F4 ,bSetKey4)
SetKey(VK_F9 ,bSetKey9)
SetKey(VK_F11,bSetKey11)
SetKey(VK_F12,bSetKey12)

ogetdad:oBrowse:lDisablePaint := .F. // Este evento desabilita a utilizacao
// do delete no orcamento o qual sera
// reativado na saida
//������������������������������������������������������������������������Ŀ
//�Efetua a Atualizacao no aColsSim Corrente                               �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�Atualiza o Preco de Venda com base no aColsSim.                         �
//��������������������������������������������������������������������������

If  nOpcA == 1
	
	If  "MATA415" $ Upper(Funname())
		
		DbSelectArea("TMP1")
		TMP1->(DBGOTOP())

		For nY:= 1 to len(aCols)
			
			//DbSelectArea("TMP1")
			//TMP1->(DbGoto(nY))
			Reclock("TMP1",.F.)
			
			TMP1->CK_FLAG    := aCols[nY,Len(aHeader)+1 ]// Se deletar na simulacao sera deletado no Orcamento
			TMP1->CK_QTDVEN  := aCols[nY,XQTDVEN]
			TMP1->CK_PRCVEN  := aCols[nY,XPRCVEN]
			TMP1->CK_VALOR   := NOROUND(aCols[nY,XPRCVEN] * aCols[nY,xQtdVen],2)
			TMP1->CK_X_MARGE := aCols[nY,xMargE]
			TMP1->CK_X_MARGV := aCols[nY,xMargv]
			TMP1->CK_X_MARGA := aCols[nY,xMargA]
			TMP1->CK_X_CTSTD := aCols[nY,xCTSTD]
			TMP1->CK_X_CTPAD := aCols[nY,xCtPadrao]
			TMP1->CK_X_FOB   := aCols[nY,xCTFOB]
			TMP1->CK_TES     := aCols[nY,xTes]
			TMP1->CK_CLASFIS := aCols[nY,xClasFis]
			TMP1->CK_LOCAL   := aCols[nY,xLOCAL]
			TMP1->CK_LOCNOME := GetAdvFval("NNR","ZB_DESCRI",xFilial("NNR")+TMP1->CK_LOCAL, 1)
			TMP1->CK_X_PIS   := aCols[nY,xPIS]
			TMP1->CK_X_COFIN := aCols[nY,xCofins]
			TMP1->CK_X_CPMF  := aCols[nY,xCPMF]
			TMP1->CK_X_ICM   := aCols[nY,xICM]
			TMP1->CK_X_IPI   := aCols[nY,xIPI]
			TMP1->CK_X_PRCLI := aCols[nY,xProdCli]
			TMP1->CK_X_RESER := aCols[nY,xReser]
			TMP1->CK_X_ITEM0 := aCols[nY,xItem0]
			TMP1->CK_X_ENTRE := aCols[nY,xDTENT]
			TMP1->CK_OBS     := aCols[nY,xObs]    
			
			If Empty(TMP1->CK_X_EMISS)
			   TMP1->CK_X_EMISS := ddataBase
            Endif
            			
			MsUnlock()
			
			TMP1->(DBSKIP())
			
		Next
		
		M->CJ_CONDPAG := _cGetCond   // Condicoes de Pagamento
		M->CJ_X_FRETE := _nGetFrete     // Frete
		M->CJ_X_MARGE := _nGetRent   // % Medio da Margem de Rentabilidade
		M->CJ_X_MARGV := _nGetRenVr  // $ Medio da Margem de Rentabilidade
		M->CJ_X_MARGA := _cStatus    // Status do Item
		
		
		
	ElseIF Upper(Funname()) $ "#MFATC04"
		
		For nY:= 1 to len(aColsAux)
			
			aColsAux[nY,LEN(aHeadAux)+1] := aCols[nY,Len(aHeader)+1 ]// Se deletar na simulacao
			//  sera deletado no orcamento
			aColsAux[nY,nQTDVEN]         := aCols[nY,xQTDVEN]
			aColsAux[nY,nPRCVEN]         := aCols[nY,xPRCVEN]
			aColsAux[nY,nVALOR]          := aCols[nY,xPRCVEN] * aCols[nY,xQtdVen]
			aColsAux[nY,nMargE]          := aCols[nY,xMargE]
			aColsAux[nY,nMargV]          := aCols[nY,xMargv]
			aColsAux[nY,nMargA]          := aCols[nY,xMargA]
			aColsAux[nY,nCTSTD]          := aCols[nY,xCTSTD]
			//aColsAux[nY,nCtPadrao]       := aCols[nY,xCtPadrao] // FIXO NAO TEM NECESSIDADE DE REGRAVAR
			aColsAux[nY,nCTFOB]          := aCols[nY,xCTFOB]
			aColsAux[nY,nTes]            := aCols[nY,xTes]
			aColsAux[nY,nClasFis]        := aCols[nY,xClasFis]
			aColsAux[nY,nLocal]          := aCols[nY,xLocal]
			aColsAux[nY,nLocNome]        := aCols[nY,xLocNome]
			
			aColsAux[nY,nPIS]            := aCols[nY,xPis]
			aColsAux[nY,nCOFINS]         := aCols[nY,xCofins]
			aColsAux[nY,nCPMF]           := aCols[nY,xCPMF]
			aColsAux[nY,nICM]            := aCols[nY,xICM]
			aColsAux[nY,nIPI]            := aCols[nY,xIPI]
			aColsAux[nY,nProdCli]        := aCols[nY,xProdCli]
			aColsAux[nY,nReser]          := aCols[nY,xReser]
			aColsAux[nY,nItem0]          := aCols[nY,xItem0]
			aColsAux[nY,nDtEnt]          := aCols[nY,xDtEnt]
			aColsAux[nY,nObs]            := aCols[nY,xObs]
			
			
			//���������������������������������������������������������������������������������������red�
			//�Indica que a rotina esta sendo executa pela MFATC08.PRW ou seja pelo reajuste de preco�
			//�logo sera necessario recalcular o % de reajuste em funcao da alteracao do preco       �
			//�efetuada pelo simulador.                                                              �
			//�                                                                                      �
			//�Sendo:                                                                                �
			//�                                                                                      �
			//�% Reajuste = ( (Preco Sugerido / Preco Anterior) - 1 ) * 100                          �
			//���������������������������������������������������������������������������������������
			if nPrcRea !=0
				aColsAux[nY,nPerrea] := (((aColsAux[nY,nPRCVEN] /  aColsAux[nY,nPrcRea]) - 1)  * 100)
			Endif
			
		Next
		
		CCONDPAG   := _cGetCond
		nFrete     := _nGetFrete
		nPrentab   := _nGetRent   // % Medio da Margem de Rentabilidade
		nRrentab   := _nGetRenVr  // $ Medio da Margem de Rentabilidade
		cSrentab   := IIf(_cStatus = "B","Bloqueado","Liberado")
		
	Endif
	
	
	aColsSim:=Aclone(Acols)
	aHeadSim:=Aclone(aHeader)
	
Endif


//��������������������������������������������������������������Ŀ
//� Restaurando a Tela de Contrato Ou Orcamento                  �
//����������������������������������������������������������������
StarVar()	 // Retorna o aHeader/Acols antes de entrar nesta operacao

If "MATA415" $ Upper(Funname())
	DbSelectArea("TMP1")
	// Esta linha impede que o sistema perca a primeira linha
	//
	TMP1->(dbGoTop())
	
	oGetDad:oBrowse:GoTop() //(ao inv�s de: oGetDad:oBrowse:Refresh())
Else
	oGetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento ou Contrato
Endif

//ogetdad:oBrowse:lDisablePaint := .T. // Este evento desabilita a utilizacao
// do delete no orcamento o qual sera
// reativado na saida

//��������������������������������������������������������������Ŀ
//� Deleta arquivo temporario                                    �
//����������������������������������������������������������������
If File(cArqVend+".DTC")
	dbSelectArea("TEMPVEND")
	dbCloseArea()
	Ferase(cArqVend+".DTC")
	Ferase(cIndVend+OrdBagExt())
Endif   

If File(cArqOrca+".DTC")
	dbSelectArea("TEMPORCA")
	dbCloseArea()
	Ferase(cArqOrca+".DTC")
	Ferase(cIndVend+OrdBagExt())
Endif   
                   

RestArea(aGetArea)

Return




Static Function Val_GetCond(_cGetCond)
Local lRet := .T.
Local aArea:= GetArea()
Local nY   := 0

DbSelectArea("SE4")
DbSetOrder(1)    
If Dbseek( xFilial("SE4") + _cGetCond )
	For nY :=  1 to len(oGet:aCols)         // Altera os Precos
		U_CalcSim(nY,.F.)
	Next nY
	oget:obrowse:Refresh()
	oget:obrowse:SETFOCUS()
Else
	Aviso("ATENCAO", "Condicao de Pagamento nao Cadastrada",{"&Ok"})
	lRet:=.F.
Endif

RestArea(aArea)

Return lRet

//
// Consulta de Produtos
//
Static Function Consulta()

//
// n deve estar posicionado em algum item evitando erro de tela.
//
If Len(Acols) = 0 .or. oGet:oBrowse:nAt = 0 .or. oGet:oBrowse:nAt > Len(Acols)
	Return
Endif

U_MFATC03(aCols[oGet:oBrowse:nAt][xPRODUTO])

Return



Static Function Val_Frete(cVar)
Local lRet := .T.
Local nY   := 0

If  cVar < 0
	Aviso("ATENCAO", "Valor de Frete Invalido.",{"&Ok"})
	lRet := .f.
Endif

For nY :=  1 to len(Acols)
	U_CalcSim(nY,.F.)
Next nY

oget:obrowse:Refresh()
oget:obrowse:SETFOCUS()

Return lRet




Static Function Val_GetDesc(nCont)
Local lRet    := .T.
Local nVrDesc := _nGetDesc
Local nY      := 0

if nVrDesc = 0
	Return(.t.)
Endif

If  nCont < 0
	Aviso("ATENCAO", "Valor de Desconto Invalido.",{"&Ok"})
	Return(.f.)
Endif

For nY :=  1 to len(Acols)
	_nGetDesc := nVrDesc
	U_CalcSim(nY,.F.)
Next nY

//��������������������������������������������������������������������Ŀ
//�Este parametro permite que o calculo apos efetuado pela rotina  4   �
//�rotina que trata desconto seja refeito pela Rotina 1                �
//����������������������������������������������������������������������


oGetDesc:Refresh()
oget:obrowse:Refresh()
If nCont <> 0
	oget:obrowse:SETFOCUS()
Endif

Return lRet





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RfatBar   � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � EnchoiceBar especifica do Rfatc01                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oDlg: 	Objeto Dialog                                     ���
���          � bOk:  	Code Block para o Evento Ok                       ���
���          � bCancel: Code Block para o Evento Cancel                   ���
���          � nOpc:		nOpc transmitido pela mbrowse                 ���
���          � aForma: Array com as formas de pagamento                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RfatBar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButonUsr := {}
Local nI        := 0

aadd(aButtons,{"S4WB011N",{|| U_MFATC03(aCols[oGet:oBrowse:nAt][xPRODUTO])}, "Consulta Estoque da Malha Logistica" })   //F4
aadd(aButtons,{"BUDGET"  ,{|| CONSPER(xPRODUTO,@_dDataIni,@_dDataFinal,@nMaxReg,@nFiltra,aPosObj,oDlg,oFntFecha2)}, "Periodo das Ultimas Vendas" }) //F11
If lUsuLib      // Usuario Liberado para efetuar Liberacao Manual.
	aadd(aButtons,{"CHECKED" ,{|| LIBMANUAL()},"Liberacao Manual por Rentabilidade" }) //F12
Endif
//aadd(aButtons,{"CHKED",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"CHECKED",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"CHECKOK",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"SDUREPL",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"BUDGET",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"CHKED",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"BMPPARAM",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"ANALITICO",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"ANALITIC",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"

//aadd(aButtons,{"POSCLI",{|| If(M->CJ_TIPO=="N".And.!Empty(M->CJ_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},"Posi��o de Cliente" }) 	//"Posi��o de Cliente"
//aadd(aButtons,{"BUDGET",{|| Ma410ForPg(nOpc)}, "Formas de Pagamento" })
//aadd(aButtons,{"RELATORIO",{||Ma410Impos()}, "Planilha Financeira" })
//aadd(aButtons,{"PRODUTO",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"SOLICITA",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"CARGASEQ",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"BUDGETY",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"SIMULACAO",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })
//aadd(aButtons,{"DBG06",{||U_MFATC03(aCols[n][xPRODUTO])}, "<F4> - Consulta Estoque da Malha Logistica" })

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | ConsVend � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta as Ultimas Compras dos Produtos                   ���
���          � Transportei as ultimas compras dos produtos para um TRB    ���
���          � para evitar que durante a navegacao do acols nao haja      ���
���          � grande perda de performace.                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ConsVend(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra)
Local nY        := 0
Local cChave    := ""
Local nTVendas  := 0
Local aStru     :={}
Local aCampo    :={}
Local aGetArea  :={}

DbSelectArea("SA1")

aGetArea  := GetArea()

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SD2")
While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "SD2")
	cTitulo := TRIM(SX3->X3_CAMPO)
	
	if  cTitulo $  ('D2_COD|D2_EMISSAO|D2_X_ORIGM|'+;
		'D2_QUANT|D2_PRCVEN|D2_TOTAL|'+;
		'D2_X_MARGE|D2_X_MARGV|D2_IPI|D2_PICM|D2_DOC|D2_SERIE|')
		//D2_CLIENTE|D2_LOJA|'+; Nao sera necessrario devido nome ficar por
		//                       extenso e estar sendo tratado pela D2_NREDUZ
		
		//D2_COD nao sera utilizado na visualizacao sua funcao e apenas
		//       indexar o arquivo temporario que e gerado.
		//       evitando perda de performace.
		AADD(aCampo,cTitulo)
		AADD(aStru,{cTitulo, X3_TIPO, X3_TAMANHO, X3_DECIMAL} )
	Endif
	
	SX3->(DbSkip())
End

// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"D2_NREDUZ", "C" , 20 , 0 } )
// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"A1_EST", "C" , 2 , 0 } )
// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"A1_MUN", "C" , 16 , 0 } )



//���������������������������������������������������������������
//�Deleto neste momento pois posso chamar outras vezes esta     �
//�funcao com o objetivo de remontar o Trb com perido diferente.�
//���������������������������������������������������������������
If  File(cArqVend+".DTC")
	dbSelectArea("TEMPVEND")
	dbCloseArea()
	Ferase(cArqVend+".DTC")
	Ferase(cIndVend+OrdBagExt())
Endif


cArqVend   := CriaTrab(aStru,.T.) // Nome do arquivo temporario
cIndVend   := CriaTrab(,.F.)
dbusearea(.T.,,cArqVend,"TEMPVEND",.F.,.F.)
IndRegua("TEMPVEND",cIndVend,"D2_COD",,,"Indexando Registro")
        

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+_cCliente + _cLoja)
_cNReduz := SA1->A1_NREDUZ


ProcRegua(LEN(ACOLS))

For nY = 1 to LEN(ACOLS)
	
	Incproc("Levantando Ultimas Vendas")
	
	//
	//  NAO ESTOU UTILIZANDO QUERY DEVIDO CALSAR LENTIDAO NO SISTEMA DEVIDO SER CHAMADA VARIAS VEZES
	//
	
	DbselectArea("TEMPVEND")
	If  !DbSeek(Acols[ny][xPRODUTO])
		
		DbselectArea("SD2")
		DbOrderNickname("D2EMISSAO") //D2_FILIAL+D2_COD+DTOS(D2_EMISSAO)
		cChave:=xFilial("SD2")+ Acols[ny][xPRODUTO] + DTOS(_dDataFinal)
		
		SET SOFTSEEK ON
		DbSeek(cChave,.T.)
		SET SOFTSEEK OFF
		
		If Acols[ny][xPRODUTO] <> SD2->D2_COD
			SD2->(DBSKIP(-1))
		Endif
		
		nTVendas := 0
		cChave:=xFilial("SD2")+Acols[ny][xPRODUTO] 
		
		
		While   !SD2->(EOF()) .and. !SD2->(BOF()) .and. cCHAVE = xFilial("SD2")+SD2->D2_COD .and.;
			SD2->D2_EMISSAO >= _dDataIni .and. SD2->D2_EMISSAO  <= _dDataFinal
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
			
			If nFiltra = 1                
			
               If !(ALLTRIM(SA1->A1_NREDUZ) = ALLTRIM(_cNReduz))
              	  DbSelectArea("SD2")
			      SD2->(DBSKIP(-1))
			      loop
			   Endif
			
			ENdif   
			
			DbSelectArea("TEMPVEND") // Alterado - Almeida 21/05/2014
			Reclock("TEMPVEND",.T.)
			For cnt:= 1 to len(aCampo)
				Field->&(aCampo[cnt]):= SD2->&(aCampo[cnt])
			Next
			Field->D2_NREDUZ:= SA1->A1_NREDUZ
			Field->A1_EST   := SA1->A1_EST
			Field->A1_MUN   := SA1->A1_MUN
			Msunlock()
			
			nTVendas++
			
			If nTVendas > nMaxReg // Define o Max de Registros para Historico
				Exit              // de venda
			Endif
			
			DbSelectArea("SD2")
			SD2->(DBSKIP(-1))
			
		Enddo
	Endif
Next

RestArea(aGetArea)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | ConsORCA � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta as Ultimas Compras dos Produtos                   ���
���          � Transportei as ultimas compras dos produtos para um TRB    ���
���          � para evitar que durante a navegacao do acols nao haja      ���
���          � grande perda de performace.                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ConsORCA(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra)
Local nY        := 0
Local cChave    := ""
Local nTVendas  := 0
Local aStru     :={}
Local aCampo    :={}
Local aGetArea  :={}

DbSelectArea("SA1")

aGetArea  := GetArea()

dbSelectArea("SX3")
dbSetOrder(1)           

dbSeek("SCK")
While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO == "SCK")
	cTitulo := TRIM(SX3->X3_CAMPO)
	                            
	if  cTitulo $  ('CK_PRODUTO|CK_X_EMISS|CK_CLIENTE|'+;
		'CK_NUM|CK_QTDVEN|CK_VALOR|CK_PRCVEN|'+;
		'CK_X_MARGE|CK_X_MARGV|CK_X_IPI|CK_X_ICM|CK_X_PRCLI|CK_NUMPV|')
		//D2_CLIENTE|D2_LOJA|'+; Nao sera necessrario devido nome ficar por
		//                       extenso e estar sendo tratado pela D2_NREDUZ
		
		//D2_COD nao sera utilizado na visualizacao sua funcao e apenas
		//       indexar o arquivo temporario que e gerado.
		//       evitando perda de performace.
		AADD(aCampo,cTitulo)
		AADD(aStru,{cTitulo, X3_TIPO, X3_TAMANHO, X3_DECIMAL} )
	Endif
	
	SX3->(DbSkip())
End

// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"D2_NREDUZ", "C" , 20 , 0 } )
// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"A1_EST", "C" , 2 , 0 } )
// Ira guardar o nome por extendo do Cliente
AADD(aStru,{"A1_MUN", "C" , 16 , 0 } )



//���������������������������������������������������������������
//�Deleto neste momento pois posso chamar outras vezes esta     �
//�funcao com o objetivo de remontar o Trb com perido diferente.�
//���������������������������������������������������������������
If  File(cArqOrca+".DTC")
	dbSelectArea("TEMPORCA")
	dbCloseArea()
	Ferase(cArqOrca+".DTC")
	Ferase(cIndOrca+OrdBagExt())
Endif


cArqOrca   := CriaTrab(aStru,.T.) // Nome do arquivo temporario
cIndOrca   := CriaTrab(,.F.)
dbusearea(.T.,,cArqOrca,"TEMPORCA",.F.,.F.)
IndRegua("TEMPORCA",cIndOrca,"CK_PRODUTO",,,"Indexando Registro")
        

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+_cCliente + _cLoja)
_cNReduz := SA1->A1_NREDUZ


ProcRegua(LEN(ACOLS))

For nY = 1 to LEN(ACOLS)
	
	Incproc("Levantando Ultimos Orcamentos")
	
	//
	//  NAO ESTOU UTILIZANDO QUERY DEVIDO CALSAR LENTIDAO NO SISTEMA DEVIDO SER CHAMADA VARIAS VEZES
	//
	
	DbselectArea("TEMPORCA")
	If  !DbSeek(Acols[ny][xPRODUTO])
		
		DbselectArea("SCK")
		DbOrderNickname("SCKEMISSAO") //CK_FILIAL+CK_PRODUTO+DTOS(CK_X_EMISS)
		cChave:=xFilial("SCK")+ Acols[ny][xPRODUTO] + DTOS(_dDataFinal)
		
		SET SOFTSEEK ON
		DbSeek(cChave,.T.)
		SET SOFTSEEK OFF
		
		If Acols[ny][xPRODUTO] <> SCK->CK_PRODUTO
		   SCK->(DBSKIP(-1))
		Endif
		
		nTVendas := 0
		cChave:=xFilial("SCK")+Acols[ny][xPRODUTO] 
		
		
		While   !SCK->(EOF()) .and. !SCK->(BOF()) .and. cCHAVE = xFilial("SCK")+SCK->CK_PRODUTO .and.;
			SCK->CK_X_EMISS >= _dDataIni .and. SCK->CK_X_EMISS  <= _dDataFinal
			
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SCK->CK_CLIENTE+SCK->CK_LOJA)
			
			If nFiltra = 1                
			
               If !(ALLTRIM(SA1->A1_NREDUZ) = ALLTRIM(_cNReduz))
              	  DbSelectArea("SCK")
			      SCK->(DBSKIP(-1))
			      loop
			   Endif
			
			ENdif   
			
			DbSelectArea("TEMPORCA") // Alterado - Almeida 21/05/2014
			Reclock("TEMPORCA",.T.)
			For cnt:= 1 to len(aCampo)
				Field->&(aCampo[cnt]):= SCK->&(aCampo[cnt])
			Next
			Field->D2_NREDUZ:= SA1->A1_NREDUZ
			Field->A1_EST   := SA1->A1_EST
			Field->A1_MUN   := SA1->A1_MUN
			Msunlock()
			
			nTVendas++
			
			If nTVendas > nMaxReg // Define o Max de Registros para Historico
				Exit              // de venda
			Endif
			
			DbSelectArea("SCK")
			SCK->(DBSKIP(-1))
			
		Enddo
	Endif
Next

RestArea(aGetArea)

Return





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | GeraVend � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monsta a Lista de Itens das Ultimas Compras com base no TMP���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraVend(cProduto)
Local aListObj :={}                  

DbSelectArea("TEMPVEND")
If DbSeek(cProduto)
	While !TEMPVEND->(EOF()) .and. cProduto = TEMPVEND->D2_COD
		
		AADD(aListObj,{DTOC(TEMPVEND->D2_EMISSAO),;
		TEMPVEND->D2_X_ORIGM,;
		TEMPVEND->D2_NREDUZ,;
		TEMPVEND->D2_PRCVEN,;
		TEMPVEND->D2_X_MARGE,;
		TEMPVEND->D2_PICM,;
		TEMPVEND->A1_MUN,;
		TEMPVEND->A1_EST,;
		TEMPVEND->D2_QUANT,;
		TEMPVEND->D2_TOTAL,;
		TEMPVEND->D2_X_MARGV,;
		TEMPVEND->D2_IPI,;
		TEMPVEND->D2_DOC,;
		TEMPVEND->D2_SERIE})
		
		TEMPVEND->(DBSKIP())
	Enddo
Endif

if len(aListObj)=0
	AADD(aListObj,{"","","",0,0,0,"","",0,0,0,0,"",""})
Endif


Return(aListObj)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | GeraOrca � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monsta a Lista de Itens das Ultimas Compras com base no TMP���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraOrca(cProduto)
Local aListObj :={}                  

DbSelectArea("TEMPORCA")
If DbSeek(cProduto)
	While !TEMPORCA->(EOF()) .and. cProduto = TEMPORCA->CK_PRODUTO
		
		AADD(aListObj,{DTOC(TEMPORCA->CK_X_EMISS),;
		TEMPORCA->D2_NREDUZ,;
		TEMPORCA->CK_PRCVEN,;
		TEMPORCA->CK_X_MARGE,;
		TEMPORCA->CK_X_ICM,;
		TEMPORCA->A1_MUN,;
		TEMPORCA->A1_EST,;
		TEMPORCA->CK_QTDVEN,;
		TEMPORCA->CK_VALOR,;
		TEMPORCA->CK_X_MARGV,;
		TEMPORCA->CK_X_IPI,;
		TEMPORCA->CK_NUMPV,;
		TEMPORCA->CK_NUM})
		
		TEMPORCA->(DBSKIP())
	Enddo
Endif

if len(aListObj)=0
	AADD(aListObj,{"","",0,0,0,"","",0,0,0,0,"",""})
Endif


Return(aListObj)









/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AtuDisp  � Autor �                       � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza objeto relacao itens                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AtuDisp(aListVend,oListVend,oGet,oTimer,aPosObj,oDlg,oFntFecha2,aListORCA,oListORCA)
Local oGetRefer       
//Static Function AtuDisp(aListVend,oListVend,oGet,oTimer)
If  nPosicao = oGet:oBrowse:nAt .and. !lReplace        // Objetivo evitar que o sistema perca tempo processando
	return                              // sendo que o usuario se encontra na mesma linha.
Endif                                  // para iniciar nPosicao = 0 e n = 1
// apos passar a primeira vez nPosicao fica = 1
// neste momento o controle fica com o usuario

lReplace := .F.                       // Esta variavel apenas libera a atualizacao da tela
// apesar do nPosicao ser igual a n isto e nessecario
// apos o usuario teclar F11 atualizando a tela.


If oTimer # NIL
	oTimer:Activate()
EndIf


//
// n deve estar posicionado em algum item evitando erro de tela.
//
If Len(Acols) = 0 .or. oGet:oBrowse:nAt = 0 .or. oGet:oBrowse:nAt > Len(Acols)
	Return
Endif


//
// Dispara descricao do produto na tela.
//
//@ aPosObj[2,1]+90 ,01 SAY "Descricao do Produto" size 100,8 OF oDlg PIXEL //FONT oFntFecha5
//@ aPosObj[2,1]+100,01 MSGET oGetRefer VAR Acols[oGet:oBrowse:nAt,xRefer] when .f. SIZE 310,15 OF oDlg PIXEL FONT oFntFecha2   
@ aPosObj[2,1]+90,01 MSGET oGetRefer VAR Acols[oGet:oBrowse:nAt,xRefer] when .f. SIZE 310,15 OF oDlg PIXEL FONT oFntFecha2   

//@ aPosObj[2,1]+yyPOS+35,255+xxPOS/*aPosGet[1,1]*/ SAY "R$ Total Media Rent. Ped.   " size 100,8 OF oDlg PIXEL //FONT oFntFecha5
//@ aPosObj[2,1]+90,01 SAY  Acols[oGet:oBrowse:nAt,xRefer]  SIZE 310,15 OF oDlg PIXEL FONT oFntFecha2   

oGetRefer:Refresh()

//
// Dispara Atualizacao do aListVend na tela.
//
aListVend:=GeraVend(Acols[oGet:oBrowse:nAt,xPRODUTO]) // Ultimas compras com base no produto

oListVend:SetArray(aListVend)
oListVend:nFreeze:= 3
oListVend:nAt:= 1

oListVend:bLine := { || {xPadC(aListVend[oListVend:nAt,X_DATA],45),;
xPadC(aListVend[oListVend:nAt,X_ORIGM] ,10),;
xPadC(aListVend[oListVend:nAt,X_NREDUZ],60),;
Transform(aListVend[oListVend:nAt,X_VRUNIT]	        ,"@E 99,999.99"),;
Transform(aListVend[oListVend:nAt,X_MARGE]	        ,"@R 999.99% "),;
Transform(aListVend[oListVend:nAt,X_ICM]	        ,"@R 99.99% "),;
xPadC(aListVend[oListVend:nAt,X_MUN]    ,30),;
xPadC(aListVend[oListVend:nAt,X_EST]    ,10),;
Transform(aListVend[oListVend:nAt,X_QTDE]	        ,"@E 999,999.99"),;
Transform(aListVend[oListVend:nAt,X_VRTOTAL]        ,"@E 99,999,999.99"),;
Transform(aListVend[oListVend:nAt,X_MARGV]	        ,"@E 999,999.99 "),;
Transform(aListVend[oListVend:nAt,X_IPI]	        ,"@R 99.99% "),;
xPadC(aListVend[oListVend:nAt,X_NF]     ,40),;
xPadC(aListVend[oListVend:nAt,X_SERIE]  ,40)}}


//
// Dispara Atualizacao do aListORCA na tela.
//
aListORCA:=GeraOrca(Acols[oGet:oBrowse:nAt,xPRODUTO]) // Ultimas compras com base no produto

oListORCA:SetArray(aListORCA)
oListORCA:nFreeze:= 3
oListORCA:nAt:= 1

oListORCA:bLine := { || {xPadC(aListORCA[oListORCA:nAt,Y_DATA],45),;
xPadC(aListORCA[oListORCA:nAt,Y_NREDUZ],60),;
Transform(aListORCA[oListORCA:nAt,Y_VRUNIT]	        ,"@E 99,999.99"),;
Transform(aListORCA[oListORCA:nAt,Y_MARGE]	        ,"@R 999.99% "),;
Transform(aListORCA[oListORCA:nAt,Y_ICM]	        ,"@R 99.99% "),;
xPadC(aListORCA[oListORCA:nAt,Y_MUN]    ,30),;
xPadC(aListORCA[oListORCA:nAt,Y_EST]    ,10),;
Transform(aListORCA[oListORCA:nAt,Y_QTDE]	        ,"@E 999,999.99"),;
Transform(aListORCA[oListORCA:nAt,Y_VRTOTAL]        ,"@E 99,999,999.99"),;
Transform(aListORCA[oListORCA:nAt,Y_MARGV]	        ,"@E 999,999.99 "),;
Transform(aListORCA[oListORCA:nAt,Y_IPI]	        ,"@R 99.99% "),;
xPadC(aListORCA[oListORCA:nAt,Y_PEDIDO]     ,40),;
xPadC(aListORCA[oListORCA:nAt,Y_NUM],45)}}

If nPosicao # 0
	oListVend:Refresh()
	oListORCA:Refresh()
Endif

nPosicao := oGet:oBrowse:nAt

If oTimer # NIL
	oTimer:Activate()
EndIf

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaAcols�Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta rotina Atribui Informacoes ao Acols durante o processo ���
���          �de Montagem.                                                ���
���          �                                                            ���
���          �Durante este processo e calculado o custo medio item a item ���
���          �devido termos variavies no sistema que nao sao armazenadas  ���
���          �como custo,comissao dentro da funcao  CalcSim()             ���
���          �Este processo pode gerar lentidao.(???Analisar)             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MontaAcols(lOrigem,nLin,aCols)
Local nPos        := 0
Local lSituacao   := .f.
Local _nMarg      := 0
Local _aTrataEIS  := {}
Local lValid      := .f.
Local aPrVenda    := {}

Private lCancelar := .f.


AADD(aCols,Array(Len(aHeader)+1))
nLin:=Len(aCols)

_cProd     := IIF(lOrigem , TMP1->CK_PRODUTO , aColsAux[nLin][nProduto])
_aTrataEIS := U_TrataEIS(_cProd)


aCols[nLin][Len(aHeader)+1]:= IIF(lOrigem , TMP1->CK_FLAG    , aColsAux[nLin][Len(aHeadAux)+1])
aCols[nLin][xRefer]        := SB1->B1_X_REFER+"-"+SB1->B1_X_SUFIX+"-"+SB1->B1_X_MARCA+"-"+ SB1->B1_ORIGEM+" - "+IF(SB1->B1_X_PRODU="1",SPACE(3),"MTK")
aCols[nLin][xItem]         := IIF(lOrigem , TMP1->CK_ITEM    , aColsAux[nLin][nItem])
aCols[nLin][xSlow]         := SB1->B1_X_CSLOW
aCols[nLin][xProduto]      := _cProd
aCols[nLin][xQtdven]       := IIF(lOrigem , TMP1->CK_QTDVEN  , aColsAux[nLin][nQtdVen])
aCols[nLin][xCTFOB]        := IIF(lOrigem , TMP1->CK_X_FOB   , aColsAux[nLin][nCTFOB])
aCols[nLin][xPreunit]      := IIF(lOrigem , TMP1->CK_X_PRUN  , aColsAux[nLin][nPrunit])  // Preco Sugerido
aCols[nLin][xPrcven]       := IIF(lOrigem , TMP1->CK_PRCVEN  , aColsAux[nLin][nPRCVEN])  // Preco Sugerido
aCols[nLin][xValor]        := IIF(lOrigem , TMP1->CK_VALOR   , aColsAux[nLin][nValor])
aCols[nLin][xDescont]      := 0                              // Desconto no Item
aCols[nLin][xMargE]        := IIF(lOrigem , TMP1->CK_X_MARGE , aColsAux[nLin][nMargE])
aCols[nLin][xMargV]        := IIF(lOrigem , TMP1->CK_X_MARGV , aColsAux[nLin][nMargV])
aCols[nLin][xMargA]        := IIF(lOrigem , TMP1->CK_X_MARGA , aColsAux[nLin][nMargA])
aCols[nLin][xTes]          := IIF(lOrigem , TMP1->CK_TES     , aColsAux[nLin][nTes])
aCols[nLin][xClasFis]      := IIF(lOrigem , TMP1->CK_CLASFIS , aColsAux[nLin][nClasfis])
aCols[nLin][xLOCAL]        := IIF(lOrigem , TMP1->CK_LOCAL   , aColsAux[nLin][nLOCAL])
aCols[nLin][xLOCNOME]      := IIF(lOrigem , TMP1->CK_LOCNOME , aColsAux[nLin][nLOCNOME])
aCols[nLin][xPQR]          := SB1->B1_X_PQR
aCols[nLin][xNeoil]        := SB1->B1_X_Neoil
aCols[nLin][xXYZ]          := SB1->B1_X_XYZ
aCols[nLin][x123]          := SB1->B1_X_123
aCols[nLin][xNC_IM]        := SB1->B1_X_NC_IM
aCols[nLin][xABC]          := SB1->B1_X_ABC
aCols[nLin][xLHM]          := SB1->B1_X_LMN
aCols[nLin][xGiro]         := SB1->B1_X_GIROQ
aCols[nLin][xIpi]          := IIF(lOrigem , TMP1->CK_X_IPI   , aColsAux[nLin][nIpi])        // Ipi
aCols[nLin][xPis]          := IIF(lOrigem , TMP1->CK_X_PIS   , aColsAux[nLin][nPis])        // Pis
aCols[nLin][xCofins]       := IIF(lOrigem , TMP1->CK_X_COFIN , aColsAux[nLin][nCofins])     // Cofins
aCols[nLin][xCpmf]         := IIF(lOrigem , TMP1->CK_X_CPMF  , aColsAux[nLin][nCpmf])       // Cpmf
aCols[nLin][xIcm]          := IIF(lOrigem , TMP1->CK_X_ICM   , aColsAux[nLin][nIcm] )        // Icm
aCols[nLin][xSimil]        := SB1->B1_X_SIMIL                                                 // Desconto no Item
aCols[nLin][xEis]          := _aTrataEIS[01,03]                                               // Codigo Inteiro Eis
aCols[nLin][xProdCli]      := IIF(lOrigem , TMP1->CK_X_PRCLI , aColsAux[nLin][nProdCli])    // Produto do Cliente
aCols[nLin][xCtStd]        := IIF(lOrigem , TMP1->CK_X_CTSTD , aColsAux[nLin][nCTSTD])
aCols[nLin][xCtPadrao]     := IIF(lOrigem , TMP1->CK_X_CTPAD , aColsAux[nLin][nCtPadrao])
aCols[nLin][xCTFOB]        := IIF(lOrigem , TMP1->CK_X_FOB   , aColsAux[nLin][nCTFOB])
aCols[nLin][xReser]        := IIF(lOrigem , TMP1->CK_X_RESER , aColsAux[nLin][nReser])      // Reserva do Cliente
aCols[nLin][xItem0]        := IIF(lOrigem , TMP1->CK_X_ITEM0 , aColsAux[nLin][nItem0])      // Item da Reserva
aCols[nLin][xDTENT]        := IIF(lOrigem , TMP1->CK_X_ENTRE , aColsAux[nLin][nDtEnt])      // Data de Entrega
aCols[nLin][xObs]          := IIF(lOrigem , TMP1->CK_OBS     , aColsAux[nLin][nObs])        // OBSERVACAO

U_MediaRent(.F.,nLin)

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrVenda   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta funcao permite determinar o Preco de Venda Sem estar   ���
���          �utilizando o Simulador com base na Rotina 1                 ���
���          �                                                            ���
���          �- Esta sendo chamada de um gatilho para alimentar o preco de���
���          �  Venda do Orcamento ou contrato sem passar pelo Simulador. ���
���          �                                                            ���
���          �- No futuro podera ser utilizada para determinar preco de   ���
���          �  Lista de Produto sem entrar no Simulador                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function PrVenda(cCondPgto,cProduto,_cIndComer,lSimulador,_nGetFrete)

//������������������������������������������������������������������������Ŀ
//� Variaveis necessarias para execucao dos Calculos pela Funcao ExecCalc  �
//��������������������������������������������������������������������������
Local _aArea      := GetArea()
Local _X_Custo    :=  0
Local _X_Margem   :=  0
Local _X_Ipi      :=  0
Local _X_Comissao :=  0
Local _X_Pis      :=  0
Local _X_Cofins   :=  0
Local _X_Cpmf     :=  0
Local _X_Icms     :=  0
Local _X_Frete    :=  0
Local _X_TxFinan  :=  0
Local _X_PrazoVe  :=  0
Local _X_DescLin  :=  0
Local _x_DescAll  :=  0

Local nY          := 0
//������������������������������������������������������������������������Ŀ
//� Variaveis auxiliares para ajudar nos calculos.                         �
//��������������������������������������������������������������������������
Local _uString    := ""   // Retorna o numero de dias para a cond.de Pagto


//�������������������������������������������������������������������������Ŀ
//�                 V a r i a v e i s  d e  C a l c u l o s                 �
//�Estas Parametrosalimentarao o Matriz de Simulacao no Inicio.             �
//�Sendo que o Juros nao e mostrado em tela somente entre no Calculo.       �
//���������������������������������������������������������������������������
Local cProcName    := FunName()
Local ii           := 0

Local   _n_Mv_TxPis  := GetMv("MV_TXPIS")     //  Pis            (Padrao)
Local   _n_Mv_Cofins1:= GeTMv("MV_TXCOFIN")   //  Confins        (Padrao)
Local   _n_Mv_Cpmf   := GeTMV("MV_CPMF")      //  Cpmf           (Especifico)
Local   _n_Mv_IcmPad := 0
Local   _n_Mv_Jurmes := GetMV("MV_JURMES")    //  Juros no Mes   (Especifico)
Private _n_Mv_Comical:= GetMV("MV_COMICAL")
Private  lCancelar:=.F.

DEFAULT _nGetFrete  := GetMv("MV_FRETEC")    //  Valor do Frete (Especifico)


Private _cCliente := ""
Private _cLoja    := ""

Private _cClient  := ""
Private _cLojaEnt := ""


If Upper(Funname()) $ "#MFATC02B|#MFATC02C|#MFATC02D"  // Chamada pela Tela do Sr. Luiz
	
	_cIndComer    := If(MV_PAR01 = 1 , "I" , "C" ) // Industria ou Consumo
	cCondPgto     := MV_PAR02     //Condicoes Pagamento
	_nGetFrete    := MV_PAR03     //Frete
	_n_Mv_IcmPad  := MV_PAR04     //Icms
	_X_Comissao   := MV_PAR05     //Somatoria das Comissoes

	
Else
	
	_cCliente := IIF( "MATA415" $ Upper(Funname()),M->CJ_CLIENTE, cCliente   )
	_cLoja    := IIF( "MATA415" $ Upper(Funname()),M->CJ_LOJA   , cLoja      )
	
	_cClient := IIF( "MATA415" $ Upper(Funname()),M->CJ_CLIENT  , cCliente   )
	_cLojaEnt:= IIF( "MATA415" $ Upper(Funname()),M->CJ_LOJAENT , cLoja      )
	
	
	//
	// Define a TES a ser utilizada por este produto.
	//
	_cTes:=U_TESDEF(_cIndComer)


	
	/*
	//������������������������������������������������������������������������Ŀ
	//�Posiciona o item no Cadastro de Clientes                                 �
	//��������������������������������������������������������������������������
	// Cliente de Entrega
	DbSelectArea("SA1")
	DbSetorder(1)
	Dbseek(xFilial("SA1")+_cClient+_cLojaEnt)
	
	//
	// Com base na Tes acima Define o Icms.
	//
	_n_Mv_IcmPad := U_IcmsAliq(_cClient,_cLojaEnt,cProduto,_cTes)
	
	
	// Cliente de Faturamento
	DbSelectArea("SA1")
	DbSetorder(1)
	Dbseek(xFilial("SA1")+_cCliente+_cLoja)
	*/
	
	
	//
	// Garante o posicionamento da Tes apos sair da Funcao acima.
	//
	SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+_cTes))
	
	
	While !Empty(cProcName)
		If cProcName $ "U_MFATC05"   // Geracao Pedido atraves do Contrato
			Exit
		Endif
		ii++
		cProcName := UPPER(AllTrim(ProcName(ii)))
	EndDo
	
	If Type("_cIndComer") = "U"   // Caso o Preco seja Mostrado apenas na consulta de
		Private  _cIndComer:= ""
		If  "MATA415" $ Upper(Funname())                                     // Orcamento
			_cIndComer:= M->CJ_X_ST_CI
		ElseIf Upper(Funname())="#MFATC04" .and. !(cProcName $ "U_MFATC05") // Contrato
			_cIndComer:= M->CJ_X_ST_CI       // A Variavel no contrato possui este nome
			// para facilitar.
		ElseIf cProcName $ "U_MFATC05"                                        // Produto de Substituicao no Pedido
			_cIndComer:= SZ6->Z6_X_ST_CI
		Endif
	Endif
	
	lCancelar:=.F.
	//������������������������������������������������������������������������Ŀ
	//�Comissao do Item                                                        �
	//��������������������������������������������������������������������������
	_X_Comissao := U_AjudCalc("COMISSAO",SB1->B1_COD,0,"",@lCancelar,lSimulador)
	
Endif


//������������������������������������������������������������������������Ŀ
//�Margem do Produto                                                       �
//��������������������������������������������������������������������������
_X_Margem   := U_AjudCalc("MARGEM",SB1->B1_COD,0,"",,@lCancelar,lSimulador)

//������������������������������������������������������������������������Ŀ
//�Custo do Produto                                                        �
//��������������������������������������������������������������������������
_X_Custo    := U_AjudCalc("CUSTO",SB1->B1_COD,0,"",,@lCancelar,lSimulador)

//������������������������������������������������������������������������Ŀ
//�Condicoes de Pagamento                                                  �
//��������������������������������������������������������������������������
_uString    := U_AjudCalc("PGTO",SB1->B1_COD,0,cCondPgto,@lCancelar,lSimulador)


If  Upper(Funname()) $ "#MFATC02B|#MFATC02C|#MFATC02D"  // Chamada pela Tela do Sr. Luiz

	//������������������������������������������������������������������������Ŀ
	//�Icms utilizado no Calculo                                               �
	//��������������������������������������������������������������������������
	_X_Icms     := _n_Mv_IcmPad
	//������������������������������������������������������������������������Ŀ
	//�Ipi utilizado no Calculo                                                �
	//��������������������������������������������������������������������������
	_X_Ipi        := SB1->B1_IPI
	//������������������������������������������������������������������������Ŀ
	//�Cofins Utilizado no Calculo                                             �
	//��������������������������������������������������������������������������
	_X_Cofins   := GeTMv("MV_TXCOFIN")
	//������������������������������������������������������������������������Ŀ
	//�Pis  Utilizado no Calculo                                               �
	//��������������������������������������������������������������������������
	_X_Pis      := GetMv("MV_TXPIS")    

Else
	//������������������������������������������������������������������������Ŀ
	//�Icms utilizado no Calculo                                               �
	//��������������������������������������������������������������������������
	//_X_Icms   :=  _nIcm // O % DE ICMS NAO PODE FICAR CONGELADO POIS PODEM
	// OCORRER TROCA DE TES EXEMPLO TER QUE NAO CALCULA ICMS.
	// ESTOU BUSCANDO UTILIZAR O CLIENTE DE ENTREGA
	// Esta funcao necessita a Tes posicionada o que ja foi
	// feito acima.
	_X_Icms     := U_IcmsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
	
	//������������������������������������������������������������������������Ŀ
	//�Ipi utilizado no Calculo                                                �
	//��������������������������������������������������������������������������
	//_X_Ipi        :=  SB1->B1_IPI
	_X_Ipi        := U_IpiAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
	
	
	//������������������������������������������������������������������������Ŀ
	//�Cofins Utilizado no Calculo                                             �
	//��������������������������������������������������������������������������
	_X_Cofins   := U_CofinsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
	
	//������������������������������������������������������������������������Ŀ
	//�Pis  Utilizado no Calculo                                               �
	//��������������������������������������������������������������������������
	_X_Pis      := U_PisAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
	
Endif


If lCancelar
	RestArea(_aArea)
	Return({})
Endif

//������������������������������������������������������������������������Ŀ
//�                         Inicio dos Calculos                            �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�	Rotina 1		Simula��o de pre�os dos produtos com base no custo e   |
//|                 na pol�tica de rentabilidade definida pela empresa.	   |
//��������������������������������������������������������������������������
//_X_Ipi        :=  SB1->B1_IPI
//_X_Pis        :=  _n_Mv_TxPis
//_X_Cofins     :=  _n_Mv_Cofins1
_X_Cpmf       :=  _n_Mv_Cpmf
//_X_Icms       :=  _n_Mv_IcmPad
_X_Frete      :=  _nGetFrete
_X_TxFinan    :=  _n_Mv_Jurmes
_X_PrazoVe    :=  _uString
_X_DescLin    :=  0
_x_DescAll    :=  0

aPrVenda := {}
aPrVenda := U_ExecCalc(_X_Custo  ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,.F.,0,0,_cIndComer)


RestArea(_aArea)


Return(aPrVenda)






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjudCalc  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta funcao tem como objetivo retornar as seguintes         ���
���          �informacoes  Simulador com base na Rotina 1                 ���
���Parametro �                                                            ���
���    cParam�                                                            ���
���          � (1) Custo                      Retorna o Custo do Produto  ���
���          � (2) Margem                     Retorna a Margem do Produto ���
���          �                                (Rotina 1)                  ���
���          � (3) Comissao                   Retorna a Somatoria das     ���
���          �                               comissoes com base no cliente���
���          � (4) PGTO (Cond. Pgto)           Retorna o numero de dias   ���
���          �                                                            ���
���  cProduto� Produto do Cliente                                         ���
���          �                                                            ���
���nMargDigit� Margem Digitada p/ usuario somente util quando for         ���
���          � comparar a Margem Rotina1 com a Margem Rotina2             ���
���          �                                                            ���
��� PgtoDigit| Condicao de Pagamento digitada ou seja codigo utilizado    ���
���          � junto com o cParam com PGTO                                ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AjudCalc(cParam,cProduto,nMargDigit,cPgtoDigit,lCancelar,lSimulador)

Local nY     := 0
Local uRet   := ""
Local aAreaD := GetArea()
Local aVend  := {}
Local aElem  := {}
Local nDias  := 0
Local lOrigem:= IIF("MATA415" $ Upper(Funname()),.T.,.F.)
Local nCM1   := 0

//������������������������������������������������������������������������Ŀ
//�Custo do Produto.                                                       �
//��������������������������������������������������������������������������
if  Upper(cParam) = "CUSTO"
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto)  //aCols[nLin][xProduto])
		
		/*
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek("01"+cProduto+"01")  //aCols[nLin][xProduto])
		
		nCM1 := SB2->B2_CM1
		
		IF nCm1 = 0
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek("03"+cProduto+"01")  //aCols[nLin][xProduto])
		nCM1 := SB2->B2_CM1
		Else
		nCM1 := SB1->B1_X_CTSTD
		Endif
		*/
		
		if lSimulador                     // Origem Simulador
			
			uRet  :=  aCols[n][xCtStd]
			//- Conforme conferca com o Sr. Mauricio o custo
			//  ira se tornar uma variavel no acols que vira junto com
			//  o preco de venda quando Definico o Produto.
			//  Logo  a origem e no MFATC02.PRW  16.06.2004
		Else
			
			
			
			//IF SB1->B1_X_CSLOW = 0
			uRet := SB1->B1_X_CTSTD
			//Else
			//  uRet := SB1->B1_X_CSLOW
			//ndif
			//B1_CUSTD - Conforme conversa com Mauricio nao usariamos
			//           campos do microsiga para calculo do Custo Stander.
		Endif
		
	Else
		
		Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo "+cProduto+;
		"nao esta Cadastrado."+CHH(13)+CHR(13)+;
		"Tentativa de Localizar custo do Produto pela Funcao AjudCalc() falho.",{"&Ok"})
		
		lCancelar:=.T.
		
	Endif
	
	
Elseif Upper(cParam) = "MARGEM"
	
	
	//������������������������������������������������������������������������Ŀ
	//� Margem do Produto no SZH (Tab. de Arvore de Encaminhamento).           |
	//� _X_MARGEM = Margem Ideal do Produto ou Margem Sugestao ROTINA 1        �
	//� _nMarge  = Margem Digitada pelo Usuario.              ROTINA 2         �
	//��������������������������������������������������������������������������
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+cProduto)  //aCols[nLin][xProduto])
		
		
		DbSelectArea("SZH")
		DbSetOrder(2)
		If DbSeek(xFilial("SZH")+SB1->(B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC+B1_X_LMN))
			
			If  nMargDigit=0
				uRet :=IIF(SB1->B1_X_CSLOW = 0,SZH->ZH_MCIDEAL,SB1->B1_X_CSLOW)
			Else
				uRet := nMargDigit
			Endif
			//uRet := IIf( nMargDigit=0 , IIF(SB1->B1_X_CSLOW = 0,SZH->ZH_MCIDEAL,SB1->B1_X_CSLOW) , nMargDigit )
			
		Else
			/*  Solicitado pelo Sr. Mauricio 20/07/05 - Nao deseja ver a mensagem
			Aviso("ATENCAO", "Existem problemas no SZH a chave B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC+B1_X_LMN igual a "+;
			SB1->(B1_X_PQR+B1_X_NEOIL+B1_X_XYZ+B1_X_123+B1_X_ABC+B1_X_LMN) + "nao foi encontrada no campo ZH_AUXILIAR "+;
			"para determinar a Margem do Produto. Produto Cod. "+SB1->B1_COD+chr(13)+;
			"O Sistema assumira margem de 30% para o produto",{"&Ok"})
			*/
			uRet:= 30
			
		Endif
		
	Else
		
		Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo "+cProduto+;
		"nao esta Cadastrado."+CHH(13)+CHR(13)+;
		"Tentativa de determinar a Margem da Sku pela Funcao AjudCalc() falho."+CHR(13)+;
		"O Sistema assumira margem de 30% para o produto",{"&Ok"})
		uRet:= 30
		
	Endif
	
	
Elseif Upper(cParam) = "COMISSAO"
	
	
	//������������������������������������������������������������������������Ŀ
	//� Comissao                              �                                |
	//��������������������������������������������������������������������������
	// O percentual utilizado para calculo pode vir do parametro ou da
	// somatoria dos vendedores contidos no SA1+VENDEDOR INTERNO.
	If substr(_n_Mv_Comical,1,1) = "T"        //substr(GetMv("MV_COMICAL"),1,1) <> "T"
		
		
		uRet:= VAL(substr(_n_Mv_Comical,2,10))
		
	Else
		
		
		//������������������������������������������������������������������������Ŀ
		//� Comissao                              �                                |
		//��������������������������������������������������������������������������
		_X_Comissao  :=  0
		
		If Upper(Funname()) != "#MFATC04"
			
			AADD(aVend,M->CJ_X_VEND1)         //     Vendedor Interno.

			AADD(aVend,SA1->A1_X_VEND2)
			AADD(aVend,SA1->A1_X_VEND3)
			AADD(aVend,SA1->A1_X_VEND4)
			AADD(aVend,SA1->A1_X_VEND5)

			DbSelectArea("SA3")
			uRet:=0
			For _nCont := 1 to len(aVend)
				If !EmptY(aVend[_nCont])
					If Dbseek(xFilial("SA3")+aVend[_nCont])
						
						///if lOrigem:= IIF(Funname()$ "MATA415",.T.,.F.)
						// A3_COMIS   % de comissao para venda Spot
						// A3_X_COMIS % de comissao para venda Contrato
						
						// 29.03.06 - Definido atraves da Solicitacao de Suporte 084
						//            que caso o vendedor for 2 e o campo A1_COMIS estiver preechido
						//            o valor da comisso vira do mesmo. alterado tambem MFATC01.PRW calculo simulador
						//if  _nCont = 2 .and. SA1->A1_COMIS <> 0
						//	uRet := uRet + IIf(lOrigem , SA1->A1_COMIS ,SA1->A1_COMIS)
						//else
						//	uRet := uRet + IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
						//Endif
						If M->CJ_X_TPVEN = "2"  // 1 = Spot; 2 = Contrato
							
							if  _nCont = 1 	//.and. SA1->A1_X_COMII <> 0
								
								uRet := uRet + IIf(lOrigem , SA1->A1_X_COMII ,SA3->A3_X_COMIS)
								
							Elseif _nCont = 2 //.and. SA1->A1_COMIS <> 0
								
								uRet := uRet + IIf(lOrigem , SA1->A1_COMIS   ,SA1->A1_COMIS)
								
							Elseif  _nCont = 3 //.and. SA1->A1_X_COMIE <> 0
								
								uRet := uRet + IIf(lOrigem , SA1->A1_X_COMIE ,SA1->A1_COMIS)
								
							Elseif  _nCont = 4 //.and. SA1->A1_X_COMIG <> 0
								
								uRet := uRet + IIf(lOrigem , SA1->A1_X_COMIG ,SA1->A1_COMIS)
								
							else
								
								uRet := uRet + IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
								
							Endif
							
						Else
							
							uRet := uRet + IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
							
						Endif
						
						
					Else
						
						Aviso("ATENCAO", "Existem vendedores cadastrados neste cliente que nao foram encontrados no Cadastro de Vendedores."+chr(13)+;
						"O Sistema assumira comissao de 0.00% para o produto",{"&Ok"})
						uRet:= 0
						
					Endif
				Endif
			Next _nCont
			
		Else
			
			AADD(aVend,cVend1)               //     Vendedor Interno no Contrato.

			AADD(aVend,SA1->A1_X_VEND2)
			AADD(aVend,SA1->A1_X_VEND3)
			AADD(aVend,SA1->A1_X_VEND4)
			AADD(aVend,SA1->A1_X_VEND5)
			
			For _nCont := 1 to len(aVend)
				If !EmptY(aVend[_nCont])
					If Dbseek(xFilial("SA3")+aVend[_nCont])
							
						uRet := uRet + IIf(lOrigem , SA3->A3_COMIS ,SA3->A3_X_COMIS)
						
					Else
						
						Aviso("ATENCAO", "Existem vendedores cadastrados neste cliente que nao foram encontrados no Cadastro de Vendedores."+chr(13)+;
						"O Sistema assumira comissao de 0.00% para o produto",{"&Ok"})
						uRet:= 0
						
					Endif
				Endif
			Next _nCont
    		
		Endif
		
		
	Endif
	
	
	//������������������������������������������������������������������������Ŀ
	//�Condicoes de Pagamento                                                  �
	//��������������������������������������������������������������������������
Elseif Upper(cParam) = "PGTO"
	
	If Empty(cPgtoDigit)
		
		Aviso("ATENCAO", "Condicao de Pagamento nao Informada na Tela Anterior."+CHR(13)+CHR(13)+;
		"O sistema assumira Cond.de Pgto 001",{"&Ok"})
		
		cPgtoDigit := "001"
		
	Endif
	
	
	
	DbSelectArea("SE4")
	DbSetOrder(1)
	if  !Dbseek(xFilial("SE4")+cPgtoDigit) //_cGetCond)
		
		Aviso("ATENCAO", "Condicao de Pagamento "+_cGetCond+" nao Cadastrada."+CHR(13)+CHR(13)+;
		"O sistema assumira Cond.de Pgto 001",{"&Ok"})
		
		cPgtoDigit := "001"
		
	Endif
	
	
	IF   ("MATA415" $ Upper(Funname()))
		M->CJ_CONDPAG:=  cPgtoDigit
	Else
		CCONDPAG  :=  cPgtoDigit
	Endif
	
	Dbseek(xFilial("SE4")+ cPgtoDigit)    //_cGetCond)
	
	
	_uString:=SE4->E4_CODIGO                   // Estou utilizando este metodo pois caso seja
	
	aElem:=condicao(100,_uString)
	
	uRet := 0
	For nY := 1 to Len(aElem)
		nDias:= (aElem[nY][1] - dDataBase)  // Numero de Dias de Cada Parcela
		uRet := uRet + nDias
	Next
	
	uRet := ROUND(uRet / len(aElem),0 )
	
	
ENDIF


RestArea(aAreaD)

Return(uRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcSim   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua todos os calculos necessarios para determinar:       ���
���          �a) Novo Preco do Produto                                    ���
���          �b) Determina a Rentabilidade do Item                        ���
���          �c) Calcula o Preco Total                                    ���
���          �c) Informa a Rentabilidade Media em % e $                   ���
���          �Preco do Produto                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function CalcSim(nLin,lValid)

Local cAreaAtu    := GetArea()

//������������������������������������������������������������������������Ŀ
//� O conteudo das variaveis abaixo tem como origem o acols.               �
//��������������������������������������������������������������������������
Local _nQtdven    := 0
Local _nPreunit   := 0
Local _nPrcven    := 0
Local _nValor     := 0
Local _nMargV     := 0
Local _nMargA     := 0
Local _nMargE     := 0
Local _nDescont   := 0
//Local _nIpi       := 0
//Local _nIcm       := 0
Local _nPis       := 0
Local _nCofins    := 0
Local _nCpmf      := 0
Local _nCtStd     := 0
Local lPrecoAlt   := .F.


//������������������������������������������������������������������������Ŀ
//� Variaveis necessarias para execucao dos Calculos pela Funcao ExecCalc  �
//��������������������������������������������������������������������������
Local _X_Custo    := 0
Local _X_Margem   := 0
Local _X_Ipi      := 0
Local _X_Comissao := 0
Local _X_Pis      := 0
Local _X_Cofins   := 0
Local _X_Cpmf     := 0
Local _X_Icms     := 0
Local _X_Frete    := 0
Local _X_TxFinan  := 0
Local _X_PrazoVe  := 0
Local _X_DescLin  := 0
Local _x_DescAll  := 0


Local nY          := 0
//������������������������������������������������������������������������Ŀ
//� Variaveis auxiliares para ajudar nos calculos.                         �
//��������������������������������������������������������������������������
Local _uString               // Retorna o numero de dias para a cond.de Pagto

Private lCancelar := .F.

Private _n_Mv_Jurmes := GetMV("MV_JURMES")          //  Juros no Mes   (Especifico)
Private _n_Mv_Comical:= GetMV("MV_COMICAL")


DEFAULT lValid    := .F.


//Estou considerando apenas no momento do calculo mostrar em tela
//pois um item pode ser deletado e neste momento esta rotina deve ser
//chamada
  
// 20100921 - Solicitado pelo mauricio que os itens deletados tambem fossem calculados
//            conforme solicitacao da Auditoria.
//            Estavam existindo casos em que o funcionario deletava o item para alterar
//            os precos burlando o sistema e apos feito isto voltava a linha deletada.
//            a linha deletada somente nao esta sendo considerada.                                    
//            para o calculo da media geral.

//if aCols[nLin][Len(aHeader)+1]  // Item deletado do Acols no Simulador
//	Return(.T.)                   // Nao e necessario calcular
//Endif


//������������������������������������������������������������������������Ŀ
//�Posiciona o item no Cadastro de Clientes                                �
//��������������������������������������������������������������������������
DbSelectArea("SA1")
DbSetorder(1)
Dbseek(xFilial("SA1")+_cCliente+_cLoja)


// Todos os campos utilizados em calculos tiveram seus nomes alterados para ALT_<nome do Campo>
// este procedimento foi necessario em funcao desta rotina ser utilizada no orcamento e no
// contrato.
// O objetivo desta alteracao e viabilizar a analise das variaveis de memoria quando o usuario
// efetua o primeiro enter em uma das variaveis abaixo.

_nQtdven  :=IIF(lValid .AND. TYPE("M->ALT_QTDVEN")  <>"U",&("M->ALT_QTDVEN")   ,oget:aCols[nLin][xQtdven] )
_nCtStd   :=IIF(lValid .AND. TYPE("M->ALT_CTSTD")   <>"U",&("M->ALT_CTSTD")    ,oget:aCols[nLin][xCtStd] )
_nPrcven  :=IIF(lValid .AND. TYPE("M->ALT_PRCVEN")  <>"U",&("M->ALT_PRCVEN")   ,oget:aCols[nLin][xPrcven] )
_nValor   :=IIF(lValid .AND. TYPE("M->ALT_VALOR")   <>"U",&("M->ALT_VALOR" )   ,oget:aCols[nLin][xValor] )
_nMarge   :=IIF(lValid .AND. TYPE("M->ALT_MARGE")   <>"U",&("M->ALT_MARGE")    ,oget:aCols[nLin][xMargE] )
_nSlow    :=IIF(lValid .AND. TYPE("M->ALT_SLOW")    <>"U",&("M->ALT_SLOW")     ,oget:aCols[nLin][xSlow] )
_nMargV   :=IIF(lValid .AND. TYPE("M->ALT_MARGV")   <>"U",&("M->ALT_MARGV" )   ,oget:aCols[nLin][xMargV] )
_nDescont :=IIF(lValid .AND. TYPE("M->ALT_XDES")    <>"U",&("M->ALT_XDES")     ,oget:aCols[nLin][xDescont] )
//_nIpi     :=IIF(lValid .AND. TYPE("M->ALT_IPI")     <>"U",&("M->ALT_IPI")      ,aCols[nLin][xIpi] )
//_nIcm     :=IIF(lValid .AND. TYPE("M->ALT_ICM")     <>"U",&("M->ALT_ICM")      ,aCols[nLin][xIcm] )
_nPis     :=IIF(lValid .AND. TYPE("M->ALT_PIS")     <>"U",&("M->ALT_PIS")      ,oget:aCols[nLin][xPis] )
_nCofins  :=IIF(lValid .AND. TYPE("M->ALT_COFINS")  <>"U",&("M->ALT_COFINS")   ,oget:aCols[nLin][xCofins] )
_nCpmf    :=IIF(lValid .AND. TYPE("M->ALT_CPMF")    <>"U",&("M->ALT_CPMF")     ,oget:aCols[nLin][xCpmf] )
_cTes     :=IIF(lValid .AND. TYPE("M->C6_TES")      <>"U",&("M->C6_TES")       ,oget:aCols[nLin][xTes] )

_nMargA   := oget:aCols[nLin][xMargA]


DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+oget:aCols[nLin][xProduto])
	Aviso("ATENCAO", "Existem problemas na Tabela SB1 - Sku Codigo "+xFilial("SB1")+oget:aCols[nLin][xProduto]+;
	"nao Cadastrado.",{"&Ok"})
	Return(.f.)
Endif

//
// Garante o posicionamento da Tes apos sair da Funcao acima.
//
SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+_cTes))


//������������������������������������������������������������������������Ŀ
//�Custo do Produto                                                        �
//��������������������������������������������������������������������������
//_X_Custo  := U_AjudCalc("CUSTO",SB1->B1_COD,0,"",@lCancelar,.T.)
_X_Custo    := _nCtStd
//������������������������������������������������������������������������Ŀ
//�Margem do Produto                                                       �
//��������������������������������������������������������������������������
_X_Margem   := U_AjudCalc("MARGEM",SB1->B1_COD,_nMarge,"",@lCancelar,.T.)
//������������������������������������������������������������������������Ŀ
//�Comissao do Item                                                        �
//��������������������������������������������������������������������������
_X_Comissao := U_AjudCalc("COMISSAO",SB1->B1_COD,0,"",@lCancelar,.T.)
//������������������������������������������������������������������������Ŀ
//�Condicoes de Pagamento                                                  �
//��������������������������������������������������������������������������
_uString    := U_AjudCalc("PGTO",SB1->B1_COD,0,_cGetCond,@lCancelar,.T.)
//������������������������������������������������������������������������Ŀ
//�Icms utilizado no Calculo                                               �
//��������������������������������������������������������������������������
//_X_Icms   :=  _nIcm // O % DE ICMS NAO PODE FICAR CONGELADO POIS PODEM 
                        // OCORRER TROCA DE TES EXEMPLO TER QUE NAO CALCULA ICMS.  
                        // ESTOU BUSCANDO UTILIZAR O CLIENTE DE ENTREGA
                        // Esta funcao necessita a Tes posicionada o que ja foi 
                        // feito acima.
_X_Icms     := U_IcmsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
        
//������������������������������������������������������������������������Ŀ
//�Ipi utilizado no Calculo                                               �
//��������������������������������������������������������������������������
_X_Ipi        := U_IpiAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)
    
//������������������������������������������������������������������������Ŀ
//�Cofins Utilizado no Calculo                                             �
//��������������������������������������������������������������������������
_X_Cofins   := U_CofinsAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)

//������������������������������������������������������������������������Ŀ
//�Pis  Utilizado no Calculo                                               �
//��������������������������������������������������������������������������
_X_Pis      := U_PisAliq(_cClient,_cLojaEnt,SB1->B1_COD,_cTes)


If lCancelar
	Return({})
Endif


//������������������������������������������������������������������������Ŀ
//�                         Inicio dos Calculos                            �
//��������������������������������������������������������������������������

//������������������������������������������������������������������������Ŀ
//�	Rotina 2		Simula��o de pre�os dos produtos atrav�s de alteracoes |
//|                 de dados pr�-definidos (margem de contribui��o,        |
//|                 comiss�o de vendas, fretes, prazo)				   	   |
//��������������������������������������������������������������������������
_X_Margem     :=  _nMarge  // Margem digitada.
//_X_Ipi        :=  _nIpi
//_X_Pis        :=  _nPis
//_X_Cofins     :=  _nCofins
_X_Cpmf       :=  _nCpmf
_X_Frete      :=  _nGetFrete
_X_TxFinan    :=  _n_Mv_Jurmes
_X_PrazoVe    :=  _uString
_X_DescLin    :=  _nDescont
_x_DescAll    :=  _nGetDesc

//��������������������������������������������������������Ŀ
//�lPrVenda Verifica se a Tecla F11 (Rastreia o Calculo)   �
//�foi ativada caso afirmativo nao altera o ultimo lPrecoalt�
//�Isto tem como objetivo podermos analisar a rastreab.    �
//�levando-se em conta a ultima forma de calculo.          �
//����������������������������������������������������������

// lPrecoAlt - caso seja enviada via parametro nao seja
//             necessario uma analise

If !lPrVenda
	//��������������������������������������������������������Ŀ
	//�Verifica se a alteracao partiu do preco de venda, caso, �
	//�afirmativo executa o calculo de novo maneira            �
	//����������������������������������������������������������
	IF (lValid .AND. TYPE("M->ALT_PRCVEN")<>"U") .OR. (lValid .AND. TYPE("M->ALT_XDES")<> "U") .OR. _nGetDesc <> 0 
		lPrecoAlt:=.T.
	Else
		lPrecoAlt:=.F.	
	Endif
Endif



aPrVenda := {}
aPrVenda := U_ExecCalc(_X_Custo ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,lPrecoAlt,_nPrcven,nLin,_cIndComer)


//������������������������������������������������������������������������Ŀ
//� Resultado da Rotina 3 - Efetua Atualizacoes de Tela                    �
//��������������������������������������������������������������������������
// 1) Atualiza a Rentabilidade em termos de Valor($)
oget:aCols[nLin][xMargV]  := aPrVenda[03,03]
// 2) Atualiza o Preco de Venda do Produto(Preco SImulado)
oget:aCols[nLin][xPrcven] := aPrVenda[02,03]
// 3) Atualiza o Preco Total
oget:aCols[nLin][xValor]  := oget:aCols[nLin][xPrcven] * _nQtdven
// 4) O Icms em funcao de Alguma alteracao na Tes.
oget:aCols[nLin][xIcm]    := _X_Icms
// 5) O IpI em funcao de Alguma alteracao na Tes.
oget:aCols[nLin][xIPI]    := _X_IPI
// 5) O Pis em funcao de Alguma alteracao na Tes.
oget:aCols[nLin][xPis]    := _X_PIS
// 5) O Cofins em funcao de Alguma alteracao na Tes.
oget:aCols[nLin][xCofins] := _X_COFINS


oget:aCols[nLin][xDescont]:= 0                           
M->ALT_XDES          := 0
_nGetDesc         := 0

If lPrecoAlt
	
	
	oget:aCols[nLin][xMargE]  := aPrVenda[04,03]
	M->ALT_MARGE         := aPrVenda[04,03]
	
	//��������������������������������������������������������������������Ŀ
	//�Este parametro permite que o calculo apos efetuado pela rotina  4   �
	//�rotina que trata desconto seja refeito pela Rotina 1                �
	//����������������������������������������������������������������������
	
	If GETMV("MV_TIPCAL")
		
		U_CalcSim(nLin,.F.)   // Chamo novamente para ajustar corretamente com base na Rotina 1
		
	Endif
	
Endif



// Neste ponto e avaliado definitivamente no simulador se o item se encontra
// liberado ou broqueado.
_nMarge   :=IIF(lValid .AND. TYPE("M->ALT_MARGE")   <>"U",&("M->ALT_MARGE")    ,oget:aCols[nLin][xMargE] )

oget:aCols[nLin][xMargA]  :=  U_AvalMarg(_nMarge)

U_MediaRent(lValid,nLin)

oGet:oBrowse:Refresh()

If  oGetRent <> nil
	oGetDesc:Refresh()
	oGetRent:Refresh()
	oGetRenVr:Refresh()
	//oGet:oBrowse:SETFOCUS()
Endif


//������������������������������������������������������������������������Ŀ
//� Ativa Tela para demostrar como foram efetuados os calculos.            �
//��������������������������������������������������������������������������
if lPrVenda
	DemoPreco(aPrVenda,@lPrVenda)
Endif


RestArea(cAreaAtu)

Return(.T.)






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExecCalc  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua todos os calculos necessarios para determinar:       ���
���          �a) Novo Preco do Produto                                    ���
���          �b) Determina a Rentabilidade do Item                        ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ExecCalc(_X_Custo  ,_X_Margem,_X_Ipi ,_X_Comissao,_X_Pis,;
_X_Cofins ,_X_Cpmf   ,_X_Icms,_X_Frete   ,_X_TxFinan,;
_X_PrazoVe,_X_DescLin,_x_DescAll,lPrecoAlt,_nPrcven,;
nPosicao,_cIndComer)
Local _nK := 0
Local _nJ := 0
Local _nA := 0
Local _nX := 0
Local _nB := 0
Local _nD := 0
Local _nE := 0
Local _nI := 0
Local _nC := 0
Local _nF := 0
Local _nG := 0
Local _n00    := 0
Local _n01    := 0
Local _n02    := 0
Local _n22    := 0
Local _n03    := 0
Local _n04    := 0
Local _n05    := 0
Local _n06    := 0
Local _n07    := 0
Local _n08    := 0
Local _n09    := 0
Local _n10    := 0
Local _n11    := 0
Local _n12    := 0
Local _n13    := 0
Local _n14    := 0
Local _cT1    := 0
Local _nZ     := 0
Local aResult := {}
Default _X_Custo	:=0
Default _X_Margem	:=0
Default _X_Ipi 		:=0
Default _X_Comissao :=0
Default _X_Pis		:=0
Default _X_Cofins 	:=0
Default _X_Cpmf   	:=0
Default _X_Icms		:=0
Default _X_Frete   	:=0
Default _X_TxFinan	:=0
Default _X_PrazoVe	:=0
Default _X_DescLin	:=0
Default _x_DescAll	:=0
Default _nPrcven	:=0
Default nPosicao	:=0
Default _cIndComer	:=""
Default lPrecoAlt	:=.F.

_X_Custo     := _X_Custo    // Custo do Produto
_X_Margem    := _X_Margem   /100
_X_Ipi       := _X_Ipi      /100
_X_Comissao  := _X_Comissao /100
_X_Pis       := _X_Pis      /100
_X_Cofins    := _X_Cofins   /100
_X_Cpmf      := _X_Cpmf     /100
_X_Icms      := _X_Icms     /100
_X_Frete     := _X_Frete    /100
_X_TxFinan   := _X_TxFinan  // Taxa Financeira
_X_PrazoVe   := _X_PrazoVe  // Prazo de Vencimento
_X_DescLin   := _X_DescLin  /100
_x_DescAll   := _x_DescAll  /100


//������������������������������������������������������������������������Ŀ
//�_nK	% das despesas vari�veis de vendas + % de margem de contribui��o   |
//|  	  (%pis + %cofins + %icms + %cpmf + %frete + %comiss�o +           |
//|       margem de contribui��o)			                               |
//��������������������������������������������������������������������������
_nK := _X_Pis + _X_Cofins  + _X_Icms + _X_Cpmf + _X_Frete + _X_Comissao + _X_Margem
//������������������������������������������������������������������������Ŀ
//�_nJ	% Juros imputado ao prazo de dias concedido na venda com base na   |
//|       taxa mensal cadastrada	                                       |
//| 	  nj = (1+%am)^(1/30)^n.dias - 1			                       |
//��������������������������������������������������������������������������
_nJ := Round( ( 1 + _X_TxFinan / 100  ) ^ (1/30) ^ _X_PrazoVe - 1 , 4 )
//������������������������������������������������������������������������Ŀ
//|_nA   Pre�o de Venda a Vista sem IPI                                    |
//|      _nX = $custo / ( 1 - _nk)                                         |
//��������������������������������������������������������������������������
_nA :=  _X_Custo	/ ( 1 - _nK )
//������������������������������������������������������������������������Ŀ
//|_nI   % Despesas vari�veis de vendas                                    |
//��������������������������������������������������������������������������
_nI := ( _nK - _X_Margem ) * 100
//������������������������������������������������������������������������Ŀ
//|_nC   Valor da mercadoria                                               |
//��������������������������������������������������������������������������
_nC := ROUND(_X_Custo  /  (  1- (_nK +  _nJ ) ),2)
//������������������������������������������������������������������������Ŀ
//|     Calculo Utilizado somente para o caso Consumo                      |
//��������������������������������������������������������������������������
If _cIndComer =  "C"
	_nC := ROUND(_nC + ( _nC * (_X_Ipi * _X_Icms)),2)
Endif
//������������������������������������������������������������������������Ŀ
//|_n03  $ Preco de Venda Simulado (sem Ipi)                               |
//��������������������������������������������������������������������������
if lPrecoAlt
	// A entrada aqui ocorre quando digitou um novo preco fica valendo o
	// preco digitado para continuacao do calculo ou quando da um desconto
	// no Item fica falendo o Preco da Rotina 1 para aplicar o desconto Linear.
	if _X_DescLin <> 0 .And. nPosicao>0  .And. xPrcVen>0
		//_nPrcVen:= aCols[nPosicao][xPreunit]  // Preco da Rotina 1
		// Apos conversa com Mauricio o desconto deve ser aplicado sobre o preco simulado e 
		// e nao sobre o preco sugerido (Rotina 1).  17/08/2010
		_nPrcVen:= oget:aCols[nPosicao][xPrcven]  
	Endif
	
	_n03    :=  _nPrcven
	//������������������������������������������������������������������������Ŀ
	//|_n22  $ Desconto Concedido                                              |
	//��������������������������������������������������������������������������
	_n22	   :=  _n03 * _X_DescLin
	_n03    :=  Round( _n03 * (1 - _X_DescLin),2)
Else
	_n03    :=  _nC
Endif

//������������������������������������������������������������������������Ŀ
//|_n00  $ Preco de Venda Base p/ Desconto                                 |
//��������������������������������������������������������������������������
_n00    :=  _n03 * _x_DescAll
_n03    :=  Round( _n03 * (1 - _x_DescAll),2)
//������������������������������������������������������������������������Ŀ
//|_n12  $ Margem de Contribuicao                                          |
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//|_n13  % Margem de Contribuicao                                          |
//��������������������������������������������������������������������������
If _cIndComer ==  "C"
	_nZ      :=  ROUND( _n03 /  ((_X_Ipi * _X_Icms)+1) , 2 )
	_n12     :=  _nZ * ( 1-  ( ( _nK  - _X_Margem + _nJ  ) ) ) - _X_Custo
	_n13     :=  ROUND((_n12 / _nZ ) * 100 ,2)
Else
	_n12     :=  _n03 * ( 1-  ( ( _nK  - _X_Margem + _nJ  ) ) ) - _X_Custo
	_n13     :=  ROUND((_n12 / _n03 ) * 100,2)
Endif
//������������������������������������������������������������������������Ŀ
//|_CT1 Avaliacao da Margem de Contribuicao (Bloqueado / Liberado)         |
//|     neste ponto estamos apenas avaliando para mostrar em tela
//��������������������������������������������������������������������������
if lPrecoAlt
	_cT1     :=   U_AvalMarg(_n13 )
Else
	_cT1     :=   U_AvalMarg(_X_Margem * 100 )
Endif




//
//
//  Os  calculos abaixos sao apenas para demonstracao nao fazem parte do
//  Calculo Total
//
//


//������������������������������������������������������������������������Ŀ
//|_nB  re�o de Venda a Vista com IPI                                      |
//|      _nB =  %ipi *  _nX	                                               |
//��������������������������������������������������������������������������
_nB :=  _nA * ( 1+_X_Ipi )

//������������������������������������������������������������������������Ŀ
//|_nD   Custo Financeiro da Venda                                         |
//��������������������������������������������������������������������������
_nD =    _nJ * _nB


//������������������������������������������������������������������������Ŀ
//|_nE   % Margem de contribui��o da venda                                 |
//��������������������������������������������������������������������������
_nE :=   _X_Margem * _nA


//������������������������������������������������������������������������Ŀ
//|_nF   Preco de Venda a Prazo com Ipi                                    |
//��������������������������������������������������������������������������
_nF :=  _nC * ( 1 + _X_Ipi )


//������������������������������������������������������������������������Ŀ
//|_nG   Preco de Venda a Prazo sem IPI/ICMS                               |
//|      G = C * (1 - % icms)                                              |
//��������������������������������������������������������������������������
_nG :=  _nC * ( 1 - _X_Icms )


//������������������������������������������������������������������������Ŀ
//|_n01  $ Preco de Venda Simulado Com Ipi                                 |
//��������������������������������������������������������������������������
_n01	   :=  _n03 * ( 1 + _X_Ipi)

//������������������������������������������������������������������������Ŀ
//|_n02  $ Valor do Ipi                                                    |
//��������������������������������������������������������������������������
_n02	   :=  _n03 * _X_Ipi


//������������������������������������������������������������������������Ŀ
//|_n04  $ Comissao                                                        |
//��������������������������������������������������������������������������
_n04	   :=   _n03 * _X_Comissao

//������������������������������������������������������������������������Ŀ
//|_n05  $ Pis                                                             |
//��������������������������������������������������������������������������
_n05	  :=    _n03 * _X_Pis

//������������������������������������������������������������������������Ŀ
//|_n06  $ Cofins                                                          |
//��������������������������������������������������������������������������
_n06	  :=    _n03 *  _X_Cofins

//������������������������������������������������������������������������Ŀ
//|_n07  $ Cpmf                                                            |
//��������������������������������������������������������������������������
_n07	  :=     _n03 * _X_Cpmf

//������������������������������������������������������������������������Ŀ
//|_n08  $ Icms                                                            |
//��������������������������������������������������������������������������
_n08	  :=     _n03 * _X_Icms

//������������������������������������������������������������������������Ŀ
//|_n09  $ Frete                                                           |
//��������������������������������������������������������������������������
_n09	  :=     _n03 * _X_Frete

//������������������������������������������������������������������������Ŀ
//|_n10  $ Financiero                                                      |
//��������������������������������������������������������������������������
_n10      :=   ( _n03 * (1+ _x_ipi) / (1 + _nJ)) * _nJ

//������������������������������������������������������������������������Ŀ
//|     Calculo Utilizado somente para o caso Consumo (Icm Sobre Ipi )     |
//��������������������������������������������������������������������������
if _cIndComer =  "C"
	_n14 := ( _n03 * (_X_Ipi * _X_Icms))
Else
	_n14 := 0
Endif

//������������������������������������������������������������������������Ŀ
//|_n11  $ Soma dos Impostos e Tx Financiero                               |
//|        Soma dos Impostos e Tx Financiero                               |
//|        _n04  $ Comissao                                                |
//|        _n05  $ Pis                                                     |
//|        _n06  $ Cofins                                                  |
//|        _n07  $ Cpmf                                                    |
//|        _n08  $ Icms                                                    |
//|        _n09  $ Frete                                                   |
//|        _n10  $ Financiero                                              |
//��������������������������������������������������������������������������
_n11     :=  _n04 + _n05 + _n06 + _n07 + _n08 + _n09 + _n10 + _n14





//������������������������������������������������������������������������Ŀ
//|Gera Matriz para Retornar as Informacoes                                |
//|Apartir do 6 elemento da matriz existem informacoes que poderam ser     |
//|utilizadas no futuro para demostracao dos calculos.                     |
//��������������������������������������������������������������������������
Aadd(aResult,{"Dados Aproveitados Apos os Calculos" , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"Preco de Venda Simulado sem IpI    " , "_n03      "           , _n03              ,"   ","N","               "})      // Preco de Venda  [2]
Aadd(aResult,{" $ Margem de Contribuicao (calcul) " , "_n12      "           , _n12              ,"   ","N","               "})      // $ Margem        [3]
Aadd(aResult,{" % Margem de Contribuicao (calcul) " , "_n13      "           , _n13              ,"   ","N","               "})      // % Margem        [4]
Aadd(aResult,{" Bloqueado / Liberado              " , "_cT1      "           , _cT1              ,"   ","C","                "})      // Bloqueado / Liberado
Aadd(aResult,{"Margem Contribuicao do Produto     " , "_X_Margem "           , _X_Margem * 100   ,"   ","N","ZH_            "})


Aadd(aResult,{"                                   " , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"Dados Utilizados                   " , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"================                   " , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"Cliente                            " , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"    Codigo do Clinte               " , "A1_COD    "           , SA1->A1_COD       ,"   ","C",SPACE(09)+"SA1->A1_COD    "})
Aadd(aResult,{"    Loja do Cliente                " , "A1_LOJA   "           , SA1->A1_LOJA      ,"   ","C",SPACE(13)+"SA1->A1_LOJA   "})
Aadd(aResult,{"    Estado do Cliente (ICMS)       " , "A1_EST    "           , SA1->A1_EST       ,"   ","C",SPACE(13)+"SA1->A1_EST    "})
If  !(Upper(Funname()) $ "#MFATC02B|#MFATC02C|#MFATC02D")
	If Upper(Funname()) != "#MFATC04"
		Aadd(aResult,{"    Vendedor 1                  " , "CJ_X_VEND1"           , M->CJ_X_VEND1  ,"   ","C",SPACE(10)+"SCJ->A1_X_VEND1"})
	Else
		Aadd(aResult,{"    Vendedor 1                  " , "cVend1    "           , cVend1       ,"   ","C","               "})
	Endif
Endif
Aadd(aResult,{"    Vendedor 2                     " , "A1_X_VEND2"           , SA1->A1_X_VEND2   ,"   ","C",SPACE(10)+"SA1->A1_X_VEND2"})
Aadd(aResult,{"    Vendedor 3                     " , "A1_X_VEND3"           , SA1->A1_X_VEND3   ,"   ","C",SPACE(10)+"SA1->A1_X_VEND3"})
Aadd(aResult,{"    Vendedor 4                     " , "A1_X_VEND4"           , SA1->A1_X_VEND4   ,"   ","C",SPACE(10)+"SA1->A1_X_VEND4"})
Aadd(aResult,{"    Vendedor 5                     " , "A1_X_VEND5"           , SA1->A1_X_VEND5   ,"   ","C",SPACE(10)+"SA1->A1_X_VEND5"})
Aadd(aResult,{"Produto                            " , "          "           , 0                 ,"   ","C","               "})
Aadd(aResult,{"    Referencia                     " , "B1_X_REFER"           , SB1->B1_X_REFER   ,"   ","C","SB1->B1_X_REFER"})
Aadd(aResult,{"    Sufixo                         " , "B1_X_SUFIX"           , SB1->B1_X_SUFIX   ,"   ","C",SPACE(07)+"SB1->B1_X_SUFIX"})
Aadd(aResult,{"    Simil                          " , "B1_X_MARCA"           , SB1->B1_X_MARCA   ,"   ","C",SPACE(13)+"SB1->B1_X_MARCA"})
Aadd(aResult,{"    Cod.do Produto                 " , "B1_COD    "           , SB1->B1_COD       ,"   ","C",SPACE(01)+"SB1->B1_COD    "})
Aadd(aResult,{"Tes                                " , "F4_CODIGO "           , SF4->F4_CODIGO    ,"   ","C",SPACE(13)+"SF4->F4_CODIGO "})
Aadd(aResult,{"Cond. de Pagamento                 " , "E4_CODIGO "           , SE4->E4_CODIGO    ,"   ","C",SPACE(13)+"SE4->E4_CODIGO "})
Aadd(aResult,{"                                   " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"Custo Padrao                       " , "_X_Custo  "            , _X_Custo          ,"   ","N","B1_CUSTD       "})
Aadd(aResult,{"Margem Contribuicao                " , "_X_Margem "            , _X_Margem   * 100 ,"   ","N","ZH_            "})
Aadd(aResult,{"Ipi                                " , "_X_Ipi    "            , _X_Ipi      * 100 ,"   ","N","B1_IPI         "})
Aadd(aResult,{"Comissao                           " , "_X_Comissao"           , _X_Comissao * 100 ,"   ","N","SA1/SE3        "})
Aadd(aResult,{"Pis                                " , "_X_Pis    "            , _X_Pis      * 100 ,"   ","N","MV_TXPIS       "})
Aadd(aResult,{"Cofins                             " , "_X_Cofins "            , _X_Cofins   * 100 ,"   ","N","MV_TXCOFIN     "})
Aadd(aResult,{"CPMF                               " , "_X_Cpmf   "            , _X_Cpmf     * 100 ,"   ","N","MV_CPMF        "})
Aadd(aResult,{"ICMS                               " , "_X_Icms   "            , _X_Icms     * 100 ,"   ","N","MV_ESTICM      "})
Aadd(aResult,{"Frete                              " , "_X_Frete  "            , _X_Frete    * 100 ,"   ","N","MV_FRETEC      "})
Aadd(aResult,{"Tax. Financeira Mes                " , "_X_TxFinan"            , _X_TxFinan        ,"   ","N","MV_JURMES      "})
Aadd(aResult,{"Dias de prazo na Venda             " , "_X_PrazoVe"            , _X_PrazoVe        ,"   ","N","SE4            "})
Aadd(aResult,{"Desconto Linear                    " , "_X_DescLin"            , _X_DescLin        ,"   ","N","               "})
Aadd(aResult,{"Desconto Total                     " , "_x_DescAll"            , _x_DescAll        ,"   ","N","               "})

Aadd(aResult,{"                                   " , "          "            ,                   ,"   ","C","               "})
Aadd(aResult,{"Inicio dos Calculos Fase I         " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"==========================         " , "          "            , 0                 ,"   ","C","               "})

Aadd(aResult,{"% das Despesas Variaveis + Magem   " , "_nK       "            , _nK  * 100        ,"   ","N","               "})
Aadd(aResult,{"% de  Juros                        " , "_nJ       "            , _nJ               ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda a Vista Sem Ipi     " , "_nA       "            , _nA               ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda a Vista Com Ipi     " , "_nB       "            , _nB               ,"   ","N","               "})
Aadd(aResult,{"Custo Financeiro da Venda          " , "_nD       "            , _nD               ,"   ","N","               "})
Aadd(aResult,{"% Margem de Contribuicao da Venda  " , "_nE       "            , _nE               ,"   ","N","               "})
Aadd(aResult,{"% Despesas variaveis de Vendas     " , "_nI       "            , _nI               ,"   ","N","               "})
Aadd(aResult,{"Preco da Mercadoria                " , "_nC       "            , _nC               ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda a Prazo com IPI     " , "_nF       "            , _nF               ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda a Prazo sem IPI/ICM " , "_nG       "            , _nG               ,"   ","N","               "})

Aadd(aResult,{"                                   " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"Inicio dos Calculos Fase II        " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"===========================        " , "          "            , 0                 ,"   ","C","               "})


Aadd(aResult,{"Preco de Venda Base p/Desconto     " , "_n00      "            , _n00              ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda Simulado com Ipi    " , "_n01      "            , _n01              ,"   ","N","               "})
Aadd(aResult,{"IPI                                " , "_n02      "            , _n02              ,"   ","N","               "})
Aadd(aResult,{"Desconto Concedido                 " , "_n22      "            , _n22              ,"   ","N","               "})
Aadd(aResult,{"Preco de Venda Simulado sem IpI    " , "_n03      "            , _n03              ,"(1)","N","               "})
Aadd(aResult,{"(+)Comissao                        " , "_n04      "            , _n04              ,"   ","N","               "})
Aadd(aResult,{"(+)Pis                             " , "_n05      "            , _n05              ,"   ","N","               "})
Aadd(aResult,{"(+}Cofins                          " , "_n06      "            , _n06              ,"   ","N","               "})
Aadd(aResult,{"(+)Cpmf                            " , "_n07      "            , _n07              ,"   ","N","               "})
Aadd(aResult,{"(+)Icm                             " , "_n08      "            , _n08              ,"   ","N","               "})
Aadd(aResult,{"(+)Frete                           " , "_n09      "            , _n09              ,"   ","N","               "})
Aadd(aResult,{"(+)Financeiro                      " , "_n10      "            , _n10              ,"   ","N","               "})
Aadd(aResult,{"(-)Icms sobre Ipi                  " , "_n14      "            , _n14              ,"   ","N","               "})
Aadd(aResult,{" = Soma dos Impostos               " , "_n11      "            , _n11              ,"   ","N","               "})
Aadd(aResult,{" $ Margem de Contribuicao          " , "_n12      "            , _n12              ,"(2)","N","               "})
Aadd(aResult,{" % Margem de Contribuicao          " , "_n13      "            , _n13              ,"(3)","N","               "})
Aadd(aResult,{" Avaliacao da Marbem(Bloq/Liberado)" , "_cT1      "            , SPACE(13)+_cT1     ,"(4)","C","               "})

Aadd(aResult,{"                                   " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"Observacao (Retorno dos Calculos)  " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"=================================  " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"                                   " , "          "            , 0                 ,"   ","C","               "})
Aadd(aResult,{"(1)Preco de Venda Simulado sem IpI " , "_n03      "            , _n03              ,"   ","N","               "})      // Preco de Venda  [2]
Aadd(aResult,{"(2) $ Margem de Contribuicao       " , "_n12      "            , _n12              ,"   ","N","               "})      // $ Margem        [3]
Aadd(aResult,{"(3) % Margem de Contribuicao       " , "_n13      "            , _n13              ,"   ","N","               "})      // % Margem        [4]
Aadd(aResult,{"(4) Bloqueado / Liberado           " , "_cT1      "            , SPACE(13)+_cT1     ,"   ","C","               "})      // Bloqueado / Liberado



Return(aResult)






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AvalMarg  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Parametros|Libera o item com relacao a Rentabilidade.                  ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AvalMarg(_nGetRent)
Local aArea        := GetArea()
Local cRetorno     := "L"  // "LIBERADO"
Local _nMarg       := U_AjudCalc("MARGEM",SB1->B1_COD,0,"",@lCancelar,.T.)
Local _n_MV_Broqret:= GetMV("MV_BLOQRET")   //  Percentual de Bloqueiode Rentabilidade (Especifico)
Local _nRentab     := _n_MV_Broqret * ( _nMarg /100 )    // % Desconto Parametro / % Margem do SZH
// Ex.  30 / 0.25 = 7.5

Local _nMargMin    := _nMarg  -  _nRentab                // % Margem do SZH - % Encontrado acima
// Ex. 25 - 7.5 = 17.5  (Valor Minimo para venda)
Default _nGetRent	:=0
//�����������������������������������������������������������������������������������������Ŀ
//|Bloqueia o item com relacao a rentabilidade                                              �
//�onde  o % com base na rentabilidade do alvo /  rentabilidade digitada e menor que o valor�
//�percentual desejado.                                                                     �
//�������������������������������������������������������������������������������������������
if  _nGetRent <  _nMargMin
	cRetorno  := "B"
Endif              

RestArea(aArea) // Luciano - 26/04/2013

Return(cRetorno)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaDel  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Este funcao tem como objetivo gravar todos itens que foram ���
���          | deletados do acols durante o processo de Orcamento.        ���
���          |                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GravaDel()

Local cArqGrav   := "???"
Local cArqInic   := Substr(cArqGrav,1,2)
Local cCampo     := ""
Local nY         := 0
Local nz         := 0
LOcal aHeaderDes := {}

DbSelectArea("SX3")
DbSetorder(1)
Dbseek(cArqGrav)
While !cArqGrav->(EOF()) .and. SX3->X3_ARQUIVO # cArqGrav
	AADD(aHeaderDes,X3_CAMPO)
	SX3->(DBSKIP())
Enddo


For nY := 1 to len(acols)
	
	If oget:aCols[nY,Len(aHeader)+1 ]   // Acols = Deletado
		
		DbSelectArea(cArqGrav)
		
		Reclock(cArqGrav,.T.)
		For nZ := 1 to Len(aHeader)
			cCampo:=cArqInic+Substr(aHeader[nZ][2],7) // Transf. Campo origem em destino
			If "_FILIAL"$ cCampo
				Field->&(cCampo):= xFilial(cArqGrav)
			Else
				// Verifico se existe o Campo na base que sera appendada
				if Ascan(aHeaderDes,cCampo) # 0
					Field->&(cCampo):= oget:acols[nY][nZ]
				Endif
			Endif
		Next
		Msunlock()
		
	Endif
	
Next nY

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WhenSX3   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Este funcao tem como objetivo validar a utilizada do Acols ���
���          | Apenas pelo Simulador e nao Pelo Orcamento.                ���
���          |                                                            ���
���          | Os campos que se encontram nesta situacao sao os :         ���
���          | CK_X_MARGE tentei fazer o CK_QTDVEN trabalhando com when   ���
���          | mas nao tive sucesso pois os gatilhos do CK_QTDVEN interf  ���
���          | erem no processo.                                          ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function WhenSX3()
Local lRet         := .F.
Local cProcName    :=FunName()
Local ii           := 0

While !Empty(cProcName)
	If cProcName $ "U_MFATC01"   // Simulador esta utilizando
		lRet := .T.
		Exit
	Endif
	ii++
	cProcName := UPPER(AllTrim(ProcName(ii)))
EndDo

Return (lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DemoPreco �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Demonstra os calculos efetuados para definicao do Preco    ���
���          | lPrVenda - Controla a abertura da Janela                   ���
���          | aPrVenda - Matriz com dados a serem exibidos               ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DemoPreco(aPrVenda,lPrVenda)
Local uValor := 0
Local nY     := 0
For nY := 1 to len(aPrVenda)
	
	if alltrim(aPrVenda[nY,02]) = ""
		uValor := SPACE(14)
	Elseif  alltrim(aPrVenda[nY,05])    = "C"
		uValor := aPrVenda[nY,03]
	Else
		uValor := TRANSFORM(aPrVenda[nY,03],"@E 9,999,999,999.99")
	Endif
	
	AutoGrLog(aPrVenda[nY,01]+;
	uValor+;
	space(1)+;
	aPrVenda[nY,04]+;
	space(2)+;
	aPrVenda[nY,06])
	
Next Ny

lPrVenda := .F.

MostraErro()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IcmsAliq  �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Retornar a Alicota de Icms com base no Estado do Cliente e ���
���          | no parametro mv_esticm                                     ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IcmsAliq(cCliente,cLoja,cProduto,cTes)
Local _aArea   := GetArea()
Local nAliqEst := 0
Local nItem    := 0
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})

/*
DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1")+cCliente+cLoja)
nAliqEst   := Val(Subs(GETMV("MV_ESTICM"),AT(SA1->A1_EST,GETMV("MV_ESTICM"))+2,2))
if nAliqEst = 0
Aviso("ATENCAO", "Favor verificar parametro MV_ESTICM , estado do cliente "+SA1->A1_EST+;
"nao cadastrado ou alicota incorreta 0 .",{"&Ok"})
Endif
Endif


MaFisIni(cCliente,;					   		// 1-Codigo Cliente/Fornecedor
cLoja,;                           // 2-Loja do Cliente/Fornecedor
"C",;                             // 3-C:Cliente                 F:FornecedorIf(SC5->C5_TIPO$'DB',"F","C"),;
"N",;		                       	// 4-Tipo da NF
SA1->A1_TIPO,;	             		// 5-Tipo do Cliente/Fornecedor
aRelImp,;							      // 6-Relacao de Impostos que suportados no arquivo
,;						   			   // 7-Tipo de complemento
,;									      // 8-Permite Incluir Impostos no Rodape .T./.F.
"SB1",;						       	// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
"MATA461")							   // 10-Nome da rotina que esta utilizando a funcao

MaFisAdd(cProduto,; 	             		// 1-Codigo do Produto ( Obrigatorio )
,;				                  // 2-Codigo do TES ( Opcional )
1,;			                     // 3-Quantidade ( Obrigatorio )
1,;		                       	// 4-Preco Unitario ( Obrigatorio )
0,;                             // 5-Valor do Desconto ( Opcional )
,;							  	      // 6-Numero da NF Original ( Devolucao/Benef )
,;								      // 7-Serie da NF Original ( Devolucao/Benef )
,;					                // 8-RecNo da NF Original no arq SD1/SD2
0,;							          // 9-Valor do Frete do Item ( Opcional )
0,;							          // 10-Valor da Despesa do item ( Opcional )
0,;            			          // 11-Valor do Seguro do item ( Opcional )
0,;							          // 12-Valor do Frete Autonomo ( Opcional )
1,;                              // 13-Valor da Mercadoria ( Obrigatorio )
0,;							          // 14-Valor da Embalagem ( Opiconal )
0,;		     				          // 15-RecNo do SB1
0) 							          // 16-RecNo do SF4

nItem += 1

nAliqEst:=MAFISRET(nItem,"IT_ALIQICM")

MaFisEnd()

*/

SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+cTes))
SA1->(DbSelectArea("SA1"),DbSetOrder(1),DbSeek(xFilial("SA1")+cCliente+cLoja))
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+cProduto))

aExcecao := ExcecFis(SB1->B1_GRTRIB,IF(SC5->C5_TIPO$"DB",,SA1->A1_GRPTRIB))


//VERIFICA A ALIQUOTA DE ICMS DO CLIENTE
//           cEstf := SA1->A1_EST
//           nFAliqIcms := AliqIcms(     "N",;      // Tipo de Operacao
//           "S",;          // Tipo de Nota ('E'ntrada/'S'aida)
//           "C",;     // Tipo do Cliente ou Fornecedor
//           "I",;     // Tipo da Aliquota ("S"olidario/"I"cms)
//           '')     // Numero do Registro caso seja devolucao

nAliqEst := AliqIcms('N','S',SA1->A1_TIPOCLI,'I')    

nAliqEst := If(SB1->B1_ORIGEM='2' .AND. SA1->A1_EST = 'RJ'.AND. SM0->M0_ESTENT='ES', 4 , nAliqEst )  

nAliqEst := IIf(SF4->F4_ICM='S', nAliqEst ,0)

nAliqEst := IIf(SF4->F4_CODIGO='547', 18 , nAliqEst) `
// Situacao Especifica em funcao de agregar
// custo do icms ao Preco de Venda. (Substituicao Tributaria)    

// Tratativa para filial 20/04/2012 - MARCELO
nAliqEst := IIf(SF4->F4_BASEICM=41.18, 07 , nAliqEst)



// Melhoria somente para atenter casos especificos de Cotacao 
// 
DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+cCliente+cLoja)
If cCliente = '000002' .and. alltrim(xFilial("SA1")) $ '01' .and. alltrim(cLoja) $ '01/02/03'
   if cLoja = '01' 
      nAliqEst := 18
   Elseif cLoja = '02' 
      nAliqEst := 12 
   Elseif cLoja = '03'
      nAliqEst := 07 
   Endif
Endif

If cCliente = '000002' .and. alltrim(xFilial("SA1")) $ '11' .and. alltrim(cLoja) $ '01/02/03'
   if cLoja = '01' 
      nAliqEst := 17
   Elseif cLoja = '02' 
      nAliqEst := 12 
   Elseif cLoja = '03'
      nAliqEst := 07 
   Endif
Endif


If 	CFILANT = "14"
    DbSelectArea("SA1")
    DbSetOrder(1)
    If DbSeek(xFilial("SA1")+cCliente+cLoja)  
       If SA1->A1_EST="BA"
          nAliqEst := 18 
       Endif
    Endif   
Endif

RestArea(_aArea)

Return(nAliqEst)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IpiAliq   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Retornar a Alicota de IPI  com base no Cadastro de Produto ���
���          | e Tes                                                      ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IpiAliq(cCliente,cLoja,cProduto,cTes)
Local _aArea   := GetArea()
Local nAliqEst := 0
Local nItem    := 0

SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+cTes))
SA1->(DbSelectArea("SA1"),DbSetOrder(1),DbSeek(xFilial("SA1")+cCliente+cLoja))
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+cProduto))


nAliqEst := SB1->B1_IPI   

nAliqEst := IIf( SF4->F4_IPI='S', nAliqEst , 0 )

RestArea(_aArea)

Return(nAliqEst)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CofinsAliq�Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Retornar a Alicota de Cofins com base na Tes               ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CofinsAliq(cCliente,cLoja,cProduto,cTes)
Local _aArea   := GetArea()
Local nAliqEst := 0
Local nItem    := 0

SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+cTes))
SA1->(DbSelectArea("SA1"),DbSetOrder(1),DbSeek(xFilial("SA1")+cCliente+cLoja))
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+cProduto))

nAliqEst := GeTMv("MV_TXCOFIN")   //  Confins        (Padrao)
      
nAliqEst := IIf( !(SF4->F4_CSTCOF $ '07/08/09') , nAliqEst , 0 )

RestArea(_aArea)

Return(nAliqEst)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PisAliq   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Retornar a Alicota de Pis  com base na Tes                 ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PisAliq(cCliente,cLoja,cProduto,cTes)
Local _aArea   := GetArea()
Local nAliqEst := 0
Local nItem    := 0

SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+cTes))
SA1->(DbSelectArea("SA1"),DbSetOrder(1),DbSeek(xFilial("SA1")+cCliente+cLoja))
SB1->(DbSelectArea("SB1"),DbSetOrder(1),DbSeek(xFilial("SB1")+cProduto))

nAliqEst := GetMv("MV_TXPIS")     //  Pis            (Padrao)

nAliqEst := IIf( !(SF4->F4_CSTPIS $ '07/08/09') , nAliqEst , 0 )

RestArea(_aArea)

Return(nAliqEst)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �StarVar   �Autor  �                    � Data �  13/10/03   ���
�������������������������������������������������������������������������͹��
���Objetivo  | Retornar o clone do Acols/aHeader antes de entrar nesta    ���
���          | operacao.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Multitek                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function StarVar()

aHeader := Aclone(aHeadAux)
aRotina := aClone(aBackRot)

If "MATA415" $ Upper(Funname())
	aCols         := {}
	TMP1->(DbGoto(nNAux))
Else
	aCols         := aClone(aColsAux)
	n             := nNAux
Endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �DxAcresLin� Autor �Silvio Cazela          � Data � 24.11.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina Para Pular Para Linha Abaixo Quando Digitado        ���
���          � Quantidado na GetDados do Pedido de Venda.                 ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� Distribution                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Function U_DxAcresLin(cCampo)

//��������������������������������������������������Ŀ
//�Utilizado como ultima validacao do campo, passando�
//�como parametro o campo em que a mesma esta sendo  �
//�utilizada.                                        �
//����������������������������������������������������


Local cAlias := Alias()
Local nReg   := Recno()
Local lRet   := .T.
Local cVariavel := "M->"+cCampo
Local cConteudo := &cVariavel
Private nPosQuant, nPosProd

nPosCpo := Ascan(aHeader,{|x| Upper(AllTrim(x[2])) == cCampo})

oGet:oBrowse:bEditcol := { || Iif(aCols[n][Ascan(aHeader,{|x| Upper(AllTrim(x[2])) == cCampo})]>0 .And. oGet:LinhaOk(),(oGet:oBrowse:GoDown(),oGet:oBrowse:nColPos := 1) ,Nil)}
oGet:oBrowse:Refresh()

dbSelectarea(cAlias)
dbGoto(nReg)

Return(.T.)
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VALVEND   |Autor  �                       � Data � 18.03.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do Vendedor                                      ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� Distribution                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALVEND(cTipo,Codigo)
Local lRet := .T.
Local _agetArea := GetArea()

IF Upper(Funname()) $ "#TESTE410|#MFATC04"
	RETURN .T.
Endif

DbSelectArea("SA3")
DbSetOrder(1)
If Dbseek(xFilial("SA3")+Codigo)
	
	If cTipo = "I"
		if  SA3->A3_TIPO <> "I"
			Aviso("ATENCAO", "Vendedor Invalido... Vendedor Externo",{"&Ok"})
			lRet := .F.
		Endif
	Else
		if  SA3->A3_TIPO <> "E"
			Aviso("ATENCAO", "Vendedor Invalido... Vendedor Interno",{"&Ok"})
			lRet := .F.
		Endif
	Endif
	
	If  SA3->A3_MSBLQL  = "1"
		Aviso("ATENCAO", "Vendedor Bloqueado... ",{"&Ok"})
		lRet := .F.
	Endif
	
Else
	
	Aviso("ATENCAO", "Vendedor nao Cadastrado",{"&Ok"})
	lRet := .F.
	
Endif



//IF lRet
//  If  SA1->A1_MSBLQL  = "1"
//		Aviso("ATENCAO", "Cliente Bloqueado... ",{"&Ok"})
//		lRet := .F.
// Endif
//Endif


RestArea(_agetArea)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | ConsPer  � Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Refaz o Perido de Consulta das Ultimas Compras             ���
���          � Com base nos seguintes parametros                          ���
���          � Poderia ser utilizado o Pergunte mas como estavamos em via ���
���          � de definicoes de projeto preferi utilizar uma tela normal  ���
���          � pois nao sabia o que o cliente poderia desejar             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Static Function ConsPer(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg)
Local aArea		:= GetArea()
Local bKey4     := SetKey(VK_F4)
Local bKey12    := SetKey(VK_F12)

Local nX 		:= 0
Local lContinua	:= .T.
Local oSay
Local aPosObj   := {}
Local aSize     := {}
Local aPosGet   := {}
Local nGetLin   := 0
Local nOpca     := 0

Local oDlgF12

Private aTela[0][0]
Private aGets[0]


//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
aSize := MsAdvSize()                           //315 - Tam. Janela Vertical

aPosGet := MsObjGetPos(aSize[3]-aSize[1],50,;
{{05,15},{05,15},{05,15},{10,15}} )

SetKey(VK_F4,nil)
SetKey(VK_F12,nil)
DEFINE MSDIALOG oDlgF12 TITLE "Parametros - Periodo das Ultimas Vendas" From aSize[7],0 to aSize[6]-200,aSize[5]-450 of oMainWnd PIXEL

@ 10,aPosGet[1,1] SAY oSay PROMPT "Data Incial" 	  SIZE 060,009 PIXEL OF oDlgF12
@ 10,aPosGet[1,2] MSGET _dDataIni  Of oDlgF12 PIXEL

@ 25,aPosGet[2,1] SAY oSay PROMPT "Data Final "  	  SIZE 060,009 PIXEL OF oDlgF12
@ 25,aPosGet[2,2] MSGET _dDataFinal Of oDlgF12 PIXEL Valid ValData()

@ 40,aPosGet[3,1] SAY oSay PROMPT "Qtd Max.de Reg." SIZE 060,009 PIXEL OF oDlgF12
@ 40,aPosGet[3,2] MSGET nMaxReg  Picture "@E 99"  Of oDlgF12 PIXEL

DEFINE SBUTTON FROM 65,aPosGet[4,1]  TYPE 1 ACTION (nOpca:=1,oDlgF12:End()) ENABLE OF oDlgF12
DEFINE SBUTTON FROM 65,aPosGet[4,2]  TYPE 2 ACTION (nOpca:=0,oDlgF12:End()) ENABLE OF oDlgF12

ACTIVATE MSDIALOG oDlgF12 Centered
//ON INIT Ma415Bar(oDlgF12,{||nOpcA:=1,IIf(oGetDb:TudoOk().And.Obrigatorio(aGets,aTela).And.A415VldTOk(),oDlgF12:End(),nOpcA:=0)},{||oDlgF12:End()}, nOpcx)
SetKey(VK_F4,bKey4)
SetKey(VK_F12,bKey12)


If nOpca = 1
ConsPro(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg)
Endif

RestArea(aArea)
Return
*/


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ConsPer  � Autor �                       � Data � 18.01.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Define novo periodo de consulta de ultimas Vendas.         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ConsPer(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra,aPosObj,oDlg,oFntFecha2)

Local aArea		:= GetArea()
Local bKey4     := SetKey(VK_F4)
Local bKey9     := SetKey(VK_F9)
Local bKey11    := SetKey(VK_F11)
Local bKey12    := SetKey(VK_F12)

Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Local aStruSX1 :={}

Private cCadastro := "Periodo das Ultimas Vendas"

//���������������������������������������������������������������Ŀ
//� mv_par01 Dta Inicial de   ?                                   �
//� mv_par02 Dta Final de  ?                                      �
//� mv_par02 Qtd Max.de Reg. ?                                    �
//�����������������������������������������������������������������
AjustaSX1()

If  Pergunte("PARSIM"+SPACE(4),.T.)
	_dDataIni  :=MV_PAR01
	_dDataFinal:=MV_PAR02
	nMaxReg    :=MV_PAR03
	nFiltra    :=MV_PAR04

	
	Processa({|lEnd| ConsVend(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra) },"Levantando Ultimas Vendas",,.T.)

	Processa({|lEnd| ConsORCA(xPRODUTO,_dDataIni,_dDataFinal,nMaxReg,nFiltra) },"Levantando Ultimos Orcamentos",,.T.)


	//������������������������������������������������������������������������Ŀ
	//�Monta o ListBox com base no Primeiro item                               �
	//��������������������������������������������������������������������������
	n:=1                          
	aListVend:=GeraVend(aCols[1][xPRODUTO])
	aListOrca:=GeraOrca(aCols[1][xPRODUTO])
	lReplace := .T.            // Sera Forcada a Atualizacao da Tela
	
    U_AtuDisp(aListVend,oListVend,oGet,oTimer,aPosObj,oDlg,oFntFecha2,aListORCA,oListORCA)
	
EndIf

SetKey(VK_F4 ,bKey4)
SetKey(VK_F9 ,bKey9)
SetKey(VK_F11,bKey11)
SetKey(VK_F12,bKey12)

RestArea(aArea)

Return(.T.)




// Valida Data Final
Static Function ValData()
IF _dDataFinal < _dDataIni
	Aviso("ATENCAO", "Data Invalida"+CHR(13)+CHR(13)+"Data final maior que data Inicial.",{"&Ok"})
	Return .F.
Endif
Return .T.




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1    �Autor �  Alice Y Yamamoto    �Data� 22.11.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local cAlias:=Alias(), aPerg := {}
Local cPerg := "PARSIM"+SPACE(4), nI, nPerg

aadd(aPerg,{"01","Dta Inicial de ?","Dta Inicial de ? ","Dta Inicial de ? "   ,"mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"02","Dta Final de ? ","Dta Final de ? ","Dta Final de ? "        ,"mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"03","Qtd Max.de Reg. ? ","Qtd Max.de Reg. ? ","Qtd Max.de Reg. ?","mv_ch3","N",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aadd(aPerg,{"04","Filtra Cliente  ?","Filtra Cliente  ?","Filtra Cliente  ?"  ,"mv_ch4","N",01,0,0,"C","","MV_PAR04","Sim","","","","Nao","","","","","","","","","","","","","","","","","","","","",""})

nPerg := Len(aPerg)

dbSelectArea("SX1")
dbSetOrder(1)
For nI := 1 To nPerg
	If ! dbSeek(cPerg+aPerg[nI,1])
		RecLock("SX1",.T.)
		Replace X1_GRUPO	With cPerg
		Replace X1_ORDEM	With aPerg[nI,01]
		Replace X1_PERGUNT	With aPerg[nI,02]
		Replace X1_PERSPA	With aPerg[nI,03]
		Replace X1_PERENG	With aPerg[nI,04]
		Replace X1_VARIAVL	With aPerg[nI,05]
		Replace X1_TIPO		With aPerg[nI,06]
		Replace X1_TAMANHO	With aPerg[nI,07]
		Replace X1_DECIMAL  With aPerg[nI,08]
		Replace X1_PRESEL   With aPerg[nI,09]
		Replace X1_GSC		With aPerg[nI,10]
		Replace X1_VALID    With aPerg[nI,11]
		Replace X1_VAR01	With aPerg[nI,12]
		/*
		Replace X1_DEF01	With aPerg[nI,10]
		Replace X1_DEFSPA1	With aPerg[nI,11]
		Replace X1_DEFENG1	With aPerg[nI,12]
		Replace X1_CNT01	With aPerg[nI,13]
		Replace X1_DEF02	With aPerg[nI,14]
		Replace X1_DEFSPA2	With aPerg[nI,15]
		Replace X1_DEFENG2	With aPerg[nI,16]
		*/
		MsUnlock()
	EndIf
Next


dbSelectArea(cAlias)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | LibManual� Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a Liberacao Manual por Rentabilidade Automaticamente���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LibManual()


// Verifica se Usuario tem permissao para efetuar Liberacao Manual por Rentabilidade.
if !lUsuLib      // Usuario Liberado para efetuar Liberacao Manual.
	Aviso("ATENCAO", "Usuario nao possui permissao para efetuar Liberacao Manual de Rentabilidade",{"&Ok"})
	return .t.
Endif

// Verifica se o Item esta Bloqueado por Rentabilidade
if  oGet:aCols[oGet:oBrowse:nAt][xMargA] = "L"   // Liberado Automaticamente
	Aviso("ATENCAO", "O item em que se encontra posicinado na tela nao esta  BLOQUEADO por Rentabilidade",{"&Ok"})
	return .t.
Endif

oGet:aCols[oGet:oBrowse:nAt][xMargA] :=  "M"    // Liberado Manualmente 

Return .t.



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | GetIndCon� Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � O disparo para recalculo do precos ocorre quando o usuario ���
���          � troca cliente/industria ou comercio/Vendedor Interno.      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GetIndCon(lCond)
Local _aGetArea    := GetArea()
Local _cGetCond    := "" //IIF( Upper(Funname()) $ "MATA415", M->CJ_CONDPAG ,M->CCONDPAG)
Local _nGetFrete   := IIF( "MATA415" $ Upper(Funname()) , M->CJ_X_FRETE , nFrete)
Local _cVendedor   := IIF( "MATA415" $ Upper(Funname()) , M->CJ_X_VEND1 , cVEND1 )
Local _cNumero     := IIF( "MATA415" $ Upper(Funname()) , M->CJ_NUM     , cNum )

Local _cCliente    := IIF( "MATA415" $ Upper(Funname()) , M->CJ_CLIENTE ,cCliente)
Local _cLoja       := IIF( "MATA415" $ Upper(Funname()) , M->CJ_LOJA    ,cLoja)

Local _cClient     := IIF( "MATA415" $ Upper(Funname()) , M->CJ_CLIENT  , cCliente   )
Local _cLojaEnt    := IIF( "MATA415" $ Upper(Funname()) , M->CJ_LOJAENT , cLoja      )

Local nQTDVEN      := 0
Local nPRCVEN      := 0
Local nCtStd       := 0
Local nPRUNIT      := 0
Local nVALOR       := 0

Local nMARGE       := 0
Local nMARGV       := 0
Local nMARGA       := 0
Local nY           := 0
Local nPRODUTO     := 0

Local nPis         := 0
Local nCofins      := 0
Local nCPMF        := 0
Local nICM         := 0
Local nIPI         := 0

Local _n_Mv_TxPis  := GetMv("MV_TXPIS")     //  Pis            (Padrao)
Local _n_Mv_Cofins1:= GeTMv("MV_TXCOFIN")   //  Confins        (Padrao)
Local _n_Mv_Cpmf   := GeTMV("MV_CPMF")      //  Cpmf           (Especifico)
//  sb1                 //  IPI

Private _cIndComer   := IIF( "MATA415" $ Upper(Funname()) , M->CJ_X_ST_CI ,IIF( UPPER(CJ_X_ST_CI) $ "INDUSTRIA","I",IIF( UPPER(CJ_X_ST_CI) $ "CONSUMO","C","R" )))

DEFAULT lCond      := .T.

DbSelectArea("SA1")
DbSetorder(1)
If !DbSeek(xFilial("SA1")+_cCliente+_cLoja)
	Return(.T.)
Endif


IF "MATA415" $ Upper(Funname())
	_cGetCond      := IIF(EmptY(SA1->A1_COND),"001",SA1->A1_COND)
	M->CJ_CONDPAG := _cGetCond
	M->CJ_X_CGC   := SA1->A1_CGC
Else // Neste caso a condicao de pagamento e alteravel independente do cliente.
	// Este e o caso do contrato.
	_cGetCond      := M->cCondPag
Endif

IF "MATA415" $ Upper(Funname())
	
	
	// Indentifico se e uma alteracao e depois analiso se ha necessidade
	// de disparar a rotina.
	DbSelectArea("SCJ")
	DbSetOrder(1)
	if Dbseek(xFilial("SCJ")+_cNumero+_cCliente+_cLoja)
		If _cCliente+_cLoja+_cIndComer+_cVendedor = SCJ->(CJ_CLIENTE+CJ_LOJA+CJ_X_ST_CI+CJ_X_VEND1)
			Return .t.
		Endif
	Endif
	
	DbSelectArea("TMP1")
	DbGotop()
	
	While !TMP1->(eof())
		
		if !EmptY(TMP1->CK_PRODUTO)  .and. !TMP1->CK_FLAG
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			If Dbseek(xFilial("SB1")+TMP1->CK_PRODUTO)
				
				//
				// Define Preco de Venda
				//
				//�������������������������������������������������������������������������T�
				//� Parametros                                                             �
				//� 1. < cGetCond > - Condicoes de Pagamento                               �
				//� 2 <._cProd    > - Produto Desejado                                     �
				//� 3.< NIL       > - I(Industria)/C(Comercio)                             �
				//�                   Caso Nil a propria rotina define                     �
				//�                   atraves da Origem.                                   �
				//�  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  �
				//�                   .F. Outras origens.                                  �
				//�                   Motivo controle do custo que vem do acols.           �
				//��������������������������������������������������������������������������
				aPrVenda  := U_PrVenda(_cGetCond,SB1->B1_COD,_cIndComer,.F.,_nGetFrete)
				If Len(aPrVenda)>5
					// Aa alterar ou adicionar novos campos deve ser revisto o Startar dos campos na
					// mfatc02.prw e o filtro no SXB da consulta F4F
					DbSelectArea("TMP1")      // Alterado - Almeida 21/05/2014
					Reclock("TMP1",.F.)
					TMP1->CK_X_CTSTD := SB1->B1_X_CTSTD
					TMP1->CK_PRCVEN  := aPrVenda[02,03]    // Preco de Venda
					TMP1->CK_X_PRUN  := aPrVenda[02,03]    // Preco de Tabela
					TMP1->CK_VALOR   := TMP1->CK_X_PRUN * TMP1->CK_QTDVEN
					TMP1->CK_X_MARGE := aPrVenda[06,03]    //  % Rentabilidade
					TMP1->CK_X_MARGV := aPrVenda[03,03]    //  $  Rentabilidade
					TMP1->CK_X_MARGA := aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
					TMP1->CK_TES     := U_TESDEF(_cIndComer) //IIF(SA1->A1_EST="AM","   ",IIf(_cIndComer="C","536","537"))
					TMP1->CK_CLASFIS := " "+GetAdvFval("SF4","F4_SITTRIB",xFilial("SF4") +TMP1->CK_TES, 1)
					TMP1->CK_LOCAL   := IIf(alltrim(GetMv("MV_MODFIL")) = "03","  ","01") //IIF(SM0->M0_CODFIL="01","01","  ") // Opcao 01 - HandHeld On-Line
					// Opcao 02 - HandHeld nao utilizanda HandHeld.
					// Opcao 03 - HandHeld Off-Line
					TMP1->CK_X_PIS   := _n_Mv_TxPis
					TMP1->CK_X_COFIN := _n_Mv_Cofins1
					TMP1->CK_X_CPMF  := _n_Mv_Cpmf
					TMP1->CK_X_ICM   := U_IcmsAliq(_cClient,_cLojaEnt,TMP1->CK_PRODUTO,TMP1->CK_TES)
					TMP1->CK_X_IPI   := SB1->B1_IPI
					TMP1->(MsUnlock())
				Endif
			Endif
			
		Endif
		
		DbSelectArea("TMP1")
		TMP1->(Dbskip())
		
	Enddo
	
	// Atualiza a media no Cabecalho
	U_MediaRent(NIL,NIL,"O")
	
	DbSelectArea("TMP1")
	DbGotop()
	
Else
	
	If Len(acols) = 0
		Return .t.
	Endif
	
	// Indentifico se e uma alteracao e depois analiso se ha necessidade
	// de disparar a rotina.
	DbSelectArea("SZ6")
	DbSetOrder(1)
	if Dbseek(xFilial("SZ6")+_cNumero+_cCliente+_cLoja)
		If _cCliente+_cLoja+_cIndComer+_cVendedor = SZ6->(Z6_CLIENTE+Z6_LOJA+Z6_X_ST_CI+Z6_VEND1)
			Return .t.
		Endif
	Endif
	
	nPRODUTO  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRODUTO"})
	nQTDVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
	nPRCVEN   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRCVEN"}) //"Z6_PRCVEN"
	nCtStd    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CTSTD"})
	nPRUNIT   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_PRUNIT"})
	nVALOR    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_VALOR"})
	nMARGE    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	nMARGV    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	nMARGA    := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	
	nPis      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_PIS"})
	nCofins   := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_COFIN"})
	nCpmf     := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_CPMF"})
	nIcm      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_ICM"})
	nIPI      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_IPI"})
	nTes      := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_TES"})
	
	
	For nY := 1 to len(Acols)
		
		If !aCols[nY][Len(aHeader)+1] .and. !Empty(aCols[nY][nPRODUTO])
			
			DbSelectArea("SB1")
			DbSetOrder(1)
			If Dbseek(xFilial("SB1")+aCols[nY][nPRODUTO])
				
				//
				// Define Preco de Venda
				//
				//�������������������������������������������������������������������������T�
				//� Parametros                                                             �
				//� 1. < cGetCond > - Condicoes de Pagamento                               �
				//� 2 <._cProd    > - Produto Desejado                                     �
				//� 3.< NIL       > - I(Industria)/C(Comercio)                             �
				//�                   Caso Nil a propria rotina define                     �
				//�                   atraves da Origem.                                   �
				//�  4.<.T.       > - .T.Origem no Simulador(MFATC01.PRW)                  �
				//�                   .F. Outras origens.                                  �
				//�                   Motivo controle do custo que vem do acols.           �
				//��������������������������������������������������������������������������

				aPrVenda  := U_PrVenda(_cGetCond,SB1->B1_COD,,.F.,_nGetFrete)
				If Len(aPrVenda)>5
					aCols[nY][nPRCVEN]    := aPrVenda[02,03]   // Preco de Venda
					aCols[nY][nPRUNIT]    := aPrVenda[02,03]   // Preco de Tabela
					aCols[nY][nMARGE]     := aPrVenda[06,03]    //  % Rentabilidade
					aCols[nY][nMARGV]     := aPrVenda[03,03]    //  $  Rentabilidade
					aCols[nY][nMARGA]     := aPrVenda[05,03]    // AvalMarg()  - Avaliacao da Margem
                Endif
				aCols[nY][nCTSTD]     := SB1->B1_X_CTSTD    // Preco Stander
				aCols[nY][nVALOR]     := aCols[nY][nPRUNIT] * aCols[nY][nQTDVEN]
				aCols[nY][nPis]       := _n_Mv_TxPis
				aCols[nY][nCofins]    := _n_Mv_Cofins1
				aCols[nY][nCpmf]      := _n_Mv_Cpmf
				aCols[nY][nIcm]       := U_IcmsAliq(_cClient,_cLojaEnt,aCols[nY][nPRODUTO],aCols[nY][nTes])
				aCols[nY][nIPI]       := SB1->B1_IPI
				
			Endif
			
		Endif
		
	Next nY
	
	// Atualiza a media no Cabecalho
	U_MediaRent(NIL,NIL,"C")
	
Endif


ogetdad:obrowse:Refresh()  // Atualiza a GetDados do Orcamento ou Contrato

RestArea(_aGetArea)


Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    | MediaRent� Autor �                       � Data � 13.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Determina a Media da Rentabilidade de todos os Items       ���
���          � Esta media no final do processo e gravado no SCJ           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � O retorno se da atraves das variaveis privantes no sistema ���
���          � _nGetRent                                                  ���
���          � _nGetRenVr                                                 ���
���          � _cStatus                                                   ���
���cOrigem   � "S"-Simulador/"C"-Contrato/"O"-Orcamento                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Rotina Utilizada nos Seguintes Lugares:
+ Simulador;
+ Consulta Produtos;
+ Geracao DTC de Contrato;
+ Manutencao Contrato de Venda;
+ Geracao Pedido do Contrato;
+ Reajuste de Preco dos Contratos.

Calculo da Media e Efetuado da Seguinte Forma:

R$ Total Media Rent = Somatoria de Todos os itens (Quantidade x R$ Rent)
%  Total Media Rent = Somatoria de Todos os itens (Quantidae  x %  Rent) / Somatoria das quantidades

*/
User Function MediaRent(lValid,nLin,cOrigem)
Local _nMarge   := 0
Local _nMargV   := 0
Local _cMargA   := "L"
Local _nElem    := 0
Local nY        := 0
Local _xMARGE   := 0
Local _xMARGV   := 0
Local _xMARGA   := 0
Local _aArea    := GetArea()
Local _xQUANT   := 0
Local _nQUANT   := 0
Local _nSomaQuat :=0

DEFAULT  cOrigem := "S"
DEFAULT  lValid  := .F.

If  cOrigem = "S"
	// Variaveis Privante
	_nGetRent  := 0
	_nGetRenVr := 0
	_cStatus   := "L"
	
	_xMARGE  := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_MARGE"})
	_xMARGV  := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_MARGV"})
	_xMARGA  := aScan(aHeader,{|x| AllTrim(x[2])=="CK_X_MARGA"})
	_xQUANT  := aScan(aHeader,{|x| AllTrim(x[2])=="ALT_QTDVEN"})
	
	For nY := 1 to len(Acols)
		if !aCols[nY][Len(aHeader)+1]
			_nElem    :=_nElem + 1
			_nMargE   :=IIF(lValid .AND. nLin = nY .AND. TYPE("M->ALT_MARGE")   <>"U",&("M->ALT_MARGE")   ,aCols[nY][_xMargE] )
			_nMargV   :=IIF(lValid .AND. nLin = nY .AND. TYPE("M->ALT_MARGV")   <>"U",&("M->ALT_MARGV")   ,aCols[nY][_xMargV] )
			_cMargA   :=IIF(lValid .AND. nLin = nY .AND. TYPE("M->CK_X_MARGA")  <>"U",&("M->CK_X_MARGA")  ,aCols[nY][_xMargA] )
			_nQuant   :=IIF(lValid .AND. nLin = nY .AND. TYPE("M->ALT_QTDVEN")  <>"U",&("M->ALT_QTDVEN")   ,aCols[nY][_xQuant] )
			_nGetRent := _nGetRent  + ( _nMargE * _nQuant)   // %
			_nGetRenVr:= _nGetRenVr + ( _nMargV * _nQuant)   // Valor
			_nSomaQuat:= _nSomaQuat + _nQuant
			If _cMargA = "B"
				_cStatus   := "B"
			Endif
		Endif
	Next
	_nGetRenVr  := _nGetRenVr                                // %
	_nGetRent   := _nGetRent  / _nSomaQuat                   // Valor
Endif


If  cOrigem = "C"
	// Variaveis Privante
	nPrentab  := 0// % Medio da Margem de Rentabilidade
	nRrentab  := 0// $ Medio da Margem de Rentabilidade
	cSrentab  := "Liberado"
	
	_xMARGE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	_xMARGV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	_xMARGA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	_xQUANT  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
	
	
	For nY := 1 to len(Acols)
		if !aCols[nY][Len(aHeader)+1]
			_nElem    :=_nElem + 1
			_nMargE   := aCols[nY][_xMargE]
			_nMargV   := aCols[nY][_xMargV]
			_cMargA   := aCols[nY][_xMargA]
			_nQuant   := aCols[nY][_xQuant]
			
			nRrentab := nRrentab +  (_nMargE * _nQuant)   // %
			nPrentab := nPrentab +  (_nMargV * _nQuant)   // Valor
			_nSomaQuat:= _nSomaQuat + _nQuant
		Endif
	Next
	nRrentab  := nRrentab /_nSomaQuat                   // %
	nPrentab  := nPrentab                                 // Valor
Endif

If  cOrigem = "CC"
	// Variaveis Privante
	nPrentab  := 0// % Medio da Margem de Rentabilidade
	nRrentab  := 0// $ Medio da Margem de Rentabilidade
	cSrentab   := "Liberado"
	
	_xMARGE  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGE"})
	_xMARGV  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGV"})
	_xMARGA  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_X_MARGA"})
	_xQUANT  := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_QTDVEN"})
	
	For nY := 1 to len(Acols)
		if !aCols[nY][Len(aHeader)+1]
			_nElem    :=_nElem + 1
			_nMargE   := aCols[nY][_xMargE]
			_nMargV   := aCols[nY][_xMargV]
			_cMargA   := aCols[nY][_xMargA]
			_nQuant   := aCols[nY][_xQuant]
			
			nRrentab  := nRrentab + (_nMargE * _nQuant)    // %
			nPrentab  := nPrentab + (_nMargV * _nQuant)    // Valor
			_nSomaQuat:= _nSomaQuat + _nQuant
		Endif
	Next
	nRrentab  := nRrentab  /  _nSomaQuat                   // %
	nPrentab  := nPrentab                                  // Valor
Endif


If  cOrigem = "O"
	// Variaveis Privante
	M->CJ_X_MARGE := 0   // % Medio da Margem de Rentabilidade
	M->CJ_X_MARGV := 0   // $ Medio da Margem de Rentabilidade
	M->CJ_X_MARGA := "Liberado"
	
	DbSelectArea("TMP1")
	DbGotop()
	While !TMP1->(EOF())
		if !TMP1->CK_FLAG
			_nElem    :=_nElem + 1
			_nMARGE  := TMP1->CK_X_MARGE
			_nMARGV  := TMP1->CK_X_MARGV
			_nMARGA  := TMP1->CK_X_MARGA
			_nQUANT  := TMP1->CK_QTDVEN
			
			M->CJ_X_MARGE := M->CJ_X_MARGE + ( _nMargE  * _nQUANT )
			M->CJ_X_MARGV := M->CJ_X_MARGV + ( _nMargV  * _nQUANT )
			_nSomaQuat:= _nSomaQuat + _nQuant
			
			If  _nMARGA = "B"
				M->CJ_X_MARGA := "B"
			Endif
			
		Endif
		TMP1->(DBSKIP())
	Enddo
	
	M->CJ_X_MARGE := M->CJ_X_MARGE / _nSomaQuat
	
Endif

RestArea(_aArea)

Return




/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �ValLocal  �Autor  �                       � Data �06.11.03   ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Valida a existencia do Almoxarifado e retorna a descricao.   ���
���          �Sera chamado pelo X3_VALID no Z6_LOCAL/CK_LOCAL              ���
���Parametros�1 Nome do Armazem                                            ���
���          �2 "O" Simulador ou Orcamento // "C" Contrato                 ���
��������������������������������������������������������������������������Ĵ��
���Uso       �Multitek                                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function ValLocal(cArmazem,Origem)
Local lRet      := .t.
Local _aArea    := GetArea()
Local _nLOCNOME := 0

DbSelectArea("NNR")
DbSetOrder(1)

Do case
	
	Case Origem = "C"
		
		_nLOCNOME := aScan(aHeader,{|x| Trim(x[2])=="Z6_LOCNOME"})
		
		If !DbSeek(xFilial("NNR")+cArmazem)
			lRet := .F.
		Else
			aCols[n][_nLOCNOME]:=NNR->NNR_DESCRI
			lRet := .T.
		Endif
		
	Case Origem = "O"
		
		If !DbSeek(xFilial("SZB")+cArmazem)
			lRet := .F.
		Else
			
			If Type("aCols") != "U"
				_nLOCNOME := aScan(aHeader,{|x| Trim(x[2])=="CK_LOCNOME"})
				aCols[n][_nLOCNOME]:=NNR->NNR_DESCRI
			Else
			    DbSelectArea("TMP1")  // Alterado - Almeida 21/05/2014
				Reclock("TMP1",.F.)
				CK_LOCNOME := NNR->NNR_DESCRI //SZB->ZB_LOCNOME
				MsUnlock()
			Endif
			lRet:=.T.
			
		Endif
		
EndCase

If !lRet
	Aviso('Atencao ','Armazem nao Disponivel',{'Ok'})
Endif

RestArea(_aArea)

Return(lRet)


//
// Valida codigo do Cliente
//
User Function ValClie(_nLin,_lValid)
Local _aArea	:=GetArea()
Local _lRet     := .T.    
Local _nPosCli	:= aScan(aHeader,{|x| AllTrim(x[2])=="ALT_PROCL"}) 
Local _cCodCli  := ""
Default _nLin	:= n
Default _lValid	:= .F.

If _nPosCli>0
	If(_lValid .And. TYPE("M->ALT_PROCL")  <>"U")
		_cCodCli:=&("M->ALT_PROCL")  
	Else
		_cCodCli:=aCols[oGet:oBrowse:nAt][_nPosCli]
	Endif

	If Empty(_cCodCli) 
		Aviso("ATENCAO", "Campo Obrigatorio, cliente sem codigo tecle N",{"&Ok"})
		_lRet := .F.
	ElseIf UPPER(ALLTRIM(_cCodCli)) == "N"

		DBSelectArea("SA1")
		SA1->(DbSetOrder(1))	   
		if SA1->(DbSeek(xFilial("SA1")+AvKey(M->CJ_CLIENTE,"A1_COD")+AvKey(M->CJ_LOJA,"A1_LOJA")))
	       if   alltrim(SA1->A1_X_GRPCO) $ "000019/000021/000029/000002" 
			    Aviso( "Atencao!", "Obrigatorio o preenchimento do codigo do cliente para o xml.",{"&Ok"})
			    _lRet:=.F.
            Endif            
        Endif
        
		aCols[oGet:oBrowse:nAt][xProdCli]:="NAO DETERMINADO"//U_CodCliente(_cCliente,_cLoja,aCols[nLin][xProduto],CriaVar("Z6_PRODCLI"),.F.)
		If _lValid .AND. TYPE("M->ALT_PROCL")  <>"U"           
			M->ALT_PROCL := "NAO DETERMINADO"
		Endif

	Else
		DBSelectArea("SA1")
		SA1->(DbSetOrder(1))	   
		
		If SA1->(DbSeek(xFilial("SA1")+AvKey(M->CJ_CLIENTE,"A1_COD")+AvKey(M->CJ_LOJA,"A1_LOJA")))
                         
			If  Alltrim(SA1->A1_X_GETIQ) == "2" // Valiada Alcoa e Mrn
				If At("-",_cCodCli) == 0
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
					_lRet:=.F.
				ElseIf Len(Alltrim(Substr(_cCodCli,At("-",_cCodCli)+1,4))) < 4
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
					_lRet:=.F.
				Endif
			Endif
		    /*
	       If  alltrim(SA1->A1_X_GRPCO) == "000021"  // Mrn 
	           if  Empty(alltrim(substr(_cCodCli,at("-",_cCodCli)+1,10)))  //If  At("-",_cCodCli) == 0
			  	   Aviso( "Atencao!", "O codigo do cliente nao e valido para o Grupo 000021 deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
				   _lRet:=.F.
			       //ElseIf Len(Alltrim(Substr(_cCodCli,At("-",_cCodCli)+1,4))) < 4
				   //	Aviso( "Atencao!", "O codigo do cliente nao e valido para o Grupo 000021 deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
			 	   //	_lRet:=.F.
				Endif
		   ElseIf alltrim(SA1->A1_X_GRPCO) == "000029" .or. alltrim(SA1->A1_X_GRPCO) == "000002"  // Alcoa e Vale
	           if  Empty(alltrim(substr(_cCodCli,at("-",_cCodCli)+1,10)))  //If  At("-",_cCodCli) == 0
			  	   Aviso( "Atencao!", "O codigo do cliente nao e valido para o Grupo 000029 e 000002 deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
				   _lRet:=.F.
			       //ElseIf Len(Alltrim(Substr(_cCodCli,At("-",_cCodCli)+1,4))) < 4
				   //	Aviso( "Atencao!", "O codigo do cliente nao e valido para o Grupo 000021 deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
			 	   //	_lRet:=.F.
				Endif
		   Endif
            */
		   
		    /*
			If  Alltrim(SA1->A1_X_GETIQ) == "2" // Valiada Alcoa e Mrn
				If At("-",_cCodCli) == 0
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
					_lRet:=.F.
				ElseIf Len(Alltrim(Substr(_cCodCli,At("-",_cCodCli)+1,4))) < 4
					Aviso( "Atencao!", "O codigo informado para Alcoa nao e valido o mesmo deve ser o 99999999-9999 (apos o Hifem informar 04 Digitos).",{"&Ok"})
					_lRet:=.F.
				Endif
			Endif
            */
		Endif
	Endif
Endif
RestArea(_aArea)

oGet:oBrowse:SETFOCUS()

Return(_lRet)



//
// Valida data de Entreaga
//
User Function ValEntre(nLin,lValid)
Local dDataEntre   := IIF(lValid .AND. TYPE("M->CK_X_ENTRE")  <>"U",&("M->CK_X_ENTRE")   ,aCols[nLin][xDTENT] )
Local lRet     := .T.

DEFAULT lVALID := .F.

If Empty(dDataEntre)
	Aviso("ATENCAO", "Campo data de entrega deve ser preenchido.",{"&Ok"})
	lRet := .F.
Endif

If dDataEntre < dDataBase
	Aviso("ATENCAO", "Data de entraga menor que a data Atual.",{"&Ok"})
	lRet := .F.
Endif

Return(lRet)



//
//  Valida todo o Orcamento antes de sair
//
User Function ValAllSim()
Local lRet := .T.

/*
O tratamento do codigo do cliente em branco esta sendo tratanto no ponto de entrada
A415TDOK desta forma o usuario pode andar entre as telas do orcamento e simulador
normalmente sendo brecado somente ao tentar sarir do orcamento.

Local lRet := .T.
Local nY   := 0

For nY := 1 to Len(acols)
If !aCols[nY][Len(aHeader)+1]
If EmptY(aCols[nY][xProdCli])
Aviso("ATENCAO","Produto : "+aCols[nY][xProduto]+" esta com o codigo do cliente em branco.",{"&Ok"})
lRet := .F.
Endif
Endif
Next
*/

Return(lRet)




User Function PictCGC()

Local cPictutre := PICPES(SA1->A1_PESSOA)

Return(cPictutre)



User Function TESDEF(_cIndComer)
Local _cFil := SM0->M0_CODIGO+SM0->M0_CODFIL
Local _cTes := "   "

// Precisei compilar antes desta forma comentei o restante.
// quando for retornar delete o trecho abaixo e descomente o restante.
If  _cFil $ "0110|0112"                                    // ==> ALBRAS / ALUMAR 
	
	//     574 - Nao Calcula Icms - Devido serem mineradoras.
	_cTes   := "574"

ElseIf  _cFil $ "0116"                                    // ==>  MRN
	            
	_cTes   := "536"

	If SB1->B1_IPI = 0

       _cTes   := "570"

    Endif
    	
Else
	
	If  SA1->A1_EST="AM"
		
		_cTes   := "   "
		
	Else                          								    // ==> Cliente esta em outro estado
		
		If SB1->B1_IPI <> 0
			
			If _cIndComer="C"     // Consumo
				_cTes    := "536"
			ElseIf _cIndComer="I" // Industria
				_cTes    := "537"
			Else                  // Revenda
				_cTes    := "609"
			Endif
			
		Else
			
			_cTes    := "570"     // Ipi 0 -  Muda a Coluna de Ipi
			
		Endif
		
	Endif
	
Endif


/*
If  _cFil $ "0110|0112|0116"                                    // ==> ALBRAS / ALUMAR / MRN
//     Possuindo beneficio do Icms.
_cTes   := "574"                                            //     574 - Nao Calcula Icms - Devido serem mineradoras.
//

Elseif  _cFil = '0101' .and. SB1->B1_PICMRET <> 0 .and. SA1->A1_EST $ "SP"

If  SB1->B1_ORIGEM $  '0/2'

_cTes := "547"                                          // ==> Produto controla Substituicao Tributaria.

Elseif SB1->B1_ORIGEM = '1' .and. _cIndComer = "R"         //     Legislacao propria nao tributa nem o icms prorio nem
//     o icms substituicao triburaria.
_cTes := "601"											//     547- Uso Revenda/Consumo/Industria / somente produtos nao importados.
//     B1_ORIGEM (0-NANCIONAL/1-ESTRAN(IMPORTACAO DIRETA)/2-ESTRAN(NACIONALIZADO)
Else

If _cIndComer="C"     // Consumo

_cTes    := "536"

ElseIf _cIndComer="I" // Industria

_cTes    := "537"

Else                  // Revenda

_cTes    := "609"

Endif

Endif

ElseIf  _cFil = '0101' .and. SB1->B1_PICMRET <> 0  .and. SA1->A1_EST <> "SP" .and. _cIndComer<>"I"
// ==> Produto controla Substituicao Tributaria.
//     Outros Estados.
//     Nao estao no Protocolo
//     Legislacao propria tributa o icms prorio

if SA1->A1_EST $ "AM"
_cTes  := "   "
ElseIF SA1->A1_EST $ "AL/AP/BA/CE/ES/MT/MG/PA/PR/PI/RJ/RS/SC"
if _cIndComer = "C"      // Consumo
_cTes   := "600"                                    //    600 - Recolhimento da Aliquota Diferencial de Icms do Estado Proprio (Envio pago o Icms)
Else                     // Revenda
_cTes   := "601"                                    //    601 - Margem de valor agregado para fiz de calculo do Icms de Subst.Tributaria.
Endif
Else
If _cIndComer="C"     // Consumo

_cTes    := "536"

ElseIf _cIndComer="I" // Industria

_cTes    := "537"

Else                  // Revenda

_cTes    := "609"

Endif

Endif


Else                                                                            // ==> Produto Nao controla Substituicao Tributaria.

If  SA1->A1_EST="AM"
_cTes    := "   "
Else                          										        // ==> Cliente esta em outro estado
If _cIndComer="C"     // Consumo
_cTes    := "536"
ElseIf _cIndComer="I" // Industria
_cTes    := "537"
Else                  // Revenda
_cTes    := "609"
Endif
Endif

Endif
*/

If Empty(_cTes) // Este posicionamento se faz necessario no Caso da Amazonia "AM" caso contrario o Valor do Icms veem zerado.
	SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+"536"))
Else
	SF4->(DbSelectArea("SF4"),DbSetOrder(1),DbSeek(xFilial("SF4")+_cTes))
Endif

Return(_cTes)

