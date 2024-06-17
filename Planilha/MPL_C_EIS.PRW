#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "VKEY.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MPL_C_EIS ³ Autor ³ Anderson Kurtinaitis   ³ Data ³ 23/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que gera consultas ref. Consumo/Mes do Simil + EIS   ³±±
±±³          ³ posicionado                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ROCHESTER                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MPL_C_EIS(cSimil,cEIS)  //SUBST. MPL_003

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta matriz ajudar na montagem da Tela                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

          
if EmptY(cSimil)
   Aviso("ATENCAO", "Nao foi possivel continuar pois o Simil esta em branco",{"&Ok"})
   Return
Endif

If EmptY(cEIS)
   Aviso("ATENCAO", "Nao foi possivel continuar pois o Cod.Eis esta em branco",{"&Ok"})
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³[1][2]Data Inicio da consulta dos Historicos com base na ³
//³        data de Reprocessamento.                         ³
//³Utilizamos sempre a data de Reprocessamento pois o resumo³
//³do Historico ocorre com base no ultimo fechamento.       ³
//³[1][2]Data Final do Reprocessamento.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDtFecha:= U_DataFecha()
dIniHis := aDtFecha[1][3]  // Data Inicial
dFimHis := aDtFecha[1][1]  // Data Final


cAno    := str(Year(dIniHis),4)
cMes    := strzero(month(dIniHis),2)

cAnoFim := str(Year(dFimHis),4)
cMesFim := strzero(month(dFimHis),2)


/*
cMes = cMes - 1
if cMes < 0
   cAno := str(Val(cAno)-1,4)
   cMes := "12"
Else
   cAno := cAno
   cMes := strzero(Val(cMes)-1,2)
Endif    



cMesFim = cMesFim - 1
if cMesFim < 0
   cAnoFim := str(Val(cAnoFim)-1,4)
   cMesFim := "12"
Else
   cAnoFim := cAnoFim
   cMesFim := strzero(Val(cMesFim)-1,2)
Endif    
             
*/



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Primeiro monto todos os meses que apareceram no acols    ³
//³para que independente de ter ou nao quantidade ele       ³
//³aparecam com quantidade igual a 0 zero.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
    DbSelectArea("SZ9")       //AADD(_aDados,{"JAN","2003",1545,"01"})
    DbSetOrder(2)             // Filial + Ano + Mes + Simil + Eis       
    If DbSeek( xFilial("SZ9") + _aDados[ny][2] + _aDados[ny][4] + cSimil + cEis )
       _aDados[ny][3] := SZ9->Z9_QTDSAI
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

@ 020,070 To 330,385 Dialog oJan01 Title OemToAnsi("Consumo/Mes SIMIL+EIS")
bSetKey4 := SetKey(VK_F4 ,{|| Close(oJan01) }) // Desabilita e guarda o conteudo

DbSelectArea("TRB")
DbGoTop()

aFields := {}
AADD(aFields,{ "MES"	   	,"Mes"    	,"@!" })
AADD(aFields,{ "ANO"	   	,"Ano"		,"@!" })
AADD(aFields,{ "CONSUMO"	,"Consumo"	,"@E 999,999.99" })
AADD(aFields,{ "VAZIO"	   ,"","" })

@ 007,005 SAY OemToAnsi("SIMIL:") COLOR CLR_HRED
@ 007,020 SAY cSimil Size 20,8 COLOR CLR_HBLUE
@ 007,043 SAY OemToAnsi("EIS:") COLOR CLR_HRED
@ 007,055 SAY cEIS Size 100,8 COLOR CLR_HBLUE

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
