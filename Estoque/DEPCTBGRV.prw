#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/07/00

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DEPCTBGRV ³Autor  ³                       ³ Data ³06.11.03   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Alteracao da Origem do Lancamento no CT2 para Mata331 e inclui³±±
±±³          ³filial.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Multitek                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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