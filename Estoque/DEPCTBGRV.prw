#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/00

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矰EPCTBGRV 矨utor  �                       � Data �06.11.03   潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 矨lteracao da Origem do Lancamento no CT2 para Mata331 e inclui潮�
北�          砯ilial.                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ultitek                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function DEPCTBGRV()
                  
If !(UPPER(FUNNAME()) = "MATA330")
   RETURN
Endif   


                      
//if MsgBox("Deseja manter os Lancamentos contabeis desta filial  ? "+chr(13)+;
//          "Caso afirmativo estaremos mudando a origem dos registros "+;
//          "para que na proxima geracao nao seja efetuada limpeza da Contabilidade.","Escolha","YESNO")
 
MsgRun( OemToAnsi( "Aguarde. Efetuando Troca da Origem dos Lancamentos..." ),"",{||LimpCT2()})
    
//Endif                                                                 

Return




Static Function LimpCT2()

// Prenchendo a Filail original tambem pode resolver o problema mas pode afetar outras
// rotinas.
// TCSQLEXEC(("UPDATE CT2010 SET CT2_FILORI='"+xFilial("SD2")+"' WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_ROTINA='MATA330' AND CT2_FILORI='"+xFilial("SD2")+"' AND D_E_L_E_T_<>'*'" ))

TCSQLEXEC(("UPDATE CT2010 SET CT2_ROTINA = 'MATA331-"+xFilial("SD2")+"' WHERE CT2_FILIAL = '"+xFilial("CT2")+"' AND CT2_ROTINA='MATA330' AND D_E_L_E_T_<>'*'" ))

TCSQLEXEC(("COMMIT"))

Return