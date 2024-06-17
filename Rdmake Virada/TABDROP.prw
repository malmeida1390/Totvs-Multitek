#include "rwmake.ch"
#include "topconn.ch"


USER FUNCTION TABDROP
          
   IF MsgBox( "O programa ira efetuar o drop em todas as tabelas." + chr(13) + chr(10) + "É recomendável que seja feito um backup!" + chr(13) + chr(10) + "Deseja continuar?", "Limpar", "YESNO" )
      // Abre o SX2 para ler o
      DbSelectArea( "SX2" )
      SX2->( DbGoTop() )
      WHILE SX2->( !Eof() )
         TCSQLExec( "DROP TABLE " + SX2->X2_ARQUIVO )

         SX2->( DbSkip() )
      ENDDO

      MsgBox( "Concluído!", "Cleaner", "INFO" )
   ENDIF

   MS_FLUSH()

RETURN

