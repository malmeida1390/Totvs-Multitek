#include "rwmake.ch"
#include "protheus.ch"
/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � F470ALLF � Autor � Edelcio Cano            � Data � 14/10/2016 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Permite a visualizacao do Extrato Bancario de forma Compartilhada���
���          � tendo o sa6 compartilhado                                      ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Multitek                                                       ���
�����������������������������������������������������������������������������Ĵ��
���             ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL              ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
��������������������������������������������������������������������������������� 
http://tdn.totvs.com/pages/releaseview.action?pageId=6071573
Quando lAllFil chegar no RdMake com valor ".T." significa que o sistema identificou o
uso de 'SA6 exclusivo' e 'SE5 compartilhado' e ir� processar a query sem considerar o
campo filial. Quando lAllFil chegar no Rdmake com valor ".F." significa que o sistema
identificou que n�o est� sendo usada a configura��o 'SA6 exclusivo' e 'SE5 compartilhado'
e ir� processar a query considerando o campo filial do SE5.  Quando lAllFil chegar 
RdMake com valor ".T." significa que o sistema identificou o uso de 'SA6 exclusivo' e 'SE5 compartilhado'
e ir� processar a query sem considerar o campo filial. Quando lAllFil chegar no Rdmake com valor ".F."
significa que o sistema identificou que n�o est� sendo usada a configura��o 'SA6 exclusivo' e 'SE5 
compartilhado' e ir� processar a query considerando o campo filial do SE5. 
*/
User Function F470ALLF() 

Local lAllfil := ParamIxb[1] 

If !lAllfil         
   Aviso("ATENCAO", "Consolidar movimentos da conta corrente de todas as filiais",{"&Ok"})
   lAllfil := .T.
Endif 

Return lAllfil 


