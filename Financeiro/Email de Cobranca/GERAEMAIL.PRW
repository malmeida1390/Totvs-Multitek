#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"   
#INCLUDE "TBICONN.CH"           

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÀÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GERAEMIAL∫Autor≥ Marco Abramo  		 ∫ Data ≥  08/08/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕ ÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±               
±±∫Descricao ≥ SeleÁ„o de Titulos em Atraso para compor e-mails de        ∫±±
±±∫          ≥ cobranÁa                                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico Demarest & Almeida                              ∫±±
±±∫          ≥ Projeto FS08203722                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

//U_GERAEMAIL(.t.,'01','01') (uso no lancamento padrao para teste)
//U_GERAEMAIL(.f.,'01','01') (uso no WORKFLOW)
                   
User Function GERAEMAIL(_lManual,_cEmpJob,_cFilJob)
Local cAliasQry 	:= ""
Local cCliente		:= ""          
Local cContato		:= ""	
Local cNome1		:= ""
Local cNome2		:= ""

Local cEmail1		:= ""	
Local cEmail2		:= ""	
Local dData			:= ctod("  /  /  ")
Local aTitulos2		:= {}
Local aTitulos5		:= {}
Local aTitulos15	:= {}
Local cLinha 		:= ""  
Local dDataAux		:= ctod("  /  /  ")
Local dDataAux2		:= ctod("  /  /  ")
Local dData2Dias	:= ctod("  /  /  ")
Local dData5Dias	:= ctod("  /  /  ")
Local dData15Dias	:= ctod("  /  /  ")   
Local nI			:= 0
Local cDirErrMail 	:= "\System\"
Local cArqErrMail 	:= "ErroEmail"
Local lOk         	:= .F.     
Local lAutOk 		:= .T.
local nDias2		:= 0
local nDias5		:= 0
local nDias15		:= 0
Local lSmtpAuth
Local nTimeOut  
                           
Local cFatura := ""

Local lManual := _lManual
Local cEmpJob := _cEmpJob
Local cFilJob := _cFilJob

Local  cQuery := ""
		  
cQuery := " SELECT DISTINCT " 
cQuery += " E1_CLIENTE 	AS COD_CLIENTE,  "
cQuery += " A1_NOME 	AS NOME_CLIENTE, " 
cQuery += " A1_EMAIL 	AS NOME_CLIENTE, " 
cQuery += " E1_PREFIXO 	AS PREFIXO, "
cQuery += " E1_NUM 		AS FATURA, " 
cQuery += " E1_PARCELA 	AS PARCELA, "
cQuery += " E1_TIPO 	AS TIPO, "
cQuery += " E1_EMISSAO 	AS EMISSAO, "
cQuery += " E1_VENCREA 	AS VCTO_REAL, "
cQuery += " E1_VALOR 	AS VAL_BRUTO, "
cQuery += " E1_IRRF 	AS IRRF, " 
cQuery += " E1_PIS 		AS PIS,  "
cQuery += " E1_COFINS 	AS COFINS," 
cQuery += " E1_CSLL 	AS CSLL, " 
cQuery += " E1_SALDO 	AS SALDO, " 
cQuery += " E1_NENVIO 	AS NUMERO_ENVIO " 

cQuery += "FROM "                    
cQuery += RetSqlName("SE1")+" SE1, "
cQuery += RetSqlName("SA1")+" SA1 "
		
cQuery += " WHERE "	 
cQuery += " E1_FILIAL 	= '"+xFilial("SE1")+"' AND "
cQuery += " E1_STATUS 	= 'A' AND "
cQuery += " E1_SALDO 	> 0   AND "
cQuery += " E1_NENVIO 	< 3   AND "

cQuery += " E1_VENCREA 	BETWEEN  '"+DTOS(DataValida(DDATABASE - nDias15 - 50))+"' AND '"+DTOS(DDATABASE)+"' AND " 
cQuery += " SE1.D_E_L_E_T_<>'*' AND "
cQuery += " SA1.D_E_L_E_T_<>'*' "
     	   					
cQuery += " ORDER BY "	
cQuery += " E1_CLIENTE,E1_LOJA "

memowrite("\query.txt", cQuery)


cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
                                         
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop()) 
	
           
	dData2Dias := DDATABASE + nDias2 
	dData5Dias := DiaUtil(DDATABASE, - nDias5) 

	Do While (cAliasQry)->(!Eof())

		//----------- Quebra de Contato ou Cliente-----------------------------------//
                                                
		cContato 		:= (cAliasQry)->COD_CONTATO
		cCliente 		:= (cAliasQry)->COD_CLIENTE  

		Do While cCliente == (cAliasQry)->COD_CLIENTE .and. ;
		         cContato == (cAliasQry)->COD_CONTATO			
   
			cNome1	:= (cAliasQry)->NOME_CONTATO
			cEmail1	:= (cAliasQry)->EMAIL_CONTATO

			cNome2	:= (cAliasQry)->NOME_CONT2
			cEmail2	:= (cAliasQry)->EMAIL_CTO2
			
			If cFatura == (cAliasQry)->FATURA
				(cAliasQry)->(DbSkip())
				Loop
			Endif	
			     
            cFatura := (cAliasQry)->FATURA

			// Melhora desempenho evitando recalculo do dia util se a data do
			// segundo envio ainda for a mesma do registro anterior

			If !Empty((cAliasQry)->SEGUNDO_ENVIO) .and. ;
			 		 ((cAliasQry)->SEGUNDO_ENVIO <> dDataAux2)
				dData15Dias := DiaUtil((cAliasQry)->SEGUNDO_ENVIO, + nDias15) 
			Endif	
              
              
			//Titulos a vencer com  2 Dias antes do vencimento  
			If ((cAliasQry)->NUMERO_ENVIO 	< 1)  .and. ;
			   ((cAliasQry)->VCTO_REAL 		= dData2Dias) 
			    
				aadd(aTitulos2,{(cAliasQry)->FATURA 		,;
								(cAliasQry)->EMISSAO	 	,;
								(cAliasQry)->VCTO_REAL	 	,;
								(cAliasQry)->VAL_BRUTO		,;
								(cAliasQry)->IRRF			,;
								(cAliasQry)->PIS 			,;
								(cAliasQry)->COFINS			,;
								(cAliasQry)->CSLL 			,;
								(cAliasQry)->SALDO			,;
								(cAliasQry)->PREFIXO		,;
								(cAliasQry)->PARCELA		,;
								(cAliasQry)->TIPO			 ,;
								AllTrim((cAliasQry)->NOME_CLIENTE);
							 	})
                           
			// Titulos com 5 dias uteis apos o vencimento
			ElseIf ((cAliasQry)->NUMERO_ENVIO 	< 2)  .and. ;
                    ; //((cAliasQry)->VCTO_REAL	<= dData5Dias) 
				   (dDATABASE >= DiaUtil((cAliasQry)->VCTO_REAL, nDias5) )

				aadd(aTitulos5,{(cAliasQry)->FATURA 		,;
								(cAliasQry)->EMISSAO	 	,;
								(cAliasQry)->VCTO_REAL	 	,;
								(cAliasQry)->VAL_BRUTO		,;
								(cAliasQry)->IRRF			,;
								(cAliasQry)->PIS 			,;
								(cAliasQry)->COFINS			,;
								(cAliasQry)->CSLL 			,;
								(cAliasQry)->SALDO			,;		
								(cAliasQry)->PREFIXO		,;
								(cAliasQry)->PARCELA		,;
								(cAliasQry)->TIPO			 ,;
								AllTrim((cAliasQry)->NOME_CLIENTE);
							 	})

    
			// Titulos vencidos apos o 15 dias do segundo aviso 
			ElseIf !Empty((cAliasQry)->SEGUNDO_ENVIO) .and. ;
		   				dDATABASE   >= dData15Dias  //  ((cAliasQry)->VCTO_REAL < dData15Dias ) 
		       
				aadd(aTitulos15,{(cAliasQry)->FATURA 		,;
								(cAliasQry)->EMISSAO	 	,;
								(cAliasQry)->VCTO_REAL	 	,;
								(cAliasQry)->VAL_BRUTO		,;
								(cAliasQry)->IRRF			,;
								(cAliasQry)->PIS 			,;
								(cAliasQry)->COFINS			,;
								(cAliasQry)->CSLL 			,;
								(cAliasQry)->SALDO         ,;
								(cAliasQry)->PREFIXO		,;
								(cAliasQry)->PARCELA		,;
								(cAliasQry)->TIPO			 ,;
								AllTrim((cAliasQry)->NOME_CLIENTE);
								})
								
			Endif
				
			dDataAux 	:= (cAliasQry)->VCTO_REAL 
			dDataAux2 	:= (cAliasQry)->SEGUNDO_ENVIO 

			(cAliasQry)->(DbSkip())
		EndDo  
			
			     
        ////////////////////////////////////////////////////////////////////////////////////
		//Envia email para os contatos
        //Estao separados em 3 vetores
		//  aTitulos2 := {}   apos envio o envio SE1->E1_NENVIO := 1   			
    	//	aTitulos5 := {}   apos envio o envio SE1->E1_NENVIO := 2
		//  aTitulos15:= {}	  apos envio o envio SE1->E1_NENVIO := 3
        ////////////////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////////////////
		//Titulos a vencer com  2 Dias antes do vencimento  
        ////////////////////////////////////////////////////////////////////////////////////
		If len(aTitulos2) > 0 
			//Atualiza flags na SE1 caso tenha conseguido enviar email
			If MENVMAIL(cNome1,cEmail1,cNome2,cEmail2,'1',aTitulos2) 
			    For nI := 1 to len(aTitulos2)
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					SE1->(dbSeek(	xFilial("SE1") 		+;
									aTitulos2[nI,10] 	+;
									aTitulos2[nI,01] 	+;
									aTitulos2[nI,11] 	+;
									aTitulos2[nI,12]) ) 
					RecLock("SE1", .F.)
					SE1->E1_NENVIO := 1
					SE1->(MsUnlock())
			    Next nI
			Endif
			//DEBUG
			cLinha += CRLF
			cLinha += 'Tipo 2 dias - Contato: ' + cNome1 + '   Email: ' + cEmail1 +   'Contato2: ' + cNome2 + '   Email2: ' + cEmail2 + '  Cliente: ' + cCliente  + CRLF
			for xxx := 1 to len(aTitulos2)
				cLinha += aTitulos2[xxx,1] + '   ' + dtoc(aTitulos2[xxx,3]) + CRLF
			next xxx	
			//FIM DEBUG
		Endif
				

        ////////////////////////////////////////////////////////////////////////////////////
		// Titulos vencidos a 5 dias 
        ////////////////////////////////////////////////////////////////////////////////////
		If len(aTitulos5) > 0 
			//Atualiza flags na SE1 caso tenha conseguido enviar email
			If MENVMAIL(cNome1,cEmail1,cNome2,cEmail2,'2',aTitulos5)
			    For nI := 1 to len(aTitulos5)
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					SE1->(dbSeek(	xFilial("SE1") 		+;
									aTitulos5[nI,10] 	+;
									aTitulos5[nI,01] 	+;
									aTitulos5[nI,11] 	+;
									aTitulos5[nI,12]) ) 
					RecLock("SE1", .F.)
					SE1->E1_NENVIO := 2
					SE1->E1_DT1ENV := dDataBase  
					SE1->(MsUnlock())
			    Next nI   
			Endif
			//DEBUG
			cLinha += CRLF
			cLinha += 'Tipo 5 dias - Contato: ' + cNome1 + '   Email: ' + cEmail1 +   'Contato2: ' + cNome2 + '   Email2: ' + cEmail2 + '  Cliente: ' + cCliente  + CRLF
			for xxx := 1 to len(aTitulos5)
				cLinha += aTitulos5[xxx,1] + '   ' + dtoc(aTitulos5[xxx,3]) + CRLF
			next xxx	
			//FIM DEBUG
		Endif
           
        ////////////////////////////////////////////////////////////////////////////////////
		// Titulos vencidos apos 15 dias do primeiro aviso 
        ////////////////////////////////////////////////////////////////////////////////////
		If len(aTitulos15) > 0 
			//Atualiza flags na SE1 caso tenha conseguido enviar email
			If MENVMAIL(cNome1,cEmail1,cNome2, cEmail2,'3',aTitulos15)
			    For nI := 1 to len(aTitulos15)
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					SE1->(dbSeek(	xFilial("SE1") 		+;
									aTitulos15[nI,10] 	+;
									aTitulos15[nI,01] 	+;
									aTitulos15[nI,11] 	+;
									aTitulos15[nI,12]) ) 
					RecLock("SE1", .F.)
					SE1->E1_NENVIO := 3
					SE1->(MsUnlock())
			    Next nI
            Endif 
			//DEBUG
			cLinha += CRLF
			cLinha += 'Tipo 15 dias - Contato: ' + cNome1 + '   Email: ' + cEmail1 +   'Contato2: ' + cNome2 + '   Email2: ' + cEmail2 + '  Cliente: ' + cCliente  + CRLF
			for xxx := 1 to len(aTitulos15)
				cLinha += aTitulos15[xxx,1] + '   ' + dtoc(aTitulos15[xxx,3]) + CRLF
			next xxx	
			//FIM DEBUG
		Endif	
                   
		aTitulos2 := {}			
		aTitulos5 := {}
		aTitulos15:= {}	   
       
	EndDo
          
    //alert('fim')

    //debug gera log espelho dos emails
	nFile := MsFCreate("\DEMJ010.LOG")
	FWrite(nFile, cLinha) 
	FClose(nFile)


	memowrite("\2.txt", 'XXX')
      
	//
	// Libera Job
	//
	If !lManual
		FreeUsedCode()
		RpcClearEnv()
	Endif
Return(.t.) 
   
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÀÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunÁ„o    ≥DiaUtil ∫Autor≥ Marco Andre Abramo     ∫ Data ≥  11/08/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕ ÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Obtem o dia util a partir de uma data informada            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Parametros≥ _dData	Data Informada                                    ∫±±
±±∫Uso       ≥ _nDias	Deslocamento em dias a partir de _dData.          ∫±±
±±∫Uso       ≥          Se negativo, desloca para os dias anteriores      ∫±±
±±∫Uso       ≥          Se positivo, desloca para os dias posteriores     ∫±±
±±∫Retorno   ≥ Data encontrada                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GenÈrico                                                   ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
 
Static  Function DiaUtil(_dData, _nDias)
Local nI 			:= 0
Local _dData2 		:= _dData   
Local _dData2Ant	:= _dData


For nI := 1 to Abs(_nDias)

	_dData2 := DataValida(_dData2 + iif(_nDias > 0, +1, -1) ) 

	nD := 0
	
	While _dData2 == _dData2Ant
		_dData2 := DataValida(_dData2 - ++nD ) 
	EndDo	
	     
	_dData2Ant := _dData2

Next nI


Return _dData2




/*                              
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Rotina    ≥MENVMAIL   ∫Autor  ≥ Amarildo Stewart   ∫ Data ≥  08/08/08   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Rotina para envio de e-mail de titulos a receber a vencer e∫±±
±±∫          ≥atrasado de carta de cobranca para os contatos dos Contratos∫±±
±±∫          ≥monta o layout do e-mail a ser enviado. 					  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Especifico Demarest & Almedida Advocacia-Projeto FS08203722∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ   

*/
Static Function MENVMAIL(cNome1, cEmail1, cNome2, cEmail2, cTipo, aTitulo)                

Local lRet 		   := .T.
Local nLinha      := 0     //Contador
Local cDe         := AllTrim(GetMV("MV_RELFROM",,"cobranca@demarest.com.br")) //Conta do usuario que est· enviando. Pode ser a mesma de conexao - cobranca@demarest.com.br
Local cAttach     := ""  
Local cArqui	   := ""
Local cError      := ""
Local dDatEnvio   := Nil
Local cHorEnvio   := ""
Local cDirErrMail := "\System\"
Local cArqErrMail := "ErroEmail"
Local lOk         := .F.
Local lAutOk 	   := .T.
Local lSendOk     := .F.
Local Cc          := ""
Local cComCopia   := ""
Local cAssunto    := ""
Local cMessage    := ""
Local nCont       := 0
Local _cUSERCOB   := ""//,,"cobranca@demarest.com.br")) //  usuario responsavel do financeiro que recebera o e-mail. 
Local _ESWFNDIA1  := 0 // 2 Dias util antes do vencimento real
Local _ESWFNDIA2  := 0 //  5 Dias uteis de atraso
Local _ESWFNDIA3  := 0 // 15 Dias uteis de atraso apos o primeiro envio
Local  cHtml      := ""
Local _nTotal	   := 0
Local _nCont	   := 0
Local _nTpEvio 	:= 0        
Local nTvlBruto	:= 0
Local nTIrrf      := 0
Local nTPis       := 0
Local nTCofins    := 0
Local nTCsll      := 0
Local nTVlLiq     := 0    

                     
cDe         := Alltrim(GetMV("MV_RELFROM",,"cobranca@demarest.com.br")) //Conta do usuario que est· enviando. Pode ser a mesma de conexao - cobranca@demarest.com.br
_cUSERCOB   := AllTrim(GetMV("ES_USERCOB"))//,,"cobranca@demarest.com.br")) //  usuario responsavel do financeiro que recebera o e-mail. 
_ESWFNDIA1  := GetMV("ES_WFNDIA1") //  2 Dias util antes do vencimento real
_ESWFNDIA2  := GetMV("ES_WFNDIA2") //  5 Dias uteis de atraso
_ESWFNDIA3  := GetMV("ES_WFNDIA3") // 15 Dias uteis de atraso apos o primeiro envio


cServer	:= GetMV("MV_RELSERV") 			// ,,"smtp.microsiga.com.br")   
cPass		:= GetMV("MV_RELPSW")  			// ,,"xxxxxxxx")
cCopyOc	:= GetMV("FS_MCOPYOC")  			// ,,"xxxxxxxx")
cEmail	:= GetMV("MV_RELACNT") 			// se for com autenticacao , a conta deve ser colocado
										  			// somente a primeira parte sem @ 
lSmtpAuth:= GetMV("MV_RELAUTH",,.T.)   // se houver autenticacao colocar nesse parametro .T.            		
nTimeOut := GetMV("MV_RELTIME",,30)
           
cHtml += '<html>'   
cHtml += '<head>'   
cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'   
cHtml += '<meta name="GENERATOR" content="Microsoft FrontPage 6.0">'   
cHtml += '<meta name="ProgId" content="FrontPage.Editor.Document">'   
cHtml += '<title>Carta de Cobranca </title>'   
cHtml += '<style>'   
cHtml += 'BODY {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt'   
cHtml += '}'   
cHtml += 'DIV {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt'   
cHtml += '}'   
cHtml += 'TABLE {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt'   
cHtml += '}'   
cHtml += 'TD {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt'   
cHtml += '}'   
cHtml += 'FORM {'   
cHtml += '	MARGIN: 0px'   
cHtml += '}'   
cHtml += 'A:link {'   
cHtml += '	COLOR: #2d2dcb'   
cHtml += '}'   
cHtml += 'A:visited {'   
cHtml += '	COLOR: #2d2dcb'   
cHtml += '}'   
cHtml += 'A:active {'   
cHtml += '	COLOR: #2d2dcb'   
cHtml += '}'   
cHtml += 'A:hover {'   
cHtml += '	COLOR: #2d2dcb'   
cHtml += '}'   
cHtml += 'INPUT {'   
cHtml += '	FONT-FAMILY: Courier; FONT-SIZE: 12px'   
cHtml += '}'   
cHtml += 'SELECT {'   
cHtml += '	FONT-FAMILY: Verdana,Arial,Helvetica,sans-serif; FONT-SIZE: 12px'   
cHtml += '}'   
cHtml += '.Yellow {'   
cHtml += '	BACKGROUND-COLOR: #e8e028'   
cHtml += '}	'   
cHtml += '.NormalYellow {'   
cHtml += '	COLOR: #e8e028; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 13px'   
cHtml += '}'   
cHtml += '.TableRowYellow {'   
cHtml += '	BACKGROUND-COLOR: #FFFFCC; COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.NormalRedBold {'   
cHtml += '	COLOR: #ff0000; FONT-FAMILY: Verdana,Arial,Helvetica,sans-serif; FONT-SIZE: 13px; FONT-WEIGHT: bold'   
cHtml += '}'   
cHtml += '.NormalCommentField {'   
cHtml += '	FONT-FAMILY: Courier; FONT-SIZE: 12px'   
cHtml += '}'   
cHtml += '.NormalBold {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10pt; FONT-WEIGHT: bold'   
cHtml += '}'   
cHtml += '.Mini {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'   
cHtml += '}'   
cHtml += '.MiniError {'   
cHtml += '	COLOR: #ff3333; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'   
cHtml += '}'   
cHtml += '.MidleBold {'   
cHtml += '	FONT-FAMILY: Verdana,Arial,Helvetica,sans-serif; FONT-SIZE: 14px; FONT-WEIGHT: bold'   
cHtml += '}'   
cHtml += '.Small {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'   
cHtml += '}'   
cHtml += '.SmallRight {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; TEXT-ALIGN: right'   
cHtml += '}'   
cHtml += '.SmallBold {'   
cHtml += '	FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; FONT-WEIGHT: bold'   
cHtml += '}'   
cHtml += '.SmallBoldHeight {'   
cHtml += '	FONT-FAMILY: Verdana,Arial,Helvetica,sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold; LINE-HEIGHT: 17px'   
cHtml += '}'   
cHtml += '.TitleSmall {'   
cHtml += '	COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 18px; FONT-WEIGHT: normal; LINE-HEIGHT: 20px; TEXT-ALIGN: left'   
cHtml += '}'   
cHtml += '.TitleSmallRight {'   
cHtml += '	COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 18px; FONT-WEIGHT: normal; LINE-HEIGHT: 20px; TEXT-ALIGN: right'   
cHtml += '}'   
cHtml += '.TitleSmallCenter {'   
cHtml += '	COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 18px; FONT-WEIGHT: normal; LINE-HEIGHT: 20px; TEXT-ALIGN: center'   
cHtml += '}'   
cHtml += '.TitleSmallSalmon {'   
cHtml += '	COLOR: #ffbfbf; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 18px; FONT-WEIGHT: normal; LINE-HEIGHT: 20px'   
cHtml += '}'   
cHtml += '.TitleMedium {'   
cHtml += '	COLOR: #979797; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 22px; FONT-WEIGHT: normal; LINE-HEIGHT: 24px; TEXT-ALIGN: left'   
cHtml += '}'   
cHtml += '.TitleMediumBold {'   
cHtml += '	COLOR: #979797; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 22px; FONT-WEIGHT: bold; LINE-HEIGHT: 24px; TEXT-ALIGN: left'   
cHtml += '}'   
cHtml += '.TitleMediumRight {'   
cHtml += '	COLOR: #979797; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 22px; FONT-WEIGHT: normal; LINE-HEIGHT: 24px; TEXT-ALIGN: right'   
cHtml += '}'   
cHtml += '.TitleMediumCenter {'   
cHtml += '	COLOR: #979797; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 22px; FONT-WEIGHT: normal; LINE-HEIGHT: 24px; TEXT-ALIGN: center'   
cHtml += '}'   
cHtml += '.TitleBig {'   
cHtml += '	COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 24px; FONT-WEIGHT: normal; LINE-HEIGHT: 26px; TEXT-ALIGN: left'   
cHtml += '}'   
cHtml += '.TitleBigRight {'   
cHtml += '	COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 24px; FONT-WEIGHT: normal; LINE-HEIGHT: 26px; TEXT-ALIGN: right'   
cHtml += '}'   
cHtml += '.TitleBigCenter {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7;COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 24px; FONT-WEIGHT: normal; LINE-HEIGHT: 26px; TEXT-ALIGN: center'   
cHtml += '}'   
cHtml += '.TitlePopupWhite {'   
cHtml += '	COLOR: #ffffff; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 16px; FONT-WEIGHT: normal; LINE-HEIGHT: 18px; TEXT-ALIGN: right'   
cHtml += '}'   
cHtml += '.TableColumnTitle {'   
cHtml += '	BACKGROUND-COLOR: #FFFF99; COLOR: #006633; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 14px; FONT-WEIGHT: bold; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableColumnTitleCenter {'   
cHtml += '	BACKGROUND-COLOR: #ffddcb; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; FONT-WEIGHT: bold; TEXT-ALIGN: center; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGrey {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGreyCenter {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; TEXT-ALIGN: center; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGreyForm {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; HEIGHT: 22px'   
cHtml += '}'   
cHtml += '.TableRowErrorForm {'   
cHtml += '	BACKGROUND-COLOR: #ff3333; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; HEIGHT: 22px'   
cHtml += '}'   
cHtml += '.TableRowGreyTitleMedium {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7; COLOR: #979797; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 19px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGreyDark {'   
cHtml += '	BACKGROUND-COLOR: #ececec; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGreyDarkMini {'   
cHtml += '	BACKGROUND-COLOR: #ececec; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowGreyMini {'   
cHtml += '	BACKGROUND-COLOR: #f7f7f7; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowSalmon {'   
cHtml += '	BACKGROUND-COLOR: #fff2eb; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowSalmonCenter {'   
cHtml += '	BACKGROUND-COLOR: #fff2eb; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; TEXT-ALIGN: center; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowSalmonForm {'   
cHtml += '	BACKGROUND-COLOR: #fff2eb; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; HEIGHT: 22px'   
cHtml += '}'   
cHtml += '.TableRowSalmonFormMini {'   
cHtml += '	BACKGROUND-COLOR: #fff2eb; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px'   
cHtml += '}'   
cHtml += '.TableRowWhite {'   
cHtml += '	COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowWhiteCenter {'   
cHtml += '	COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; TEXT-ALIGN: center; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowWhiteForm {'   
cHtml += '	COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; HEIGHT: 22px'   
cHtml += '}'   
cHtml += '.TableRowWhiteMini {'   
cHtml += '	COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowWhiteMini2 {'   
cHtml += '	COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowBlueTitleMedium {'   
cHtml += '	BACKGROUND-COLOR: #006633; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 28px; VERTICAL-ALIGN: top ; FONT-WEIGHT: bold'   
cHtml += '}'   
cHtml += '.TableRowBlueDark {'   
cHtml += '	BACKGROUND-COLOR: #006633; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 14px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowBlueDarkMini {'   
cHtml += '	BACKGROUND-COLOR: #006633; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowBlueMini {'   
cHtml += '	BACKGROUND-COLOR: #006633; COLOR: #FFFFFF; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 10px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '.TableRowBlue {'   
cHtml += '	BACKGROUND-COLOR: #006633; COLOR: #000000; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; FONT-SIZE: 12px; VERTICAL-ALIGN: top'   
cHtml += '}'   
cHtml += '</style>'   
cHtml += '</head>'   

cHtml += '<body>'   

cHtml += '<table border="0" width="100%">'   
cHtml += '  <tr>'   
cHtml += '    <td width="100%" class="TableRowBlueTitleMedium"> <p align="center"><font size="4">DEMAREST '   
cHtml += '        &amp; ALMEIDA ADVOGADOS</font></td>'   
cHtml += '  </tr>'   
cHtml += '</table>'   

If cTipo == "1" 
cHtml += '<div align="center">'   
cHtml += '<table  width="100%">'   
cHtml += '	<TR>'   
cHtml += '      <td width="100%" height="15" valign="middle" class="TitleBig"><font size="5" face="Geneva, Arial, Helvetica, sans-serif">Aviso de Vencimento '
cHtml += '      </font></TD>'   
cHtml += '  </TR>'   
cHtml += '</table>'   
cHtml += '</div>'   
ElseIf cTipo == "2"
cHtml += '<div align="center">'   
cHtml += '<table  width="100%">'   
cHtml += '	<TR>'   
cHtml += '      <td width="100%" height="15" valign="middle" class="TitleBig"><font size="5" face="Geneva, Arial, Helvetica, sans-serif">Primeiro Lembrete de Honor&aacute;rios Pendentes '   
cHtml += '      </font></TD>'   
cHtml += '  </TR>'   
cHtml += '</table>'   
cHtml += '</div>'  
Else
cHtml += '<div align="center">'   
cHtml += '<table  width="100%">'   
cHtml += '	<TR>'   
cHtml += '      <td width="100%" height="15" valign="middle" class="TitleBig"><font size="5" face="Geneva, Arial, Helvetica, sans-serif">Segundo Lembrete de Honor&aacute;rios Pendentes '   
cHtml += '      </font></TD>'   
cHtml += '    </TR>'   
cHtml += '</table>'   
cHtml += '</div>'  
Endif
cHtml += '<p><br>'   
cHtml += '  S&atilde;o Paulo, '+Strzero(Day(dDataBase),2,0)+' de '+MesExtenso(Month(dDataBase))+' de '+Strzero(Year(dDatabase),4,0)+'</p>'   

If cTipo == "1" .Or. cTipo == "2"
	cHtml += '<p>&nbsp;</p>'   
	cHtml += '<p>Prezado Sr (a): ' + cNome1 + '</p>'    
	cHtml += '<p></p>'
Endif
            
If cTipo == "3"
	cHtml += '<p>&nbsp;</p>'   
	cHtml += '<p>Prezado Sr (a): ' + cNome2 + '</p>'    
	cHtml += '<p></p>'    
Endif 

If cTipo == "1" 
cHtml += '<p>Tem a presente, a finalidade de informar que a(s) fatura(s) abaixo descrita(s) '   
cHtml += '  vencer&aacute;(&atilde;o) nos pr&oacute;ximos '+ str(_ESWFNDIA1) +' dias. </p>'   
Endif      

If cTipo == "2" 
cHtml += '<p>Tem a presente, a finalidade de informar que a(s) fatura(s) abaixo descrita(s) encontra(m)-se vencida(s)'
cHtml += ' h· mais de '+str(_ESWFNDIA2) +' dias.</p>'   
Endif 

If cTipo == "3"
cHtml += '<p>Tem a presente, a finalidade de informar que a(s) fatura(s) abaixo descrita(s) encontra(m)-se vencida(s)' 
cHtml += ' h· mais de '+ str(_ESWFNDIA3) +' dias.</p>'   
Endif

cHtml += '<table border="1" cellspacing="1" width="100%">'   
cHtml += '  <tr> '   
cHtml += '    <td width="9%"  align="center" bgcolor="#0000FF" class="TableRowBlueDarkMini" > '   
cHtml += '      <div align="center"><b>Fatura </b></div></td>'   

//Alterado Jordan Lazarine - 22.Jan.09
cHtml += '    <td width="40%"  align="center" bgcolor="#0000FF" class="TableRowBlueDarkMini" > '   
cHtml += '      <div align="center"><b>Raz&atilde;o Social </b></div></td>'

cHtml += '    <td width="9%"  align="center" bgcolor="#0000FF" class="TableRowBlueDarkMini" > '   
cHtml += '      <div align="center"><b><font size="2">Emiss&atilde;o</font></b></div></td>'   
cHtml += '    <td width="9%" align="center" bgcolor="#0000FF" class="TableRowBlueDarkMini" ><b><font size="2">Vecto '   
cHtml += '      Real </font></b></td>'   
/*cHtml += '    <td width="11%" align="center" bgcolor="#0000FF"  class="TableRowBlueDarkMini" ><font size="2"><strong>Valor '   
cHtml += '      Bruto </strong></font></td>'   
cHtml += '    <td width="10%" align="center" bgcolor="#0000FF"  class="TableRowBlueDarkMini" ><b><font size="2">IRRF '   
cHtml += '      </font></b></td>'   
cHtml += '    <td width="11%" align="center"  class="TableRowBlueDarkMini" > <div align="center"></div>'   
cHtml += '      <strong><font size="2">PIS</font></strong></td>'   
cHtml += '    <td width="12%" align="center" bgcolor="#0000FF"  class="TableRowBlueDarkMini" > '   
cHtml += '      <div align="center"><strong><font size="2"></font></strong></div>'   
cHtml += '      <strong><font size="2">COFINS</font></strong></td>'   
cHtml += '    <td width="9%" align="center" bgcolor="#0000FF"  class="TableRowBlueDarkMini" > '   
cHtml += '      <div align="center"><strong><font size="2"></font></strong></div>'   
cHtml += '      <strong><font size="2">CSLL</font></strong></td>'*/   //Alterado por Jordan Lazarine - 07.Nov.08
cHtml += '    <td width="14%" align="center" bgcolor="#0000FF"  class="TableRowBlueDarkMini" ><b><font size="2">Valor '   
cHtml += '      Bruto </font></b></td>'   
cHtml += '  </tr>'   
           
For nLinha := 1 to Len(aTitulo)     

// total com impostos.
aTitulo[nLinha,4]+= (aTitulo[nLinha,5])+(aTitulo[nLinha,6])+(aTitulo[nLinha,7])+(aTitulo[nLinha,8])


cHtml += '  <tr>   
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <p align="center"><font size="2">'+aTitulo[nLinha,1]+' 
cHtml += '        </font></p></td>

//Alterado Jordan Lazarine - 22.Jan.09
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <p align="left"><font size="2">'+aTitulo[nLinha,13]+' 
cHtml += '        </font></p></td>
                                                   
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="center">'+dtoc(aTitulo[nLinha,2])+'</div></td>
cHtml += '    <td bordercolor="1" class="TableRowWhiteMini2">  <div align="center">'+dtoc(aTitulo[nLinha,3])+'</div></td>
/*cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,4],"@E 99,999,999,999.99")+'</font></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,5],"@E 99,999,999,999.99")+'</font></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,6],"@E 99,999,999,999.99")+'</font></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,7],"@E 99,999,999,999.99")+'</font></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,8],"@E 99,999,999,999.99")+'</font></div></td>*/   //Alterado por Jordan Lazarine - 07.Nov.08
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><font size="2">'+Transform(aTitulo[nLinha,9],"@E 99,999,999,999.99")+'</font></div></td>
cHtml += '  </tr>

// totalizacao dos valores dos titulos por e-mail.  
nTvlBruto += aTitulo[nLinha,4]
nTIrrf    += aTitulo[nLinha,5]
nTPis     += aTitulo[nLinha,6]
nTCofins  += aTitulo[nLinha,7]
nTCsll	 += aTitulo[nLinha,8]
nTVlLiq   += aTitulo[nLinha,9] 

Next nLinha

cHtml += '  <tr bgcolor="#999999"> 
cHtml += '    <td colspan="4" bordercolor="1"  class="TableRowWhiteMini2"> <p align="center">&nbsp;</p>
cHtml += '      <div align="center"></div>
cHtml += '      <div align="center"></div>
cHtml += '      <div align="center"></div></td>
/*cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTvlBruto,"@E 99,999,999,999.99")+'</font></strong></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTIrrf,"@E 99,999,999,999.99")+'</font></strong></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTPis,"@E 99,999,999,999.99")+'</font></strong></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTCofins,"@E 99,999,999,999.99")+'</font></strong></div></td>
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTCsll,"@E 99,999,999,999.99")+'</font></strong></div></td>*/   //Alterado por Jordan Lazarine - 07.Nov.08
cHtml += '    <td bordercolor="1"  class="TableRowWhiteMini2"> <div align="right"><strong><font size="2">'+Transform(nTVlLiq,"@E 99,999,999,999.99")+'</font></strong></div></td>
cHtml += '  </tr>
cHtml += '  <tbody>
cHtml += '  </tbody>
cHtml += '</table>
cHtml += '<TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
cHtml += '	<TR><TD bgColor=#006633><IMG height=1 src="pic_invis.gif" width=1></TD></TR>
cHtml += '</TABLE>'

If cTipo == "2" .or. cTipo == "3" 
cHtml += '<br>
cHtml += 'Caso ela(s) apresente(m) d&uacute;vida(s)/incorre&ccedil;&atilde;o(&otilde;es) ou necessite de assist&ecirc;ncia '
cHtml += 'para liquid&aacute;-la(s), favor entrar em contato com nosso departamento de cobran&ccedil;a 
cHtml += '(cobranca@demarest.com.br ou pelos telefones: (11) 3356-2165/1607/1691). '
cHtml += '<br>' 
Endif

If cTipo == "1"
cHtml += '<br>
cHtml += 'Caso ela(s) n&atilde;o tenha(m) sido recebida(s) ou apresente(m) d&uacute;vida(s)/ 
cHtml += 'incorre&ccedil;&atilde;o(&otilde;es), favor entrar em contato com nosso departamento de cobran&ccedil;a 
cHtml += '(cobranca@demarest.com.br ou pelos telefones: (11) 3356-2165/1607/1691). '   
cHtml += '<br>'
Endif

cHtml += 'Esta mensagem &eacute; gerada automaticamente; desta forma, favor desconsider&aacute;-la, caso a(s) fatura(s) tenha(m)
cHtml += ' sido liquidada(s).</p>

cHtml += '<br>'

cHtml += '* Conforme instru&ccedil;&atilde;o normativa SRF 381 de 02/02/2004, est&aacute; dispensada a reten&ccedil;&atilde;o
cHtml += ' do PIS, COFINS e CSLL, quando o valor for inferior &agrave; R$ 5.000,01.</p>

cHtml += '<p></p>
/*cHtml += '<p></p>
cHtml += '<p><br>
cHtml += '</p>*/
cHtml += '<p><br>
cHtml += '  Atenciosamente,</p>
cHtml += '<p>Demarest &amp; Almeida<br>
cHtml += '  Departamento Financeiro<br>
cHtml += '</p>
cHtml += '</body>
cHtml += '</html>'     
    
If cTipo = "1"
	cComCopia := " "
else
	cComCopia := cEmail2
Endif

// A conexao esta sendo realizada antes ,pela rotina DemJ010.

if cTipo == "1"
	cAssunto := "Aviso de Vencimento "    
Endif

if cTipo == "2"
	cAssunto := "Primeiro Lembrete de Honor·rios Pendentes "  
Endif

if cTipo == "3"
	cAssunto := "Segundo Lembrete de Honor·rios Pendentes "  
Endif
    
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass TIMEOUT nTimeOut RESULT lOk 

//Se configurado, efetua a autenticacao
If ( lSmtpAuth )
	lAutOk := MailAuth(cEmail,cPass)
EndIf  

If !lOk  .or. !lAutOk
		nHandle := MsFCreate(cDirErrMail+cArqErrMail) 
		FWrite(nHandle,	"N„o foi possivel conectar-se ao servidor de email. " + ;
					"Server: " + cServer 	+;
					"Conta:	 " + cEmail		+;
					"Senha:	 " + cPass ) 
    	Fclose(nHandle) 

		Return .F.	
Endif

// Envio de aviso de titulos a vencer.
If cTipo == "1" .and. !empty(cEmail1)
	SEND MAIL FROM cDe to Lower(cEmail1) BCC Lower(cCopyOc) SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
	//SEND MAIL FROM cMailConta to cTo BCC cCC  SUBJECT cAssunto BODY cMensagem  RESULT lSendOk
Endif

//  Envio de aviso de titulos com 5 dias uteis de atraso.
If cTipo == "2" .and. !empty(cEmail1)
	SEND MAIL FROM cDe to Lower(cEmail1) BCC Lower(cCopyOc) SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
	//SEND MAIL FROM cDe to Lower(cEmail1) SUBJECT cAssunto BODY cHtml  ATTACHMENT cAttach RESULT lSendOk
   
   If AllTrim(Lower(cEmail1)) <> AllTrim(Lower(cEmail2)) //Caso e-mail seja igual n„o enviar novamente.
		cHtml := STUFF(cHtml, at(cNome1, cHtml),  len(cNome1), cNome2) // Substituicao para o nome do cEmail2
   
   	SEND MAIL FROM cDe to Lower(cEmail2) BCC Lower(cCopyOc) SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
   	//SEND MAIL FROM cDe to Lower(cEmail2) SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
	EndIf

Endif
      
// Envio de aviso de titulos com 15 dias de atraso apos o primeiro aviso.    
If cTipo == "3" .and. !empty(cEmail1) 
	SEND MAIL FROM cDe to Lower(cEmail2) BCC Lower(cCopyOc) SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
	//SEND MAIL FROM cDe to Lower(cEmail2)  SUBJECT cAssunto BODY cHtml ATTACHMENT cAttach RESULT lSendOk
Endif


If !lOk  .or. !lAutOk
		nHandle := MsFCreate(cDirErrMail+cArqErrMail) 
		FWrite(nHandle,	"N„o foi possivel conectar-se ao servidor de email. " + ;
					"Server: " + cServer 	+;
					"Conta:	 " + cEmail		+;
					"Senha:	 " + cPass ) 
    	Fclose(nHandle) 

		Return .F.	
Endif
             
//Erro de envio do e-mail
If !lSendOk  .or. ;
   (empty(cEmail1) .and. cTipo <> "3") .or.;
   (empty(cEmail2) .and. cTipo <> "1") 
	
	lRet := .T.  

	cAssunto:= "Falha de envio de email - Tipo de Envio " + cTipo +  " - Contato 1: " + cNome1 + ' - Email1 ' + cEmail1 +  ' - Contato 2: ' + cNome2 + ' Email2 '+ cEMail2

	// enviar e-mail para o responsavel financeiro
	SEND MAIL FROM cDe to Lower(_cUSERCOB) BCC Lower(cCopyOc) SUBJECT cAssunto BODY cHtml RESULT lSendOk
	//SEND MAIL FROM cDe to Lower(_cUSERCOB) SUBJECT cAssunto BODY cHtml RESULT lSendOk
	
	GET MAIL ERROR cError
	dDatEnvio   := dDataBase
	cHorEnvio   := Time() 
	
	cError      += cAssunto+","+cEmail1+","+cEmail2
	
	cData:=DtoS(Date())+"_"+SubsTr(Time(),1,2)+"h"+SubsTr(Time(),4,2)+"m"+SubsTr(Time(),7,2)

	nHandle := MsFCreate(cDirErrMail+cArqErrMail+"_"+cData+".txt")
	FWrite(nHandle,cError)
	Fclose(nHandle)
Endif

DISCONNECT SMTP SERVER RESULT lOk

Return(lRet)   

SELECT * FROM SA1010

