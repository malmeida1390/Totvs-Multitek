/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���P.E       �MSE3440   �Autor  �Flavio Correa       � Data �  191212     ���
�������������������������������������������������������������������������͹��
���Desc.     �O calculo da porcentagem na devolu;�o esta fazendo errado,  ���
���          �ent�o nesse ponto fazemos a correcao						  ���
�������������������������������������������������������������������������͹��
���Uso       � Multi-Tek                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                
User function MSE3440()
Local aArea  :=GetArea()
Local nPerc  :=0 

If SE3->E3_ORIGEM='B' .AND. SE3->E3_COMIS > 0  
       
    If SE1->E1_VEND1 = SE3->E3_VEND       
       nPerc  := SE1->E1_COMIS1
    Elseif SE1->E1_VEND2 = SE3->E3_VEND       
       nPerc  := SE1->E1_COMIS2
    Elseif SE1->E1_VEND3 = SE3->E3_VEND       
       nPerc  := SE1->E1_COMIS3
    Elseif SE1->E1_VEND4 = SE3->E3_VEND       
      nPerc  := SE1->E1_COMIS4
    Elseif SE1->E1_VEND5 = SE3->E3_VEND       
      nPerc  := SE1->E1_COMIS5
    Endif
      
    If SE3->E3_PORC <> nPerc
       SE3->E3_XCOMBK := SE3->E3_PORC // Percentual antes da alteracao.
       SE3->E3_XVLRBK := SE3->E3_COMIS
       SE3->E3_PORC   := nPerc
  	   SE3->E3_COMIS  := NoRound(NoRound(SE3->E3_BASE * (nPerc/100) ,3),2)
    Endif

Endif

If SE3->E3_COMIS < 0   //altera somente nas devolucoes
    SE3->E3_PORC :=  Abs(Round(SE3->E3_COMIS/SE3->E3_BASE,4)*100)
Endif

RestArea(aArea)

return .T.       

