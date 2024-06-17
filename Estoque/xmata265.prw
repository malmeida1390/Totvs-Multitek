#INCLUDE "MATA265.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA265  � Autor � Rodrigo de a. Sartorio� Data � 05/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Distribuicao de Produtos.                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo Sarto.�22/04/98�XXXXXX�Inclusao de chamada da funcao BloqData()���
���Fernando Joly �05/01/99�18846A�Inclusao do Ponto de Entrada MTA265I    ���
���Rodrigo Sarto.�11/02/99�XXXXXX�Acerto na funcao CriaSDB                ���
��� Rodrigo Sart.�24/02/99�META  �Revisao Rastreabilidade                 ���
���Rodrigo Sarto.�26/07/99�23110A�Acerto travamento do arquivo SDA        ���
���Fernando Joly �17/08/99�21805A�Diferenciar Prods. com Saldo a Distrib. ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA                     MATA265.PRX ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  �Responsavel               �Data          |BOPS              ���
�������������������������������������������������������������������������Ĵ��
���      01  �Marcos V. Ferreira        �29/08/2006    |00000104892       ���
���      02  �Flavio Luiz Vicco         �05/04/2006    |00000095676       ���
���      03  �Marcos V. Ferreira        �08/09/2006    |00000104383       ���
���      04  �                          �              |                  ���
���      05  �                          �              |                  ���
���      06  �Marcos V. Ferreira        �29/08/2006    |00000104892       ���
���      07  �Ricardo Berti             �08/05/2006    |00000098058       ���
���      08  �Ricardo Berti             �08/05/2006    |00000098058       ���
���      09  �Marcos V. Ferreira        �08/09/2006    |00000104383       ���
���      10  �Flavio Luiz Vicco         �05/04/2006    |00000095676       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function XMATA265(xAutoCab,xAutoItens,nOpcAuto)
//��������������������������������������������������������������������������������Ŀ
//�Simula a variavel aAlter onde ira validar somente os campos que forem informados�
//����������������������������������������������������������������������������������
Local aAltAuto := {"DB_ESTORNO"}
Local nX       := 0
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local lRetPE   := .T.
Local cFiltro  := ""  
Local cCampo   := "" 
Local nPos     := 0
Local nPosProd := 0 
Local nPosNseq := 0      
Local nCt      := 0  
Local nI       := 0   
Local nY       := 0
Local aKey1    :={}

PRIVATE	lMovimento:=.F.

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 -Pesquisa e Posiciona em um Banco de Dados              �
//�    2 -Simplesmente Mostra os Campos                          �
//�    3 -Inclui registros no Bancos de Dados                    �
//�    4 -Altera o registro corrente                             �
//�    5 -Estorna registro selecionado gerando uma contra-partida�
//����������������������������������������������������������������
PRIVATE aRotina := MenuDef()
//���������������������������������������������������������������Ŀ
//�Define variaveis para executar em processo de rotina automatica�
//�����������������������������������������������������������������
PRIVATE l265Auto := ( xAutoCab <> NIL  .and. xAutoItens <> NIL )

If ( l265Auto )
	Private aAutoCab:={} , aAutoItens :={},aValidGet:={}
EndIf
nOpcAuto := If (nOpcAuto == nil, 3, nOpcAuto)
//��������������������������������������������������������Ŀ
//�Se o processo for automatico deve montar um novo aRotina�
//����������������������������������������������������������
If ( l265Auto )
	aRotina := {	{STR0001,"AxPesqui"  , 0 , 1},; //"Pesquisar"
					{STR0002,"U_XA265Visual", 0 , 2},; //"Visualizar"
					{STR0003,"U_XA265Inclui", 0 , 3},; //"EnDerecar"
					{STR0004,"U_A265Exclui", 0 , 4} } //"Estornar"
EndIf
//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de atualizacoes                   �
//����������������������������������������������������������������
PRIVATE cCadastro := OemToAnsi(STR0005)	//"Distribui��o de Produtos"

//��������������������������������������������������������������Ŀ
//� Inicializa perguntas deste programa                          �
//� mv_par01 - Bloqueia Data Validade Vencida   1 - Sim 2 - Nao  �
//� mv_par02 - Sugere Localizacoes              1 - Sim 2 - Nao  �
//����������������������������������������������������������������
Pergunte("MTA265",.F.)

If !l265Auto
	//����������������������������������������������������������������Ŀ
	//� Ativa tecla F12 para acionar perguntas                         �
	//������������������������������������������������������������������
	Set Key VK_F12 TO MTA265PERG()

	If (ExistBlock("M265FIL"))
		ExecBlock("M265FIL",.F.,.F.)
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Ponto de entrada para verificacao de filtros na Mbrowse      �
	//����������������������������������������������������������������
	If  ExistBlock("M265FILB")
		cFiltro := ExecBlock("M265FILB",.F.,.F.)
		If Valtype(cFiltro) <> "C"
			cFiltro := ""
		EndIf
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Endereca a funcao de BROWSE                                  �
	//����������������������������������������������������������������
    mBrowse(6,1,22,75,"SDA",,,,"SDA->DA_SALDO>0",,,,,,,,,, IF(!Empty(cFiltro),cFiltro, NIL))

	//����������������������������������������������������������������Ŀ
	//� Desativa tecla que aciona perguntas                            �
	//������������������������������������������������������������������
	Set Key VK_F12 TO
Else
    //Posiciona a Tabela SDA de acordo com o NumSeq recebido //  
    nPosProd := Ascan(xAutoCab,{|x| x[1]== "DA_PRODUTO"}) 
    nPosNseq := Ascan(xAutoCab,{|x| x[1]== "DA_NUMSEQ"})
    nCt := 0
    If nPosProd>0 .And. nPosNseq>0  
	   	dbSelectArea("SDA")
   		DbSetOrder(1)   
	   	MsSeek(xFilial('SDA')+xAutoCab[nPosProd][2])
	   	                                                             
			//-- Avalia se existe registro com o DA_NUMSEQ informado
			cQuery := "SELECT ISNULL(MAX(R_E_C_N_O_),0) RECSDA"
			cQuery += " FROM " +RetSqlName("SDA") +" SDA"
			cQuery += " WHERE (SDA.DA_FILIAL = '"+xFilial("SDA")+"')"
			cQuery += " AND (SDA.DA_PRODUTO = '"+Trim(xAutoCab[nPosProd,2])+"' AND SDA.DA_NUMSEQ = '"+xAutoCab[nPosnSeq,2]+"')"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRYSDA",.T.,.T.)
	   		If (nCt := QRYSDA->RECSDA) > 0
	   			SDA->(dbGoTo(nCt))
	   		EndIf
		   	QRYSDA->(DbCloseArea())
		   		EndIf
	
	If nCt==0    
		lMsErroAuto:=.T.
   		Help(" ",1,"STR0040")
		Return .F.
	EndIf         
	
	//Verifica se os campos adcionais na chave do SDB existem no xAutoItens, se n�o existir, complementa o Array //     
	DbSelectArea("SIX")
	DbSetOrder(1)
	DbSeek("SDB"+"1") 
	aKey1:={}
	If !EOF()
		aKey1:=STRTOKARR(SIX->CHAVE,"+")
	EndIf
	If Len(aKey1)==0  
		lMsErroAuto:=.T.
		Help(" ",1,"STR0041")
		Return NIL
	EndIf    
	                
	For nY=1 to Len(xAutoItens)
		For nI=1 to Len(aKey1)
			nPos:=Ascan(xAutoItens[nY],{|x| Trim(x[1])==Trim(aKey1[nI])}) 
			cCampo:="DA_"+Substr(aKey1[nI],4,Len(aKey1[nI]))
			If nPos==0 .And. SDA->(FieldPos(cCampo)) > 0 
				AAdd(xAutoItens[nY],{Trim(aKey1[nI]),SDA->&cCampo,Nil})
			EndIf
		Next nI
	Next nY

	If nOpcAuto == 3
		aAltAuto := NIL
	EndIf
	
	For nX := 1 To Len(xAutoItens)
		aadd(aAutoItens,SDB->(MSArrayXDB(xAutoItens[nX],.F.,nOpcAuto,,aAltAuto)))
	Next
	dbSelectArea("SDA")
	nPos := Ascan(aRotina,{|x| x[4]== nOpcAuto})
	If ( nPos # 0 )
		bBlock := &( "{ |x,y,z,k| " + aRotina[ nPos,2 ] + "(x,y,z,k) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nOpcAuto)
	EndIf
EndIf

//��������������������������������������������������������������Ŀ
//� Inicializa novamente as perguntas do programa                �
//� Evita o erro que ocorre apos exportar para Excel onde as     �
//� variaveis mv_par01 e mv_par02 sao desconfiguradas            �
//����������������������������������������������������������������
If Type("mv_par01") != "N"
	Pergunte("MTA265",.F.)
EndIf

//����������������������������������������������������������������������Ŀ
//� Verifica se lotes estao com validade vencida                         �
//������������������������������������������������������������������������
If lMovimento .And. mv_par01 == 1 .And. SuperGETMV("MV_LOTVENC") == "N" .And. SuperGETMV("MV_RASTRO") == "S"
	lRetPE := .T.
	If (ExistBlock("MA265BLOT"))
		//���������������������������������������������������������������������������Ŀ
		//� MA265BLOT - Ponto de Entrada para definir se executa a funcao BloqData()  �
		//�����������������������������������������������������������������������������
		lRetPE := ExecBlock( "MA265BLOT", .F., .F., {l265Auto} )
		lRetPE := If(ValType(lRetPE)=="L",lRetPE,.T.)
	EndIf
	If lRetPE
		If l265Auto
			BloqData(.T., .T.)
		Else
			Processa({|lEnd| BloqData(.T.)},OemToAnsi(STR0007),OemToAnsi(STR0008),.F.)	//"Verificando Data de Validade dos Lotes"###"Verificando Lotes com data de validade vencida ..."
		EndIf
	EndIf
EndIf

If (ExistBlock("M265END"))
	ExecBlock("M265END",.F.,.F.)
EndIf

Return NIL

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Visual� Autor � Rodrigo de A. Sartorio� Data � 07/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Visualizacao da distribuicao de produtos                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265Visual(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
uSER Function XA265Visual(cAlias,nReg,nOpc)
Local nOpca      := 0
Local i          := 0
Local nX         := 0
Local cSeek      := ''
Local cLoteSDA   := ''
Local lRastro    := .F.
Local aObjects   := {}
Local aPosObj    := {}
Local aNoFields  := {}
Local aSize      := MsAdvSize()
Local aInfo      := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local bSeekWhile := { || SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ+SDB->DB_DOC+SDB->DB_SERIE+SDB->DB_CLIFOR+SDB->DB_LOJA } //Condicao While para montar o aCols
Local bSeekFor   := { || SDB->DB_TM <= "500" .And. SDB->DB_TIPO == "D" .And. If(lRastro,cLoteSDA==SDB->DB_LOTECTL,.T.) }

PRIVATE aButtons  := {}
PRIVATE nCounter  :=0
PRIVATE nUsado    :=0
PRIVATE aTELA[0][0]
PRIVATE aGETS[0]
PRIVATE oGetd


bCampo    := { |nCPO| Field(nCPO) }

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
If LastRec() == 0
	Return (.T.)
EndIf

If SDA->DA_FILIAL != xFilial("SDA")
	Help(" ",1,"A000FI")
	Return (.T.)
EndIf

//���������������������������������������������������������Ŀ
//� M265BUT - Ponto de Entrada para Adicionar botoes        �
//�����������������������������������������������������������
If ExistBlock("M265BUT")
	aButtonUsr := ExecBlock("M265BUT",.F.,.F.,{nOpc})
	If ValType(aButtonUsr) == "A"
		For nX:=1 to Len(aButtonUsr)
			aAdd(aButtons,aButtonUsr[nX])
		Next
	EndIf
EndIf

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//� p/ preencher variaveis da Enchoice                   �
//��������������������������������������������������������
dbSelectArea(cAlias)
For i := 1 TO FCount()
	M->&(EVAL(bCampo,i)) := FieldGet(i)
Next i

//������������������������������������������������������Ŀ
//� Conta registros de movimentos ja incluidos           �
//��������������������������������������������������������
nCounter	:=	u_xA265UltIt('N')

If nCounter > 0
	//������������������������������������������������������Ŀ
	//� Monta a entrada de dados do arquivo                  �
	//��������������������������������������������������������
	cSeek    := xFilial("SDB")+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
	cLoteSDA := DA_LOTECTL
	lRastro  := Rastro(DA_PRODUTO)

	AAdd(aNoFields,'DB_PRODUTO') ; AAdd(aNoFields,'DB_DOC')     ; AAdd(aNoFields,'DB_SERIE')   ; AAdd(aNoFields,'DB_CLIFOR')
	AAdd(aNoFields,'DB_LOJA')    ; AAdd(aNoFields,'DB_TIPONF')  ; AAdd(aNoFields,'DB_ORIGEM')  ; AAdd(aNoFields,'DB_NUMLOTE')
	AAdd(aNoFields,'DB_LOTECTL') ; AAdd(aNoFields,'DB_TM')      ; AAdd(aNoFields,'DB_LOCAL')

	//��������������������������������������������������������������Ŀ
	//� Monta aHeader e aCols                                        �
	//����������������������������������������������������������������
	PRIVATE aHeader[0],aCols[0], Continua
	//�����������������������������������������������������������������Ŀ
	//� Caso ja tenha dados, preenche linhas com movimentos anteriores  �
	//�������������������������������������������������������������������

	FillGetDados(nOpc,"SDB",1,cSeek,bSeekWhile,bSeekFor,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/)

	nCounter:=Len(aCols)

EndIf

// Array com objetos utilizados
AADD(aObjects,{100,095,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
EnChoice(cAlias,nReg,nOpc,,,,,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
If nCounter > 0
	oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc)
EndIf
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)
RETURN

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Inclui� Autor � Rodrigo de A. Sartorio� Data � 05/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Distribuicao de produtos p/ Localizacao Fisica             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265Inclui(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
uSER Function XA265Inclui(cAlias,nReg,nOpc)
Local nOpca    := 0
Local cSeek    := ''
Local cLoteSDA := ''
Local lRastro  := .F.
Local bCampo

// Verifica a existencia de PE para preencher aCols
Local lMTA265Cols := (ExistBlock( 'A265COL' ) )
Local aBackCols   :={}
Local aNoFields   :={}
Local bSeekWhile  := {|| SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ+SDB->DB_DOC+SDB->DB_SERIE+SDB->DB_CLIFOR+SDB->DB_LOJA } //Condicao While para montar o aCols
Local bSeekFor    := {|| SDB->DB_TM <= "500" .And. SDB->DB_TIPO == "D" .And. If(lRastro,cLoteSDA==SDB->DB_LOTECTL,.T.) }

// Salva o Array aRotina Original
Local aCopia :=ACLONE(aRotina)
Local nI     := 0
Local oDlg, aButtonUsr


Local nITENSDIST:=9999
Local dDataFec  := MVUlmes()

Local aObjects :={},aPosObj  :={}
Local aSize    :=MsAdvSize()
Local aInfo    :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local i        := 0
Local nX       := 0
Local nPosAlias:= 0
Local nPosRec  := 0
Local lEndProt := .F. // Endere�amento via Protheus

// Variavel para ponto de entrada
Local lRetPE := .T.

PRIVATE aButtons  := {}

//��������������������������������������������������������������Ŀ
//� Ativa tecla F4 para comunicacao com Saldos por Endereco      �
//����������������������������������������������������������������
If ( ! l265Auto )
	Set Key VK_F4 TO ShowF4()
EndIf

PRIVATE oGetd
PRIVATE nPosLocali:=0,nPosQuant:=0,nPosData:=0,nPosEstorn:=0,nPosNumSer:=0,nPosItem:=0,nPosQtSegum:=0
PRIVATE nCounter:=0

//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������
PRIVATE nUsado:=0

bCampo    := { |nCPO| Field(nCPO) }

//��������������������������������������������������������������Ŀ
//� Inicializa novamente as perguntas do programa                �
//� Evita o erro que ocorre apos exportar para Excel onde as     �
//� variaveis mv_par01 e mv_par02 sao desconfiguradas            �
//����������������������������������������������������������������
If Type("mv_par01") != "N"
	Pergunte("MTA265",.F.)
EndIf

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
If LastRec() == 0
	Return (.T.)
EndIf

//�������������������������������������������������������������������������Ŀ
//� Ponto de Entrada para permitir ou nao enderecamento via Protheus / ACD	|
//���������������������������������������������������������������������������
If ExistBlock("A265NACD")
	lEndProt := ExecBlock("A265NACD",.F.,.F.)
EndIf

////�������������������������������������������������������������������������������������������Ŀ
//� Trava endere�amento via Protheus quando existe controle de c�digo interno do produto "CB0"|
//���������������������������������������������������������������������������������������������
//If UsaCB0("01") .And. !l265Auto .And. !lEndProt
//   MsgStop(	'O controle de c�digo interno est� habilitado',STR0016)//O controle de c�digo interno est� habilitado, nesse caso, o endere�amento dever� ser feito pelas rotinas do ACD.","Aten��o!"
//   Return 
//EndIf

//��������������������������������������������������������������Ŀ
//� Verificar data do ultimo fechamento em SX6.                  �
//����������������������������������������������������������������
If dDataFec >= dDataBase
	Help ( " ", 1, "FECHTO" )
	Return
EndIf

If SDA->DA_FILIAL != xFilial("SDA")
	Help(" ",1,"A000FI")
	Return (.T.)
EndIf

If SDA->DA_SALDO <= 0
	Help(" ",1,"A265NAOQTD")
	Return (.T.)
EndIf

If !(Reclock("SDA",.F.))
	Return (.T.)
EndIf

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//� p/ preencher variaveis da Enchoice                   �
//��������������������������������������������������������
dbSelectArea(cAlias)
For i := 1 To FCount()
	M->&(EVAL(bCampo,i)) := FieldGet(i)
Next i

cSeek    := xFilial("SDB")+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ+DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA
cLoteSDA := DA_LOTECTL
lRastro  := Rastro(DA_PRODUTO)

//���������������������������������������������������������Ŀ
//� Botao para exportar dados para EXCEL                    �
//�����������������������������������������������������������
If RemoteType() == 1
	aAdd(aButtons,{PmsBExcel()[1],{|| DlgToExcel({{"ENCHOICE",cCadastro,aGets,aTela},{"GETDADOS",OemToAnsi(STR0024),aHeader,aCols} })},PmsBExcel()[2],PmsBExcel()[3]})
EndIf
//���������������������������������������������������������Ŀ
//� Bot�o para gera��o dos n�meros de s�rie automaticamente �
//�����������������������������������������������������������
aAdd(aButtons,{'Gerar n�meros de S�rie',{|| A265GerNS(aHeader,SDA->DA_QTDORI,SDA->DA_SALDO)} , 'Gerar N�meros de S�rie' , 'Gerar N�meros de S�rie' })  //'Gerar n�meros de S�rie'

//���������������������������������������������������������Ŀ
//� M265BUT - Ponto de Entrada para Adicionar botoes        �
//�����������������������������������������������������������
If ExistBlock("M265BUT")
	aButtonUsr := ExecBlock("M265BUT",.F.,.F.,{nOpc})
	If ValType(aButtonUsr) == "A"
		For nX:=1 to Len(aButtonUsr)
			aAdd(aButtons,aButtonUsr[nX])
		Next nX
	EndIf
EndIf

//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������
PRIVATE aTELA[0][0],aGETS[0],Continua

AAdd(aNoFields,'DB_PRODUTO') ; AAdd(aNoFields,'DB_DOC')     ; AAdd(aNoFields,'DB_SERIE')   ; AAdd(aNoFields,'DB_CLIFOR')
AAdd(aNoFields,'DB_LOJA')    ; AAdd(aNoFields,'DB_TIPONF')  ; AAdd(aNoFields,'DB_ORIGEM')  ; AAdd(aNoFields,'DB_NUMLOTE')
AAdd(aNoFields,'DB_LOTECTL') ; AAdd(aNoFields,'DB_TM')      ; AAdd(aNoFields,'DB_LOCAL')   ; AAdd(aNoFields,'DB_DESSER')
AAdd(aNoFields,'DB_TAREFA')  ; AAdd(aNoFields,'DB_DESTAR')  ; AAdd(aNoFields,'DB_ATIVID')  ; AAdd(aNoFields,'DB_DESATI')
AAdd(aNoFields,'DB_RHFUNC')  ; AAdd(aNoFields,'DB_RECHUM')  ; AAdd(aNoFields,'DB_RECFIS')  ; AAdd(aNoFields,'DB_OCORRE')
AAdd(aNoFields,'DB_ANOMAL')  ; AAdd(aNoFields,'DB_ANOMDES') ; AAdd(aNoFields,'DB_ENDDES')  ; AAdd(aNoFields,'DB_CARGA')
AAdd(aNoFields,'DB_ESTFIS')  ; AAdd(aNoFields,'DB_HRINI')   ; AAdd(aNoFields,'DB_HRFIM')   ; AAdd(aNoFields,'DB_UNITIZ')
AAdd(aNoFields,'DB_ATUEST')  ; AAdd(aNoFields,'DB_STATUS')  ; AAdd(aNoFields,'DB_PRIORI')  ; AAdd(aNoFields,'DB_ORDTARE')
AAdd(aNoFields,'DB_ORDATIV') ; AAdd(aNoFields,'DB_IDOPERA') ; AAdd(aNoFields,'DB_SEQCAR')  ; AAdd(aNoFields,'DB_REGWMS')
AAdd(aNoFields,'DB_DESHUM')  ; AAdd(aNoFields,'DB_TEMPO')

//���������������������������������������������������������������������������Ŀ
//� Monta aHeader e aCols                                                     �
//�����������������������������������������������������������������������������
PRIVATE aHeader:={},aCOLS:={}

FillGetDados(4,"SDB",1,cSeek,bSeekWhile,bSeekFor,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/)

//������������������������������������������������������Ŀ
//� Descobre a posicao dos campos obrigatorios no AHeader�
//��������������������������������������������������������
For nx = 1 To Len(aHeader)
	If Trim(aHeader[nx][2]) == "DB_LOCALIZ"
		nPosLocali:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_QUANT"
		nPosQuant:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_DATA"
		nPosData:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_ESTORNO"
		nPosEstorn:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_NUMSERI"
		nPosNumSer:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_ITEM"
		nPosItem:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_QTSEGUM"
		nPosQtSegum:=nx
	ElseIf IsHeadAlias(aHeader[nx][2])
		nPosAlias:=nx
	ElseIf IsHeadRec(aHeader[nx][2])
		nPosRec:=nx
	EndIf
Next nx

nCounter:=Len(aCols)
If nCounter > 1 .Or. (nCounter == 1 .And. (!Empty(aCols[nCounter,nPosQuant]) .And. (!Empty(aCols[nCounter,nPosLocali]) .Or. !Empty(aCols[nCounter,nPosNumSer]))))
	AADD(aCols,Array(Len(aHeader)+1))
	For i:=1 to Len(aHeader)
		If i == nPosAlias
			aCOLS[nCounter+1][i] := "SDB"
		ElseIf i == nPosRec
			aCOLS[nCounter+1][i] := 0
		Else
			cCampo:=Alltrim(aHeader[i,2])
			aCols[nCounter+1][i] := CriaVar(cCampo)
		EndIf
	Next i
	aCOLS[nCounter+1][Len(aHeader)+1] := .F.
	aCOLS[nCounter+1][nPosItem] := StrZero(nCounter+1,Len(aCOLS[nCounter][nPosItem]))
	aCols[nCounter+1][nPosData] := dDataBase
Else
	aCols[nCounter][nPosData] := dDataBase
	aCOLS[nCounter][nPosItem] := StrZero(1,Len(aCOLS[nCounter][nPosItem]))
	nCounter:=0
EndIf

//������������������������������������������������������Ŀ
//� Monta aCols com Localizacoes sugeridas p/ Distribuir �
//��������������������������������������������������������
If mv_par02 == 1
	A265MtCols(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_SALDO,nPosItem,nPosLocali,nPosQuant,nPosQtSegum,ACLONE(aCols[Len(aCols)]),nPosAlias,nPosRec)
EndIf

//��������������������������������������������������������������Ŀ
//�Executa P.E. para preencher ou mudar aCols                    �
//����������������������������������������������������������������
If lMTA265Cols
	aBackCols:=ACLONE(aCols)
	lRetPE:=ExecBlock('A265COL',.F.,.F.)
	If ValType(lRetPe) == "L" .And. !lRetPe
		Return
	EndIf
	If Valtype(aCols) # "A"
		aCols:={}
		aCols:=ACLONE(aBackCols)
	EndIf
EndIf

// Array com objetos utilizados
AADD(aObjects,{100,095,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

If Type("l265Auto") != "L" .Or. !l265Auto
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		//��������������������������������������������������������������Ŀ
		//� Muda o valor do aRotina para so visualizar enchoice.         �
		//����������������������������������������������������������������
		aRotina[3]:={STR0003,"A265Inclui", 0 , 2}
		EnChoice(cAlias,nReg,nOpc,,,,,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
		//��������������������������������������������������������������Ŀ
		//� Restaura o aRotina original p/ a GetDados.                   �
		//����������������������������������������������������������������
		aRotina:=ACLONE(aCopia)
		oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_xA265LinOk","u_xA265TudoOk","+DB_ITEM",.T.,,,,nITENSDIST,"u_xA265VldAll()",,,"u_xA265Del")   
		oGetd:oBrowse:Refresh()
	ACTIVATE MSDIALOG oDlg ON INIT (oGetd:oBrowse:nRowPos:=Len(aCols),oGetd:oBrowse:Refresh(),EnchoiceBar(oDlg,{|| IIF(oGetd:TudoOk(),(nOpca:=1,oDlg:End()),)},{||oDlg:End()},,aButtons))
Else
	//��������������������������������������������������������������Ŀ
	//�Se for rotina automatica atualiza aCols conforme o aAutoItens,�
	//�com opcao de alteracao para pegar dados se ja existir         �
	//����������������������������������������������������������������
	If ( nCounter > 0 )
		MsAuto2aCols(4,,"DB_ITEM")
	Else
		MsAuto2aCols()
	EndIf
	//������������������������������������������Ŀ
	//�Gera validacao das informacoes adiquiridas�
	//��������������������������������������������
	nOpcA := 1
	For nI := 1 to SDA->(FCount())
		Aadd(aValidGet,{SDA->(FieldName(nI)),SDA->(FieldGet(nI)),"",.t.})
	Next
	If ( nCounter > 0 )
		If ! SDB->(MsVldAcAuto(aValidGet,"u_xA265LinOk(o)","u_xA265TudoOk(o)",,4,"DB_ITEM"))   // consiste o campos do Acols
			nOpcA := 0
		EndIf
	Else
		If nOpcA == 0 .or. ! SDB->(MsVldAcAuto(aValidGet,"u_xA265LinOk(o)","u_xA265TudoOk(o)"))   // consiste o campos do Acols
			nOpcA := 0
		EndIf
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//� Grava movimentos e baixa saldo a classificar no SB2 e no SDA �
//����������������������������������������������������������������
If nOpca == 1
	u_xA265Grava()
Else
	//��������������������������������������������������������������Ŀ
	//�Executa P.E. ao sair sem gravar 				                 �
	//����������������������������������������������������������������
	If (ExistBlock("MTA265CAN"))
		ExecBlock("MTA265CAN",.F.,.F.)
	EndIf
EndIf
//Destrava o Lock
SDA->(MsUnLock())
//��������������������������������������������������������������Ŀ
//� Desativa tecla F4 para comunicacao com Saldos dos Lotes      �
//����������������������������������������������������������������
SET KEY VK_F4 TO
RETURN

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Exclui� Autor � Rodrigo de A. Sartorio� Data � 05/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Distribuicao de produtos p/ Localizacao Fisica             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265Exclui(ExpC1,ExpN1,ExpN2)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function XA265Exclui(cAlias,nReg,nOpc)
Local nOpca := 0
Local cSeek := ''
Local nx    := 0
Local i     := 0
Local nI    := 0
Local bCampo
// Salva o Array aRotina Original
Local aCopia:=ACLONE(aRotina)
// Array com campos que podem ser alterados
Local aAlter   :={}
Local aObjects :={}
Local aPosObj  :={}
Local aNoFields:={}
Local cLoteSDA := SDA->DA_LOTECTL+SDA->DA_NUMLOTE
Local lRastro  := Rastro(SDA->DA_PRODUTO)
Local oDlg, aButtonUsr

Local aSize    :=MsAdvSize()
Local aInfo    :={aSize[1],aSize[2],aSize[3],aSize[4],3,3}

Local bSeekWhile := {|| SDB->DB_FILIAL+SDB->DB_PRODUTO+SDB->DB_LOCAL+SDB->DB_NUMSEQ+SDB->DB_DOC+SDB->DB_SERIE+SDB->DB_CLIFOR+SDB->DB_LOJA } //Condicao While para montar o aCols
Local bSeekFor   := {|| SDB->DB_ESTORNO <> "S" .And. SDB->DB_TM <= "500" .And. SDB->DB_TIPO == "D" .And. If(lRastro,cLoteSDA==SDB->DB_LOTECTL+SDB->DB_NUMLOTE,.T.) }
Local uRet

//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������

PRIVATE aButtons   := {}
PRIVATE nUsado     :=0
PRIVATE nCounter   :=0
PRIVATE nPosLocali :=0
PRIVATE nPosQuant  :=0
PRIVATE nPosData   :=0
PRIVATE nPosEstorn :=0
PRIVATE nPosLote   :=0
PRIVATE nPosLotCtl :=0
PRIVATE nPosNumSer :=0
PRIVATE nPosItem   :=0
PRIVATE nPosQtSegum:=0
PRIVATE Continua
PRIVATE aTELA[0][0]
PRIVATE aGETS[0]
PRIVATE oGetd

l265Auto := If(ValType(l265Auto) == "L",l265Auto,.F.)

//��������������������������������������������������������������Ŀ
//� Campos que podem ser alterados na GetDados, se for adicionado�
//� mais algum campo nesta variavel,tambem deverah ser feita a   �
//� alteracao na variavel aAltAuto no inicio do MATA265          �
//����������������������������������������������������������������
AADD(aAlter,"DB_ESTORNO")

bCampo    := { |nCPO| Field(nCPO) }

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
If LastRec() == 0
	Return (.T.)
EndIf

If SDA->DA_FILIAL != xFilial("SDA")
	Help(" ",1,"A000FI")
	Return (.T.)
EndIf

If !(Reclock("SDA",.F.))
	Return (.T.)
EndIf

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//� p/ preencher variaveis da Enchoice                   �
//��������������������������������������������������������
dbSelectArea(cAlias)
For i := 1 To FCount()
	M->&(EVAL(bCampo,i)) := FieldGet(i)
Next i

//������������������������������������������������������Ŀ
//� Conta registros de movimentos ja incluidos           �
//��������������������������������������������������������
nCounter	:=	u_xA265UltIt('N', .F.)

If nCounter == 0 //-- Conta somente Registros NAO DELETADOS
	If !l265Auto
		Aviso(STR0009,STR0014,{"OK"})  //###"Atencao"###"TODOS ITENS JA FORAM ESTORNADOS ! ! !"
	EndIf
	Return
EndIf

//���������������������������������������������������������Ŀ
//� M265BUT - Ponto de Entrada para Adicionar botoes        �
//�����������������������������������������������������������
If ExistBlock("M265BUT")
	aButtonUsr := ExecBlock("M265BUT",.F.,.F.,{nOpc})
	If ValType(aButtonUsr) == "A"
		For nX:=1 to Len(aButtonUsr)
			aAdd(aButtons,aButtonUsr[nX])
		Next
	EndIf
EndIf

cSeek	 := xFilial("SDB")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA

AAdd(aNoFields,'DB_PRODUTO') ; AAdd(aNoFields,'DB_DOC')     ; AAdd(aNoFields,'DB_SERIE')   ; AAdd(aNoFields,'DB_CLIFOR')
AAdd(aNoFields,'DB_LOJA')    ; AAdd(aNoFields,'DB_TIPONF')  ; AAdd(aNoFields,'DB_ORIGEM')
AAdd(aNoFields,'DB_TM')      ; AAdd(aNoFields,'DB_LOCAL')   ; AAdd(aNoFields,'DB_SERVIC')

//��������������������������������������������������������������Ŀ
//� Monta aHeader e aCols                                        �
//����������������������������������������������������������������
PRIVATE aHeader[0],aCols[0]

FillGetDados(nOpc,"SDB",1,cSeek,bSeekWhile,bSeekFor,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/)

//������������������������������������������������������Ŀ
//� Descobre a posicao dos campos obrigatorios no AHeader�
//��������������������������������������������������������
For nx = 1 To Len(aHeader)
	If Trim(aHeader[nx][2]) == "DB_LOCALIZ"
		nPosLocali:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_QUANT"
		nPosQuant:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_DATA"
		nPosData:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_ESTORNO"
		nPosEstorn:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_NUMLOTE"
		nPosLote:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_LOTECTL"
		nPosLotCtl:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_NUMSERI"
		nPosNumSer:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_ITEM"
		nPosItem:=nX
	ElseIf Trim(aHeader[nx][2]) == "DB_QTSEGUM"
		nPosQtSegum:=nx
	EndIf
Next nx

AADD(aObjects,{100,095,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

If !l265Auto
	DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
	EnChoice(cAlias,nReg,nOpc,,,,,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]})
	oGetd := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_xA265EstOk","u_xA265ETDOk","",,aAlter)
	ACTIVATE MSDIALOG oDlg ON INIT (oGetd:oBrowse:nRowPos:=Len(aCols),oGetd:oBrowse:Refresh(),EnchoiceBar(oDlg,{|| IIF(oGetd:TudoOk(),(nOpca:=1,oDlg:End()),)},{||oDlg:End()},,aButtons))
Else
	nOpca := 1
	MsAuto2aCols(4,,"DB_ITEM")
	For nI := 1 to SDA->(FCount())
		Aadd(aValidGet,{SDA->(FieldName(nI)),SDA->(FieldGet(nI)),"",.t.})
	Next
	If ! SDB->(MsVldAcAuto(aValidGet,"u_xA265EstOk(o)",,,4,"DB_ITEM"))   // consiste o campos do Acols
		nOpca := 0
	EndIf
EndIf

//���������������������������������������Ŀ
//� PE para validar a execucao do estorno �
//�����������������������������������������
If ExistBlock("M265VEST")
	uRet  := ExecBlock( "M265VEST", .F., .F., {nOpca} )
	nOpca := If(ValType(uRet)=="N", uRet, nOpca)
EndIf

//��������������������������������������������������������������Ŀ
//� Estorna movimentos e baixa saldo a classificar no SB2 e  SDA �
//����������������������������������������������������������������
If nOpca == 1
	u_xB265Estorn()
EndIf

RETURN

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Grava � Autor � Rodrigo de A. Sartorio� Data � 06/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava os registros de movimentacao de distribuicao         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265Grava()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function xA265Grava()

Local i          := 0
Local j          := 0
Local nEmpenho   := 0
Local nBaixa     := 0
Local nEmpenho2  := 0
Local nBaixa2    := 0
Local nPos       := 0
Local nX         := 0
Local nQtde      := 0
Local n1Cnt      := 0
Local nSaldoSBF  := 0
Local nPosDCF    := 0
Local nRecnoSDB  := 0

Local cSeek      := ''
Local cSeekSD1   := ''
Local cSeekSD7   := ''
Local cNumSD1    := ''
Local cSeekDCF   := ''
Local cEndOrig   := ''
Local cEstOrig   := ''
Local cTm        := ''

Local lMTA265I   := (ExistBlock( 'MTA265I' ) )
Local aCpoUsu    := {}
Local aSeekDCF   := {}

Local lAchouD1   := .F.
Local lGrvEnd    := .F.

Local cLocalCQ   := SuperGETMV("MV_CQ")
Local bCampo     := { |nCPO| Field(nCPO) }
Local dDtValid,lCQ
Local aAreaDTC

Local lIntDL     := IntDl(SDA->DA_PRODUTO)
Local lExecDCF   := IntDl(SDA->DA_PRODUTO) .And. SuperGetMV('MV_RADIOF') == 'S'
Local cServWMSE  := SuperGetMV('MV_SRVWMSE', .F., '499') //-- Servico de WMS Generico para Entradas

// Variavel usada no monitoramento de saldos na funcao LogMov() (SIGACUSA)
Local aSldAnt    := {}

//��������������������������������������������������������������Ŀ
//� Ativa variavel relativa a movimentacao                       �
//����������������������������������������������������������������
lMovimento:=.T.

//��������������������������������������������������������������Ŀ
//� Verifica se Existem Campos de Usuario no SX3                 �
//����������������������������������������������������������������
SX3->(dbSetOrder(1))
If SX3->(dbSeek('SDB', .F.))
	Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == 'SDB'
		If SX3->X3_PROPRI == 'U'
			aAdd(aCpoUsu, {SX3->X3_CAMPO, SX3->X3_TIPO})
		EndIf
		SX3->(dbSkip())
	EndDo
EndIf

//��������������������������������������������������������������Ŀ
//� Posiciona no almoxarifado correto.                           �
//����������������������������������������������������������������
SB2->(dbSeek(xFilial("SB2")+SDA->DA_PRODUTO+SDA->DA_LOCAL))

//��������������������������������������������������������������Ŀ
//� Grava somente novos movimentos.                              �
//����������������������������������������������������������������
For i := nCounter+1 To Len(aCols)
	If !(aCols[i,Len(aCols[i])])
		//-- Validacoes WMS
		If	lIntDL .And. GdFieldGet('DB_SERVIC',i)!=cServWMSE
			If	!Empty(GdFieldGet('DB_SERVIC',i)) .And. Empty(SDA->DA_DOC)
				If Type("l265Auto") != "L" .Or. !l265Auto
					Aviso('MATA26502',STR0027,{'Ok'}) //'O campo "DOCUMENTO" deve ser preenchido quando integrado ao WMS.'
				EndIf
				//-- Sai do laco do For sem efetuar gravacoes
				Exit
			EndIf
			//-- Nao permite enderecar quantidade superior ao saldo a distribuir, considerando os
			//-- servicos de enderecamento pendentes na radio frequencia.
			nSaldoSBF := WmsSaldoSBF(SDA->DA_LOCAL,,SDA->DA_PRODUTO,,SDA->DA_LOTECTL,SDA->DA_NUMLOTE,.F.,,.T.,.F.,,'3',,SDA->DA_NUMSEQ,SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA)
			If	QtdComp(nSaldoSBF + GdFieldGet('DB_QUANT',i)) > QtdComp(SDA->DA_SALDO)
				AutoGrLog(Repl('-',80))
				AutoGrLog(STR0029) //'OCORRENCIA NO ENDERECAMENTO MANUAL'
				AutoGrLog(STR0030+SDA->DA_DOC) //'Documento : '
				If	!Empty(SDA->DA_SERIE)
					AutoGrLog(STR0031+SDA->DA_SERIE) //'Serie : '
				EndIf
				If	!Empty(SDA->DA_CLIFOR)
					AutoGrLog(STR0032+SDA->DA_CLIFOR) //'Cod.Cli/Forn : '
					AutoGrLog(STR0033+SDA->DA_LOJA) //'Loja : '
				EndIf
				AutoGrLog(STR0034+SDA->DA_LOCAL) //'Armazem : '
				AutoGrLog(STR0035+SDA->DA_PRODUTO) //'Produto : '
				AutoGrLog(' ')
				If	nSaldoSBF > 0
					AutoGrLog(STR0036) //'Existe O.S.WMS pendente para este documento'
					AutoGrLog(' ')
				EndIf
				AutoGrLog(STR0037+Transform(SDA->DA_SALDO-nSaldoSBF,'@E 9,999,999.99')) //'Saldo a distribuir : '
				AutoGrLog(Repl('-',80))
				MostraErro()
				Exit
			EndIf
		EndIf
		//-- Gerar e executar a O.S.WMS sem atualizar o estoque.
		//-- O processo inicia na nota fiscal de entrada, informe o endereco( D1_ENDER ) e
		//-- estrutura fisica de origem( D1_TPESTR ) e nao preencha o codigo do servico( D1_SERVIC ),
		//-- pois a O.S.WMS sera gerada e executada no enderecamento de produtos quando o
		//-- codigo de servico( DB_SERVIC ) for diferente do servico de WMS generico para entradas e o
		//-- endereco e estrutura fisica de destino for informado nos campos DB_LOCALIZ e DB_ESTDES.
		If	lIntDL .And. !Empty(GdFieldGet('DB_SERVIC',i)) .And. GdFieldGet('DB_SERVIC',i)!=cServWMSE
			//-- Posiciona no item da entrada de nota para identificar o endereco e estrutura inicial
			cTm      := ''
			cEndOrig := ''
			cEstOrig := ''
			lGrvEnd  := .F.
			nPosDCF  := 0
			If	SDA->DA_ORIGEM == 'SD1'
				SD1->(DbSetOrder(5))
				SD1->(MsSeek(xFilial('SD1')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ))
				If	!Empty(SD1->D1_SERVIC)
					If Type("l265Auto") != "L" .Or. !l265Auto
						DLAviso(, 'MATA26501', STR0018+AllTrim(Tabela('L4',SD1->D1_SERVIC,.F.))+STR0019) //'O servico de '###' devera ser executado pela rotina de Execucao de Servicos'
					EndIf
					//-- Sai do laco do For sem efetuar gravacoes
					Exit
				EndIf
				cTm      := SD1->D1_TES
				cEndOrig := SD1->D1_ENDER
				cEstOrig := SD1->D1_TPESTR
			ElseIf SDA->DA_ORIGEM == 'SD3'
				SD3->(DbSetOrder(3))
				SD3->(MsSeek(xFilial('SD3')+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ))
				cTm := SD3->D3_TM
			ElseIf SDA->DA_ORIGEM == 'SD5'
				//-- gerar OS e nao executar ao informar codigo de servico na rotina de Enderecar saldos (MATA265) 
				//-- para saldos gerados pela manutencao de lotes (SD5).
				lExecDCF := .F.
			EndIf
			//-- Solicita a digitacao do endereco e estrutura inicial
			If	Empty(cEndOrig) .Or. Empty(cEstOrig)
				DLPergEnd(@cEndOrig,@cEstOrig,STR0038+SDA->DA_DOC,STR0020,.T.,.T.) //'Identifique a origem do Servico de WMS:' //'SIGAWMS - O.S.'
			EndIf
			aParam150 := Array(32)
			aParam150[01] := SDA->DA_PRODUTO
			aParam150[02] := SDA->DA_LOCAL
			aParam150[03] := SDA->DA_DOC
			aParam150[04] := SDA->DA_SERIE
			aParam150[05] := SDA->DA_NUMSEQ
			aParam150[06] := GdFieldGet('DB_QUANT',i)
			aParam150[07] := dDataBase
			aParam150[09] := GdFieldGet('DB_SERVIC',i)
			aParam150[12] := SDA->DA_CLIFOR
			aParam150[13] := SDA->DA_LOJA
			aParam150[16] := cTm
			aParam150[17] := SDA->DA_ORIGEM
			aParam150[18] := SDA->DA_LOTECTL
			aParam150[19] := SDA->DA_NUMLOTE
			If	!Empty(cEndOrig)
				aParam150[20] := cEndOrig
			EndIf
			If	!Empty(cEstOrig)
				aParam150[21] := cEstOrig
			EndIf
			aParam150[25] := aParam150[02]
			aParam150[26] := GdFieldGet('DB_LOCALIZ',i)
			aParam150[27] := GdFieldGet('DB_ESTDES',i)

			CriaDCF('SDA',,,,{aParam150[09],cEstOrig,cEndOrig,aParam150[06]},@nPosDCF)

			If lExecDCF
				//-- Executa o servico
				DC5->(DbSetOrder(1))
				If	! Empty(nPosDCF) .And. DC5->(MsSeek(xFilial('DC5')+aParam150[09]))
					While DC5->(!Eof() .And. DC5->DC5_FILIAL + DC5->DC5_SERVIC == xFilial('DC5')+aParam150[09])
						//-- Grava o status da O.S.WMS como 'Interrompido'
						DCF->(DbGoTo(nPosDCF))
						DLA150Stat('2')
						aParam150[08] := Time()
						aParam150[10] := DC5->DC5_TAREFA
						aParam150[11] := ''
						aParam150[28] := DC5->DC5_ORDEM
						aParam150[29] := ''
						aParam150[30] := ''
						aParam150[31] := ''
						DLXExecAti(DC5->DC5_TAREFA, aParam150)
						//-- Grava o status da O.S.WMS como 'Executado'
						DCF->(DbGoTo(nPosDCF))
						DLA150Stat('3')
						DC5->(DbSkip())
					EndDo
				EndIf
			EndIf

		Else

			Begin Transaction
			//�������������������������������������������������������Ŀ
			//� Chamada da LogMov para verificar o saldo antes da     |
			//| atualizacao das tabelas SB2/SBF/SB8                   |
			//���������������������������������������������������������
			LogMov('SDA',,,SDA->DA_PRODUTO,SDA->DA_LOCAL,,,,,.T.,@aSldAnt)

			//��������������������������������������������������������������Ŀ
			//� Gera movimento (SDB)                                         �
			//����������������������������������������������������������������
			nRecnoSDB := 0
			CriaSDB(SDA->DA_PRODUTO,SDA->DA_LOCAL,aCols[i,nPosQuant],aCols[i,nPosLocali],aCols[i,nPosNumSer],SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,SDA->DA_TIPONF,SDA->DA_ORIGEM,aCols[i,nPosData],SDA->DA_LOTECTL,SDA->DA_NUMLOTE,SDA->DA_NUMSEQ,"499","D",aCols[i,nPosItem],.F.,If(SDA->DA_EMPENHO>0,aCols[i,nPosQuant],0),If(nPosQtSegum>0,aCols[i,nPosQtSegum],0),,,,,,,,,,,,,,,,,,,@nRecnoSDB)
			//��������������������������������������������������������������Ŀ
			//� Efetua a Gravacao dos Campos de Usuario da Linha do aCols    �
			//����������������������������������������������������������������
			If Len(aCpoUsu) > 0
				RecLock('SDB', .F.)
				For nX := 1 to Len(aCpoUsu)
					nPos:=aScan(aHeader,{|x| x[2] == aCpoUsu[nX,1]})
					If nPos > 0 .And. ValType(aCols[i,nPos])==aCpoUsu[nX,2]
						Replace &(aCpoUsu[nX,1])	With aCols[i, nPos]
					EndIf
				Next nX
				MsUnlock()
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Baixa saldo classificar do arquivo de saldos em estoque (SB2)�
			//����������������������������������������������������������������
			RecLock("SB2",.F.)
			Replace B2_QACLASS With B2_QACLASS - SDB->DB_QUANT

			//��������������������������������������������������������������Ŀ
			//� Atualiza CQ_QTDISP e B2_QEMPSA para baixar pre-requisicao.   �
			//����������������������������������������������������������������
			A265AtuSA(1)

			//��������������������������������������������������������������Ŀ
			//� Baixa saldo empenhado no arquivo de saldos por sub-lote (SB8)�
			//����������������������������������������������������������������
			If Rastro(SDA->DA_PRODUTO)
				If Rastro(SDA->DA_PRODUTO,"S")
					dbSelectArea("SB8")
					dbSetOrder(3)
					cSeek:=xFilial("SB8")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL+SDA->DA_NUMLOTE
					If dbSeek(cSeek)
						RecLock("SB8",.F.)
						Replace B8_QACLASS With B8_QACLASS - SDB->DB_QUANT
						Replace B8_QACLAS2 With B8_QACLAS2 - SDB->DB_QTSEGUM
						dDtValid := B8_DTVALID
					EndIf
				Else
					nEmpenho:=SDB->DB_QUANT
					nEmpenho2:=SDB->DB_QTSEGUM
					dbSelectArea("SB8")
					dbSetOrder(3)
					cSeek:=xFilial("SB8")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL
					dbSeek(cSeek)
					Do While !Eof() .And. nEmpenho > 0 .And. B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL == cSeek
						nBaixa:=IF(SB8->B8_QACLASS < nEmpenho,SB8->B8_QACLASS,nEmpenho)
						nBaixa2:=IF(SB8->B8_QACLAS2 < nEmpenho2,SB8->B8_QACLAS2,nEmpenho2)
						Reclock("SB8",.F.)
						Replace B8_QACLASS With B8_QACLASS - nBaixa
						Replace B8_QACLAS2 With B8_QACLAS2 - ConvUM(SB8->B8_PRODUTO, nBaixa, nBaixa2, 2)
						dDtValid := B8_DTVALID
						nEmpenho -= nBaixa
						nEmpenho2-= nBaixa2
						dbSkip()
					EndDo
				EndIf
			EndIf

			//��������������������������������������������������������������Ŀ
			//� Cria Saldo no SBF baseado no movimento                       �
			//����������������������������������������������������������������
			GravaSBF("SDB",,,nRecnoSDB)

			// Verifica se o produto tem CQ
			cSeekSD7 := xFilial("SD7")+DA_PRODUTO+DA_NUMSEQ+DA_DOC
			SD7->(dbSetOrder(3))
			If SD7->(dbSeek(cSeekSD7))
				cSeekSD1 := xFilial("SD1")+SD7->D7_PRODUTO+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA
				lCQ      := .T.
			Else
				cSeekSD1 := xFilial("SD1")+	SDA->DA_PRODUTO+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA
				lCQ      := .F.
			EndIf

			cNumSD1 := If(lCQ,"SD7->D7_NUMERO == SD1->D1_NUMCQ","SDA->DA_NUMSEQ == SD1->D1_NUMSEQ")

			//-- Caso item da NF seja para OP, grava o numero da OP na requisicao.
			SD1->(dbSetOrder(2))
			SD1->(dbSeek(cSeekSD1))
			While !SD1->(Eof()) .And. SD1->(D1_FILIAL+D1_COD+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cSeekSD1
				If &cNumSD1 .And. !Empty(SD1->D1_OP) .And. (SDA->DA_LOCAL # cLocalCQ)
					lAchouD1 := .T.
					Exit
				EndIf
				SD1->(dbSkip())
			End
			If lAchouD1
				//-- Gera Movimenta��o (S) RE5 Ref. a OP no SD1 (SD3)
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SDA->DA_PRODUTO))

				RecLock('SD3', .T.)
				Replace D3_FILIAL  With xFilial('SD3')
				Replace D3_COD     With SDA->DA_PRODUTO
				Replace D3_QUANT   With SDB->DB_QUANT
				Replace D3_CF      With 'RE5'
				Replace D3_CHAVE   With 'E0'
				Replace D3_LOCAL   With SDA->DA_LOCAL
				Replace D3_DOC     With If(lCQ,SD7->D7_NUMERO,SDA->DA_DOC)
				Replace D3_EMISSAO With dDataBase
				Replace D3_UM      With SB1->B1_UM
				Replace D3_GRUPO   With SB1->B1_GRUPO
				Replace D3_NUMSEQ  With If(lCQ,SD7->D7_NUMSEQ,SDA->DA_NUMSEQ)
				Replace D3_QTSEGUM With If(lCQ,SD7->D7_QTSEGUM,SDA->DA_QTSEGUM)
				Replace D3_SEGUM   With SB1->B1_SEGUM
				Replace D3_TM      With '999'
				Replace D3_TIPO    With SB1->B1_TIPO
				Replace D3_CONTA   With SB1->B1_CONTA
				Replace D3_USUARIO With CUSERNAME
				Replace D3_OP      With SD1->D1_OP
				Replace D3_NUMLOTE With SDA->DA_NUMLOTE
				Replace D3_LOTECTL With SDA->DA_LOTECTL
				Replace D3_LOCALIZ With aCols[i,nPosLocali]
				Replace D3_IDENT   With SDA->DA_NUMSEQ
				If Rastro(SDA->DA_PRODUTO)
					Replace D3_DTVALID With dDtvALID
				EndIf
				MsUnlock()
				nSD3Rec := Recno()

				// aCM => array com os custos medio do produto
				aCM := If(If(lCQ,SD7->D7_ORIGLAN=='CP',SDA->DA_ORIGEM=='SD1'),PegaCMD1(),PegaCMD3())

				//-- Grava o custo da movimentacao
				aCusto := GravaCusD3(aCM)

				dbSelectArea("SD4")
				dbSetOrder(1)
				If MsSeek(xFilial("SD4")+SD1->D1_COD+SD1->D1_OP)
					nQtde := Min(SD4->D4_QTDEORI-SD4->D4_QUANT,SDB->DB_QUANT)
					RecLock("SD4",.f.)
					SD4->D4_QUANT	:= SD4->D4_QUANT   - nQtde
					SD4->D4_QTSEGUM	:= SD4->D4_QTSEGUM - ConvUM(SD4->D4_COD, nQtde, 0, 2)
					dbSelectArea("SB2")
					dbSetOrder(1)
					If MsSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
						RecLock("SB2",.F.)
						nQtde := IIf(nQtde==NIL,SD1->D1_QUANT,nQtde)
						Replace B2_QEMP  With B2_QEMP  - nQtde
						Replace B2_QEMP2 With B2_QEMP2 - ConvUM(SB2->B2_COD, nQtde, 0, 2)
					EndIf
				EndIf

				//-- Atualiza o saldo atual (VATU) com os dados do SD3
				B2AtuComD3(aCusto)

				//-- Acerta custo da OP relacionada na NF de Entrada
				C2AtuComD3(aCusto)

			EndIf

			//��������������������������������������������������������������Ŀ
			//� Baixa saldo do arquivo de Saldos a classificar   (SDA)       �
			//����������������������������������������������������������������
			RecLock("SDA",.F.)
			Replace DA_SALDO   With DA_SALDO - SDB->DB_QUANT
			Replace DA_QTSEGUM With DA_QTSEGUM - SDB->DB_QTSEGUM
			Replace DA_EMPENHO With DA_EMPENHO - SDB->DB_EMPENHO
			Replace DA_EMP2    With DA_EMP2 - SDB->DB_EMP2

			//��������������������������������������������������������������Ŀ
			//� Integracao com o Modulo de Transporte (TMS)                  �
			//����������������������������������������������������������������
			If IntTMS()
				aAreaDTC := DTC->(GetArea())
				DUH->(dbSetOrder(1))
				DTC->(dbSetOrder(2))
				If DTC->(MsSeek(xFilial('DTC')+ SDA->(DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA) )) .And. ;
						!DUH->(MsSeek(xFilial('DUH')+ cFilAnt + SDA->(DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA) ))
					RegToMemory( 'DUH', .T. )
					M->DUH_FILIAL := xFilial('DUH')	
					M->DUH_FILORI := cFilAnt
					M->DUH_NUMNFC := SDA->DA_DOC
					M->DUH_SERNFC := SDA->DA_SERIE
					M->DUH_CLIREM := SDA->DA_CLIFOR
					M->DUH_LOJREM := SDA->DA_LOJA
					M->DUH_LOCAL  := SDA->DA_LOCAL
					M->DUH_QTDVOL := GdFieldGet('DB_QUANT'  ,i)
					M->DUH_LOCALI := GdFieldGet('DB_LOCALIZ',i)
						M->DUH_CODPRO  := SDA->DA_PRODUTO
					nCampos := DUH->( FCount() )
					RecLock('DUH',.T.)
					For n1Cnt := 1 To nCampos
						FieldPut( n1Cnt, M->&( Eval( bCampo,n1Cnt ) ) )
					Next
					MsUnLock()
				EndIf
				RestArea(aAreaDTC)
			EndIf
	
			//������������������������������������������������������������Ŀ
			//� Chamada da LogMov apos atualizacao das tabelas SB2/SBF/SB8 |
			//��������������������������������������������������������������
			LogMov('SDA',,,SDA->DA_PRODUTO,SDA->DA_LOCAL,,,,,,aClone(aSldAnt))

			End Transaction

			//�������������������������������������������������������������������Ŀ
			//� Ponto de entrada Posterior a gravacao na Inclus�o - MTA265I       �
			//���������������������������������������������������������������������
			If lMTA265I
				ExecBlock("MTA265I", .F., .F., {i})
			EndIf

		EndIf
	EndIf
Next i

//��������������������������������������������������������������Ŀ
//� Integracao com o Modulo de Transporte (TMS) caso o documento �
//� seja relacionado a alguma viagem                             �
//����������������������������������������������������������������
If IntTMS() .And. (QtdComp(SDA->DA_SALDO) == QtdComp(0))
	u_xA265DocTMS(.F.)
EndIf

//��������������������������������������������������������������Ŀ
//�Executa P.E. apos gravacao das movimentacoes/integracoes      �
//����������������������������������������������������������������
If (ExistBlock("MTA265GRV"))
	ExecBlock("MTA265GRV",.F.,.F.)
EndIf

RETURN

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Estorn� Autor � Rodrigo de A. Sartorio� Data � 06/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Estorna gravacao de movimentacao de distribuicao           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265Estorn()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xB265Estorn()

Local bCampo     := {|nCPO| Field(nCPO) }
Local cAlias     := Alias()
Local cSeek      := ''
Local cSeek2     := ''
Local cSeekSD1   := ''
Local cSeekSD7   := ''
Local cNumSD1    := ''
Local i          := 0
Local nEmpenho   := 0
Local nBaixa     := 0
Local nEmpenho2  := 0
Local nBaixa2    := 0
Local nPos       := 0
Local nX         := 0
Local nZ         := 0
Local nSldDE5    := 0
Local nRestaura  := 0
Local nRestDC    := 0
Local nRecnoSDB  := 0
Local nCount     := 0
Local nQtdEnd    := 0
Local nQtdLote   := 0

Local aCpoUsu    := {}
Local aArray     := {}
Local aTravas    := {}

Local lMTA265E   := (ExistBlock( 'MTA265E' ) )
Local lMT265ACD   := ExistBlock('MT265ACD')
Local lIntACD	 := SuperGetMV("MV_INTACD",.F.,"0") == "1"
Local dDataFec   := MVUlmes()
Local lAchouD1   := .F.

Local dDtValid,lCQ

Local cLocalCQ   := SuperGETMV("MV_CQ")
Local lEmpPrev   := If(SuperGetMV("MV_QTDPREV")== "S",.T.,.F.)
Local lRe5       := .F.
Local cDistaut	 := SuperGETMV("MV_DISTAUT")

// Variavel usada no monitoramento de saldos na funcao LogMov() (SIGACUSA)
Local aSldAnt    := {}

//��������������������������������������������������������������Ŀ
//� Verificar data do ultimo fechamento em SX6.                  �
//����������������������������������������������������������������
If dDataFec >= dDataBase
	Help ( " ", 1, "FECHTO" )
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica se Existem Campos de Usuario no SX3                 �
//����������������������������������������������������������������
SX3->(dbSetOrder(1))
If SX3->(dbSeek('SDB', .F.))
	Do While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == 'SDB'
		If SX3->X3_PROPRI == 'U'
			aAdd(aCpoUsu, {SX3->X3_CAMPO, SX3->X3_TIPO})
		EndIf
		SX3->(dbSkip())
	EndDo
EndIf


//��������������������������������������������������������������Ŀ
//� Verifica se no SD3 o D3_CF = RE5                             �
//����������������������������������������������������������������
SD3->(dbSetOrder(2))
SD3->(MsSeek(xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO))
While !Eof() .And. xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO == SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD
	If SD3->D3_CF == "RE5" .And. !Empty(SD3->D3_OP) .And. SDA->DA_NUMSEQ+SDA->DA_LOTECTL == SD3->D3_NUMSEQ+SD3->D3_LOTECTL .And. SD3->D3_ESTORNO # "S"
		lRe5 := .T.
		Exit
	EndIf
	SD3->(dbSkip())	
EndDo

//��������������������������������������������������������������Ŀ
//� Posiciona no almoxarifado correto.                           �
//����������������������������������������������������������������
SB2->(dbSeek(xFilial("SB2")+SDA->DA_PRODUTO+SDA->DA_LOCAL))

//��������������������������������������������������������������Ŀ
//� Processa somente novos estornos.                             �
//����������������������������������������������������������������
For i:=1 To Len(aCols)
	If aCols[i,nPosEstorn] == "S"
		// Chamada da fun��o SldPorLote para validar o saldo antes do Estorno
		aArray:=SldPorLote(SDA->DA_PRODUTO,SDA->DA_LOCAL,aCols[i,nPosQuant],If(nPosQtSegum>0,aCols[i,nPosQtSegum],0),SDA->DA_LOTECTL,SDA->DA_NUMLOTE,aCols[i,nPosLocali],aCols[i,nPosNumSer],@aTravas,NIL,NIL,.T.)
		nQtdEnd  := 0
		nQtdLote := 0
		For nX := 1 to Len(aArray)
			nQtdEnd += aArray[nX,5]
			For nZ := 1 to Len(aArray[nX,10])
				nQtdLote += aArray[nX,10,nZ,2]
			Next nZ
		Next
		If lRe5 .Or. (nQtdEnd >= aCols[i,nPosQuant] .And. IIf(Rastro(SDA->DA_PRODUTO),nQtdLote >= aCols[i,nPosQuant],.T.))
			//��������������������������������������������������������������Ŀ
			//� Grava movimento de estorno (SDB)                             �
			//����������������������������������������������������������������
			If UsaCb0("01") .And. (lIntACD) .And. !lMT265ACD
				//Valida se a etiqueta que est� sendo estornada pertence ao movimento antes de estornar
				If !CBMTA265E(1,i) .and. cDistaut <> SB2->B2_LOCAL + alltrim(aCols[i,nPosLocali])
					Return
				EndIf
			EndIf
			
			Begin Transaction
				//�������������������������������������������������������Ŀ
				//� Chamada da LogMov para verificar o saldo antes da     |
				//| atualizacao das tabelas SB2/SBF/SB8                   |
				//���������������������������������������������������������
				LogMov('SDA',,,SDA->DA_PRODUTO,SDA->DA_LOCAL,,,,,.T.,@aSldAnt)
	
				dbSelectArea("SDB")
				dbSetOrder(1)
				cSeek:=xFilial("SDB")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA+aCols[i,nPosItem]
				dbSeek(cSeek)
				Do While !Eof() .And. cSeek == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_ITEM
					If DB_TIPO == "D" .And. DB_ESTORNO # "S"
						Exit
					EndIf
					dbSkip()
				EndDo
				RecLock("SDB",.F.)
				Replace DB_ESTORNO WITH "S"
				nRecnoSDB := 0
				CriaSDB(SDA->DA_PRODUTO,SDA->DA_LOCAL,aCols[i,nPosQuant],aCols[i,nPosLocali],aCols[i,nPosNumSer],SDA->DA_DOC,SDA->DA_SERIE,SDA->DA_CLIFOR,SDA->DA_LOJA,SDA->DA_TIPONF,SDA->DA_ORIGEM,aCols[i,nPosData],SDA->DA_LOTECTL,SDA->DA_NUMLOTE,SDA->DA_NUMSEQ,"999","D",aCols[i,nPosItem],.T.,If(SDA->DA_EMPENHO>0,aCols[i,nPosQuant],0),If(nPosQtSegum>0,aCols[i,nPosQtSegum],0),,,,,,,,,,,,,,,,,,,@nRecnoSDB)
	
				//��������������������������������������������������������������Ŀ
				//� Efetua a Gravacao dos Campos de Usuario da Linha do aCols    �
				//����������������������������������������������������������������
				If Len(aCpoUsu) > 0
					RecLock('SDB', .F.)
					For nX := 1 to Len(aCpoUsu)
						If (nPos:=aScan(aHeader,{|x|x[2]==aCpoUsu[nX,1]}))>0 .And. ValType(aCols[i,nPos])==aCpoUsu[nX,2]
							Replace &(aCpoUsu[nX,1])	With aCols[i, nPos]
						EndIf
					Next nX
					MsUnlock()
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Soma saldo classificar no arquivo de saldos em estoque (SB2) �
				//����������������������������������������������������������������
				RecLock("SB2",.F.)
				Replace B2_QACLASS With B2_QACLASS + SDB->DB_QUANT
	
				//��������������������������������������������������������������Ŀ
				//� Atualiza CQ_QTDISP e B2_QEMPSA para estornar pre-requisicao. �
				//����������������������������������������������������������������
				A265AtuSA(2)
	
				// Verifica se o produto tem CQ
				cSeekSD7 := xFilial("SD7")+DA_PRODUTO+DA_NUMSEQ+DA_DOC
				SD7->(dbSetOrder(3))
				If SD7->(dbSeek(cSeekSD7))
					cSeekSD1 := xFilial("SD1")+SD7->D7_PRODUTO+SD7->D7_DOC+SD7->D7_SERIE+SD7->D7_FORNECE+SD7->D7_LOJA
					lCQ     := .T.
				Else
					cSeekSD1 := xFilial("SD1")+	SDA->DA_PRODUTO+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA
					lCQ     := .F.
				EndIf
	
				cNumSD1 := If(lCQ,"SD7->D7_NUMERO == SD1->D1_NUMCQ","SDA->DA_NUMSEQ == SD1->D1_NUMSEQ")
	
				//-- Caso item da NF seja para OP, grava o numero da OP na requisicao.
				SD1->(dbSetOrder(2))
				SD1->(dbSeek(cSeekSD1))
				If &cNumSD1 .And. !Empty(SD1->D1_OP) .And. (SDA->DA_LOCAL # cLocalCQ)
					lAchouD1 := .T.
				EndIf
	
				If lAchouD1
					//-- Gera Movimenta��o (S) RE5 Ref. a OP no SD1 (SD3)
					SB1->(dbSetOrder(1))
					SB1->(dbSeek(xFilial("SB1")+SDA->DA_PRODUTO))
					SD3->(dbSetOrder(2))
					SD3->(MsSeek(xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO))
					While xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO == SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD
						If SD3->D3_CF == "RE5" .And. !Empty(SD3->D3_OP) .And. SDA->DA_NUMSEQ+SDA->DA_LOTECTL == SD3->D3_NUMSEQ+SD3->D3_LOTECTL .And. SD3->D3_ESTORNO # "S" .And. SDB->DB_QUANT == SD3->D3_QUANT
							RecLock('SD3', .F.)				// Estorno do RE5
							Replace D3_ESTORNO With "S"
							dDtValid := SD3->D3_DTVALID
							Exit
						EndIf
						SD3->(dbSkip())
					EndDo
					RecLock('SD3', .T.)			 	// Cria DE5
					Replace D3_FILIAL  With xFilial('SD3')
					Replace D3_COD     With SDA->DA_PRODUTO
					Replace D3_QUANT   With SDB->DB_QUANT
					Replace D3_CF      With 'DE5'
					Replace D3_CHAVE   With 'E9'
					Replace D3_LOCAL   With SDA->DA_LOCAL
					Replace D3_DOC     With If(lCQ,SD7->D7_NUMERO,SDA->DA_DOC)
					Replace D3_EMISSAO With dDataBase
					Replace D3_UM      With SB1->B1_UM
					Replace D3_GRUPO   With SB1->B1_GRUPO
					Replace D3_NUMSEQ  With If(lCQ,SD7->D7_NUMSEQ,SDA->DA_NUMSEQ)
					Replace D3_QTSEGUM With If(lCQ,SD7->D7_QTSEGUM,SDA->DA_QTSEGUM)
					Replace D3_SEGUM   With SB1->B1_SEGUM
					Replace D3_TM      With '499'
					Replace D3_TIPO    With SB1->B1_TIPO
					Replace D3_CONTA   With SB1->B1_CONTA
					Replace D3_USUARIO With CUSERNAME
					Replace D3_OP      With SD1->D1_OP
					Replace D3_NUMLOTE With SDA->DA_NUMLOTE
					Replace D3_LOTECTL With SDA->DA_LOTECTL
					Replace D3_LOCALIZ With aCols[i,nPosLocali]
					Replace D3_IDENT   With SDA->DA_NUMSEQ
					Replace D3_DTVALID With dDtValid
					Replace D3_ESTORNO With "S"
					MsUnlock()
					nSD3Rec := Recno()
					// aCM => array com os custos medio do produto
					aCM := If(If(lCQ,SD7->D7_ORIGLAN=='CP',SDA->DA_ORIGEM=='SD1'),PegaCMD1(),PegaCMD3())
					//-- Grava o custo da movimentacao
					aCusto := GravaCusD3(aCM)
					nSldDE5 := SDB->DB_QUANT
					dbSelectArea("SD4")
					dbSetOrder(1)
					MsSeek(xFilial("SD4")+SD1->D1_COD+SD1->D1_OP)
					While nSldDE5 > 0
						If SD4->(D4_FILIAL+D4_COD+D4_OP) == xFilial("SD4")+SD1->(D1_COD+D1_OP)
							If SD4->D4_QUANT < SD4->D4_QTDEORI
								RecLock("SD4",.f.)
								nRestaura := Min(nSldDe5,SD4->D4_QTDEORI-SD4->D4_QUANT)
								SD4->D4_QUANT	:= SD4->D4_QUANT   + nRestaura
								SD4->D4_QTSEGUM	:= SD4->D4_QTSEGUM + ConvUM(SD4->D4_COD, nRestaura, 0, 2)
								dbSelectArea("SB2")
								dbSetOrder(1)
								If MsSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL)
									RecLock("SB2",.F.)
									Replace B2_QEMP  With B2_QEMP  + nRestaura
									Replace B2_QEMP2 With B2_QEMP2 + ConvUM(SB2->B2_COD, nRestaura, 0, 2)
								EndIf
								dbSelectArea("SDC")
								dbSetOrder(2)
								MsSeek(xFilial("SDC")+SD1->(D1_COD+D1_LOCAL+D1_OP))
								nRestDC := nRestaura
								While nRestDC > 0 .And. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP) == xFilial("SDC")+SD1->(D1_COD+D1_LOCAL+D1_OP)
									If SDC->DC_QUANT < SDC->DC_QTDORIG
										RecLock("SDC",.F.)
										SDC->DC_QUANT += Min(nRestDC,SDC->DC_QTDORIG)
										SDC->DC_QTSEGUM += ConvUM(SDC->DC_PRODUTO,Min(nRestDC,SDC->DC_QTDORIG),0,2)
										MsUnlock()
										dbSelectArea("SBF")
										dbSetOrder(1)
										If MsSeek(xFilial("SBF")+SDC->(DC_LOCAL+DC_LOCALIZ+DC_PRODUTO),.F.)
											RecLock("SBF",.F.)
											SBF->BF_EMPENHO += Min(nRestDC,SDC->DC_QTDORIG)
											SBF->BF_EMPEN2 += ConvUM(SBF->BF_PRODUTO,Min(nRestDC,SDC->DC_QTDORIG),0,2)
											MsUnlock()
										EndIf
										nRestDC -= Min(nRestDC,SDC->DC_QTDORIG)
									EndIf
									SDC->(dbSkip())
								End		
								nSldDE5 -= nRestaura
							EndIf
							SD4->(dbSkip())
						Else
							nSldDE5 := 0
						EndIf
					End
					//-- Atualiza o saldo atual (VATU) com os dados do SD3
					B2AtuComD3(aCusto)
					//-- Acerta custo da OP relacionada na NF de Entrada
					C2AtuComD3(aCusto)
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Baixa saldo empenhado no arquivo de saldos por sub-lote (SB8)�
				//����������������������������������������������������������������
				If Rastro(SDA->DA_PRODUTO)
					If Rastro(SDA->DA_PRODUTO,"S")
						dbSelectArea("SB8")
						dbSetOrder(3)
						cSeek2:=xFilial("SB8")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL+SDA->DA_NUMLOTE
						If dbSeek(cSeek2)
							RecLock("SB8",.F.)
							Replace B8_QACLASS With B8_QACLASS + SDB->DB_QUANT
							Replace B8_QACLAS2 With B8_QACLAS2 + SDB->DB_QTSEGUM
						EndIf
					Else
						nEmpenho:=SDB->DB_QUANT
						nEmpenho2:=SDB->DB_QTSEGUM
						dbSelectArea("SB8")
						dbSetOrder(3)
						dbSelectArea("SD5")
						dbSetOrder(3)
						dbSeek(xFilial("SD5")+SDB->DB_NUMSEQ+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL)
						While !Eof() .And. nEmpenho > 0 .And. D5_FILIAL+D5_NUMSEQ+D5_PRODUTO+D5_LOCAL+D5_LOTECTL == xFilial("SD5")+SDB->DB_NUMSEQ+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL
							dbSelectArea("SB8")
							If dbSeek(xFilial("SB8")+SD5->D5_PRODUTO+SD5->D5_LOCAL+SD5->D5_LOTECTL+SD5->D5_NUMLOTE)
								nBaixa:=If(SB8Saldo(Nil,Nil,Nil,Nil,Nil,lEmpPrev) < nEmpenho,SB8Saldo(Nil,Nil,Nil,Nil,Nil,lEmpPrev),nEmpenho)
								nBaixa2:=If(SB8Saldo(Nil,Nil,Nil,.T.,Nil,lEmpPrev) < nEmpenho2,SB8Saldo(Nil,Nil,Nil,.T.,Nil,lEmpPrev),nEmpenho2)
								Reclock("SB8",.F.)
								Replace B8_QACLASS With B8_QACLASS + nBaixa
								Replace B8_QACLAS2 With B8_QACLAS2 + ConvUM(SB8->B8_PRODUTO, nBaixa, nBaixa2, 2)
								nEmpenho -= nBaixa
								nEmpenho2-= nBaixa2
							EndIf
							dbSelectArea("SD5")
							dbSkip()
						End
						dbSelectArea("SB8")
						dbSetOrder(3)
						cSeek2:=xFilial("SB8")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_LOTECTL
						dbSeek(cSeek2)
						Do While !Eof() .And. nEmpenho > 0 .And. B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL == cSeek2
							nBaixa:=If(SB8Saldo(Nil,Nil,Nil,Nil,Nil,lEmpPrev) < nEmpenho,SB8Saldo(Nil,Nil,Nil,Nil,Nil,lEmpPrev),nEmpenho)
							nBaixa2:=If(SB8Saldo(Nil,Nil,Nil,.T.,Nil,lEmpPrev) < nEmpenho2,SB8Saldo(Nil,Nil,Nil,.T.,Nil,lEmpPrev),nEmpenho2)
							Reclock("SB8",.F.)
							Replace B8_QACLASS With B8_QACLASS + nBaixa
							Replace B8_QACLAS2 With B8_QACLAS2 + ConvUM(SB8->B8_PRODUTO, nBaixa, nBaixa2, 2)
							nEmpenho -= nBaixa
							nEmpenho2-= nBaixa2
							dbSkip()
						EndDo
					EndIf
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Soma saldo no arquivo de Saldos a classificar   (SDA)        �
				//����������������������������������������������������������������
				RecLock("SDA",.F.)
				Replace DA_SALDO   With DA_SALDO + SDB->DB_QUANT
				Replace DA_QTSEGUM With DA_QTSEGUM + SDB->DB_QTSEGUM
				Replace DA_EMPENHO With DA_EMPENHO + SDB->DB_EMPENHO
				Replace DA_EMP2    With DA_EMP2 + SDB->DB_EMP2
	
				If IntTMS()
					DUH->( dbSetOrder( 1 ) )
					If DUH->( MsSeek( xFilial("DUH")+ cFilAnt + SDA->( DA_DOC+DA_SERIE+DA_CLIFOR+DA_LOJA ) ) )
						RecLock( "DUH", .F. )
						DUH->(DbDelete())
						MsUnLock()
					EndIf
				EndIf
	
				//��������������������������������������������������������������Ŀ
				//� Baixa Saldo no SBF baseado no movimento                      �
				//����������������������������������������������������������������
				GravaSBF("SDB",,,nRecnoSDB)
	
				//������������������������������������������������������������Ŀ
				//� Chamada da LogMov apos atualizacao das tabelas SB2/SBF/SB8 |
				//��������������������������������������������������������������
				LogMov('SDA',,,SDA->DA_PRODUTO,SDA->DA_LOCAL,,,,,,aClone(aSldAnt))

			End Transaction

			//����������������������������������������������������������������������������Ŀ
			//� Integracao com o ACD - Faz Acerto do CB0 no estorno da Distribuicao 	   �
			//������������������������������������������������������������������������������
			If lIntACD .And. !lMT265ACD
				CBMTA265E(2,i) 
			//������������������������������������������Ŀ
			//�Template de acinamento de ponto de entrada�
			//��������������������������������������������
			ElseIf ExistTemplate("MTA265E")
				ExecTemplate("MTA265E", .F., .F., {i} )
			EndIf
    	
			If lMTA265E
				ExecBlock("MTA265E", .F., .F., {i} )
			EndIf   
			
		Else
			nCount++
		EndIf
		MaDesTrava(aTravas)
	EndIf
Next i

If nCount > 0
	Help(" ",1,"MA265QTEST")
EndIf	

//��������������������������������������������������������������Ŀ
//� Integracao com o Modulo de Transporte (TMS) caso o documento �
//� seja relacionado a alguma viagem                             �
//����������������������������������������������������������������
If IntTMS() .And. QtdComp(SDA->DA_SALDO) > QtdComp(0)
	u_xA265DocTMS(.T.)
EndIf
RETURN

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265VldAll� Autor � Rodrigo de A. Sartorio� Data � 06/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida campo a campo na GetDados p/ impedir alteracao em   ���
���          � movimentos anteriores.                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265VldAll()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xA265VldAll()
Local nx
Local cVar:=Alltrim(ReadVar())
Local lRet:=.T.
//������������������������������������������������������������������Ŀ
//� Verifica somente se a linha for de movimento anterior ou estorno.�
//��������������������������������������������������������������������
If n <= nCounter
	For nX := 1 to Len(aHeader)
		If AllTrim(aHeader[nX][2]) == Substr(cVar,4,10)
			If &(cVar) # aCols[n][nX]
				HELP(" ",1,"A175NAO")
				lRet:=.F.
				Exit
			EndIf
		EndIf
	Next nX
ElseIf cVar == "M->DB_ESTORNO"
	HELP(" ",1,"A265NAOEST")
	lRet:=.F.
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265TudoOk� Autor � Rodrigo de A. Sartorio� Data � 17/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a GetDados antes de abandonar                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265TudoOk()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xA265TudoOk(o)
Local lRet	:=.T.
Local lRetPE:=.T.
Local nX    := 0
Local nAnt  := n

For nX :=1 To Len(aCols)
	n:= nX
	lRet := u_xA265LinOk(o)
	If !lRet
		Exit
	Endif
Next

n:= nAnt

If lRet .And. ExistBlock("MA265TDOK")
	lRetPE:=ExecBlock("MA265TDOK",.F.,.F.)
	If ValType(lRetPE) == "L"
		lRet:=lRetPE
	EndIf
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265LinOK � Autor � Rodrigo de A. Sartorio� Data � 06/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a linha da GetDados na inclusao                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265LinOk()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function XA265LinOk(o)
Local lRet      := .T.
Local i         := 0
Local nQuant    := 0
Local nQuant2   := 0
Local nQuantCols:= 0
Local nAchou    := 0
Local nPosDCF	:= 0
Local aAreaAnt  := {}
Local aAreaSD1  := {}
Local aAreaSD3  := {}

Local cSeek     := ''
Local cOrigem   := ''
Local cDoc      := ''
Local cSerie    := ''
Local cCliFor   := ''
Local cLoja     := ''
Local cProduto  := ''
Local cServico  := ''
Local cSeekSD1  := ''
local cSeekSD3	:= ''
Local cNumSeq   := ''
Local cLocal    := ''
Local aDocOri   := {}  //-- Utilizado no estorno da o.s.wms

Local aArea     := GetArea()
Local cLocCQ    := SuperGetMV('MV_CQ')
Local aInfProd  := InfProd(SDA->DA_PRODUTO)
Local lIntegEIC := (SuperGetMV("MV_EASY") == "S")
Local dDataFec  := MVUlmes()
Local cAcao     := "2"
Local lAchou    := .F.
Local nPosRecn  := aScan(aHeader, { |x| Alltrim(x[2]) == 'DB_REC_WT' })

l265Auto := If(ValType(l265Auto) == "L",l265Auto,.F.)

If !(aCols[n,Len(aCols[n])])

	If l265Auto
		n := Len(aCols)	  // Posiciona a variavel "N" utilizada para definir a linha atual do aCols
	EndIf

	//-- Verifica se o movimento de origem foi excluido por outro usuario
	If lRet .And. SDA->DA_ORIGEM == 'SD1'
		aAreaAnt := GetArea()
		aAreaSD1 := SD1->(GetArea())
		dbSelectArea("SD1")
		dbSetOrder(5)
		If !dbSeek(xFilial("SD1")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ)
			Help(" ",1,"A265NOMOV")
			lRet := .F.
		EndIf
		RestArea(aAreaSD1)
		RestArea(aAreaAnt)
	ElseIf lRet .And. SDA->DA_ORIGEM == 'SD3'
		lAchou   := .F.
		aAreaAnt := GetArea()
		aAreaSD3 := SD3->(GetArea())
		dbSelectArea("SD3")
		dbSetOrder(8)
		If SD3->(dbSeek(cSeekSD3:=xFilial('SD3')+SDA->DA_DOC+SDA->DA_NUMSEQ))
			While SD3->(!Eof() .And. D3_FILIAL+D3_DOC+D3_NUMSEQ == cSeekSD3)
				If SD3->D3_COD == SDA->DA_PRODUTO
					If (SD3->D3_ESTORNO # 'S') .Or. (SD3->D3_ESTORNO == 'S' .And. SD3->D3_TM == '499')
						lAchou := .T.
						Exit
					EndIf	
				EndIf
			    SD3->(dbSkip())
			EndDo
			If !lAchou
				Help(" ",1,"A265NOMOV")
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"A265NOMOV")
			lRet := .F.		
		EndIf
		RestArea(aAreaSD3)
		RestArea(aAreaAnt)
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica campos obrigatorios                                 �
	//����������������������������������������������������������������
	If (Empty(aCols[n,nPosLocali]) .And. Empty(aCols[n,nPosNumSer])) .Or. Empty(aCols[n,nPosQuant]) .Or. Empty(aCols[n,nPosData])
		Help(" ",1,"MA260OBR")
		lRet:=.F.
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Valida data maior ou igual a data original do movimento      �
	//����������������������������������������������������������������
	If lRet .And. aCols[n,nPosData] < SDA->DA_DATA
		Help(" ",1,"DATADISTRI")
		lRet:=.F.
	EndIf

	//�������������������������������������������������������������������������Ŀ
	//� Valida se a data do Movimento e' Menor que a data de ultimo fechamento  �
	//���������������������������������������������������������������������������
	If lRet .And. dDataFec >= aCols[n,nPosData] .And. aCols[n,nPosData] == dDataBase
		Help ( " ", 1, "FECHTO" )
		lRet:=.F.
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Valida quantidade IGUAL A 1 quando usa numero de serie       �
	//����������������������������������������������������������������
	If lRet
		lRet:=MtAvlNSer(SDA->DA_PRODUTO,aCols[n,nPosNumSer],aCols[n,nPosQuant],aCols[n,nPosQtSegum])
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica se j� nao existe um numero de serie p/ este produto �
	//� neste almoxarifado.                                          �
	//����������������������������������������������������������������
	If lRet .And. n >= nCounter+1 .And. !Empty(aCols[n,nPosNumSer])
		dbSelectArea("SBF")
		dbSetOrder(4)
		cSeek  := xFilial("SBF")+SDA->DA_PRODUTO+aCols[n,nPosNumSer]
		nAchou := ASCAN(aCols,{|x| x[nPosNumSer] == aCols[n,nPosNumSer] .And. Empty(x[nPosEstorn]) })
		If (nAchou > 0 .And. nAchou >= nCounter+1 .And. nAchou # n) .Or. (dbSeek(cSeek) .And. QtdComp(BF_QUANT) > QtdComp(0))
			Help(" ",1,"NUMSERIEEX")
			lRet:=.F.
		EndIf
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica se nao existe outro produto nesta localizacao que   �
	//� utilize controle de area.                                    �
	//����������������������������������������������������������������
	//��������������������������������������������������������������Ŀ
	//� Verifica se nao existe outro produto nesta localizacao que   �
	//� utilize controle de area.                                    �
	//����������������������������������������������������������������
	If lRet
		If aCols[n,nPosRecn] == 0
		SBE->(dbSetOrder(1))
		If SBE->(dbSeek(xFilial("SBE")+SDA->DA_LOCAL+aCols[n,nPosLocali]))
			//�������������������������������������������������Ŀ
			//� Verifica se utiliza controle de Cubagem         �
			//���������������������������������������������������
			If aInfProd[1] .OR. (SBE->BE_ALTURLC*SBE->BE_LARGLC*SBE->BE_COMPRLC > 0)
				lRet:=ProdLocali(SDA->DA_PRODUTO,SDA->DA_LOCAL,aCols[n,nPosLocali])
			EndIf
		EndIf
	EndIf
	EndIf
	If lRet
		//��������������������������������������������������������������Ŀ
		//� Verifica se qtd distribuida nao ultrapassou o saldo a ser    �
		//� distribuido.                                                 �
		//����������������������������������������������������������������
		For i:= 1 to Len(aCols)
			If aCols[i,nPosEstorn] # "S" .And. !(aCols[i,Len(aCols[i])])
				nQuant+= aCols[i,nPosQuant]
				If nPosQtSegum > 0
					nQuant2+= aCols[i,nPosQtSegum]
				EndIf
			EndIf
		Next i
		If QtdComp(nQuant) > QtdComp(SDA->DA_QTDORI) .Or. If(nPosQtSegum > 0,QtdComp(NoRound(nQuant2, TamSx3("DA_QTDORI2")[2])) > QtdComp(SDA->DA_QTDORI2),.F.)
			Help(" ",1,"MA265QUANT")
			lRet:=.F.
		EndIf
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica se qtd distribuida nao ultrapassou a capacidade da  �
	//� localizacao.                                                 �
	//����������������������������������������������������������������
	If lRet .And. !Empty(aCols[n,nPosLocali])
		For i:=nCounter+1 to Len(aCols)
			If aCols[i,nPosLocali] == aCols[n,nPosLocali]
				nQuantCols+=aCols[i,nPosQuant]
			EndIf
		Next i
		lRet:=Capacidade(SDA->DA_LOCAL,aCols[n,nPosLocali],nQuantCols,SDA->DA_PRODUTO)
	EndIf
	//���������������������������������������������������������������������������������������������������������Ŀ
	//� Verifica se qtde a distribuir foi empenhada conforme conceito da processo de importa��o, se sim, n�o    �
	//� permitir a distribui��o dos produtos.                                                                   �
	//�����������������������������������������������������������������������������������������������������������
	If lRet .And. cPaisLoc != "BRA" .And. lIntegEIC .And. Rastro(SDA->DA_PRODUTO)
		If  SaldoSDA(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_LOTECTL,SDA->DA_NUMLOTE,.T. ) < aCols[n][nPosQuant]
			If !l265Auto
				Aviso(STR0016,STR0017, { "  OK  " } )
			EndIf
			lRet := .F.
		EndIf
	EndIf
	If	lRet .And. IntDL()
		cOrigem  := SDA->DA_ORIGEM
		cDoc     := SDA->DA_DOC
		cSerie   := SDA->DA_SERIE
		cCliFor  := SDA->DA_CLIFOR
		cLoja    := SDA->DA_LOJA
		cProduto := SDA->DA_PRODUTO
		cNumSeq  := SDA->DA_NUMSEQ
		cLocal   := SDA->DA_LOCAL
		cServico := ''
		If	cOrigem == 'SD1'
			dbSelectArea('SD1')
			dbSetOrder(1)
			If	SD1->(MsSeek(cSeekSD1:=xFilial('SD1')+cDoc+cSerie+cCliFor+cLoja+cProduto))
				While SD1->(!Eof() .And. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD == cSeekSD1)
					If	SD1->D1_NUMSEQ == cNumSeq
						cServico := SD1->D1_SERVIC
						Exit
					EndIf
					SD1->(dbSkip())
				EndDo
			EndIf
		ElseIf cOrigem == 'SD3'
			dbSelectArea('SD3')
			dbSetOrder(3) //D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ
			If	SD3->(MsSeek(cSeek:=xFilial('SD3')+cProduto+cLocal+cNumSeq))
				While SD3->(!Eof() .And. D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ == cSeek)
					If	!Empty(SD3->D3_SERVIC)
						cServico := SD3->D3_SERVIC
					EndIf
					SD3->(dbSkip())
				EndDo
			EndIf
		ElseIf cOrigem == 'SD2'
			cAcao := "2"
		EndIf
		If	!Empty(cOrigem) .And. (cAcao=="2" .Or. !Empty(cServico))
			// --- Validacoes WMS
			If	!Empty(cServico) .And. (SuperGetMV('MV_WMSVLDT',.F.,.T.)==.T.)
				If	!A260WMSvld(SDA->DA_PRODUTO, SDA->DA_LOCAL, Nil, aCols[n,nPosLocali], aCols[n,nPosNumSer], SDA->DA_LOTECTL, SDA->DA_NUMLOTE, aCols[n,nPosQuant], Nil, SuperGetMV('MV_WMSVLDE', .F., .T.))
					lRet := .F.
				EndIf
			EndIf
			If	lRet
				//-- Verifica se o servico diferente de conferencia 000005 - DLCONFEREN
				DC5->(DbSetOrder(1)) //DC5_FILIAL+DC5_SERVIC+DC5_ORDEM
				If	DC5->(MsSeek(xFilial('DC5')+cServico) .And. DC5_FUNEXE<>'000005')
					If	lRet .And. WmsChkDCF(cOrigem,,,cServico,,,cDoc,cSerie,cCliFor,cLoja,cLocal,cProduto,,,cNumSeq,,@nPosDCF,cAcao)
						If	l265Auto .Or. SuperGetMV('MV_WMSDCFV',.F.,.F.) .Or. Aviso(STR0009,STR0023,{STR0025,STR0026}) == 1 //'Atencao'###'Este endere�amento possui servi�o WMS. Estorna O.S.WMS ?'###'Sim'###'Nao'
							DCF->(DbGoTo(nPosDCF))
							//-- Estorna a O.S.WMS
							If	DCF->DCF_STSERV == '1'
								RecLock('DCF',.F.,.T.)
								DCF->(DbDelete())
								MsUnLock()
							Else
								//-- Estorna o enderecamento feito atraves do WMS
								lRet := MADeletDCF('2',,.T.,.T.,aDocOri)
								//-- Estorna todos os documentos com referencia a carga ou documento original
								If	lRet .And. ! Empty(aDocOri)
									MADeletDCF('3',,,,aDocOri)
								EndIf
								//-- Apos o estorno do enderecamento, estorna a O.S.WMS
								If	lRet
									DCF->(DbGoTo(nPosDCF))
									If DCF->DCF_STSERV == '1'
										RecLock('DCF',.F.,.T.)
										DCF->(dbDelete())
										MsUnLock()
									EndIf
								EndIf
							EndIf
						Else
							lRet:= .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265QSegum� Autor � Rodrigo de A. Sartorio� Data � 04/10/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula a quantidade na Segunda Unidade de medida          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265QSegum()                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xA265QSegum()
Local cVar:=Alltrim(ReadVar())
If cVar == "M->DB_QUANT"
	If nPosQtSegum > 0
		aCols[n,nPosQtSegum] := ConvUm(SDA->DA_PRODUTO,&(ReadVar()),aCols[n,nPosQtSegum],2)
	EndIf
ElseIf cVar == "M->DB_QTSEGUM"
	aCols[n,nPosQuant] := ConvUm(SDA->DA_PRODUTO,aCols[n,nPosQuant],&(ReadVar()),1)
EndIf
Return .T.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265EstOK � Autor � Rodrigo de A. Sartorio� Data � 06/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a linha da GetDados no estorno                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265EstOk()                                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//1
User Function xA265EstOk(o)
Local lRet  := .T.,lRe5:=.F.
Local nSaldo:= 0
Local dDataFec   := MVUlmes()

If aCols[n,nPosEstorn] == "S"
	//��������������������������������������������������������������Ŀ
	//� Impede o Estorno de Enderecamentos anteriores ao Fechamento  �
	//����������������������������������������������������������������
	If dDataFec >= aCols[n, nPosData]
		Help (' ', 1, 'FECHTO')
		lRet := .F.
	EndIf
	If lRet
		//��������������������������������������������������������������Ŀ
		//� Verifica se no SD3 o D3_CF = RE5                             �
		//����������������������������������������������������������������
		SD3->(dbSetOrder(2))
		SD3->(MsSeek(xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO))
		While !Eof() .And. xFilial("SD3")+SDA->DA_DOC+SDA->DA_PRODUTO == SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD
			If SD3->D3_CF == "RE5" .And. !Empty(SD3->D3_OP) .And. SDA->DA_NUMSEQ+SDA->DA_LOTECTL == SD3->D3_NUMSEQ+SD3->D3_LOTECTL .And. SD3->D3_ESTORNO # "S"
				lRe5 := .T.
				Exit
			EndIf
			SD3->(dbSkip())	
		EndDo
		If !lRe5
			//��������������������������������������������������������������Ŀ
			//� Verifica se qtd distribuida ja foi utilizada                 �
			//����������������������������������������������������������������
			nSaldo:=SaldoSBF(M->DA_LOCAL,aCols[n,nPosLocali],M->DA_PRODUTO,aCols[n,nPosNumSer],aCols[n,nPosLotCtl],aCols[n,nPosLote])
			If nSaldo < aCols[n,nPosQuant]
				Help(" ",1,"MA265QTEST")
				lRet:=.F.
			EndIf
		EndIf
	EndIf
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTA265PERG� Autor � Rodrigo de A. Sartorio� Data � 13/09/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada da funcao PERGUNTE                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTA265PERG()
Pergunte("MTA265",.T.)
RETURN Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265MtCols� Autor �Rodrigo de A. Sartorio � Data � 28/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta array aCols com Localizacoes e qtdes. sugeridas      ���
���          � (pode gerar n linhas em br. conf. enderecos sugeridos      ���
�������������������������������������������������������������������������Ĵ��
��� Sintaxe  �A265MtCols(ExpC1,ExpC2,ExpN1,ExpN2,ExpN3,ExpN4,ExpN5,		  ���
���          �           aExpA1,ExpN6,ExpN7)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 - > Produto utilizado                                ���
���          � ExpC2 - > Almoxarifado utilizado                           ���
���          � ExpN1 - > Saldo a ser distribuido                          ���
���          � ExpN2 - > Posicao do item no array aCols                   ���
���          � ExpN3 - > Posicao da Localizacao no array aCols            ���
���          � ExpN4 - > Posicao da Qtd. 1a UM no array aCols             ���
���          � ExpN5 - > Posicao da Qtd. 2a UM no array aCols             ���
���          � ExpA1 - > Copia do array aCols em branco                   ���
���          � ExpN6 - > Posicao do alias (ALI_WT) no array aCols         ���
���          � ExpN7 - > Posicao do recno (REC_WT) no array aCols         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function A265MtCols(cProduto,cLocal,nSaldo,nPosItem,nPosLocali,nPosQuant,nPosQtSegum,aBackCols,nPosAlias,nPosRec)
Local lFirst:=.T.
Local aArray:=MADistrAut(cLocal,cProduto,nSaldo)
Local zi	:=0

For zi:=1 to Len(aArray)
	//�����������������������������������������������������������������Ŀ
	//� Utiliza linha em branco e apos isso Inclui linha no array aCols �
	//�������������������������������������������������������������������
	If !lFirst
		AADD(aCols,ACLONE(aBackCols))
		aCols[Len(aCols),nPosItem]:=Soma1(aCols[Len(aCols)-1,nPosItem])
	Else
		lFirst:=.F.
	EndIf
	aCols[Len(aCols),nPosLocali] :=aArray[zi,1]
	aCols[Len(aCols),nPosQuant]	 :=aArray[zi,2]
	aCols[Len(aCols),nPosQtSegum]:=aArray[zi,3]
	// Grava o Alias e Recno (Walk-Thru)
	aCols[Len(aCols),nPosAlias]	 :="SDB"
	aCols[Len(aCols),nPosRec]	 :=0
Next zi
Return

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Legend�Rev.   � Edson Maricate        � Data �29.07.2000 ���
��������������������������������������������������������������������������Ĵ��
���          �Demonstra a legenda das cores da mbrowse                     ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina monta uma dialog com a descricao das cores da    ���
���          �Mbrowse.                                                     ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
uSER Function XA265Legend()
BrwLegenda(cCadastro,STR0011,{	{"ENABLE" ,STR0012},;	//"Legenda"###"Saldo a Distribuir"
								{"DISABLE",STR0013}})	//"Ja Distribuido"
Return(.T.)


/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A265UltIt �Rev.   � Bruno Sobieski        � Data �29.07.2000 ���
��������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Define se deve retornar como numerico ou como caracter���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Ultimo item utilizado no SDB                                 ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina monta Retorna o ultimo item utilizado no SDB     ���
���          � para o SDA posicionado .                                    ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function xA265UltIt(cTipo, lContaDel)
Local cSeek    := xFilial("SDB")+SDA->DA_PRODUTO+SDA->DA_LOCAL+SDA->DA_NUMSEQ+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA
Local cLoteSDA := SDA->DA_LOTECTL+SDA->DA_NUMLOTE
Local lRastro  := Rastro(SDA->DA_PRODUTO)
Local aArea	   := GetArea()
Local aAreaSDB := SDB->(GetArea())
Local cCounter := StrZero(0,TamSx3('DB_ITEM')[1])
Local nCounter := 0

DEFAULT cTipo      := 'N'
DEFAULT lContaDel  := .T.

dbSelectArea("SDB")
dbSetOrder(1)
If dbSeek(cSeek)
	Do While !EOF() .And. DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA == cSeek
		If DB_TM > "500" .Or. DB_TIPO # "D"
			dbSkip()
			Loop
		EndIf
		If lRastro .And. !(cLoteSDA==DB_LOTECTL+DB_NUMLOTE)
			If !Empty(DB_LOTECTL) .And. !Empty(DB_NUMLOTE)
				dbSkip()
				Loop
			EndIf
		EndIf
		If !(DB_ATUEST $ 'S ') //-- Desconsidera Servicos do WMS
			dbSkip()
			Loop
		EndIf
		If !lContaDel
			If !Empty(DB_ESTORNO) .Or. !(DB_ATUEST $ 'S ')
				dbSkip()
				Loop
			EndIf
		EndIf
		If cTipo == "N"
			nCounter++
		Else
			cCounter := Soma1(cCounter)
		EndIf
		dbSkip()
	EndDo
EndIf

RestArea(aAreaSDB)
RestArea(aArea)
Return (IIf(cTipo == "N",nCounter,cCounter))

/*
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �A265DocTMS�Rev.   �Rodrigo de A. Sartorio � Data �15.11.2002 ���
��������������������������������������������������������������������������Ĵ��
���          �Verifica o relacionamento do documento com os arquivos do    ���
���          �SIGATMS                                                      ���
��������������������������������������������������������������������������Ĵ��
���Parametros�lEstorno - Indica se esta estornando enderecamento           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Materiais                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function xA265DocTMS(lEstorno)
Local aAreaDTC := DTC->(GetArea())
Local cSeekDUD:="",cSeekDTC:=""
Local lOk:=.T.

dbSelectArea("SDA")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

// Pesquisa o CTRC amarrado a essa NF
dbSelectArea("DTC")
dbSetOrder(2)
If dbSeek(xFilial("DTC")+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA+SDA->DA_PRODUTO)
	cSeekDUD:=xFilial("DUD")+DTC_FILDOC+DTC_DOC+DTC_SERIE+cFilAnt
	cSeekDTC:=DTC_FILDOC+DTC_DOC+DTC_SERIE
	If lEstorno
		// No estorno do enderecamento marca o DUD com flag de nao enderecado
		dbselectArea("DUD")
		dbSetOrder(1)
		If dbSeek(cSeekDUD) .And. DUD->DUD_ENDERE == "2"
			Reclock("DUD",.F.)
			Replace DUD_ENDERE With "1"
			MsUnlock()
		EndIf
	Else
		// Varre todas as NFS do CTRC verificando se todas estao enderecadas
		// Caso isso ocorra marca o DUD com flag de ja enderecado
		dbSetOrder(3)
		dbSeek(xFilial("DTC")+cSeekDTC)
		While !Eof() .And. lOk .And. DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE == xFilial("DTC")+cSeekDTC
			// Verifica se o produto utiliza controle de enderecamento
			If Localiza(DTC_CODPRO)
				If SD1->(dbSeek(xFilial("SD1")+DTC->DTC_NUMNFC+DTC->DTC_SERNFC+DTC->DTC_CLIREM+DTC->DTC_LOJREM+DTC->DTC_CODPRO))
					If (SDA->(dbSeek(xFilial("SDA")+DTC->DTC_CODPRO+SD1->D1_LOCAL+SD1->D1_NUMSEQ+DTC->DTC_NUMNFC+DTC->DTC_SERNFC+DTC->DTC_CLIREM+DTC->DTC_LOJREM+DTC->DTC_CODPRO)))
						lOk:=lOk .And. (QtdComp(SDA->DA_SALDO) == QtdComp(0))
					EndIf
				EndIf
			EndIf
			dbSelectArea("DTC")
			dbSkip()
		End
		// No enderecamento marca o DUD com flag de enderecado
		If lOk
			dbselectArea("DUD")
			dbSetOrder(1)
			If dbSeek(cSeekDUD)
				Reclock("DUD",.F.)
				Replace DUD_ENDERE With "2"
				MsUnlock()
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aAreaDTC)
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SHOWF4   � Autor � Rodrigo de A. Sartorio� Data � 29/11/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada da funcao F4LOCALIZ                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA240                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ShowF4(a,b,c)
Local cCampo:=AllTrim(Upper(ReadVar()))
Private cLoteCTL   := SDA->DA_LOTECTL
Private cNumLote   := SDA->DA_NUMLOTE
If cCampo == "M->DB_LOCALIZ" .Or. cCampo == "M->DB_NUMSERI"
	F4Localiz(,,, "A265",SDA->DA_PRODUTO,SDA->DA_LOCAL,,ReadVar())
EndIf
Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � A265ATUSA� Autor � Marcos V. Ferreira    � Data � 16/08/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza campos B2_QEMPSA / CQ_QTDISP utilizados na baixa  ���
���          � da pre-requisicao. Posicionar SDA/SDB                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A265AtuSA(nTipo)
Local nQtdLib	:= 0
Local nQtdaLib	:= 0
Local cCondicao	:= ''
Local aAreaAnt	:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSC7	:= SC7->(GetArea())
Local aAreaSCQ	:= SCQ->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())

Default nTipo := 0

//�������������������������������������������������Ŀ
//� nTipo == 1 - Distribuicao B2_QEMPSA / CQ_QTDISP	�
//� nTipo == 2 - Estorno B2_QEMPSA / CQ_QTDISP		�
//���������������������������������������������������
If SDA->DA_ORIGEM == "SD1"
	dbSelectArea("SD1")
	dbSetOrder(1)
	If	dbSeek(xFilial("SD1")+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_LOJA+SDA->DA_PRODUTO)
		nQtdaLib := SDB->DB_QUANT
		dbSelectAreA("SC7")
		dbSetOrder(1)
		If dbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
			dbSelectArea("SCQ")
			dbSetOrder(2)
			If !Empty(SC7->C7_NUMSC) .And. !Empty(SC7->C7_ITEMSC) .And. MsSeek(xFilial("SCQ")+SC7->C7_NUMSC+SC7->C7_ITEMSC)
				cCondicao := "CQ_FILIAL+CQ_NUMSC+CQ_ITSC==xFilial('SCQ')+SC7->C7_NUMSC+SC7->C7_ITEMSC"
				While !Eof() .And. &(cCondicao) .And. nQtdaLib > 0
					If Empty(CQ_NUMREQ)
						RecLock("SCQ",.F.)
						If nTipo == 1
							nQtdLib := Min(SCQ->CQ_QUANT-SCQ->CQ_QTDISP,nQtdALib)
						ElseIf nTipo == 2
							nQtdLib := Min(SCQ->CQ_QTDISP,nQtdALib)
						EndIf
						nQtdALib-= nQtdLib
						If nTipo == 1
							SCQ->CQ_QTDISP += nQtdLib
						ElseIf nTipo == 2
							SCQ->CQ_QTDISP -= nQtdLib
						EndIf
						SCQ->CQ_STATUSC:= ""
						dbSelectArea("SB2")
						dbSetOrder(1)
						MsSeek(xFilial("SB2")+SCQ->CQ_PRODUTO+SCQ->CQ_LOCAL)
						Reclock("SB2",.F.)
						If nTipo == 1
							SB2->B2_QEMPSA += nQtdLib
						ElseIf nTipo == 2
							SB2->B2_QEMPSA -= nQtdLib
						EndIf
						MsUnlock()
					EndIf
					dbSelectArea("SCQ")
					dbSkip()
				EndDo
			EndIf
		EndIf
	EndIf
EndIf
RestArea(aAreaSD1)
RestArea(aAreaSC7)
RestArea(aAreaSCQ)
RestArea(aAreaSB2)
RestArea(aAreaAnt)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Fabio Alves Silva     � Data �04/10/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �    1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()

Private aRotina	:={	{STR0001,"AxPesqui"  , 0 , 1,0,.F.},;	//"Pesquisar"
					{STR0002,"U_XA265Visual", 0 , 2,0,nil},;	//"Visualizar"
					{STR0003,"U_XA265Inclui", 0 , 4,0,nil},;	//"EnDerecar"
					{STR0004,"U_XA265Exclui", 0 , 6,0,nil},;	//"Estornar"
					{STR0011,"U_XA265Legend", 0 , 1,0,.F.} }	//"Legenda"

If	ExistBlock ("MTA265MNU")
	ExecBlock ("MTA265MNU",.F.,.F.)
EndIf

Return (aRotina)

/*
�����������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������Ŀ��
���Fun��o    �A265ETDOk � Autor � Moises Nunes                      � Data � 04/01/11 ���
�������������������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a execucao do estorno, retornando para a tela de dados          ���
�������������������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265ETDOk()                                                            ���
�������������������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                                ���
��������������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������
*/
User Function xA265ETDOk()
//�������������������������������������������������������������������������������������Ŀ
//� M265ESTOK - PE para validar a execucao do estorno, retornando para a tela de dados  �
//���������������������������������������������������������������������������������������  
Local lRet := .T.
If (ExistBlock("M265ESTOK"))
	lRet:=ExecBlock("M265ESTOK",.F.,.F.)
	If ValType(lRet)<>"L"
		lRet:=.T.
	EndIf
EndIf 
Return lRet

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �A265Del� Autor �  Nilton MK 				  Data � 01/06/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida a pemiss�o de uso da tecla del					  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � A265DEL()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATA265                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function xA265DEL()
Local lRet	:=.F.  
Local nPosRecn := aScan(aHeader, { |x| Alltrim(x[2]) == 'DB_REC_WT' })
Local nPosFoc  := oGetd:obrowse:nAt
Static nCnt    := 0  

nCnt++	
If  nPosFoc > 0 .and. nPosRecn > 0 .and. (nCnt%2>0)   // prote��o para executar apenas uma unica vez , efeito da msgetdados
	if acols[nPosFoc][nPosRecn] > 0
       AVISO('ATENCAO!','STR0042',{"OK"})		
	   lRet:=.F. 
	Else
	   lRet:=.T.
	EndIf
EndIf	 
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} A265GerNS(aHead,nQtdOri,nSaldo)
Gera��o de N�mero de S�rie
@author guilherme.pimentel

@param aHead - Cabe�alho da tabela
@param nQtdOri - Quantidade Original
@param nSaldo - Saldo
@return lRet

@since 09/01/2014
@version 1.0
/*/
//-------------------------------------------------------------------

User Function xA265GerNS(aHeadSDB,nQtdOri,nSaldo,xColsSDB,oGetSD1)
Local nX := 0
Local nY := 0
Local nQtde := 0
Local nLinha := 0
Local cFormula := ''
Local cProduto := SDA->DA_PRODUTO
Local lRet := .T.

If Valtype(xColsSDB) == "O"
	aColsSDB := xColsSDB:aCols
	nLinha := xColsSDB:nAt
	cProduto := oGetSD1:aCols[oGetSD1:nAt][GDFieldPos("D1_COD",oGetSD1:aHeader)]
ElseIf Valtype(xColsSDB) == "A"
	aColsSDB := xColsSDB
Else
	aColsSDB := aCols
EndIf

//Define Indice para uso na obten��o do n�mero de s�rie
dbSelectArea("SBF")
dbSetOrder(4)

cFormula := u_xA265SetNS(u_xA265GetFor(cProduto),aHeadSDB,aColsSDB)

If !Empty(cFormula)
	//Colocado caso haja a inser��o de algum registro manualmente antes de executar a distribui��o automatica
	For nX := 1 to Len(aColsSDB)
		If !aColsSDB[nX,Len(aHeadSDB)+1] .Or. IIF(GDFieldPos("DB_ESTORNO",aHeadSDB)>0,!Empty(aColsSDB[nX,GDFieldPos("DB_ESTORNO",aHeadSDB)]),.F.) 
			nQtde += aColsSDB[nX,GDFieldPos("DB_QUANT",aHeadSDB)]
		EndIf
	Next nX
	
	nSaldo := nQtdOri - nQtde   
	
	//Coloca o valor na linha inicial caso esteja vazia
	If aColsSDB[Len(aColsSDB),GDFieldPos("DB_QUANT",aHeadSDB)] == 0 .And. Empty(aColsSDB[Len(aColsSDB),GDFieldPos("DB_NUMSERI",aHeadSDB)])
		
		aColsSDB[Len(aColsSDB),GDFieldPos("DB_QUANT",aHeadSDB)] := 1
		aColsSDB[Len(aColsSDB),GDFieldPos("DB_NUMSERI",aHeadSDB)] := cFormula
		nSaldo := nSaldo - 1
		cFormula := u_xA265SetNS(cFormula,aHeadSDB,aColsSDB)
	EndIf
	
	For nX := (Len(aColsSDB)+1) to (nSaldo + Len(aColsSDB)) 
		AAdd(aColsSDB,Array(Len(aHeadSDB) + 1))
		
		For nY := 1 to Len(aHeadSDB)
			If IsHeadAlias(aHeadSDB[nY][2])
				aColsSDB[nX,nY] := 'SDB'	
			ElseIf IsHeadRec(aHeadSDB[nY][2])
				aColsSDB[nX,nY] := 0
			Else
				aColsSDB[nX,nY] := CriaVar(aHeadSDB[nY, 2],.F.)
			EndIf
		Next nY
		
		aColsSDB[nX,1] := StrZero(Len(aColsSDB),Len(aColsSDB[Len(aColsSDB),1]))
		aColsSDB[nX,GDFieldPos("DB_QUANT",aHeadSDB)] := 1
		If GDFieldPos("DB_DATA",aHeadSDB) > 0
			aColsSDB[nX,GDFieldPos("DB_DATA",aHeadSDB)] := dDataBase
		EndIf
		aColsSDB[nX,GDFieldPos("DB_NUMSERI",aHeadSDB)] := cFormula
		aColsSDB[nX,(Len(aHeadSDB) + 1)] := .F.
		
		cFormula := u_xA265SetNS(cFormula,aHeadSDB,aColsSDB)
		
		If Valtype(xColsSDB) == "O"
			xColsSDB:nAt := nX
			A103CHANGE(oGetSD1, xColsSDB, 'SDB')
		EndIf
		
	Next nX
	
	If Valtype(xColsSDB) == "O"
		xColsSDB:nAt := nLinha
	Else
		aCols := aColsSDB
	EndIf
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} A265GetFor()
Obten��o da f�rmula a ser utilizada	
@author guilherme.pimentel

@since 09/01/2014
@version 1.0
@return cValor
/*/
//-------------------------------------------------------------------

User Function xA265GetFor(cProduto)
Local oDlg		:= Nil
Local oFont1	:= Nil      
Local lRet		:= .F.
Local cValor := ''

If SB5->(DbSeek(xFilial('SB5')+cProduto))

	cValor := Formula(SB5->B5_FORSER)
Else
	cValor := Replicate(" ", (TamSx3('BF_NUMSERI')[1]))
EndIF

Define Font oFont1 Name "Consolas" Size 07,17
Define MsDialog oDlg Title 'CONSOLAS' From 0,0 To 100,400 Of oDlg Pixel 
@ 06,06 To 35,195 LABEL  OF oDlg PIXEL

@ 09,40 SAY 'CONSOLAS' OF oDlg PIXEL
@ 16,40 MSGet oCanal  Var cValor Font oFont1 Size 100 ,10 Valid !Empty(Trim(cValor)) Of oDlg PIXEL  

ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||  oDlg:End() },{|| cValor := '', oDlg:End()})
	

Return AllTrim(cValor)

//-------------------------------------------------------------------
/*/{Protheus.doc} A265SetNS(cValor,aHeadSDB)
Obten��o do pr�ximo n�mero de s�rie v�lido	
@author guilherme.pimentel

@param cValor - Valor Base
@param aHeadSDB - Cabe�alho da tabela
@return cValor

@since 09/01/2014
@version 1.0
/*/
//-----------------------------------------------x--------------------

user Function xA265SetNS(cValor,aHeadSDB,aColsSDB)

If !Empty(cValor)
	cValor := PadR(AllTrim(cValor),TamSX3( 'BF_NUMSERI' )[1],' ')
																																	
	While SBF->(DbSeek(xFilial('SBF')+SDA->DA_PRODUTO+cValor)) .Or. (ASCAN(aColsSDB,{|x| x[GDFieldPos("DB_NUMSERI",aHeadSDB)] == cValor .And. IIF(GDFieldPos("DB_ESTORNO",aHeadSDB)>0,Empty(x[GDFieldPos("DB_ESTORNO")]),.T.)  }) > 0) 
		cValor := PadR(Soma1(AllTrim(cValor)),TamSX3( 'BF_NUMSERI' )[1],' ')
	End
EndIf
	
Return cValor
