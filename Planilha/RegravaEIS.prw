#INCLUDE  "FIVEWIN.CH"
#include  "topconn.ch"
#include  "tbiconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RegravaEIS� Autor �                       � Data � 10/08/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � cSku   - Codigo de Sku                                     ���
���          � cSimil - Codigo de Simil                                   ���
���          � cEis   - Codigo do Eis                                     ���
���          � lProcBloc - .T. quando vou reprocessar o B1 inteiro        ���
���          �                                                            ���
���          � Obs. Para utilizar esta funcao devo estar possicionado     ���
���          �      no SB1 que tera o numero de SIMIL ou EIS trocado.     ���
���          �                                                            ���
���          � Documentacao no M000001                                    ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RegravaEIS(lProcBloc)

Private nPosSimil := 0
Private aSZ9      := {}
Private cChaveAnt := ""
Private aAreaSb1  := GetArea()

Private cSimilAnt := ""
Private cEisAnt   := ""

Private cSku    := SB1->B1_COD
Private cSimil  := SB1->B1_X_SIMIL
Private cEis    := SB1->(B1_X_EIS01+B1_X_EIS02+B1_X_EIS03+B1_X_EIS04+B1_X_EIS05+B1_X_EIS06+B1_X_EIS07+B1_X_EIS08+B1_X_EIS09+B1_X_EIS10)

//���������������������������������������������������������������Ŀ
//� Ajusta SZA              		     			   		            �
//�����������������������������������������������������������������
If SB1->B1_X_CTSTD = 0
	if lProcBloc
		GeraLog("Problema na SKU - "+cSku+" Custo padrao do Produto nao foi informado. Mas Eis foi Alterado")
	Else
		//Aviso("ATENCAO","Problema na SKU - "+cSku+" Custo padrao do Produto nao foi informado. Mas troca de Eis foi confirmada.",{"&Ok"})
	Endif
Endif


//���������������������������������������������������������������Ŀ
//� Ajusta SZA              		     			   		            �
//�����������������������������������������������������������������
DbSelectArea("SZ2")
DbSetorder(1)
DbGotop()
If !dbSeek(xFilial("SZ2")+cSimil)
	if lProcBloc
		GeraLog("Problema na SKU - "+cSku+" Codigo Simil "+cSimil+" inexistente no SZ2-Grupo de Similaridade.")
		RestArea(aAreaSb1)
		RETURN(.F.)
	Else
		//Aviso("ATENCAO","Problema na SKU - "+cSku+" Codigo Simil "+cSimil+" inexistente no SZ2-Grupo de Similaridade.  Mas troca de Eis foi confirmada.",{"&Ok"})
	Endif
Endif


DbSelectArea("Z10")
DbSetorder(1)
DbGotop()
If !dbSeek(xFilial("Z10")+cEis)
	if lProcBloc
		GeraLog("Problema na SKU - "+cSku+" Codigo Eis "+cEis+" nao Cadastrado.")
		RestArea(aAreaSb1)
		RETURN(.F.)
	Else
		//Aviso("ATENCAO","Problema na SKU - "+cSku+" Codigo Eis "+cEis+" nao Cadastrado.  Mas troca de Eis foi confirmada.",{"&Ok"})
	Endif
Endif


DbSelectArea("SZA")
DbSetOrder(1)
DbGotop()
DbSeek(xFilial("SZA")+cSku)

cSimilAnt := SZA->ZA_SIMIL
cEisAnt   := SZA->(ZA_EIS01+ZA_EIS02+ZA_EIS03+ZA_EIS04+ZA_EIS05+ZA_EIS06+ZA_EIS07+ZA_EIS08+ZA_EIS09+ZA_EIS10)


DbSelectArea("SZA")
DbSetOrder(1)
DbGotop()
If DbSeek(xFilial("SZA")+cSku)
	
	While !SZA->(EOF()) .and. xFilial("SZA")+cSku = ZA_FILIAL + ZA_SKU
		
		
		Reclock("SZA",.f.)
		//SZA->ZA_FILIAL := xFilial("SZA")
		//SZA->ZA_ANO    := STR(YEAR(dFimProc),4)
		//SZA->ZA_MES    := STRZERO(MONTH(dFimProc),2)
		//SZA->ZA_SKU    := aSku[nPosSku][1]                  // Codigo da Sku
		SZA->ZA_SIMIL    := SB1->B1_X_SIMIL                  // Codigo Simil
		SZA->ZA_EIS01    := SB1->B1_X_EIS01                  // Codigo Eis
		SZA->ZA_EIS02    := SB1->B1_X_EIS02
		SZA->ZA_EIS03    := SB1->B1_X_EIS03
		SZA->ZA_EIS04    := SB1->B1_X_EIS04
		SZA->ZA_EIS05    := SB1->B1_X_EIS05
		SZA->ZA_EIS06    := SB1->B1_X_EIS06
		SZA->ZA_EIS07    := SB1->B1_X_EIS07
		SZA->ZA_EIS08    := SB1->B1_X_EIS08
		SZA->ZA_EIS09    := SB1->B1_X_EIS09
		SZA->ZA_EIS10    := SB1->B1_X_EIS10
		
		MsUnlock()
		
		SZA->(DBSKIP())
		
	Enddo
	
	//���������������������������������������������������������������Ŀ
	//� Reprocessando novo Eis    	     			   		            �
	//�����������������������������������������������������������������
	aSZ9 := {}
	//��������������������������������������������������������������Ŀ
	//�Gera o Vetor aSZ9 agora com o acumulado por Eis               �
	//�Este vetor e por ano+mes+simil+eis                            �
	//����������������������������������������������������������������
	GeraSz9( cSimil , cEis)
	//��������������������������������������������������������������Ŀ
	//�Atualiza SZ9 com dados do Eis contido no Vetor                �
	//����������������������������������������������������������������
	AtualSZ9(aSZ9, cSimil , cEis)
	
Endif




//
// Analisa se ocorreu realmente alteracao no Simil+Eis comparando o atual com anterior.
//
If alltrim(cEisAnt)<>"" // Este evita que seja processado durante a Inclusao por exemplo.
	
	If cSimil+cEis <> cSimilAnt+cEisAnt
		
		// O parametro abaixo e tratado pelos programas:
		// a) REGRAVAEIS.PRW  - Trava  a Geracao da Planilha "MESTC02"
		//                      Devido altera o Eis ou adiciona um novo EIS        PutMv('MV_LIBPGMM',.T.)
		// b) MESTC01.PRW     - Libera a Geracao da Planilha "MESTC02"               
		//                      Apos Reprocessamento ou Fechamento da Planilha     PutMv('MV_LIBPGMM',.F.)
		// c) MESTC02.PRW     - Analiza se esta permitido a Geracao da Planilha    GETMV('MV_LIBPGMM)
		//
		//__cUserId  Vari�vel Publica com o ID do Usu�rio Logado
		cNome := Alltrim(UsrRetName(__cUserId))

		PutMv('MV_LIBPGMM',"T-"+cNome)
		//  O usuario e avisado logo no comeco desta funcao caso persista em efetuar a operacao o
		//  acesso a manutencao da planilha sera travado ate proximo fechamento.
		//  Trava acesso a manutencao da Planilha ate proximo fechamento.
		
		
		DbSelectArea("SB1")
		DbOrderNickname("B1SIMIL")
		DbGotop()
		If DbSeek(xFilial("SB1")+cSimilAnt+cEisAnt)
			
			//���������������������������������������������������������������Ŀ
			//� Reprocessa Eis Anterior     	     			   		            �
			//�����������������������������������������������������������������
			aSZ9 := {}
			//��������������������������������������������������������������Ŀ
			//�Gera o Vetor aSZ9 agora com o acumulado por Eis               �
			//�Este vetor e por ano+mes+simil+eis                            �
			//����������������������������������������������������������������
			GeraSz9( cSimilAnt , cEisAnt)
			
			//��������������������������������������������������������������������������Ŀ
			//�Regrava o SZ9                                                             �
			//����������������������������������������������������������������������������
			AtualSZ9(aSZ9 , cSimilAnt , cEisAnt )
			
			
		Else  // Neste caso nao existe mais nenhum simil+eis no SB1 desta forma os Historicos
			// restantes para este EIS/SIMIL seram eliminados.
			
			//
			// DELETE SZA
			//
			DbSelectArea("SZA")
			DbSetorder(3)
			DbGotop()
			If DbSeek(xFilial("SZA")+ cSimilAnt + cEisAnt )
				While !SZA->(EOF()) .and. xFilial("SZA")+cSimilAnt+cEisAnt = ;
					SZA->(ZA_FILIAL+ZA_SIMIL+ZA_EIS01+ZA_EIS02+ZA_EIS03+ZA_EIS04+ZA_EIS05+ZA_EIS06+ZA_EIS07+ZA_EIS08+ZA_EIS09+ZA_EIS10)
					RECLOCK("SZA",.F.)
					DbDelete()
					MsUnlock()
					SZA->(DBSKIP())
				Enddo
			Endif
			
			
			//
			// DELETE SZ9 - Simil+Eis  Atual
			//
			DbSelectArea("SZ9")
			DbSetOrder(1)
			DbGotop()
			If Dbseek(xFilial("SZ9") + cSimilAnt + cEisAnt )
				While !SZ9->(EOF()) .and. xFilial("SZ9")+ cSimilAnt + cEisAnt = ;
					SZ9->(Z9_FILIAL+Z9_SIMIL+Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10)
					RECLOCK("SZ9",.F.)
					DbDelete()
					MsUnlock()
					SZ9->(DBSKIP())
				Enddo
			Endif
			
			
		Endif
		
	Endif
	
Endif

RestArea(aAreaSb1)

Return(.T.)





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraSz9  � Autor �                       � Data � 10/08/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera Vetor contendo informacoes para o SZ9                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function GeraSz9(cCdSimil , cCodiEis)
//��������������������������������������������������������������������������Ŀ
//�Adicionando itens a Matriz 3 -  Nome aSimil -  Busca  aScan[Simil+Eis]    �
//����������������������������������������������������������������������������

DbSelectArea("SZA")
DbSetorder(3)
DbGotop()
If DbSeek(xFilial("SZA")+ cCdSimil+cCodiEis)
	
	//��������������������������������������������������������������������������Ŀ
	//�Busca no SZA por SIMIL + EIS  AGLOTINANDO NOVAMENTE POR SIMILO E EIS      �
	//�com o objetivo de somar todos os consumos no periodo e apanhes            �
	//�e importante relembar que para este caso as caracteristicas do eis        �
	//�continuam sendo as mesmas informadas no ultimo fechamento com base no     |
	//�SB1.                                                                      |
	//����������������������������������������������������������������������������
	
	While !SZA->(EOF()) .and. xFilial("SZA")+cCdSimil+cCodiEis = ;
		SZA->ZA_FILIAL	+ SZA->ZA_SIMIL + SZA->(ZA_EIS01+ZA_EIS02+ZA_EIS03+ZA_EIS04+ZA_EIS05+ZA_EIS06+ZA_EIS07+ZA_EIS08+ZA_EIS09+ZA_EIS10)
		
		
		nPosSimil := aScan( aSZ9 , {|x| x[1]+x[2]+x[3]+x[4]+x[5] == SZA->(ZA_FILIAL+ZA_ANO+ZA_MES+ZA_SIMIL+ZA_EIS01+ZA_EIS02+ZA_EIS03+ZA_EIS04+ZA_EIS05+ZA_EIS06+ZA_EIS07+ZA_EIS08+ZA_EIS09+ZA_EIS10) })
		
		if nPosSimil = 0
			
			AADD(aSZ9, { xFilial("SZ9"),;   //[01]
			SZA->ZA_ANO  ,;   //[02]
			SZA->ZA_MES  ,;   //[03]
			SZA->ZA_SIMIL,;   //[04]
			SZA->ZA_EIS01+SZA->ZA_EIS02+SZA->ZA_EIS03+SZA->ZA_EIS04+SZA->ZA_EIS05+SZA->ZA_EIS06+SZA->ZA_EIS07+SZA->ZA_EIS08+SZA->ZA_EIS09+SZA->ZA_EIS10,;
			SZA->ZA_EIS01,;   //[06]
			SZA->ZA_EIS02,;   //[07]
			SZA->ZA_EIS03,;   //[08]
			SZA->ZA_EIS04,;   //[09]
			SZA->ZA_EIS05,;   //[10]
			SZA->ZA_EIS06,;   //[11]
			SZA->ZA_EIS07,;   //[12]
			SZA->ZA_EIS08,;   //[13]
			SZA->ZA_EIS09,;   //[14]
			SZA->ZA_EIS10,;   //[15]
			SZA->ZA_QTDSAI,;  //[16]   Qtd Vendida
			SZA->ZA_QTDAPA })  //[17]   Qtd de Apanhes
			
			
		Else
			
			aSZ9[nPosSimil][16] += SZA->ZA_QTDSAI  //[27]   Qtd Vendida
			aSZ9[nPosSimil][17] += SZA->ZA_QTDAPA  //[27]   Qtd de Apanhes
			
		Endif
		
		SZA->(DBSKIP())
		
	Enddo
	
Endif

//
// Se nao Existir SZA nao devera existir SZ9
//
If Len(aSZ9) = 0
	
	//
	// DELETE SZ9 - Simil+Eis  Atual
	//
	DbSelectArea("SZ9")
	DbSetOrder(1)
	DbGotop()
	If Dbseek(xFilial("SZ9") + cCdSimil+cCodiEis )
		While !SZ9->(EOF()) .and. xFilial("SZ9")+ cCdSimil+cCodiEis  = ;
			SZ9->(Z9_FILIAL+Z9_SIMIL+Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10)
			RECLOCK("SZ9",.F.)
			DbDelete()
			MsUnlock()
			SZ9->(DBSKIP())
		Enddo
	Endif
	
Endif


Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AtualSZ9 � Autor �                       � Data � 10/08/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza o SZ9 em funcao das mudancas de eis no SZA        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AtualSZ9(aSZ9,cSimil,cEis)
Local _cRecno  :=""
Local nPosSimil:=0
Local aRecnoSZ9:=0

DbSelectArea("SZ9")
For nPosSimil:= 1 to len(aSz9)
	
	cChaveSZ9:=aSz9[nPosSimil][01]+aSz9[nPosSimil][02]+aSz9[nPosSimil][03]+aSz9[nPosSimil][04]+aSz9[nPosSimil][05]
	
	DbSelectArea("SZ9")
	DbSetOrder(2)
	DbGotop()	// Filial + Ano + Mes + Simil + Eis
	If Dbseek(cChaveSZ9)
		Reclock("SZ9",.F.)
	Else
		Reclock("SZ9",.T.)
		SZ9->Z9_FILIAL		:= aSz9[nPosSimil][01]
		SZ9->Z9_ANO		   := aSz9[nPosSimil][02]
		SZ9->Z9_MES			:= aSz9[nPosSimil][03]
		SZ9->Z9_SIMIL		:= aSz9[nPosSimil][04]
		SZ9->Z9_EIS01		:= aSz9[nPosSimil][06]
		SZ9->Z9_EIS02		:= aSz9[nPosSimil][07]
		SZ9->Z9_EIS03		:= aSz9[nPosSimil][08]
		SZ9->Z9_EIS04		:= aSz9[nPosSimil][09]
		SZ9->Z9_EIS05		:= aSz9[nPosSimil][10]
		SZ9->Z9_EIS06		:= aSz9[nPosSimil][11]
		SZ9->Z9_EIS07		:= aSz9[nPosSimil][12]
		SZ9->Z9_EIS08		:= aSz9[nPosSimil][13]
		SZ9->Z9_EIS09		:= aSz9[nPosSimil][14]
		SZ9->Z9_EIS10		:= aSz9[nPosSimil][15]
		
		SZ9->Z9_LEAD		:= SB1->B1_X_LT
		SZ9->Z9_ABC			:= SB1->B1_X_ABC
		SZ9->Z9_PQR			:= SB1->B1_X_PQR
		SZ9->Z9_NEOIL		:= SB1->B1_X_NEOIL
		SZ9->Z9_123			:= SB1->B1_X_123
		SZ9->Z9_XYZ			:= SB1->B1_X_XYZ
		SZ9->Z9_LMN			:= SB1->B1_X_LMN
		SZ9->Z9_GIROQ		:= SB1->B1_X_GIROQ
		SZ9->Z9_TMEA		:= SB1->B1_X_TMEA
		SZ9->Z9_DESVP		:= SB1->B1_X_DESVP
		SZ9->Z9_VLRCM		:= SB1->B1_X_CTSTD
	Endif
	
	SZ9->Z9_QTDSAI		:= aSz9[nPosSimil][16]
	SZ9->Z9_QTDAPA		:= aSz9[nPosSimil][17]
	
	_cRecno:=_cRecno+alltrim(str(SZ9->(RECNO())))+","
	
	MsUnLock()
	
Next

//
// DELETE SZ9 - Somente registros que nao foram alterados
//
DbSelectArea("SZ9")
DbSetOrder(1)
DbGotop()
If Dbseek(xFilial("SZ9") + cSimil + cEis )
	While !SZ9->(EOF()) .and. xFilial("SZ9")+ cSimil + cEis = ;
		SZ9->(Z9_FILIAL+Z9_SIMIL+Z9_EIS01+Z9_EIS02+Z9_EIS03+Z9_EIS04+Z9_EIS05+Z9_EIS06+Z9_EIS07+Z9_EIS08+Z9_EIS09+Z9_EIS10)
		
		//
		// Elimina todos os registros que nao sofreram alteracao
		//
		If !(alltrim(str(SZ9->(RECNO())))  $  _cRecno)
			
			RECLOCK("SZ9",.F.)
			DbDelete()
			MsUnlock()
			
		Endif
		
		SZ9->(DBSKIP())
	Enddo
	
Endif


Return




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraLog  � Autor � Edelcio Cano          � Data � 10/08/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que efetuara a gravacao do arquivo de LOG           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Multi-Tek                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function GeraLog(_cString1)

AADD(_aLog,_cString1)

Return

