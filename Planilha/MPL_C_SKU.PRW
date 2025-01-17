#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "VKEY.CH"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MPL_C_SKU � Autor � Anderson Kurtinaitis   � Data � 23/01/04 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que gera consultas ref. Consumo/Mes da Sku           ���
���          � posicionado                                                 ���
��������������������������������������������������������������������������Ĵ��
���Uso       � ROCHESTER                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function MPL_C_SKU(cSKU)

Local bSetKey4
Local oJan01
Local _aDados := {}
Local aMes    := {}
Local aDtFecha:= {}
Local dIniHis := ctod("")
Local cAno    := ""
Local cMes    := ""
Local cAnoFim := ""
Local cMesFim := ""
Local aStru   := {}

//���������������������������������������������������������Ŀ
//�Esta matriz ajudar na montagem da Tela                   �
//�����������������������������������������������������������
aMes := {{"01","JAN"},;
{"02","FEV"},;
{"03","MAR"},;
{"04","ABR"},;
{"05","MAI"},;
{"06","JUN"},;
{"07","JUL"},;
{"08","AGO"},;
{"09","SET"},;
{"10","OUT"},;
{"11","NOV"},;
{"12","DEZ"}}

         
if EmptY(cSKU)
   Aviso("ATENCAO", "Nao foi possivel continuar pois o item selecionado esta com a numero da sku em branco",{"&Ok"})
   Return
Endif

//���������������������������������������������������������Ŀ
//�[1][2]Data Inicio da consulta dos Historicos com base na �
//�        data de Reprocessamento.                         �
//�Utilizamos sempre a data de Reprocessamento pois o resumo�
//�do Historico ocorre com base no ultimo fechamento.       �
//�[1][2]Data Final do Reprocessamento.                     �
//�����������������������������������������������������������
aDtFecha:= U_DataFecha()
dIniHis := aDtFecha[1][3]  // Data Inicial
dFimHis := aDtFecha[1][1]  // Data Final

cAno    := str(Year(dIniHis),4)
cMes    := strzero(month(dIniHis),2)
    
cAnoFim := str(Year(dFimHis),4)
cMesFim := strzero(month(dFimHis),2)


//���������������������������������������������������������Ŀ
//�Primeiro monto todos os meses que apareceram no acols    �
//�para que independente de ter ou nao quantidade ele       �
//�aparecam com quantidade igual a 0 zero.                  �
//�����������������������������������������������������������
While .t.
      nMes := Val(cMes)
      nAno := Val(cAno)    
      nPos := aScan( aMes , {|x| x[1] == cMes })
   
      //AADD(_aDados,{"JAN","2003",1545,"01"})
      AADD(_aDados,{aMes[nPos][2],cAno,0,cMes})

      If cMes == cMesFim .and. cAno == cAnoFim 
         Exit
      Endif
   
      nMes += 1
      if nMes > 12
	     cAno := str(Val(cAno)+1,4)
	     cMes := "01"
      Else
	     cAno := cAno
	     cMes := strzero(Val(cMes)+1,2)
      Endif    
Enddo

For nY:= 1 to Len(_aDados)	
    DbSelectArea("SZA")       //AADD(_aDados,{"JAN","2003",1545,"01"})
    DbSetOrder(2)             // Filial + Ano + Mes + Sku      
    If DbSeek( xFilial("SZA") + _aDados[ny][2] + _aDados[ny][4] + cSku )
       _aDados[ny][3] := SZA->ZA_QTDSAI
    Endif
Next


// Criando arquivo Temporario para conter os dados dos consumos mes a mes
aStru := {}

AADD(aStru,{ "MES"		,"C",10,0 })
AADD(aStru,{ "ANO" 	    ,"C",06,0 })
AADD(aStru,{ "CONSUMO"	,"N",15,2 })
AADD(aStru,{ "VAZIO"	   ,"C",1 ,0 })

cArqTrab := CriaTrab( aStru, .t. )
dbUseArea( .T.,,cArqTrab,"TRB",.T.,.F. )

DbSelectArea("TRB")

For nY :=1 to Len(_aDados)

	// Rotina para gravar os dados acumulados no TRB (Que mostrara os dados por representante no Browser)
	
	DbSelectArea("TRB")
	RecLock("TRB",.T.)
	
	TRB->MES 		:= _aDados[nY,1]
	TRB->ANO 		:= _aDados[nY,2]
	TRB->CONSUMO	:= _aDados[nY,3]
	
	MsUnLock()
	
Next


// Tela para apresentacao dos dados

@ 020,070 To 330,385 Dialog oJan01 Title OemToAnsi("Consumo/Mes SKU")
bSetKey4 := SetKey(VK_F4 ,{|| Close(oJan01) }) // Desabilita e guarda o conteudo

DbSelectArea("TRB")
DbGoTop()

aFields := {}
AADD(aFields,{ "MES"		,"Mes"    	,"@!" })
AADD(aFields,{ "ANO"		,"Ano"		,"@!" })
AADD(aFields,{ "CONSUMO","Consumo"	,"@E 999,999.99" })
AADD(aFields,{ "VAZIO"	,"","" })

@ 007,005 SAY OemToAnsi("SKU:") COLOR CLR_HRED
@ 007,020 SAY cSKU  Size 100,8 COLOR CLR_HBLUE
//@ 007,043 SAY OemToAnsi("EIS:") COLOR CLR_HRED
//@ 007,055 SAY cEIS Size 100,8 COLOR CLR_HBLUE

@ 005,120 BmpButton Type 1 Action Close(oJan01)
@ 025,005 TO 150,150 BROWSE "TRB" FIELDS aFields

ACTIVATE DIALOG oJan01 CENTERED
SetKey(VK_F4 ,bSetKey4) // Retorna o Conteudo anterior


// Eliminando arquivos temporarios (Query e Tmp)
dbSelectarea("TRB")
dbCloseArea()

// Eliminando Arq. temporario
If File(cArqTrab+".DTC")
	FErase(cArqTrab+".DTC")
EndIf

Return()
