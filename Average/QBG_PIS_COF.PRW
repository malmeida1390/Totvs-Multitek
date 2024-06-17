//------------------------------------------------------------------------------------//
//Empresa...: AVERAGE TECNOLOGIA
//Funcao....: U_PIS_COF()
//Autor.....: Leandro Delfino Rodrigues (LDR)
//Data......: 23 de Abril de 2004, 16:50
//Uso.......: SIGAEIC   
//Versao....: Protheus - 6.09    
//Descricao.: Carga Pis e Cofins.
//------------------------------------------------------------------------------------//
#INCLUDE "Rwmake.ch"

*-------------------------------*
USER FUNCTION PIS_COF()
*-------------------------------*
LOCAL bOk:={||(nOpcao:=1,oDlg:End())}
LOCAL bCancel:={||(lLoop:=.F.,oDlg:End())}
LOCAL oDLG
LOCAL nOpcao:=0
PRIVATE lApend:=.T.,lAtu_Base:=.F.,lLOOP:=.T.

DO WHILE lLoop

   DEFINE MSDIALOG oDlg TITLE "PIS, Cofins"  From 8,5 To 18,50 OF oMainWnd 

   NOPCAO:=0
   @ 030,010 CHECKBOX "Criaçao das novas despesas (204-Pis / 205-Cofins)"  VAR lApend 
   @ 040,010 CHECKBOX "Atualizacao das Aliquotas de (Pis / Cofins)"        VAR lAtu_Base
   
   Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) CENTERED  

   IF nOpcao == 1
      IF !lApend .AND. !lAtu_Base
         MSGINFO("Selecione uma opcao!")
         LOOP
      ENDIF
      PROCESSA({|| U_GRV_SYD()})
   ENDIF

ENDDO
   
Return .T.
*-------------------------------*
USER FUNCTION GRV_SYD()
*-------------------------------*
LOCAL nCont := 0,nPIS := 1.65,nCOF := 7.6
LOCAL cTEC, oDLG, lMen:=.T.,  lMenSYB:=.T.
LOCAL bOk:={||(nOpcao:=1,oDlg:End())}
LOCAL bCancel:={||oDlg:End()}
LOCAL nOpcao:=0
LOCAL oFont:=TFont():New( "Courier New", 10, 0 )
LOCAL cMENSAGEM :=""

lLoop:=.F.


cMensagem:= "IMPORTANTE: Este programa irá atualizar as alíquotas do cadastro NCM de PIS e COFINS. Observe que as NCM's podem ter alíquotas distintas em função de algumas variáveis.";
           +"Certifique-se que as alíquotas carregadas -  automaticamente - atendem o seu ramo de atuação.";
           +"A AVERAGE não se responsabiliza pela carga das alíquotas que serão carregadas pelo programa padrão."

IF SYD->(FIELDPOS("YD_PER_PIS")) # 0 .AND. SYD->(FIELDPOS("YD_PER_COF")) # 0

   IF lAtu_Base

      DEFINE MSDIALOG oDlg TITLE "ATENÇÃO : PIS / Cofins"  From 8,5 To 25,62 OF oMainWnd 

      @ 015,010 GET cMENSAGEM MEMO SIZE 203,80

      @ 0100,010 BUTTON "OK"      SIZE 60,15 ACTION(EVAL(bOK))      
      @ 0100,090 BUTTON "Cancela" SIZE 60,15 ACTION(EVAL(bCancel))  
       
      Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) CENTERED  

      IF nOPCAO == 1
      
         ProcRegua(SYD->(LASTREC()))
         SYD->(DBGOTOP())
         DO WHILE SYD->(!EOF())
            cTEC := LEFT(SYD->YD_TEC,4)
            cTec8:= ALLTRIM(SYD->YD_TEC)
            nPIS := 1.65
            nCOF := 7.6

            IncProc("Atualizando: "+SYD->YD_TEC) 

            IF cTEC == "3001" .OR. ;
               (cTEC == "3003" .AND. cTec8  <> "30039056") .OR. ;
               (cTEC == "3004" .AND. cTec8  <> "30049046") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3002101") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3002102") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3002103") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3002201") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3002202") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3006301") .OR. ;
               (LEFT(SYD->YD_TEC,7) == "3006302") .OR. ;        
               (cTec8 == "30029020") .OR. ;                
               (cTec8 == "30029092") .OR. ;                
               (cTec8 == "30029099") .OR. ;                
               (cTec8 == "30051010") .OR. ;                
               (cTec8 == "30066000")
        
              nPIS := 2.1
              nCOF := 9.9        

           ELSEIF SUBSTR(cTEC,1,2) == "29" .OR. SUBSTR(cTEC,1,2) == "30"

              nPIS := 0
              nCOF := 0        
           
           ELSEIF  (cTec8 >= "330300" .AND. cTEC <= "3307") .OR. ;
                   (cTec8 == "34011190") .OR. ;                
                   (cTec8 == "34012010") .OR. ;                
                   (cTec8 == "96032100")
                                            	
               nPIS := 2.2
               nCOF := 10.3        
        
            ELSEIF cTEC == "8429" .OR. ;      
               (cTec8 == "84324000") .OR. ;
               (cTec8 == "84328000") .OR. ;
               (LEFT(SYD->YD_TEC,6) == "843320") .OR. ;
               (cTec8 == "84333000") .OR. ;
               (cTec8 == "84334000") .OR. ;
               (LEFT(SYD->YD_TEC,5) == "84335") .OR. ;
               cTEC == "8701" .OR. ;      
               cTEC == "8702" .OR. ;      
               cTEC == "8703" .OR. ;      
               cTEC == "8704" .OR. ;      
               cTEC == "8705" .OR. ;      
               cTEC == "8706" .OR. ;
               cTEC8 == "84261100" .OR. cTEC8 == "84261900" .OR. ;
               cTEC8 == "84262000" .OR. cTEC8 == "84263000" .OR. ;
               cTEC8 == "84269900" .OR. cTEC8 == "84271019" .OR. ;
               cTEC8 == "84271090" .OR. cTEC8 == "84272090" .OR. ;    
               cTEC8 == "84279000" .OR. cTEC8 == "84281000" .OR. ;
               cTEC8 == "84292090" .OR. cTEC8 == "84282090" .OR. ;
               cTEC8 == "84283300" .OR. cTEC8 == "84283990" .OR. ; 
               cTEC8 == "84284000" .OR. cTEC8 == "84285000" .OR. ;
               cTEC8 == "84289090"

               nPIS := 2.00
               nCOF := 9.6

            ELSEIF cTEC == "4011" .OR. ;
                   cTEC == "4013"

               nPIS := 2.00
               nCOF := 9.5
            ELSEIF cTEC8 == "22021000"

               nPIS := 2.00
               nCOF := 1.90

            ELSEIF cTEC8 == "27101911"

               nPIS := 1.25
               nCOF := 5.80
   
            ELSEIF cTEC8 == "27111910" .OR. CTEC8 == "27111990"

               nPIS := 2.56
               nCOF := 11.84

            ELSEIF cTEC8 == "76129019" .OR. cTEC8 == "39233000"

               nPIS := 2.20
               nCOF := 11.90
         
            ELSEIF cTEC8 == "27101130" .OR. cTEC8 == "38249029" .OR.;
                   cTEC8 == "27101151" .OR. cTEC8 == "38249031" .OR.; 
                   cTEC8 == "27101159" .OR. cTEC8 == "38249032" .OR.;
                   cTEC8 == "27101919" .OR. cTEC8 == "38249033" .OR.;
                   cTEC8 == "27101922" .OR. cTEC8 == "38249039" .OR.;
                   cTEC8 == "27101929" .OR. cTEC8 == "38249041" .OR.;
                   cTEC8 == "27101931" .OR. cTEC8 == "38249049" .OR.;
                   cTEC8 == "27101932" .OR. cTEC8 == "38249079" .OR.;
                   cTEC8 == "27101991" .OR. cTEC8 == "38249089" .OR.;
                   cTEC8 == "27101992" .OR. cTEC8 == "38249090" .OR.;
                   cTEC8 == "27109900" .OR. cTEC8 == "68131010" .OR.;
                   cTEC8 == "27111290" .OR. cTEC8 == "68131090" 

               nPIS := 0
               nCOF := 0
     
            ELSEIF cTEC8 == "27112100" .OR. cTEC8 == "68139010" .OR.;
                   cTEC8 == "27112990" .OR. cTEC8 == "70071100" .OR.;
                   cTEC8 == "70072100" .OR. cTEC8 == "70091000" .OR.;
                   cTEC8 == "83012000" .OR.;
                   cTEC8 == "83023000" .OR. cTEC8 == "84073490" .OR.;
                   cTEC8 == "84082090" .OR. cTEC8 == "84099111" .OR.;
                   cTEC8 == "84099112" .OR. cTEC8 == "84099113" .OR.;
                   cTEC8 == "84099120" .OR. cTEC8 == "84099130" .OR.;
                   cTEC8 == "84099190" .OR. cTEC8 == "84099911" .OR.;
                   cTEC8 == "84099913" .OR. cTEC8 == "84099914" .OR.;
                   cTEC8 == "84099920" .OR. cTEC8 == "84099990" .OR.;
                   cTEC8 == "84133010" .OR. cTEC8 == "84133030" 

               nPIS := 0
               nCOF := 0

            ELSEIF cTEC8 == "84133090" .OR. cTEC8 == "84148021" .OR.;
                   cTEC8 == "84212300" .OR. cTEC8 == "84213100" .OR.;
                   cTEC8 == "84835010" .OR. cTEC8 == "84835090" .OR.;
                   cTEC8 == "85052010" .OR. cTEC8 == "85052090" .OR.;
                   cTEC8 == "85111000" .OR. cTEC8 == "85112010" .OR.;
                   cTEC8 == "85112090" .OR. cTEC8 == "85113010" .OR.;
                   cTEC8 == "85113020" .OR. cTEC8 == "85114000" .OR.;
                   cTEC8 == "85115010" .OR. cTEC8 == "85115090" .OR.;
                   cTEC8 == "85118020" .OR. cTEC8 == "85118030" .OR.;
                   cTEC8 == "85118090" .OR. cTEC8 == "85119000" .OR.;
                   cTEC8 == "85122011" .OR. cTEC8 == "85122019" .OR.;                                                              
                   cTEC8 == "85123000" .OR. cTEC8 == "85124010" .OR.;
                   cTEC8 == "85124020" .OR. cTEC8 == "85129000" .OR.;
                   cTEC8 == "85391010" .OR. cTEC8 == "85391090" .OR.;
                   cTEC8 == "87079090" .OR. cTEC8 == "87081000" .OR.;
                   cTEC8 == "87082911" .OR. cTEC8 == "87082999" 

               nPIS := 0
               nCOF := 0

            ELSEIF cTEC8 == "87083900" .OR. cTEC8 == "87086090" .OR.;
                   cTEC8 == "87087090" .OR. cTEC8 == "87088000" .OR.;
                   cTEC8 == "87089100" .OR. cTEC8 == "87089200" .OR.;
                   cTEC8 == "87089300" .OR. cTEC8 == "87089491" .OR.;
                   cTEC8 == "87089492" .OR. cTEC8 == "87089493" .OR.;
                   cTEC8 == "87089990" .OR. cTEC8 == "90292010" .OR.;
                   cTEC8 == "90299010" .OR. cTEC8 == "94012000" .OR.;
                   cTEC8 == "91040000" .OR. cTEC8 == "94012000" .OR.;
                   cTEC8 == "97011000" .OR. cTEC8 == "84831020" .OR.;
                   cTEC8 == "84831030" .OR. cTEC8 == "84831040" .OR.;
                   cTEC8 == "84831090" .OR. cTEC8 == "84832000" .OR.;
                   cTEC8 == "84833020" .OR. cTEC8 == "84833090" .OR.;
                   cTEC8 == "85443000" 

               nPIS := 0
               nCOF := 0
            ENDIF

            SYD->(RECLOCK("SYD",.F.))
            SYD->YD_PER_PIS := nPIS
            SYD->YD_PER_COF := nCOF
            SYD->(MSUNLOCK("SYD",.F.))

            SYD->(DBSKIP())
         ENDDO
      ELSE
         lMen:=.F.
      ENDIF
   ENDIF

   SYB->(DBSETORDER(1))

   ProcRegua(2)

   IF !SYB->(DBSEEK(xFILIAL("SYB")+"204"))
      IncProc("Atualizando... ") 
      RECLOCK("SYB",.T.)
      SYB->YB_FILIAL  := xFilial("SYB")
      SYB->YB_DESP    := "204"
      SYB->YB_DESCR   := "PIS"
      SYB->YB_IDVL    := "2"
      SYB->YB_PERCAPL := 1.65
      SYB->YB_DESPBAS := "104201203"
      SYB->YB_BASECUS := "2"
      IF SYB->(FIELDPOS("YB_BASEICM")) # 0
         SYB->YB_BASEICM := "2"                      
      ENDIF
      IF SYB->(FIELDPOS("YB_BASEIMP")) # 0
         SYB->YB_BASEIMP := "2"
      ENDIF
      SYB->(MSUNLOCK())
   ELSE 
      lMENSYB:=.F.
   ENDIF

   IF !SYB->(DBSEEK(xFILIAL("SYB")+"205"))   
      IncProc("Atualizando... ") 
      RECLOCK("SYB",.T.)
      SYB->YB_FILIAL  := xFilial("SYB")
      SYB->YB_DESP    := "205"
      SYB->YB_DESCR   := "COFINS"
      SYB->YB_IDVL    := "2"
      SYB->YB_PERCAPL := 7.6
      SYB->YB_DESPBAS := "104201203"
      SYB->YB_BASECUS := "2"
      IF SYB->(FIELDPOS("YB_BASEICM")) # 0
         SYB->YB_BASEICM := "2"                      
      ENDIF
      IF SYB->(FIELDPOS("YB_BASEIMP")) # 0
         SYB->YB_BASEIMP := "2"                            
      ENDIF
      SYB->(MSUNLOCK())
   ELSE 
      lMENSYB:=.F.   
   ENDIF
  
ENDIF
             
IF !lMenSYB .AND. lApend
   MSGINFO("Despesa(s) já estava(m) cadastrada(s)!")
ENDIF             
IF lMen .AND. lMENSYB
   MSGINFO("Atualizado com Sucesso !")
ENDIF

Return .T.