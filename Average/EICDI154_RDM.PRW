#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEICDI154_RDMบ Autor ณ                  บ Data ณ  30/06/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para controlar Numeracao de Notas Fiscais บฑฑ
ฑฑบ          ณ Evitando duplicacao de Numeracao                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7 IDE - AVERAGE                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออ]อออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

//Marcelo,..
//O programa deverแ chamar EICDI154_RDM.PRW, a fun็ใo deverแ chamar
//User function EITAV079 PATRICIA          03/02/06 14:41 CDI154 ()..
//Oparโmetro ้ passado da seguinte forma: .Case Paramixb == "DGL_MARCADOS". .
//Entใo voc๊ faz sua valida็ใo com as variแveis cnumNFE e cserieNFE, caso seja rejeitada,
//zerar a nOpca e zerar as duas variแveis...Atenciosamente,..Patrํcia dos Santos.

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


