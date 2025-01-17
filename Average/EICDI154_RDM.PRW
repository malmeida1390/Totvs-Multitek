#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EICDI154_RDM� Autor �                  � Data �  30/06/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para controlar Numeracao de Notas Fiscais ���
���          � Evitando duplicacao de Numeracao                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 IDE - AVERAGE                                          ���
������������������������������������������������������������������]������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//Marcelo,..
//O programa dever� chamar EICDI154_RDM.PRW, a fun��o dever� chamar
//User function EITAV079 PATRICIA          03/02/06 14:41 CDI154 ()..
//Opar�metro � passado da seguinte forma: .Case Paramixb == "DGL_MARCADOS". .
//Ent�o voc� faz sua valida��o com as vari�veis cnumNFE e cserieNFE, caso seja rejeitada,
//zerar a nOpca e zerar as duas vari�veis...Atenciosamente,..Patr�cia dos Santos.

*----------------------*
User Function EICDI154_RDM()
*----------------------*

Local _aArea    := GetArea()
Local _nOpc     := ParamIxb

If _nOpc = "GRV_MARCADOS"
	
	If cNumNfe <> ""               // Evita que esta funcao seja chamada varias vezes
		
		DbSelectArea("SF1")
		DbSetOrder(1)
		If Dbseek(xFilial("SF1")+cnumNFE+cserieNFE)
			
			while !SF1->(EOF()) .and. xFilial("SF1")+cnumNFE+cserieNFE = SF1->(F1_FILIAL+F1_DOC+F1_SERIE)
				
				// Devolucao em Formulario proprio
				// Ou seja e analizado se a numeracao de nota fiscal utilizada pelo Eic nao foi
				// utilizada para efetuar uma nota fiscal de devolucao.
				// Evitando que tenhamos duas notas emitidas pela multitek com o mesmo numero.
				If SF1->F1_TIPO="D" .and. SF1->F1_FORMUL ="S"
					
					Aviso("ATENCAO", "Nota fiscal ja foi emitida como devolucao",{"&Ok"})
					
					cnumNFE  := ""
					cserieNFE:= ""
					nOpca    := 0
					
				Endif
				
				SF1->(DBSKIP())
				
			Enddo
			
		Endif
		
		
		
		If cNumNfe <> ""  // Analiso se ja nao foi validado acima
			
			DbSelectArea("SF2")
			DbSetOrder(1)
			If Dbseek(xFilial("SF2")+cnumNFE+cserieNFE)
				
				Aviso("ATENCAO", "Nota fiscal ja foi emitida como Saida..",{"&Ok"})
				
				cnumNFE  := ""
				cserieNFE:= ""
				nOpca    := 0
				
			Endif
			
		endif
		
	Endif
	
Endif

RestArea(_aArea)

Return


